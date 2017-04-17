Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B2ED221939248
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 12:16:11 -0700 (PDT)
Subject: [resend PATCH v2 18/33] x86, dax,
 pmem: remove indirection around memcpy_from_pmem()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Apr 2017 12:10:27 -0700
Message-ID: <149245622727.10206.9207175325089032123.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

memcpy_from_pmem() maps directly to memcpy_mcsafe(). The wrapper
serves no real benefit aside from affording a more generic function name
than the x86-specific 'mcsafe'. However this would not be the first time
that x86 terminology leaked into the global namespace. For lack of
better name, just use memcpy_mcsafe() directly.

This conversion also catches a place where we should have been using
plain memcpy, acpi_nfit_blk_single_io().

Cc: <x86@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/pmem.h      |    5 -----
 arch/x86/include/asm/string_64.h |    1 +
 drivers/acpi/nfit/core.c         |    3 +--
 drivers/nvdimm/claim.c           |    2 +-
 drivers/nvdimm/pmem.c            |    2 +-
 include/linux/pmem.h             |   23 -----------------------
 include/linux/string.h           |    8 ++++++++
 7 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index 529bb4a6487a..d5a22bac9988 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -44,11 +44,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
 		BUG();
 }
 
-static inline int arch_memcpy_from_pmem(void *dst, const void *src, size_t n)
-{
-	return memcpy_mcsafe(dst, src, n);
-}
-
 /**
  * arch_wb_cache_pmem - write back a cache range with CLWB
  * @vaddr:	virtual start address
diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index a164862d77e3..733bae07fb29 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -79,6 +79,7 @@ int strcmp(const char *cs, const char *ct);
 #define memset(s, c, n) __memset(s, c, n)
 #endif
 
+#define __HAVE_ARCH_MEMCPY_MCSAFE 1
 __must_check int memcpy_mcsafe_unrolled(void *dst, const void *src, size_t cnt);
 DECLARE_STATIC_KEY_FALSE(mcsafe_key);
 
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index c8ea9d698cd0..d0c07b2344e4 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1783,8 +1783,7 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 				mmio_flush_range((void __force *)
 					mmio->addr.aperture + offset, c);
 
-			memcpy_from_pmem(iobuf + copied,
-					mmio->addr.aperture + offset, c);
+			memcpy(iobuf + copied, mmio->addr.aperture + offset, c);
 		}
 
 		copied += c;
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index ca6d572c48fc..3a35e8028b9c 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -239,7 +239,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 	if (rw == READ) {
 		if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align)))
 			return -EIO;
-		return memcpy_from_pmem(buf, nsio->addr + offset, size);
+		return memcpy_mcsafe(buf, nsio->addr + offset, size);
 	}
 
 	if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 85b85633d674..3b3dab73d741 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -89,7 +89,7 @@ static int read_pmem(struct page *page, unsigned int off,
 	int rc;
 	void *mem = kmap_atomic(page);
 
-	rc = memcpy_from_pmem(mem + off, pmem_addr, len);
+	rc = memcpy_mcsafe(mem + off, pmem_addr, len);
 	kunmap_atomic(mem);
 	if (rc)
 		return -EIO;
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index e856c2cb0fe8..71ecf3d46aac 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -31,12 +31,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
 	BUG();
 }
 
-static inline int arch_memcpy_from_pmem(void *dst, const void *src, size_t n)
-{
-	BUG();
-	return -EFAULT;
-}
-
 static inline size_t arch_copy_from_iter_pmem(void *addr, size_t bytes,
 		struct iov_iter *i)
 {
@@ -65,23 +59,6 @@ static inline bool arch_has_pmem_api(void)
 	return IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API);
 }
 
-/*
- * memcpy_from_pmem - read from persistent memory with error handling
- * @dst: destination buffer
- * @src: source buffer
- * @size: transfer length
- *
- * Returns 0 on success negative error code on failure.
- */
-static inline int memcpy_from_pmem(void *dst, void const *src, size_t size)
-{
-	if (arch_has_pmem_api())
-		return arch_memcpy_from_pmem(dst, src, size);
-	else
-		memcpy(dst, src, size);
-	return 0;
-}
-
 /**
  * memcpy_to_pmem - copy data to persistent memory
  * @dst: destination buffer for the copy
diff --git a/include/linux/string.h b/include/linux/string.h
index 26b6f6a66f83..9d6f189157e2 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -114,6 +114,14 @@ extern int memcmp(const void *,const void *,__kernel_size_t);
 #ifndef __HAVE_ARCH_MEMCHR
 extern void * memchr(const void *,int,__kernel_size_t);
 #endif
+#ifndef __HAVE_ARCH_MEMCPY_MCSAFE
+static inline __must_check int memcpy_mcsafe(void *dst, const void *src,
+		size_t cnt)
+{
+	memcpy(dst, src, cnt);
+	return 0;
+}
+#endif
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *s, char old, char new);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
