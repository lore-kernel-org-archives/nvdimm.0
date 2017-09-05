Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2A17421E47D66
 for <linux-nvdimm@lists.01.org>; Tue,  5 Sep 2017 15:33:30 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 9/9] ext4: add per-inode DAX flag
Date: Tue,  5 Sep 2017 16:35:41 -0600
Message-Id: <20170905223541.20594-10-ross.zwisler@linux.intel.com>
In-Reply-To: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Follow the lead of XFS and add a per-inode flag that allows the choice of
whether or not to use DAX to be made for individual files.  As with XFS
this flag can also be set on a directory, in which case it will be
inherited by new inodes (both subdirectories and files) created within that
directory.

This inode flag can be viewed and manipulated using xfs_io, just as is done
with the XFS version of this flag:

  # mount /dev/pmem0 /mnt/

  # mount | grep /mnt
  /dev/pmem0 on /mnt type ext4 (rw,relatime,seclabel,data=ordered)

  # touch /mnt/a

  # xfs_io -c lsattr /mnt/a
  ---------------- /mnt/a

  # xfs_io -c 'chattr +x' /mnt/a

  # xfs_io -c lsattr /mnt/a
  --------------x- /mnt/a

We will use DAX in ext4 if either the mount option is used or if the inode
flag is set.

The 'chattr +x' functionality of xfs_io has been in place for foreign
filesystems (ext4) since xfsprogs v4.8.0.  Support for 'lsattr' on foreign
filesystems was added with:

commit e13a325cd7a9 ("xfs_io: allow lsattr & lsproj on foreign filesystems")

which can currently be found in the "for-next" branch.

The rules for the per-inode DAX flag in ext4 are pretty much the same as
the rules for the '-o dax' mount option:

1) When DAX and journaling are both requested on the same inode, journaling
will win and DAX will be turned off.  The S_DAX transitions due to
journaling mode changes are done safely by locking out page faults and I/O,
doing a writeback and an invalidate.

2) The DAX inode flag will fail with -EINVAL for filesystems that can
contain inline data.

3) If you try and use DAX on an encrypted inode, the inode will accept the
DAX inode flag but DAX will never be used.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

---

The behavior of the DAX inode flag when combined with journaling, inline
data and encryption was meant to stay as consistent as possible with the
'-o dax' mount option.  If there is a better way to handle these conflics,
please let me know.
---
 fs/ext4/ext4.h      | 10 ++++++----
 fs/ext4/ext4_jbd2.h |  5 +++--
 fs/ext4/inode.c     |  2 +-
 fs/ext4/ioctl.c     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c950278..9d8e067 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -399,10 +399,11 @@ struct flex_groups {
 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
 #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data. */
 #define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
+#define EXT4_DAX_FL			0x40000000 /* use DAX for IO */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
-#define EXT4_FL_USER_VISIBLE		0x304BDFFF /* User visible flags */
-#define EXT4_FL_USER_MODIFIABLE		0x204BC0FF /* User modifiable flags */
+#define EXT4_FL_USER_VISIBLE		0x704BDFFF /* User visible flags */
+#define EXT4_FL_USER_MODIFIABLE		0x604BC0FF /* User modifiable flags */
 
 /* Flags we can manipulate with through EXT4_IOC_FSSETXATTR */
 #define EXT4_FL_XFLAG_VISIBLE		(EXT4_SYNC_FL | \
@@ -410,14 +411,15 @@ struct flex_groups {
 					 EXT4_APPEND_FL | \
 					 EXT4_NODUMP_FL | \
 					 EXT4_NOATIME_FL | \
-					 EXT4_PROJINHERIT_FL)
+					 EXT4_PROJINHERIT_FL | \
+					 EXT4_DAX_FL)
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
 			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
 			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
 			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL |\
-			   EXT4_PROJINHERIT_FL)
+			   EXT4_PROJINHERIT_FL | EXT4_DAX_FL)
 
 /* Flags that are appropriate for regular files (all but dir-specific ones). */
 #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 65e2aa9..14b7a84 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -462,9 +462,10 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
 	return 1;
 }
 
