Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 17/25] intel-iommu: switch from ioremap_cache to memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jul 2015 22:39:33 -0400
Message-ID: <20150725023933.8664.85856.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, David Woodhouse <dwmw2@infradead.org>, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for deprecating ioremap_cache() convert its usage in
intel-iommu to memremap.  This also eliminates the mishandling of the
__iomem annotation in the implementation.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/iommu/intel-iommu.c         |   10 ++++++----
 drivers/iommu/intel_irq_remapping.c |    4 ++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index a98a7b27aca1..028ad0ff6abb 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -34,6 +34,7 @@
 #include <linux/mempool.h>
 #include <linux/memory.h>
 #include <linux/timer.h>
+#include <linux/io.h>
 #include <linux/iova.h>
 #include <linux/iommu.h>
 #include <linux/intel-iommu.h>
@@ -2871,7 +2872,8 @@ static int copy_context_table(struct intel_iommu *iommu,
 			}
 
 			ret = -ENOMEM;
-			old_ce = ioremap_cache(old_ce_phys, PAGE_SIZE);
+			old_ce = memremap(old_ce_phys, PAGE_SIZE,
+					MEMREMAP_CACHE);
 			if (!old_ce)
 				goto out;
 
@@ -2919,7 +2921,7 @@ static int copy_context_table(struct intel_iommu *iommu,
 	__iommu_flush_cache(iommu, new_ce, VTD_PAGE_SIZE);
 
 out_unmap:
-	iounmap(old_ce);
+	memunmap(old_ce);
 
 out:
 	return ret;
@@ -2953,7 +2955,7 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 	if (!old_rt_phys)
 		return -EINVAL;
 
-	old_rt = ioremap_cache(old_rt_phys, PAGE_SIZE);
+	old_rt = memremap(old_rt_phys, PAGE_SIZE, MEMREMAP_CACHE);
 	if (!old_rt)
 		return -ENOMEM;
 
@@ -3002,7 +3004,7 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 	ret = 0;
 
 out_unmap:
-	iounmap(old_rt);
+	memunmap(old_rt);
 
 	return ret;
 }
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 27cdfa84ec5b..1da158d3b3ce 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -408,7 +408,7 @@ static int iommu_load_old_irte(struct intel_iommu *iommu)
 	size     = INTR_REMAP_TABLE_ENTRIES*sizeof(struct irte);
 
 	/* Map the old IR table */
-	old_ir_table = ioremap_cache(irt_phys, size);
+	old_ir_table = memremap(irt_phys, size, MEMREMAP_CACHE);
 	if (!old_ir_table)
 		return -ENOMEM;
 
@@ -426,7 +426,7 @@ static int iommu_load_old_irte(struct intel_iommu *iommu)
 			bitmap_set(iommu->ir_table->bitmap, i, 1);
 	}
 
-	iounmap(old_ir_table);
+	memunmap(old_ir_table);
 
 	return 0;
 }

