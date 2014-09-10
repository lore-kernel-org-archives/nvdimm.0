Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <5410899C.3030501@plexistor.com>
Date: Wed, 10 Sep 2014 20:25:48 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/9] mm: Let sparse_{add,remove}_one_section receive a
 node_id
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com> <540F20AB.4000404@plexistor.com> <540F48BA.2090304@intel.com> <541022DB.9090000@plexistor.com> <541077DF.1060609@intel.com>
In-Reply-To: <541077DF.1060609@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave.hansen@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org, Toshi Kani <toshi.kani@hp.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 09/10/2014 07:10 PM, Dave Hansen wrote:
> On 09/10/2014 03:07 AM, Boaz Harrosh wrote:
>> On 09/09/2014 09:36 PM, Dave Hansen wrote:
>>> On 09/09/2014 08:45 AM, Boaz Harrosh wrote:
>>>> This is for add_persistent_memory that will want a section of pages
>>>> allocated but without any zone associated. This is because belonging
>>>> to a zone will give the memory to the page allocators, but
>>>> persistent_memory belongs to a block device, and is not available for
>>>> regular volatile usage.
>>>
>>> I don't think we should be taking patches like this in to the kernel
>>> until we've seen the other side of it.  Where is the page allocator code
>>> which will see a page belonging to no zone?  Am I missing it in this set?
>>
>> It is not missing. It will never be.
>>
>> These pages do not belong to any allocator. They are not allocate-able
>> pages. In fact they are not "memory" they are "storage"
>>
>> These pages belong wholesomely to a block-device. In turn the block
>> device grants ownership of a partition of this pages to an FS.
>> The FS loaded has its own block allocation schema. Which internally
>> circulate each pages usage around. But the page never goes beyond its
>> FS.
> 
> I'm mostly worried about things that start with an mmap().
> 
> Imagine you mmap() a persistent memory file, fault some pages in, then
> 'cat /proc/$pid/numa_maps'.  That code will look at the page to see
> which zone and node it is in.
> 
> Or, consider if you mmap() then put a futex in the page.  The page will
> have get_user_pages() called on it by the futex code, and a reference
> taken.  The reference can outlast the mmap().  We either have to put the
> file somewhere special and scan the page's reference occasionally, or we
> need to hook something under put_page() to make sure that we keep the
> page out of the normal allocator.
> 

Yes the block_allocator of the pmem-FS always holds the final REF on this
page, as long as there is valid data on this block. Even cross boots, the
mount code re-initializes references. The only internal state that frees
these blocks is truncate, which only then return these pages to the block
allocator, all this is common practice in filesystems so the page-ref on
these blocks only ever drops to zero after they loose all visibility. And
yes the block allocator uses a special code to drop the count to zero
not using put_page().

So there is no chance these pages will ever be presented to page_allocators
through a  put_page().

BTW: There is an hook in place that can be used today. By calling
  SetPagePrivate(page) and setting a .release function on the page->mapping->a_ops
  If .release() returns false the page is not released (and can be added on an
  internal queue for garbage collection)
  But with above schema this is not needed at all. I yet need to find a test
  that keeps my free_block reference above 1. At which time I will exercise
  a garbage collection queue.

>>> I see about 80 or so calls to page_zone() in the kernel.  How will a
>>> zone-less page look to all of these sites?
>>
>> None of these 80 call site will be reached! the pages are always used
>> below the FS, like send them on the network, or send them to a slower
>> block device via a BIO. I have a full fledge FS on top of this code
>> and it all works very smoothly, and stable. (And fast ;))
> 
> Does the fs support mmap()?
> 
> The idea of layering is a nice one, but mmap() is a big fat layering
> violation. :)
> 

No!

Yes the FS supports mmap, but through the DAX patchset. Please see
Matthew's DAX patchset how he implements mmap without using pages
at all, direct PFN to virtual_addr. So these pages do not get exposed
to the top of the FS.

My FS uses his technics exactly only when it wants to spill over to
slower device it will use these pages copy-less.

Cheers
Boaz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
