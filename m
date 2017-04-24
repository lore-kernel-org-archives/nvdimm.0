Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B9E92195407C
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 13:52:12 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id x184so150816197oia.1
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 13:52:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJcbSZEOOZZnuD3nftkzpcthGdT-6f6DDZ=VtdBKuHbC+0LdFw@mail.gmail.com>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <20170419133630.GA2311@x1>
 <CAJcbSZEbrOfnMQhr2dA0HBqogo0dYsEGCGsEbPMh1kM9tX4tEA@mail.gmail.com>
 <20170420132632.GD2311@x1>
 <CAJcbSZEOOZZnuD3nftkzpcthGdT-6f6DDZ=VtdBKuHbC+0LdFw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 24 Apr 2017 13:52:10 -0700
Message-ID: <CAPcyv4gzdwDmtxoz7O5=1zGow+6zx2YqQqjRu1=kBX087MLx2Q@mail.gmail.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
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
To: Thomas Garnier <thgarnie@google.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 24, 2017 at 1:37 PM, Thomas Garnier <thgarnie@google.com> wrote:
>  )
>
> On Thu, Apr 20, 2017 at 6:26 AM, Baoquan He <bhe@redhat.com> wrote:
>> On 04/19/17 at 07:27am, Thomas Garnier wrote:
>>> On Wed, Apr 19, 2017 at 6:36 AM, Baoquan He <bhe@redhat.com> wrote:
>>> > Hi all,
>>> >
>>> > I login in Jeff's system, and added debug code, no clue found. However
>>> > DaveY found he disabled page_offset randomization only and the efi issue
>>> > won't be seen on his system with kaslr enabled. I did it too on Jeff's
>>> > pmem system, it has the same result. I have rebooted several times, all
>>> > boot successfully. In the current code, no __PAGE_OFFSET_BASE is used
>>> > directly, don't know why it failed.
>>>
>>> Great! I still cannot repro it.
>>>
>>> >
>>> > Does anyone have any idea or hint I can try? I read pmem code about
>>> > the devm_nsio_enable/pmem_attach_disk/arch_add_memory, have no idea yet.
>>>
>>> I would test couple things:
>>>  - Set page_offset_base to 0 by default and set it to
>>> __PAGE_OFFSET_BASE in kernel_randomize_memory (without randomizing
>>> it). If it crashes on a low address, it might be due to using __va or
>>> PAGE_OFFSET in general before randomization is done.
>>>  - Does any change in __PAGE_OFFSET lead to a crash? Or only when
>>> __PAGE_OFFSET is on a specific range. Given that you may have to
>>> reboot multiple times to get a crash, I assume that a specific range
>>> is the problem but might be worth checking.
>>
>> I added debug code and collected boot logs about failure cases and
>> success cases, seems it's related to crossing pgd entry issue. Below
>> code change is part of my debugging code, I added printing anywhere,
>> just abstract this for better understanding of the printed information
>> below it. The emulated pmem memory is [1TB, 1TB+192G], namely
>> [0x10000000000, 0x13000000000). If the left pud entries indexed from 1TB
>> is smaller than 192, it will fail. init_memory_mapping might have
>> handled direct mapping well, I am not sure if __add_pages is OK.
>>
>> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> index 5b536be..f3f8d43 100644
>> --- a/drivers/nvdimm/pmem.c
>> +++ b/drivers/nvdimm/pmem.c
>> @@ -87,6 +87,8 @@ static int read_pmem(struct page *page, unsigned int off,
>>  {
>>         int rc;
>>         void *mem = kmap_atomic(page);
>> +       pr_info("pfn:0x%llu, off=0x%lx, pmem_addr:0x%llx, len:0x%lx\n",
>> +               page_to_pfn(page), off, pmem_addr, len);
>>
>>         rc = memcpy_from_pmem(mem + off, pmem_addr, len);
>>         kunmap_atomic(mem);
>> @@ -312,6 +318,8 @@ static int pmem_attach_disk(struct device *dev,
>>         if (IS_ERR(addr))
>>                 return PTR_ERR(addr);
>>         pmem->virt_addr = addr;
>> +       pr_info("pmem->virt_addr:0x%llx, pmem->phys_addr:0x%llx, pmem->size:0x%llx\n",
>> +               pmem->virt_addr, pmem->phys_addr, pmem->size);
>>
>>         blk_queue_write_cache(q, true, true);
>>         blk_queue_make_request(q, pmem_make_request);
>>
>>
>
> Super useful. I can see that the virt_addr field can be set in three
> locations (http://lxr.free-electrons.com/source/drivers/nvdimm/pmem.c#L288).
> Can you check which one is used for the faulting addresses?
>
> Also the two functions used (devm_memremap_pages and devm_memremap)
> seem to check if the region intersects with IORESOURCE_SYSTEM_RAM, if
> it does then the mapping is not done and the __va is returned. I would
> be interested to know if this is what's happening. Basically logging
> the VA on these lines:
>
>  - http://lxr.free-electrons.com/source/kernel/memremap.c#L307
>  - http://lxr.free-electrons.com/source/kernel/memremap.c#L98
>
> This way, we can get closer to which code does not handle PG boundary correctly.
>
> Thanks!
>

When using the memmap= parameter we're using this call by default:

        } else if (pmem_should_map_pages(dev)) {
                addr = devm_memremap_pages(dev, &nsio->res,
                                &q->q_usage_counter, NULL);
                pmem->pfn_flags |= PFN_MAP;
        } else

...where we are assuming that the memmap= parameter does not specify a
range-size that will exhaust all of system-memory just to hold the
struct page array.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
