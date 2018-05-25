Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sandeen.net (sandeen.net [63.231.237.45])
 by ml01.01.org (Postfix) with ESMTP id 4293F2096AED0
 for <linux-nvdimm@lists.01.org>; Fri, 25 May 2018 15:32:27 -0700 (PDT)
Subject: Re: [PATCH resend 1/7] fs: allow per-device dax status checking for
 filesystems
References: <20180525220055.18920-1-ross.zwisler@linux.intel.com>
 <20180525220055.18920-2-ross.zwisler@linux.intel.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <924994ed-64c8-ca11-75c1-cb1a1f0f6d94@sandeen.net>
Date: Fri, 25 May 2018 17:32:25 -0500
MIME-Version: 1.0
In-Reply-To: <20180525220055.18920-2-ross.zwisler@linux.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 5/25/18 5:00 PM, Ross Zwisler wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> 
> Remove __bdev_dax_supported and change to bdev_dax_supported that takes a
> bdev parameter.  This enables multi-device filesystems like xfs to check
> that a dax device can work for the particular filesystem.  Once that's
> in place, actually fix all the parts of XFS where we need to be able to
> distinguish between datadev and rtdev.
> 
> This patch fixes the problem where we screw up the dax support checking
> in xfs if the datadev and rtdev have different dax capabilities.

I wonder where we might be able to document this wrinkle, i.e. mount -o dax
means at least /one/ of the devices must support it, and then at runtime
whichever file you try to use dax on still needs to be on a device that
supports it ... but ok, anyway this seems fine functionally.

