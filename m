Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151126062728.GR19199@dastard>
References: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151125183724.12508.73971.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151125215050.GQ19199@dastard>
	<CAPcyv4i_wjZLNPN5C=fy7TL4N+QCedMX5U-T4gdMxhMmFztfJA@mail.gmail.com>
	<20151126062728.GR19199@dastard>
Date: Wed, 25 Nov 2015 23:11:00 -0800
Message-ID: <CAPcyv4ipVjvMJ7VjtcBX+umXZPv66X8p6V4VwfKjBrkQhJZ5jg@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] fs: notify superblocks of backing-device death
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 25, 2015 at 10:27 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Nov 25, 2015 at 02:09:34PM -0800, Dan Williams wrote:
>> On Wed, Nov 25, 2015 at 1:50 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Wed, Nov 25, 2015 at 10:37:24AM -0800, Dan Williams wrote:
[..]
>> That sounds good in theory.  However, in the case of xfs it is already
>> calling xfs_force_shutdown(),
>
> Where?

In the trace I included in the cover letter.

Testing this patch set reveals that xfs needs more XFS_FORCED_SHUTDOWN
checks, especially in the unmount path.  Currently we deadlock here on
umount after block device removal:

 INFO: task umount:2187 blocked for more than 120 seconds.
       Tainted: G           O    4.4.0-rc2+ #1953
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 umount          D ffff8800d2fbfd70     0  2187   2095 0x00000080
  ffff8800d2fbfd70 ffffffff81f94f98 ffff88031fc97bd8 ffff88030af5ad80
  ffff8800db71db00 ffff8800d2fc0000 ffff8800db8dbde0 ffff8800d93b6708
  ffff8800d93b6760 ffff8800d93b66d8 ffff8800d2fbfd88 ffffffff818f0695
 Call Trace:
  [<ffffffff818f0695>] schedule+0x35/0x80
  [<ffffffffa01e134e>] xfs_ail_push_all_sync+0xbe/0x110 [xfs]
  [<ffffffff810ecc30>] ? wait_woken+0x80/0x80
  [<ffffffffa01c8d91>] xfs_unmountfs+0x81/0x1b0 [xfs]
  [<ffffffffa01c991b>] ? xfs_mru_cache_destroy+0x6b/0x90 [xfs]
  [<ffffffffa01cbf30>] xfs_fs_put_super+0x30/0x90 [xfs]
  [<ffffffff81247eca>] generic_shutdown_super+0x6a/0xf0

Earlier in this trace xfs has already performed:

 XFS (pmem0m): xfs_do_force_shutdown(0x2) called from line 1197 of
file fs/xfs/xfs_log.c.

...but xfs_log_work_queue() continues to run periodically.

> If XFS does not do any metadata IO, then it won't shut the
> filesystem down. We almost always allocate/map blocks without doing
> any IO, which means we cannot guarantee erroring out page faults
> during get_blocks until a shutdown has be triggered by other
> means....
>
>> but that does not prevent it from
>> continuing to wait indefinitely at umount.
>
> Which is a bug we need to fix - I don't see how a shutdown
> implementation problem is at all relevant to triggering shutdowns in
> a prompt manner...
>
>> For the ext4 the
>> mark_inode_dirty() warning we're triggering the error in generic code.
>
> So? XFS doesn't use that generic code, but we have filesystem
> specific issues that we need to handle sanely.
>
>> None of this fixes the problem of dax mappings leaking past block
>> device remove.  That can be done generically without needing per-fs
>> code.
>
> No, the shutdown is intended to close the race between the device
> being removed, the mappings being invalidated and the filesytem
> racing creating new mappings during page faults because it doesn't
> know the device has been unplugged until it does IO that gets some
> error in an unrecoverable path...
>

So you want me to grow a ->sb_shutdown() method for each fs that
supports dax only to call unmap_mapping_range on each dax inode when
common code could have already walked the inode list.  Also separately
teach each fs to start returning errors on get_blocks() after shutdown
even though fs/dax.c can figure it out from the return value from
blk_queue_enter?  I'm failing to see the point.

That is of course separate from the real need for an ->sb_shutdown()
to tell the fs that the device is gone for other filesystem specific
operations.
