Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 6/7] dax: update I/O path to do proper PMEM flushing
Date: Thu, 13 Aug 2015 10:51:10 -0600
Message-Id: <1439484671-15718-7-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1439484671-15718-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1439484671-15718-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

Update the DAX I/O path so that all operations that store data (I/O
writes, zeroing blocks, punching holes, etc.) properly synchronize the
stores to media using the PMEM API.  This ensures that the data DAX is
writing is durable on media before the operation completes.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index b6769ce..ea1b2c8 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -17,12 +17,14 @@
 #include <linux/atomic.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
+#include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/genhd.h>
 #include <linux/highmem.h>
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/pmem.h>
 #include <linux/sched.h>
 #include <linux/uio.h>
 #include <linux/vmstat.h>
@@ -46,10 +48,7 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 			unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
 			if (pgsz > count)
 				pgsz = count;
-			if (pgsz < PAGE_SIZE)
-				memset(addr, 0, pgsz);
-			else
-				clear_page(addr);
+			clear_pmem((void __pmem *)addr, pgsz);
 			addr += pgsz;
 			size -= pgsz;
 			count -= pgsz;
@@ -59,6 +58,7 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 		}
 	} while (size);
 
+	wmb_pmem();
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dax_clear_blocks);
@@ -70,15 +70,16 @@ static long dax_get_addr(struct buffer_head *bh, void **addr, unsigned blkbits)
 	return bdev_direct_access(bh->b_bdev, sector, addr, &pfn, bh->b_size);
 }
 
+/* the clear_pmem() calls are ordered by a wmb_pmem() in the caller */
 static void dax_new_buf(void *addr, unsigned size, unsigned first, loff_t pos,
 			loff_t end)
 {
 	loff_t final = end - pos + first; /* The final byte of the buffer */
 
 	if (first > 0)
-		memset(addr, 0, first);
+		clear_pmem((void __pmem *)addr, first);
 	if (final < size)
-		memset(addr + final, 0, size - final);
+		clear_pmem((void __pmem *)addr + final, size - final);
 }
 
 static bool buffer_written(struct buffer_head *bh)
@@ -108,6 +109,7 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 	loff_t bh_max = start;
 	void *addr;
 	bool hole = false;
+	bool need_wmb = false;
 
 	if (iov_iter_rw(iter) != WRITE)
 		end = min(end, i_size_read(inode));
@@ -145,18 +147,27 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 				retval = dax_get_addr(bh, &addr, blkbits);
 				if (retval < 0)
 					break;
-				if (buffer_unwritten(bh) || buffer_new(bh))
+				if (buffer_unwritten(bh) || buffer_new(bh)) {
 					dax_new_buf(addr, retval, first, pos,
 									end);
+					need_wmb = true;
+				}
 				addr += first;
 				size = retval - first;
 			}
 			max = min(pos + size, end);
 		}
 
-		if (iov_iter_rw(iter) == WRITE)
+		if (iov_iter_rw(iter) == WRITE) {
 			len = copy_from_iter_nocache(addr, max - pos, iter);
-		else if (!hole)
+			/*
+			 * copy_from_iter_nocache() uses non-temporal stores
+			 * for iovec iterators so we can skip the write back.
+			 */
+			if (!iter_is_iovec(iter))
+				wb_cache_pmem((void __pmem *)addr, max - pos);
+			need_wmb = true;
+		} else if (!hole)
 			len = copy_to_iter(addr, max - pos, iter);
 		else
 			len = iov_iter_zero(max - pos, iter);
@@ -168,6 +179,9 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 		addr += len;
 	}
 
+	if (need_wmb)
+		wmb_pmem();
+
 	return (pos == start) ? retval : pos - start;
 }
 
@@ -300,8 +314,10 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 		goto out;
 	}
 
-	if (buffer_unwritten(bh) || buffer_new(bh))
-		clear_page(addr);
+	if (buffer_unwritten(bh) || buffer_new(bh)) {
+		clear_pmem((void __pmem *)addr, PAGE_SIZE);
+		wmb_pmem();
+	}
 
 	error = vm_insert_mixed(vma, vaddr, pfn);
 
@@ -608,7 +624,9 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
 			int i;
 			for (i = 0; i < PTRS_PER_PMD; i++)
-				clear_page(kaddr + i * PAGE_SIZE);
+				clear_pmem((void __pmem *)kaddr + i*PAGE_SIZE,
+						PAGE_SIZE);
+			wmb_pmem();
 			count_vm_event(PGMAJFAULT);
 			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
 			result |= VM_FAULT_MAJOR;
@@ -720,7 +738,8 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 		err = dax_get_addr(&bh, &addr, inode->i_blkbits);
 		if (err < 0)
 			return err;
-		memset(addr + offset, 0, length);
+		clear_pmem((void __pmem *)addr + offset, length);
+		wmb_pmem();
 	}
 
 	return 0;
-- 
2.1.0

