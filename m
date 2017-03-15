Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E2F9C8034C
 for <linux-nvdimm@lists.01.org>; Wed, 15 Mar 2017 11:33:40 -0700 (PDT)
Subject: [PATCH v3 5/5] libnvdimm: providing dax support for nvdimm testing
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 15 Mar 2017 11:33:40 -0700
Message-ID: <148960282011.4721.5572367816330663729.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148960279823.4721.5449530412401763266.stgit@djiang5-desk3.ch.intel.com>
References: <148960279823.4721.5449530412401763266.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding dax support to the nvdimm testing in tools/testing/nvdimm. The
memory allocated by the tool is via vmalloc and non-contiguous.
Overriding pgoff_to_phys() call to support the vmalloc memory.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/dax/dax-private.h      |   40 ++++++++++++++++++++++++++++++++++++
 drivers/dax/dax.c              |   31 +++++-----------------------
 tools/testing/nvdimm/Kbuild    |    3 ++-
 tools/testing/nvdimm/dax-dev.c |   44 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 92 insertions(+), 26 deletions(-)
 create mode 100644 drivers/dax/dax-private.h
 create mode 100644 tools/testing/nvdimm/dax-dev.c

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
new file mode 100644
index 0000000..1567ea4
--- /dev/null
+++ b/drivers/dax/dax-private.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright(c) 2016 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __DAX_PRIVATE_H__
+#define __DAX_PRIVATE_H__
+
+#include <linux/device.h>
+#include <linux/cdev.h>
+
+/**
+ * struct dax_dev - subdivision of a dax region
+ * @region - parent region
+ * @inode - inode
+ * @dev - device backing the character device
+ * @cdev - core chardev data
+ * @alive - !alive + rcu grace period == no new mappings can be established
+ * @id - child id in the region
+ * @num_resources - number of physical address extents in this device
+ * @res - array of physical address ranges
+ */
+struct dax_dev {
+	struct dax_region *region;
+	struct inode *inode;
+	struct device dev;
+	struct cdev cdev;
+	bool alive;
+	int id;
+	int num_resources;
+	struct resource res[0];
+};
+#endif
diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 80c6db279..f3087f0 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -22,6 +22,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include "dax-private.h"
 #include "dax.h"
 
 static dev_t dax_devt;
@@ -55,27 +56,6 @@ struct dax_region {
 	unsigned long pfn_flags;
 };
 
-/**
- * struct dax_dev - subdivision of a dax region
- * @region - parent region
- * @dev - device backing the character device
- * @cdev - core chardev data
- * @alive - !alive + rcu grace period == no new mappings can be established
- * @id - child id in the region
- * @num_resources - number of physical address extents in this device
- * @res - array of physical address ranges
- */
-struct dax_dev {
-	struct dax_region *region;
-	struct inode *inode;
-	struct device dev;
-	struct cdev cdev;
-	bool alive;
-	int id;
-	int num_resources;
-	struct resource res[0];
-};
-
 static ssize_t id_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -396,7 +376,8 @@ static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 	return 0;
 }
 
-static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
+/* see "strong" declaration in tools/testing/nvdimm/dax-dev.c */
+__weak phys_addr_t dax_pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
 		unsigned long size)
 {
 	struct resource *res;
@@ -441,7 +422,7 @@ static int __dax_dev_pte_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 	if (fault_size != dax_region->align)
 		return VM_FAULT_SIGBUS;
 
-	phys = pgoff_to_phys(dax_dev, vmf->pgoff, PAGE_SIZE);
+	phys = dax_pgoff_to_phys(dax_dev, vmf->pgoff, PAGE_SIZE);
 	if (phys == -1) {
 		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
 				vmf->pgoff);
@@ -496,7 +477,7 @@ static int __dax_dev_pmd_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 		return VM_FAULT_SIGBUS;
 
 	pgoff = linear_page_index(vmf->vma, pmd_addr);
-	phys = pgoff_to_phys(dax_dev, pgoff, PMD_SIZE);
+	phys = dax_pgoff_to_phys(dax_dev, pgoff, PMD_SIZE);
 	if (phys == -1) {
 		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
 				pgoff);
@@ -547,7 +528,7 @@ static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 		return VM_FAULT_SIGBUS;
 
 	pgoff = linear_page_index(vmf->vma, pud_addr);
-	phys = pgoff_to_phys(dax_dev, pgoff, PUD_SIZE);
+	phys = dax_pgoff_to_phys(dax_dev, pgoff, PUD_SIZE);
 	if (phys == -1) {
 		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
 				pgoff);
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 405212b..6dcb3c4 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -28,7 +28,7 @@ obj-$(CONFIG_ND_BTT) += nd_btt.o
 obj-$(CONFIG_ND_BLK) += nd_blk.o
 obj-$(CONFIG_X86_PMEM_LEGACY) += nd_e820.o
 obj-$(CONFIG_ACPI_NFIT) += nfit.o
-obj-$(CONFIG_DEV_DAX) += dax.o
+obj-$(CONFIG_DEV_DAX) += dax.o dax-dev.o
 obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 
 nfit-y := $(ACPI_SRC)/core.o
@@ -49,6 +49,7 @@ nd_e820-y := $(NVDIMM_SRC)/e820.o
 nd_e820-y += config_check.o
 
 dax-y := $(DAX_SRC)/dax.o
+dax-y += dax-dev.o
 dax-y += config_check.o
 
 dax_pmem-y := $(DAX_SRC)/pmem.o
diff --git a/tools/testing/nvdimm/dax-dev.c b/tools/testing/nvdimm/dax-dev.c
new file mode 100644
index 0000000..1763688
--- /dev/null
+++ b/tools/testing/nvdimm/dax-dev.c
@@ -0,0 +1,44 @@
+/*
+ * Copyright (c) 2016, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include "test/nfit_test.h"
+#include <linux/mm.h>
+#include "../../../drivers/dax/dax-private.h"
+
+phys_addr_t dax_pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
+		unsigned long size)
+{
+
+	struct resource *res;
+	phys_addr_t virt;
+	int i;
+
+	for (i = 0; i < dax_dev->num_resources; i++) {
+		res = &dax_dev->res[i];
+		virt = pgoff * PAGE_SIZE + res->start;
+		if (virt >= res->start && virt <= res->end)
+			break;
+		pgoff -= PHYS_PFN(resource_size(res));
+	}
+
+	if (i < dax_dev->num_resources) {
+		res = &dax_dev->res[i];
+		if (virt + size - 1 <= res->end) {
+			struct page *page;
+
+			page = vmalloc_to_page((void *)virt);
+			return PFN_PHYS(page_to_pfn(page));
+		}
+	}
+
+	return -1;
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