you've assured me that xfstests are coming ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>   drivers/dax/super.c | 30 +++++++++++++++---------------
>   fs/ext2/super.c     |  2 +-
>   fs/ext4/super.c     |  2 +-
>   fs/xfs/xfs_ioctl.c  |  3 ++-
>   fs/xfs/xfs_iops.c   | 30 +++++++++++++++++++++++++-----
>   fs/xfs/xfs_super.c  | 10 ++++++++--
>   include/linux/dax.h | 10 +++-------
>   7 files changed, 55 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 2b2332b605e4..9206539c8330 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -73,8 +73,8 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
>   #endif
>   
>   /**
> - * __bdev_dax_supported() - Check if the device supports dax for filesystem
> - * @sb: The superblock of the device
> + * bdev_dax_supported() - Check if the device supports dax for filesystem
> + * @bdev: block device to check
>    * @blocksize: The block size of the device
>    *
>    * This is a library function for filesystems to check if the block device
> @@ -82,33 +82,33 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
>    *
>    * Return: negative errno if unsupported, 0 if supported.
>    */
> -int __bdev_dax_supported(struct super_block *sb, int blocksize)
> +int bdev_dax_supported(struct block_device *bdev, int blocksize)
>   {
> -	struct block_device *bdev = sb->s_bdev;
>   	struct dax_device *dax_dev;
>   	pgoff_t pgoff;
>   	int err, id;
>   	void *kaddr;
>   	pfn_t pfn;
>   	long len;
> +	char buf[BDEVNAME_SIZE];
>   
>   	if (blocksize != PAGE_SIZE) {
> -		pr_debug("VFS (%s): error: unsupported blocksize for dax\n",
> -				sb->s_id);
> +		pr_debug("%s: error: unsupported blocksize for dax\n",
> +				bdevname(bdev, buf));
>   		return -EINVAL;
>   	}
>   
>   	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
>   	if (err) {
> -		pr_debug("VFS (%s): error: unaligned partition for dax\n",
> -				sb->s_id);
> +		pr_debug("%s: error: unaligned partition for dax\n",
> +				bdevname(bdev, buf));
>   		return err;
>   	}
>   
>   	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
>   	if (!dax_dev) {
> -		pr_debug("VFS (%s): error: device does not support dax\n",
> -				sb->s_id);
> +		pr_debug("%s: error: device does not support dax\n",
> +				bdevname(bdev, buf));
>   		return -EOPNOTSUPP;
>   	}
>   
> @@ -119,8 +119,8 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
>   	put_dax(dax_dev);
>   
>   	if (len < 1) {
> -		pr_debug("VFS (%s): error: dax access failed (%ld)\n",
> -				sb->s_id, len);
> +		pr_debug("%s: error: dax access failed (%ld)\n",
> +				bdevname(bdev, buf), len);
>   		return len < 0 ? len : -EIO;
>   	}
>   
> @@ -137,14 +137,14 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
>   	} else if (pfn_t_devmap(pfn)) {
>   		/* pass */;
>   	} else {
> -		pr_debug("VFS (%s): error: dax support not enabled\n",
> -				sb->s_id);
> +		pr_debug("%s: error: dax support not enabled\n",
> +				bdevname(bdev, buf));
>   		return -EOPNOTSUPP;
>   	}
>   
>   	return 0;
>   }
> -EXPORT_SYMBOL_GPL(__bdev_dax_supported);
> +EXPORT_SYMBOL_GPL(bdev_dax_supported);
>   #endif
>   
>   enum dax_device_flags {
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index de1694512f1f..9627c3054b5c 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -961,7 +961,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>   	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
>   
>   	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
> -		err = bdev_dax_supported(sb, blocksize);
> +		err = bdev_dax_supported(sb->s_bdev, blocksize);
>   		if (err) {
>   			ext2_msg(sb, KERN_ERR,
>   				"DAX unsupported by block device. Turning off DAX.");
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index eb104e8476f0..089170e99895 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3732,7 +3732,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>   					" that may contain inline data");
>   			sbi->s_mount_opt &= ~EXT4_MOUNT_DAX;
>   		}
> -		err = bdev_dax_supported(sb, blocksize);
> +		err = bdev_dax_supported(sb->s_bdev, blocksize);
>   		if (err) {
>   			ext4_msg(sb, KERN_ERR,
>   				"DAX unsupported by block device. Turning off DAX.");
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 89fb1eb80aae..0effd46b965f 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1103,7 +1103,8 @@ xfs_ioctl_setattr_dax_invalidate(
>   	if (fa->fsx_xflags & FS_XFLAG_DAX) {
>   		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
>   			return -EINVAL;
> -		if (bdev_dax_supported(sb, sb->s_blocksize) < 0)
> +		if (bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
> +				sb->s_blocksize) < 0)
>   			return -EINVAL;
>   	}
>   
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index a3ed3c811dfa..6e83acf74a95 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1195,6 +1195,30 @@ static const struct inode_operations xfs_inline_symlink_inode_operations = {
>   	.update_time		= xfs_vn_update_time,
>   };
>   
> +/* Figure out if this file actually supports DAX. */
> +static bool
> +xfs_inode_supports_dax(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	/* Only supported on non-reflinked files. */
> +	if (!S_ISREG(VFS_I(ip)->i_mode) || xfs_is_reflink_inode(ip))
> +		return false;
> +
> +	/* DAX mount option or DAX iflag must be set. */
> +	if (!(mp->m_flags & XFS_MOUNT_DAX) &&
> +	    !(ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
> +		return false;
> +
> +	/* Block size must match page size */
> +	if (mp->m_sb.sb_blocksize != PAGE_SIZE)
> +		return false;
> +
> +	/* Device has to support DAX too. */
> +	return xfs_find_daxdev_for_inode(VFS_I(ip)) != NULL;
> +}
> +
>   STATIC void
>   xfs_diflags_to_iflags(
>   	struct inode		*inode,
> @@ -1213,11 +1237,7 @@ xfs_diflags_to_iflags(
>   		inode->i_flags |= S_SYNC;
>   	if (flags & XFS_DIFLAG_NOATIME)
>   		inode->i_flags |= S_NOATIME;
> -	if (S_ISREG(inode->i_mode) &&
> -	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
> -	    !xfs_is_reflink_inode(ip) &&
> -	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
> -	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
> +	if (xfs_inode_supports_dax(ip))
>   		inode->i_flags |= S_DAX;
>   }
>   
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d71424052917..62188c2a4c36 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1690,11 +1690,17 @@ xfs_fs_fill_super(
>   		sb->s_flags |= SB_I_VERSION;
>   
>   	if (mp->m_flags & XFS_MOUNT_DAX) {
> +		int	error2 = 0;
> +
>   		xfs_warn(mp,
>   		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>   
> -		error = bdev_dax_supported(sb, sb->s_blocksize);
> -		if (error) {
> +		error = bdev_dax_supported(mp->m_ddev_targp->bt_bdev,
> +				sb->s_blocksize);
> +		if (mp->m_rtdev_targp)
> +			error2 = bdev_dax_supported(mp->m_rtdev_targp->bt_bdev,
> +					sb->s_blocksize);
> +		if (error && error2) {
>   			xfs_alert(mp,
>   			"DAX unsupported by block device. Turning off DAX.");
>   			mp->m_flags &= ~XFS_MOUNT_DAX;
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index f9eb22ad341e..509a85ac8470 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -64,12 +64,7 @@ static inline bool dax_write_cache_enabled(struct dax_device *dax_dev)
>   struct writeback_control;
>   int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
>   #if IS_ENABLED(CONFIG_FS_DAX)
> -int __bdev_dax_supported(struct super_block *sb, int blocksize);
> -static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
> -{
> -	return __bdev_dax_supported(sb, blocksize);
> -}
> -
> +int bdev_dax_supported(struct block_device *bdev, int blocksize);
>   static inline struct dax_device *fs_dax_get_by_host(const char *host)
>   {
>   	return dax_get_by_host(host);
> @@ -84,7 +79,8 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
>   int dax_writeback_mapping_range(struct address_space *mapping,
>   		struct block_device *bdev, struct writeback_control *wbc);
>   #else
> -static inline int bdev_dax_supported(struct super_block *sb, int blocksize)
> +static inline int bdev_dax_supported(struct block_device *bdev,
> +		int blocksize)
>   {
>   	return -EOPNOTSUPP;
>   }
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
