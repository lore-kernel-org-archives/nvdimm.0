Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH v5 00/10] mm: Sub-section memory hotplug support
References: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190322180532.GM32418@dhcp22.suse.cz>
 <CAPcyv4gBGNP95APYaBcsocEa50tQj9b5h__83vgngjq3ouGX_Q@mail.gmail.com>
 <20190325101945.GD9924@dhcp22.suse.cz>
 <CAPcyv4iJCgu-akJM_O8ZtscqWQt=CU-fvx-ViGYeau-NJufmSQ@mail.gmail.com>
 <20190326080408.GC28406@dhcp22.suse.cz>
 <CAPcyv4jUeUPwbfToWQtWX1AxfgFLNpBUhm8BvgJ2Hv1RbNPiog@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <89ee9efc-868a-7f08-79e3-60454ecd3089@redhat.com>
Date: Mon, 1 Apr 2019 11:18:11 +0200
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jUeUPwbfToWQtWX1AxfgFLNpBUhm8BvgJ2Hv1RbNPiog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Logan Gunthorpe <logang@deltatee.com>, Toshi Kani <toshi.kani@hpe.com>, Jeff Moyer <jmoyer@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 27.03.19 01:20, Dan Williams wrote:
> On Tue, Mar 26, 2019 at 1:04 AM Michal Hocko <mhocko@kernel.org> wrote:
>>
>> On Mon 25-03-19 13:03:47, Dan Williams wrote:
>>> On Mon, Mar 25, 2019 at 3:20 AM Michal Hocko <mhocko@kernel.org> wrote:
>> [...]
>>>>> User-defined memory namespaces have this problem, but 2MB is the
>>>>> default alignment and is sufficient for most uses.
>>>>
>>>> What does prevent users to go and use a larger alignment?
>>>
>>> Given that we are living with 64MB granularity on mainstream platforms
>>> for the foreseeable future, the reason users can't rely on a larger
>>> alignment to address the issue is that the physical alignment may
>>> change from one boot to the next.
>>
>> I would love to learn more about this inter boot volatility. Could you
>> expand on that some more? I though that the HW configuration presented
>> to the OS would be more or less stable unless the underlying HW changes.
> 
> Even if the configuration is static there can be hardware failures
> that prevent a DIMM, or a PCI device to be included in the memory map.
> When that happens the BIOS needs to re-layout the map and the result
> is not guaranteed to maintain the previous alignment.
> 
>>> No, you can't just wish hardware / platform firmware won't do this,
>>> because there are not enough platform resources to give every hardware
>>> device a guaranteed alignment.
>>
>> Guarantee is one part and I can see how nobody wants to give you
>> something as strong but how often does that happen in the real life?
> 
> I expect a "rare" event to happen everyday in a data-center fleet.
> Failure rates tend towards 100% daily occurrence at scale and in this
> case the kernel has everything it needs to mitigate such an event.
> 
> Setting aside the success rate of a software-alignment mitigation, the
> reason I am charging this hill again after a 2 year hiatus is the
> realization that this problem is wider spread than the original
> failing scenario. Back in 2017 the problem seemed limited to custom
> memmap= configurations, and collisions between PMEM and System RAM.
> Now it is clear that the collisions can happen between PMEM regions
> and namespaces as well, and the problem spans platforms from multiple
> vendors. Here is the most recent collision problem:
> https://github.com/pmem/ndctl/issues/76, from a third-party platform.
> 
> The fix for that issue uncovered a bug in the padding implementation,
> and a fix for that bug would result in even more hacks in the nvdimm
> code for what is a core kernel deficiency. Code review of those
> changes resulted in changing direction to go after the core
> deficiency.
> 
>>> The effect is that even if the driver deploys a software alignment
>>> mitigation when it first sees the persistent memory range, that
>>> alignment can be violated on a subsequent boot leading to data being
>>> unavailable. There is no facility to communicate to the administrator
>>> what went wrong in this scenario as several events can trigger a
>>> physical map layout change. Add / remove of hardware and hardware
>>> failure are the most likely causes.
>>
>> This is indeed bad and unexpected! That is exactly something to have in
>> the chagelog!
> 
> Apologies that was indeed included in the 2017 changelog (see: "a user
> could inadvertently lose access to nvdimm namespaces" note here:
> https://lwn.net/Articles/717383/), and I failed to carry it forward.
> 
>>
>>> An additional pain point for users is that EFI pre-boot environment
>>> has little chance to create a namespace that Linux might be able to
>>> use. The section size is an arbitrary Linux constraint and we should
>>> not encode something Linux specific that might change in the future
>>> into OS agnostic software.
>>
>> This looks like a fair point but please keep in mind that there hotplug
>> restrictions are on other platforms as well (4MB on Windows IIRC) so
>> there will be some knowledge required all the time. Besides that there
>> are likely to be some restrictions depending on the implementation.
> 
> Windows does not have an equivalent constraint, so it's only Linux
> that imposes an arbitrary alignment restriction on pmem to agents like
> EFI.
> 
>> [...]
>>>>> Right, as stated in the cover letter, this does not remove all those
>>>>> assumptions, it only removes the ones that impact
>>>>> devm_memremap_pages(). Specifying that sub-section is only supported
>>>>> in the 'want_memblock=false' case to arch_add_memory().
>>>>
>>>> And this is exactly the problem. Having different assumptions depending
>>>> on whether there is a memblock interface or not is utterly wrong and a
>>>> maintainability mess.
>>>
>>> In this case I disagree with you. The hotplug code already has the
>>> want_memblock=false semantic in the implementation.
>>
>> want_memblock was a hack to allow memory hotplug to not have user
>> visible sysfs interface. It was added to reduce the code duplication
>> IIRC. Besides that this hasn't changed the underlying assumptions about
>> hotplugable units or other invariants that were in place.
> 
> Neither does this patch series for the typical memory hotplug case.
> For the device-memory use case I've gone through and fixed up the
> underlying assumptions.
> 
>>> The sub-section
>>> hotplug infrastructure is a strict superset of what is there already.
>>> Now, if it created parallel infrastructure that would indeed be a
>>> maintainability burden, but in this case there are no behavior changes
>>> for typical memory hotplug as it just hotplugs full sections at a time
>>> like always. The 'section' concept is not going away.
>>
>> You are really neglecting many details here. E.g. memory section can be
>> shared between two different types of memory. We've had some bugs in the
>> hotplug code when one section can be shared between two different NUMA
>> nodes (e.g. 4aa9fc2a435a ("Revert "mm, memory_hotplug: initialize struct
>> pages for the full memory section""). We do not allow to hotremove such
>> sections because it would open another can of worms. I am not saying
>> your implementation is incorrect - still haven't time to look deeply -
>> but stating that this is a strict superset of want_memblock is simply
>> wrong.
> 
> Please have a look at the code and the handling of "early" sections.
> The assertion that I neglected to consider that detail is not true.
> 
> My "superset" contention is from the arch_add_memory() api
> perspective. All typical memory hotplug use cases are a sub-case of
> the new support.
> 
>> [...]
>>>> Why do we have to go a mile to tweak the kernel, especially something as
>>>> fragile as memory hotplug, just to support sub mem section ranges. This
>>>> is somthing that is not clearly explained in the cover letter. Sure you
>>>> are talking about hacks at the higher level to deal with this but I do
>>>> not see any fundamental reason to actually support that at all.
>>>
>>> Like it or not, 'struct page' mappings for arbitrary hardware-physical
>>> memory ranges is a facility that has grown from the pmem case, to hmm,
>>> and peer-to-peer DMA. Unless you want to do the work to eliminate the
>>> 'struct page' requirement across the kernel I think it is unreasonable
>>> to effectively archive the arch_add_memory() implementation and
>>> prevent it from reacting to growing demands.
>>
>> I am definitely not blocking memory hotplug to be reused more! All I am
>> saying is that there is much more ground work to be done before you can
>> add features like that. There are some general assumptions in the code,
>> like it or not, and you should start by removing those to build on top.
> 
> Let's talk about specifics please, because I don't think you've had a
> chance to consider the details in the patches. Your "start by removing
> those [assumptions] to build on top" request is indeed what the
> preparation patches in this series aim to achieve.
> 
> The general assumptions of the current (pre-patch-series) implementation are:
> 
> - Sections that describe boot memory (early sections) are never
> unplugged / removed.

I m not sure if this is completely true, and it also recently popped up
while discussing some work Oscar is doing ("[PATCH 0/4]
mm,memory_hotplug: allocate memmap from hotadded memory").

We have powernv (arch/powerpc/platforms/powernv/memtrace.c), that will
offline + remove memory from the system that it didn't originally add.
As far as I understand, this can easily be boot memory. Not sure if
there is anything blocking this code from removing boot memory.

Also, ACPI memory hotplug (drivers/acpi/acpi_memhotplug.c) seems to have
a case where memory provided by a DIMM is already used by the kernel (I
assume this means, it was detected and added during boot). This memory
can theoretically be removed. I am still to figure out how that special
case here fits into the big picture.

> 
> - pfn_valid(), in the CONFIG_SPARSEMEM_VMEMMAP=y, case devolves to a
> valid_section() check
> 
> - __add_pages() and helper routines assume all operations occur in
> PAGES_PER_SECTION units.
> 
> - the memblock sysfs interface only comprehends full sections
> 
> Those assumptions are removed / handled with the following
> implementation details respectively:
> 
> - Partially populated early sections can be extended with additional
> sub-sections, and those sub-sections can be removed with
> arch_remove_memory(). With this in place we no longer lose usable
> memory capacity to padding.
> 
> - pfn_valid() goes beyond valid_section() to also check the
> active-sub-section mask. As stated before this indication is in the
> same cacheline as the valid_section() so the performance impact is
> expected to be negligible. So far the lkp robot has not reported any
> regressions.
> 
> - Outside of the core vmemmap population routines which are replaced,
> other helper routines like shrink_{zone,pgdat}_span() are updated to
> handle the smaller granularity. Core memory hotplug routines that deal
> with online memory are not updated. That's a feature not a bug until
> we decide that sub-section hotplug makes sense for online / typical
> memory as well.
> 
> - the existing memblock sysfs user api guarantees / assumptions are
> not touched since this capability is limited to !online
> !sysfs-accessible sections for now.

So to expand on that, the main difference of RAM hotplug to device
memory hotplug is that

- Memory has to be onlined/offlined. Sections are marked as being either
online or offline. Not relevant for device memory. Onlining/offlining
imples working on the buddy / core MM.

- Memory is exposed and managed via memblock sysfs API. memblocks are
multiples of sections. The RAM hotplug granularity really is the size of
memblocks. E.g. kdump uses memblock sysfs events to reaload when new
memory is added/onlined. Onlining controlled by userspace works on
memblocks getting added. Other users heavily use the memblock API.

So I think the hotplug granularity of RAM really is memblocks (actually
sections). Changing that might be very complicated, will break APIs and
has a questionable benefit.

I am starting to wonder if RAM (memdev) really is the special case and
what you are proposing is the right thing to do for everything that
- doesn't use memdev sysfs interface
- doesn't require to online memory (sections)

So, it boils down to memblock=true is the special case. We would have to
make sure that memblock=true cannot be mixed with memblock=false on the
same sections (or even memory blocks)

(not having had a detailed look at the patches yet) Michal, what do you
think?

-- 

Thanks,

David / dhildenb
