From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 6/8] xfs: direct calls in the direct I/O path
Date: Wed, 22 Jun 2016 17:27:14 +0200
Message-ID: <1466609236-23801-7-git-send-email-hch@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1466609236-23801-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

We control both the callers and callees of ->direct_IO, so remove the
indirect calls.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/xfs/xfs_aops.c | 24 +++++-------------------
 fs/xfs/xfs_aops.h |  3 +++
 fs/xfs/xfs_file.c | 17 +++++++++++++++--
 3 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 80714eb..b368277 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1303,7 +1303,7 @@ xfs_get_blocks_dax_fault(
  * whereas if we have flags set we will always be called in task context
  * (i.e. from a workqueue).
  */
-STATIC int
+int
 xfs_end_io_direct_write(
 	struct kiocb		*iocb,
 	loff_t			offset,
@@ -1374,24 +1374,10 @@ xfs_vm_direct_IO(
 	struct kiocb		*iocb,
 	struct iov_iter		*iter)
 {
-	struct inode		*inode = iocb->ki_filp->f_mapping->host;
-	dio_iodone_t		*endio = NULL;
-	int			flags = 0;
-	struct block_device	*bdev;
-
-	if (iov_iter_rw(iter) == WRITE) {
-		endio = xfs_end_io_direct_write;
-		flags = DIO_ASYNC_EXTEND;
-	}
-
-	if (IS_DAX(inode)) {
-		return dax_do_io(iocb, inode, iter,
-				 xfs_get_blocks_direct, endio, 0);
-	}
-
-	bdev = xfs_find_bdev_for_inode(inode);
-	return  __blockdev_direct_IO(iocb, inode, bdev, iter,
-			xfs_get_blocks_direct, endio, NULL, flags);
+	/*
+	 * We just need the method present so that open/fcntl allow direct I/O.
+	 */
+	return -EINVAL;
 }
 
 STATIC sector_t
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 814aab7..bf2d9a1 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -60,6 +60,9 @@ int	xfs_get_blocks_direct(struct inode *inode, sector_t offset,
 int	xfs_get_blocks_dax_fault(struct inode *inode, sector_t offset,
 			         struct buffer_head *map_bh, int create);
 
+int	xfs_end_io_direct_write(struct kiocb *iocb, loff_t offset,
+		ssize_t size, void *private);
+
 extern void xfs_count_page_state(struct page *, int *, int *);
 extern struct block_device *xfs_find_bdev_for_inode(struct inode *);
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f761f49..24b267d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -317,7 +317,13 @@ xfs_file_dio_aio_read(
 	}
 
 	data = *to;
-	ret = mapping->a_ops->direct_IO(iocb, &data);
+	if (IS_DAX(inode)) {
+		ret = dax_do_io(iocb, inode, &data, xfs_get_blocks_direct,
+				NULL, 0);
+	} else {
+		ret = __blockdev_direct_IO(iocb, inode, target->bt_bdev, &data,
+				xfs_get_blocks_direct, NULL, NULL, 0);
+	}
 	if (ret > 0) {
 		iocb->ki_pos += ret;
 		iov_iter_advance(to, ret);
@@ -650,7 +656,14 @@ xfs_file_dio_aio_write(
 	trace_xfs_file_direct_write(ip, count, iocb->ki_pos);
 
 	data = *from;
-	ret = mapping->a_ops->direct_IO(iocb, &data);
+	if (IS_DAX(inode)) {
+		ret = dax_do_io(iocb, inode, &data, xfs_get_blocks_direct,
+				xfs_end_io_direct_write, 0);
+	} else {
+		ret = __blockdev_direct_IO(iocb, inode, target->bt_bdev, &data,
+				xfs_get_blocks_direct, xfs_end_io_direct_write,
+				NULL, DIO_ASYNC_EXTEND);
+	}
 
 	/* see generic_file_direct_write() for why this is necessary */
 	if (mapping->nrpages) {
-- 
2.1.4
