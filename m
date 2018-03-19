Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E2AA8225B02AA
 for <linux-nvdimm@lists.01.org>; Mon, 19 Mar 2018 10:27:23 -0700 (PDT)
Date: Mon, 19 Mar 2018 10:33:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v6 12/15] xfs: require mmap lock for xfs_break_layouts()
Message-ID: <20180319173345.GF1757@magnolia>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152112914933.24669.5543317105428477772.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152112914933.24669.5543317105428477772.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 15, 2018 at 08:52:29AM -0700, Dan Williams wrote:
> In preparation for adding coordination between truncate operations and
> busy dax-pages, extend xfs_break_layouts() to assume it must be called
> with the mmap lock held. This locking scheme will be required for
> coordinating the break of 'dax layouts' (non-idle dax (ZONE_DEVICE)
> pages mapped into the file's address space).

If I'm reading this right, you've added a requirement (for xfs anyway)
that we have to have grabbed MMAPLOCK_EXCL before calling break_layout()
so that the layout breaking process will block until active dmas have
finished.

In 4.16 we added xfs_iolock_two_inodes_and_break_layout (in
xfs_reflink.c) to break pnfs leases for files that are about to be
reflinked (since pnfs and reflink aren't compatible either).  I think
that function will have to be adapted to take the appropriate mmap locks
too -- definitely the exclusive mmap lock for the destination file
because we anticipate punching out blocks.  I'm not sure about the
source file; I think taking the shared mmap lock is fine for that?

--D

> 
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/xfs/xfs_file.c  |   14 +++++++++-----
>  fs/xfs/xfs_ioctl.c |    5 +----
>  fs/xfs/xfs_iops.c  |   10 +++++++---
>  fs/xfs/xfs_pnfs.c  |    6 ++++--
>  4 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 9ea08326f876..ba969019bf26 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -350,9 +350,16 @@ xfs_file_aio_write_checks(
>  	if (error <= 0)
>  		return error;
>  
> +	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> +	*iolock |= XFS_MMAPLOCK_EXCL;
>  	error = xfs_break_layouts(inode, iolock);
> -	if (error)
> +	if (error) {
> +		*iolock &= ~XFS_MMAPLOCK_EXCL;
> +		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
>  		return error;
> +	}
> +	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> +	*iolock &= ~XFS_MMAPLOCK_EXCL;
>  
>  	/*
>  	 * For changing security info in file_remove_privs() we need i_rwsem
> @@ -768,7 +775,7 @@ xfs_file_fallocate(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	long			error;
>  	enum xfs_prealloc_flags	flags = 0;
> -	uint			iolock = XFS_IOLOCK_EXCL;
> +	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
>  	loff_t			new_size = 0;
>  	bool			do_file_insert = false;
>  
> @@ -782,9 +789,6 @@ xfs_file_fallocate(
>  	if (error)
>  		goto out_unlock;
>  
> -	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> -	iolock |= XFS_MMAPLOCK_EXCL;
> -
>  	if (mode & FALLOC_FL_PUNCH_HOLE) {
>  		error = xfs_free_file_space(ip, offset, len);
>  		if (error)
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 89fb1eb80aae..4151fade4bb1 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -614,7 +614,7 @@ xfs_ioc_space(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct iattr		iattr;
>  	enum xfs_prealloc_flags	flags = 0;
> -	uint			iolock = XFS_IOLOCK_EXCL;
> +	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
>  	int			error;
>  
>  	/*
> @@ -648,9 +648,6 @@ xfs_ioc_space(
>  	if (error)
>  		goto out_unlock;
>  
> -	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> -	iolock |= XFS_MMAPLOCK_EXCL;
> -
>  	switch (bf->l_whence) {
>  	case 0: /*SEEK_SET*/
>  		break;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 951e84df5576..d23aa08426f9 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1028,13 +1028,17 @@ xfs_vn_setattr(
>  
>  	if (iattr->ia_valid & ATTR_SIZE) {
>  		struct xfs_inode	*ip = XFS_I(d_inode(dentry));
> -		uint			iolock = XFS_IOLOCK_EXCL;
> +		uint			iolock;
> +
> +		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> +		iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
>  
>  		error = xfs_break_layouts(d_inode(dentry), &iolock);
> -		if (error)
> +		if (error) {
> +			xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
>  			return error;
> +		}
>  
> -		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
>  		error = xfs_vn_setattr_size(dentry, iattr);
>  		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
>  	} else {
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index aa6c5c193f45..9fe661c2d59c 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -38,12 +38,14 @@ xfs_break_layouts(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
> +				| XFS_MMAPLOCK_EXCL));
>  
>  	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
>  		xfs_iunlock(ip, *iolock);
>  		error = break_layout(inode, true);
> -		*iolock = XFS_IOLOCK_EXCL;
> +		*iolock &= ~XFS_IOLOCK_SHARED;
> +		*iolock |= XFS_IOLOCK_EXCL;
>  		xfs_ilock(ip, *iolock);
>  	}
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
