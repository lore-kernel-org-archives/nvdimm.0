Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4E08121DFC897
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 17:39:37 -0700 (PDT)
Subject: [PATCH 1/2] xfs: cache dax_device lookup result
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 17:35:48 -0700
Message-ID: <150362134833.39142.12423673180125514125.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150362134292.39142.1715377949592729029.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150362134292.39142.1715377949592729029.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, hch@lst.de, jack@suse.cz, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The ->iomap_begin() operation is a hot path, so cache the
fs_dax_get_by_host() result to avoid the incurring the hash lookup
overhead.

Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_aops.c  |   24 ++++++++++++++++++++++++
 fs/xfs/xfs_aops.h  |    1 +
 fs/xfs/xfs_buf.h   |    1 +
 fs/xfs/xfs_iomap.c |    9 +--------
 4 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6bf120bb1a17..d16e013e1b8c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -80,6 +80,30 @@ xfs_find_bdev_for_inode(
 		return mp->m_ddev_targp->bt_bdev;
 }
 
+struct dax_device *
+xfs_find_daxdev_for_inode(
+	struct inode		*inode)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct block_device	*bdev;
+	xfs_buftarg_t		*bt;
+
+	if (XFS_IS_REALTIME_INODE(ip))
+		bt = mp->m_rtdev_targp;
+	else
+		bt = mp->m_ddev_targp;
+
+	bdev = bt->bt_bdev;
+	if (!blk_queue_dax(bdev->bd_queue))
+		return NULL;
+
+	if (!bt->bt_daxdev)
+		bt->bt_daxdev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
+
+	return bt->bt_daxdev;
+}
+
 /*
  * We're now finished for good with this page.  Update the page state via the
  * associated buffer_heads, paying attention to the start and end offsets that
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index cc174ec6c2fd..88c85ea63da0 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -59,5 +59,6 @@ int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
 
 extern void xfs_count_page_state(struct page *, int *, int *);
 extern struct block_device *xfs_find_bdev_for_inode(struct inode *);
+extern struct dax_device *xfs_find_daxdev_for_inode(struct inode *);
 
 #endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 20721261dae5..fc95a02f272a 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -108,6 +108,7 @@ typedef unsigned int xfs_buf_flags_t;
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
 	struct block_device	*bt_bdev;
+	struct dax_device	*bt_daxdev;
 	struct xfs_mount	*bt_mount;
 	unsigned int		bt_meta_sectorsize;
 	size_t			bt_meta_sectormask;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 813394c62849..3e8b9ec9e802 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -69,6 +69,7 @@ xfs_bmbt_to_iomap(
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
 	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
+	iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
 }
 
 xfs_extlen_t
@@ -976,7 +977,6 @@ xfs_file_iomap_begin(
 	int			nimaps = 1, error = 0;
 	bool			shared = false, trimmed = false;
 	unsigned		lockmode;
-	struct block_device	*bdev;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
@@ -1087,13 +1087,6 @@ xfs_file_iomap_begin(
 
 	xfs_bmbt_to_iomap(ip, iomap, &imap);
 
-	/* optionally associate a dax device with the iomap bdev */
-	bdev = iomap->bdev;
-	if (blk_queue_dax(bdev->bd_queue))
-		iomap->dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
-	else
-		iomap->dax_dev = NULL;
-
 	if (shared)
 		iomap->flags |= IOMAP_F_SHARED;
 	return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
