Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150606115822.GI2729@linux.intel.com>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150605211924.20751.434.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150606115822.GI2729@linux.intel.com>
Date: Fri, 7 Aug 2015 16:54:07 -0700
Message-ID: <CAPcyv4hiz1sFgyZfzJ5MNfuoqy0APZ+PwMG4FXJBz_p-gvoorg@mail.gmail.com>
Subject: Re: [PATCH v4 4/9] dax: fix mapping lifetime handling, convert to
 __pfn_t + kmap_atomic_pfn_t()
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, david <david@fromorbit.com>, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jun 6, 2015 at 4:58 AM, Matthew Wilcox <willy@linux.intel.com> wrote:
> On Fri, Jun 05, 2015 at 05:19:24PM -0400, Dan Williams wrote:
>> @@ -35,13 +35,16 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
>>       might_sleep();
>>       do {
>>               void *addr;
>> -             unsigned long pfn;
>> +             __pfn_t pfn;
>>               long count;
>>
>> -             count = bdev_direct_access(bdev, sector, &addr, &pfn, size);
>> +             count = bdev_direct_access(bdev, sector, &pfn, size);
>>               if (count < 0)
>>                       return count;
>>               BUG_ON(size < count);
>> +             addr = kmap_atomic_pfn_t(pfn);
>> +             if (!addr)
>> +                     return -EIO;
>>               while (count > 0) {
>>                       unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
>>                       if (pgsz > count)
>
> This part is incomplete.  When bdev_direct_access() could return an
> address, it was possible for that address to be unaligned (eg when
> 'sector' was not a multiple of 8).  DAX has never had full support for
> devices that weren't a 4k sector size, but I was trying to not make that
> assumption in more places than I had to.  So this function needs a lot
> more simplification (or it needs to add '(sector & 7) << 9' to addr ...
> assuming that the partition this bdev represents actually starts at a
> multiple of 8 ... bleh!).

Isn't this already handled by the:

    if (sector % (PAGE_SIZE / 512))
                    return -EINVAL;

...check in bdev_direct_access()?  As long as the driver's mapping is
4K aligned, which appears to be the case for all DAX-enabled drivers,
then we should be good to go.

>>
>> -static long dax_get_addr(struct buffer_head *bh, void **addr, unsigned blkbits)
>> +static long dax_get_pfn(struct buffer_head *bh, __pfn_t *pfn, unsigned blkbits)
>>  {
>> -     unsigned long pfn;
>>       sector_t sector = bh->b_blocknr << (blkbits - 9);
>> -     return bdev_direct_access(bh->b_bdev, sector, addr, &pfn, bh->b_size);
>> +     return bdev_direct_access(bh->b_bdev, sector, pfn, bh->b_size);
>>  }
>
> This function should just be deleted.  It offers essentially nothing
> over just calling bdev_direct_access().

Ok.
