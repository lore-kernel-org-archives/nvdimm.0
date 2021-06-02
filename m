Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5829B70
	for <nvdimm@lists.linux.dev>; Wed,  2 Jun 2021 12:28:50 +0000 (UTC)
IronPort-SDR: 96nmgKzlZtdSZeXaJwh+z553VWG/n3qRenoppVSaTgta8IDRtXZlr3rVkyQpHGoBQVLodrOlc9
 zplvkJn0hc1A==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="203587091"
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="203587091"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 05:28:49 -0700
IronPort-SDR: 7ZjeHQ8TFwnSLQ+HYcpou62waENhZCHA3U/6e88uwEGUwF/h2jOMFBBRWvgb6DXhMURqQcSUUN
 EQDN8POCmZjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="479690617"
Received: from icx-hcc-jingqi.sh.intel.com ([10.239.48.31])
  by orsmga001.jf.intel.com with ESMTP; 02 Jun 2021 05:28:47 -0700
From: Jingqi Liu <jingqi.liu@intel.com>
To: dan.j.williams@intel.com,
	nvdimm@lists.linux.dev
Cc: Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH] ndctl/dimm: Fix to dump namespace indexs and labels
Date: Wed,  2 Jun 2021 20:18:40 +0800
Message-Id: <20210602121840.72324-1-jingqi.liu@intel.com>
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

