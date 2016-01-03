Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 4 Jan 2016 08:05:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: handle shutdown notifications
Message-ID: <20160103210544.GX19802@dastard>
References: <20151201235836.36836.90416.stgit@dwillia2-desk3.jf.intel.com>
 <20151201235846.36836.1476.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151201235846.36836.1476.stgit@dwillia2-desk3.jf.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 01, 2015 at 03:58:46PM -0800, Dan Williams wrote:
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
> index 39989e990df9..dfe9a53a7c53 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1802,7 +1802,7 @@ int __invalidate_device(struct block_device *bdev, bool kill_dirty)
>  }
>  EXPORT_SYMBOL(__invalidate_device);
>  
> -static void generic_bdi_gone(struct super_block *sb)
> +void generic_bdi_gone(struct super_block *sb)
>  {
>  	struct inode *inode, *_inode = NULL;
>  
> @@ -1828,6 +1828,7 @@ static void generic_bdi_gone(struct super_block *sb)
>  	spin_unlock(&sb->s_inode_list_lock);
>  	iput(_inode);
>  }
> +EXPORT_SYMBOL(generic_bdi_gone);
>  
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
> +	struct super_block *sb)
> +{
> +	xfs_force_shutdown(XFS_M(sb), SHUTDOWN_DEVICE_REQ);
> +	generic_bdi_gone(sb);
> +}

You haven't cc'd me or the XFS list on the other patches in this
series, so I cannot comment as to whether this will work or not.
As I've asked before, please do not do single patch CC's like this
as it does not give the reviewer the context to be able to review
the change, nor is it possible to *apply and test* the patch they
are being asked to comment on.

Please resend the series with complete CC's to the relevant lists.
Sure, go ahead an CC individual people on certain patches, but you
need to make sure the whole patch series hit each mailing list....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
