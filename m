Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5453321954084
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 16:07:42 -0700 (PDT)
Date: Tue, 25 Apr 2017 07:07:38 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
Message-ID: <20170424230738.GA11734@x1>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <20170419133630.GA2311@x1>
 <CAJcbSZEbrOfnMQhr2dA0HBqogo0dYsEGCGsEbPMh1kM9tX4tEA@mail.gmail.com>
 <20170420132632.GD2311@x1>
 <CAJcbSZEOOZZnuD3nftkzpcthGdT-6f6DDZ=VtdBKuHbC+0LdFw@mail.gmail.com>
 <CAPcyv4gzdwDmtxoz7O5=1zGow+6zx2YqQqjRu1=kBX087MLx2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gzdwDmtxoz7O5=1zGow+6zx2YqQqjRu1=kBX087MLx2Q@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Thomas Garnier <thgarnie@google.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 04/24/17 at 01:52pm, Dan Williams wrote:
> On Mon, Apr 24, 2017 at 1:37 PM, Thomas Garnier <thgarnie@google.com> wrote:
> >  )
> >
> > On Thu, Apr 20, 2017 at 6:26 AM, Baoquan He <bhe@redhat.com> wrote:
> >> On 04/19/17 at 07:27am, Thomas Garnier wrote:
> >>> On Wed, Apr 19, 2017 at 6:36 AM, Baoquan He <bhe@redhat.com> wrote:
> >>> > Hi all,
> >>> >
> >>> > I login in Jeff's system, and added debug code, no clue found. However
> >>> > DaveY found he disabled page_offset randomization only and the efi issue
> >>> > won't be seen on his system with kaslr enabled. I did it too on Jeff's
> >>> > pmem system, it has the same result. I have rebooted several times, all
> >>> > boot successfully. In the current code, no __PAGE_OFFSET_BASE is used
> >>> > directly, don't know why it failed.
> >>>
> >>> Great! I still cannot repro it.
> >>>
> >>> >
> >>> > Does anyone have any idea or hint I can try? I read pmem code about
> >>> > the devm_nsio_enable/pmem_attach_disk/arch_add_memory, have no idea yet.
> >>>
> >>> I would test couple things:
> >>>  - Set page_offset_base to 0 by default and set it to
> >>> __PAGE_OFFSET_BASE in kernel_randomize_memory (without randomizing
> >>> it). If it crashes on a low address, it might be due to using __va or
> >>> PAGE_OFFSET in general before randomization is done.
> >>>  - Does any change in __PAGE_OFFSET lead to a crash? Or only when
> >>> __PAGE_OFFSET is on a specific range. Given that you may have to
> >>> reboot multiple times to get a crash, I assume that a specific range
> >>> is the problem but might be worth checking.
> >>
> >> I added debug code and collected boot logs about failure cases and
> >> success cases, seems it's related to crossing pgd entry issue. Below
> >> code change is part of my debugging code, I added printing anywhere,
> >> just abstract this for better understanding of the printed information
> >> below it. The emulated pmem memory is [1TB, 1TB+192G], namely
> >> [0x10000000000, 0x13000000000). If the left pud entries indexed from 1TB
> >> is smaller than 192, it will fail. init_memory_mapping might have
> >> handled direct mapping well, I am not sure if __add_pages is OK.
> >>
> >> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> >> index 5b536be..f3f8d43 100644
> >> --- a/drivers/nvdimm/pmem.c
> >> +++ b/drivers/nvdimm/pmem.c
> >> @@ -87,6 +87,8 @@ static int read_pmem(struct page *page, unsigned int off,
> >>  {
> >>         int rc;
> >>         void *mem = kmap_atomic(page);
> >> +       pr_info("pfn:0x%llu, off=0x%lx, pmem_addr:0x%llx, len:0x%lx\n",
> >> +               page_to_pfn(page), off, pmem_addr, len);
> >>
> >>         rc = memcpy_from_pmem(mem + off, pmem_addr, len);
> >>         kunmap_atomic(mem);
> >> @@ -312,6 +318,8 @@ static int pmem_attach_disk(struct device *dev,
> >>         if (IS_ERR(addr))
> >>                 return PTR_ERR(addr);
> >>         pmem->virt_addr = addr;
> >> +       pr_info("pmem->virt_addr:0x%llx, pmem->phys_addr:0x%llx, pmem->size:0x%llx\n",
> >> +               pmem->virt_addr, pmem->phys_addr, pmem->size);
> >>
> >>         blk_queue_write_cache(q, true, true);
> >>         blk_queue_make_request(q, pmem_make_request);
> >>
> >>
> >
> > Super useful. I can see that the virt_addr field can be set in three
> > locations (http://lxr.free-electrons.com/source/drivers/nvdimm/pmem.c#L288).
> > Can you check which one is used for the faulting addresses?
> >
> > Also the two functions used (devm_memremap_pages and devm_memremap)
> > seem to check if the region intersects with IORESOURCE_SYSTEM_RAM, if
> > it does then the mapping is not done and the __va is returned. I would
> > be interested to know if this is what's happening. Basically logging
> > the VA on these lines:
> >
> >  - http://lxr.free-electrons.com/source/kernel/memremap.c#L307
> >  - http://lxr.free-electrons.com/source/kernel/memremap.c#L98
> >
> > This way, we can get closer to which code does not handle PG boundary correctly.
> >
> > Thanks!
> >
> 
> When using the memmap= parameter we're using this call by default:
> 
>         } else if (pmem_should_map_pages(dev)) {
>                 addr = devm_memremap_pages(dev, &nsio->res,
>                                 &q->q_usage_counter, NULL);
>                 pmem->pfn_flags |= PFN_MAP;
>         } else
> 
> ...where we are assuming that the memmap= parameter does not specify a
> range-size that will exhaust all of system-memory just to hold the
> struct page array.

Yeah, according to my debugging tracking, it goes as Dan said. And the
is_ram is REGION_DISJOINT. And till arch_add_memory, the parameters
passed to arch_add_memory are "arch_add_memory, align_start:0x10000000000, align_size:0x3000000000",
seems it's going well.

Hi Dan,

I am always confused that in devm_memremap_pages, the passed in
parameter altmap is NULL, while it used devres_alloc_node to allocate a
page_map and that page_map contained a altmap instance, not pointer.
Then the addr range were inserted into pgmap_radix with value of
page_map. Why later in __add_pages, to_vmem_altmap() return NULL
according to my debugging code?

Thanks
Baoquan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
