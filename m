Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A452211EB820
 for <linux-nvdimm@lists.01.org>; Thu, 28 Mar 2019 13:10:15 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] mm: Sub-section memory hotplug support
References: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <cf304a31-70a6-e701-ec3e-c47dc84b81d2@redhat.com>
Date: Thu, 28 Mar 2019 21:10:11 +0100
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

I'm gonna have to ask some very basic questions:

You are using the term "Sub-section memory hotplug support", but is it
actually what you mean? To rephrase, aren't we talking here about
"Sub-section device memory hotplug support" or similar?

Reason I am asking is because I wonder how that would interact with the
memory block device infrastructure and hotplugging of system ram -
add_memory()/add_memory_resource(). I *assume* you are not changing the
add_memory() interface, so that one still only works with whole sections
(or well, memory_block_size_bytes()) - check_hotplug_memory_range().

In general, mix and matching system RAM and persistent memory per
section, I am not a friend of that. Especially when it comes to memory
block devices. But I am getting the feeling that we are rather targeting
PMEM vs. PMEM with this patch series.

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

As side-noted by Michal, I wonder if PMEM vs. PMEM cannot rather be
implemented "on top" of what we have right now. Or is this what we
already have that you call "hacks in nvdimm" code? (no NVDIMM expert,
sorry for the stupid questions)

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

Ah, there it is. And my point would be, please don't ever unlock
something like that for want_memblock=true. Especially not for memory
added after boot via device drivers (add_memory()).

> 
> With this in place the hacks in the libnvdimm sub-system can be
> dropped, and other devm_memremap_pages() users need no longer be
> constrained to 128MB mapping granularity.


-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
