Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151103011653.GO10656@dastard>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151102043058.6610.15559.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151103011653.GO10656@dastard>
Date: Mon, 2 Nov 2015 20:56:24 -0800
Message-ID: <CAPcyv4hof4rVN0EZHhV9Q7VBE0WMw6hcSrLK-HvB5FOrOwY+tg@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] dax: dirty extent notification
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 2, 2015 at 5:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Nov 01, 2015 at 11:30:58PM -0500, Dan Williams wrote:
>> DAX-enabled block device drivers can use hints from fs/dax.c to
>> optimize their internal tracking of potentially dirty cpu cache lines.
>> If a DAX mapping is being used for synchronous operations, dax_do_io(),
>> a dax-enabled block-driver knows that fs/dax.c will handle immediate
>> flushing.  For asynchronous mappings, i.e.  returned to userspace via
>> mmap, the driver can track active extents of the media for flushing.
>
> So, essentially, you are marking the calls into the mapping calls
> with BLKDAX_F_DIRTY when the mapping is requested for a write page
> fault?  Hence allowing the block device to track "dirty pages"
> exactly?

Not pages, but larger extents (1 extent = 1/NUM_DAX_EXTENTS of the
total storage capacity), because tracking dirty mappings should be
temporary compatibility hack and not a first class citizen.

> But, really, if we're going to use Ross's mapping tree patches that
> use exceptional entries to track dirty pfns, why do we need to this
> special interface from DAX to the block device? Ross's changes will
> track mmap'd ranges that are dirtied at the filesytem inode level,
> and the fsync/writeback will trigger CPU cache writeback of those
> dirty ranges. This will work for block devices that are mapped by
> DAX, too, because they have a inode+mapping tree, too.
>
> And if we are going to use Ross's infrastructure (which, when we
> work the kinks out of, I think we will), we really should change
> dax_do_io() to track pfns that are dirtied this way, too. That will
> allow us to get rid of all the cache flushing from the DAX layer
> (they'll get pushed into fsync/writeback) and so we only take the
> CPU cache flushing penalties when synchronous operations are
> requested by userspace...

No, we definitely can't do that.   I think your mental model of the
cache flushing is similar to the disk model where a small buffer is
flushed after a large streaming write.  Both Ross' patches and my
approach suffer from the same horror that the cache flushing is O(N)
currently, so we don't want to make it responsible for more data
ranges areas than is strictly necessary.

>> We can later extend the DAX paths to indicate when an async mapping is
>> "closed" allowing the active extents to be marked clean.
>
> Yes, that's a basic feature of Ross's patches. Hence I think this
> special case DAX<->bdev interface is the wrong direction to be
> taking.

So here's my problem with the "track dirty mappings" in the core
mm/vfs approach, it's harder to unwind and delete when it turns out no
application actually needs it, or the platform gives us an O(1) flush
method that is independent of dirty pte tracking.

We have the NVML [1] library as the recommended method for
applications to interact with persistent memory and it is not using
fsync/msync for its synchronization primitives, it's managing the
cache directly.  The *only* user for tracking dirty DAX mappings is
unmodified legacy applications that do mmap I/O and call fsync/msync.

DAX in my opinion is not a transparent accelerator of all existing
apps, it's a targeted mechanism for applications ready to take
advantage of byte addressable persistent memory.  This is why I'm a
big supporter of your per-inode DAX control proposal.  The fact that
fsync is painful for large amounts of dirty data is a feature.  It
detects inodes that should have had DAX-disabled in the first
instance.  The only advantage of the radix approach is that the second
fsync after the big hit may be faster, but that still can't beat
either targeted disabling of DAX or updating the app to use NVML.

So, again, I remain to be convinced that we need to carry complexity
in the core kernel when we have the page cache to cover those cases.
The driver solution is a minimal extension of the data
bdev_direct_access() is already sending down to the driver, and covers
the gap without mm/fs entanglements while we figure out a longer term
solution.

[1]: https://github.com/pmem/nvml
