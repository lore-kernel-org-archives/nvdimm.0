From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/8] xfs: don't pass ioflags around in the ioctl path
Date: Wed, 22 Jun 2016 17:27:09 +0200
Message-ID: <1466609236-23801-2-git-send-email-hch@lst.de>
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

Instead check the file pointer for the invisble I/O flag directly, and
use the chance to drop redundant arguments from the xfs_ioc_space
prototype.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/xfs/xfs_ioctl.c   | 22 ++++++++--------------
 fs/xfs/xfs_ioctl.h   |  3 ---
 fs/xfs/xfs_ioctl32.c |  6 +-----
 3 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index dbca737..6ab5a24 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -595,13 +595,12 @@ xfs_attrmulti_by_handle(
 
 int
 xfs_ioc_space(
-	struct xfs_inode	*ip,
-	struct inode		*inode,
 	struct file		*filp,
-	int			ioflags,
 	unsigned int		cmd,
 	xfs_flock64_t		*bf)
 {
+	struct inode		*inode = file_inode(filp);
+	struct xfs_inode	*ip = XFS_I(inode);
 	struct iattr		iattr;
 	enum xfs_prealloc_flags	flags = 0;
 	uint			iolock = XFS_IOLOCK_EXCL;
@@ -626,7 +625,7 @@ xfs_ioc_space(
 
 	if (filp->f_flags & O_DSYNC)
 		flags |= XFS_PREALLOC_SYNC;
-	if (ioflags & XFS_IO_INVIS)
+	if (filp->f_mode & FMODE_NOCMTIME)
 		flags |= XFS_PREALLOC_INVISIBLE;
 
 	error = mnt_want_write_file(filp);
@@ -1464,8 +1463,7 @@ xfs_getbmap_format(void **ap, struct getbmapx *bmv, int *full)
 
 STATIC int
 xfs_ioc_getbmap(
-	struct xfs_inode	*ip,
-	int			ioflags,
+	struct file		*file,
 	unsigned int		cmd,
 	void			__user *arg)
 {
@@ -1479,10 +1477,10 @@ xfs_ioc_getbmap(
 		return -EINVAL;
 
 	bmx.bmv_iflags = (cmd == XFS_IOC_GETBMAPA ? BMV_IF_ATTRFORK : 0);
-	if (ioflags & XFS_IO_INVIS)
+	if (file->f_mode & FMODE_NOCMTIME)
 		bmx.bmv_iflags |= BMV_IF_NO_DMAPI_READ;
 
-	error = xfs_getbmap(ip, &bmx, xfs_getbmap_format,
+	error = xfs_getbmap(XFS_I(file_inode(file)), &bmx, xfs_getbmap_format,
 			    (__force struct getbmap *)arg+1);
 	if (error)
 		return error;
@@ -1619,12 +1617,8 @@ xfs_file_ioctl(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	void			__user *arg = (void __user *)p;
-	int			ioflags = 0;
 	int			error;
 
-	if (filp->f_mode & FMODE_NOCMTIME)
-		ioflags |= XFS_IO_INVIS;
-
 	trace_xfs_file_ioctl(ip);
 
 	switch (cmd) {
@@ -1643,7 +1637,7 @@ xfs_file_ioctl(
 
 		if (copy_from_user(&bf, arg, sizeof(bf)))
 			return -EFAULT;
-		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, &bf);
+		return xfs_ioc_space(filp, cmd, &bf);
 	}
 	case XFS_IOC_DIOINFO: {
 		struct dioattr	da;
@@ -1702,7 +1696,7 @@ xfs_file_ioctl(
 
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
-		return xfs_ioc_getbmap(ip, ioflags, cmd, arg);
+		return xfs_ioc_getbmap(filp, cmd, arg);
 
 	case XFS_IOC_GETBMAPX:
 		return xfs_ioc_getbmapx(ip, arg);
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 77c02c7..8b52881 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -20,10 +20,7 @@
 
 extern int
 xfs_ioc_space(
-	struct xfs_inode	*ip,
-	struct inode		*inode,
 	struct file		*filp,
-	int			ioflags,
 	unsigned int		cmd,
 	xfs_flock64_t		*bf);
 
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 1a05d8a..321f577 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -532,12 +532,8 @@ xfs_file_compat_ioctl(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	void			__user *arg = (void __user *)p;
-	int			ioflags = 0;
 	int			error;
 
-	if (filp->f_mode & FMODE_NOCMTIME)
-		ioflags |= XFS_IO_INVIS;
-
 	trace_xfs_file_compat_ioctl(ip);
 
 	switch (cmd) {
@@ -589,7 +585,7 @@ xfs_file_compat_ioctl(
 		if (xfs_compat_flock64_copyin(&bf, arg))
 			return -EFAULT;
 		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
-		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, &bf);
+		return xfs_ioc_space(filp, cmd, &bf);
 	}
 	case XFS_IOC_FSGEOMETRY_V1_32:
 		return xfs_compat_ioc_fsgeometry_v1(mp, arg);
-- 
2.1.4
