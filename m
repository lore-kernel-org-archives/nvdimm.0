Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC2F521A04804
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 12:45:05 -0700 (PDT)
Subject: [PATCH v2] x86,
 uaccess: introduce copy_from_iter_wt for pmem / writethrough
 operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Apr 2017 12:39:12 -0700
Message-ID: <149340820800.28724.16189291963486607562.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20170427063054.soejyqocqqrihfdw@gmail.com>
References: <20170427063054.soejyqocqqrihfdw@gmail.com>
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
To: viro@zeniv.linux.org.uk
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The pmem driver has a need to transfer data with a persistent memory
destination and be able to rely on the fact that the destination writes
are not cached. It is sufficient for the writes to be flushed to a
cpu-store-buffer (non-temporal / "movnt" in x86 terms), as we expect
userspace to call fsync() to ensure data-writes have reached a
power-fail-safe zone in the platform. The fsync() triggers a REQ_FUA or
REQ_FLUSH to the pmem driver which will turn around and fence previous
writes with an "sfence".

Implement a __copy_from_user_inatomic_wt, memcpy_page_wt, and memcpy_wt,
that guarantee that the destination buffer is not dirty in the cpu cache
on completion. The new copy_from_iter_wt and sub-routines will be used
to replace the "pmem api" (include/linux/pmem.h +
arch/x86/include/asm/pmem.h). The availability of copy_from_iter_wt()
and memcpy_wt() are gated by the CONFIG_ARCH_HAS_UACCESS_WT config
symbol, and fallback to copy_from_iter_nocache() and plain memcpy()
otherwise.

This is meant to satisfy the concern from Linus that if a driver wants
to do something beyond the normal nocache semantics it should be
something private to that driver [1], and Al's concern that anything
uaccess related belongs with the rest of the uaccess code [2].

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-January/008364.html
[2]: https://lists.01.org/pipermail/linux-nvdimm/2017-April/009942.html

Cc: <x86@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since the initial RFC:
* s/writethru/wt/ since we already have ioremap_wt(), set_memory_wt(),
  etc. (Ingo)

 arch/x86/Kconfig                  |    1 
 arch/x86/include/asm/string_64.h  |    5 +
 arch/x86/include/asm/uaccess_64.h |   11 +++
 arch/x86/lib/usercopy_64.c        |  128 +++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/core.c          |    3 -
 drivers/nvdimm/claim.c            |    2 -
 drivers/nvdimm/pmem.c             |   13 +++-
 drivers/nvdimm/region_devs.c      |    4 +
 include/linux/dax.h               |    3 +
 include/linux/string.h            |    6 ++
 include/linux/uio.h               |   15 ++++
 lib/Kconfig                       |    3 +
 lib/iov_iter.c                    |   21 ++++++
 13 files changed, 208 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d50fdff77ee..398117923b1c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,6 +54,7 @@ config X86
 	select ARCH_HAS_KCOV			if X86_64
 	select ARCH_HAS_MMIO_FLUSH
 	select ARCH_HAS_PMEM_API		if X86_64
+	select ARCH_HAS_UACCESS_WT		if X86_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_STRICT_KERNEL_RWX
diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 733bae07fb29..dfbd66b11c72 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -109,6 +109,11 @@ memcpy_mcsafe(void *dst, const void *src, size_t cnt)
 	return 0;
 }
 
