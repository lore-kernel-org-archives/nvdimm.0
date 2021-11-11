Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE6F2CA5
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 20:44:59 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233253835"
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="233253835"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:55 -0800
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="504579081"
Received: from dmamols-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.255.92.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:55 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v5 10/16] libcxl: add representation for an nvdimm bridge object
Date: Thu, 11 Nov 2021 13:44:30 -0700
Message-Id: <20211111204436.1560365-11-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211111204436.1560365-1-vishal.l.verma@intel.com>
References: <20211111204436.1560365-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4988; h=from:subject; bh=JRQd6l8jnyOv819qFdcCc5JY8gUc4aagdEbwESrIVUE=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm9DZvUzsyImLZFsnzTBdsNxuoKfzIT5DadvhF0a8r/L5s2 /2Ce1lHKwiDGwSArpsjyd89HxmNy2/N5AhMcYeawMoEMYeDiFICJ8Jsy/Gbntl36bmXco13T12fWTP +5bupTFyV9P92EP0kbZjTG7fjLyLBWUCRnhbzztg+iyw9vndMSwqh82OppLt+33yfKLmZ9K+MDAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add an nvdimm bridge object representation internal to libcxl. A bridge
object is ited to its parent memdev object, and this patch adds its
first interface, which checks whether a bridge is 'active' - i.e.
implying the label space on the memdev is owned by the kernel.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  |  9 ++++++
 cxl/lib/libcxl.c   | 73 ++++++++++++++++++++++++++++++++++++++++++++++
 cxl/libcxl.h       |  1 +
 cxl/lib/libcxl.sym |  1 +
 4 files changed, 84 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index c4ed741..2f0b6ea 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -10,6 +10,14 @@
 
 #define CXL_EXPORT __attribute__ ((visibility("default")))
 
+
+struct cxl_nvdimm_br {
+	int id;
+	void *dev_buf;
+	size_t buf_len;
+	char *dev_path;
+};
+
 struct cxl_memdev {
 	int id, major, minor;
 	void *dev_buf;
@@ -23,6 +31,7 @@ struct cxl_memdev {
 	int payload_max;
 	size_t lsa_size;
 	struct kmod_module *module;
+	struct cxl_nvdimm_br *bridge;
 };
 
 enum cxl_cmd_query_status {
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index def3a97..7bc0696 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -45,11 +45,19 @@ struct cxl_ctx {
 	void *private_data;
 };
 
+static void free_bridge(struct cxl_nvdimm_br *bridge)
+{
+	free(bridge->dev_buf);
+	free(bridge->dev_path);
+	free(bridge);
+}
+
 static void free_memdev(struct cxl_memdev *memdev, struct list_head *head)
 {
 	if (head)
 		list_del_from(head, &memdev->list);
 	kmod_module_unref(memdev->module);
+	free_bridge(memdev->bridge);
 	free(memdev->firmware_version);
 	free(memdev->dev_buf);
 	free(memdev->dev_path);
@@ -205,6 +213,40 @@ CXL_EXPORT void cxl_set_log_priority(struct cxl_ctx *ctx, int priority)
 	ctx->ctx.log_priority = priority;
 }
 
+static void *add_cxl_bridge(void *parent, int id, const char *br_base)
+{
+	const char *devname = devpath_to_devname(br_base);
+	struct cxl_memdev *memdev = parent;
+	struct cxl_ctx *ctx = memdev->ctx;
+	struct cxl_nvdimm_br *bridge;
+
+	dbg(ctx, "%s: bridge_base: \'%s\'\n", devname, br_base);
+
+	bridge = calloc(1, sizeof(*bridge));
+	if (!bridge)
+		goto err_dev;
+	bridge->id = id;
+
+	bridge->dev_path = strdup(br_base);
+	if (!bridge->dev_path)
+		goto err_read;
+
+	bridge->dev_buf = calloc(1, strlen(br_base) + 50);
+	if (!bridge->dev_buf)
+		goto err_read;
+	bridge->buf_len = strlen(br_base) + 50;
+
+	memdev->bridge = bridge;
+	return bridge;
+
+ err_read:
+	free(bridge->dev_buf);
+	free(bridge->dev_path);
+	free(bridge);
+ err_dev:
+	return NULL;
+}
+
 static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 {
 	const char *devname = devpath_to_devname(cxlmem_base);
@@ -271,6 +313,8 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 		goto err_read;
 	memdev->buf_len = strlen(cxlmem_base) + 50;
 
+	sysfs_device_parse(ctx, cxlmem_base, "pmem", memdev, add_cxl_bridge);
+
 	cxl_memdev_foreach(ctx, memdev_dup)
 		if (memdev_dup->id == memdev->id) {
 			free_memdev(memdev, NULL);
@@ -362,6 +406,35 @@ CXL_EXPORT size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev)
 	return memdev->lsa_size;
 }
 
+static int is_enabled(const char *drvpath)
+{
+	struct stat st;
+
+	if (lstat(drvpath, &st) < 0 || !S_ISLNK(st.st_mode))
+		return 0;
+	else
+		return 1;
+}
+
+CXL_EXPORT int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev)
+{
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	struct cxl_nvdimm_br *bridge = memdev->bridge;
+	char *path = memdev->dev_buf;
+	int len = memdev->buf_len;
+
+	if (!bridge)
+		return 0;
+
+	if (snprintf(path, len, "%s/driver", bridge->dev_path) >= len) {
+		err(ctx, "%s: nvdimm bridge buffer too small!\n",
+				cxl_memdev_get_devname(memdev));
+		return 0;
+	}
+
+	return is_enabled(path);
+}
+
 CXL_EXPORT void cxl_cmd_unref(struct cxl_cmd *cmd)
 {
 	if (!cmd)
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index d3b97a1..535e349 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -43,6 +43,7 @@ unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
 size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
+int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev);
 
 #define cxl_memdev_foreach(ctx, memdev) \
         for (memdev = cxl_memdev_get_first(ctx); \
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 858e953..f3b0c63 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -65,6 +65,7 @@ global:
 	cxl_cmd_new_read_label;
 	cxl_cmd_read_label_get_payload;
 	cxl_memdev_get_label_size;
+	cxl_memdev_nvdimm_bridge_active;
 local:
         *;
 };
-- 
2.31.1

