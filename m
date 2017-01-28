Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9347782001
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:41:28 -0800 (PST)
Subject: [RFC PATCH 14/17] ext2, ext4,
 xfs: retrieve dax_inode through iomap operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:37:19 -0800
Message-ID: <148559263958.11180.13062024115072920011.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: snitzer@redhat.com, mawilcox@microsoft.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

In preparation for converting fs/dax.c to use bdev_dax_direct_access()
instead of bdev_direct_access(), add the plumbing to retrieve the
dax_inode determined at mount through ->iomap_begin.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/inode.c       |    1 +
 fs/ext4/inode.c       |    1 +
 fs/xfs/xfs_aops.c     |   13 +++++++++++++
 fs/xfs/xfs_aops.h     |    1 +
 fs/xfs/xfs_buf.h      |    1 +
 fs/xfs/xfs_iomap.c    |    1 +
 fs/xfs/xfs_super.c    |    3 +++
 include/linux/iomap.h |    1 +
 8 files changed, 22 insertions(+)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index f073bfca694b..c83f84748ec9 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -813,6 +813,7 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	iomap->flags = 0;
 	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->dax_inode = inode->i_sb->s_dax;
 	iomap->offset = (u64)first_block << blkbits;
 
 	if (ret == 0) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 88d57af1b516..ae6fa6a78d0d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3344,6 +3344,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	iomap->flags = 0;
 	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->dax_inode = inode->i_sb->s_dax;
 	iomap->offset = first_block << blkbits;
 
 	if (ret == 0) {
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 631e7c0e0a29..7d22938a4d8b 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -80,6 +80,19 @@ xfs_find_bdev_for_inode(
 		return mp->m_ddev_targp->bt_bdev;
 }
 
+struct dax_inode *
+xfs_find_dax_for_inode(
+	struct inode		*inode)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (XFS_IS_REALTIME_INODE(ip))
+		return NULL;
+	else
+		return mp->m_ddev_targp->bt_dax;
+}
+
 /*
  * We're now finished for good with this page.  Update the page state via the
  * associated buffer_heads, paying attention to the start and end offsets that
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index cc174ec6c2fd..e5b65f436acf 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -59,5 +59,6 @@ int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
 
 extern void xfs_count_page_state(struct page *, int *, int *);
 extern struct block_device *xfs_find_bdev_for_inode(struct inode *);
+extern struct dax_inode *xfs_find_dax_for_inode(struct inode *);
 
 #endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 8a9d3a9599f0..1ff83f398649 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -109,6 +109,7 @@ typedef unsigned int xfs_buf_flags_t;
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
 	struct block_device	*bt_bdev;
+	struct dax_inode	*bt_dax;
 	struct backing_dev_info	*bt_bdi;
 	struct xfs_mount	*bt_mount;
 	unsigned int		bt_meta_sectorsize;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0d147428971e..1d08bd2433d5 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -69,6 +69,7 @@ xfs_bmbt_to_iomap(
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
 	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
+	iomap->dax_inode = xfs_find_dax_for_inode(VFS_I(ip));
 }
 
 xfs_extlen_t
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index eecbaac08eba..1a99013a0701 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -774,6 +774,9 @@ xfs_open_devices(
 	if (!mp->m_ddev_targp)
 		goto out_close_rtdev;
 
+	/* associate dax inode for filesystem-dax */
+	mp->m_ddev_targp->bt_dax = mp->m_super->s_dax;
+
 	if (rtdev) {
 		mp->m_rtdev_targp = xfs_alloc_buftarg(mp, rtdev);
 		if (!mp->m_rtdev_targp)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index a4c94b86401e..01e265e7cf55 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -41,6 +41,7 @@ struct iomap {
 	u16			type;	/* type of mapping */
 	u16			flags;	/* flags for mapping */
 	struct block_device	*bdev;	/* block device for I/O */
+	struct dax_inode	*dax_inode; /* dax_inode for dax operations */
 };
 
 /*

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