-static inline bool ext4_should_use_dax(struct inode *inode)
+static inline bool ext4_should_use_dax(struct inode *inode,
+		bool dax_inode_flag)
 {
-	if (!test_opt(inode->i_sb, DAX))
+	if (!(test_opt(inode->i_sb, DAX) || dax_inode_flag))
 		return false;
 	if (!S_ISREG(inode->i_mode))
 		return false;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index facb5ae..022ca58 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4599,7 +4599,7 @@ void ext4_set_inode_flags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (flags & EXT4_DIRSYNC_FL)
 		new_fl |= S_DIRSYNC;
-	if (ext4_should_use_dax(inode))
+	if (ext4_should_use_dax(inode, !!(flags & EXT4_DAX_FL)))
 		new_fl |= S_DAX;
 	inode_set_flags(inode, new_fl,
 			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index afb66d4..8626a94 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -22,6 +22,7 @@
 #include <linux/fsmap.h>
 #include "fsmap.h"
 #include <trace/events/ext4.h>
+#include <linux/dax.h>
 
 /**
  * Swap memory between @a and @b for @len bytes.
@@ -205,6 +206,41 @@ static int uuid_is_zero(__u8 u[16])
 }
 #endif
 
+static int ext4_ioctl_dax_invalidate(struct inode *inode, bool dax_inode_flag)
+{
+	bool old_dax = !!(inode->i_flags & S_DAX);
+	bool new_dax = ext4_should_use_dax(inode, dax_inode_flag);
+	struct super_block *sb = inode->i_sb;
+
+	lockdep_assert_held(&inode->i_rwsem);
+	lockdep_assert_held(&EXT4_I(inode)->i_mmap_sem);
+
+	if (dax_inode_flag) {
+		if (ext4_has_feature_inline_data(sb)) {
+			ext4_msg(sb, KERN_ERR, "Cannot use DAX on a filesystem"
+					" that may contain inline data");
+			return -EINVAL;
+		}
+		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
+			return -EINVAL;
+		if (bdev_dax_supported(sb, sb->s_blocksize) < 0)
+			return -EINVAL;
+	}
+
+	if (old_dax != new_dax) {
+		int err;
+
+		err = filemap_write_and_wait(inode->i_mapping);
+		if (err)
+			return err;
+
+		err = invalidate_inode_pages2(inode->i_mapping);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 static int ext4_ioctl_setflags(struct inode *inode,
 			       unsigned int flags)
 {
@@ -258,10 +294,15 @@ static int ext4_ioctl_setflags(struct inode *inode,
 			goto flags_out;
 	}
 
+	down_write(&ei->i_mmap_sem);
+	err = ext4_ioctl_dax_invalidate(inode, !!(flags & EXT4_DAX_FL));
+	if (err)
+		goto unlock_out;
+
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
-		goto flags_out;
+		goto unlock_out;
 	}
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
@@ -286,6 +327,7 @@ static int ext4_ioctl_setflags(struct inode *inode,
 
 	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
 flags_err:
+	up_write(&ei->i_mmap_sem);
 	ext4_journal_stop(handle);
 	if (err)
 		goto flags_out;
@@ -303,6 +345,10 @@ static int ext4_ioctl_setflags(struct inode *inode,
 
 flags_out:
 	return err;
+
+unlock_out:
+	up_write(&ei->i_mmap_sem);
+	return err;
 }
 
 #ifdef CONFIG_QUOTA
@@ -425,12 +471,15 @@ static inline __u32 ext4_iflags_to_xflags(unsigned long iflags)
 		xflags |= FS_XFLAG_NOATIME;
 	if (iflags & EXT4_PROJINHERIT_FL)
 		xflags |= FS_XFLAG_PROJINHERIT;
+	if (iflags & EXT4_DAX_FL)
+		xflags |= FS_XFLAG_DAX;
 	return xflags;
 }
 
 #define EXT4_SUPPORTED_FS_XFLAGS (FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | \
 				  FS_XFLAG_APPEND | FS_XFLAG_NODUMP | \
-				  FS_XFLAG_NOATIME | FS_XFLAG_PROJINHERIT)
+				  FS_XFLAG_NOATIME | FS_XFLAG_PROJINHERIT | \
+				  FS_XFLAG_DAX)
 
 /* Transfer xflags flags to internal */
 static inline unsigned long ext4_xflags_to_iflags(__u32 xflags)
@@ -449,6 +498,8 @@ static inline unsigned long ext4_xflags_to_iflags(__u32 xflags)
 		iflags |= EXT4_NOATIME_FL;
 	if (xflags & FS_XFLAG_PROJINHERIT)
 		iflags |= EXT4_PROJINHERIT_FL;
+	if (xflags & FS_XFLAG_DAX)
+		iflags |= EXT4_DAX_FL;
 
 	return iflags;
 }
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
