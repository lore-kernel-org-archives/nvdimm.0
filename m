Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 5 Jan 2016 15:03:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [resend PATCH 2/3] xfs: handle shutdown notifications
Message-ID: <20160105040334.GK19802@dastard>
References: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160104182011.24118.30446.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160104182011.24118.30446.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 04, 2016 at 10:20:11AM -0800, Dan Williams wrote:
> Force a filesystem shutdown when the backing device is known to be dead.
> I.e. blk_queue_enter() permanently returns -ENODEV.
> 
> Cc: xfs@oss.sgi.com
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/block_dev.c     |    3 ++-
>  fs/xfs/xfs_super.c |    9 +++++++++
>  include/linux/fs.h |    2 ++
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 739e43a37e64..7d6c66148948 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1806,7 +1806,7 @@ int __invalidate_device(struct block_device *bdev, bool kill_dirty)
>  }
>  EXPORT_SYMBOL(__invalidate_device);
>  
> -static void generic_bdi_gone(struct super_block *sb)
> +void generic_bdi_gone(struct super_block *sb)
>  {
>  	struct inode *inode, *_inode = NULL;
>  
> @@ -1832,6 +1832,7 @@ static void generic_bdi_gone(struct super_block *sb)
>  	spin_unlock(&sb->s_inode_list_lock);
>  	iput(_inode);
>  }
> +EXPORT_SYMBOL(generic_bdi_gone);

That should be in the previous patch.

>  void shutdown_partition(struct gendisk *disk, int partno)
>  {
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 36bd8825bfb0..63c36508e9db 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1618,6 +1618,14 @@ xfs_fs_free_cached_objects(
>  	return xfs_reclaim_inodes_nr(XFS_M(sb), sc->nr_to_scan);
>  }
>  
> +static void
> +xfs_fs_bdi_gone(

xfs_fs_shutdown

> +	struct super_block *sb)
> +{
> +	xfs_force_shutdown(XFS_M(sb), SHUTDOWN_DEVICE_REQ);
> +	generic_bdi_gone(sb);
> +}
> +

This is wrong. we have to unmap the DAX inodes during *every*
shutdown that XFS executes. Hence it needs to be done inside
xfs_do_force_shutdown(), not in addition to the shutdown when the
block device is pulled. i.e. something like this in
xfs_do_force_shutdown():

 	 */
 	if (xfs_log_force_umount(mp, logerror))
 		return;
+
+	/*
+	 * If DAX is in use, we have to unmap all direct access
+	 * virtual mappings to ensure nothing more gets written
+	 * directly from userspace. This will force them to refault
+	 * and that will result in them detecting the shutdown
+	 * condition and hence will fail appropriately.
+	 */
+	unmap_dax_inodes(mp->m_super);
 
 	if (flags & SHUTDOWN_CORRUPT_INCORE) {
 		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT

>  static const struct super_operations xfs_super_operations = {
>  	.alloc_inode		= xfs_fs_alloc_inode,
>  	.destroy_inode		= xfs_fs_destroy_inode,
> @@ -1632,6 +1640,7 @@ static const struct super_operations xfs_super_operations = {
>  	.show_options		= xfs_fs_show_options,
>  	.nr_cached_objects	= xfs_fs_nr_cached_objects,
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
> +	.bdi_gone		= xfs_fs_bdi_gone,
>  };
>  
>  static struct file_system_type xfs_fs_type = {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 0e201ed38045..b1e8e049e4b8 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2265,6 +2265,7 @@ extern struct super_block *freeze_bdev(struct block_device *);
>  extern void emergency_thaw_all(void);
>  extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
>  extern int fsync_bdev(struct block_device *);
> +extern void generic_bdi_gone(struct super_block *sb);

previous patch.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
