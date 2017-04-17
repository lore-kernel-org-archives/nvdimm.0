Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C971F21939248
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 12:17:05 -0700 (PDT)
Subject: [resend PATCH v2 28/33] x86, libnvdimm,
 dax: stop abusing __copy_user_nocache
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Apr 2017 12:11:21 -0700
Message-ID: <149245628098.10206.16202709432908862265.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The pmem and nd_blk drivers both have need to copy data through the cpu
cache to persistent memory. To date they have been abusing
__copy_user_nocache through the memcpy_to_pmem abstraction, but this has
several problems:

* __copy_user_nocache does not guarantee that it will always avoid the
  cache. While we have fixed the cases where the pmem usage might
  trigger that behavior it's a fragile assumption and burdens the
  uaccess.h implementation with worrying about the distinction between
  'nocache' and the stricter write-through semantic needed by pmem.
  Quoting Linus: "Quite frankly, the whole "memcpy_nocache()" idea or
  (ab-)using copy_user_nocache() just needs to die. ... If some driver
  ends up using "movnt" by hand, that is up to that *driver*."

* It implements SMAP (supervisor mode access protection) which is only
  meant for user copies.

* It expects faults. For in-kernel copies, faults are fatal and we
  should not be coding for exception handling in that case.

__arch_memcpy_to_pmem() is effectively a copy of __copy_user_nocache()
minus SMAP, unaligned support, and exception handling. The configuration
symbol ARCH_HAS_PMEM_API is also moved local to libnvdimm to be next to
the implementation.

Cc: <x86@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oliver O'Halloran <oohall@gmail.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 MAINTAINERS                     |    2 -
 arch/x86/Kconfig                |    1 -
 arch/x86/include/asm/pmem.h     |   48 -----------------------------
 drivers/acpi/nfit/core.c        |    3 +-
 drivers/nvdimm/Kconfig          |    4 ++
 drivers/nvdimm/claim.c          |    4 +-
 drivers/nvdimm/namespace_devs.c |    1 -
 drivers/nvdimm/pmem.c           |    4 +-
 drivers/nvdimm/region_devs.c    |    1 -
 drivers/nvdimm/x86.c            |   65 +++++++++++++++++++++++++++++++++++++++
 fs/dax.c                        |    1 -
 include/linux/libnvdimm.h       |    9 +++++
 include/linux/pmem.h            |   59 -----------------------------------
 lib/Kconfig                     |    3 --
 14 files changed, 83 insertions(+), 122 deletions(-)
 delete mode 100644 arch/x86/include/asm/pmem.h
 delete mode 100644 include/linux/pmem.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 819d5e8b668a..1c4da1bebd7c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7458,8 +7458,6 @@ L:	linux-nvdimm@lists.01.org
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 S:	Supported
 F:	drivers/nvdimm/pmem.c
-F:	include/linux/pmem.h
-F:	arch/*/include/asm/pmem.h
 
 LIGHTNVM PLATFORM SUPPORT
 M:	Matias Bjorling <mb@lightnvm.io>
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc98d5a294ee..d377da696903 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -53,7 +53,6 @@ config X86
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV			if X86_64
 	select ARCH_HAS_MMIO_FLUSH
-	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_STRICT_KERNEL_RWX
diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
deleted file mode 100644
index ded2541a7ba9..000000000000
--- a/arch/x86/include/asm/pmem.h
+++ /dev/null
@@ -1,48 +0,0 @@
-/*
- * Copyright(c) 2015 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-#ifndef __ASM_X86_PMEM_H__
-#define __ASM_X86_PMEM_H__
-
-#include <linux/uaccess.h>
-#include <asm/cacheflush.h>
-#include <asm/cpufeature.h>
-#include <asm/special_insns.h>
-
-#ifdef CONFIG_ARCH_HAS_PMEM_API
-/**
- * arch_memcpy_to_pmem - copy data to persistent memory
- * @dst: destination buffer for the copy
- * @src: source buffer for the copy
- * @n: length of the copy in bytes
- *
- * Copy data to persistent memory media via non-temporal stores so that
- * a subsequent pmem driver flush operation will drain posted write queues.
- */
-static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
-{
-	int rem;
-
-	/*
-	 * We are copying between two kernel buffers, if
-	 * __copy_from_user_inatomic_nocache() returns an error (page
-	 * fault) we would have already reported a general protection fault
-	 * before the WARN+BUG.
-	 */
-	rem = __copy_from_user_inatomic_nocache(dst, (void __user *) src, n);
-	if (WARN(rem, "%s: fault copying %p <- %p unwritten: %d\n",
-				__func__, dst, src, rem))
-		BUG();
-}
-
-#endif /* CONFIG_ARCH_HAS_PMEM_API */
-#endif /* __ASM_X86_PMEM_H__ */
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index d0c07b2344e4..8b4c6212737c 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -20,7 +20,6 @@
 #include <linux/list.h>
 #include <linux/acpi.h>
 #include <linux/sort.h>
