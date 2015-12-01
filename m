Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151201040336.GS19199@dastard>
References: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151125183724.12508.73971.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151125215050.GQ19199@dastard>
	<CAPcyv4i_wjZLNPN5C=fy7TL4N+QCedMX5U-T4gdMxhMmFztfJA@mail.gmail.com>
	<20151126062728.GR19199@dastard>
	<CAPcyv4ipVjvMJ7VjtcBX+umXZPv66X8p6V4VwfKjBrkQhJZ5jg@mail.gmail.com>
	<20151201040336.GS19199@dastard>
Date: Mon, 30 Nov 2015 20:20:47 -0800
Message-ID: <CAPcyv4iQx=dohU+gcEUmxA5LGZYsRKoUsfpHSOx=+Jzu_BS+jQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] fs: notify superblocks of backing-device death
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 30, 2015 at 8:03 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Nov 25, 2015 at 11:11:00PM -0800, Dan Williams wrote:
>> On Wed, Nov 25, 2015 at 10:27 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Wed, Nov 25, 2015 at 02:09:34PM -0800, Dan Williams wrote:
>> >> On Wed, Nov 25, 2015 at 1:50 PM, Dave Chinner <david@fromorbit.com> wrote:
>> >> > On Wed, Nov 25, 2015 at 10:37:24AM -0800, Dan Williams wrote:
>> [..]
>> >> That sounds good in theory.  However, in the case of xfs it is already
>> >> calling xfs_force_shutdown(),
>> >
>> > Where?
>>
>> In the trace I included in the cover letter.
>>
>> Testing this patch set reveals that xfs needs more XFS_FORCED_SHUTDOWN
>> checks, especially in the unmount path.  Currently we deadlock here on
>> umount after block device removal:
>
> What's the test case?
>
> From what you've said, it appears to be another manifestation where
> we trying to recovery from non-fatal IO errors that are being
> reported by the block device, but that is short-cutting the path
> that normally does shutdown detection on metadata buffer IO
> completion.
>
> Filesystem error handling coul dbe a lot more simple if we didnt'
> have to try to guess what EIO from the block device actually means.
> If device unplug triggered a shutdown, we wouldn't have to care
> about retrying in many cases where we do right now because shutdown
> then has clear priority of all other errors we need to handle. RIgh
> tnow we just have ot guess, and there's a long history of corner
> cases where we have guessed wrong....
>
> I have patches to fix this particular manifestation, but until we
> have have notification that devices hav ebeen unplugged and are not
> coming back we're going to continue to struggle to get this right
> and hence have re-occurring bugs when users pull USB drives out from
> under active filesystems.....
>
>
>> >> None of this fixes the problem of dax mappings leaking past block
>> >> device remove.  That can be done generically without needing per-fs
>> >> code.
>> >
>> > No, the shutdown is intended to close the race between the device
>> > being removed, the mappings being invalidated and the filesytem
>> > racing creating new mappings during page faults because it doesn't
>> > know the device has been unplugged until it does IO that gets some
>> > error in an unrecoverable path...
>>
>> So you want me to grow a ->sb_shutdown() method for each fs that
>> supports dax only to call unmap_mapping_range on each dax inode when
>> common code could have already walked the inode list.
>
> No, I don't want you to implement some whacky, dax only
> ->sb_shutdown method. I want a notification method to be implemented
> so that each filesystem can take the necessary action it requires
> when the underlying block device goes away.
>
> Yes, that *filesystem specific method* might involve invalidating
> all the dirty inodes in the filesystem, and if there are DAX
> mappings in the filesystem then invalidating them, too, but that's
> something the filesystem needs to take care of because *all
> filesystem shutdowns must do this*.
>
> Do you see the distinction there? This isn't just about device
> unplug - there are lots of different triggers for a filesystem
> shutdown. However, regardless of the shutdown trigger, we have to
> take the same action. That is, we have to prevent all pending and
> future IO from being issued to the block device, *even if the block
> device is still OK*.

Ah, that finally got through to me.

I'll refactor this to be a ->shutdown notification with a generic
unmap that a filesystem can optionally call under its own discretion.
As I now see that generic functionality is just common code that an fs
might optionally need/use, but it is counter productive for that to be
privately triggered only by the block layer and only from an event
like del_gendisk.  We need it in potentially all fs shutdown paths.
