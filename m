Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com
 [IPv6:2607:f8b0:4864:20::544])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 28662211B5A34
 for <linux-nvdimm@lists.01.org>; Tue, 29 Jan 2019 06:49:13 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id c25so8837591pgb.4
 for <linux-nvdimm@lists.01.org>; Tue, 29 Jan 2019 06:49:13 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH v4 1/5] libndctl: Use the supported_alignment attribute
Date: Wed, 30 Jan 2019 01:48:53 +1100
Message-Id: <20190129144857.6741-1-oohall@gmail.com>
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

Newer kernels provide the "supported_alignments" sysfs attribute that
indicates what alignments can be used with a PFN or DAX namespace. This
patch adds the plumbing inside of libndctl to allow users to query this
information through using:
	ndctl_{dax|pfn}_get_supported_alignment(), and
	ndctl_{dax|pfn}_get_num_alignments()

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
v4: Changed return code of ndctl_pfn_get_supported_alignment from -1 to
    -1 to -EINVAL.

    Reworded comment about why we default to 4K and 2M alignments when
    the sysfs attribute is missing.

    Shuffled around prototypes in ndctl.h.

    80 char compliance fixes.

    rebased onto pending branch

v3: Changed the return type of the *_get_supported_alignment() functions
    to unsigned long to match the existing *_get_alignment() functions.
---
 ndctl/lib/libndctl.c   | 44 ++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |  4 ++++
 ndctl/libndctl.h       |  4 ++++
 3 files changed, 52 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 830b791339d2..64cd2996bbd9 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -31,6 +31,7 @@
 #include <ccan/build_assert/build_assert.h>
 
 #include <ndctl.h>
+#include <util/size.h>
 #include <util/sysfs.h>
 #include <ndctl/libndctl.h>
 #include <ndctl/namespace.h>
@@ -237,6 +238,7 @@ struct ndctl_pfn {
 	int buf_len;
 	uuid_t uuid;
 	int id, generation;
+	struct ndctl_lbasize alignments;
 };
 
 struct ndctl_dax {
@@ -4814,6 +4816,20 @@ static void *__add_pfn(struct ndctl_pfn *pfn, const char *pfn_base)
 	else
 		pfn->size = strtoull(buf, NULL, 0);
 
+	/*
+	 * The supported_alignments attribute was added before arches other
+	 * than x86 had pmem support. If the kernel doesn't provide the
+	 * attribute then it's safe to a attribute then it's safe to assume
+	 * that we are on x86 which will always support 2MB and 4KB
+	 * alignments.
+	 */
+	sprintf(path, "%s/supported_alignments", pfn_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		sprintf(buf, "%d %d", SZ_4K, SZ_2M);
+
+	if (parse_lbasize_supported(ctx, pfn_base, buf, &pfn->alignments) < 0)
+		goto err_read;
+
 	free(path);
 	return pfn;
 
@@ -5048,6 +5064,23 @@ NDCTL_EXPORT int ndctl_pfn_set_align(struct ndctl_pfn *pfn, unsigned long align)
 	return 0;
 }
 
+NDCTL_EXPORT int ndctl_pfn_get_num_alignments(struct ndctl_pfn *pfn)
+{
+	return pfn->alignments.num;
+}
+
+NDCTL_EXPORT unsigned long ndctl_pfn_get_supported_alignment(
+		struct ndctl_pfn *pfn, int i)
+{
+	if (pfn->alignments.num == 0)
+		return 0;
+
+	if (i < 0 || i > pfn->alignments.num)
+		return -EINVAL;
+	else
+		return pfn->alignments.supported[i];
+}
+
 NDCTL_EXPORT int ndctl_pfn_set_namespace(struct ndctl_pfn *pfn,
 		struct ndctl_namespace *ndns)
 {
@@ -5270,6 +5303,17 @@ NDCTL_EXPORT unsigned long ndctl_dax_get_align(struct ndctl_dax *dax)
 	return ndctl_pfn_get_align(&dax->pfn);
 }
 
+NDCTL_EXPORT int ndctl_dax_get_num_alignments(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_get_num_alignments(&dax->pfn);
+}
+
+NDCTL_EXPORT unsigned long ndctl_dax_get_supported_alignment(
+		struct ndctl_dax *dax, int i)
+{
+	return ndctl_pfn_get_supported_alignment(&dax->pfn, i);
+}
+
 NDCTL_EXPORT int ndctl_dax_has_align(struct ndctl_dax *dax)
 {
 	return ndctl_pfn_has_align(&dax->pfn);
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 275db92ee103..a30a93e3c012 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -390,4 +390,8 @@ LIBNDCTL_19 {
 global:
 	ndctl_cmd_xlat_firmware_status;
 	ndctl_cmd_submit_xlat;
+	ndctl_pfn_get_supported_alignment;
+	ndctl_pfn_get_num_alignments;
+	ndctl_dax_get_supported_alignment;
+	ndctl_dax_get_num_alignments;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index e55a5932781d..ac639b7d9142 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -597,7 +597,9 @@ int ndctl_pfn_set_uuid(struct ndctl_pfn *pfn, uuid_t uu);
 void ndctl_pfn_get_uuid(struct ndctl_pfn *pfn, uuid_t uu);
 int ndctl_pfn_has_align(struct ndctl_pfn *pfn);
 int ndctl_pfn_set_align(struct ndctl_pfn *pfn, unsigned long align);
+int ndctl_pfn_get_num_alignments(struct ndctl_pfn *pfn);
 unsigned long ndctl_pfn_get_align(struct ndctl_pfn *pfn);
+unsigned long ndctl_pfn_get_supported_alignment(struct ndctl_pfn *pfn, int i);
 unsigned long long ndctl_pfn_get_resource(struct ndctl_pfn *pfn);
 unsigned long long ndctl_pfn_get_size(struct ndctl_pfn *pfn);
 int ndctl_pfn_set_namespace(struct ndctl_pfn *pfn, struct ndctl_namespace *ndns);
@@ -628,7 +630,9 @@ unsigned long long ndctl_dax_get_resource(struct ndctl_dax *dax);
 int ndctl_dax_set_uuid(struct ndctl_dax *dax, uuid_t uu);
 enum ndctl_pfn_loc ndctl_dax_get_location(struct ndctl_dax *dax);
 int ndctl_dax_set_location(struct ndctl_dax *dax, enum ndctl_pfn_loc loc);
+int ndctl_dax_get_num_alignments(struct ndctl_dax *dax);
 unsigned long ndctl_dax_get_align(struct ndctl_dax *dax);
+unsigned long ndctl_dax_get_supported_alignment(struct ndctl_dax *dax, int i);
 int ndctl_dax_has_align(struct ndctl_dax *dax);
 int ndctl_dax_set_align(struct ndctl_dax *dax, unsigned long align);
 int ndctl_dax_set_namespace(struct ndctl_dax *dax,
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
