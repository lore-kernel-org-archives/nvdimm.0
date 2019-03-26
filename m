Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 32B29211EB296
 for <linux-nvdimm@lists.01.org>; Tue, 26 Mar 2019 01:04:11 -0700 (PDT)
Date: Tue, 26 Mar 2019 09:04:08 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 00/10] mm: Sub-section memory hotplug support
Message-ID: <20190326080408.GC28406@dhcp22.suse.cz>
References: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190322180532.GM32418@dhcp22.suse.cz>
 <CAPcyv4gBGNP95APYaBcsocEa50tQj9b5h__83vgngjq3ouGX_Q@mail.gmail.com>
 <20190325101945.GD9924@dhcp22.suse.cz>
 <CAPcyv4iJCgu-akJM_O8ZtscqWQt=CU-fvx-ViGYeau-NJufmSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iJCgu-akJM_O8ZtscqWQt=CU-fvx-ViGYeau-NJufmSQ@mail.gmail.com>
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

On Mon 25-03-19 13:03:47, Dan Williams wrote:
> On Mon, Mar 25, 2019 at 3:20 AM Michal Hocko <mhocko@kernel.org> wrote:
[...]
> > > User-defined memory namespaces have this problem, but 2MB is the
> > > default alignment and is sufficient for most uses.
> >
> > What does prevent users to go and use a larger alignment?
> 
> Given that we are living with 64MB granularity on mainstream platforms
> for the foreseeable future, the reason users can't rely on a larger
> alignment to address the issue is that the physical alignment may
> change from one boot to the next.

I would love to learn more about this inter boot volatility. Could you
expand on that some more? I though that the HW configuration presented
to the OS would be more or less stable unless the underlying HW changes.

> No, you can't just wish hardware / platform firmware won't do this,
> because there are not enough platform resources to give every hardware
> device a guaranteed alignment.

Guarantee is one part and I can see how nobody wants to give you
something as strong but how often does that happen in the real life?

> The effect is that even if the driver deploys a software alignment
> mitigation when it first sees the persistent memory range, that
> alignment can be violated on a subsequent boot leading to data being
> unavailable. There is no facility to communicate to the administrator
> what went wrong in this scenario as several events can trigger a
> physical map layout change. Add / remove of hardware and hardware
> failure are the most likely causes.

This is indeed bad and unexpected! That is exactly something to have in
the chagelog!

> An additional pain point for users is that EFI pre-boot environment
> has little chance to create a namespace that Linux might be able to
> use. The section size is an arbitrary Linux constraint and we should
> not encode something Linux specific that might change in the future
> into OS agnostic software.

This looks like a fair point but please keep in mind that there hotplug
restrictions are on other platforms as well (4MB on Windows IIRC) so
there will be some knowledge required all the time. Besides that there
are likely to be some restrictions depending on the implementation.

[...]
> > > Right, as stated in the cover letter, this does not remove all those
> > > assumptions, it only removes the ones that impact
> > > devm_memremap_pages(). Specifying that sub-section is only supported
> > > in the 'want_memblock=false' case to arch_add_memory().
> >
> > And this is exactly the problem. Having different assumptions depending
> > on whether there is a memblock interface or not is utterly wrong and a
> > maintainability mess.
> 
> In this case I disagree with you. The hotplug code already has the
> want_memblock=false semantic in the implementation.

want_memblock was a hack to allow memory hotplug to not have user
visible sysfs interface. It was added to reduce the code duplication
IIRC. Besides that this hasn't changed the underlying assumptions about
hotplugable units or other invariants that were in place.

> The sub-section
> hotplug infrastructure is a strict superset of what is there already.
> Now, if it created parallel infrastructure that would indeed be a
> maintainability burden, but in this case there are no behavior changes
> for typical memory hotplug as it just hotplugs full sections at a time
> like always. The 'section' concept is not going away.

You are really neglecting many details here. E.g. memory section can be
shared between two different types of memory. We've had some bugs in the
hotplug code when one section can be shared between two different NUMA
nodes (e.g. 4aa9fc2a435a ("Revert "mm, memory_hotplug: initialize struct
pages for the full memory section""). We do not allow to hotremove such
sections because it would open another can of worms. I am not saying
your implementation is incorrect - still haven't time to look deeply -
but stating that this is a strict superset of want_memblock is simply
wrong.
 
[...]
> > Why do we have to go a mile to tweak the kernel, especially something as
> > fragile as memory hotplug, just to support sub mem section ranges. This
> > is somthing that is not clearly explained in the cover letter. Sure you
> > are talking about hacks at the higher level to deal with this but I do
> > not see any fundamental reason to actually support that at all.
> 
> Like it or not, 'struct page' mappings for arbitrary hardware-physical
> memory ranges is a facility that has grown from the pmem case, to hmm,
> and peer-to-peer DMA. Unless you want to do the work to eliminate the
> 'struct page' requirement across the kernel I think it is unreasonable
> to effectively archive the arch_add_memory() implementation and
> prevent it from reacting to growing demands.

I am definitely not blocking memory hotplug to be reused more! All I am
saying is that there is much more ground work to be done before you can
add features like that. There are some general assumptions in the code,
like it or not, and you should start by removing those to build on top.
Pmem/nvidimm development is full of "we have to do it now and find a way
to graft it into the existing infrastructure" pattern that I really
hate. Clean up will come later, I have heard. Have a look at all
zone_device hacks that remained. Why is this any different?

And just to make myself clear. There are places where section cannot go
away because that is the unit in which the memory model maintains struct
pages. But the hotplug code is fill of construct where we iterate mem
sections as one unit and operate on it as whole. Those have to go away
before you can consider subsection hotadd/remove.

> > I can feel your frustration. I am not entirely happy about the section
> > size limitation myself but you have to realize that this is simplicy vs.
> > feature set compromise.
> 
> You have to realize that arch_add_memory() is no longer just a
> front-end for typical memory hotplug. The requirements have changed.
> Simplicity should be maintained for as long as it can get the job
> done, and the simplicity is currently failing.

I do agree. But you also have to realize that this require a lot of
work. As long as users of the api are not willing to do that work then
I am afraid but the facility will remain dumb. But putting hacks to make
a specific usecase (almost)work is not the right way.
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
