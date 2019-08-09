Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 267C22131D580
 for <linux-nvdimm@lists.01.org>; Fri,  9 Aug 2019 16:01:33 -0700 (PDT)
From: ira.weiny@intel.com
Subject: [RFC PATCH v2 07/19] fs/xfs: Teach xfs to use new
 dax_layout_busy_page()
Date: Fri,  9 Aug 2019 15:58:21 -0700
Message-Id: <20190809225833.6657-8-ira.weiny@intel.com>
In-Reply-To: <20190809225833.6657-1-ira.weiny@intel.com>
References: <20190809225833.6657-1-ira.weiny@intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ira Weiny <ira.weiny@intel.com>

dax_layout_busy_page() can now operate on a sub-range of the
address_space provided.

Have xfs specify the sub range to dax_layout_busy_page()

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/xfs/xfs_file.c  | 19 +++++++++++++------
 fs/xfs/xfs_inode.h |  5 +++--
 fs/xfs/xfs_ioctl.c | 15 ++++++++++++---
 fs/xfs/xfs_iops.c  | 14 ++++++++++----
 4 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8f8d478f9ec6..447571e3cb02 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -295,7 +295,11 @@ xfs_file_aio_write_checks(
 	if (error <= 0)
 		return error;
 
-	error = xfs_break_layouts(inode, iolock, BREAK_WRITE);
+	/*
+	 * BREAK_WRITE ignores offset/len tuple just specify the whole file
+	 * (0 - ULONG_MAX to be safe.
+	 */
+	error = xfs_break_layouts(inode, iolock, 0, ULONG_MAX, BREAK_WRITE);
 	if (error)
 		return error;
 
@@ -734,14 +738,15 @@ xfs_wait_dax_page(
 static int
 xfs_break_dax_layouts(
 	struct inode		*inode,
-	bool			*retry)
+	bool			*retry,
+	loff_t                   off,
+	loff_t                   len)
 {
 	struct page		*page;
 
 	ASSERT(xfs_isilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL));
 
-	/* We default to the "whole file" */
-	page = dax_layout_busy_page(inode->i_mapping, 0, ULONG_MAX);
+	page = dax_layout_busy_page(inode->i_mapping, off, len);
 	if (!page)
 		return 0;
 
@@ -755,6 +760,8 @@ int
 xfs_break_layouts(
 	struct inode		*inode,
 	uint			*iolock,
+	loff_t                   off,
+	loff_t                   len,
 	enum layout_break_reason reason)
 {
 	bool			retry;
@@ -766,7 +773,7 @@ xfs_break_layouts(
 		retry = false;
 		switch (reason) {
 		case BREAK_UNMAP:
-			error = xfs_break_dax_layouts(inode, &retry);
+			error = xfs_break_dax_layouts(inode, &retry, off, len);
 			if (error || retry)
 				break;
 			/* fall through */
@@ -808,7 +815,7 @@ xfs_file_fallocate(
 		return -EOPNOTSUPP;
 
 	xfs_ilock(ip, iolock);
-	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
+	error = xfs_break_layouts(inode, &iolock, offset, len, BREAK_UNMAP);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 558173f95a03..1b0948f5267c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -475,8 +475,9 @@ enum xfs_prealloc_flags {
 
 int	xfs_update_prealloc_flags(struct xfs_inode *ip,
 				  enum xfs_prealloc_flags flags);
-int	xfs_break_layouts(struct inode *inode, uint *iolock,
-		enum layout_break_reason reason);
+int xfs_break_layouts(struct inode *inode, uint *iolock,
+		      loff_t off, loff_t len,
+		      enum layout_break_reason reason);
 
 /* from xfs_iops.c */
 extern void xfs_setup_inode(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6f7848cd5527..3897b88080bd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -597,6 +597,7 @@ xfs_ioc_space(
 	enum xfs_prealloc_flags	flags = 0;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	int			error;
+	loff_t                  break_length;
 
 	if (inode->i_flags & (S_IMMUTABLE|S_APPEND))
 		return -EPERM;
@@ -617,9 +618,6 @@ xfs_ioc_space(
 		return error;
 
 	xfs_ilock(ip, iolock);
-	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
-	if (error)
-		goto out_unlock;
 
 	switch (bf->l_whence) {
 	case 0: /*SEEK_SET*/
@@ -665,6 +663,17 @@ xfs_ioc_space(
 		goto out_unlock;
 	}
 
+	/* break layout for the whole file if len ends up 0 */
+	if (bf->l_len == 0)
+		break_length = ULONG_MAX;
+	else
+		break_length = bf->l_len;
+
+	error = xfs_break_layouts(inode, &iolock, bf->l_start, break_length,
+				  BREAK_UNMAP);
+	if (error)
+		goto out_unlock;
+
 	switch (cmd) {
 	case XFS_IOC_ZERO_RANGE:
 		flags |= XFS_PREALLOC_SET;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ff3c1fae5357..f0de5486f6c1 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1042,10 +1042,16 @@ xfs_vn_setattr(
 		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 		iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 
-		error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
-		if (error) {
-			xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
-			return error;
+		if (iattr->ia_size < inode->i_size) {
+			loff_t                  off = iattr->ia_size;
+			loff_t                  len = inode->i_size - iattr->ia_size;
+
+			error = xfs_break_layouts(inode, &iolock, off, len,
+						  BREAK_UNMAP);
+			if (error) {
+				xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
+				return error;
+			}
 		}
 
 		error = xfs_vn_setattr_size(dentry, iattr);
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
