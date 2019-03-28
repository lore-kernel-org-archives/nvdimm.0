Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1735D21168208
 for <linux-nvdimm@lists.01.org>; Thu, 28 Mar 2019 14:17:21 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] mm: Sub-section memory hotplug support
References: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
 <cf304a31-70a6-e701-ec3e-c47dc84b81d2@redhat.com>
 <CAPcyv4hgAM=ex0B4EBZ40RNf=bXk2WkEzySTUV4ZzOWd_HZwSQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <24c163f2-3b78-827f-257e-70e5a9655806@redhat.com>
Date: Thu, 28 Mar 2019 22:17:15 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hgAM=ex0B4EBZ40RNf=bXk2WkEzySTUV4ZzOWd_HZwSQ@mail.gmail.com>
Content-Language: en-US
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
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, stable <stable@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

>> You are using the term "Sub-section memory hotplug support", but is it
>> actually what you mean? To rephrase, aren't we talking here about
>> "Sub-section device memory hotplug support" or similar?
> 
> Specifically it is support for passing @start and @size arguments to
> arch_add_memory() that are not section aligned. It's not limited to
> "device memory" which is otherwise not a concept that
> arch_add_memory() understands, it just groks spans of pfns.

Okay, so everything that does not have a memory block devices as of now.

> 
>> Reason I am asking is because I wonder how that would interact with the
>> memory block device infrastructure and hotplugging of system ram -
>> add_memory()/add_memory_resource(). I *assume* you are not changing the
>> add_memory() interface, so that one still only works with whole sections
>> (or well, memory_block_size_bytes()) - check_hotplug_memory_range().
> 
> Like you found below, the implementation enforces that add_memory_*()
> interfaces maintain section alignment for @start and @size.
> 
>> In general, mix and matching system RAM and persistent memory per
>> section, I am not a friend of that.
> 
> You have no choice. The platform may decide to map PMEM and System RAM
> in the same section because the Linux section is too large compared to
> typical memory controller mapping granularity capability.

I might be very wrong here, but do we actually care about something like
64MB getting lost in the cracks? I mean if it simplifies core MM, let go
of the couple of MB of system ram and handle the PMEM part only. Treat
the system ram parts like memory holes we already have in ordinary
sections (well, there we simply set the relevant struct pages to
PG_reserved). Of course, if we have hundreds of unaligned devices and
stuff will start to add up ... but I assume this is not the case?

> 
>> Especially when it comes to memory
>> block devices. But I am getting the feeling that we are rather targeting
>> PMEM vs. PMEM with this patch series.
> 
> The collisions are between System RAM, PMEM regions, and PMEM
> namespaces (sub-divisions of regions that each need their own mapping
> lifetime).

Understood. I wonder if that PMEM only mapping (including separate
lifetime) could be handled differently. But I am absolutely no expert,
just curious.

> 
>>> Quote patch7:
>>>
>>> "The libnvdimm sub-system has suffered a series of hacks and broken
>>>  workarounds for the memory-hotplug implementation's awkward
>>>  section-aligned (128MB) granularity. For example the following backtrace
>>>  is emitted when attempting arch_add_memory() with physical address
>>>  ranges that intersect 'System RAM' (RAM) with 'Persistent Memory' (PMEM)
>>>  within a given section:
>>>
>>>   WARNING: CPU: 0 PID: 558 at kernel/memremap.c:300 devm_memremap_pages+0x3b5/0x4c0
>>>   devm_memremap_pages attempted on mixed region [mem 0x200000000-0x2fbffffff flags 0x200]
>>>   [..]
>>>   Call Trace:
>>>     dump_stack+0x86/0xc3
>>>     __warn+0xcb/0xf0
>>>     warn_slowpath_fmt+0x5f/0x80
>>>     devm_memremap_pages+0x3b5/0x4c0
>>>     __wrap_devm_memremap_pages+0x58/0x70 [nfit_test_iomap]
>>>     pmem_attach_disk+0x19a/0x440 [nd_pmem]
>>>
>>>  Recently it was discovered that the problem goes beyond RAM vs PMEM
>>>  collisions as some platform produce PMEM vs PMEM collisions within a
>>
>> As side-noted by Michal, I wonder if PMEM vs. PMEM cannot rather be
>> implemented "on top" of what we have right now. Or is this what we
>> already have that you call "hacks in nvdimm" code? (no NVDIMM expert,
>> sorry for the stupid questions)
> 
> It doesn't work, because even if the padding was implemented 100%
> correct, which thus far has failed to be the case, the platform may
> change physical alignments from one boot to the next for a variety of
> reasons.

Would ignoring the System RAM parts (as mentioned above) help or doesn't
it make any difference in terms of complexity?

> 
>>
>>>  given section. The libnvdimm workaround for that case revealed that the
>>>  libnvdimm section-alignment-padding implementation has been broken for a
>>>  long while. A fix for that long-standing breakage introduces as many
>>>  problems as it solves as it would require a backward-incompatible change
>>>  to the namespace metadata interpretation. Instead of that dubious route
>>>  [2], address the root problem in the memory-hotplug implementation."
>>>
>>> The approach is taken is to observe that each section already maintains
>>> an array of 'unsigned long' values to hold the pageblock_flags. A single
>>> additional 'unsigned long' is added to house a 'sub-section active'
>>> bitmask. Each bit tracks the mapped state of one sub-section's worth of
>>> capacity which is SECTION_SIZE / BITS_PER_LONG, or 2MB on x86-64.
>>>
>>> The implication of allowing sections to be piecemeal mapped/unmapped is
>>> that the valid_section() helper is no longer authoritative to determine
>>> if a section is fully mapped. Instead pfn_valid() is updated to consult
>>> the section-active bitmask. Given that typical memory hotplug still has
>>> deep "section" dependencies the sub-section capability is limited to
>>> 'want_memblock=false' invocations of arch_add_memory(), effectively only
>>> devm_memremap_pages() users for now.
>>
>> Ah, there it is. And my point would be, please don't ever unlock
>> something like that for want_memblock=true. Especially not for memory
>> added after boot via device drivers (add_memory()).
> 
> I don't see a strong reason why not, as long as it does not regress
> existing use cases. It might need to be an opt-in for new tooling that
> is aware of finer granularity hotplug. That said, I have no pressing
> need to go there and just care about the arch_add_memory() capability
> for now.

Especially onlining/offlining of memory might end up very ugly. And that
goes hand in hand with memory block devices. They are either online or
offline, not something in between. (I went that path and Michal
correctly told me why it is not a good idea)

I was recently trying to teach memory block devices who their owner is /
of which type they are. Right now I am looking into the option of using
drivers. Memory block devices that could belong to different drivers at
a time are well ... totally broken. I assume it would still be a special
case, though, but conceptually speaking about the interface it would be
allowed.

Memory block devices (and therefore 1..X sections) should have one owner
only. Anything else just does not fit.

-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
