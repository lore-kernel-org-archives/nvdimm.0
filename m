Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 2/9] x86: support kmap_atomic_pfn_t() for persistent
 memory
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 05 Jun 2015 17:19:12 -0400
Message-ID: <20150605211912.20751.35406.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, arnd@arndb.de, ross.zwisler@linux.intel.com, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, hch@lst.de, tj@kernel.org, paulus@samba.org, hpa@zytor.com, schwidefsky@de.ibm.com, willy@linux.intel.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

It would be unfortunate if the kmap infrastructure escaped its current
32-bit/HIGHMEM bonds and leaked into 64-bit code.  Instead, if the user
has enabled CONFIG_DEV_PFN we direct the kmap_atomic_pfn_t()
implementation to scan a list of pre-mapped persistent memory address
ranges inserted by the pmem driver.

The __pfn_t to resource lookup is indeed inefficient walking of a linked list,
but there are two mitigating factors:

1/ The number of persistent memory ranges is bounded by the number of
   DIMMs which is on the order of 10s of DIMMs, not hundreds.

2/ The lookup yields the entire range, if it becomes inefficient to do a
   kmap_atomic_pfn_t() a PAGE_SIZE at a time the caller can take
   advantage of the fact that the lookup can be amortized for all kmap
   operations it needs to perform in a given range.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/Kconfig            |    3 +
 arch/x86/Kconfig        |    5 ++
 include/linux/highmem.h |   23 +++++++++++
 mm/Makefile             |    1 
 mm/pfn.c                |   98 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 130 insertions(+)
 create mode 100644 mm/pfn.c

diff --git a/arch/Kconfig b/arch/Kconfig
index a65eafb24997..9b98732e0f3b 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -203,6 +203,9 @@ config HAVE_DMA_ATTRS
 config HAVE_DMA_CONTIGUOUS
 	bool
 
+config HAVE_KMAP_PFN
+	bool
+
 config GENERIC_SMP_IDLE_THREAD
        bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 226d5696e1d1..130d1a4c2efc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1432,6 +1432,11 @@ config X86_PMEM_LEGACY
 
 	  Say Y if unsure.
 
+config X86_PMEM_DMA
+	depends on !HIGHMEM
+	def_bool DEV_PFN
+	select HAVE_KMAP_PFN
+
 config HIGHPTE
 	bool "Allocate 3rd-level pagetables from highmem"
 	depends on HIGHMEM
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 9286a46b7d69..85fd52d43a9a 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -83,6 +83,29 @@ static inline void __kunmap_atomic(void *addr)
 
 #endif /* CONFIG_HIGHMEM */
 
+#ifdef CONFIG_HAVE_KMAP_PFN
+extern void *kmap_atomic_pfn_t(__pfn_t pfn);
+extern void kunmap_atomic_pfn_t(void *addr);
+extern int devm_register_kmap_pfn_range(struct device *dev,
+		struct resource *res, void *base);
+#else
+static inline void *kmap_atomic_pfn_t(__pfn_t pfn)
+{
+	return kmap_atomic(__pfn_t_to_page(pfn));
+}
+
+static inline void kunmap_atomic_pfn_t(void *addr)
+{
+	__kunmap_atomic(addr);
+}
+
+static inline int devm_register_kmap_pfn_range(struct device *dev,
+		struct resource *res, void *base)
+{
+	return 0;
+}
+#endif /* CONFIG_HAVE_KMAP_PFN */
+
 #if defined(CONFIG_HIGHMEM) || defined(CONFIG_X86_32)
 
 DECLARE_PER_CPU(int, __kmap_atomic_idx);
diff --git a/mm/Makefile b/mm/Makefile
index 98c4eaeabdcb..66e30c2addfe 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -78,3 +78,4 @@ obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
+obj-$(CONFIG_HAVE_KMAP_PFN) += pfn.o
diff --git a/mm/pfn.c b/mm/pfn.c
new file mode 100644
index 000000000000..0e046b49aebf
--- /dev/null
+++ b/mm/pfn.c
@@ -0,0 +1,98 @@
+/*
+ * Copyright(c) 2015 Intel Corporation. All rights reserved.
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
+#include <linux/rcupdate.h>
+#include <linux/rculist.h>
+#include <linux/highmem.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+
+static LIST_HEAD(ranges);
+
+struct kmap {
+	struct list_head list;
+	struct resource *res;
+	struct device *dev;
+	void *base;
+};
+
+static void teardown_kmap(void *data)
+{
+	struct kmap *kmap = data;
+
+	dev_dbg(kmap->dev, "kmap unregister %pr\n", kmap->res);
+	list_del_rcu(&kmap->list);
+	synchronize_rcu();
+	kfree(kmap);
+}
+
+int devm_register_kmap_pfn_range(struct device *dev, struct resource *res,
+		void *base)
+{
+	struct kmap *kmap = kzalloc(sizeof(*kmap), GFP_KERNEL);
+	int rc;
+
+	if (!kmap)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&kmap->list);
+	kmap->res = res;
+	kmap->base = base;
+	kmap->dev = dev;
+	rc = devm_add_action(dev, teardown_kmap, kmap);
+	if (rc) {
+		kfree(kmap);
+		return rc;
+	}
+	dev_dbg(kmap->dev, "kmap register %pr\n", kmap->res);
+	list_add_rcu(&kmap->list, &ranges);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_register_kmap_pfn_range);
+
+void *kmap_atomic_pfn_t(__pfn_t pfn)
+{
+	struct page *page = __pfn_t_to_page(pfn);
+	resource_size_t addr;
+	struct kmap *kmap;
+
+	if (page)
+		return kmap_atomic(page);
+	addr = __pfn_t_to_phys(pfn);
+	rcu_read_lock();
+	list_for_each_entry_rcu(kmap, &ranges, list)
+		if (addr >= kmap->res->start && addr <= kmap->res->end)
+			return kmap->base + addr - kmap->res->start;
+
+	/* only unlock in the error case */
+	rcu_read_unlock();
+	return NULL;
+}
+EXPORT_SYMBOL(kmap_atomic_pfn_t);
+
+void kunmap_atomic_pfn_t(void *addr)
+{
+	/*
+	 * If the original __pfn_t had an entry in the memmap then
+	 * 'addr' will be outside of vmalloc space i.e. it came from
+	 * page_address()
+	 */
+	if (!is_vmalloc_addr(addr)) {
+		kunmap_atomic(addr);
+		return;
+	}
+
+	/* signal that we are done with the range */
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(kunmap_atomic_pfn_t);

