Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5413021CF1D17
 for <linux-nvdimm@lists.01.org>; Fri, 16 Feb 2018 09:25:12 -0800 (PST)
Date: Fri, 16 Feb 2018 09:26:07 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v6 2/3] dax: change bdev_dax_supported() to support
 boolean returns
Message-ID: <20180216172607.GT5217@magnolia>
References: <151880058592.43131.558230052922233871.stgit@djiang5-desk3.ch.intel.com>
 <151880066062.43131.82642632079885057.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151880066062.43131.82642632079885057.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 16, 2018 at 10:04:20AM -0700, Dave Jiang wrote:
> The function return values are confusing with the way the function is
> named. We expect a true or false return value but it actually returns
> 0/-errno.  This makes the code very confusing. Changing the return values
> to return a bool where if DAX is supported then return true and no DAX
> support returns false.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c |   16 ++++++++--------
>  fs/ext2/super.c     |    3 +--
>  fs/ext4/super.c     |    3 +--
>  fs/xfs/xfs_ioctl.c  |    4 ++--
>  fs/xfs/xfs_super.c  |   12 ++++++------
>  include/linux/dax.h |    6 +++---
>  6 files changed, 21 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index f037458600aa..a7a30d3794f6 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -80,9 +80,9 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
>   * This is a library function for filesystems to check if the block device
>   * can be mounted with dax option.
>   *
> - * Return: negative errno if unsupported, 0 if supported.
> + * Return: true if supported, false if unsupported
>   */
> -int bdev_dax_supported(struct block_device *bdev, int blocksize)
> +bool bdev_dax_supported(struct block_device *bdev, int blocksize)
>  {
>  	struct dax_device *dax_dev;
>  	pgoff_t pgoff;
> @@ -95,21 +95,21 @@ int bdev_dax_supported(struct block_device *bdev, int blocksize)
>  	if (blocksize != PAGE_SIZE) {
>  		pr_debug("%s: error: unsupported blocksize for dax\n",
>  				bdevname(bdev, buf));
> -		return -EINVAL;
> +		return false;
>  	}
>  
>  	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
>  	if (err) {
>  		pr_debug("%s: error: unaligned partition for dax\n",
>  				bdevname(bdev, buf));
> -		return err;
> +		return false;
>  	}
>  
>  	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
>  	if (!dax_dev) {
>  		pr_debug("%s: error: device does not support dax\n",
>  				bdevname(bdev, buf));
> -		return -EOPNOTSUPP;
> +		return false;
>  	}
>  
>  	id = dax_read_lock();
> @@ -121,7 +121,7 @@ int bdev_dax_supported(struct block_device *bdev, int blocksize)
>  	if (len < 1) {
>  		pr_debug("%s: error: dax access failed (%ld)\n",
>  				bdevname(bdev, buf), len);
> -		return len < 0 ? len : -EIO;
> +		return false;
>  	}
>  
>  	if ((IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn))
> @@ -130,10 +130,10 @@ int bdev_dax_supported(struct block_device *bdev, int blocksize)
>  	else {
>  		pr_debug("%s: error: dax support not enabled\n",
>  				bdevname(bdev, buf));
> -		return -EOPNOTSUPP;
> +		return false;
>  	}
>  
> -	return 0;
> +	return true;
>  }
>  EXPORT_SYMBOL_GPL(bdev_dax_supported);
>  #endif
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index b8063b640ec1..5e19e1a886b7 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -961,8 +961,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
>  
>  	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
> -		err = bdev_dax_supported(sb->s_bdev, blocksize);
> -		if (err) {
> +		if(!bdev_dax_supported(sb->s_bdev, blocksize)) {

Minor spacing nit: if (!bdev...

Otherwise looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  			ext2_msg(sb, KERN_ERR,
>  				"DAX unsupported by block device. Turning off DAX.");
>  			sbi->s_mount_opt &= ~EXT2_MOUNT_DAX;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 911eca771853..23debb8313e5 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3714,8 +3714,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  					" that may contain inline data");
>  			sbi->s_mount_opt &= ~EXT4_MOUNT_DAX;
>  		}
> -		err = bdev_dax_supported(sb->s_bdev, blocksize);
> -		if (err) {
> +		if (!bdev_dax_supported(sb->s_bdev, blocksize)) {
>  			ext4_msg(sb, KERN_ERR,
>  				"DAX unsupported by block device. Turning off DAX.");
>  			sbi->s_mount_opt &= ~EXT4_MOUNT_DAX;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0effd46b965f..2c70a0a4f59f 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1103,8 +1103,8 @@ xfs_ioctl_setattr_dax_invalidate(
>  	if (fa->fsx_xflags & FS_XFLAG_DAX) {
>  		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
>  			return -EINVAL;
> -		if (bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
> -				sb->s_blocksize) < 0)
> +		if (!bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
> +				sb->s_blocksize))
>  			return -EINVAL;
>  	}
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index aaaba6e604c4..3634e7eb362c 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1657,17 +1657,17 @@ xfs_fs_fill_super(
>  		sb->s_flags |= SB_I_VERSION;
>  
>  	if (mp->m_flags & XFS_MOUNT_DAX) {
> -		int	error2 = 0;
> +		bool rtdev_is_dax = false, datadev_is_dax;
>  
>  		xfs_warn(mp,
>  		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>  
> -		error = bdev_dax_supported(mp->m_ddev_targp->bt_bdev,
> -				sb->s_blocksize);
> +		datadev_is_dax = bdev_dax_supported(mp->m_ddev_targp->bt_bdev,
> +			sb->s_blocksize);
>  		if (mp->m_rtdev_targp)
> -			error2 = bdev_dax_supported(mp->m_rtdev_targp->bt_bdev,
> -					sb->s_blocksize);
> -		if (error && error2) {
> +			rtdev_is_dax = bdev_dax_supported(
> +				mp->m_rtdev_targp->bt_bdev, sb->s_blocksize);
> +		if (!rtdev_is_dax && !datadev_is_dax) {
>  			xfs_alert(mp,
>  			"DAX unsupported by block device. Turning off DAX.");
>  			mp->m_flags &= ~XFS_MOUNT_DAX;
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 8eb3a359df95..dd77b0ed2283 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -40,7 +40,7 @@ static inline void put_dax(struct dax_device *dax_dev)
>  
>  int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
>  #if IS_ENABLED(CONFIG_FS_DAX)
> -int bdev_dax_supported(struct block_device *bdev, int blocksize);
> +bool bdev_dax_supported(struct block_device *bdev, int blocksize);
>  static inline struct dax_device *fs_dax_get_by_host(const char *host)
>  {
>  	return dax_get_by_host(host);
> @@ -53,10 +53,10 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
>  
>  struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
>  #else
> -static inline int bdev_dax_supported(struct block_device *bdev,
> +static inline bool bdev_dax_supported(struct block_device *bdev,
>  		int blocksize)
>  {
> -	return -EOPNOTSUPP;
> +	return false;
>  }
>  
>  static inline struct dax_device *fs_dax_get_by_host(const char *host)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
