Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151103054039.GQ10656@dastard>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151102043058.6610.15559.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151103011653.GO10656@dastard>
	<CAPcyv4hof4rVN0EZHhV9Q7VBE0WMw6hcSrLK-HvB5FOrOwY+tg@mail.gmail.com>
	<20151103054039.GQ10656@dastard>
Date: Mon, 2 Nov 2015 23:20:49 -0800
Message-ID: <CAPcyv4gMuLcnLckoXQAe7yO36213rWT3KyHW+WrW3AtxaAHv0A@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] dax: dirty extent notification
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 2, 2015 at 9:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Nov 02, 2015 at 08:56:24PM -0800, Dan Williams wrote:
>> No, we definitely can't do that.   I think your mental model of the
>> cache flushing is similar to the disk model where a small buffer is
>> flushed after a large streaming write.  Both Ross' patches and my
>> approach suffer from the same horror that the cache flushing is O(N)
>> currently, so we don't want to make it responsible for more data
>> ranges areas than is strictly necessary.
>
> I didn't see anything that was O(N) in Ross's patches. What part of
> the fsync algorithm that Ross proposed are you refering to here?

We have to issue clflush per touched virtual address rather than a
constant number of physical ways, or a flush-all instruction.

>> >> We can later extend the DAX paths to indicate when an async mapping is
>> >> "closed" allowing the active extents to be marked clean.
>> >
>> > Yes, that's a basic feature of Ross's patches. Hence I think this
>> > special case DAX<->bdev interface is the wrong direction to be
>> > taking.
>>
>> So here's my problem with the "track dirty mappings" in the core
>> mm/vfs approach, it's harder to unwind and delete when it turns out no
>> application actually needs it, or the platform gives us an O(1) flush
>> method that is independent of dirty pte tracking.
>>
>> We have the NVML [1] library as the recommended method for
>> applications to interact with persistent memory and it is not using
>> fsync/msync for its synchronization primitives, it's managing the
>> cache directly.  The *only* user for tracking dirty DAX mappings is
>> unmodified legacy applications that do mmap I/O and call fsync/msync.
>
> I'm pretty sure there are going to be many people still writing new
> applications that use POSIX APIs they expect to work correctly on
> pmem because, well, it's going to take 10 years before persistent
> memory is common enough for most application developers to only
> target storage via NVML.
>
> The whole world is not crazy HFT applications that need to bypass
> the kernel for *everything* because even a few nanoseconds of extra
> latency matters.

I agree with all of that...

>> DAX in my opinion is not a transparent accelerator of all existing
>> apps, it's a targeted mechanism for applications ready to take
>> advantage of byte addressable persistent memory.
>
> And this is where we disagree. DAX is a method of allowing POSIX
> compliant applications get the best of both worlds - portability
> with existing storage and filesystems, yet with the speed and byte
> addressiblity of persistent storage through the use of mmap.
>
> Applications designed specifically for persistent memory don't want
> a general purpose, POSIX compatible filesystem underneath them. The
> should be interacting directly with, and only with, your NVML
> library. If the NVML library is implemented by using DAX on a POSIX
> compatible, general purpose filesystem, then you're just going to
> have to live with everything we need to do to make DAX work with
> general purpose POSIX compatible applications.
>
> DAX has always been intended as a *stopgap measure* designed to
> bridge the gap between existing POSIX based storage APIs and PMEM
> native filesystem implementations. You're advocating that DAX should
> only be used by PMEM native applications using NVML and then saying
> anything that might be needed for POSIX compatible behaviour is
> unacceptible overhead...

Also agreed, up until you this last sentence which is not what I am
saying at all.  I didn't say it is unacceptable overhead, my solution
in the driver has the exact same overhead.

Where I instead think we disagree is the acceptable cost of the "flush
cache" operation before the recommended solution is to locally disable
DAX, or require help from the platform to do this operation more
efficiently.  What I submit is unacceptable is to have the cpu loop
over every address heading out to storage.  The radix solution only
makes the second fsync after the first potentially less costly over
time.

I don't think we'll need it long term, or so I hope. The question
becomes do we want to carry this complexity in the core or push
selectively disabling DAX in the interim and have the simple driver
approach for cases where it's not feasible to disable DAX.  For 4.4 we
have the practical matter of not having the time to get mm folks to
review the radix approach.

I'm not opposed to ripping out the driver solution in 4.5 when we have
the time to get Ross' implementation reviewed.  I'm also holding back
the get_user_page() patches until 4.5 and given the big fat comment in
write_protect_page() about gup-fast interactions we'll need to think
through similar implications.

>
>> This is why I'm a
>> big supporter of your per-inode DAX control proposal.  The fact that
>> fsync is painful for large amounts of dirty data is a feature.  It
>> detects inodes that should have had DAX-disabled in the first
>> instance.
>
> fsync is painful for any storage when there is large amounts of
> dirty data. DAX is no different, and it's not a reason for saying
> "don't use DAX". DAX + fsync should be faster than "buffered IO
> through the page cache on pmem + fsync" because there is only one
> memory copy being done in the DAX case.
>
> The buffered IO case has all that per-page radix tree tracking in it,
> writeback, etc. Yet:
>
> # mount -o dax /dev/ram0 /mnt/scratch
> # time xfs_io -fc "truncate 0" -c "pwrite -b 8m 0 3g" -c fsync /mnt/scratch/file
> wrote 3221225472/3221225472 bytes at offset 0
> 3.000 GiB, 384 ops; 0:00:10.00 (305.746 MiB/sec and 38.2182 ops/sec)
> 0.00user 10.05system 0:10.05elapsed 100%CPU (0avgtext+0avgdata 10512maxresident)k
> 0inputs+0outputs (0major+2156minor)pagefaults 0swaps
> # umount /mnt/scratch
> # mount /dev/ram0 /mnt/scratch
> # time xfs_io -fc "truncate 0" -c "pwrite -b 8m 0 3g" -c fsync /mnt/scratch/file
> wrote 3221225472/3221225472 bytes at offset 0
> 3.000 GiB, 384 ops; 0:00:02.00 (1.218 GiB/sec and 155.9046 ops/sec)
> 0.00user 2.83system 0:02.86elapsed 99%CPU (0avgtext+0avgdata 10468maxresident)k
> 0inputs+0outputs (0major+2154minor)pagefaults 0swaps
> #
>
> So don't tell me that tracking dirty pages in the radix tree too
> slow for DAX and that DAX should not be used for POSIX IO based
> applications - it should be as fast as buffered IO, if not faster,
> and if it isn't then we've screwed up real bad. And right now, we're
> screwing up real bad.

Again, it's not the dirty tracking in the radix I'm worried about it's
looping through all the virtual addresses within those pages..
