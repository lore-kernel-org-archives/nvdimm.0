Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE495220C2A59
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 08:54:26 -0700 (PDT)
Subject: [PATCH v6 04/15] xfs, dax: introduce xfs_dax_aops
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Mar 2018 08:51:45 -0700
Message-ID: <152112910519.24669.5862622842481813804.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
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
 fs/xfs/xfs_aops.c |   21 +++++++++++++++++----
 fs/xfs/xfs_aops.h |    1 +
 fs/xfs/xfs_iops.c |    5 ++++-
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9c6a830da0ee..5f1f5948ecc2 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1194,16 +1194,22 @@ xfs_vm_writepages(
 	int			ret;
 
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
-	if (dax_mapping(mapping))
-		return dax_writeback_mapping_range(mapping,
-				xfs_find_bdev_for_inode(mapping->host), wbc);
-
 	ret = write_cache_pages(mapping, wbc, xfs_do_writepage, &wpc);
 	if (wpc.ioend)
 		ret = xfs_submit_ioend(wbc, wpc.ioend, ret);
 	return ret;
 }
 
+STATIC int
+xfs_dax_writepages(
+	struct address_space	*mapping,
+	struct writeback_control *wbc)
+{
+	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
+	return dax_writeback_mapping_range(mapping,
+			xfs_find_bdev_for_inode(mapping->host), wbc);
+}
+
 /*
  * Called to move a page into cleanable state - and from there
  * to be released. The page should already be clean. We always
@@ -1505,3 +1511,10 @@ const struct address_space_operations xfs_address_space_operations = {
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
 };
+
+const struct address_space_operations xfs_dax_aops = {
+	.direct_IO		= xfs_vm_direct_IO,
+	.writepages		= xfs_dax_writepages,
+	.set_page_dirty		= noop_set_page_dirty,
+	.invalidatepage		= noop_invalidatepage,
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

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
