Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <5603BC62.1050805@plexistor.com>
Date: Thu, 24 Sep 2015 12:03:30 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH] dax: fix deadlock in __dax_fault
References: <1443040800-5460-1-git-send-email-ross.zwisler@linux.intel.com> <20150924025225.GT3902@dastard>
In-Reply-To: <20150924025225.GT3902@dastard>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 09/24/2015 05:52 AM, Dave Chinner wrote:
> On Wed, Sep 23, 2015 at 02:40:00PM -0600, Ross Zwisler wrote:
>> Fix the deadlock exposed by xfstests generic/075.  Here is the sequence
>> that was causing us to deadlock:
>>
>> 1) enter __dax_fault()
>> 2) page = find_get_page() gives us a page, so skip
>> 	i_mmap_lock_write(mapping)
>> 3) if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page)
>> 	passes, enter this block
>> 4) if (vmf->flags & FAULT_FLAG_WRITE) fails, so do the else case and
>> 	i_mmap_unlock_write(mapping);
>> 	return dax_load_hole(mapping, page, vmf);
>>
>> This causes us to up_write() a semaphore that we weren't holding.
>>
>> The up_write() on a semaphore we didn't down_write() happens twice in
>> a row, and then the next time we try and i_mmap_lock_write(), we hang.
>>
>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Reported-by: Dave Chinner <david@fromorbit.com>
>> ---
>>  fs/dax.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/dax.c b/fs/dax.c
>> index 7ae6df7..df1b0ac 100644
>> --- a/fs/dax.c
>> +++ b/fs/dax.c
>> @@ -405,7 +405,8 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>>  			if (error)
>>  				goto unlock;
>>  		} else {
>> -			i_mmap_unlock_write(mapping);
>> +			if (!page)
>> +				i_mmap_unlock_write(mapping);
>>  			return dax_load_hole(mapping, page, vmf);
>>  		}
>>  	}
> 
> I can't review this properly because I can't work out how this
> locking is supposed to work.  Captain, we have a Charlie Foxtrot
> situation here:
> 
> 	page = find_get_page(mapping, vmf->pgoff)
> 	if (page) {
> 		....
> 	} else {
> 		i_mmap_lock_write(mapping);
> 	}
> 
> So if there's no page in the page cache, we lock the i_mmap_lock.
> The we have the case the above patch fixes. Then later:
> 
> 	if (vmf->cow_page) {
> 		.....
> 		if (!page) {
> 			/* can fall through */
> 		}
> 		return VM_FAULT_LOCKED;
> 	}
> 
> Which means __dax_fault() can also return here with the
> i_mmap_lock_write() held. There's no documentation to indicate why
> this is valid, and only by looking about 4 function calls higher up
> the stack can I see that there's some attempt to handle this
> *specific return condition* (in do_cow_fault()). That also is
> lacking in documentation explaining the circumstances where we might
> have the i_mmap_lock_write() held and have to release it. (Not to
> mention the beautiful copy-n-waste of the unlock code, either.)
> 
> The above code in __dax_fault() is then followed by this gem:
> 
> 	/* Check we didn't race with a read fault installing a new page */
>         if (!page && major)
>                 page = find_lock_page(mapping, vmf->pgoff);
> 
> 	if (page) {
> 		/* mapping invalidation .... */
> 	}
> 	.....
> 
> 	if (!page)
> 		i_mmap_unlock_write(mapping);
> 
> Which means that if we had a race with another read fault, we'll
> remove the page from the page cache, insert the new direct mapped
> pfn into the mapping, and *then fail to unlock the i_mmap lock*.
> 
> Is this supposed to work this way? Or is it another bug?
> 
> Another difficult question this change of locking raised that I
> can't answer: is it valid to call into the filesystem via getblock()
> or complete_unwritten() while holding the i_mmap_rwsem? This puts
> filesystem transactions and locks inside the scope of i_mmap_rwsem,
> which may have impact on the fact that we already have an inode lock
> order dependency w.r.t. i_mmap_rwsem through truncate (and probably
> other paths, too).
> 
> So, please document the locking model, explain the corner cases and
> the intricacies like why *unbalanced, return value conditional
> locking* is necessary, and update the charts of lock order
> dependencies in places like mm/filemap.c, and then we might have
> some idea of how much of a train-wreck this actually is....
> 

Hi hi

I hate this VM_FAULT_LOCKED + !page which means i_mmap_lock. I still
think it solves nothing and that we've done a really really bad job.

If we *easily* involve the FS in the locking here (Which btw I think XFS
already does), then this all i_mmap_lock can be avoided.

Please remind me again what race it is suppose to avoid? I get confused.

> Cheers,
> Dave.
> 

Thanks
Boaz