+#ifdef CONFIG_ARCH_HAS_UACCESS_WT
+#define __HAVE_ARCH_MEMCPY_WT 1
+void memcpy_wt(void *dst, const void *src, size_t cnt);
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_STRING_64_H */
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index c5504b9a472e..07ded30c7e89 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -171,6 +171,10 @@ unsigned long raw_copy_in_user(void __user *dst, const void __user *src, unsigne
 extern long __copy_user_nocache(void *dst, const void __user *src,
 				unsigned size, int zerorest);
 
+extern long __copy_user_wt(void *dst, const void __user *src, unsigned size);
+extern void memcpy_page_wt(char *to, struct page *page, size_t offset,
+			   size_t len);
+
 static inline int
 __copy_from_user_inatomic_nocache(void *dst, const void __user *src,
 				  unsigned size)
@@ -179,6 +183,13 @@ __copy_from_user_inatomic_nocache(void *dst, const void __user *src,
 	return __copy_user_nocache(dst, src, size, 0);
 }
 
+static inline int
+__copy_from_user_inatomic_wt(void *dst, const void __user *src, unsigned size)
+{
+	kasan_check_write(dst, size);
+	return __copy_user_wt(dst, src, size);
+}
+
 unsigned long
 copy_user_handle_tail(char *to, char *from, unsigned len);
 
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 3b7c40a2e3e1..0aeff66a022f 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -7,6 +7,7 @@
  */
 #include <linux/export.h>
 #include <linux/uaccess.h>
+#include <linux/highmem.h>
 
 /*
  * Zero Userspace
@@ -73,3 +74,130 @@ copy_user_handle_tail(char *to, char *from, unsigned len)
 	clac();
 	return len;
 }
+
+#ifdef CONFIG_ARCH_HAS_UACCESS_WT
+/**
+ * clean_cache_range - write back a cache range with CLWB
+ * @vaddr:	virtual start address
+ * @size:	number of bytes to write back
+ *
+ * Write back a cache range using the CLWB (cache line write back)
+ * instruction. Note that @size is internally rounded up to be cache
+ * line size aligned.
+ */
+static void clean_cache_range(void *addr, size_t size)
+{
+	u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
+	unsigned long clflush_mask = x86_clflush_size - 1;
+	void *vend = addr + size;
+	void *p;
+
+	for (p = (void *)((unsigned long)addr & ~clflush_mask);
+	     p < vend; p += x86_clflush_size)
+		clwb(p);
+}
+
+long __copy_user_wt(void *dst, const void __user *src, unsigned size)
+{
+	unsigned long flushed, dest = (unsigned long) dst;
+	long rc = __copy_user_nocache(dst, src, size, 0);
+
+	/*
+	 * __copy_user_nocache() uses non-temporal stores for the bulk
+	 * of the transfer, but we need to manually flush if the
+	 * transfer is unaligned. A cached memory copy is used when
+	 * destination or size is not naturally aligned. That is:
+	 *   - Require 8-byte alignment when size is 8 bytes or larger.
+	 *   - Require 4-byte alignment when size is 4 bytes.
+	 */
+	if (size < 8) {
+		if (!IS_ALIGNED(dest, 4) || size != 4)
+			clean_cache_range(dst, 1);
+	} else {
+		if (!IS_ALIGNED(dest, 8)) {
+			dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);
+			clean_cache_range(dst, 1);
+		}
+
+		flushed = dest - (unsigned long) dst;
+		if (size > flushed && !IS_ALIGNED(size - flushed, 8))
+			clean_cache_range(dst + size - 1, 1);
+	}
+
+	return rc;
+}
+
+void memcpy_wt(void *_dst, const void *_src, size_t size)
+{
+	unsigned long dest = (unsigned long) _dst;
+	unsigned long source = (unsigned long) _src;
+
+	/* cache copy and flush to align dest */
+	if (!IS_ALIGNED(dest, 8)) {
+		unsigned len = min_t(unsigned, size, ALIGN(dest, 8) - dest);
+
+		memcpy((void *) dest, (void *) source, len);
+		clean_cache_range((void *) dest, len);
+		dest += len;
+		source += len;
+		size -= len;
+		if (!size)
+			return;
+	}
+
+	/* 4x8 movnti loop */
+	while (size >= 32) {
+		asm("movq    (%0), %%r8\n"
+		    "movq   8(%0), %%r9\n"
+		    "movq  16(%0), %%r10\n"
+		    "movq  24(%0), %%r11\n"
+		    "movnti  %%r8,   (%1)\n"
+		    "movnti  %%r9,  8(%1)\n"
+		    "movnti %%r10, 16(%1)\n"
+		    "movnti %%r11, 24(%1)\n"
+		    :: "r" (source), "r" (dest)
+		    : "memory", "r8", "r9", "r10", "r11");
+		dest += 32;
+		source += 32;
+		size -= 32;
+	}
+
+	/* 1x8 movnti loop */
+	while (size >= 8) {
+		asm("movq    (%0), %%r8\n"
+		    "movnti  %%r8,   (%1)\n"
+		    :: "r" (source), "r" (dest)
+		    : "memory", "r8");
+		dest += 8;
+		source += 8;
+		size -= 8;
+	}
+
+	/* 1x4 movnti loop */
+	while (size >= 4) {
+		asm("movl    (%0), %%r8d\n"
+		    "movnti  %%r8d,   (%1)\n"
+		    :: "r" (source), "r" (dest)
+		    : "memory", "r8");
+		dest += 4;
+		source += 4;
+		size -= 4;
+	}
+
+	/* cache copy for remaining bytes */
+	if (size) {
+		memcpy((void *) dest, (void *) source, size);
+		clean_cache_range((void *) dest, size);
+	}
+}
+EXPORT_SYMBOL_GPL(memcpy_wt);
+
+void memcpy_page_wt(char *to, struct page *page, size_t offset,
+		size_t len)
+{
+	char *from = kmap_atomic(page);
+
+	memcpy_wt(to, from + offset, len);
+	kunmap_atomic(from);
+}
+#endif
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index d0c07b2344e4..be9bba609f26 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1776,8 +1776,7 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 		}
 
 		if (rw)
