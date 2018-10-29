Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D540621184E80
 for <linux-nvdimm@lists.01.org>; Mon, 29 Oct 2018 12:59:12 -0700 (PDT)
Message-ID: <3281f3044fa231bbc1b02d5c5efca3502a0d05a8.camel@linux.intel.com>
Subject: Re: [PATCH v5 4/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Mon, 29 Oct 2018 12:59:11 -0700
In-Reply-To: <20181029181827.GO32673@dhcp22.suse.cz>
References: <20181011085509.GS5873@dhcp22.suse.cz>
 <6f32f23c-c21c-9d42-7dda-a1d18613cd3c@linux.intel.com>
 <20181017075257.GF18839@dhcp22.suse.cz>
 <971729e6-bcfe-a386-361b-d662951e69a7@linux.intel.com>
 <20181029141210.GJ32673@dhcp22.suse.cz>
 <84f09883c16608ddd2ba88103f43ec6a1c649e97.camel@linux.intel.com>
 <20181029163528.GL32673@dhcp22.suse.cz>
 <18dfc5a0db11650ff31433311da32c95e19944d9.camel@linux.intel.com>
 <20181029172415.GM32673@dhcp22.suse.cz>
 <8e7a4311a240b241822945c0bb4095c9ffe5a14d.camel@linux.intel.com>
 <20181029181827.GO32673@dhcp22.suse.cz>
Mime-Version: 1.0
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
To: Michal Hocko <mhocko@kernel.org>
Cc: Pasha Tatashin <pavel.tatashin@microsoft.com>, osalvador@techadventures.net, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux MM <linux-mm@kvack.org>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, rppt@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-10-29 at 19:18 +0100, Michal Hocko wrote:
> On Mon 29-10-18 10:42:33, Alexander Duyck wrote:
> > On Mon, 2018-10-29 at 18:24 +0100, Michal Hocko wrote:
> > > On Mon 29-10-18 10:01:28, Alexander Duyck wrote:
> 
> [...]
> > > > So there end up being a few different issues with constructors. First
> > > > in my mind is that it means we have to initialize the region of memory
> > > > and cannot assume what the constructors are going to do for us. As a
> > > > result we will have to initialize the LRU pointers, and then overwrite
> > > > them with the pgmap and hmm_data.
> > > 
> > > Why we would do that? What does really prevent you from making a fully
> > > customized constructor?
> > 
> > It is more an argument of complexity. Do I just pass a single pointer
> > and write that value, or the LRU values in init, or do I have to pass a
> > function pointer, some abstracted data, and then call said function
> > pointer while passing the page and the abstracted data?
> 
> I though you have said that pgmap is the current common denominator for
> zone device users. I really do not see what is the problem to do
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 89d2a2ab3fe6..9105a4ed2c96 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5516,7 +5516,10 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
>  
>  not_early:
>  		page = pfn_to_page(pfn);
> -		__init_single_page(page, pfn, zone, nid);
> +		if (pgmap && pgmap->init_page)
> +			pgmap->init_page(page, pfn, zone, nid, pgmap);
> +		else
> +			__init_single_page(page, pfn, zone, nid);
>  		if (context == MEMMAP_HOTPLUG)
>  			SetPageReserved(page);
>  
> that would require to replace altmap throughout the call chain and
> replace it by pgmap. Altmap could be then renamed to something more
> clear

So as I had pointed out earlier doing per-page init is much slower than
initializing pages in bulk. Ideally I would like to see us seperate the
memmap_init_zone function into two pieces, one section for handling
hotplug and another for the everything else case. As is the fact that
you have to jump over a bunch of tests for the "not_early" case is
quite ugly in my opinion.

I could probably take your patch and test it. I'm suspecting this is
going to be a signficant slow-down in general as the indirect function
pointer stuff is probably going to come into play.

The "init_page" function in this case is going to end up being much
more complex then it really needs to be in this design as well since I
have to get the altmap and figure out if the page was used for vmmemmap
storage or is an actual DAX page. I might just see if I could add an
additional test for the pfn being before the end of the vmmemmap in the
case of pgmap being present.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 89d2a2ab3fe6..048e4cc72fdf 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5474,8 +5474,8 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
>  	 * Honor reservation requested by the driver for this ZONE_DEVICE
>  	 * memory
>  	 */
> -	if (altmap && start_pfn == altmap->base_pfn)
> -		start_pfn += altmap->reserve;
> +	if (pgmap && pgmap->get_memmap)
> +		start_pfn = pgmap->get_memmap(pgmap, start_pfn);
>  
>  	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
>  		/*
> 
> [...]

The only reason why I hadn't bothered with these bits is that I was
actually trying to leave this generic since I thought I had seen other
discussions about hotplug scenerios where memory may want to change
where the vmmemmap is initialized other than just the case of
ZONE_DEVICE pages. So I was thinking at some point we may see altmap
without the pgmap.

> > If I have to implement the code to verify the slowdown I will, but I
> > really feel like it is just going to be time wasted since we have seen
> > this in other spots within the kernel.
> 
> Please try to understand that I am not trying to force you write some
> artificial benchmarks. All I really do care about is that we have sane
> interfaces with reasonable performance. Especially for one-off things
> in relattively slow paths. I fully recognize that ZONE_DEVICE begs for a
> better integration but really, try to go incremental and try to unify
> the code first and microptimize on top. Is that way too much to ask for?

No, but the patches I had already proposed I thought were heading in
that direction. I had unified memmap_init_zone,
memmap_init_zone_device, and the deferred page initialization onto a
small set of functions and all had improved performance as a result.

> Anyway we have gone into details while the primary problem here was that
> the hotplug lock doesn't scale AFAIR. And my question was why cannot we
> pull move_pfn_range_to_zone and what has to be done to achieve that.
> That is a fundamental thing to address first. Then you can microptimize
> on top.

Yes, the hotplug lock was part of the original issue. However that
starts to drift into the area I believe Oscar was working on as a part
of his patch set in encapsulating the move_pfn_range_to_zone and other
calls that were contained in the hotplug lock into their own functions.

Most of the changes I have in my follow-on patch set can work
regardless of how we deal with the lock issue. I just feel like what
you are pushing for is going to be a massive patch set by the time we
are done and I really need to be able to work this a piece at a time. 

The patches Andrew pushed addressed the immediate issue so that now
systems with nvdimm/DAX memory can at least initialize quick enough
that systemd doesn't refuse to mount the root file system due to a
timeout. The next patch set I have refactors things to reduce code and
allow us to reuse some of the hotplug code for the deferred page init, 
https://lore.kernel.org/lkml/20181017235043.17213.92459.stgit@localhost.localdomain/
. After that I was planning to work on dealing with the PageReserved
flag and trying to get that sorted out.

I was hoping to wait until after Dan's HMM patches and Oscar's changes
had been sorted before I get into any further refactor of this specific
code.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
