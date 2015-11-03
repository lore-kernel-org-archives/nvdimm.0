Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151103190140.GB23366@linux.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151102042958.6610.65193.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151103190140.GB23366@linux.intel.com>
Date: Tue, 3 Nov 2015 14:50:32 -0800
Message-ID: <CAPcyv4h6FFX05U5atqSFRNkdawq81638ydD5PAtmKzWGnkyWoA@mail.gmail.com>
Subject: Re: [PATCH v3 03/15] block, dax: fix lifetime of in-kernel dax
 mappings with dax_map_atomic()
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 3, 2015 at 11:01 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Sun, Nov 01, 2015 at 11:29:58PM -0500, Dan Williams wrote:
>> The DAX implementation needs to protect new calls to ->direct_access()
>> and usage of its return value against unbind of the underlying block
>> device.  Use blk_queue_enter()/blk_queue_exit() to either prevent
>> blk_cleanup_queue() from proceeding, or fail the dax_map_atomic() if the
>> request_queue is being torn down.
>>
>> Cc: Jan Kara <jack@suse.com>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Dave Chinner <david@fromorbit.com>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
> <>
[ trim the comments that Jeff responded to]

>> @@ -305,11 +353,10 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
>>               goto out;
>>       }
>>
>> -     error = bdev_direct_access(bh->b_bdev, sector, &addr, &pfn, bh->b_size);
>> -     if (error < 0)
>> -             goto out;
>> -     if (error < PAGE_SIZE) {
>> -             error = -EIO;
>> +     addr = __dax_map_atomic(bdev, to_sector(bh, inode), bh->b_size,
>> +                     &pfn, NULL);
>> +     if (IS_ERR(addr)) {
>> +             error = PTR_ERR(addr);
>
> Just a note that we lost the check for bdev_direct_access() returning less
> than PAGE_SIZE.  Are we sure this can't happen and that it's safe to remove
> the check?

Yes, as Jeff recommends I'll do a follow on patch to make this an
explicit guarantee of bdev_direct_access() just like the page
alignment.

>
>> @@ -609,15 +655,20 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>>               result = VM_FAULT_NOPAGE;
>>               spin_unlock(ptl);
>>       } else {
>> -             sector = bh.b_blocknr << (blkbits - 9);
>> -             length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
>> -                                             bh.b_size);
>> -             if (length < 0) {
>> +             long length;
>> +             unsigned long pfn;
>> +             void __pmem *kaddr = __dax_map_atomic(bdev,
>> +                             to_sector(&bh, inode), HPAGE_SIZE, &pfn,
>> +                             &length);
>
> Let's use PMD_SIZE instead of HPAGE_SIZE to be consistent with the rest of the
> DAX code.
>

I changed to HPAGE_SIZE on advice from Dave Hansen.  I'll insert a
preceding cleanup patch in this series to do the conversion since we
should be consistent with the use of PAGE_SIZE in the other dax paths.

>> +
>> +             if (IS_ERR(kaddr)) {
>>                       result = VM_FAULT_SIGBUS;
>>                       goto out;
>>               }
>> -             if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
>> +             if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR)) {
>> +                     dax_unmap_atomic(bdev, kaddr);
>>                       goto fallback;
>> +             }
>>
>>               if (buffer_unwritten(&bh) || buffer_new(&bh)) {
>>                       clear_pmem(kaddr, HPAGE_SIZE);
>
> Ditto, let's use PMD_SIZE for consistency (I realize this was changed ealier
> in the series).

Ditto on the rebuttal.
