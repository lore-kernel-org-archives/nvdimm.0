Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DA257211D56C1
 for <linux-nvdimm@lists.01.org>; Tue,  5 Mar 2019 21:35:30 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x265Ycc2140665
 for <linux-nvdimm@lists.01.org>; Wed, 6 Mar 2019 00:35:29 -0500
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2r283s06cw-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Wed, 06 Mar 2019 00:35:28 -0500
Received: from localhost
 by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Wed, 6 Mar 2019 05:35:27 -0000
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [RFC PATCH] drivers/nvdimm: Architecture specific abstraction for pfn
 device alignment
Date: Wed,  6 Mar 2019 11:05:15 +0530
MIME-Version: 1.0
Message-Id: <20190306053515.6480-1-aneesh.kumar@linux.ibm.com>
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
To: linux-nvdimm@lists.01.org, dan.j.williams@intel.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

Even if the kernel is built with THP or HUGEPAGE_PUD, the platform can decide
not to allow huge pages based on different parameters. The huge page support
checks are mostly arch specific and this patch provides arch specific
callbacks/abstraction for finding alignment values we should use when configuring
pfn device.

Cc: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/include/asm/libnvdimm.h | 10 ++++++
 arch/powerpc/mm/Makefile             |  1 +
 arch/powerpc/mm/nvdimm.c             | 48 ++++++++++++++++++++++++++++
 arch/x86/include/asm/libnvdimm.h     | 19 +++++++++++
 drivers/nvdimm/nd.h                  |  6 ----
 drivers/nvdimm/pfn_devs.c            | 31 ++++++++++++++++--
 6 files changed, 107 insertions(+), 8 deletions(-)
 create mode 100644 arch/powerpc/include/asm/libnvdimm.h
 create mode 100644 arch/powerpc/mm/nvdimm.c
 create mode 100644 arch/x86/include/asm/libnvdimm.h

diff --git a/arch/powerpc/include/asm/libnvdimm.h b/arch/powerpc/include/asm/libnvdimm.h
new file mode 100644
index 000000000000..0928096eca90
--- /dev/null
+++ b/arch/powerpc/include/asm/libnvdimm.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_LIBNVDIMM_H
+#define _ASM_POWERPC_LIBNVDIMM_H
+
+#define nd_pfn_supported_alignment nd_pfn_supported_alignment
+extern unsigned long *nd_pfn_supported_alignments(void);
+extern unsigned long nd_pfn_default_alignment(void);
+extern unsigned long nd_altmap_align_size(unsigned long nd_align);
+
+#endif
diff --git a/arch/powerpc/mm/Makefile b/arch/powerpc/mm/Makefile
index f965fc33a8b7..fed0d4b3b4bc 100644
--- a/arch/powerpc/mm/Makefile
+++ b/arch/powerpc/mm/Makefile
@@ -55,3 +55,4 @@ obj-$(CONFIG_PPC_BOOK3S_64)	+= dump_linuxpagetables-book3s64.o
 endif
 obj-$(CONFIG_PPC_HTDUMP)	+= dump_hashpagetable.o
 obj-$(CONFIG_PPC_MEM_KEYS)	+= pkeys.o
