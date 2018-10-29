Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1670321184AD6
 for <linux-nvdimm@lists.01.org>; Mon, 29 Oct 2018 11:18:29 -0700 (PDT)
Date: Mon, 29 Oct 2018 19:18:27 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 4/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
Message-ID: <20181029181827.GO32673@dhcp22.suse.cz>
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
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8e7a4311a240b241822945c0bb4095c9ffe5a14d.camel@linux.intel.com>
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Pasha Tatashin <pavel.tatashin@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, rppt@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 29-10-18 10:42:33, Alexander Duyck wrote:
> On Mon, 2018-10-29 at 18:24 +0100, Michal Hocko wrote:
> > On Mon 29-10-18 10:01:28, Alexander Duyck wrote:
[...]
> > > So there end up being a few different issues with constructors. First
> > > in my mind is that it means we have to initialize the region of memory
> > > and cannot assume what the constructors are going to do for us. As a
> > > result we will have to initialize the LRU pointers, and then overwrite
> > > them with the pgmap and hmm_data.
> > 
> > Why we would do that? What does really prevent you from making a fully
> > customized constructor?
> 
> It is more an argument of complexity. Do I just pass a single pointer
> and write that value, or the LRU values in init, or do I have to pass a
> function pointer, some abstracted data, and then call said function
> pointer while passing the page and the abstracted data?

I though you have said that pgmap is the current common denominator for
zone device users. I really do not see what is the problem to do
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 89d2a2ab3fe6..9105a4ed2c96 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5516,7 +5516,10 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 
 not_early:
 		page = pfn_to_page(pfn);
-		__init_single_page(page, pfn, zone, nid);
+		if (pgmap && pgmap->init_page)
+			pgmap->init_page(page, pfn, zone, nid, pgmap);
+		else
+			__init_single_page(page, pfn, zone, nid);
 		if (context == MEMMAP_HOTPLUG)
 			SetPageReserved(page);
 
that would require to replace altmap throughout the call chain and
replace it by pgmap. Altmap could be then renamed to something more
clear
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 89d2a2ab3fe6..048e4cc72fdf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5474,8 +5474,8 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 	 * Honor reservation requested by the driver for this ZONE_DEVICE
 	 * memory
 	 */
-	if (altmap && start_pfn == altmap->base_pfn)
-		start_pfn += altmap->reserve;
+	if (pgmap && pgmap->get_memmap)
+		start_pfn = pgmap->get_memmap(pgmap, start_pfn);
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		/*

[...]

> If I have to implement the code to verify the slowdown I will, but I
> really feel like it is just going to be time wasted since we have seen
> this in other spots within the kernel.

Please try to understand that I am not trying to force you write some
artificial benchmarks. All I really do care about is that we have sane
interfaces with reasonable performance. Especially for one-off things
in relattively slow paths. I fully recognize that ZONE_DEVICE begs for a
better integration but really, try to go incremental and try to unify
the code first and microptimize on top. Is that way too much to ask for?

Anyway we have gone into details while the primary problem here was that
the hotplug lock doesn't scale AFAIR. And my question was why cannot we
pull move_pfn_range_to_zone and what has to be done to achieve that.
That is a fundamental thing to address first. Then you can microptimize
on top.
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
