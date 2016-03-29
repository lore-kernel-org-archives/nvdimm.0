Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 2A0381A1E93
 for <linux-nvdimm@lists.01.org>; Mon, 28 Mar 2016 17:29:53 -0700 (PDT)
Subject: [PATCH v3] x86, pmem: use memcpy_mcsafe() for memcpy_from_pmem()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 28 Mar 2016 17:28:45 -0700
Message-ID: <20160329002845.10978.8879.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: Tony Luck <tony.luck@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Update the definition of memcpy_from_pmem() to return 0 or a negative
error code.  Implement x86/arch_memcpy_from_pmem() with memcpy_mcsafe().

Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/pmem.h |    9 +++++++++
 drivers/nvdimm/pmem.c       |    4 ++--
 include/linux/pmem.h        |   21 +++++++++++++++------
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index bf8b35d2035a..fbc5e92e1ecc 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -47,6 +47,15 @@ static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
 		BUG();
 }
 
+static inline int arch_memcpy_from_pmem(void *dst, const void __pmem *src,
+		size_t n)
+{
+	if (static_cpu_has(X86_FEATURE_MCE_RECOVERY))
+		return memcpy_mcsafe(dst, (void __force *) src, n);
+	memcpy(dst, (void __force *) src, n);
+	return 0;
+}
+
 /**
  * arch_wmb_pmem - synchronize writes to persistent memory
  *
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index ca5721c306bb..cc31c6f1f88e 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -99,7 +99,7 @@ static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 		if (unlikely(bad_pmem))
 			rc = -EIO;
 		else {
-			memcpy_from_pmem(mem + off, pmem_addr, len);
+			rc = memcpy_from_pmem(mem + off, pmem_addr, len);
 			flush_dcache_page(page);
 		}
 	} else {
@@ -295,7 +295,7 @@ static int pmem_rw_bytes(struct nd_namespace_common *ndns,
 
 		if (unlikely(is_bad_pmem(&pmem->bb, offset / 512, sz_align)))
 			return -EIO;
-		memcpy_from_pmem(buf, pmem->virt_addr + offset, size);
+		return memcpy_from_pmem(buf, pmem->virt_addr + offset, size);
 	} else {
 		memcpy_to_pmem(pmem->virt_addr + offset, buf, size);
 		wmb_pmem();
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 3ec5309e29f3..cc948191a653 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -42,6 +42,12 @@ static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
 	BUG();
 }
 
+static inline int arch_memcpy_from_pmem(void *dst, const void __pmem *src,
+		size_t n)
+{
+	BUG();
+}
+
 static inline size_t arch_copy_from_iter_pmem(void __pmem *addr, size_t bytes,
 		struct iov_iter *i)
 {
@@ -66,14 +72,17 @@ static inline void arch_invalidate_pmem(void __pmem *addr, size_t size)
 #endif
 
 /*
- * Architectures that define ARCH_HAS_PMEM_API must provide
- * implementations for arch_memcpy_to_pmem(), arch_wmb_pmem(),
- * arch_copy_from_iter_pmem(), arch_clear_pmem(), arch_wb_cache_pmem()
- * and arch_has_wmb_pmem().
+ * memcpy_from_pmem - read from persistent memory with error handling
+ * @dst: destination buffer
+ * @src: source buffer
+ * @size: transfer length
+ *
+ * Returns 0 on success negative error code on failure.
  */
-static inline void memcpy_from_pmem(void *dst, void __pmem const *src, size_t size)
+static inline int memcpy_from_pmem(void *dst, void __pmem const *src,
+		size_t size)
 {
-	memcpy(dst, (void __force const *) src, size);
+	return arch_memcpy_from_pmem(dst, src, size);
 }
 
 static inline bool arch_has_pmem_api(void)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
