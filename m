From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/12] dax: provide an iomap based dax read/write path
Date: Wed, 14 Sep 2016 12:01:24 +0200
Message-ID: <1473847291-18913-6-git-send-email-hch@lst.de>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1473847291-18913-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
Cc: ross.zwisler@linux.intel.com
List-Id: linux-nvdimm@lists.01.org

This is a much simpler implementation of the DAX read/write path that makes
use of the iomap infrastructure.  It does not try to mirror the direct I/O
calling conventions and thus doesn't have to deal with i_dio_count or the
end_io handler, but instead leaves locking and filesystem-specific I/O
completion to the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c            | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h |   4 ++
 2 files changed, 118 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 84343ce..1f9f2d4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -31,6 +31,8 @@
 #include <linux/vmstat.h>
 #include <linux/pfn_t.h>
 #include <linux/sizes.h>
+#include <linux/iomap.h>
+#include "internal.h"
 
 /*
  * We use lowest available bit in exceptional entry for locking, other two
@@ -1241,3 +1243,115 @@ int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
 	return dax_zero_page_range(inode, from, length, get_block);
 }
 EXPORT_SYMBOL_GPL(dax_truncate_page);
+
+#ifdef CONFIG_FS_IOMAP
+static loff_t
+iomap_dax_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
+		struct iomap *iomap)
+{
+	struct iov_iter *iter = data;
+	loff_t end = pos + length, done = 0;
+	ssize_t ret = 0;
+
+	if (iov_iter_rw(iter) == READ) {
+		end = min(end, i_size_read(inode));
+		if (pos >= end)
+			return 0;
+
+		if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_UNWRITTEN)
+			return iov_iter_zero(min(length, end - pos), iter);
+	}
+
+	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED))
+		return -EIO;
+
+	while (pos < end) {
+		unsigned offset = pos & (PAGE_SIZE - 1);
+		struct blk_dax_ctl dax = { 0 };
+		ssize_t map_len;
+
+		dax.sector = iomap->blkno +
+			(((pos & PAGE_MASK) - iomap->offset) >> 9);
+		dax.size = (length + offset + PAGE_SIZE - 1) & PAGE_MASK;
+		map_len = dax_map_atomic(iomap->bdev, &dax);
+		if (map_len < 0) {
+			ret = map_len;
+			break;
+		}
+
+		dax.addr += offset;
+		map_len -= offset;
+		if (map_len > end - pos)
+			map_len = end - pos;
+
+		if (iov_iter_rw(iter) == WRITE)
+			map_len = copy_from_iter_pmem(dax.addr, map_len, iter);
+		else
+			map_len = copy_to_iter(dax.addr, map_len, iter);
+		dax_unmap_atomic(iomap->bdev, &dax);
+		if (map_len <= 0) {
+			ret = map_len ? map_len : -EFAULT;
+			break;
+		}
+
+		pos += map_len;
+		length -= map_len;
+		done += map_len;
+	}
+
+	return done ? done : ret;
+}
+
+/**
+ * iomap_dax_rw - Perform I/O to a DAX file
+ * @iocb:	The control block for this I/O
+ * @iter:	The addresses to do I/O from or to
+ * @ops:	iomap ops passed from the file system
+ *
+ * This function performs read and write operations to directly mapped
+ * persistent memory.  The callers needs to take care of read/write exclusion
+ * and evicting any page cache pages in the region under I/O.
+ */
+ssize_t
+iomap_dax_rw(struct kiocb *iocb, struct iov_iter *iter,
+		struct iomap_ops *ops)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	struct inode *inode = mapping->host;
+	loff_t pos = iocb->ki_pos, ret = 0, done = 0;
+	unsigned flags = 0;
+
+	if (iov_iter_rw(iter) == WRITE)
+		flags |= IOMAP_WRITE;
+
+	/*
+	 * Yes, even DAX files can have page cache attached to them:  A zeroed
+	 * page is inserted into the pagecache when we have to serve a write
+	 * fault on a hole.  It should never be dirtied and can simply be
+	 * dropped from the pagecache once we get real data for the page.
+	 *
+	 * XXX: This is racy against mmap, and there's nothing we can do about
+	 * it. We'll eventually need to shift this down even further so that
+	 * we can check if we allocated blocks over a hole first.
+	 */
+	if (mapping->nrpages) {
+		ret = invalidate_inode_pages2_range(mapping,
+				pos >> PAGE_SHIFT,
+				(pos + iov_iter_count(iter) - 1) >> PAGE_SHIFT);
+		WARN_ON_ONCE(ret);
+	}
+
+	while (iov_iter_count(iter)) {
+		ret = iomap_apply(inode, pos, iov_iter_count(iter), flags, ops,
+				iter, iomap_dax_actor);
+		if (ret <= 0)
+			break;
+		pos += ret;
+		done += ret;
+	}
+
+	iocb->ki_pos += done;
+	return done ? done : ret;
+}
+EXPORT_SYMBOL_GPL(iomap_dax_rw);
+#endif /* CONFIG_FS_IOMAP */
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 9c6dc77..a0595b4 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -6,9 +6,13 @@
 #include <linux/radix-tree.h>
 #include <asm/pgtable.h>
 
+struct iomap_ops;
+
 /* We use lowest available exceptional entry bit for locking */
 #define RADIX_DAX_ENTRY_LOCK (1 << RADIX_TREE_EXCEPTIONAL_SHIFT)
 
+ssize_t iomap_dax_rw(struct kiocb *iocb, struct iov_iter *iter,
+		struct iomap_ops *ops);
 ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *,
 		  get_block_t, dio_iodone_t, int flags);
 int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
-- 
2.1.4

