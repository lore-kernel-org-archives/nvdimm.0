Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 19E70224A9ECD
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 08:17:28 -0700 (PDT)
Date: Fri, 30 Mar 2018 08:16:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v7 12/14] xfs: prepare xfs_break_layouts() to be called
 with XFS_MMAPLOCK_EXCL
Message-ID: <20180330151600.GC13552@magnolia>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167310017.5268.8654419042128713101.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152167310017.5268.8654419042128713101.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Wed, Mar 21, 2018 at 03:58:20PM -0700, Dan Williams wrote:
> In preparation for adding coordination between extent unmap operations
> and busy dax-pages, update xfs_break_layouts() to permit it to be called
> with the mmap lock held. This lock scheme will be required for
> coordinating the break of 'dax layouts' (non-idle dax (ZONE_DEVICE)
> pages mapped into the file's address space). Breaking dax layouts will
> be added to xfs_break_layouts() in a future patch, for now this preps
> the unmap call sites to take and hold XFS_MMAPLOCK_EXCL over the call to
> xfs_break_layouts().
> 
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_file.c  |    5 +----
>  fs/xfs/xfs_ioctl.c |    5 +----
>  fs/xfs/xfs_iops.c  |   10 +++++++---
>  fs/xfs/xfs_pnfs.c  |    3 ++-
>  4 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 9ea08326f876..18edf04811d0 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -768,7 +768,7 @@ xfs_file_fallocate(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	long			error;
>  	enum xfs_prealloc_flags	flags = 0;
> -	uint			iolock = XFS_IOLOCK_EXCL;
> +	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
>  	loff_t			new_size = 0;
>  	bool			do_file_insert = false;
>  
> @@ -782,9 +782,6 @@ xfs_file_fallocate(
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
> index aa6c5c193f45..6ea7b0b55d02 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -43,7 +43,8 @@ xfs_break_layouts(
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
