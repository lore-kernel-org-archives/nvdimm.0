Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x243.google.com (mail-pf0-x243.google.com
 [IPv6:2607:f8b0:400e:c00::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 52FA421951C94
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 02:15:09 -0700 (PDT)
Received: by mail-pf0-x243.google.com with SMTP id g23so8060169pfj.1
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 02:15:09 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 2/4] ndctl: Parse supported_alignments for dax and pfn devices
Date: Thu, 27 Apr 2017 19:14:52 +1000
Message-Id: <20170427091454.17412-2-oohall@gmail.com>
In-Reply-To: <20170427091454.17412-1-oohall@gmail.com>
References: <20170427091454.17412-1-oohall@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Newer kernels advertise the list of alignments that they support
through sysfs. This patch adds parsing inside of libndctl to
determine the alignments permitted.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 ndctl/lib/libndctl.c   | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |  4 ++++
 ndctl/libndctl.h.in    |  4 ++++
 3 files changed, 61 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 25a1e6d20d10..f9bc4ee72bb8 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -34,6 +34,7 @@
 #include <ndctl.h>
 #endif
 
+#include <util/size.h>
 #include <util/sysfs.h>
 #include <ndctl/libndctl.h>
 #include <daxctl/libdaxctl.h>
@@ -323,6 +324,8 @@ struct ndctl_pfn {
 	int buf_len;
 	uuid_t uuid;
 	int id, generation;
+	struct ndctl_sizes alignments;
+	unsigned long default_align;
 };
 
 struct ndctl_dax {
@@ -4025,6 +4028,29 @@ static void *__add_pfn(struct ndctl_pfn *pfn, const char *pfn_base)
 	else
 		pfn->size = strtoull(buf, NULL, 0);
 
+	/*
+	 * Newer kernels explicitly state what they support with the
+	 * supported_alignments attribuate and older kernels only
+	 * support 4K, 2M or 1G alignments.
+	 */
+	sprintf(path, "%s/supported_alignments", pfn_base);
+	if (!sysfs_read_attr(ctx, path, buf)) {
+		if (parse_sizes(ctx, devpath_to_devname(pfn_base),
+				buf, &pfn->alignments)) {
+			goto err_read;
+		}
+
+		sprintf(path, "%s/default_alignment", pfn_base);
+		if (sysfs_read_attr(ctx, path, buf) < 0)
+			goto err_read;
+
+		pfn->default_align = strtoull(buf, NULL, 0);
+	} else {
+		pfn->alignments.supported =
+			(unsigned int []) {SZ_4K, SZ_2M, SZ_1G};
+		pfn->default_align = SZ_2M;
+	}
+
 	free(path);
 	return pfn;
 
@@ -4256,6 +4282,22 @@ NDCTL_EXPORT int ndctl_pfn_set_align(struct ndctl_pfn *pfn, unsigned long align)
 	return 0;
 }
 
+NDCTL_EXPORT unsigned long ndctl_pfn_def_align(struct ndctl_pfn *pfn)
+{
+	return pfn->default_align;
+}
+
+NDCTL_EXPORT int ndctl_pfn_supports_align(struct ndctl_pfn *pfn,
+		unsigned long align)
+{
+	int i;
+
+	for (i = 0; i < pfn->alignments.num; i++)
+		if (pfn->alignments.supported[i] == align)
+			return true;
+	return false;
+}
+
 NDCTL_EXPORT int ndctl_pfn_set_namespace(struct ndctl_pfn *pfn,
 		struct ndctl_namespace *ndns)
 {
@@ -4482,6 +4524,17 @@ NDCTL_EXPORT int ndctl_dax_has_align(struct ndctl_dax *dax)
 	return ndctl_pfn_has_align(&dax->pfn);
 }
 
+NDCTL_EXPORT unsigned long ndctl_dax_def_align(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_def_align(&dax->pfn);
+}
+
+NDCTL_EXPORT int ndctl_dax_supports_align(struct ndctl_dax *dax,
+		unsigned long align)
+{
+	return ndctl_pfn_supports_align(&dax->pfn, align);
+}
+
 NDCTL_EXPORT int ndctl_dax_set_align(struct ndctl_dax *dax, unsigned long align)
 {
 	return ndctl_pfn_set_align(&dax->pfn, align);
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index be2e3680d202..fa60dfb82a9e 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -231,6 +231,8 @@ global:
 	ndctl_pfn_get_location;
 	ndctl_pfn_set_location;
 	ndctl_pfn_get_align;
+	ndctl_pfn_def_align;
+	ndctl_pfn_supports_align;
 	ndctl_pfn_get_size;
 	ndctl_pfn_get_resource;
 	ndctl_pfn_has_align;
@@ -259,6 +261,8 @@ global:
 	ndctl_dax_get_location;
 	ndctl_dax_set_location;
 	ndctl_dax_get_align;
+	ndctl_dax_def_align;
+	ndctl_dax_supports_align;
 	ndctl_dax_has_align;
 	ndctl_dax_set_align;
 	ndctl_dax_set_namespace;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index c27581d939c5..be0e20b706fa 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -572,6 +572,8 @@ void ndctl_pfn_get_uuid(struct ndctl_pfn *pfn, uuid_t uu);
 int ndctl_pfn_has_align(struct ndctl_pfn *pfn);
 int ndctl_pfn_set_align(struct ndctl_pfn *pfn, unsigned long align);
 unsigned long ndctl_pfn_get_align(struct ndctl_pfn *pfn);
+unsigned long ndctl_pfn_def_align(struct ndctl_pfn *pfn);
+int ndctl_pfn_supports_align(struct ndctl_pfn *pfn, unsigned long align);
 unsigned long long ndctl_pfn_get_resource(struct ndctl_pfn *pfn);
 unsigned long long ndctl_pfn_get_size(struct ndctl_pfn *pfn);
 int ndctl_pfn_set_namespace(struct ndctl_pfn *pfn, struct ndctl_namespace *ndns);
@@ -603,6 +605,8 @@ int ndctl_dax_set_uuid(struct ndctl_dax *dax, uuid_t uu);
 enum ndctl_pfn_loc ndctl_dax_get_location(struct ndctl_dax *dax);
 int ndctl_dax_set_location(struct ndctl_dax *dax, enum ndctl_pfn_loc loc);
 unsigned long ndctl_dax_get_align(struct ndctl_dax *dax);
+unsigned long ndctl_dax_def_align(struct ndctl_dax *dax);
+int ndctl_dax_supports_align(struct ndctl_dax *dax, unsigned long align);
 int ndctl_dax_has_align(struct ndctl_dax *dax);
 int ndctl_dax_set_align(struct ndctl_dax *dax, unsigned long align);
 int ndctl_dax_set_namespace(struct ndctl_dax *dax,
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
