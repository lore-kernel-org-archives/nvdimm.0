Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E5DD21A143C1
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 01:14:26 -0700 (PDT)
Received: by mail-pf0-x241.google.com with SMTP id d5so3767848pfe.1
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 01:15:56 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 2/4] libndctl: Parse supported_alignments for dax and pfn
 devices
Date: Tue, 27 Jun 2017 18:15:29 +1000
Message-Id: <20170627081531.7389-2-oohall@gmail.com>
In-Reply-To: <20170627081531.7389-1-oohall@gmail.com>
References: <20170627081531.7389-1-oohall@gmail.com>
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
determine the alignments the kernel supports for PFN and DAX
regions.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 ndctl/lib/libndctl.c   | 69 +++++++++++++++++++++++++++++++++++++++++++++++++-
 ndctl/lib/libndctl.sym |  2 ++
 ndctl/libndctl.h.in    |  8 ++++++
 3 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index aa262f03303e..d21d372891a4 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -34,6 +34,7 @@
 #include <ndctl.h>
 #endif
 
+#include <util/size.h>
 #include <util/sysfs.h>
 #include <ndctl/libndctl.h>
 #include <daxctl/libdaxctl.h>
@@ -327,6 +328,7 @@ struct ndctl_pfn {
 	int buf_len;
 	uuid_t uuid;
 	int id, generation;
+	struct ndctl_sizes alignments;
 };
 
 struct ndctl_dax {
@@ -2858,6 +2860,18 @@ static char *get_block_device(struct ndctl_ctx *ctx, const char *block_path)
 static int parse_sizes(struct ndctl_ctx *ctx, const char *devname,
 		const char *buf, struct ndctl_sizes *lba);
 
+static int sizes_contains(struct ndctl_sizes *sizes, unsigned long size)
+{
+	int i;
+
+	for (i = 0; i < sizes->num; i++)
+		if (sizes->supported[i] == size)
+			return 1;
+
+	return 0;
+}
+
+
 static void *add_namespace(void *parent, int id, const char *ndns_base)
 {
 	const char *devname = devpath_to_devname(ndns_base);
@@ -4148,6 +4162,7 @@ static void *__add_pfn(struct ndctl_pfn *pfn, const char *pfn_base)
 	char *path = calloc(1, strlen(pfn_base) + 100);
 	struct ndctl_region *region = pfn->region;
 	char buf[SYSFS_ATTR_SIZE];
+	char *end = NULL;
 
 	if (!path)
 		return NULL;
@@ -4190,7 +4205,19 @@ static void *__add_pfn(struct ndctl_pfn *pfn, const char *pfn_base)
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		pfn->align = 0;
 	else
-		pfn->align = strtoul(buf, NULL, 0);
+		pfn->align = strtoul(buf, &end, 0);
+
+
+	sprintf(path, "%s/supported_alignments", pfn_base);
+	if (sysfs_read_attr(ctx, path, buf) >= 0)
+		parse_sizes(ctx, devpath_to_devname(pfn_base),
+				buf, &pfn->alignments);
+
+	if (!pfn->alignments.supported) {
+		pfn->alignments.supported =
+			(unsigned int []) {SZ_4K, SZ_2M, SZ_1G};
+		pfn->alignments.num = 3;
+	}
 
 	sprintf(path, "%s/resource", pfn_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
@@ -4435,6 +4462,29 @@ NDCTL_EXPORT int ndctl_pfn_set_align(struct ndctl_pfn *pfn, unsigned long align)
 	return 0;
 }
 
+NDCTL_EXPORT unsigned int ndctl_pfn_get_supported_align(
+		struct ndctl_pfn *pfn, int i)
+{
+	if (pfn->alignments.num == 0)
+		return 0;
+
+	if (i < 0 || i > pfn->alignments.num)
+		return UINT_MAX;
+	else
+		return pfn->alignments.supported[i];
+}
+
+NDCTL_EXPORT int ndctl_pfn_get_num_aligns(struct ndctl_pfn *pfn)
+{
+	return pfn->alignments.num;
+}
+
+NDCTL_EXPORT int ndctl_pfn_supports_align(struct ndctl_pfn *pfn,
+		unsigned long align)
+{
+	return sizes_contains(&pfn->alignments, align);
+}
+
 NDCTL_EXPORT int ndctl_pfn_set_namespace(struct ndctl_pfn *pfn,
 		struct ndctl_namespace *ndns)
 {
@@ -4661,6 +4711,23 @@ NDCTL_EXPORT int ndctl_dax_has_align(struct ndctl_dax *dax)
 	return ndctl_pfn_has_align(&dax->pfn);
 }
 
+NDCTL_EXPORT unsigned int ndctl_dax_get_supported_align(
+		struct ndctl_dax *dax, int i)
+{
+	return ndctl_pfn_get_supported_align(&dax->pfn, i);
+}
+
+NDCTL_EXPORT int ndctl_dax_get_num_aligns(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_get_num_aligns(&dax->pfn);
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
index 9bc36a37a813..547d1bf133c6 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -238,6 +238,7 @@ global:
 	ndctl_pfn_get_location;
 	ndctl_pfn_set_location;
 	ndctl_pfn_get_align;
+	ndctl_pfn_supports_align;
 	ndctl_pfn_get_size;
 	ndctl_pfn_get_resource;
 	ndctl_pfn_has_align;
@@ -266,6 +267,7 @@ global:
 	ndctl_dax_get_location;
 	ndctl_dax_set_location;
 	ndctl_dax_get_align;
+	ndctl_dax_supports_align;
 	ndctl_dax_has_align;
 	ndctl_dax_set_align;
 	ndctl_dax_set_namespace;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 2c45d2daa81b..1d0924999b03 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -587,7 +587,11 @@ int ndctl_pfn_set_uuid(struct ndctl_pfn *pfn, uuid_t uu);
 void ndctl_pfn_get_uuid(struct ndctl_pfn *pfn, uuid_t uu);
 int ndctl_pfn_has_align(struct ndctl_pfn *pfn);
 int ndctl_pfn_set_align(struct ndctl_pfn *pfn, unsigned long align);
+int ndctl_pfn_get_num_aligns(struct ndctl_pfn *pfn);
+int ndctl_pfn_supports_align(struct ndctl_pfn *pfn, unsigned long size);
+unsigned int ndctl_pfn_get_supported_align(struct ndctl_pfn *pfn, int i);
 unsigned long ndctl_pfn_get_align(struct ndctl_pfn *pfn);
+unsigned long ndctl_pfn_def_align(struct ndctl_pfn *pfn);
 unsigned long long ndctl_pfn_get_resource(struct ndctl_pfn *pfn);
 unsigned long long ndctl_pfn_get_size(struct ndctl_pfn *pfn);
 int ndctl_pfn_set_namespace(struct ndctl_pfn *pfn, struct ndctl_namespace *ndns);
@@ -619,8 +623,12 @@ int ndctl_dax_set_uuid(struct ndctl_dax *dax, uuid_t uu);
 enum ndctl_pfn_loc ndctl_dax_get_location(struct ndctl_dax *dax);
 int ndctl_dax_set_location(struct ndctl_dax *dax, enum ndctl_pfn_loc loc);
 unsigned long ndctl_dax_get_align(struct ndctl_dax *dax);
+unsigned long ndctl_dax_def_align(struct ndctl_dax *dax);
 int ndctl_dax_has_align(struct ndctl_dax *dax);
 int ndctl_dax_set_align(struct ndctl_dax *dax, unsigned long align);
+int ndctl_dax_get_num_aligns(struct ndctl_dax *dax);
+unsigned int ndctl_dax_get_supported_align(struct ndctl_dax *dax, int i);
+int ndctl_dax_supports_align(struct ndctl_dax *dax, unsigned long size);
 int ndctl_dax_set_namespace(struct ndctl_dax *dax,
 		struct ndctl_namespace *ndns);
 struct ndctl_bus *ndctl_dax_get_bus(struct ndctl_dax *dax);
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
