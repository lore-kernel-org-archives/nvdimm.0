Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA41E211EB835
 for <linux-nvdimm@lists.01.org>; Wed, 10 Apr 2019 02:52:01 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] mm: Sub-section memory hotplug support
References: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <91856fac-c624-fcef-4c58-547a216d370b@redhat.com>
Date: Wed, 10 Apr 2019 11:51:57 +0200
MIME-Version: 1.0
In-Reply-To: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On 22.03.19 17:57, Dan Williams wrote:
> Changes since v4 [1]:
> - Given v4 was from March of 2017 the bulk of the changes result from
>   rebasing the patch set from a v4.11-rc2 baseline to v5.1-rc1.
> 
> - A unit test is added to ndctl to exercise the creation and dax
>   mounting of multiple independent namespaces in a single 128M section.
> 
> [1]: https://lwn.net/Articles/717383/
> 
> ---
> 
> Quote patch7:
> 
> "The libnvdimm sub-system has suffered a series of hacks and broken
>  workarounds for the memory-hotplug implementation's awkward
>  section-aligned (128MB) granularity. For example the following backtrace
>  is emitted when attempting arch_add_memory() with physical address
>  ranges that intersect 'System RAM' (RAM) with 'Persistent Memory' (PMEM)
>  within a given section:
>  
>   WARNING: CPU: 0 PID: 558 at kernel/memremap.c:300 devm_memremap_pages+0x3b5/0x4c0
>   devm_memremap_pages attempted on mixed region [mem 0x200000000-0x2fbffffff flags 0x200]
>   [..]
>   Call Trace:
>     dump_stack+0x86/0xc3
>     __warn+0xcb/0xf0
>     warn_slowpath_fmt+0x5f/0x80
>     devm_memremap_pages+0x3b5/0x4c0
>     __wrap_devm_memremap_pages+0x58/0x70 [nfit_test_iomap]
>     pmem_attach_disk+0x19a/0x440 [nd_pmem]
>  
>  Recently it was discovered that the problem goes beyond RAM vs PMEM
>  collisions as some platform produce PMEM vs PMEM collisions within a
>  given section. The libnvdimm workaround for that case revealed that the
>  libnvdimm section-alignment-padding implementation has been broken for a
>  long while. A fix for that long-standing breakage introduces as many
>  problems as it solves as it would require a backward-incompatible change
>  to the namespace metadata interpretation. Instead of that dubious route
>  [2], address the root problem in the memory-hotplug implementation."
> 
> The approach is taken is to observe that each section already maintains
> an array of 'unsigned long' values to hold the pageblock_flags. A single
> additional 'unsigned long' is added to house a 'sub-section active'
> bitmask. Each bit tracks the mapped state of one sub-section's worth of
> capacity which is SECTION_SIZE / BITS_PER_LONG, or 2MB on x86-64.
> 
> The implication of allowing sections to be piecemeal mapped/unmapped is
> that the valid_section() helper is no longer authoritative to determine
> if a section is fully mapped. Instead pfn_valid() is updated to consult
> the section-active bitmask. Given that typical memory hotplug still has
> deep "section" dependencies the sub-section capability is limited to
> 'want_memblock=false' invocations of arch_add_memory(), effectively only
> devm_memremap_pages() users for now.
> 
> With this in place the hacks in the libnvdimm sub-system can be
> dropped, and other devm_memremap_pages() users need no longer be
> constrained to 128MB mapping granularity.
> 
> [2]: https://lore.kernel.org/r/155000671719.348031.2347363160141119237.stgit@dwillia2-desk3.amr.corp.intel.com
> 

I started to explore the wonderful world of system ram memory hotplug
(memory block devices) and it is full with issues. Too many to name them
all, but two example are memory block devices that span several nodes
(such memory can only be added during boot, mem->nid would be completely
misleading) or that we assume struct pages have been initialized, while
they really haven't when removing memory.

It is already a mess that we have multiple sections per memory block
devices (and it was never properly cleaned up and I think I spotted
several issues). Going into the direction of sub-sections for memory
block devices, I don't like. It is already a big mess.

Memory block devices are an important concept for memory hotplug/unplug.
This is the granularity memory will get onlined/offlined by user space.
I don't see this interface going away. On the other hand, memory block
devices only make sense for memory to be onlined/offlined in such
chunks, system ram. So whatever ZONE_DEVICE memory doesn't run into that
restriction.

I think we should restrict adding/removing system ram via
online_pages()/offline_pages()/add_memory()/remove_memory() to
- memory block device granularity (already mostly checked)
- single zones (already mostly checked)
- single nodes (basically not checked as far as I can see)

Cleaning this mess up might take some time. Essentially, all special
handling related to memory block devices should be factored out from
arch_add_memory()/arch_remove_memory() to add_memory()/remove_memory().
I started looking into that. __add_pages() doesn't properly revert what
it already did when failing.

I don't have a strong opinion against adding sub-section memory hotadd
as long as we don't use it for memory block devices hotplug. Meaning,
use it internally, but don't use it along with memory block device hotplug.

As add_memory() only works on memory block device granularity, memory
block devices for something like that is not an issue. The real issue is
memory added during boot that e.g. has holes or overlaps with pmem and
friends. Trying to offline/online/remove such memory should be
completely blocked.

To easily detect multiple nodes per memory block devices, I am thinking
about making mem->nid indicated that. E.g. nid == -1, uninitialized, nid
== -2, mixed nodes, don't allow to offline/remove such memory. Might
require some refactorings.

The question is how we could easily detect
- memory block devices with some sub-sections missing. Offlining code
forbids this right now as the holes are marked as PG_reserved.
- memory block devices with some sub-sections being ZONE_DEVICE memory
like pmem.

Both cases could only happen when memory was added during boot.
Offlining/removing such memory has to be forbidden.

-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
