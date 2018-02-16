Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E8824223230CE
 for <linux-nvdimm@lists.01.org>; Fri, 16 Feb 2018 09:18:03 -0800 (PST)
Date: Fri, 16 Feb 2018 09:22:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v6 3/3] xfs: reject removal of realtime flag when datadev
 doesn't support DAX
Message-ID: <20180216172247.GS5217@magnolia>
References: <151880058592.43131.558230052922233871.stgit@djiang5-desk3.ch.intel.com>
 <151880066614.43131.15847174332875373188.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151880066614.43131.15847174332875373188.stgit@djiang5-desk3.ch.intel.com>
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

On Fri, Feb 16, 2018 at 10:04:26AM -0700, Dave Jiang wrote:
> In a situation where the rt_dev is DAX and data_dev is not DAX, if the user
> requests to remove the realtime flag via ioctl we can no longer support DAX
> for that file. Dynamic changing of S_DAX on the inode is not supported due
> to various complications in the existing implementation. Therefore until we
> address the dynamic S_DAX change issues, we must disallow realtime flag
> being removed.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioctl.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 2c70a0a4f59f..edd97d527fe8 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1030,6 +1030,20 @@ xfs_ioctl_setattr_xflags(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	uint64_t		di_flags2;
> +	struct inode		*inode = VFS_I(ip);
> +	struct super_block	*sb = inode->i_sb;
> +
> +	/*
> +	 * In the case that the inode is realtime, and we are trying to remove
> +	 * the realtime flag, and the rtdev supports DAX but the datadev does
> +	 * not support DAX, we can't allow the realtime flag to be removed
> +	 * since we do not support dynamic S_DAX flag removal yet.
> +	 */
> +	if (XFS_IS_REALTIME_INODE(ip) &&
> +	    !(fa->fsx_xflags & FS_XFLAG_REALTIME) &&
> +	    bdev_dax_supported(mp->m_rtdev_targp->bt_bdev, sb->s_blocksize) &&
> +	    !bdev_dax_supported(mp->m_ddev_targp->bt_bdev, sb->s_blocksize))

What happens here if we have a non-rt file that we're trying to turn
into an rt file and the data dev supports dax but not the rt dev?

Changing the rt flag is only supported on files with no data blocks (no
extents, no delalloc blocks), so why can't we remove S_DAX from an empty
file?  There aren't any memory mappings or page cache to get in the way,
correct?

Please fix the complications in the existing implementation that prevent
us from removing S_DAX rather than adding more XFS restrictions, or at
least tell me what's holding that up.

--D

> +		return -ENOTSUPP;
>  
>  	/* Can't change realtime flag if any extents are allocated. */
>  	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
