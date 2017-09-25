Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0537E2095E513
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 16:11:20 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 7/7] xfs: re-enable XFS per-inode DAX
Date: Mon, 25 Sep 2017 17:14:04 -0600
Message-Id: <20170925231404.32723-8-ross.zwisler@linux.intel.com>
In-Reply-To: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Re-enable the XFS per-inode DAX flag, preventing S_DAX from changing when
any mappings are present.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/xfs/xfs_ioctl.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 386b437..7a24dd5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1012,12 +1012,10 @@ xfs_diflags_to_linux(
 		inode->i_flags |= S_NOATIME;
 	else
 		inode->i_flags &= ~S_NOATIME;
-#if 0	/* disabled until the flag switching races are sorted out */
 	if ((xflags & FS_XFLAG_DAX) || (ip->i_mount->m_flags & XFS_MOUNT_DAX))
 		inode->i_flags |= S_DAX;
 	else
 		inode->i_flags &= ~S_DAX;
-#endif
 }
 
 static bool
@@ -1049,6 +1047,8 @@ xfs_ioctl_setattr_xflags(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	uint64_t		di_flags2;
+	struct address_space	*mapping = VFS_I(ip)->i_mapping;
+	bool			dax_changing;
 
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
@@ -1084,10 +1084,23 @@ xfs_ioctl_setattr_xflags(
 	if (di_flags2 && ip->i_d.di_version < 3)
 		return -EINVAL;
 
+	dax_changing = xfs_is_dax_state_changing(fa->fsx_xflags, ip);
+	if (dax_changing) {
+		i_mmap_lock_read(mapping);
+		if (mapping_mapped(mapping)) {
+			i_mmap_unlock_read(mapping);
+			return -EBUSY;
+		}
+	}
+
 	ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
 	ip->i_d.di_flags2 = di_flags2;
 
 	xfs_diflags_to_linux(ip);
+
+	if (dax_changing)
+		i_mmap_unlock_read(mapping);
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	XFS_STATS_INC(mp, xs_ig_attrchg);
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
