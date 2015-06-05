Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 1/9] introduce __pfn_t for scatterlists and pmem
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 05 Jun 2015 17:19:06 -0400
Message-ID: <20150605211906.20751.59875.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, arnd@arndb.de, ross.zwisler@linux.intel.com, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, hch@lst.de, schwidefsky@de.ibm.com, paulus@samba.org, hpa@zytor.com, tj@kernel.org, willy@linux.intel.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Introduce a type that encapsulates a page-frame-number that can also be
used to encode other information.  This other information is the
traditional "page_link" encoding in a scatterlist, but can also denote
"device memory".  Where "device memory" is a set of pfns that are not
part of the kernel's linear mapping, but are accessed via the same
memory controller as ram.  The motivation for this conversion is large
capacity persistent memory that does not enjoy struct page coverage,
entries in memmap, by default.

This type will be used in replace usage of 'struct page *' in cases
where only a pfn is required, i.e. scatterlists for drivers, dma mapping
api, and later biovecs for the block layer.  The operations in those i/o
paths that formerly required a 'struct page *' are converted to
use __pfn_t aware equivalent helpers.  The goal is that existing use
cases of data structures referencing struct page are binary identical to
the __pfn_t converted type.  Only new use cases for pmem will require
the new __pfn_t helper routines, i.e. __pfn_t is a struct page alias in
the absence of pmem.

It turns out that while 'struct page' references are used broadly in the
kernel I/O stacks the usage of 'struct page' based capabilities is very
shallow for block-i/o.  It is only used for populating bio_vecs and
scatterlists for the retrieval of dma addresses, and for temporary
kernel mappings (kmap).  Aside from kmap, these usages can be trivially
converted to operate on a pfn.

Indeed, kmap_atomic() is more problematic as it uses mm infrastructure,
via struct page, to setup and track temporary kernel mappings.  It would
be unfortunate if the kmap infrastructure escaped its 32-bit/HIGHMEM
bonds and leaked into 64-bit code.  Thankfully, it seems all that is
needed here is to convert kmap_atomic() callers, that want to opt-in to
supporting persistent memory, to use a new kmap_atomic_pfn_t().  Where
kmap_atomic_pfn_t() is enabled to re-use the existing ioremap() mapping
established by the driver for persistent memory.

Note, that as far as conceptually understanding __pfn_t is concerned,
'persistent memory' is really any address range in host memory not
covered by memmap.  Contrast this with pure iomem that is on an mmio
mapped bus like PCI and cannot be converted to a dma_addr_t by "pfn <<
PAGE_SHIFT".

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/asm-generic/memory_model.h |    1 
 include/asm-generic/pfn.h          |   86 ++++++++++++++++++++++++++++++++++++
 include/linux/mm.h                 |    1 
 init/Kconfig                       |   13 +++++
 4 files changed, 100 insertions(+), 1 deletion(-)
 create mode 100644 include/asm-generic/pfn.h

diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
index 14909b0b9cae..1b0ae21fd8ff 100644
--- a/include/asm-generic/memory_model.h
+++ b/include/asm-generic/memory_model.h
@@ -70,7 +70,6 @@
 #endif /* CONFIG_FLATMEM/DISCONTIGMEM/SPARSEMEM */
 
 #define page_to_pfn __page_to_pfn
-#define pfn_to_page __pfn_to_page
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/include/asm-generic/pfn.h b/include/asm-generic/pfn.h
new file mode 100644
index 000000000000..2f4ae40dc6a7
--- /dev/null
+++ b/include/asm-generic/pfn.h
@@ -0,0 +1,86 @@
+#ifndef __ASM_PFN_H
+#define __ASM_PFN_H
+
+/*
+ * Default pfn to physical address conversion, like most arch
+ * page_to_phys() implementations this resolves to a dma_addr_t as it
+ * should be the size needed for a device to reference this address.
+ */
+#ifndef __pfn_to_phys
+#define __pfn_to_phys(pfn)      ((dma_addr_t)(pfn) << PAGE_SHIFT)
+#endif
+
+static inline struct page *pfn_to_page(unsigned long pfn)
+{
+	return __pfn_to_page(pfn);
+}
+
+/*
+ * __pfn_t: encapsulates a page-frame number that is optionally backed
+ * by memmap (struct page).  This type will be used in place of a
+ * 'struct page *' instance in contexts where unmapped memory (usually
+ * persistent memory) is being referenced (scatterlists for drivers,
+ * biovecs for the block layer, etc).  Whether a __pfn_t has a struct
+ * page backing is indicated by flags in the low bits of @data.
+ */
+typedef struct {
+	union {
+		unsigned long data;
+		struct page *page;
+	};
+} __pfn_t;
+
+enum {
+#if BITS_PER_LONG == 64
+	PFN_SHIFT = 3,
+	/* device-pfn not covered by memmap */
+	PFN_DEV = (1UL << 2),
+#else
+	PFN_SHIFT = 2,
+#endif
+	PFN_MASK = (1UL << PFN_SHIFT) - 1,
+	PFN_SG_CHAIN = (1UL << 0),
+	PFN_SG_LAST = (1UL << 1),
+};
+
+#ifdef CONFIG_DEV_PFN
+static inline bool __pfn_t_has_page(__pfn_t pfn)
+{
+	return (pfn.data & PFN_MASK) == 0;
+}
+
+#else
+static inline bool __pfn_t_has_page(__pfn_t pfn)
+{
+	return true;
+}
+#endif
+
+static inline struct page *__pfn_t_to_page(__pfn_t pfn)
+{
+	if (!__pfn_t_has_page(pfn))
+		return NULL;
+	return pfn.page;
+}
+
+static inline unsigned long __pfn_t_to_pfn(__pfn_t pfn)
+{
+	if (__pfn_t_has_page(pfn))
+		return page_to_pfn(pfn.page);
+	return pfn.data >> PFN_SHIFT;
+}
+
+static inline dma_addr_t __pfn_t_to_phys(__pfn_t pfn)
+{
+	if (!__pfn_t_has_page(pfn))
+		return __pfn_to_phys(__pfn_t_to_pfn(pfn));
+	return __pfn_to_phys(page_to_pfn(pfn.page));
+}
+
+static inline __pfn_t page_to_pfn_t(struct page *page)
+{
+	__pfn_t pfn = { .page = page };
+
+	return pfn;
+}
+#endif /* __ASM_PFN_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4024543b4203..ae6f9965f3dd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -53,6 +53,7 @@ extern int sysctl_legacy_va_layout;
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
+#include <asm-generic/pfn.h>
 
 #ifndef __pa_symbol
 #define __pa_symbol(x)  __pa(RELOC_HIDE((unsigned long)(x), 0))
diff --git a/init/Kconfig b/init/Kconfig
index d4f763332f9f..907ab91a5557 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1769,6 +1769,19 @@ config PROFILING
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.
 
+config DEV_PFN
+	depends on 64BIT
+	bool "Support for device provided (pmem, graphics, etc) memory" if EXPERT
+	help
+	  Say Y here to enable I/O to/from device provided memory,
+	  i.e.  reference memory that is not mapped.  This is usually
+	  the case if you have large quantities of persistent memory
+	  relative to DRAM.  Enabling this option may increase the
+	  kernel size by a few kilobytes as it instructs the kernel
+	  that a __pfn_t may reference unmapped memory.  Disabling
+	  this option instructs the kernel that a __pfn_t always
+	  references mapped platform memory.
+
 #
 # Place an empty function call at each tracepoint site. Can be
 # dynamically changed for a probe function.

