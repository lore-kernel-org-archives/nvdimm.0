Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A75572125ADC5
 for <linux-nvdimm@lists.01.org>; Mon, 24 Jun 2019 10:54:33 -0700 (PDT)
Message-ID: <1561398869.3073.4.camel@suse.de>
Subject: Re: [PATCH v10 02/13] mm/sparsemem: Introduce a SECTION_IS_EARLY flag
From: Oscar Salvador <osalvador@suse.de>
Date: Mon, 24 Jun 2019 19:54:29 +0200
In-Reply-To: <156092350358.979959.5817209875548072819.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156092349300.979959.17603710711957735135.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156092350358.979959.5817209875548072819.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: Michal Hocko <mhocko@suse.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, David Hildenbrand <david@redhat.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Qian Cai <cai@lca.pw>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2019-06-18 at 22:51 -0700, Dan Williams wrote:
> In preparation for sub-section hotplug, track whether a given section
> was created during early memory initialization, or later via memory
> hotplug.  This distinction is needed to maintain the coarse
> expectation
> that pfn_valid() returns true for any pfn within a given section even
> if
> that section has pages that are reserved from the page allocator.
> 
> For example one of the of goals of subsection hotplug is to support
> cases where the system physical memory layout collides System RAM and
> PMEM within a section. Several pfn_valid() users expect to just check
> if
> a section is valid, but they are not careful to check if the given
> pfn
> is within a "System RAM" boundary and instead expect pgdat
> information
> to further validate the pfn.
> 
> Rather than unwind those paths to make their pfn_valid() queries more
> precise a follow on patch uses the SECTION_IS_EARLY flag to maintain
> the
> traditional expectation that pfn_valid() returns true for all early
> sections.
> 
> Link: https://lore.kernel.org/lkml/1560366952-10660-1-git-send-email-
> cai@lca.pw/
> Reported-by: Qian Cai <cai@lca.pw>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

[...]
> @@ -731,7 +732,7 @@ int __meminit sparse_add_one_section(int nid,
> unsigned long start_pfn,
>  	page_init_poison(memmap, sizeof(struct page) *
> PAGES_PER_SECTION);
>  
>  	section_mark_present(ms);
> -	sparse_init_one_section(ms, section_nr, memmap, usage);
> +	sparse_init_one_section(ms, section_nr, memmap, usage, 0);

I think this is an improvment, and I really like the idea of leveraring
a new section's flag for this, but I have mixed feelings about the way
to mark a section as an early one.
IMHO, I think that a new "section_mark_early" function would be better
than passing a new flag parameter to sparse_init_one_section().

But I do not feel strong on this:

Reviewed-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE L3
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
