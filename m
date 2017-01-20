Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 40DC881EAC
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jan 2017 19:54:46 -0800 (PST)
Subject: [PATCH 05/13] x86,
 dax: replace clear_pmem() with open coded memset + dax_ops->flush
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Jan 2017 19:50:39 -0800
Message-ID: <148488423988.37913.16814081637297710444.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The clear_pmem() helper simply combines a memset() plus a cache flush.
Now that the flush routine is optionally provided by the dax device
driver we can avoid unnecessary cache management on dax devices fronting
volatile memory.

With clear_pmem() gone we can follow on with a patch to make pmem cache
management completely defined within the pmem driver.

Cc: <x86@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/pmem.h |   13 -------------
 fs/dax.c                    |    5 ++++-
 include/linux/pmem.h        |   21 ---------------------
 3 files changed, 4 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index 0ca5e693f4a2..ab4983df7bff 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -64,19 +64,6 @@ static inline void arch_wb_cache_pmem(void *addr, size_t size)
 		clwb(p);
 }
 
-/**
- * arch_clear_pmem - zero a PMEM memory range
- * @addr:	virtual start address
- * @size:	number of bytes to zero
- *
- * Write zeros into the memory range starting at 'addr' for 'size' bytes.
- */
-static inline void arch_clear_pmem(void *addr, size_t size)
-{
-	memset(addr, 0, size);
-	arch_wb_cache_pmem(addr, size);
-}
-
 static inline void arch_invalidate_pmem(void *addr, size_t size)
 {
 	clflush_cache_range(addr, size);
diff --git a/fs/dax.c b/fs/dax.c
index 160024e403f6..8883ce4d391e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -986,6 +986,7 @@ static bool dax_range_is_aligned(struct block_device *bdev,
 int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
 		unsigned int offset, unsigned int length)
 {
+	const struct dax_operations *dax_ops = to_dax_ops(bdev);
 	struct blk_dax_ctl dax = {
 		.sector		= sector,
 		.size		= PAGE_SIZE,
@@ -999,7 +1000,9 @@ int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
 	} else {
 		if (dax_map_atomic(bdev, &dax) < 0)
 			return PTR_ERR(dax.addr);
-		clear_pmem(dax.addr + offset, length);
+		memset(dax.addr + offset, 0, length);
+		if (dax_ops->flush)
+			dax_ops->flush(dax.addr + offset, length);
 		dax_unmap_atomic(bdev, &dax);
 	}
 	return 0;
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 9d542a5600e4..772bd02a5b52 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -31,11 +31,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
 	BUG();
 }
 
-static inline void arch_clear_pmem(void *addr, size_t size)
-{
-	BUG();
-}
-
 static inline void arch_wb_cache_pmem(void *addr, size_t size)
 {
 	BUG();
@@ -73,22 +68,6 @@ static inline void memcpy_to_pmem(void *dst, const void *src, size_t n)
 }
 
 /**
- * clear_pmem - zero a PMEM memory range
- * @addr:	virtual start address
- * @size:	number of bytes to zero
- *
- * Write zeros into the memory range starting at 'addr' for 'size' bytes.
- * See blkdev_issue_flush() note for memcpy_to_pmem().
- */
-static inline void clear_pmem(void *addr, size_t size)
-{
-	if (arch_has_pmem_api())
-		arch_clear_pmem(addr, size);
-	else
-		memset(addr, 0, size);
-}
-
-/**
  * invalidate_pmem - flush a pmem range from the cache hierarchy
  * @addr:	virtual start address
  * @size:	bytes to invalidate (internally aligned to cache line size)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
