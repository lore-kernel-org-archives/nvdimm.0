Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 3 Nov 2015 16:40:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 14/15] dax: dirty extent notification
Message-ID: <20151103054039.GQ10656@dastard>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151102043058.6610.15559.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151103011653.GO10656@dastard>
 <CAPcyv4hof4rVN0EZHhV9Q7VBE0WMw6hcSrLK-HvB5FOrOwY+tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hof4rVN0EZHhV9Q7VBE0WMw6hcSrLK-HvB5FOrOwY+tg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 02, 2015 at 08:56:24PM -0800, Dan Williams wrote:
> On Mon, Nov 2, 2015 at 5:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Nov 01, 2015 at 11:30:58PM -0500, Dan Williams wrote:
> >> DAX-enabled block device drivers can use hints from fs/dax.c to
> >> optimize their internal tracking of potentially dirty cpu cache lines.
> >> If a DAX mapping is being used for synchronous operations, dax_do_io(),
> >> a dax-enabled block-driver knows that fs/dax.c will handle immediate
> >> flushing.  For asynchronous mappings, i.e.  returned to userspace via
> >> mmap, the driver can track active extents of the media for flushing.
> >
> > So, essentially, you are marking the calls into the mapping calls
> > with BLKDAX_F_DIRTY when the mapping is requested for a write page
> > fault?  Hence allowing the block device to track "dirty pages"
> > exactly?
> 
> Not pages, but larger extents (1 extent = 1/NUM_DAX_EXTENTS of the
> total storage capacity), because tracking dirty mappings should be
> temporary compatibility hack and not a first class citizen.
> 
> > But, really, if we're going to use Ross's mapping tree patches that
> > use exceptional entries to track dirty pfns, why do we need to this
> > special interface from DAX to the block device? Ross's changes will
> > track mmap'd ranges that are dirtied at the filesytem inode level,
> > and the fsync/writeback will trigger CPU cache writeback of those
> > dirty ranges. This will work for block devices that are mapped by
> > DAX, too, because they have a inode+mapping tree, too.
> >
> > And if we are going to use Ross's infrastructure (which, when we
> > work the kinks out of, I think we will), we really should change
> > dax_do_io() to track pfns that are dirtied this way, too. That will
> > allow us to get rid of all the cache flushing from the DAX layer
> > (they'll get pushed into fsync/writeback) and so we only take the
> > CPU cache flushing penalties when synchronous operations are
> > requested by userspace...
> 
> No, we definitely can't do that.   I think your mental model of the
> cache flushing is similar to the disk model where a small buffer is
> flushed after a large streaming write.  Both Ross' patches and my
> approach suffer from the same horror that the cache flushing is O(N)
> currently, so we don't want to make it responsible for more data
> ranges areas than is strictly necessary.

I didn't see anything that was O(N) in Ross's patches. What part of
the fsync algorithm that Ross proposed are you refering to here?

> >> We can later extend the DAX paths to indicate when an async mapping is
> >> "closed" allowing the active extents to be marked clean.
> >
> > Yes, that's a basic feature of Ross's patches. Hence I think this
> > special case DAX<->bdev interface is the wrong direction to be
> > taking.
> 
> So here's my problem with the "track dirty mappings" in the core
> mm/vfs approach, it's harder to unwind and delete when it turns out no
> application actually needs it, or the platform gives us an O(1) flush
> method that is independent of dirty pte tracking.
> 
> We have the NVML [1] library as the recommended method for
> applications to interact with persistent memory and it is not using
> fsync/msync for its synchronization primitives, it's managing the
> cache directly.  The *only* user for tracking dirty DAX mappings is
> unmodified legacy applications that do mmap I/O and call fsync/msync.

I'm pretty sure there are going to be many people still writing new
applications that use POSIX APIs they expect to work correctly on
pmem because, well, it's going to take 10 years before persistent
memory is common enough for most application developers to only
target storage via NVML.

The whole world is not crazy HFT applications that need to bypass
the kernel for *everything* because even a few nanoseconds of extra
latency matters.

> DAX in my opinion is not a transparent accelerator of all existing
> apps, it's a targeted mechanism for applications ready to take
> advantage of byte addressable persistent memory. 

And this is where we disagree. DAX is a method of allowing POSIX
compliant applications get the best of both worlds - portability
with existing storage and filesystems, yet with the speed and byte
addressiblity of persistent storage through the use of mmap.

Applications designed specifically for persistent memory don't want
a general purpose, POSIX compatible filesystem underneath them. The
should be interacting directly with, and only with, your NVML
library. If the NVML library is implemented by using DAX on a POSIX
compatible, general purpose filesystem, then you're just going to
have to live with everything we need to do to make DAX work with
general purpose POSIX compatible applications.

DAX has always been intended as a *stopgap measure* designed to
bridge the gap between existing POSIX based storage APIs and PMEM
native filesystem implementations. You're advocating that DAX should
only be used by PMEM native applications using NVML and then saying
anything that might be needed for POSIX compatible behaviour is
unacceptible overhead...

> This is why I'm a
> big supporter of your per-inode DAX control proposal.  The fact that
> fsync is painful for large amounts of dirty data is a feature.  It
> detects inodes that should have had DAX-disabled in the first
> instance.

fsync is painful for any storage when there is large amounts of
dirty data. DAX is no different, and it's not a reason for saying
"don't use DAX". DAX + fsync should be faster than "buffered IO
through the page cache on pmem + fsync" because there is only one
memory copy being done in the DAX case.

The buffered IO case has all that per-page radix tree tracking in it,
writeback, etc. Yet:

# mount -o dax /dev/ram0 /mnt/scratch
# time xfs_io -fc "truncate 0" -c "pwrite -b 8m 0 3g" -c fsync /mnt/scratch/file
wrote 3221225472/3221225472 bytes at offset 0
3.000 GiB, 384 ops; 0:00:10.00 (305.746 MiB/sec and 38.2182 ops/sec)
0.00user 10.05system 0:10.05elapsed 100%CPU (0avgtext+0avgdata 10512maxresident)k
0inputs+0outputs (0major+2156minor)pagefaults 0swaps
# umount /mnt/scratch
# mount /dev/ram0 /mnt/scratch
# time xfs_io -fc "truncate 0" -c "pwrite -b 8m 0 3g" -c fsync /mnt/scratch/file
wrote 3221225472/3221225472 bytes at offset 0
3.000 GiB, 384 ops; 0:00:02.00 (1.218 GiB/sec and 155.9046 ops/sec)
0.00user 2.83system 0:02.86elapsed 99%CPU (0avgtext+0avgdata 10468maxresident)k
0inputs+0outputs (0major+2154minor)pagefaults 0swaps
#

So don't tell me that tracking dirty pages in the radix tree too
slow for DAX and that DAX should not be used for POSIX IO based
applications - it should be as fast as buffered IO, if not faster,
and if it isn't then we've screwed up real bad. And right now, we're
screwing up real bad.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
