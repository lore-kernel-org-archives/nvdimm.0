Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com
 [IPv6:2607:f8b0:4864:20::443])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56809211BFCC4
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 02:59:41 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id u6so11225565pfh.11
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 02:59:41 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH v5 1/7] libndctl: Use the supported_alignment attribute
Date: Wed, 30 Jan 2019 21:59:21 +1100
Message-Id: <20190130105927.31901-1-oohall@gmail.com>
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
v5: Fixed comment wording

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
 ndctl/lib/libndctl.c   | 43 ++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |  4 ++++
 ndctl/libndctl.h       |  4 ++++
 3 files changed, 51 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 830b791339d2..06f835d76117 100644
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
@@ -4814,6 +4816,19 @@ static void *__add_pfn(struct ndctl_pfn *pfn, const char *pfn_base)
 	else
 		pfn->size = strtoull(buf, NULL, 0);
 
+	/*
+	 * The supported_alignments attribute was added before arches other
+	 * than x86 had pmem support. If the kernel doesn't provide the
+	 * attribute then it's safe to assume that we running on x86 where
+	 * 4KiB and 2MiB have always been supported.
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
 
@@ -5048,6 +5063,23 @@ NDCTL_EXPORT int ndctl_pfn_set_align(struct ndctl_pfn *pfn, unsigned long align)
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
@@ -5270,6 +5302,17 @@ NDCTL_EXPORT unsigned long ndctl_dax_get_align(struct ndctl_dax *dax)
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
