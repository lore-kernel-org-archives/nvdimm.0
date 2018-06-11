Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B0532116168E
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 09:45:42 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id c128-v6so18471991oig.11
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 09:45:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180611155013.tt4sykwh2dp2vq2e@quack2.suse.cz>
References: <152850182079.38390.8280340535691965744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152850187949.38390.1012249765651998342.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180611155013.tt4sykwh2dp2vq2e@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Jun 2018 09:45:40 -0700
Message-ID: <CAPcyv4iwEOKKO92AcV=0R_-cuH9FzRO98=NVNX-sa4Fe2A3K2Q@mail.gmail.com>
Subject: Re: [PATCH v4 11/12] mm, memory_failure: Teach memory_failure() about
 dev_pagemap pages
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
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 11, 2018 at 8:50 AM, Jan Kara <jack@suse.cz> wrote:
> On Fri 08-06-18 16:51:19, Dan Williams wrote:
>>     mce: Uncorrected hardware memory error in user-access at af34214200
>>     {1}[Hardware Error]: It has been corrected by h/w and requires no further action
>>     mce: [Hardware Error]: Machine check events logged
>>     {1}[Hardware Error]: event severity: corrected
>>     Memory failure: 0xaf34214: reserved kernel page still referenced by 1 users
>>     [..]
>>     Memory failure: 0xaf34214: recovery action for reserved kernel page: Failed
>>     mce: Memory error not recovered
>>
>> In contrast to typical memory, dev_pagemap pages may be dax mapped. With
>> dax there is no possibility to map in another page dynamically since dax
>> establishes 1:1 physical address to file offset associations. Also
>> dev_pagemap pages associated with NVDIMM / persistent memory devices can
>> internal remap/repair addresses with poison. While memory_failure()
>> assumes that it can discard typical poisoned pages and keep them
>> unmapped indefinitely, dev_pagemap pages may be returned to service
>> after the error is cleared.
>>
>> Teach memory_failure() to detect and handle MEMORY_DEVICE_HOST
>> dev_pagemap pages that have poison consumed by userspace. Mark the
>> memory as UC instead of unmapping it completely to allow ongoing access
>> via the device driver (nd_pmem). Later, nd_pmem will grow support for
>> marking the page back to WB when the error is cleared.
>
> ...
>
>> +static unsigned long dax_mapping_size(struct page *page)
>> +{
>> +     struct address_space *mapping = page->mapping;
>> +     pgoff_t pgoff = page_to_pgoff(page);
>> +     struct vm_area_struct *vma;
>> +     unsigned long size = 0;
>> +
>> +     i_mmap_lock_read(mapping);
>> +     vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
>> +             unsigned long address = vma_address(page, vma);
>> +             pgd_t *pgd;
>> +             p4d_t *p4d;
>> +             pud_t *pud;
>> +             pmd_t *pmd;
>> +             pte_t *pte;
>> +
>> +             pgd = pgd_offset(vma->vm_mm, address);
>> +             if (!pgd_present(*pgd))
>> +                     continue;
>> +             p4d = p4d_offset(pgd, address);
>> +             if (!p4d_present(*p4d))
>> +                     continue;
>> +             pud = pud_offset(p4d, address);
>> +             if (!pud_present(*pud))
>> +                     continue;
>> +             if (pud_devmap(*pud)) {
>> +                     size = PUD_SIZE;
>> +                     break;
>> +             }
>> +             pmd = pmd_offset(pud, address);
>> +             if (!pmd_present(*pmd))
>> +                     continue;
>> +             if (pmd_devmap(*pmd)) {
>> +                     size = PMD_SIZE;
>> +                     break;
>> +             }
>> +             pte = pte_offset_map(pmd, address);
>> +             if (!pte_present(*pte))
>> +                     continue;
>> +             if (pte_devmap(*pte)) {
>> +                     size = PAGE_SIZE;
>> +                     break;
>> +             }
>> +     }
>> +     i_mmap_unlock_read(mapping);
>> +
>> +     return size;
>> +}
>
> Correct me if I'm wrong but cannot the same pfn be mapped by different VMAs
> with different granularity? I recall that if we have a fully allocated PMD
> entry in the radix tree we can hand out 4k entries from inside of it just
> fine...

Oh, I thought we broke up the 2M entry when that happened.

> So whether dax_mapping_size() returns 4k or 2MB would be random?
> Why don't we use the entry size in the radix tree when we have done all the
> work and looked it up there to lock it anyway?

Device-dax has no use case to populate the radix.

I think this means that we need to track the mapping size in the
memory_failure() path per vma that has the pfn mapped. I'd prefer that
over teaching device-dax to populate the radix, or teaching fs-dax to
break up huge pages when another vma wants 4K.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
