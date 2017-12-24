Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 45BB422225C0C
 for <linux-nvdimm@lists.01.org>; Sat, 23 Dec 2017 17:00:22 -0800 (PST)
Subject: [PATCH v4 11/18] fs, dax: introduce DEFINE_FSDAX_AOPS
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Dec 2017 16:56:59 -0800
Message-ID: <151407701943.38751.8997225433943672290.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

In preparation for the dax implementation to start associating dax pages
to inodes via page->mapping, we need to provide a 'struct
address_space_operations' instance for dax. Otherwise, direct-I/O
triggers incorrect page cache assumptions and warnings like the
following:

 WARNING: CPU: 27 PID: 1783 at fs/xfs/xfs_aops.c:1468
 xfs_vm_set_page_dirty+0xf3/0x1b0 [xfs]
 [..]
 CPU: 27 PID: 1783 Comm: dma-collision Tainted: G           O 4.15.0-rc2+ #984
 [..]
 Call Trace:
  set_page_dirty_lock+0x40/0x60
  bio_set_pages_dirty+0x37/0x50
  iomap_dio_actor+0x2b7/0x3b0
  ? iomap_dio_zero+0x110/0x110
  iomap_apply+0xa4/0x110
  iomap_dio_rw+0x29e/0x3b0
  ? iomap_dio_zero+0x110/0x110
  ? xfs_file_dio_aio_read+0x7c/0x1a0 [xfs]
  xfs_file_dio_aio_read+0x7c/0x1a0 [xfs]
  xfs_file_read_iter+0xa0/0xc0 [xfs]
  __vfs_read+0xf9/0x170
  vfs_read+0xa6/0x150
  SyS_pread64+0x93/0xb0
  entry_SYSCALL_64_fastpath+0x1f/0x96

...where the default set_page_dirty() handler assumes that dirty state
is being tracked in 'struct page' flags.

A DEFINE_FSDAX_AOPS macro helper is provided instead of a global 'struct
address_space_operations fs_dax_aops' instance, because ->writepages
needs to be an fs-specific implementation.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c            |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h |   32 ++++++++++++++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 54071cd27e8c..fadc1b13838b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -45,6 +45,75 @@
 /* The 'colour' (ie low bits) within a PMD of a page offset.  */
 #define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
 
+int dax_set_page_dirty(struct page *page)
+{
+	/*
+	 * Unlike __set_page_dirty_no_writeback, dax does all dirty
+	 * tracking in the radix in response to mkwrite faults.
+	 */
+	return 0;
+}
+EXPORT_SYMBOL(dax_set_page_dirty);
+
+ssize_t dax_direct_IO(struct kiocb *kiocb, struct iov_iter *iter)
+{
+	/*
+	 * The expectation is that filesystems that implement DAX
+	 * support also arrange for ->read_iter and ->write_iter to
+	 * bypass ->direct_IO.
+	 */
+	WARN_ONCE(1, "dax: incomplete fs implementation\n");
+	return -EINVAL;
+}
+EXPORT_SYMBOL(dax_direct_IO);
+
+int dax_writepage(struct page *page, struct writeback_control *wbc)
+{
+	WARN_ONCE(1, "dax: incomplete fs implementation\n");
+	return -EINVAL;
+}
+EXPORT_SYMBOL(dax_writepage);
+
+int dax_readpage(struct file *filp, struct page *page)
+{
+	WARN_ONCE(1, "dax: incomplete fs implementation\n");
+	return -EINVAL;
+}
+EXPORT_SYMBOL(dax_readpage);
+
+int dax_readpages(struct file *filp, struct address_space *mapping,
+		struct list_head *pages, unsigned nr_pages)
+{
+	WARN_ONCE(1, "dax: incomplete fs implementation\n");
+	return -EINVAL;
+}
+EXPORT_SYMBOL(dax_readpages);
+
+int dax_write_begin(struct file *filp, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata)
+{
+	WARN_ONCE(1, "dax: incomplete fs implementation\n");
+	return -EINVAL;
+}
+EXPORT_SYMBOL(dax_write_begin);
+
+int dax_write_end(struct file *filp, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned copied,
+		struct page *page, void *fsdata)
+{
+	WARN_ONCE(1, "dax: incomplete fs implementation\n");
+	return -EINVAL;
+}
+EXPORT_SYMBOL(dax_write_end);
+
+void dax_invalidatepage(struct page *page, unsigned int offset,
+		unsigned int length)
+{
+	/* nothing to do for dax */
+}
+EXPORT_SYMBOL(dax_invalidatepage);
+
 static wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
 
 static int __init init_dax_wait_table(void)
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 1c6ed44fe9fc..3502abcbea31 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -53,6 +53,34 @@ static inline struct dax_device *fs_dax_get_by_host(const char *host)
 
 struct dax_device *fs_dax_claim_bdev(struct block_device *bdev, void *owner);
 void fs_dax_release(struct dax_device *dax_dev, void *owner);
+int dax_set_page_dirty(struct page *page);
+ssize_t dax_direct_IO(struct kiocb *kiocb, struct iov_iter *iter);
+int dax_writepage(struct page *page, struct writeback_control *wbc);
+int dax_readpage(struct file *filp, struct page *page);
+int dax_readpages(struct file *filp, struct address_space *mapping,
+		struct list_head *pages, unsigned nr_pages);
+int dax_write_begin(struct file *filp, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata);
+int dax_write_end(struct file *filp, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned copied,
+		struct page *page, void *fsdata);
+void dax_invalidatepage(struct page *page, unsigned int offset,
+		unsigned int length);
+
+#define DEFINE_FSDAX_AOPS(name, writepages_fn)	\
+const struct address_space_operations name = {	\
+	.set_page_dirty = dax_set_page_dirty,	\
+	.direct_IO = dax_direct_IO,	\
+	.writepage = dax_writepage,	\
+	.readpage = dax_readpage,	\
+	.writepages = writepages_fn,	\
+	.readpages = dax_readpages,	\
+	.write_begin = dax_write_begin,	\
+	.write_end = dax_write_end,	\
+	.invalidatepage = dax_invalidatepage, \
+}
+
 #else
 static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
 {
@@ -73,6 +101,10 @@ static inline struct dax_device *fs_dax_claim_bdev(struct block_device *bdev,
 static inline void fs_dax_release(struct dax_device *dax_dev, void *owner)
 {
 }
+
+#define DEFINE_FSDAX_AOPS(name, writepages_fn)	\
+const struct address_space_operations name = { 0 }
+
 #endif
 
 int dax_read_lock(void);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
