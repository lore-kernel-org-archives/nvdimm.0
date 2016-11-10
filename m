Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7BBD781C8A
 for <linux-nvdimm@lists.01.org>; Wed,  9 Nov 2016 17:31:13 -0800 (PST)
Subject: [PATCH 1/2] libndctl: add ndctl_pfn_has_align() api
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 09 Nov 2016 17:28:15 -0800
Message-ID: <147874129531.37588.12721076898149272280.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In support of preventing create-namespace attempts to write the 'align'
attribute on kernels that do not have the capability, add this detection
api.

We would not have needed this if ndctl_pfn_get_align() returned -ENOENT
instead of zero, live and learn.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c   |   16 ++++++++++++++++
 ndctl/lib/libndctl.sym |    1 +
 ndctl/libndctl.h.in    |    1 +
 3 files changed, 18 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 82b11a0d3ac9..eed418936a38 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -4231,6 +4231,22 @@ NDCTL_EXPORT unsigned long ndctl_pfn_get_align(struct ndctl_pfn *pfn)
 	return pfn->align;
 }
 
+NDCTL_EXPORT int ndctl_pfn_has_align(struct ndctl_pfn *pfn)
+{
+	struct ndctl_ctx *ctx = ndctl_pfn_get_ctx(pfn);
+	char *path = pfn->pfn_buf;
+	int len = pfn->buf_len;
+	struct stat st;
+
+	if (snprintf(path, len, "%s/align", pfn->pfn_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				ndctl_pfn_get_devname(pfn));
+		return 0;
+	}
+
+	return stat(path, &st) == 0;
+}
+
 NDCTL_EXPORT int ndctl_pfn_set_align(struct ndctl_pfn *pfn, unsigned long align)
 {
 	struct ndctl_ctx *ctx = ndctl_pfn_get_ctx(pfn);
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 6bd032ea7526..603c386cc2a1 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -231,6 +231,7 @@ global:
 	ndctl_pfn_get_align;
 	ndctl_pfn_get_size;
 	ndctl_pfn_get_resource;
+	ndctl_pfn_has_align;
 	ndctl_pfn_set_align;
 	ndctl_pfn_set_namespace;
 	ndctl_pfn_get_bus;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index d3379f76e1f9..9d7219894ed7 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -566,6 +566,7 @@ int ndctl_pfn_set_location(struct ndctl_pfn *pfn, enum ndctl_pfn_loc loc);
 enum ndctl_pfn_loc ndctl_pfn_get_location(struct ndctl_pfn *pfn);
 int ndctl_pfn_set_uuid(struct ndctl_pfn *pfn, uuid_t uu);
 void ndctl_pfn_get_uuid(struct ndctl_pfn *pfn, uuid_t uu);
+int ndctl_pfn_has_align(struct ndctl_pfn *pfn);
 int ndctl_pfn_set_align(struct ndctl_pfn *pfn, unsigned long align);
 unsigned long ndctl_pfn_get_align(struct ndctl_pfn *pfn);
 unsigned long long ndctl_pfn_get_resource(struct ndctl_pfn *pfn);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