-			memcpy_to_pmem(mmio->addr.aperture + offset,
-					iobuf + copied, c);
+			memcpy_wt(mmio->addr.aperture + offset, iobuf + copied, c);
 		else {
 			if (nfit_blk->dimm_flags & NFIT_BLK_READ_FLUSH)
 				mmio_flush_range((void __force *)
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 3a35e8028b9c..864ed42baaf0 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -266,7 +266,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 			rc = -EIO;
 	}
 
-	memcpy_to_pmem(nsio->addr + offset, buf, size);
+	memcpy_wt(nsio->addr + offset, buf, size);
 	nvdimm_flush(to_nd_region(ndns->dev.parent));
 
 	return rc;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 3b3dab73d741..4be8f30de9b3 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -28,6 +28,7 @@
 #include <linux/pfn_t.h>
 #include <linux/slab.h>
 #include <linux/pmem.h>
+#include <linux/uio.h>
 #include <linux/dax.h>
 #include <linux/nd.h>
 #include "pmem.h"
@@ -79,7 +80,7 @@ static void write_pmem(void *pmem_addr, struct page *page,
 {
 	void *mem = kmap_atomic(page);
 
-	memcpy_to_pmem(pmem_addr, mem + off, len);
+	memcpy_wt(pmem_addr, mem + off, len);
 	kunmap_atomic(mem);
 }
 
@@ -234,8 +235,15 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
 	return __pmem_direct_access(pmem, pgoff, nr_pages, kaddr, pfn);
 }
 
+static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	return copy_from_iter_wt(addr, bytes, i);
+}
+
 static const struct dax_operations pmem_dax_ops = {
 	.direct_access = pmem_dax_direct_access,
+	.copy_from_iter = pmem_copy_from_iter,
 };
 
 static void pmem_release_queue(void *q)
@@ -288,7 +296,8 @@ static int pmem_attach_disk(struct device *dev,
 	dev_set_drvdata(dev, pmem);
 	pmem->phys_addr = res->start;
 	pmem->size = resource_size(res);
-	if (nvdimm_has_flush(nd_region) < 0)
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_UACCESS_WT)
+			|| nvdimm_has_flush(nd_region) < 0)
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index b7cb5066d961..016af2a6694d 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -947,8 +947,8 @@ void nvdimm_flush(struct nd_region *nd_region)
 	 * The first wmb() is needed to 'sfence' all previous writes
 	 * such that they are architecturally visible for the platform
 	 * buffer flush.  Note that we've already arranged for pmem
