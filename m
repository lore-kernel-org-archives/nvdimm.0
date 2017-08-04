Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 02C7A21E1DAFF
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 13:03:44 -0700 (PDT)
Date: Fri, 4 Aug 2017 13:04:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 3/5] fs, xfs: introduce FALLOC_FL_UNSEAL_BLOCK_MAP
Message-ID: <20170804200446.GD24087@magnolia>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150181370272.32119.9941879917087053701.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150181370272.32119.9941879917087053701.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 03, 2017 at 07:28:23PM -0700, Dan Williams wrote:
> Provide an explicit fallocate operation type for clearing the
> S_IOMAP_IMMUTABLE flag. Like the enable case it requires CAP_IMMUTABLE
> and it can only be performed while no process has the file mapped.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/open.c                   |   17 +++++++++++------
>  fs/xfs/xfs_bmap_util.c      |   42 ++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_bmap_util.h      |    3 +++
>  fs/xfs/xfs_file.c           |    4 +++-
>  include/linux/falloc.h      |    3 ++-
>  include/uapi/linux/falloc.h |    1 +
>  6 files changed, 62 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index e3aae59785ae..ccfd8d3becc8 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -274,13 +274,17 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  		return -EINVAL;
>  
>  	/*
> -	 * Seal block map operation should only be used exclusively, and
> -	 * with the IMMUTABLE capability.
> +	 * Seal/unseal block map operations should only be used
> +	 * exclusively, and with the IMMUTABLE capability.
>  	 */
> -	if (mode & FALLOC_FL_SEAL_BLOCK_MAP) {
> +	if (mode & (FALLOC_FL_SEAL_BLOCK_MAP | FALLOC_FL_UNSEAL_BLOCK_MAP)) {
>  		if (!capable(CAP_LINUX_IMMUTABLE))
>  			return -EPERM;
> -		if (mode & ~FALLOC_FL_SEAL_BLOCK_MAP)
> +		if (mode == (FALLOC_FL_SEAL_BLOCK_MAP
> +					| FALLOC_FL_UNSEAL_BLOCK_MAP))
> +			return -EINVAL;
> +		if (mode & ~(FALLOC_FL_SEAL_BLOCK_MAP
> +					| FALLOC_FL_UNSEAL_BLOCK_MAP))
>  			return -EINVAL;
>  	}
>  
> @@ -303,9 +307,10 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  		return -ETXTBSY;
>  
>  	/*
> -	 * We cannot allow any allocation changes on an iomap immutable file
> +	 * We cannot allow any allocation changes on an iomap immutable
> +	 * file, but we can allow clearing the immutable state.
>  	 */
> -	if (IS_IOMAP_IMMUTABLE(inode))
> +	if (IS_IOMAP_IMMUTABLE(inode) && !(mode & FALLOC_FL_UNSEAL_BLOCK_MAP))
>  		return -ETXTBSY;
>  
>  	/*
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 46d8eb9e19fc..70ac2d33ab27 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1494,6 +1494,48 @@ xfs_seal_file_space(
>  	return error;
>  }
>  
> +int
> +xfs_unseal_file_space(
> +	struct xfs_inode	*ip,
> +	xfs_off_t		offset,
> +	xfs_off_t		len)
> +{
> +	struct inode		*inode = VFS_I(ip);
> +	struct address_space	*mapping = inode->i_mapping;
> +	int			error;
> +
> +	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));

Same assert-on-the-iolock comment as the previous patch.

> +
> +	if (offset)
> +		return -EINVAL;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	/*
> +	 * It does not make sense to unseal less than the full range of
> +	 * the file.
> +	 */
> +	error = -EINVAL;
> +	if (len < i_size_read(inode))
> +		goto out_unlock;

Hmm, should we be picky and require len == i_size_read() here?

> +	/*
> +	 * Provide safety against one thread changing the policy of not
> +	 * requiring fsync/msync (for block allocations) behind another
> +	 * thread's back.
> +	 */
> +	error = -EBUSY;
> +	if (mapping_mapped(mapping))
> +		goto out_unlock;
> +
> +	inode->i_flags &= ~S_IOMAP_IMMUTABLE;

It occurred to me, should we jump out early from the seal/unseal
operations if the flag state matches whatever the user is asking for?
This is perhaps not necessary for unseal since we don't do a lot of
work.

--D

> +	error = 0;
> +
> +out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +
> +	return error;
> +}
> +
>  /*
>   * @next_fsb will keep track of the extent currently undergoing shift.
>   * @stop_fsb will keep track of the extent at which we have to stop.
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 5115a32a2483..b64653a75942 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -62,6 +62,9 @@ int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
>  				xfs_off_t len);
>  int	xfs_seal_file_space(struct xfs_inode *, xfs_off_t offset,
>  				xfs_off_t len);
> +int	xfs_unseal_file_space(struct xfs_inode *, xfs_off_t offset,
> +				xfs_off_t len);
> +
>  
>  /* EOF block manipulation functions */
>  bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index e21121530a90..833f77700be2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -740,7 +740,7 @@ xfs_file_write_iter(
>  		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
>  		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
>  		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE |	\
> -		 FALLOC_FL_SEAL_BLOCK_MAP)
> +		 FALLOC_FL_SEAL_BLOCK_MAP | FALLOC_FL_UNSEAL_BLOCK_MAP)
>  
>  STATIC long
>  xfs_file_fallocate(
> @@ -840,6 +840,8 @@ xfs_file_fallocate(
>  						XFS_BMAPI_PREALLOC);
>  			} else if (mode & FALLOC_FL_SEAL_BLOCK_MAP) {
>  				error = xfs_seal_file_space(ip, offset, len);
> +			} else if (mode & FALLOC_FL_UNSEAL_BLOCK_MAP) {
> +				error = xfs_unseal_file_space(ip, offset, len);
>  			} else
>  				error = xfs_alloc_file_space(ip, offset, len,
>  						XFS_BMAPI_PREALLOC);
> diff --git a/include/linux/falloc.h b/include/linux/falloc.h
> index 48546c6fbec7..b22c1368ed1e 100644
> --- a/include/linux/falloc.h
> +++ b/include/linux/falloc.h
> @@ -27,6 +27,7 @@ struct space_resv {
>  					 FALLOC_FL_ZERO_RANGE |		\
>  					 FALLOC_FL_INSERT_RANGE |	\
>  					 FALLOC_FL_UNSHARE_RANGE |	\
> -					 FALLOC_FL_SEAL_BLOCK_MAP)
> +					 FALLOC_FL_SEAL_BLOCK_MAP |	\
> +					 FALLOC_FL_UNSEAL_BLOCK_MAP)
>  
>  #endif /* _FALLOC_H_ */
> diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
> index 39076975bf6f..a4949e1a2dae 100644
> --- a/include/uapi/linux/falloc.h
> +++ b/include/uapi/linux/falloc.h
> @@ -95,4 +95,5 @@
>   * with the punch, zero, collapse, or insert range modes.
>   */
>  #define FALLOC_FL_SEAL_BLOCK_MAP	0x080
> +#define FALLOC_FL_UNSEAL_BLOCK_MAP	0x100
>  #endif /* _UAPI_FALLOC_H_ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
