Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 26 Nov 2015 17:27:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 5/7] fs: notify superblocks of backing-device death
Message-ID: <20151126062728.GR19199@dastard>
References: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151125183724.12508.73971.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151125215050.GQ19199@dastard>
 <CAPcyv4i_wjZLNPN5C=fy7TL4N+QCedMX5U-T4gdMxhMmFztfJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4i_wjZLNPN5C=fy7TL4N+QCedMX5U-T4gdMxhMmFztfJA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 25, 2015 at 02:09:34PM -0800, Dan Williams wrote:
> On Wed, Nov 25, 2015 at 1:50 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Nov 25, 2015 at 10:37:24AM -0800, Dan Williams wrote:
> >> Set SB_I_BDIDEAD when a block device is no longer available to service
> >> requests.  This will be used in several places where an fs should give
> >> up early because the block device is gone.  Letting the fs continue on
> >> as if the block device is still present can lead to long latencies
> >> waiting for an fs to detect the loss of its backing device, trigger
> >> crashes, or generate misleasing warnings.
> >>
> >> Cc: Jan Kara <jack@suse.com>
> >> Cc: Jens Axboe <axboe@fb.com>
> >> Suggested-by: Dave Chinner <david@fromorbit.com>
> >
> > This isn't what I suggested. :/
> >
> > .....
> >
> >> diff --git a/fs/block_dev.c b/fs/block_dev.c
> >> index 1dd416bf72f7..d0233d643d33 100644
> >> --- a/fs/block_dev.c
> >> +++ b/fs/block_dev.c
> >> @@ -1795,6 +1795,23 @@ int __invalidate_device(struct block_device *bdev, bool kill_dirty)
> >>  }
> >>  EXPORT_SYMBOL(__invalidate_device);
> >>
> >> +void kill_bdev_super(struct gendisk *disk, int partno)
> >> +{
> >> +     struct block_device *bdev = bdget_disk(disk, partno);
> >> +     struct super_block *sb;
> >> +
> >> +     if (!bdev)
> >> +             return;
> >> +     sb = get_super(bdev);
> >> +     if (!sb)
> >> +             goto out;
> >> +
> >> +     sb->s_iflags |= SB_I_BDI_DEAD;
> >> +     drop_super(sb);
> >> + out:
> >> +     bdput(bdev);
> >> +}
> >
> > That's not a notification to the filesystem - that's a status flag
> > the filesystem has to explicitly check for *on every operation*. We
> > already have checks like these throughout filesystems, but they are
> > filesystem specific and need to propagate into fs-specific
> > subsystems that have knowledge of VFS level superblocks.
> >
> > To that end, what I actually suggested what a callback - something
> > like a function in the super operations structure so that the
> > filesystem can take *immediate action* when the block device is
> > dying. i.e.
> >
> > void kill_bdev_super(struct gendisk *disk, int partno)
> > {
> >         struct block_device *bdev = bdget_disk(disk, partno);
> >         struct super_block *sb;
> >
> >         if (!bdev)
> >                 return;
> >         sb = get_super(bdev);
> >         if (!sb)
> >                 goto out;
> >
> >         if (sb->s_ops->shutdown)
> >                 sb->s_ops->shutdown(sb);
> >
> >         drop_super(sb);
> >  out:
> >         bdput(bdev);
> > }
> >
> > and then we implement ->shutdown somthing like this in XFS:
> >
> > xfs_fs_shutdown(struct superblock *sb)
> > {
> >         xfs_force_shutdown(XFS_M(sb), SHUTDOWN_DEVICE_REQ);
> > }
> >
> > and so we immediately notify the entire filesystem that a shutdown
> > state has been entered and the appropriate actions are immediately
> > taken.
> >
> 
> That sounds good in theory.  However, in the case of xfs it is already
> calling xfs_force_shutdown(),

Where? If XFS does not do any metadata IO, then it won't shut the
filesystem down. We almost always allocate/map blocks without doing
any IO, which means we cannot guarantee erroring out page faults
during get_blocks until a shutdown has be triggered by other
means....

> but that does not prevent it from
> continuing to wait indefinitely at umount.

Which is a bug we need to fix - I don't see how a shutdown
implementation problem is at all relevant to triggering shutdowns in
a prompt manner...

> For the ext4 the
> mark_inode_dirty() warning we're triggering the error in generic code.

So? XFS doesn't use that generic code, but we have filesystem
specific issues that we need to handle sanely.

> None of this fixes the problem of dax mappings leaking past block
> device remove.  That can be done generically without needing per-fs
> code.

No, the shutdown is intended to close the race between the device
being removed, the mappings being invalidated and the filesytem
racing creating new mappings during page faults because it doesn't
know the device has been unplugged until it does IO that gets some
error in an unrecoverable path...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
