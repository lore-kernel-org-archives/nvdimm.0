Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22e.google.com (mail-io0-x22e.google.com
 [IPv6:2607:f8b0:4001:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 81F85222275A4
 for <linux-nvdimm@lists.01.org>; Sun,  7 Jan 2018 13:53:34 -0800 (PST)
Received: by mail-io0-x22e.google.com with SMTP id 14so11042233iou.2
 for <linux-nvdimm@lists.01.org>; Sun, 07 Jan 2018 13:58:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180104111233.GD29010@quack2.suse.cz>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407705124.38751.12934858054023659736.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180104111233.GD29010@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 7 Jan 2018 13:58:42 -0800
Message-ID: <CAA9_cmcL7E7F+sEp1wn6H4TQBQeNttm_MSJjKT9jNfOri8iK9g@mail.gmail.com>
Subject: Re: [PATCH v4 17/18] mm, fs, dax: dax_flush_dma, handle dma vs
 block-map-change collisions
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 4, 2018 at 3:12 AM, Jan Kara <jack@suse.cz> wrote:
> On Sat 23-12-17 16:57:31, Dan Williams wrote:
>> +static struct page *dma_busy_page(void *entry)
>> +{
>> +     unsigned long pfn, end_pfn;
>> +
>> +     for_each_entry_pfn(entry, pfn, end_pfn) {
>> +             struct page *page = pfn_to_page(pfn);
>> +
>> +             if (page_ref_count(page) > 1)
>> +                     return page;
>> +     }
>> +     return NULL;
>> +}
>> +
>>  /*
>>   * Find radix tree entry at given index. If it points to an exceptional entry,
>>   * return it with the radix tree entry locked. If the radix tree doesn't
>> @@ -557,6 +570,87 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
>>       return entry;
>>  }
>>
>> +int dax_flush_dma(struct address_space *mapping, wait_atomic_t_action_f action)
>
> I don't quite like the 'dma' terminology when this is all about page
> references in fact. How about renaming like dma_busy_page() ->
> devmap_page_referenced() instead and dax_flush_dma() -> dax_wait_pages_unused()
> or something like that?

Sure, but this is moot given your better proposal below.

>
>> +{
>> +     pgoff_t indices[PAGEVEC_SIZE];
>> +     struct pagevec pvec;
>> +     pgoff_t index, end;
>> +     unsigned i;
>> +
>> +     /* in the limited case get_user_pages for dax is disabled */
>> +     if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
>> +             return 0;
>> +
>> +     if (!dax_mapping(mapping))
>> +             return 0;
>> +
>> +     if (mapping->nrexceptional == 0)
>> +             return 0;
>> +
>> +retry:
>> +     pagevec_init(&pvec);
>> +     index = 0;
>> +     end = -1;
>> +     unmap_mapping_range(mapping, 0, 0, 1);
>
> unmap_mapping_range() would be IMHO be more logical in the callers. Maybe
> a cleaner API would be like providing a function
> dax_find_referenced_page(mapping) which either returns NULL or a page that
> has elevated refcount. Filesystem can then drop locks it needs to and call
> wait_on_atomic_one() (possibly hidden in a DAX helper). When wait finishes,
> filesystem can do the retry. That way the whole lock, unlock, wait, retry
> logic is clearly visible in fs code, there's no need of 'action' function
> or propagation of locking state etc.

Yes, sounds better, I'll go this way.

>
>> +     /*
>> +      * Flush dax_dma_lock() sections to ensure all possible page
>> +      * references have been taken, or will block on the fs
>> +      * 'mmap_lock'.
>> +      */
>> +     synchronize_rcu();
>
> Frankly, I don't like synchronize_rcu() in a relatively hot path like this.
> Cannot we just abuse get_dev_pagemap() to fail if truncation is in progress
> for the pfn? We could indicate that by some bit in struct page or something
> like that.

We would need a lockless way to take a reference conditionally if the
page is not subject to truncation.

I recall the raid5 code did something similar where it split a
reference count into 2 fields. I.e. take page->_refcount and use the
upper bits as a truncation count. Something like:

do {
    old = atomic_read(&page->_refcount);
    if (old & trunc_mask) /* upper bits of _refcount */
        return false;
    new = cnt + 1;
} while (atomic_cmpxchg(&page->_refcount, old, new) != old);
return true; /* we incremented the _refcount while the truncation
count was zero */

...the only concern is teaching the put_page() path to consider that
'trunc_mask' when determining that the page is idle.

Other ideas?

>> +     while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
>> +                             min(end - index, (pgoff_t)PAGEVEC_SIZE),
>> +                             indices)) {
>> +             int rc = 0;
>> +
>> +             for (i = 0; i < pagevec_count(&pvec); i++) {
>> +                     struct page *pvec_ent = pvec.pages[i];
>> +                     struct page *page = NULL;
>> +                     void *entry;
>> +
>> +                     index = indices[i];
>> +                     if (index >= end)
>> +                             break;
>> +
>> +                     if (!radix_tree_exceptional_entry(pvec_ent))
>> +                             continue;
>
> This would be a bug so I'm not sure we need to handle that.

Sure, I can kill that check.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
