Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <55CC3222.5090503@plexistor.com>
References: <20150813025112.36703.21333.stgit@otcpl-skl-sds-2.jf.intel.com>
	<20150813030109.36703.21738.stgit@otcpl-skl-sds-2.jf.intel.com>
	<55CC3222.5090503@plexistor.com>
Date: Thu, 13 Aug 2015 05:57:26 -0700
Message-ID: <CAPcyv4gwFD5F=k_qQyf68z74Opzf1t4DMqY+A9D2w_Fwsbzvew@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] allow mapping page-less memremaped areas into KVA
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Rik van Riel <riel@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 12, 2015 at 10:58 PM, Boaz Harrosh <boaz@plexistor.com> wrote:
> On 08/13/2015 06:01 AM, Dan Williams wrote:
[..]
>> +void *kmap_atomic_pfn_t(__pfn_t pfn)
>> +{
>> +     struct page *page = __pfn_t_to_page(pfn);
>> +     resource_size_t addr;
>> +     struct kmap *kmap;
>> +
>> +     rcu_read_lock();
>> +     if (page)
>> +             return kmap_atomic(page);
>
> Right even with pages I pay rcu_read_lock(); for every access?
>
>> +     addr = __pfn_t_to_phys(pfn);
>> +     list_for_each_entry_rcu(kmap, &ranges, list)
>> +             if (addr >= kmap->res->start && addr <= kmap->res->end)
>> +                     return kmap->base + addr - kmap->res->start;
>> +
>
> Good god! This loop is a real *joke*. You have just dropped memory access
> performance by 10 fold.
>
> The all point of pages and memory_model.h was to have a one to one
> relation-ships between Kernel-virtual vs physical vs page *
>
> There is already an object that holds a relationship of physical
> to Kernel-virtual. It is called a memory-section. Why not just
> widen its definition?
>
> If you are willing to accept this loop. In current Linux 2015 Kernel
> Then I have nothing farther to say.
>
> Boaz - go mourning for the death of the Linux Kernel alone in the corner ;-(
>

This is explicitly addressed in the changelog, repeated here:

> The __pfn_t to resource lookup is indeed inefficient walking of a linked list,
> but there are two mitigating factors:
>
> 1/ The number of persistent memory ranges is bounded by the number of
>    DIMMs which is on the order of 10s of DIMMs, not hundreds.
>
> 2/ The lookup yields the entire range, if it becomes inefficient to do a
>    kmap_atomic_pfn_t() a PAGE_SIZE at a time the caller can take
>    advantage of the fact that the lookup can be amortized for all kmap
>    operations it needs to perform in a given range.

DAX as is is races against pmem unbind.   A synchronization cost must
be paid somewhere to make sure the memremap() mapping is still valid.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
