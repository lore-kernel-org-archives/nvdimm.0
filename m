Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 01/10] arch: introduce __pfn_t for persistent memory i/o
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 May 2015 16:04:59 -0400
Message-ID: <20150506200459.40425.80269.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, riel@redhat.com, linux-nvdimm@lists.01.org, mingo@kernel.org, linux-fsdevel@vger.kernel.org, mgorman@suse.de, "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Introduce a type that encapsulates a page-frame-number that is
optionally backed by memmap (struct page).  This type will be used in
place of 'struct page *' instances in contexts where persistent memory
is being referenced (scatterlists for drivers, biovecs for the block
layer, etc).  The operations in those i/o paths that formerly required a
'struct page *' are to be converted to use __pfn_t aware equivalent
helpers.  Otherwise, in the absence of persistent memory, there is no
functional change and __pfn_t is an alias for a normal memory page.

It turns out that while 'struct page' references are used broadly in the
kernel I/O stacks the usage of 'struct page' based capabilities is very
shallow.  It is only used for populating bio_vecs and scatterlists for
the retrieval of dma addresses, and for temporary kernel mappings
(kmap).  Aside from kmap, these usages can be trivially converted to
operate on a pfn.

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
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/asm-generic/memory_model.h |    1 -
 include/asm-generic/pfn.h          |   51 ++++++++++++++++++++++++++++++++++++
 include/linux/mm.h                 |    1 +
 init/Kconfig                       |   13 +++++++++
 4 files changed, 65 insertions(+), 1 deletion(-)
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
index 000000000000..91171e0285d9
--- /dev/null
+++ b/include/asm-generic/pfn.h
@@ -0,0 +1,51 @@
+#ifndef __ASM_PFN_H
+#define __ASM_PFN_H
+
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
+ * biovecs for the block layer, etc).
+ */
+typedef struct {
+	union {
+		unsigned long pfn;
+		struct page *page;
+	};
+} __pfn_t;
+
+static inline struct page *__pfn_t_to_page(__pfn_t pfn)
+{
+#if IS_ENABLED(CONFIG_PMEM_IO)
+	if (pfn.pfn < PAGE_OFFSET)
+		return NULL;
+#endif
+	return pfn.page;
+}
+
+static inline dma_addr_t __pfn_t_to_phys(__pfn_t pfn)
+{
+#if IS_ENABLED(CONFIG_PMEM_IO)
+	if (pfn.pfn < PAGE_OFFSET)
+		return __pfn_to_phys(pfn.pfn);
+#endif
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
index 0755b9fd03a7..9d35cff41c12 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -52,6 +52,7 @@ extern int sysctl_legacy_va_layout;
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
+#include <asm-generic/pfn.h>
 
 #ifndef __pa_symbol
 #define __pa_symbol(x)  __pa(RELOC_HIDE((unsigned long)(x), 0))
diff --git a/init/Kconfig b/init/Kconfig
index dc24dec60232..7d2ad350fd29 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1764,6 +1764,19 @@ config PROFILING
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.
 
+config PMEM_IO
+	default n
+	bool "Support for I/O, DAX, DMA, RDMA to unmapped (persistent) memory" if EXPERT
+	help
+	  Say Y here to enable the Block and Networking stacks to
+	  reference memory that is not mapped.  This is usually the
+	  case if you have large quantities of persistent memory
+	  relative to DRAM.  Enabling this option may increase the
+	  kernel size by a few kilobytes as it instructs the kernel
+	  that a __pfn_t may reference unmapped memory.  Disabling
+	  this option instructs the kernel that a __pfn_t always
+	  references mapped memory.
+
 #
 # Place an empty function call at each tracepoint site. Can be
 # dynamically changed for a probe function.

