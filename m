Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 805C0211E2EF4
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 03:19:48 -0700 (PDT)
Date: Mon, 25 Mar 2019 11:19:45 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 00/10] mm: Sub-section memory hotplug support
Message-ID: <20190325101945.GD9924@dhcp22.suse.cz>
References: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190322180532.GM32418@dhcp22.suse.cz>
 <CAPcyv4gBGNP95APYaBcsocEa50tQj9b5h__83vgngjq3ouGX_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gBGNP95APYaBcsocEa50tQj9b5h__83vgngjq3ouGX_Q@mail.gmail.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, stable <stable@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 22-03-19 11:32:11, Dan Williams wrote:
> On Fri, Mar 22, 2019 at 11:06 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Fri 22-03-19 09:57:54, Dan Williams wrote:
> > > Changes since v4 [1]:
> > > - Given v4 was from March of 2017 the bulk of the changes result from
> > >   rebasing the patch set from a v4.11-rc2 baseline to v5.1-rc1.
> > >
> > > - A unit test is added to ndctl to exercise the creation and dax
> > >   mounting of multiple independent namespaces in a single 128M section.
> > >
> > > [1]: https://lwn.net/Articles/717383/
> > >
> > > ---
> > >
> > > Quote patch7:
> > >
> > > "The libnvdimm sub-system has suffered a series of hacks and broken
> > >  workarounds for the memory-hotplug implementation's awkward
> > >  section-aligned (128MB) granularity. For example the following backtrace
> > >  is emitted when attempting arch_add_memory() with physical address
> > >  ranges that intersect 'System RAM' (RAM) with 'Persistent Memory' (PMEM)
> > >  within a given section:
> > >
> > >   WARNING: CPU: 0 PID: 558 at kernel/memremap.c:300 devm_memremap_pages+0x3b5/0x4c0
> > >   devm_memremap_pages attempted on mixed region [mem 0x200000000-0x2fbffffff flags 0x200]
> > >   [..]
> > >   Call Trace:
> > >     dump_stack+0x86/0xc3
> > >     __warn+0xcb/0xf0
> > >     warn_slowpath_fmt+0x5f/0x80
> > >     devm_memremap_pages+0x3b5/0x4c0
> > >     __wrap_devm_memremap_pages+0x58/0x70 [nfit_test_iomap]
> > >     pmem_attach_disk+0x19a/0x440 [nd_pmem]
> > >
> > >  Recently it was discovered that the problem goes beyond RAM vs PMEM
> > >  collisions as some platform produce PMEM vs PMEM collisions within a
> > >  given section. The libnvdimm workaround for that case revealed that the
> > >  libnvdimm section-alignment-padding implementation has been broken for a
> > >  long while. A fix for that long-standing breakage introduces as many
> > >  problems as it solves as it would require a backward-incompatible change
> > >  to the namespace metadata interpretation. Instead of that dubious route
> > >  [2], address the root problem in the memory-hotplug implementation."
> > >
> > > The approach is taken is to observe that each section already maintains
> > > an array of 'unsigned long' values to hold the pageblock_flags. A single
> > > additional 'unsigned long' is added to house a 'sub-section active'
> > > bitmask. Each bit tracks the mapped state of one sub-section's worth of
> > > capacity which is SECTION_SIZE / BITS_PER_LONG, or 2MB on x86-64.
> >
> > So the hotplugable unit is pageblock now, right?
> 
> No, with this patchset the hotplug unit is 2MB.

Which is a pageblock unit on x86 with hugetlb enabled. I was just
wondering whether this is really bound to pageblock or the math just
works out to be the same.

> > Why is this sufficient?
> 
> 2MB is sufficient because it allows mapping a namespace at PMD
> granularity and there is no practical need to go smaller.
> 
> > What prevents new and creative HW to come up with alignements that do not fit there?
> 
> There is a resource in hardware memory controllers called
> address-decode-registers that control the mapping granularity. The
> minimum granularity today is 64MB and the pressure as memory sizes
> increases is to make that granularity larger, not smaller. So the
> hardware pressure is going in the opposite direction of your concern,
> at least for persistent memory.

OK, this is good to know and actually against subsection direction.

> User-defined memory namespaces have this problem, but 2MB is the
> default alignment and is sufficient for most uses.

What does prevent users to go and use a larger alignment?

> PCI Address BARs that are also mapped with devm_memremap_pages are
> aligned to their size and there is no expectation to support smaller
> than 2MB.
> 
> All that said, to support a smaller sub-section granularity, just add
> more bits to the section-active bitmask.
> 
> > Do not get me wrong but the section
> > as a unit is deeply carved into the memory hotplug and removing all those
> > assumptions is a major undertaking
> 
> Right, as stated in the cover letter, this does not remove all those
> assumptions, it only removes the ones that impact
> devm_memremap_pages(). Specifying that sub-section is only supported
> in the 'want_memblock=false' case to arch_add_memory().

And this is exactly the problem. Having different assumptions depending
on whether there is a memblock interface or not is utterly wrong and a
maintainability mess.

> > and I would like to know that you are
> > not just shifting the problem to a smaller unit and a new/creative HW
> > will force us to go even more complicated.
> 
> HW will not do this to us. It's software that has the problem.
> Namespace creation is unnecessarily constrained to 128MB alignment.

And why is that a problem? A lack of documentation that this is a
requirement? Something will not work with a larger alignment? Someting
else?

Why do we have to go a mile to tweak the kernel, especially something as
fragile as memory hotplug, just to support sub mem section ranges. This
is somthing that is not clearly explained in the cover letter. Sure you
are talking about hacks at the higher level to deal with this but I do
not see any fundamental reason to actually support that at all.

> I'm also open to exploring lifting the section alignment constraint
> for the 'want_memblock=true', but first things first.

I disagree. If you want to get rid of the the section requirement then
do it first and build on top. This is a normal kernel development
process.

> > What is the fundamental reason that pmem sections cannot be assigned
> > to a section aligned memory range? The physical address space is
> > quite large to impose 128MB sections IMHO. I thought this is merely a
> > configuration issue.
> 
> 1) it's not just hardware that imposes this, software wants to be able
> to avoid the constraint
> 
> 2) the flexibility of the memory controller initialization code is
> constrained by address-decode-registers. So while it is simple to say
> "just configure it to be aligned" it's not that easy in practice
> without throwing away usable memory capacity.

Yes and we are talking about 128MB is sacrifying that unit worth all the
troubles?

[...]

> > I will probably have much more question, but it's friday and I am mostly
> > offline already. I would just like to hear much more about the new
> > design and resulting assumptions.
> 
> Happy to accommodate this discussion. The section alignment has been
> an absolute horror to contend with. So I have years worth of pain to
> share for as deep as you want to go on probing why this is needed.

I can feel your frustration. I am not entirely happy about the section
size limitation myself but you have to realize that this is simplicy vs.
feature set compromise. It works reasonably well for many usecases but
falls flat on some others. But you cannot simply build on top of
existing foundations and tweak some code paths to handle one particular
case. This is exactly how the memory hotplug ended in the unfortunate
state it is now. If you want to make the code more reusable then there
is a _lot_ of ground work first before you can add a shiny new feature.
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
