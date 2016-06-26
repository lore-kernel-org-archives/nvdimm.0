Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 0D26F1A1E04
 for <linux-nvdimm@lists.01.org>; Sun, 26 Jun 2016 16:13:30 -0700 (PDT)
Subject: [PATCH 1/2] libnvdimm,
 pmem: allow nfit_test to override pmem_direct_access()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Jun 2016 16:12:13 -0700
Message-ID: <146698273350.40036.13234742186730439918.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146698272810.40036.6685354433183952465.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146698272810.40036.6685354433183952465.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Currently phys_to_pfn_t() is an exported symbol to allow nfit_test to
override it and indicate that nfit_test-pmem is not device-mapped.  Now,
we want to enable nfit_test to operate without DMA_CMA and the pmem it
provides will no longer be physically contiguous, i.e. won't be capable
of supporting direct_access requests larger than a page.  Make
pmem_direct_access() a weak symbol so that it can be replaced by the
tools/testing/nvdimm/ version, and move phys_to_pfn_t() to a static
inline now that it no longer needs to be overridden.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c                 |   18 ++------------
 drivers/nvdimm/pmem.h                 |   24 +++++++++++++++++++
 include/linux/pfn_t.h                 |    5 +++-
 kernel/memremap.c                     |    6 -----
 tools/testing/nvdimm/Kbuild           |    3 ++
 tools/testing/nvdimm/pmem-dax.c       |   42 +++++++++++++++++++++++++++++++++
 tools/testing/nvdimm/test/iomap.c     |    3 ++
 tools/testing/nvdimm/test/nfit_test.h |    2 ++
 8 files changed, 79 insertions(+), 24 deletions(-)
 create mode 100644 drivers/nvdimm/pmem.h
 create mode 100644 tools/testing/nvdimm/pmem-dax.c

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index ba253df6233f..b6fcb97a601c 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -29,23 +29,10 @@
 #include <linux/slab.h>
 #include <linux/pmem.h>
 #include <linux/nd.h>
+#include "pmem.h"
 #include "pfn.h"
 #include "nd.h"
 
-struct pmem_device {
-	/* One contiguous memory region per device */
-	phys_addr_t		phys_addr;
-	/* when non-zero this device is hosting a 'pfn' instance */
-	phys_addr_t		data_offset;
-	u64			pfn_flags;
-	void __pmem		*virt_addr;
-	/* immutable base size of the namespace */
-	size_t			size;
-	/* trim size when namespace capacity has been section aligned */
-	u32			pfn_pad;
-	struct badblocks	bb;
-};
-
 static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 		unsigned int len)
 {
@@ -163,7 +150,8 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	return rc;
 }
 
