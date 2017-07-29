Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 01AE621E1DB21
 for <linux-nvdimm@lists.01.org>; Sat, 29 Jul 2017 12:47:54 -0700 (PDT)
Subject: [PATCH 1/3] fs, xfs: introduce S_IOMAP_IMMUTABLE
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 29 Jul 2017 12:43:35 -0700
Message-ID: <150135741519.35318.16765137368329971936.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: darrick.wong@oracle.com
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

An inode with this flag set indicates that the file's block map cannot
be changed, no size change, deletion, hole-punch, range collapse, or
reflink.

The implementation of toggling the flag and sealing the state of the
extent map is saved for a later patch. The functionality provided by
S_IOMAP_IMMUTABLE, once toggle support is added, will be a superset of
that provided by S_SWAPFILE, and it is targeted to replace it.

For now, only xfs and the core vfs are updated to consider the new flag.

The additional check that is added for this flag, beyond what we are
already doing for swapfiles, is to truncate or abort writes that try to
extend the file size.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Suggested-by: Dave Chinner <david@fromorbit.com>
Suggested-by: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/attr.c          |   10 ++++++++++
 fs/namei.c         |    3 ++-
 fs/open.c          |    6 ++++++
 fs/read_write.c    |    3 +++
 fs/xfs/xfs_ioctl.c |    6 ++++++
 include/linux/fs.h |    2 ++
 mm/filemap.c       |    9 +++++++++
 7 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/attr.c b/fs/attr.c
index 135304146120..8573e364bd06 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -112,6 +112,16 @@ EXPORT_SYMBOL(setattr_prepare);
  */
 int inode_newsize_ok(const struct inode *inode, loff_t offset)
 {
+	if (IS_IOMAP_IMMUTABLE(inode)) {
+		/*
+		 * Any size change is disallowed. Size increases may
+		 * dirty metadata that an application is not prepared to
+		 * sync, and a size decrease may expose free blocks to
+		 * in-flight DMA.
+		 */
+		return -ETXTBSY;
+	}
+
 	if (inode->i_size < offset) {
 		unsigned long limit;
 
diff --git a/fs/namei.c b/fs/namei.c
index ddb6a7c2b3d4..588f1135c42c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2793,7 +2793,8 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 		return -EPERM;
 
 	if (check_sticky(dir, inode) || IS_APPEND(inode) ||
-	    IS_IMMUTABLE(inode) || IS_SWAPFILE(inode) || HAS_UNMAPPED_ID(inode))
+	    IS_IMMUTABLE(inode) || IS_SWAPFILE(inode) || HAS_UNMAPPED_ID(inode)
+	    || IS_IOMAP_IMMUTABLE(inode))
 		return -EPERM;
 	if (isdir) {
 		if (!d_is_dir(victim))
diff --git a/fs/open.c b/fs/open.c
index 35bb784763a4..7395860d7164 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -292,6 +292,12 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -ETXTBSY;
 
 	/*
+	 * We cannot allow any allocation changes on an iomap immutable file
+	 */
+	if (IS_IOMAP_IMMUTABLE(inode))
+		return -ETXTBSY;
+
+	/*
 	 * Revalidate the write permissions, in case security policy has
 	 * changed since the files were opened.
 	 */
diff --git a/fs/read_write.c b/fs/read_write.c
index 0cc7033aa413..dc673be7c7cb 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1706,6 +1706,9 @@ int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
 	if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
 		return -ETXTBSY;
 
+	if (IS_IOMAP_IMMUTABLE(inode_in) || IS_IOMAP_IMMUTABLE(inode_out))
+		return -ETXTBSY;
+
 	/* Don't reflink dirs, pipes, sockets... */
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e75c40a47b7d..2e64488bc4de 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1755,6 +1755,12 @@ xfs_ioc_swapext(
 		goto out_put_tmp_file;
 	}
 
+	if (IS_IOMAP_IMMUTABLE(file_inode(f.file)) ||
+	    IS_IOMAP_IMMUTABLE(file_inode(tmp.file))) {
+		error = -EINVAL;
+		goto out_put_tmp_file;
+	}
+
 	/*
 	 * We need to ensure that the fds passed in point to XFS inodes
 	 * before we cast and access them as XFS structures as we have no
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6e1fd5d21248..0a254b768855 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1829,6 +1829,7 @@ struct super_operations {
 #else
 #define S_DAX		0	/* Make all the DAX code disappear */
 #endif
+#define S_IOMAP_IMMUTABLE 16384 /* logical-to-physical extent map is fixed */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -1867,6 +1868,7 @@ struct super_operations {
 #define IS_AUTOMOUNT(inode)	((inode)->i_flags & S_AUTOMOUNT)
 #define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
 #define IS_DAX(inode)		((inode)->i_flags & S_DAX)
+#define IS_IOMAP_IMMUTABLE(inode) ((inode)->i_flags & S_IOMAP_IMMUTABLE)
 
 #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
 				 (inode)->i_rdev == WHITEOUT_DEV)
diff --git a/mm/filemap.c b/mm/filemap.c
index a49702445ce0..e4a6529da2bd 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2806,6 +2806,15 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	if (unlikely(pos >= inode->i_sb->s_maxbytes))
 		return -EFBIG;
 
+	/* Are we about to mutate the block map on an immutable file? */
+	if (IS_IOMAP_IMMUTABLE(inode)
+			&& (pos + iov_iter_count(from) > i_size_read(inode))) {
+		if (pos < i_size_read(inode))
+			iov_iter_truncate(from, i_size_read(inode) - pos);
+		else
+			return -ETXTBSY;
+	}
+
 	iov_iter_truncate(from, inode->i_sb->s_maxbytes - pos);
 	return iov_iter_count(from);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
