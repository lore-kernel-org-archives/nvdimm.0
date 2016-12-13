Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE10282034
 for <linux-nvdimm@lists.01.org>; Mon, 12 Dec 2016 16:14:58 -0800 (PST)
Subject: [PATCH 2/3] nvdimm-testing: providing dax support for nvdimm testing
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 12 Dec 2016 17:14:57 -0700
Message-ID: <148158809779.159590.5938420122000642708.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148158809239.159590.16102609849408268953.stgit@djiang5-desk3.ch.intel.com>
References: <148158809239.159590.16102609849408268953.stgit@djiang5-desk3.ch.intel.com>
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
---
 drivers/dax/dax-private.h      |   43 ++++++++++++++++++++++++++++++++++++++++
 drivers/dax/dax.c              |   34 ++++++--------------------------
 tools/testing/nvdimm/Kbuild    |    3 ++-
 tools/testing/nvdimm/dax-dev.c |   40 +++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+), 29 deletions(-)
 create mode 100644 drivers/dax/dax-private.h
 create mode 100644 tools/testing/nvdimm/dax-dev.c

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
new file mode 100644
index 0000000..56f80d2
--- /dev/null
+++ b/drivers/dax/dax-private.h
@@ -0,0 +1,43 @@
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
+ * @resize_lock - for resource size reductions
+ * @dev - device backing the character device
+ * @cdev - core chardev data
+ * @alive - !alive + rcu grace period == no new mappings can be established
+ * @id - child id in the region
+ * @num_resources - number of physical address extents in this device
+ * @res - array of physical address ranges
+ */
+struct dax_dev {
+	struct dax_region *region;
+	rwlock_t resize_lock;
+	struct inode *inode;
+	struct device dev;
+	struct cdev cdev;
+	bool alive;
+	int id;
+	int num_resources;
+	struct resource **res;
+	void *private;
+};
+
+#endif
diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 2c34cae..32c9a7f 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -23,6 +23,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include "dax.h"
+#include "dax-private.h"
 
 static dev_t dax_devt;
 static struct class *dax_class;
@@ -62,30 +63,6 @@ struct dax_region {
 	unsigned long pfn_flags;
 };
 
-/**
- * struct dax_dev - subdivision of a dax region
- * @region - parent region
- * @resize_lock - for resource size reductions
- * @dev - device backing the character device
- * @cdev - core chardev data
- * @alive - !alive + rcu grace period == no new mappings can be established
- * @id - child id in the region
- * @num_resources - number of physical address extents in this device
- * @res - array of physical address ranges
- */
-struct dax_dev {
-	struct dax_region *region;
-	rwlock_t resize_lock;
-	struct inode *inode;
-	struct device dev;
-	struct cdev cdev;
-	bool alive;
-	int id;
-	int num_resources;
-	struct resource **res;
-	void *private;
-};
-
 #define for_each_dax_region_resource(dax_region, res) \
 	for (res = (dax_region)->res.child; res; res = res->sibling)
 
@@ -933,8 +910,9 @@ static phys_addr_t __pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
 	return res->start + res_offset;
 }
 
-static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
-                unsigned long size)
+/* see "strong" declaration in tools/testing/nvdimm/dax-dev.c */
+__weak phys_addr_t dax_pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
+		unsigned long size)
 {
 	phys_addr_t phys;
 
@@ -964,7 +942,7 @@ static int __dax_dev_fault(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 		return VM_FAULT_SIGBUS;
 	}
 
-	phys = pgoff_to_phys(dax_dev, vmf->pgoff, PAGE_SIZE);
+	phys = dax_pgoff_to_phys(dax_dev, vmf->pgoff, PAGE_SIZE);
 	if (phys == -1) {
 		dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
 				vmf->pgoff);
@@ -1026,7 +1004,7 @@ static int __dax_dev_pmd_fault(struct dax_dev *dax_dev,
 	}
 
 	pgoff = linear_page_index(vma, pmd_addr);
-	phys = pgoff_to_phys(dax_dev, pgoff, PMD_SIZE);
+	phys = dax_pgoff_to_phys(dax_dev, pgoff, PMD_SIZE);
 	if (phys == -1) {
 		dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
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
index 0000000..cd9a5e0
--- /dev/null
+++ b/tools/testing/nvdimm/dax-dev.c
@@ -0,0 +1,40 @@
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
+	struct address_space *mapping = dax_dev->inode->i_mapping;
+	phys_addr_t dev_offset = PFN_PHYS(pgoff), res_offset;
+	struct resource *res;
+
+	res = radix_tree_lookup(&mapping->page_tree, PFN_PHYS(pgoff));
+	if (!res)
+		return -1;
+
+	res_offset = dev_offset - to_dev_offset(res);
+	if (res_offset + size >= resource_size(res))
+		return -1;
+
+	if (get_nfit_res(res->start + res_offset)) {
+		struct page *page;
+
+		page = vmalloc_to_page((void *)(res->start + res_offset));
+		return PFN_PHYS(page_to_pfn(page));
+	}
+
+	return res->start + res_offset;
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
