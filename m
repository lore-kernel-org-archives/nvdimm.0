Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <54118A91.30603@plexistor.com>
Date: Thu, 11 Sep 2014 14:42:09 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH] SQUASHME pmem: Micro optimization for pmem_direct_access
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>	 <540F1EC6.4000504@plexistor.com> <54108149.3060506@plexistor.com> <1410388365.23970.9.camel@rzwisler-mobl1.amr.corp.intel.com>
In-Reply-To: <1410388365.23970.9.camel@rzwisler-mobl1.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 09/11/2014 01:32 AM, Ross Zwisler wrote:
> On Wed, 2014-09-10 at 19:50 +0300, Boaz Harrosh wrote:
<>
>> @@ -61,22 +61,12 @@ static int pmem_getgeo(struct block_device *bd, struct hd_geometry *geo)
>>   */
>>  static void *pmem_lookup_pg_addr(struct pmem_device *pmem, sector_t sector)
>>  {
>> -	size_t page_offset = sector >> PAGE_SECTORS_SHIFT;
>> -	size_t offset = page_offset << PAGE_SHIFT;
>> +	size_t offset = sector << SECTOR_SHIFT;
> 
> You just broke the "The return value will point to the beginning of the page
> containing the given sector, not to the sector itself." part of the contract
> spelled out in the comments.  This means that when you have an I/O that starts
> at a sector that isn't page aligned, copy_to_pmem() or copy_from_pmem() will
> get back a pointer to the *sector*, not the *page*, and the memcopy that takes
> into account the offset will do the wrong thing.
> 

Yes! I just saw this in testing. (Which means I did not test right ;-))
Sorry. I'll resend

>>  	BUG_ON(offset >= pmem->size);
>>  	return pmem->virt_addr + offset;
>>  }
>>  
>> -/* sector must be page aligned */
>> -static unsigned long pmem_lookup_pfn(struct pmem_device *pmem, sector_t sector)
>> -{
>> -	size_t page_offset = sector >> PAGE_SECTORS_SHIFT;
>> -
>> -	BUG_ON(sector & (PAGE_SECTORS - 1));
>> -	return (pmem->phys_addr >> PAGE_SHIFT) + page_offset;
>> -}
>> -
>>  /*
>>   * sector is not required to be page aligned.
>>   * n is at most a single page, but could be less.
>> @@ -200,14 +190,16 @@ static long pmem_direct_access(struct block_device *bdev, sector_t sector,
>>  			      void **kaddr, unsigned long *pfn, long size)
>>  {
>>  	struct pmem_device *pmem = bdev->bd_disk->private_data;
>> +	size_t offset = sector << SECTOR_SHIFT;
>>  
>>  	if (!pmem)
>>  		return -ENODEV;
>>  
>> -	*kaddr = pmem_lookup_pg_addr(pmem, sector);
>> -	*pfn = pmem_lookup_pfn(pmem, sector);
>> +	BUG_ON(offset >= pmem->size);
> 
> No need to add this - bounds checking is done in bdev_direct_access().
> 

Right thanks, copy/paste for you

>> +	*kaddr = pmem->virt_addr + offset;
>> +	*pfn = (pmem->phys_addr + offset) >> PAGE_SHIFT;
>>  
>> -	return pmem->size - (sector * 512);
>> +	return pmem->size - offset;
>>  }
>>  
>>  static const struct block_device_operations pmem_fops = {
> 
> 

Boaz

