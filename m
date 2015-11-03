Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151103205131.GH19199@dastard>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151102043058.6610.15559.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151103011653.GO10656@dastard>
	<CAPcyv4hof4rVN0EZHhV9Q7VBE0WMw6hcSrLK-HvB5FOrOwY+tg@mail.gmail.com>
	<20151103054039.GQ10656@dastard>
	<CAPcyv4gMuLcnLckoXQAe7yO36213rWT3KyHW+WrW3AtxaAHv0A@mail.gmail.com>
	<20151103205131.GH19199@dastard>
Date: Tue, 3 Nov 2015 13:19:08 -0800
Message-ID: <CAPcyv4jyO8eVOcyPEi8Ga382UQw4DmG4gzcyqkcHS2JsFqfQ0g@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] dax: dirty extent notification
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 3, 2015 at 12:51 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Nov 02, 2015 at 11:20:49PM -0800, Dan Williams wrote:
>> On Mon, Nov 2, 2015 at 9:40 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Mon, Nov 02, 2015 at 08:56:24PM -0800, Dan Williams wrote:
>> >> No, we definitely can't do that.   I think your mental model of the
>> >> cache flushing is similar to the disk model where a small buffer is
>> >> flushed after a large streaming write.  Both Ross' patches and my
>> >> approach suffer from the same horror that the cache flushing is O(N)
>> >> currently, so we don't want to make it responsible for more data
>> >> ranges areas than is strictly necessary.
>> >
>> > I didn't see anything that was O(N) in Ross's patches. What part of
>> > the fsync algorithm that Ross proposed are you refering to here?
>>
>> We have to issue clflush per touched virtual address rather than a
>> constant number of physical ways, or a flush-all instruction.
> .....
>> > So don't tell me that tracking dirty pages in the radix tree too
>> > slow for DAX and that DAX should not be used for POSIX IO based
>> > applications - it should be as fast as buffered IO, if not faster,
>> > and if it isn't then we've screwed up real bad. And right now, we're
>> > screwing up real bad.
>>
>> Again, it's not the dirty tracking in the radix I'm worried about it's
>> looping through all the virtual addresses within those pages..
>
> So, let me summarise what I think you've just said. You are
>
> 1. fine with looping through the virtual addresses doing cache flushes
>    synchronously when doing IO despite it having significant
>    latency and performance costs.

No, like I said in the blkdev_issue_zeroout thread we need to replace
looping flushes with non-temporal stores and delayed wmb_pmem()
wherever possible.

> 2. Happy to hack a method into DAX to bypass the filesystems by
>    pushing information to the block device for it to track regions that
>    need cache flushes, then add infrastructure to the block device to
>    track those dirty regions and then walk those addresses and issue
>    cache flushes when the filesystem issues a REQ_FLUSH IO regardless
>    of whether the filesystem actually needs those cachelines flushed
>    for that specific IO?

I'm happier with a temporary driver level hack than a temporary core
kernel change.  This requirement to flush by virtual address is
something that, in my opinion, must be addressed by the platform with
a reliable global flush or by walking a small constant number of
physical-cache-ways.  I think we're getting ahead of ourselves jumping
to solving this in the core kernel while the question of how to do
efficient large flushes is still pending.

> 3. Not happy to use the generic mm/vfs level infrastructure
>    architectected specifically to provide the exact asynchronous
>    cache flushing/writeback semantics we require because it will
>    cause too many cache flushes, even though the number of cache
>    flushes will be, at worst, the same as in 2).

Correct, because if/when a platform solution arrives the need to track
dirty pfns evaporates.

> 1) will work, but as we can see it is *slow*. 3) is what Ross is
> implementing - it's a tried and tested architecture that all mm/fs
> developers understand, and his explanation of why it will work for
> pmem is pretty solid and completely platform/hardware architecture
> independent.
>
> Which leaves this question: How does 2) save us anything in terms of
> avoiding iterating virtual addresses and issuing cache flushes
> over 3)? And is it sufficient to justify hacking a bypass into DAX
> and the additional driver level complexity of having to add dirty
> region tracking, flushing and cleaning to REQ_FLUSH operations?
>

Given what we are talking about amounts to a hardware workaround I
think that kind of logic belongs in a driver.  If the cache flushing
gets fixed and we stop needing to track individual cachelines the
flush implementation will look and feel much more like existing
storage drivers.
