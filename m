Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151103193223.GD23366@linux.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151102043009.6610.83896.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151103193223.GD23366@linux.intel.com>
Date: Tue, 3 Nov 2015 13:39:00 -0800
Message-ID: <CAPcyv4huhdf=JHqnHbbi4dXdFXj0TpTuabGm+4Wod_fi280HLQ@mail.gmail.com>
Subject: Re: [PATCH v3 05/15] libnvdimm, pmem: fix size trim in pmem_direct_access()
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 3, 2015 at 11:32 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Sun, Nov 01, 2015 at 11:30:10PM -0500, Dan Williams wrote:
>> This masking prevents access to the end of the device via dax_do_io(),
>> and is unnecessary as arch_add_memory() would have rejected an unaligned
>> allocation.
>>
>> Cc: <stable@vger.kernel.org>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/nvdimm/pmem.c |   17 +++--------------
>>  1 file changed, 3 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> index e46988fbdee5..93472953e231 100644
>> --- a/drivers/nvdimm/pmem.c
>> +++ b/drivers/nvdimm/pmem.c
>> @@ -100,26 +100,15 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
>>  }
>>
>>  static long pmem_direct_access(struct block_device *bdev, sector_t sector,
>> -                   void __pmem **kaddr, unsigned long *pfn)
>> +                   void __pmem **kaddr, pfn_t *pfn)
>
> It seems kind of weird to change only this instance of direct_access() to have
> the last argument as a pfn_t instead of an unsigned long?   If pfn_t is more
> descriptive (I think it is) should we update the definition in struct
> block_device_operations and all the other implementors of direct_access as
> well?  If that's touching too much, let's do them all together later, but
> let's not change one now and have them be inconsistent.
>

Oh, nice catch, that's just a mistake when I moved this patch earlier
in the series... and I wonder why 0day didn't complain about it?  In
any event, will fix.

>>  {
>>       struct pmem_device *pmem = bdev->bd_disk->private_data;
>>       resource_size_t offset = sector * 512 + pmem->data_offset;
>> -     resource_size_t size;
>>
>> -     if (pmem->data_offset) {
>> -             /*
>> -              * Limit the direct_access() size to what is covered by
>> -              * the memmap
>> -              */
>> -             size = (pmem->size - offset) & ~ND_PFN_MASK;
>> -     } else
>> -             size = pmem->size - offset;
>> -
>> -     /* FIXME convert DAX to comprehend that this mapping has a lifetime */
>>       *kaddr = pmem->virt_addr + offset;
>> -     *pfn = (pmem->phys_addr + offset) >> PAGE_SHIFT;
>> +     *pfn = __phys_to_pfn(pmem->phys_addr + offset, pmem->pfn_flags);
>
> __phys_to_pfn() only takes a single argument (the paddr) in v4.3,
> jens/for-4.4/integrity and in nvdimm/libnvdimm-for-next.  Is this second
> argument of pfn_flags actually correct?

Yeah, this shouldn't even compile.

Thanks Ross!
