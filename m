Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4194F81EA3
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jan 2017 19:55:08 -0800 (PST)
Subject: [PATCH 09/13] libnvdimm,
 pmem: implement cache bypass for all copy_from_iter() operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Jan 2017 19:51:02 -0800
Message-ID: <148488426202.37913.7632846318354911904.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Introduce copy_from_iter_ops() to enable passing custom sub-routines to
iterate_and_advance(). Define pmem operations that guarantee cache
bypass to supplement the existing usage of __copy_from_iter_nocache()
backed by arch_wb_cache_pmem().

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Brian Boylston <brian.boylston@hpe.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/Kconfig |    1 +
 drivers/nvdimm/pmem.c  |   12 +-----------
 drivers/nvdimm/pmem.h  |    7 +++++++
 drivers/nvdimm/x86.c   |   28 ++++++++++++++++++++++++++++
 include/linux/uio.h    |    4 ++++
 lib/Kconfig            |    3 +++
 lib/iov_iter.c         |   25 +++++++++++++++++++++++++
 7 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 2b62c122e1e5..03a67abfb33e 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -37,6 +37,7 @@ config BLK_DEV_PMEM
 
 config ARCH_HAS_PMEM_API
 	depends on X86_64
+	select COPY_FROM_ITER_OPS
 	def_bool y
 
 config ND_BLK
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index f971be271eac..47392c4f22b9 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -27,7 +27,6 @@
 #include <linux/vmalloc.h>
 #include <linux/pfn_t.h>
 #include <linux/slab.h>
-#include <linux/uio.h>
 #include <linux/nd.h>
 #include "pmem.h"
 #include "pfn.h"
@@ -217,18 +216,9 @@ __weak long pmem_direct_access(struct block_device *bdev, sector_t sector,
 	return pmem->size - pmem->pfn_pad - offset;
 }
 
-static size_t pmem_copy_from_iter(void *addr, size_t bytes,
-		struct iov_iter *i)
-{
-	size_t rc = copy_from_iter_nocache(addr, bytes, i);
-
-	arch_wb_cache_pmem(addr, bytes);
-	return rc;
-}
-
 static const struct dax_operations pmem_dax_ops = {
 	.direct_access = pmem_direct_access,
-	.copy_from_iter = pmem_copy_from_iter,
+	.copy_from_iter = arch_copy_from_iter_pmem,
 	.flush = arch_wb_cache_pmem,
 };
 
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 02f94e1f14ea..2cd8834f31ad 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -3,6 +3,7 @@
 #include <linux/badblocks.h>
 #include <linux/types.h>
 #include <linux/pfn_t.h>
+#include <linux/uio.h>
 #include <linux/fs.h>
 
 long pmem_direct_access(struct block_device *bdev, sector_t sector,
@@ -11,6 +12,7 @@ long pmem_direct_access(struct block_device *bdev, sector_t sector,
 #ifdef CONFIG_ARCH_HAS_PMEM_API
 void arch_wb_cache_pmem(void *addr, size_t size);
 void arch_invalidate_pmem(void *addr, size_t size);
+size_t arch_copy_from_iter_pmem(void *addr, size_t bytes, struct iov_iter *i);
 #else
 static inline void arch_wb_cache_pmem(void *addr, size_t size)
 {
@@ -18,6 +20,11 @@ static inline void arch_wb_cache_pmem(void *addr, size_t size)
 static inline void arch_invalidate_pmem(void *addr, size_t size)
 {
 }
+static inline size_t arch_copy_from_iter_pmem(void *addr, size_t bytes,
+		struct iov_iter *i)
+{
+	return copy_from_iter_nocache(addr, bytes, i);
+}
 #endif
 
 /* this definition is in it's own header for tools/testing/nvdimm to consume */
diff --git a/drivers/nvdimm/x86.c b/drivers/nvdimm/x86.c
index 0d0e2e5fadae..08beed4196a0 100644
--- a/drivers/nvdimm/x86.c
+++ b/drivers/nvdimm/x86.c
@@ -10,6 +10,9 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+#include <linux/uio.h>
+#include <linux/uaccess.h>
+#include <linux/highmem.h>
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/special_insns.h>
@@ -54,3 +57,28 @@ void arch_memcpy_to_pmem(void *dst, void *src, unsigned size)
 	__arch_memcpy_to_pmem(dst, src, size);
 }
 EXPORT_SYMBOL_GPL(arch_memcpy_to_pmem);
+
+static int pmem_from_user(void *dst, const void __user *src, unsigned size)
+{
+	int rc = __copy_from_user_nocache(dst, src, size);
+
+	/* 'nocache' does not guarantee 'writethrough'*/
+	arch_wb_cache_pmem(dst, size);
+
+	return rc;
+}
+
+static void pmem_from_page(char *to, struct page *page, size_t offset, size_t len)
+{
+	char *from = kmap_atomic(page);
+
+	arch_memcpy_to_pmem(to, from + offset, len);
+	kunmap_atomic(from);
+}
+
+size_t arch_copy_from_iter_pmem(void *addr, size_t bytes, struct iov_iter *i)
+{
+	return copy_from_iter_ops(addr, bytes, i, pmem_from_user, pmem_from_page,
+			arch_memcpy_to_pmem);
+}
+EXPORT_SYMBOL_GPL(arch_copy_from_iter_pmem);
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 804e34c6f981..edb78f3fe2c8 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -91,6 +91,10 @@ size_t copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
 size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i);
 bool copy_from_iter_full(void *addr, size_t bytes, struct iov_iter *i);
 size_t copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i);
+size_t copy_from_iter_ops(void *addr, size_t bytes, struct iov_iter *i,
+		int (*user)(void *, const void __user *, unsigned),
+		void (*page)(char *, struct page *, size_t, size_t),
+		void (*copy)(void *, void *, unsigned));
 bool copy_from_iter_full_nocache(void *addr, size_t bytes, struct iov_iter *i);
 size_t iov_iter_zero(size_t bytes, struct iov_iter *);
 unsigned long iov_iter_alignment(const struct iov_iter *i);
diff --git a/lib/Kconfig b/lib/Kconfig
index 006264ac768a..725f9f2aefd9 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -395,6 +395,9 @@ config HAS_DMA
 	depends on !NO_DMA
 	default y
 
+config COPY_FROM_ITER_OPS
+	bool
+
 config CHECK_SIGNATURE
 	bool
 
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 25f572303801..090cafc83233 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -571,6 +571,31 @@ size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 }
 EXPORT_SYMBOL(copy_from_iter);
 
+#ifdef CONFIG_COPY_FROM_ITER_OPS
+size_t copy_from_iter_ops(void *addr, size_t bytes, struct iov_iter *i,
+		int (*user)(void *, const void __user *, unsigned),
+		void (*page)(char *, struct page *, size_t, size_t),
+		void (*copy)(void *, void *, unsigned))
+{
+	char *to = addr;
+
+	if (unlikely(i->type & ITER_PIPE)) {
+		WARN_ON(1);
+		return 0;
+	}
+	iterate_and_advance(i, bytes, v,
+		user((to += v.iov_len) - v.iov_len, v.iov_base,
+				 v.iov_len),
+		page((to += v.bv_len) - v.bv_len, v.bv_page, v.bv_offset,
+				v.bv_len),
+		copy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
+	)
+
+	return bytes;
+}
+EXPORT_SYMBOL_GPL(copy_from_iter_ops);
+#endif
+
 bool copy_from_iter_full(void *addr, size_t bytes, struct iov_iter *i)
 {
 	char *to = addr;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
