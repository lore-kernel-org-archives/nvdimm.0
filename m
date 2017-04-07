Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B89A2094503D
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 15:33:37 -0700 (PDT)
Subject: [PATCH v6 4/4] device-dax,
 tools/testing/nvdimm: enable device-dax with mock resources
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 07 Apr 2017 15:33:36 -0700
Message-ID: <149160441676.52935.9832357509496841468.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149160440045.52935.12075328472007815165.stgit@djiang5-desk3.ch.intel.com>
References: <149160440045.52935.12075328472007815165.stgit@djiang5-desk3.ch.intel.com>
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

Provide a replacement pgoff_to_phys() that translates an nfit_test
resource (allocated by vmalloc()) to a pfn.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax-private.h      |   61 ++++++++++++++++++++++++++++++++++++++++
 drivers/dax/dax.c              |   52 ++++------------------------------
 tools/testing/nvdimm/Kbuild    |    3 +-
 tools/testing/nvdimm/dax-dev.c |   49 ++++++++++++++++++++++++++++++++
 4 files changed, 118 insertions(+), 47 deletions(-)
 create mode 100644 drivers/dax/dax-private.h
 create mode 100644 tools/testing/nvdimm/dax-dev.c

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
new file mode 100644
index 0000000..c45ac94a
--- /dev/null
+++ b/drivers/dax/dax-private.h
@@ -0,0 +1,61 @@
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
+ * struct dax_region - mapping infrastructure for dax devices
+ * @id: kernel-wide unique region for a memory range
+ * @base: linear address corresponding to @res
+ * @kref: to pin while other agents have a need to do lookups
+ * @dev: parent device backing this region
+ * @align: allocation and mapping alignment for child dax devices
+ * @res: physical address range of the region
+ * @pfn_flags: identify whether the pfns are paged back or not
+ */
+struct dax_region {
+	int id;
+	struct ida ida;
+	void *base;
+	struct kref kref;
+	struct device *dev;
+	unsigned int align;
+	struct resource res;
+	unsigned long pfn_flags;
+};
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
index 80c6db279..3a29b97 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -22,6 +22,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include "dax-private.h"
 #include "dax.h"
 
 static dev_t dax_devt;
@@ -34,48 +35,6 @@ static struct kmem_cache *dax_cache __read_mostly;
 static struct super_block *dax_superblock __read_mostly;
 MODULE_PARM_DESC(nr_dax, "max number of device-dax instances");
 
-/**
- * struct dax_region - mapping infrastructure for dax devices
- * @id: kernel-wide unique region for a memory range
- * @base: linear address corresponding to @res
- * @kref: to pin while other agents have a need to do lookups
- * @dev: parent device backing this region
- * @align: allocation and mapping alignment for child dax devices
- * @res: physical address range of the region
- * @pfn_flags: identify whether the pfns are paged back or not
- */
-struct dax_region {
-	int id;
-	struct ida ida;
-	void *base;
-	struct kref kref;
-	struct device *dev;
-	unsigned int align;
-	struct resource res;
-	unsigned long pfn_flags;
-};
-
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
@@ -396,7 +355,8 @@ static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 	return 0;
 }
 
-static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
+/* see "strong" declaration in tools/testing/nvdimm/dax-dev.c */
+__weak phys_addr_t dax_pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
 		unsigned long size)
 {
 	struct resource *res;
@@ -441,7 +401,7 @@ static int __dax_dev_pte_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 	if (fault_size != dax_region->align)
 		return VM_FAULT_SIGBUS;
 
-	phys = pgoff_to_phys(dax_dev, vmf->pgoff, PAGE_SIZE);
+	phys = dax_pgoff_to_phys(dax_dev, vmf->pgoff, PAGE_SIZE);
 	if (phys == -1) {
 		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
 				vmf->pgoff);
@@ -496,7 +456,7 @@ static int __dax_dev_pmd_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 		return VM_FAULT_SIGBUS;
 
 	pgoff = linear_page_index(vmf->vma, pmd_addr);
-	phys = pgoff_to_phys(dax_dev, pgoff, PMD_SIZE);
+	phys = dax_pgoff_to_phys(dax_dev, pgoff, PMD_SIZE);
 	if (phys == -1) {
 		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
 				pgoff);
@@ -547,7 +507,7 @@ static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
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
index 0000000..e89721d8
--- /dev/null
+++ b/tools/testing/nvdimm/dax-dev.c
@@ -0,0 +1,49 @@
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
+	struct resource *res;
+	phys_addr_t addr;
+	int i;
+
+	for (i = 0; i < dax_dev->num_resources; i++) {
+		res = &dax_dev->res[i];
+		addr = pgoff * PAGE_SIZE + res->start;
+		if (addr >= res->start && addr <= res->end)
+			break;
+		pgoff -= PHYS_PFN(resource_size(res));
+	}
+
+	if (i < dax_dev->num_resources) {
+		res = &dax_dev->res[i];
+		if (addr + size - 1 <= res->end) {
+			if (get_nfit_res(addr)) {
+				struct page *page;
+
+				if (dax_dev->region->align > PAGE_SIZE)
+					return -1;
+
+				page = vmalloc_to_page((void *)addr);
+				return PFN_PHYS(page_to_pfn(page));
+			} else
+				return addr;
+		}
+	}
+
+	return -1;
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
