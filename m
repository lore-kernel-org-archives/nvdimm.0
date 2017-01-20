Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A44C481E9E
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jan 2017 19:54:40 -0800 (PST)
Subject: [PATCH 04/13] dax, pmem: introduce an optional 'flush' dax operation
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Jan 2017 19:50:34 -0800
Message-ID: <148488423471.37913.134166034060177524.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Filesystem-DAX flushes caches whenever it writes to the address returned
through dax_map_atomic() and when writing back dirty radix entries. That
flushing is only required in the pmem case, so add a dax operation to
allow pmem to take this extra action, but skip it for other dax capable
block_devices like brd.

We still do all the dirty tracking since the radix entry will already be
there for locking purposes. However, the work to clean the entry will be
a nop for some dax drivers.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c  |    1 +
 fs/dax.c               |   16 ++++++++++++----
 include/linux/blkdev.h |    1 +
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 71e5e365d3fc..68fc7599a053 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -229,6 +229,7 @@ static size_t pmem_copy_from_iter(void *addr, size_t bytes,
 static const struct dax_operations pmem_dax_ops = {
 	.direct_access = pmem_direct_access,
 	.copy_from_iter = pmem_copy_from_iter,
+	.flush = wb_cache_pmem,
 };
 
 static const struct block_device_operations pmem_fops = {
diff --git a/fs/dax.c b/fs/dax.c
index 22cd57424a55..160024e403f6 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -756,10 +756,19 @@ static void dax_mapping_entry_mkclean(struct address_space *mapping,
 	i_mmap_unlock_read(mapping);
 }
 
+static const struct dax_operations *to_dax_ops(struct block_device *bdev)
+{
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+	const struct dax_operations *dax_ops = ops->dax_ops;
+
+	return dax_ops;
+}
+
 static int dax_writeback_one(struct block_device *bdev,
 		struct address_space *mapping, pgoff_t index, void *entry)
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
+	const struct dax_operations *dax_ops = to_dax_ops(bdev);
 	struct blk_dax_ctl dax;
 	void *entry2, **slot;
 	int ret = 0;
@@ -830,7 +839,8 @@ static int dax_writeback_one(struct block_device *bdev,
 	}
 
 	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(dax.pfn));
-	wb_cache_pmem(dax.addr, dax.size);
+	if (dax_ops->flush)
+		dax_ops->flush(dax.addr, dax.size);
 	/*
 	 * After we have flushed the cache, we can clear the dirty tag. There
 	 * cannot be new dirty data in the pfn after the flush has completed as
@@ -1006,10 +1016,8 @@ static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct iomap *iomap)
 {
-	struct block_device *bdev = iomap->bdev;
 	size_t (*dax_copy_from_iter)(void *, size_t, struct iov_iter *);
-	const struct block_device_operations *ops = bdev->bd_disk->fops;
-	const struct dax_operations *dax_ops = ops->dax_ops;
+	const struct dax_operations *dax_ops = to_dax_ops(iomap->bdev);
 	struct iov_iter *iter = data;
 	loff_t end = pos + length, done = 0;
 	ssize_t ret = 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7ca559d124a3..692bdcd63db6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1867,6 +1867,7 @@ struct dax_operations {
 	long (*direct_access)(struct block_device *, sector_t, void **, pfn_t *,
 			long);
 	size_t (*copy_from_iter)(void *, size_t, struct iov_iter *);
+	void (*flush)(void *, size_t);
 };
 
 struct block_device_operations {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