-static long pmem_direct_access(struct block_device *bdev, sector_t sector,
+/* see "strong" declaration in tools/testing/nvdimm/pmem-dax.c */
+__weak long pmem_direct_access(struct block_device *bdev, sector_t sector,
 		      void __pmem **kaddr, pfn_t *pfn, long size)
 {
 	struct pmem_device *pmem = bdev->bd_queue->queuedata;
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
new file mode 100644
index 000000000000..c48d4e3aa346
--- /dev/null
+++ b/drivers/nvdimm/pmem.h
@@ -0,0 +1,24 @@
+#ifndef __NVDIMM_PMEM_H__
+#define __NVDIMM_PMEM_H__
+#include <linux/badblocks.h>
+#include <linux/types.h>
+#include <linux/pfn_t.h>
+#include <linux/fs.h>
+
+long pmem_direct_access(struct block_device *bdev, sector_t sector,
+		      void __pmem **kaddr, pfn_t *pfn, long size);
+/* this definition is in it's own header for tools/testing/nvdimm to consume */
+struct pmem_device {
+	/* One contiguous memory region per device */
+	phys_addr_t		phys_addr;
+	/* when non-zero this device is hosting a 'pfn' instance */
+	phys_addr_t		data_offset;
+	u64			pfn_flags;
+	void __pmem		*virt_addr;
+	/* immutable base size of the namespace */
+	size_t			size;
+	/* trim size when namespace capacity has been section aligned */
+	u32			pfn_pad;
+	struct badblocks	bb;
+};
+#endif /* __NVDIMM_PMEM_H__ */
diff --git a/include/linux/pfn_t.h b/include/linux/pfn_t.h
index 94994810c7c0..a3d90b9da18d 100644
--- a/include/linux/pfn_t.h
+++ b/include/linux/pfn_t.h
@@ -28,7 +28,10 @@ static inline pfn_t pfn_to_pfn_t(unsigned long pfn)
 	return __pfn_to_pfn_t(pfn, 0);
 }
 
-extern pfn_t phys_to_pfn_t(phys_addr_t addr, u64 flags);
+static inline pfn_t phys_to_pfn_t(phys_addr_t addr, u64 flags)
+{
+	return __pfn_to_pfn_t(addr >> PAGE_SHIFT, flags);
+}
 
 static inline bool pfn_t_has_page(pfn_t pfn)
 {
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 017532193fb1..852e5266124a 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -169,12 +169,6 @@ void devm_memunmap(struct device *dev, void *addr)
 }
 EXPORT_SYMBOL(devm_memunmap);
 
-pfn_t phys_to_pfn_t(phys_addr_t addr, u64 flags)
-{
-	return __pfn_to_pfn_t(addr >> PAGE_SHIFT, flags);
-}
-EXPORT_SYMBOL(phys_to_pfn_t);
-
 #ifdef CONFIG_ZONE_DEVICE
 static DEFINE_MUTEX(pgmap_lock);
 static RADIX_TREE(pgmap_radix, GFP_KERNEL);
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 785985677159..4adfa9cdf26f 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -11,12 +11,12 @@ ldflags-y += --wrap=__devm_release_region
 ldflags-y += --wrap=__request_region
 ldflags-y += --wrap=__release_region
 ldflags-y += --wrap=devm_memremap_pages
-ldflags-y += --wrap=phys_to_pfn_t
 
 DRIVERS := ../../../drivers
 NVDIMM_SRC := $(DRIVERS)/nvdimm
 ACPI_SRC := $(DRIVERS)/acpi
 DAX_SRC := $(DRIVERS)/dax
+ccflags-y := -I$(src)/$(NVDIMM_SRC)/
 
 obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
 obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
@@ -31,6 +31,7 @@ nfit-y := $(ACPI_SRC)/nfit.o
 nfit-y += config_check.o
 
 nd_pmem-y := $(NVDIMM_SRC)/pmem.o
+nd_pmem-y += pmem-dax.o
 nd_pmem-y += config_check.o
 
 nd_btt-y := $(NVDIMM_SRC)/btt.o
diff --git a/tools/testing/nvdimm/pmem-dax.c b/tools/testing/nvdimm/pmem-dax.c
new file mode 100644
index 000000000000..fdba77f2bb06
--- /dev/null
+++ b/tools/testing/nvdimm/pmem-dax.c
@@ -0,0 +1,42 @@
+/*
+ * Copyright (c) 2014-2016, Intel Corporation.
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
+#include <linux/blkdev.h>
+#include <pmem.h>
+#include <nd.h>
+
+long pmem_direct_access(struct block_device *bdev, sector_t sector,
+		void __pmem **kaddr, pfn_t *pfn, long size)
+{
+	struct pmem_device *pmem = bdev->bd_queue->queuedata;
+	resource_size_t offset = sector * 512 + pmem->data_offset;
+
+	/* disable DAX for nfit_test pmem devices */
+	if (get_nfit_res(pmem->phys_addr + offset)) {
+		dev_info_once(pmem->bb.dev, "dax is disabled for nfit_test\n");
+		return -EIO;
+	}
+
+	if (unlikely(is_bad_pmem(&pmem->bb, sector, size)))
+		return -EIO;
+	*kaddr = pmem->virt_addr + offset;
+	*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
+
+	/*
+	 * If badblocks are present, limit known good range to the
+	 * requested range.
+	 */
+	if (unlikely(pmem->bb.count))
+		return size;
+	return pmem->size - pmem->pfn_pad - offset;
+}
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index c842095f2801..9966f093b4ff 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -52,7 +52,7 @@ static struct nfit_test_resource *__get_nfit_res(resource_size_t resource)
 	return NULL;
 }
 
-static struct nfit_test_resource *get_nfit_res(resource_size_t resource)
+struct nfit_test_resource *get_nfit_res(resource_size_t resource)
 {
 	struct nfit_test_resource *res;
 
@@ -62,6 +62,7 @@ static struct nfit_test_resource *get_nfit_res(resource_size_t resource)
 
 	return res;
 }
+EXPORT_SYMBOL(get_nfit_res);
 
 void __iomem *__nfit_test_ioremap(resource_size_t offset, unsigned long size,
 		void __iomem *(*fallback_fn)(resource_size_t, unsigned long))
diff --git a/tools/testing/nvdimm/test/nfit_test.h b/tools/testing/nvdimm/test/nfit_test.h
index 96c5e16d7db9..9f18e2a4a862 100644
--- a/tools/testing/nvdimm/test/nfit_test.h
+++ b/tools/testing/nvdimm/test/nfit_test.h
@@ -12,6 +12,7 @@
  */
 #ifndef __NFIT_TEST_H__
 #define __NFIT_TEST_H__
+#include <linux/list.h>
 
 struct nfit_test_resource {
 	struct list_head list;
@@ -26,4 +27,5 @@ void __iomem *__wrap_ioremap_nocache(resource_size_t offset,
 void __wrap_iounmap(volatile void __iomem *addr);
 void nfit_test_setup(nfit_test_lookup_fn lookup);
 void nfit_test_teardown(void);
+struct nfit_test_resource *get_nfit_res(resource_size_t resource);
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
