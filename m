Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 1 Dec 2015 15:03:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 5/7] fs: notify superblocks of backing-device death
Message-ID: <20151201040336.GS19199@dastard>
References: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151125183724.12508.73971.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151125215050.GQ19199@dastard>
 <CAPcyv4i_wjZLNPN5C=fy7TL4N+QCedMX5U-T4gdMxhMmFztfJA@mail.gmail.com>
 <20151126062728.GR19199@dastard>
 <CAPcyv4ipVjvMJ7VjtcBX+umXZPv66X8p6V4VwfKjBrkQhJZ5jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4ipVjvMJ7VjtcBX+umXZPv66X8p6V4VwfKjBrkQhJZ5jg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 25, 2015 at 11:11:00PM -0800, Dan Williams wrote:
> On Wed, Nov 25, 2015 at 10:27 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Nov 25, 2015 at 02:09:34PM -0800, Dan Williams wrote:
> >> On Wed, Nov 25, 2015 at 1:50 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Wed, Nov 25, 2015 at 10:37:24AM -0800, Dan Williams wrote:
> [..]
> >> That sounds good in theory.  However, in the case of xfs it is already
> >> calling xfs_force_shutdown(),
> >
> > Where?
> 
> In the trace I included in the cover letter.
> 
> Testing this patch set reveals that xfs needs more XFS_FORCED_SHUTDOWN
> checks, especially in the unmount path.  Currently we deadlock here on
> umount after block device removal:

What's the test case?

>From what you've said, it appears to be another manifestation where
we trying to recovery from non-fatal IO errors that are being
reported by the block device, but that is short-cutting the path
that normally does shutdown detection on metadata buffer IO
completion.

Filesystem error handling coul dbe a lot more simple if we didnt'
have to try to guess what EIO from the block device actually means.
If device unplug triggered a shutdown, we wouldn't have to care
about retrying in many cases where we do right now because shutdown
then has clear priority of all other errors we need to handle. RIgh
tnow we just have ot guess, and there's a long history of corner
cases where we have guessed wrong....

I have patches to fix this particular manifestation, but until we
have have notification that devices hav ebeen unplugged and are not
coming back we're going to continue to struggle to get this right
and hence have re-occurring bugs when users pull USB drives out from
under active filesystems.....


> >> None of this fixes the problem of dax mappings leaking past block
> >> device remove.  That can be done generically without needing per-fs
> >> code.
> >
> > No, the shutdown is intended to close the race between the device
> > being removed, the mappings being invalidated and the filesytem
> > racing creating new mappings during page faults because it doesn't
> > know the device has been unplugged until it does IO that gets some
> > error in an unrecoverable path...
> 
> So you want me to grow a ->sb_shutdown() method for each fs that
> supports dax only to call unmap_mapping_range on each dax inode when
> common code could have already walked the inode list.

No, I don't want you to implement some whacky, dax only
->sb_shutdown method. I want a notification method to be implemented
so that each filesystem can take the necessary action it requires
when the underlying block device goes away.

Yes, that *filesystem specific method* might involve invalidating
all the dirty inodes in the filesystem, and if there are DAX
mappings in the filesystem then invalidating them, too, but that's
something the filesystem needs to take care of because *all
filesystem shutdowns must do this*.

Do you see the distinction there? This isn't just about device
unplug - there are lots of different triggers for a filesystem
shutdown. However, regardless of the shutdown trigger, we have to
take the same action. That is, we have to prevent all pending and
future IO from being issued to the block device, *even if the block
device is still OK*.

For example, if we detect a free space corruption during allocation,
it is not safe to trust *any active mapping* because we can't trust
that we having handed out the same block to multiple owners. Hence
on such a filesystem shutdown, we have to prevent any new DAX
mapping from occurring and invalidate all existing mappings as we
cannot allow userspace to modify any data or metadata until we've
resolved the corruption situation.

The simple fact is that a /filesystem/ shutdown needs to do DAX
mapping invalidation regardless of whether the block device has been
unplugged or not. This is not a case of "this only happens when we
unplug the device", this is a user data protection mechanism that we
use to prevent corruption propagation once it has been detected. A
device unplug is just one type of "corruption" that can occur.

Hence putting all this special invalidation stuff into the block
devices is simply duplicating functionality we need to implement in
the filesystem layers.  Regardless of this, it should be done by the
filesystem layers because that is where all the information necesary
to determine what needs invalidation is stored.

So, from the block dvice perspective, the *only thing it needs to
do* is notify the filesystem that it needs to shut down, and the
filesystem should then take care of everything else. Device unplug
is not some special snowflake that needs to be treated differently
from all other types of "it's dead, Jim" filesystem errors - from
the FS perspective it's the dead simple case because there are no
serious consequences if we screw up. i.e. if the FS gets it wrong
and IO is still issued after the shutdown, the IO is going to be
errored out rather than corrupting something on disk that would have
otherwise been OK....

> Also separately
> teach each fs to start returning errors on get_blocks() after shutdown
> even though fs/dax.c can figure it out from the return value from
> blk_queue_enter?

They will already return errors from get_blocks.

STATIC int
__xfs_get_blocks(
        struct inode            *inode,
        sector_t                iblock,
        struct buffer_head      *bh_result,
        int                     create,
        bool                    direct,
        bool                    dax_fault)
{
        struct xfs_inode        *ip = XFS_I(inode);
        struct xfs_mount        *mp = ip->i_mount;
        xfs_fileoff_t           offset_fsb, end_fsb;
        int                     error = 0;
        int                     lockmode = 0;
        struct xfs_bmbt_irec    imap;
        int                     nimaps = 1;
        xfs_off_t               offset;
        ssize_t                 size;
        int                     new = 0;

        if (XFS_FORCED_SHUTDOWN(mp))
                return -EIO;
.....

Hmmm? First thing XFS does in get_blocks() is check for shutdown.
In fact, the first thing that every major subsystem entry point
does in XFs is check for shutdown. Let's look at a typical
allocation get_blocks call in XFS:

 xfs_get_blocks
   __xfs_get_blocks - has shutdown check
    xfs_bmapi_read - shutdown check is second after error injection
    xfs_iomap_write_direct
      xfs_trans_reserve - has shutdown check
      xfs_bmapi_write - has shutdown check
      xfs_trans_commit - has shutdown check

IOWs, there are shutdown checks all through the get_blocks callbacks
already, so it's hardly a caase of you having to go an add support
to any filesystem for this...

Cheers,
MDave.

-- 
Dave Chinner
david@fromorbit.com
