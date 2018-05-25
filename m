Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E681C20961853
 for <linux-nvdimm@lists.01.org>; Thu, 24 May 2018 22:01:26 -0700 (PDT)
Date: Thu, 24 May 2018 22:01:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/7] dax: change bdev_dax_supported() to support boolean
 returns
Message-ID: <20180525050114.GE4507@magnolia>
References: <20180525025518.11405-1-ross.zwisler@linux.intel.com>
 <20180525025518.11405-3-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180525025518.11405-3-ross.zwisler@linux.intel.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 24, 2018 at 08:55:13PM -0600, Ross Zwisler wrote:
> From: Dave Jiang <dave.jiang@intel.com>
> 
> The function return values are confusing with the way the function is
> named. We expect a true or false return value but it actually returns
> 0/-errno.  This makes the code very confusing. Changing the return values
> to return a bool where if DAX is supported then return true and no DAX
> support returns false.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  drivers/dax/super.c | 16 ++++++++--------
>  fs/ext2/super.c     |  3 +--
>  fs/ext4/super.c     |  3 +--
>  fs/xfs/xfs_ioctl.c  |  4 ++--
>  fs/xfs/xfs_super.c  | 12 ++++++------
>  include/linux/dax.h |  6 +++---
>  6 files changed, 21 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 9206539c8330..e5447eddecf8 100644
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
>  	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn)) {
> @@ -139,10 +139,10 @@ int bdev_dax_supported(struct block_device *bdev, int blocksize)
>  	} else {
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
> index 9627c3054b5c..c09289a42dc5 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -961,8 +961,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
>  
>  	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
> -		err = bdev_dax_supported(sb->s_bdev, blocksize);
> -		if (err) {
> +		if (!bdev_dax_supported(sb->s_bdev, blocksize)) {
>  			ext2_msg(sb, KERN_ERR,
>  				"DAX unsupported by block device. Turning off DAX.");
>  			sbi->s_mount_opt &= ~EXT2_MOUNT_DAX;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 089170e99895..2e1622907f4a 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3732,8 +3732,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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
> index 62188c2a4c36..86915dc40eed 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1690,17 +1690,17 @@ xfs_fs_fill_super(
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
> index 509a85ac8470..547eb33dbc9e 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -64,7 +64,7 @@ static inline bool dax_write_cache_enabled(struct dax_device *dax_dev)
>  struct writeback_control;
>  int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
>  #if IS_ENABLED(CONFIG_FS_DAX)
> -int bdev_dax_supported(struct block_device *bdev, int blocksize);
> +bool bdev_dax_supported(struct block_device *bdev, int blocksize);
>  static inline struct dax_device *fs_dax_get_by_host(const char *host)
>  {
>  	return dax_get_by_host(host);
> @@ -79,10 +79,10 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
>  int dax_writeback_mapping_range(struct address_space *mapping,
>  		struct block_device *bdev, struct writeback_control *wbc);
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
> -- 
> 2.14.3
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