+obj-$(CONFIG_NVDIMM_PFN)	+= nvdimm.o
diff --git a/arch/powerpc/mm/nvdimm.c b/arch/powerpc/mm/nvdimm.c
new file mode 100644
index 000000000000..ae47a65362a1
--- /dev/null
+++ b/arch/powerpc/mm/nvdimm.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/mm.h>
+
+/*
+ * We support only pte and pmd mappings for now.
+ */
+const unsigned long *nd_pfn_supported_alignments(void)
+{
+	static unsigned long supported_alignments[3];
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+#error "Update page size"
+#endif
+	supported_alignments[0] = PAGE_SIZE;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (mmu_psize_defs[MMU_PAGE_16M].shift ||
+	    mmu_psize_defs[MMU_PAGE_2M].shift)
+		supported_alignments[1] = HPAGE_PMD_SIZE;
+#else
+	supported_alignments[1] = 0;
+#endif
+
+	supported_alignments[2] = 0;
+	return supported_alignments;
+}
+
+/*
+ * Use pmd mapping if supported as default alignment
+ */
+unsigned long nd_pfn_default_alignment(void)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (mmu_psize_defs[MMU_PAGE_16M].shift ||
+	    mmu_psize_defs[MMU_PAGE_2M].shift)
+		return HPAGE_PMD_SIZE;
+#endif
+	return PAGE_SIZE;
+}
+
+unsigned long nd_altmap_align_size(unsigned long nd_align)
+{
+	unsigned long vmemmap_psize;
+
+	vmemmap_psize = 1UL << mmu_psize_defs[mmu_vmemmap_psize].shift;
+	return max(nd_align, vmemmap_psize);
+}
diff --git a/arch/x86/include/asm/libnvdimm.h b/arch/x86/include/asm/libnvdimm.h
new file mode 100644
index 000000000000..3d5361db9164
--- /dev/null
+++ b/arch/x86/include/asm/libnvdimm.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_LIBNVDIMM_H
+#define _ASM_X86_LIBNVDIMM_H
+
+static inline unsigned long nd_pfn_default_alignment(void)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	return HPAGE_PMD_SIZE;
+#else
+	return PAGE_SIZE;
+#endif
+}
+
+static inline unsigned long nd_altmap_align_size(unsigned long nd_align)
+{
+	return PMD_SIZE;
+}
+
+#endif
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 379bf4305e61..e5a65868476f 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -292,12 +292,6 @@ static inline struct device *nd_btt_create(struct nd_region *nd_region)
 struct nd_pfn *to_nd_pfn(struct device *dev);
 #if IS_ENABLED(CONFIG_NVDIMM_PFN)
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define PFN_DEFAULT_ALIGNMENT HPAGE_PMD_SIZE
-#else
-#define PFN_DEFAULT_ALIGNMENT PAGE_SIZE
-#endif
-
 int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns);
 bool is_nd_pfn(struct device *dev);
 struct device *nd_pfn_create(struct nd_region *nd_region);
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 6f22272e8d80..331e53bcb65e 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <asm/libnvdimm.h>
 #include "nd-core.h"
 #include "pfn.h"
 #include "nd.h"
@@ -111,6 +112,8 @@ static ssize_t align_show(struct device *dev,
 	return sprintf(buf, "%ld\n", nd_pfn->align);
 }
 
+#ifndef nd_pfn_supported_alignment
+#define nd_pfn_supported_alignment nd_pfn_supported_alignment
 static const unsigned long *nd_pfn_supported_alignments(void)
 {
 	/*
@@ -133,6 +136,7 @@ static const unsigned long *nd_pfn_supported_alignments(void)
 
 	return data;
 }
+#endif
 
 static ssize_t align_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
@@ -310,7 +314,7 @@ struct device *nd_pfn_devinit(struct nd_pfn *nd_pfn,
 		return NULL;
 
 	nd_pfn->mode = PFN_MODE_NONE;
-	nd_pfn->align = PFN_DEFAULT_ALIGNMENT;
+	nd_pfn->align = nd_pfn_default_alignment();
 	dev = &nd_pfn->dev;
 	device_initialize(&nd_pfn->dev);
 	if (ndns && !__nd_attach_ndns(&nd_pfn->dev, ndns, &nd_pfn->ndns)) {
@@ -420,6 +424,20 @@ static int nd_pfn_clear_memmap_errors(struct nd_pfn *nd_pfn)
 	return 0;
 }
 
+static bool nd_supported_alignment(unsigned long align)
+{
+	int i;
+	const unsigned long *supported = nd_pfn_supported_alignments();
+
+	if (align == 0)
+		return false;
+
+	for (i = 0; supported[i]; i++)
+		if (align == supported[i])
+			return true;
+	return false;
+}
+
 int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 {
 	u64 checksum, offset;
@@ -474,6 +492,15 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 		align = 1UL << ilog2(offset);
 	mode = le32_to_cpu(pfn_sb->mode);
 
+	/*
+	 * Check whether the we support the alignment
+	 */
+	if (!nd_supported_alignment(align)) {
+		dev_err(&nd_pfn->dev, "init failed, settings mismatch\n");
+		dev_dbg(&nd_pfn->dev, "align: %lx:%lx\n", nd_pfn->align, align);
+		return -EINVAL;
+	}
+
 	if (!nd_pfn->uuid) {
 		/*
 		 * When probing a namepace via nd_pfn_probe() the uuid
@@ -743,7 +770,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		 * PMD_SIZE for most architectures.
 		 */
 		offset = ALIGN(start + SZ_8K + 64 * npfns + dax_label_reserve,
-				max(nd_pfn->align, PMD_SIZE)) - start;
+			       nd_altmap_align_size(nd_pfn->align)) - start;
 	} else if (nd_pfn->mode == PFN_MODE_RAM)
 		offset = ALIGN(start + SZ_8K + dax_label_reserve,
 				nd_pfn->align) - start;
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
