Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37CC168
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 08:25:50 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="189146875"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="189146875"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 01:25:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="498347439"
Received: from icx-hcc-jingqi.sh.intel.com ([10.239.48.31])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jul 2021 01:25:48 -0700
From: Jingqi Liu <jingqi.liu@intel.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev,
	Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH v3] ndctl/dimm: Fix to dump namespace indexs and labels
Date: Thu,  8 Jul 2021 16:14:46 +0800
Message-Id: <20210708081446.14323-1-jingqi.liu@intel.com>
X-Mailer: git-send-email 2.21.3
Precedence: bulk
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

For obtaining the size of Namespace Index Block, we also cannot rely on
the field of 'mysize' in this index block since it might be corrupted.
Similar to the linux kernel, we use sizeof_namespace_index() to get the size
of Namespace Index Block. Then we can also correctly calculate the starting
offset of the following namespace labels.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
---
 ndctl/dimm.c           | 19 +++++++++++++++----
 ndctl/lib/dimm.c       |  5 +++++
 ndctl/lib/libndctl.sym |  4 ++++
 ndctl/libndctl.h       |  1 +
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 09ce49e..1d2d9a2 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -94,13 +94,18 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
 	struct json_object *jarray = json_object_new_array();
 	struct json_object *jlabel = NULL;
 	struct namespace_label nslabel;
+	unsigned int nsindex_size;
 	unsigned int slot = -1;
 	ssize_t offset;
 
 	if (!jarray)
 		return NULL;
 
-	for (offset = NSINDEX_ALIGN * 2; offset < size;
+	nsindex_size = ndctl_dimm_sizeof_namespace_index(dimm);
+	if (nsindex_size == 0)
+		return NULL;
+
+	for (offset = nsindex_size * 2; offset < size;
 			offset += ndctl_dimm_sizeof_namespace_label(dimm)) {
 		ssize_t len = min_t(ssize_t,
 				ndctl_dimm_sizeof_namespace_label(dimm),
@@ -204,17 +209,23 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
 	return jarray;
 }
 
-static struct json_object *dump_index_json(struct ndctl_cmd *cmd_read, ssize_t size)
+static struct json_object *dump_index_json(struct ndctl_dimm *dimm,
+		struct ndctl_cmd *cmd_read, ssize_t size)
 {
 	struct json_object *jarray = json_object_new_array();
 	struct json_object *jindex = NULL;
 	struct namespace_index nsindex;
+	unsigned int nsindex_size;
 	ssize_t offset;
 
 	if (!jarray)
 		return NULL;
 
-	for (offset = 0; offset < NSINDEX_ALIGN * 2; offset += NSINDEX_ALIGN) {
+	nsindex_size = ndctl_dimm_sizeof_namespace_index(dimm);
+	if (nsindex_size == 0)
+		return NULL;
+
+	for (offset = 0; offset < nsindex_size * 2; offset += nsindex_size) {
 		ssize_t len = min_t(ssize_t, sizeof(nsindex), size - offset);
 		struct json_object *jobj;
 
@@ -288,7 +299,7 @@ static struct json_object *dump_json(struct ndctl_dimm *dimm,
 		goto err;
 	json_object_object_add(jdimm, "dev", jobj);
 
-	jindex = dump_index_json(cmd_read, size);
+	jindex = dump_index_json(dimm, cmd_read, size);
 	if (!jindex)
 		goto err;
 	json_object_object_add(jdimm, "index", jindex);
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index c045cbe..9e36e28 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -256,6 +256,11 @@ static int __label_validate(struct nvdimm_data *ndd)
 	return -EINVAL;
 }
 
+NDCTL_EXPORT unsigned int ndctl_dimm_sizeof_namespace_index(struct ndctl_dimm *dimm)
+{
+	return sizeof_namespace_index(&dimm->ndd);
+}
+
 /*
  * If the dimm labels have not been previously validated this routine
  * will make up a default size. Otherwise, it will pick the size based
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 0a82616..38095b7 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -451,3 +451,7 @@ LIBNDCTL_25 {
 	ndctl_bus_clear_fw_activate_nosuspend;
 	ndctl_bus_activate_firmware;
 } LIBNDCTL_24;
+
+LIBNDCTL_26 {
+	ndctl_dimm_sizeof_namespace_index;
+} LIBNDCTL_25;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 60e1288..9a1a799 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -335,6 +335,7 @@ int ndctl_dimm_init_labels(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version v);
 unsigned long ndctl_dimm_get_available_labels(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_sizeof_namespace_label(struct ndctl_dimm *dimm);
+unsigned int ndctl_dimm_sizeof_namespace_index(struct ndctl_dimm *dimm);
 unsigned int ndctl_cmd_cfg_size_get_size(struct ndctl_cmd *cfg_size);
 ssize_t ndctl_cmd_cfg_read_get_data(struct ndctl_cmd *cfg_read, void *buf,
 		unsigned int len, unsigned int offset);
-- 
2.21.3

