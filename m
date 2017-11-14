Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D8A822035523B
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 18:10:18 -0800 (PST)
Date: Mon, 13 Nov 2017 18:14:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs, dax: unify IOMAP_F_DIRTY read vs write handling
 policy in the dax core
Message-ID: <20171114021416.GG25227@magnolia>
References: <151062258598.8554.8157038002895095232.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151062258598.8554.8157038002895095232.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 13, 2017 at 05:27:54PM -0800, Dan Williams wrote:
> While reviewing whether MAP_SYNC should strengthen its current guarantee
> of syncing writes from the initiating process to also include
> third-party readers observing dirty metadata, Dave pointed out that the
> check of IOMAP_WRITE is misplaced.
> 
> The policy of what to with IOMAP_F_DIRTY should be separated from the
> generic filesystem mechanism of reporting dirty metadata. Move this
> policy to the fs-dax core to simplify the per-filesystem iomap handlers,
> and further centralize code that implements the MAP_SYNC policy. This
> otherwise should not change behavior, it just makes it easier to change
> behavior in the future.

Yes, this was what I was looking for on my last read-through. :)

> Cc: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> This is an additional cleanup I want to include in the 4.15 merge
> request for the MAP_SYNC feature. Please review, I'm looking to send the
> pull request towards the end of the week.
> 
> 
>  fs/dax.c           |   15 +++++++++++++--
>  fs/ext4/inode.c    |    2 +-
>  fs/xfs/xfs_iomap.c |    6 +++---
>  3 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 78233c716757..27ba300660ff 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1079,6 +1079,17 @@ static int dax_fault_return(int error)
>  	return VM_FAULT_SIGBUS;
>  }
>  
> +/*
> + * MAP_SYNC on a dax mapping guarantees dirty metadata is
> + * flushed on write-faults (non-cow), but not read-faults.
> + */
> +static bool dax_fault_is_synchronous(unsigned long flags,
> +		struct vm_area_struct *vma, struct iomap *iomap)
> +{
> +	return (flags & IOMAP_WRITE) && (vma->vm_flags & VM_SYNC)
> +		&& (iomap->flags & IOMAP_F_DIRTY);
> +}
> +
>  static int dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  			       const struct iomap_ops *ops)
>  {
> @@ -1170,7 +1181,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  		goto finish_iomap;
>  	}
>  
> -	sync = (vma->vm_flags & VM_SYNC) && (iomap.flags & IOMAP_F_DIRTY);
> +	sync = dax_fault_is_synchronous(flags, vma, &iomap);
>  
>  	switch (iomap.type) {
>  	case IOMAP_MAPPED:
> @@ -1390,7 +1401,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  	if (iomap.offset + iomap.length < pos + PMD_SIZE)
>  		goto finish_iomap;
>  
> -	sync = (vma->vm_flags & VM_SYNC) && (iomap.flags & IOMAP_F_DIRTY);
> +	sync = dax_fault_is_synchronous(iomap_flags, vma, &iomap);
>  
>  	switch (iomap.type) {
>  	case IOMAP_MAPPED:
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 13a198924a0f..ee4d907a4251 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3479,7 +3479,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	}
>  
>  	iomap->flags = 0;
> -	if ((flags & IOMAP_WRITE) && ext4_inode_datasync_dirty(inode))
> +	if (ext4_inode_datasync_dirty(inode))
>  		iomap->flags |= IOMAP_F_DIRTY;
>  	iomap->bdev = inode->i_sb->s_bdev;
>  	iomap->dax_dev = sbi->s_daxdev;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index b43be199fbdf..888b60189983 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1087,9 +1087,9 @@ xfs_file_iomap_begin(
>  		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
>  	}
>  
> -	if ((flags & IOMAP_WRITE) && xfs_ipincount(ip) &&
> -	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> -		iomap->flags |= IOMAP_F_DIRTY;
> +	if (xfs_ipincount(ip))
> +		if (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP)

Why not if (xfs_ipincount(ip) && (ip->... & ~XFS_ILOG_TIMESTAMP)) ?

Otherwise looks ok (just this patch, will rvb the rest separately),
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +			iomap->flags |= IOMAP_F_DIRTY;
>  
>  	xfs_bmbt_to_iomap(ip, iomap, &imap);
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