-#include <linux/pmem.h>
 #include <linux/io.h>
 #include <linux/nd.h>
 #include <asm/cacheflush.h>
@@ -1776,7 +1775,7 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 		}
 
 		if (rw)
-			memcpy_to_pmem(mmio->addr.aperture + offset,
+			arch_memcpy_to_pmem(mmio->addr.aperture + offset,
 					iobuf + copied, c);
 		else {
 			if (nfit_blk->dimm_flags & NFIT_BLK_READ_FLUSH)
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 5bdd499b5f4f..4d45196d6f94 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -36,6 +36,10 @@ config BLK_DEV_PMEM
 
 	  Say Y if you want to use an NVDIMM
 
+config ARCH_HAS_PMEM_API
+	depends on X86_64
+	def_bool y
+
 config ND_BLK
 	tristate "BLK: Block data window (aperture) device support"
 	default LIBNVDIMM
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 1e13a196ce4b..0b222c8ce1d8 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -10,9 +10,9 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+#include <linux/libnvdimm.h>
 #include <linux/device.h>
 #include <linux/sizes.h>
-#include <linux/pmem.h>
 #include "nd-core.h"
 #include "pmem.h"
 #include "pfn.h"
@@ -267,7 +267,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 			rc = -EIO;
 	}
 
-	memcpy_to_pmem(nsio->addr + offset, buf, size);
+	arch_memcpy_to_pmem(nsio->addr + offset, buf, size);
 	nvdimm_flush(to_nd_region(ndns->dev.parent));
 
 	return rc;
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 1b481a5fb966..2580f6655bea 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -14,7 +14,6 @@
 #include <linux/device.h>
 #include <linux/sort.h>
 #include <linux/slab.h>
-#include <linux/pmem.h>
 #include <linux/list.h>
 #include <linux/nd.h>
 #include "nd-core.h"
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 769a510c20e8..329895ca88e1 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -27,8 +27,8 @@
 #include <linux/vmalloc.h>
 #include <linux/pfn_t.h>
 #include <linux/slab.h>
-#include <linux/pmem.h>
 #include <linux/dax.h>
+#include <linux/uio.h>
 #include <linux/nd.h>
 #include "pmem.h"
 #include "pfn.h"
@@ -79,7 +79,7 @@ static void write_pmem(void *pmem_addr, struct page *page,
 {
 	void *mem = kmap_atomic(page);
 
-	memcpy_to_pmem(pmem_addr, mem + off, len);
+	arch_memcpy_to_pmem(pmem_addr, mem + off, len);
 	kunmap_atomic(mem);
 }
 
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index b7cb5066d961..307a48060aa3 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -15,7 +15,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
-#include <linux/pmem.h>
 #include <linux/sort.h>
 #include <linux/io.h>
 #include <linux/nd.h>
diff --git a/drivers/nvdimm/x86.c b/drivers/nvdimm/x86.c
index 07478ed7ce97..d99b452332a9 100644
--- a/drivers/nvdimm/x86.c
+++ b/drivers/nvdimm/x86.c
@@ -40,3 +40,68 @@ void arch_invalidate_pmem(void *addr, size_t size)
 	clflush_cache_range(addr, size);
 }
 EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
+
+void arch_memcpy_to_pmem(void *_dst, void *_src, unsigned size)
+{
+	unsigned long dest = (unsigned long) _dst;
+	unsigned long source = (unsigned long) _src;
+
+	/* cache copy and flush to align dest */
+	if (!IS_ALIGNED(dest, 8)) {
+		unsigned len = min_t(unsigned, size, ALIGN(dest, 8) - dest);
+
+		memcpy((void *) dest, (void *) source, len);
+		arch_wb_cache_pmem((void *) dest, len);
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
+		arch_wb_cache_pmem((void *) dest, size);
+	}
+}
+EXPORT_SYMBOL_GPL(arch_memcpy_to_pmem);
diff --git a/fs/dax.c b/fs/dax.c
index edee7e8298bc..f37ed21e4093 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/pagevec.h>
-#include <linux/pmem.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/uio.h>
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 77e7af32543f..a98004745768 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -162,4 +162,13 @@ void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
 u64 nd_fletcher64(void *addr, size_t len, bool le);
 void nvdimm_flush(struct nd_region *nd_region);
 int nvdimm_has_flush(struct nd_region *nd_region);
+#ifdef CONFIG_ARCH_HAS_PMEM_API
+void arch_memcpy_to_pmem(void *dst, void *src, unsigned size);
+#define ARCH_MEMREMAP_PMEM MEMREMAP_WB
+#else
+static inline void arch_memcpy_to_pmem(void *dst, void *src, unsigned size)
+{
+}
+#define ARCH_MEMREMAP_PMEM MEMREMAP_WT
+#endif /* CONFIG_ARCH_HAS_PMEM_API */
 #endif /* __LIBNVDIMM_H__ */
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
deleted file mode 100644
index 559c00848583..000000000000
--- a/include/linux/pmem.h
+++ /dev/null
@@ -1,59 +0,0 @@
-/*
- * Copyright(c) 2015 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-#ifndef __PMEM_H__
-#define __PMEM_H__
-
-#include <linux/io.h>
-#include <linux/uio.h>
-
-#ifdef CONFIG_ARCH_HAS_PMEM_API
-#define ARCH_MEMREMAP_PMEM MEMREMAP_WB
-#include <asm/pmem.h>
-#else
-#define ARCH_MEMREMAP_PMEM MEMREMAP_WT
-/*
- * These are simply here to enable compilation, all call sites gate
- * calling these symbols with arch_has_pmem_api() and redirect to the
- * implementation in asm/pmem.h.
- */
-static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
-{
-	BUG();
-}
-#endif
-
-static inline bool arch_has_pmem_api(void)
-{
-	return IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API);
-}
-
-/**
- * memcpy_to_pmem - copy data to persistent memory
- * @dst: destination buffer for the copy
- * @src: source buffer for the copy
- * @n: length of the copy in bytes
- *
- * Perform a memory copy that results in the destination of the copy
- * being effectively evicted from, or never written to, the processor
- * cache hierarchy after the copy completes.  After memcpy_to_pmem()
- * data may still reside in cpu or platform buffers, so this operation
- * must be followed by a blkdev_issue_flush() on the pmem block device.
- */
-static inline void memcpy_to_pmem(void *dst, const void *src, size_t n)
-{
-	if (arch_has_pmem_api())
-		arch_memcpy_to_pmem(dst, src, n);
-	else
-		memcpy(dst, src, n);
-}
-#endif /* __PMEM_H__ */
diff --git a/lib/Kconfig b/lib/Kconfig
index 0c8b78a9ae2e..0c4aac6ef394 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -545,9 +545,6 @@ config SG_POOL
 config ARCH_HAS_SG_CHAIN
 	def_bool n
 
-config ARCH_HAS_PMEM_API
-	bool
-
 config ARCH_HAS_MMIO_FLUSH
 	bool
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
