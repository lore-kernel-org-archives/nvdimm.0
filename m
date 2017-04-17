Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1BAAA20081A7B
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 12:17:11 -0700 (PDT)
Subject: [resend PATCH v2 29/33] uio, libnvdimm,
 pmem: implement cache bypass for all copy_from_iter() operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Apr 2017 12:11:26 -0700
Message-ID: <149245628664.10206.1096202287996099788.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, hch@lst.de
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
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/Kconfig |    1 +
 drivers/nvdimm/pmem.c  |   38 +-------------------------------------
 drivers/nvdimm/pmem.h  |    7 +++++++
 drivers/nvdimm/x86.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/uio.h    |    4 ++++
 lib/Kconfig            |    3 +++
 lib/iov_iter.c         |   25 +++++++++++++++++++++++++
 7 files changed, 89 insertions(+), 37 deletions(-)

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 4d45196d6f94..28002298cdc8 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -38,6 +38,7 @@ config BLK_DEV_PMEM
 
 config ARCH_HAS_PMEM_API
 	depends on X86_64
+	select COPY_FROM_ITER_OPS
 	def_bool y
 
 config ND_BLK
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 329895ca88e1..b000c6db5731 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -223,43 +223,7 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	size_t len;
-
-	/* TODO: skip the write-back by always using non-temporal stores */
-	len = copy_from_iter_nocache(addr, bytes, i);
-
-	/*
-	 * In the iovec case on x86_64 copy_from_iter_nocache() uses
-	 * non-temporal stores for the bulk of the transfer, but we need
-	 * to manually flush if the transfer is unaligned. A cached
-	 * memory copy is used when destination or size is not naturally
-	 * aligned. That is:
-	 *   - Require 8-byte alignment when size is 8 bytes or larger.
-	 *   - Require 4-byte alignment when size is 4 bytes.
-	 *
-	 * In the non-iovec case the entire destination needs to be
-	 * flushed.
-	 */
-	if (iter_is_iovec(i)) {
-		unsigned long flushed, dest = (unsigned long) addr;
-
-		if (bytes < 8) {
-			if (!IS_ALIGNED(dest, 4) || (bytes != 4))
-				arch_wb_cache_pmem(addr, 1);
-		} else {
-			if (!IS_ALIGNED(dest, 8)) {
-				dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);
-				arch_wb_cache_pmem(addr, 1);
-			}
-
-			flushed = dest - (unsigned long) addr;
-			if (bytes > flushed && !IS_ALIGNED(bytes - flushed, 8))
-				arch_wb_cache_pmem(addr + bytes - 1, 1);
-		}
-	} else
-		arch_wb_cache_pmem(addr, bytes);
-
-	return len;
+	return arch_copy_from_iter_pmem(addr, bytes, i);
 }
 
 static const struct block_device_operations pmem_fops = {
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 00005900c1b7..574b63fb5376 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -3,11 +3,13 @@
 #include <linux/badblocks.h>
 #include <linux/types.h>
 #include <linux/pfn_t.h>
+#include <linux/uio.h>
 #include <linux/fs.h>
 
 #ifdef CONFIG_ARCH_HAS_PMEM_API
 void arch_wb_cache_pmem(void *addr, size_t size);
 void arch_invalidate_pmem(void *addr, size_t size);
+size_t arch_copy_from_iter_pmem(void *addr, size_t bytes, struct iov_iter *i);
 #else
 static inline void arch_wb_cache_pmem(void *addr, size_t size)
 {
@@ -15,6 +17,11 @@ static inline void arch_wb_cache_pmem(void *addr, size_t size)
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
index d99b452332a9..bc145d760d43 100644
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
@@ -105,3 +108,48 @@ void arch_memcpy_to_pmem(void *_dst, void *_src, unsigned size)
 	}
 }
 EXPORT_SYMBOL_GPL(arch_memcpy_to_pmem);
+
+static int pmem_from_user(void *dst, const void __user *src, unsigned size)
+{
+	unsigned long flushed, dest = (unsigned long) dest;
+	int rc = __copy_from_user_nocache(dst, src, size);
+
+	/*
+	 * On x86_64 __copy_from_user_nocache() uses non-temporal stores
+	 * for the bulk of the transfer, but we need to manually flush
+	 * if the transfer is unaligned. A cached memory copy is used
+	 * when destination or size is not naturally aligned. That is:
+	 *   - Require 8-byte alignment when size is 8 bytes or larger.
+	 *   - Require 4-byte alignment when size is 4 bytes.
+	 */
+	if (size < 8) {
+		if (!IS_ALIGNED(dest, 4) || size != 4)
+			arch_wb_cache_pmem(dst, 1);
+	} else {
+		if (!IS_ALIGNED(dest, 8)) {
+			dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);
+			arch_wb_cache_pmem(dst, 1);
+		}
+
+		flushed = dest - (unsigned long) dst;
+		if (size > flushed && !IS_ALIGNED(size - flushed, 8))
+			arch_wb_cache_pmem(dst + size - 1, 1);
+	}
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
index 0c4aac6ef394..4d8f575e65b3 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -404,6 +404,9 @@ config DMA_VIRT_OPS
 	depends on HAS_DMA && (!64BIT || ARCH_DMA_ADDR_T_64BIT)
 	default n
 
+config COPY_FROM_ITER_OPS
+	bool
+
 config CHECK_SIGNATURE
 	bool
 
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index e68604ae3ced..85f8021504e3 100644
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
