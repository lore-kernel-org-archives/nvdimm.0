Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
 [150.101.137.131])
 by ml01.01.org (Postfix) with ESMTP id 0E3FE21E0BA0C
 for <linux-nvdimm@lists.01.org>; Thu,  1 Feb 2018 19:35:41 -0800 (PST)
Date: Fri, 2 Feb 2018 14:36:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2 2/2] xfs: fix rt_dev usage for DAX
Message-ID: <20180202033617.g23puq2xbwy4wmug@destitution>
References: <151751717968.69886.6978962571680635420.stgit@djiang5-desk3.ch.intel.com>
 <151751718516.69886.135497175511444689.stgit@djiang5-desk3.ch.intel.com>
 <20180201234413.idd27uqzqbg54ddk@destitution>
 <20180202004332.GZ4849@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180202004332.GZ4849@magnolia>
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

On Thu, Feb 01, 2018 at 04:43:32PM -0800, Darrick J. Wong wrote:
> On Fri, Feb 02, 2018 at 10:44:13AM +1100, Dave Chinner wrote:
> > On Thu, Feb 01, 2018 at 01:33:05PM -0700, Dave Jiang wrote:
> > > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > > Reported-by: Darrick Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_iops.c  |    3 ++-
> > >  fs/xfs/xfs_super.c |    9 ++++++++-
> > >  2 files changed, 10 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > index 56475fcd76f2..ab352c325301 100644
> > > --- a/fs/xfs/xfs_iops.c
> > > +++ b/fs/xfs/xfs_iops.c
> > > @@ -1204,7 +1204,8 @@ xfs_diflags_to_iflags(
> > >  	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
> > >  	    !xfs_is_reflink_inode(ip) &&
> > >  	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
> > > -	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
> > > +	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX) &&
> > > +	    blk_queue_dax(bdev_get_queue(inode->i_sb->s_bdev)))
> > 
> > This does not discriminate between the rtdev or the data dev. This
> > needs to call xfs_find_bdev_for_inode() to get the right device
> > for the inode config.
> > 
> > Further, if we add or remove the RT flag to the inode at a later
> > point in time (e.g. via ioctl) we also need to re-evaluate the S_DAX
> > flag at that point in time.
> 
> Ah, right, I'd missed that subtlety in my earlier replies.  Ok, add
> another patch to this series to reevaluate S_DAX when we change the RT
> flag.
> 
> > Which brings me to the real problem here: dynamically changing the
> > S_DAX flag is racy, dangerous and broken. It's not clear that this
> > should be allowed at all as the inode may have already been mmap()d
> > by the time the ioctl is called to set/clear the rt file state.
> 
> Agreed that this is a mess.  Either this needs to get fixed in the dax
> code, or we need to decide that we're not going to support reconfiguring
> the dax flag at all, except possibly for empty files (similar to how we
> restrict changes to the rt flag).

Hmmm, the rt flag limitations are to do with whether extents have
been allocated or not. IIRC the issue with S_DAX is whether the file
has been mmap()d or not which we can't check for reliably even if
the file is empty...

.....

> > >  	if (mp->m_flags & XFS_MOUNT_DAX) {
> > > +		bool rtdev_is_dax = false;
> > > +
> > >  		xfs_warn(mp,
> > >  		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
> > >  
> > > +		if (mp->m_rtdev_targp->bt_daxdev)
> > > +			if (bdev_dax_supported(mp->m_rtdev_targp->bt_bdev,
> > > +					      sb->s_blocksize) == 0)
> > > +				rtdev_is_dax = true;
> > 
> > .... as this code here needs to turn off DAX here if any device
> > in the filesystem doesn't support DAX....
> 
> I think it'd be useful to be able to have a pmem rt device even if the
> data device doesn't support it.  Or rather, I have a few clients who
> have expressed interest in this sort of configuration.

Understood.

I suspect all this means we can only support DAX on the rt device by
setting the RT flag on file create, at least until the dynamic S_DAX
issues are sorted out.  And that also means it can't be cleared from
files that have it set. So perhaps all we need to do is disallow
changing the RT flag on regular files via the ioctl if XFS_MOUNT_DAX
is set?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
