Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F99A70
	for <nvdimm@lists.linux.dev>; Thu,  3 Jun 2021 01:36:11 +0000 (UTC)
IronPort-SDR: kr6Vd6mt9XhIKhyQyAafhFoDMTucjL4n4GA8FhP7U0hlsehiYu1eZhbuZUIEXHR0QbvoHoa2EW
 +FhkqGf4li9w==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="202082616"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="202082616"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 18:36:09 -0700
IronPort-SDR: zLNTuaj+YtknhRv1sGNp45S+JT3aoHgEi3Af9Rrbl9hjQq6BUC652UdaRfjQretyHu/23sSkXw
 EMRiFm9vsdnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="483266081"
Received: from icx-hcc-jingqi.sh.intel.com ([10.239.48.31])
  by fmsmga002.fm.intel.com with ESMTP; 02 Jun 2021 18:36:08 -0700
From: Jingqi Liu <jingqi.liu@intel.com>
To: dan.j.williams@intel.com,
	nvdimm@lists.linux.dev
Cc: Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH] ndctl/dimm: Fix to dump namespace indexs and labels
Date: Thu,  3 Jun 2021 09:25:56 +0800
Message-Id: <20210603012556.77451-1-jingqi.liu@intel.com>
X-Mailer: git-send-email 2.21.3
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following bug is caused by setting the size of Label Index Block
to a fixed 256 bytes.

Use the following Qemu command to start a Guest with 2MB label-size:
	-object memory-backend-file,id=mem1,share=on,mem-path=/dev/dax1.1,size=14G,align=2M
	-device nvdimm,memdev=mem1,id=nv1,label-size=2M

There is a namespace in the Guest as follows:
	$ ndctl list
	[
	  {
	    "dev":"namespace0.0",
	    "mode":"devdax",
	    "map":"dev",
	    "size":14780727296,
	    "uuid":"58ad5282-5a16-404f-b8ee-e28b4c784eb8",
	    "chardev":"dax0.0",
	    "align":2097152,
	    "name":"namespace0.0"
	  }
	]

Fail to read labels. The result is as follows:
	$ ndctl read-labels -u nmem0
	[
	]
	read 0 nmem

If using the following Qemu command to start the Guest with 128K
label-size, this label can be read correctly.
	-object memory-backend-file,id=mem1,share=on,mem-path=/dev/dax1.1,size=14G,align=2M
	-device nvdimm,memdev=mem1,id=nv1,label-size=128K

The size of a Label Index Block depends on how many label slots fit into
the label storage area. The minimum size of an index block is 256 bytes
and the size must be a multiple of 256 bytes. For a storage area of 128KB,
the corresponding Label Index Block size is 256 bytes. But if the label
storage area is not 128KB, the Label Index Block size should not be 256 bytes.

Namespace Label Index Block appears twice at the top of the label storage area.
Following the two index blocks, an array for storing labels takes up the
remainder of the label storage area.

When reading namespace index and labels, we should read the field of 'mysize'
in the Label Index Block. Then we can correctly calculate the starting offset
of another Label Index Block and the following namespace labels.

Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
---
 ndctl/dimm.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 09ce49e..e05dcc2 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -94,13 +94,25 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
 	struct json_object *jarray = json_object_new_array();
 	struct json_object *jlabel = NULL;
 	struct namespace_label nslabel;
+	struct namespace_index nsindex;
+	ssize_t nsindex_len = min_t(ssize_t, sizeof(nsindex), size);
+	ssize_t nsindex_mysize;
 	unsigned int slot = -1;
 	ssize_t offset;
 
 	if (!jarray)
 		return NULL;
 
-	for (offset = NSINDEX_ALIGN * 2; offset < size;
+	nsindex_len = ndctl_cmd_cfg_read_get_data(cmd_read, &nsindex, nsindex_len, 0);
+	if (nsindex_len < 0)
+		return NULL;
+
+	nsindex_mysize = le64_to_cpu(nsindex.mysize);
+	if ((nsindex_mysize > size)
+			|| !IS_ALIGNED(nsindex_mysize, NSINDEX_ALIGN))
+		return NULL;
+
+	for (offset = nsindex_mysize * 2; offset < size;
 			offset += ndctl_dimm_sizeof_namespace_label(dimm)) {
 		ssize_t len = min_t(ssize_t,
 				ndctl_dimm_sizeof_namespace_label(dimm),
@@ -210,13 +222,15 @@ static struct json_object *dump_index_json(struct ndctl_cmd *cmd_read, ssize_t s
 	struct json_object *jindex = NULL;
 	struct namespace_index nsindex;
 	ssize_t offset;
+	int i;
 
 	if (!jarray)
 		return NULL;
 
-	for (offset = 0; offset < NSINDEX_ALIGN * 2; offset += NSINDEX_ALIGN) {
+	for (i = 0, offset = 0; i < 2 ; i++) {
 		ssize_t len = min_t(ssize_t, sizeof(nsindex), size - offset);
 		struct json_object *jobj;
+		ssize_t nsindex_mysize;
 
 		jindex = json_object_new_object();
 		if (!jindex)
@@ -229,6 +243,11 @@ static struct json_object *dump_index_json(struct ndctl_cmd *cmd_read, ssize_t s
 		if (len < 0)
 			break;
 
+		nsindex_mysize = le64_to_cpu(nsindex.mysize);
+		if ((nsindex_mysize > size)
+				|| !IS_ALIGNED(nsindex_mysize, NSINDEX_ALIGN))
+			break;
+
 		nsindex.sig[NSINDEX_SIG_LEN - 1] = 0;
 		jobj = json_object_new_string(nsindex.sig);
 		if (!jobj)
@@ -261,6 +280,8 @@ static struct json_object *dump_index_json(struct ndctl_cmd *cmd_read, ssize_t s
 		json_object_object_add(jindex, "nslot", jobj);
 
 		json_object_array_add(jarray, jindex);
+
+		offset += nsindex_mysize;
 	}
 
 	if (json_object_array_length(jarray) < 1) {
-- 
2.21.3

