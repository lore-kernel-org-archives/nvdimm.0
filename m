Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA2C221296B01
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jun 2019 05:28:34 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/25] mm: remove the HMM config option
Date: Mon, 17 Jun 2019 14:27:32 +0200
Message-Id: <20190617122733.22432-25-hch@lst.de>
In-Reply-To: <20190617122733.22432-1-hch@lst.de>
References: <20190617122733.22432-1-hch@lst.de>
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
To: Dan Williams <dan.j.williams@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

All the mm/hmm.c code is better keyed off HMM_MIRROR.  Also let nouveau
depend on it instead of the mix of a dummy dependency symbol plus the
actually selected one.  Drop various odd dependencies, as the code is
pretty portable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/nouveau/Kconfig |  3 +--
 include/linux/hmm.h             | 10 +---------
 include/linux/mm_types.h        |  2 +-
 mm/Kconfig                      | 30 +++++-------------------------
 mm/Makefile                     |  2 +-
 mm/hmm.c                        |  2 --
 6 files changed, 9 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index 6303d203ab1d..66c839d8e9d1 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -84,11 +84,10 @@ config DRM_NOUVEAU_BACKLIGHT
 
 config DRM_NOUVEAU_SVM
 	bool "(EXPERIMENTAL) Enable SVM (Shared Virtual Memory) support"
-	depends on ARCH_HAS_HMM
 	depends on DEVICE_PRIVATE
 	depends on DRM_NOUVEAU
+	depends on HMM_MIRROR
 	depends on STAGING
-	select HMM_MIRROR
 	default n
 	help
 	  Say Y here if you want to enable experimental support for
diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index 454be41f2eaf..ffc52820d976 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -62,7 +62,7 @@
 #include <linux/kconfig.h>
 #include <asm/pgtable.h>
 
-#if IS_ENABLED(CONFIG_HMM)
+#ifdef CONFIG_HMM_MIRROR
 
 #include <linux/device.h>
 #include <linux/migrate.h>
@@ -334,9 +334,6 @@ static inline uint64_t hmm_pfn_from_pfn(const struct hmm_range *range,
 	return hmm_device_entry_from_pfn(range, pfn);
 }
 
-
-
-#if IS_ENABLED(CONFIG_HMM_MIRROR)
 /*
  * Mirroring: how to synchronize device page table with CPU page table.
  *
@@ -586,9 +583,4 @@ static inline void hmm_mm_destroy(struct mm_struct *mm) {}
 static inline void hmm_mm_init(struct mm_struct *mm) {}
 #endif /* IS_ENABLED(CONFIG_HMM_MIRROR) */
 
-#else /* IS_ENABLED(CONFIG_HMM) */
-static inline void hmm_mm_destroy(struct mm_struct *mm) {}
-static inline void hmm_mm_init(struct mm_struct *mm) {}
-#endif /* IS_ENABLED(CONFIG_HMM) */
-
 #endif /* LINUX_HMM_H */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index f33a1289c101..8d37182f8dbe 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -501,7 +501,7 @@ struct mm_struct {
 #endif
 		struct work_struct async_put_work;
 
-#if IS_ENABLED(CONFIG_HMM)
+#ifdef CONFIG_HMM_MIRROR
 		/* HMM needs to track a few things per mm */
 		struct hmm *hmm;
 #endif
diff --git a/mm/Kconfig b/mm/Kconfig
index 4dbd718c8cf4..7fa785551f96 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -669,37 +669,18 @@ config ZONE_DEVICE
 
 	  If FS_DAX is enabled, then say Y.
 
-config ARCH_HAS_HMM_MIRROR
-	bool
-	default y
-	depends on (X86_64 || PPC64)
-	depends on MMU && 64BIT
-
-config ARCH_HAS_HMM
-	bool
-	depends on (X86_64 || PPC64)
-	depends on ZONE_DEVICE
-	depends on MMU && 64BIT
-	depends on MEMORY_HOTPLUG
-	depends on MEMORY_HOTREMOVE
-	depends on SPARSEMEM_VMEMMAP
-	default y
-
 config MIGRATE_VMA_HELPER
 	bool
 
 config DEV_PAGEMAP_OPS
 	bool
 
-config HMM
-	bool
-	select MMU_NOTIFIER
-	select MIGRATE_VMA_HELPER
-
 config HMM_MIRROR
 	bool "HMM mirror CPU page table into a device page table"
-	depends on ARCH_HAS_HMM
-	select HMM
+	depends on (X86_64 || PPC64)
+	depends on MMU && 64BIT
+	select MMU_NOTIFIER
+	select MIGRATE_VMA_HELPER
 	help
 	  Select HMM_MIRROR if you want to mirror range of the CPU page table of a
 	  process into a device page table. Here, mirror means "keep synchronized".
@@ -719,9 +700,8 @@ config DEVICE_PRIVATE
 
 config DEVICE_PUBLIC
 	bool "Addressable device memory (like GPU memory)"
-	depends on ARCH_HAS_HMM
 	depends on BROKEN
-	select HMM
+	depends on ZONE_DEVICE
 	select DEV_PAGEMAP_OPS
 
 	help
diff --git a/mm/Makefile b/mm/Makefile
index ac5e5ba78874..91c99040065c 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -102,5 +102,5 @@ obj-$(CONFIG_FRAME_VECTOR) += frame_vector.o
 obj-$(CONFIG_DEBUG_PAGE_REF) += debug_page_ref.o
 obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
 obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
-obj-$(CONFIG_HMM) += hmm.o
+obj-$(CONFIG_HMM_MIRROR) += hmm.o
 obj-$(CONFIG_MEMFD_CREATE) += memfd.o
diff --git a/mm/hmm.c b/mm/hmm.c
index 17ed080d9c32..cefeec5c58aa 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -25,7 +25,6 @@
 #include <linux/mmu_notifier.h>
 #include <linux/memory_hotplug.h>
 
-#if IS_ENABLED(CONFIG_HMM_MIRROR)
 static const struct mmu_notifier_ops hmm_mmu_notifier_ops;
 
 static inline struct hmm *mm_get_hmm(struct mm_struct *mm)
@@ -1323,4 +1322,3 @@ long hmm_range_dma_unmap(struct hmm_range *range,
 	return cpages;
 }
 EXPORT_SYMBOL(hmm_range_dma_unmap);
-#endif /* IS_ENABLED(CONFIG_HMM_MIRROR) */
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
