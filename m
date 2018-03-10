Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EDC2921ED1C5F
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 22:57:46 -0800 (PST)
Subject: [PATCH v5 02/11] xfs, dax: introduce xfs_dax_aops
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Mar 2018 22:54:59 -0800
Message-ID: <152066489984.40260.2215636951958334858.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
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

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c            |   27 +++++++++++++++++++++++++++
 fs/xfs/xfs_aops.c   |    7 +++++++
 fs/xfs/xfs_aops.h   |    1 +
 fs/xfs/xfs_iops.c   |    5 ++++-
 include/linux/dax.h |    6 ++++++
 5 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index b646a46e4d12..ba02772fccbc 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -46,6 +46,33 @@
 #define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
 #define PG_PMD_NR	(PMD_SIZE >> PAGE_SHIFT)
 
+int dax_set_page_dirty(struct page *page)
+{
+	/*
+	 * Unlike __set_page_dirty_no_writeback that handles dirty page
+	 * tracking in the page object, dax does all dirty tracking in
+	 * the inode address_space in response to mkwrite faults. In the
+	 * dax case we only need to worry about potentially dirty CPU
+	 * caches, not dirty page cache pages to write back.
+	 *
+	 * This callback is defined to prevent fallback to
+	 * __set_page_dirty_buffers() in set_page_dirty().
+	 */
+	return 0;
+}
+EXPORT_SYMBOL(dax_set_page_dirty);
+
+void dax_invalidatepage(struct page *page, unsigned int offset,
+		unsigned int length)
+{
+	/*
+	 * There is no page cache to invalidate in the dax case, however
+	 * we need this callback defined to prevent falling back to
+	 * block_invalidatepage() in do_invalidatepage().
+	 */
+}
+EXPORT_SYMBOL(dax_invalidatepage);
+
 static wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
 
 static int __init init_dax_wait_table(void)
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9c6a830da0ee..5788b680fa01 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1505,3 +1505,10 @@ const struct address_space_operations xfs_address_space_operations = {
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
 };
+
+const struct address_space_operations xfs_dax_aops = {
+	.writepages		= xfs_vm_writepages,
+	.direct_IO		= xfs_vm_direct_IO,
+	.set_page_dirty		= dax_set_page_dirty,
+	.invalidatepage		= dax_invalidatepage,
+};
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 88c85ea63da0..69346d460dfa 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -54,6 +54,7 @@ struct xfs_ioend {
 };
 
 extern const struct address_space_operations xfs_address_space_operations;
+extern const struct address_space_operations xfs_dax_aops;
 
 int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 56475fcd76f2..951e84df5576 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1272,7 +1272,10 @@ xfs_setup_iops(
 	case S_IFREG:
 		inode->i_op = &xfs_inode_operations;
 		inode->i_fop = &xfs_file_operations;
-		inode->i_mapping->a_ops = &xfs_address_space_operations;
+		if (IS_DAX(inode))
+			inode->i_mapping->a_ops = &xfs_dax_aops;
+		else
+			inode->i_mapping->a_ops = &xfs_address_space_operations;
 		break;
 	case S_IFDIR:
 		if (xfs_sb_version_hasasciici(&XFS_M(inode->i_sb)->m_sb))
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 0185ecdae135..3045c0d9c804 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -57,6 +57,9 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
 }
 
 struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
+int dax_set_page_dirty(struct page *page);
+void dax_invalidatepage(struct page *page, unsigned int offset,
+		unsigned int length);
 #else
 static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
 {
@@ -76,6 +79,9 @@ static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
 {
 	return NULL;
 }
+
+#define dax_set_page_dirty NULL
+#define dax_invalidatepage NULL
 #endif
 
 int dax_read_lock(void);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
