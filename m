Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
 [150.101.137.145])
 by ml01.01.org (Postfix) with ESMTP id C182321FD73C4
 for <linux-nvdimm@lists.01.org>; Sat, 17 Feb 2018 16:17:24 -0800 (PST)
Date: Sun, 18 Feb 2018 11:23:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 3/3] xfs: reject removal of realtime flag when datadev
 doesn't support DAX
Message-ID: <20180218002317.GU7000@dastard>
References: <151880058592.43131.558230052922233871.stgit@djiang5-desk3.ch.intel.com>
 <151880066614.43131.15847174332875373188.stgit@djiang5-desk3.ch.intel.com>
 <20180216172247.GS5217@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180216172247.GS5217@magnolia>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 16, 2018 at 09:22:47AM -0800, Darrick J. Wong wrote:
> On Fri, Feb 16, 2018 at 10:04:26AM -0700, Dave Jiang wrote:
> > In a situation where the rt_dev is DAX and data_dev is not DAX, if the user
> > requests to remove the realtime flag via ioctl we can no longer support DAX
> > for that file. Dynamic changing of S_DAX on the inode is not supported due
> > to various complications in the existing implementation. Therefore until we
> > address the dynamic S_DAX change issues, we must disallow realtime flag
> > being removed.
> > 
> > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_ioctl.c |   14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 2c70a0a4f59f..edd97d527fe8 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1030,6 +1030,20 @@ xfs_ioctl_setattr_xflags(
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	uint64_t		di_flags2;
> > +	struct inode		*inode = VFS_I(ip);
> > +	struct super_block	*sb = inode->i_sb;
> > +
> > +	/*
> > +	 * In the case that the inode is realtime, and we are trying to remove
> > +	 * the realtime flag, and the rtdev supports DAX but the datadev does
> > +	 * not support DAX, we can't allow the realtime flag to be removed
> > +	 * since we do not support dynamic S_DAX flag removal yet.
> > +	 */
> > +	if (XFS_IS_REALTIME_INODE(ip) &&
> > +	    !(fa->fsx_xflags & FS_XFLAG_REALTIME) &&
> > +	    bdev_dax_supported(mp->m_rtdev_targp->bt_bdev, sb->s_blocksize) &&
> > +	    !bdev_dax_supported(mp->m_ddev_targp->bt_bdev, sb->s_blocksize))
> 
> What happens here if we have a non-rt file that we're trying to turn
> into an rt file and the data dev supports dax but not the rt dev?
> 
> Changing the rt flag is only supported on files with no data blocks (no
> extents, no delalloc blocks), so why can't we remove S_DAX from an empty
> file?  There aren't any memory mappings or page cache to get in the way,
> correct?

File size can be non-zero, so you can have DAX read-over-hole
mappings present. I simply don't think it's safe to remove/add S_DAX
flags via ioctls right now. If we have a DAX capable rtdev, then the
only way we should allow rtdev+dax to be used right now is via the
RT inherit bit on the dir that creates files in the rtdev right from
the start. i.e. we can't set/remove the RT inode flag on an inode
via ioctl if rtdev+dax is enabled until the whole dynamic S_DAX
inode flag thing is resolved.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