-	 * writes to avoid the cache via arch_memcpy_to_pmem().  The
-	 * final wmb() ensures ordering for the NVDIMM flush write.
+	 * writes to avoid the cache via memcpy_wt().  The final wmb()
+	 * ensures ordering for the NVDIMM flush write.
 	 */
 	wmb();
 	for (i = 0; i < nd_region->ndr_mappings; i++)
diff --git a/include/linux/dax.h b/include/linux/dax.h
index d3158e74a59e..156f067d4db5 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -16,6 +16,9 @@ struct dax_operations {
 	 */
 	long (*direct_access)(struct dax_device *, pgoff_t, long,
 			void **, pfn_t *);
+	/* copy_from_iter: dax-driver override for default copy_from_iter */
+	size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
+			struct iov_iter *);
 };
 
 int dax_read_lock(void);
diff --git a/include/linux/string.h b/include/linux/string.h
index 9d6f189157e2..245e0a29b7e5 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -122,6 +122,12 @@ static inline __must_check int memcpy_mcsafe(void *dst, const void *src,
 	return 0;
 }
 #endif
+#ifndef __HAVE_ARCH_MEMCPY_WT
+static inline void memcpy_wt(void *dst, const void *src, size_t cnt)
+{
+	memcpy(dst, src, cnt);
+}
+#endif
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *s, char old, char new);
 
diff --git a/include/linux/uio.h b/include/linux/uio.h
index f2d36a3d3005..30c43aa371b5 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -95,6 +95,21 @@ size_t copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
 size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i);
 bool copy_from_iter_full(void *addr, size_t bytes, struct iov_iter *i);
 size_t copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i);
+#ifdef CONFIG_ARCH_HAS_UACCESS_WT
+/*
+ * Note, users like pmem that depend on the stricter semantics of
+ * copy_from_iter_wt() than copy_from_iter_nocache() must check
+ * for IS_ENABLED(CONFIG_ARCH_HAS_UACCESS_WRITETHROUGH) before assuming
+ * that the destination is flushed from the cache on return.
+ */
+size_t copy_from_iter_wt(void *addr, size_t bytes, struct iov_iter *i);
+#else
+static inline size_t copy_from_iter_wt(void *addr, size_t bytes,
+				       struct iov_iter *i)
+{
+	return copy_from_iter_nocache(addr, bytes, i);
+}
+#endif
 bool copy_from_iter_full_nocache(void *addr, size_t bytes, struct iov_iter *i);
 size_t iov_iter_zero(size_t bytes, struct iov_iter *);
 unsigned long iov_iter_alignment(const struct iov_iter *i);
diff --git a/lib/Kconfig b/lib/Kconfig
index 0c8b78a9ae2e..f0752a7a9001 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -548,6 +548,9 @@ config ARCH_HAS_SG_CHAIN
 config ARCH_HAS_PMEM_API
 	bool
 
+config ARCH_HAS_UACCESS_WT
+	bool
+
 config ARCH_HAS_MMIO_FLUSH
 	bool
 
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index f7c93568ec99..19ab9af091f9 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -615,6 +615,27 @@ size_t copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i)
 }
 EXPORT_SYMBOL(copy_from_iter_nocache);
 
+#ifdef CONFIG_ARCH_HAS_UACCESS_WT
+size_t copy_from_iter_wt(void *addr, size_t bytes, struct iov_iter *i)
+{
+	char *to = addr;
+	if (unlikely(i->type & ITER_PIPE)) {
+		WARN_ON(1);
+		return 0;
+	}
+	iterate_and_advance(i, bytes, v,
+		__copy_from_user_inatomic_wt((to += v.iov_len) - v.iov_len,
+					 v.iov_base, v.iov_len),
+		memcpy_page_wt((to += v.bv_len) - v.bv_len, v.bv_page,
+				 v.bv_offset, v.bv_len),
+		memcpy_wt((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
+	)
+
+	return bytes;
+}
+EXPORT_SYMBOL_GPL(copy_from_iter_wt);
+#endif
+
 bool copy_from_iter_full_nocache(void *addr, size_t bytes, struct iov_iter *i)
 {
 	char *to = addr;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
