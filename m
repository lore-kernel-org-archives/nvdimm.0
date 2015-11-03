Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151103005113.GN10656@dastard>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151102042952.6610.7185.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151103005113.GN10656@dastard>
Date: Mon, 2 Nov 2015 19:27:26 -0800
Message-ID: <CAPcyv4jDVRz79-iucQRjBdGyZ6Bc=UVDBJkmORugBMZ8Pm4RnQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/15] dax: increase granularity of dax_clear_blocks() operations
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 2, 2015 at 4:51 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Nov 01, 2015 at 11:29:53PM -0500, Dan Williams wrote:
>> dax_clear_blocks is currently performing a cond_resched() after every
>> PAGE_SIZE memset.  We need not check so frequently, for example md-raid
>> only calls cond_resched() at stripe granularity.  Also, in preparation
>> for introducing a dax_map_atomic() operation that temporarily pins a dax
>> mapping move the call to cond_resched() to the outer loop.
>>
>> Reviewed-by: Jan Kara <jack@suse.com>
>> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  fs/dax.c |   27 ++++++++++++---------------
>>  1 file changed, 12 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/dax.c b/fs/dax.c
>> index 5dc33d788d50..f8e543839e5c 100644
>> --- a/fs/dax.c
>> +++ b/fs/dax.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/sched.h>
>>  #include <linux/uio.h>
>>  #include <linux/vmstat.h>
>> +#include <linux/sizes.h>
>>
>>  int dax_clear_blocks(struct inode *inode, sector_t block, long size)
>>  {
>> @@ -38,24 +39,20 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
>>       do {
>>               void __pmem *addr;
>>               unsigned long pfn;
>> -             long count;
>> +             long count, sz;
>>
>> -             count = bdev_direct_access(bdev, sector, &addr, &pfn, size);
>> +             sz = min_t(long, size, SZ_1M);
>> +             count = bdev_direct_access(bdev, sector, &addr, &pfn, sz);
>>               if (count < 0)
>>                       return count;
>> -             BUG_ON(size < count);
>> -             while (count > 0) {
>> -                     unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
>> -                     if (pgsz > count)
>> -                             pgsz = count;
>> -                     clear_pmem(addr, pgsz);
>> -                     addr += pgsz;
>> -                     size -= pgsz;
>> -                     count -= pgsz;
>> -                     BUG_ON(pgsz & 511);
>> -                     sector += pgsz / 512;
>> -                     cond_resched();
>> -             }
>> +             if (count < sz)
>> +                     sz = count;
>> +             clear_pmem(addr, sz);
>> +             addr += sz;
>> +             size -= sz;
>> +             BUG_ON(sz & 511);
>> +             sector += sz / 512;
>> +             cond_resched();
>>       } while (size);
>>
>>       wmb_pmem();
>
> dax_clear_blocks() needs to go away and be replaced by a driver
> level implementation of blkdev_issue_zerout(). This is effectively a
> block device operation (we're taking sector addresses and zeroing
> them), so it really belongs in the pmem drivers rather than the DAX
> code.
>
> I suspect a REQ_WRITE_SAME implementation is the way to go here, as
> then the filesystems can just call sb_issue_zerout() and the block
> layer zeroing will work on all types of storage without the
> filesystem having to care whether DAX is in use or not.
>
> Putting the implementation of the zeroing in the pmem drivers will
> enable the drivers to optimise the caching behaviour of block
> zeroing.  The synchronous cache flushing behaviour of this function
> is a performance killer as we are now block zeroing on allocation
> and that results in two synchronous data writes (zero on alloc,
> commit, write data, commit) for each page.
>
> The zeroing (and the data, for that matter) doesn't need to be
> committed to persistent store until the allocation is written and
> committed to the journal - that will happen with a REQ_FLUSH|REQ_FUA
> write, so it makes sense to deploy the big hammer and delay the
> blocking CPU cache flushes until the last possible moment in cases
> like this.

In pmem terms that would be a non-temporal memset plus a delayed
wmb_pmem at REQ_FLUSH time.  Better to write around the cache than
loop over the dirty-data issuing flushes after the fact.  We'll bump
the priority of the non-temporal memset implementation.

I like the idea of pushing this down into the driver vs your other
feedback of pushing dirty extent tracking up into the radix... but
more on that in the other thread.
