From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 5/8] xfs: stop using generic_file_read_iter for direct I/O
Date: Wed, 22 Jun 2016 17:27:13 +0200
Message-ID: <1466609236-23801-6-git-send-email-hch@lst.de>
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

XFS already implement it's own flushing of the pagecache because it
implements proper synchronization for direct I/O reads.  This means
calling generic_file_read_iter for direct I/O is rather useless,
as it doesn't do much but updating the atime and iocb position for
us.  This also gets rid of the buffered I/O fallback that isn't used
for XFS.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/xfs/xfs_file.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e584333..f761f49 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -246,12 +246,17 @@ xfs_file_dio_aio_read(
 	struct address_space	*mapping = iocb->ki_filp->f_mapping;
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
+	loff_t			isize = i_size_read(inode);
 	size_t			count = iov_iter_count(to);
+	struct iov_iter		data;
 	struct xfs_buftarg	*target;
 	ssize_t			ret = 0;
 
 	trace_xfs_file_direct_read(ip, count, iocb->ki_pos);
 
+	if (!count)
+		return 0; /* skip atime */
+
 	if (XFS_IS_REALTIME_INODE(ip))
 		target = ip->i_mount->m_rtdev_targp;
 	else
@@ -260,7 +265,7 @@ xfs_file_dio_aio_read(
 	if (!IS_DAX(inode)) {
 		/* DIO must be aligned to device logical sector size */
 		if ((iocb->ki_pos | count) & target->bt_logical_sectormask) {
-			if (iocb->ki_pos == i_size_read(inode))
+			if (iocb->ki_pos == isize)
 				return 0;
 			return -EINVAL;
 		}
@@ -311,9 +316,15 @@ xfs_file_dio_aio_read(
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
 	}
 
-	ret = generic_file_read_iter(iocb, to);
+	data = *to;
+	ret = mapping->a_ops->direct_IO(iocb, &data);
+	if (ret > 0) {
+		iocb->ki_pos += ret;
+		iov_iter_advance(to, ret);
+	}
 	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 
+	file_accessed(iocb->ki_filp);
 	return ret;
 }
 
-- 
2.1.4
