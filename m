Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 54EDA1A1EC5
 for <linux-nvdimm@lists.01.org>; Tue, 11 Oct 2016 11:42:33 -0700 (PDT)
Date: Tue, 11 Oct 2016 10:34:05 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 16/17] xfs: use struct iomap based DAX PMD fault path
Message-ID: <20161011083405.GH6952@quack2.suse.cz>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-17-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1475874544-24842-17-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 07-10-16 15:09:03, Ross Zwisler wrote:
> Switch xfs_filemap_pmd_fault() from using dax_pmd_fault() to the new and
> improved dax_iomap_pmd_fault().  Also, now that it has no more users,
> remove xfs_get_blocks_dax_fault().
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/xfs/xfs_aops.c | 26 +++++---------------------
>  fs/xfs/xfs_aops.h |  3 ---
>  fs/xfs/xfs_file.c |  2 +-
>  3 files changed, 6 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 0e2a931..1c73d0a 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1298,8 +1298,7 @@ __xfs_get_blocks(
>  	sector_t		iblock,
>  	struct buffer_head	*bh_result,
>  	int			create,
> -	bool			direct,
> -	bool			dax_fault)
> +	bool			direct)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -1420,13 +1419,8 @@ __xfs_get_blocks(
>  		if (ISUNWRITTEN(&imap))
>  			set_buffer_unwritten(bh_result);
>  		/* direct IO needs special help */
> -		if (create) {
> -			if (dax_fault)
> -				ASSERT(!ISUNWRITTEN(&imap));
> -			else
> -				xfs_map_direct(inode, bh_result, &imap, offset,
> -						is_cow);
> -		}
> +		if (create)
> +			xfs_map_direct(inode, bh_result, &imap, offset, is_cow);
>  	}
>  
>  	/*
> @@ -1466,7 +1460,7 @@ xfs_get_blocks(
>  	struct buffer_head	*bh_result,
>  	int			create)
>  {
> -	return __xfs_get_blocks(inode, iblock, bh_result, create, false, false);
> +	return __xfs_get_blocks(inode, iblock, bh_result, create, false);
>  }
>  
>  int
> @@ -1476,17 +1470,7 @@ xfs_get_blocks_direct(
>  	struct buffer_head	*bh_result,
>  	int			create)
>  {
> -	return __xfs_get_blocks(inode, iblock, bh_result, create, true, false);
> -}
> -
> -int
> -xfs_get_blocks_dax_fault(
> -	struct inode		*inode,
> -	sector_t		iblock,
> -	struct buffer_head	*bh_result,
> -	int			create)
> -{
> -	return __xfs_get_blocks(inode, iblock, bh_result, create, true, true);
> +	return __xfs_get_blocks(inode, iblock, bh_result, create, true);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index b3c6634..34dc00d 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -59,9 +59,6 @@ int	xfs_get_blocks(struct inode *inode, sector_t offset,
>  		       struct buffer_head *map_bh, int create);
>  int	xfs_get_blocks_direct(struct inode *inode, sector_t offset,
>  			      struct buffer_head *map_bh, int create);
> -int	xfs_get_blocks_dax_fault(struct inode *inode, sector_t offset,
> -			         struct buffer_head *map_bh, int create);
> -
>  int	xfs_end_io_direct_write(struct kiocb *iocb, loff_t offset,
>  		ssize_t size, void *private);
>  int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 8f12152..7b13dda 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1750,7 +1750,7 @@ xfs_filemap_pmd_fault(
>  	}
>  
>  	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -	ret = dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault);
> +	ret = dax_iomap_pmd_fault(vma, addr, pmd, flags, &xfs_iomap_ops);
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  
>  	if (flags & FAULT_FLAG_WRITE)
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
