Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 26 Apr 2019 16:00:11 +0200
From: Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v6 04/12] mm/hotplug: Prepare shrink_{zone, pgdat}_span
 for sub-section removal
Message-ID: <20190426140011.GB30513@linux>
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552635609.2015392.6246305135559796835.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190426135907.GA30513@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426135907.GA30513@linux>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Logan Gunthorpe <logang@deltatee.com>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, david@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 26, 2019 at 03:59:12PM +0200, Oscar Salvador wrote:
> On Wed, Apr 17, 2019 at 11:39:16AM -0700, Dan Williams wrote:
> > @@ -417,10 +417,10 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
> >  	 * it check the zone has only hole or not.
> >  	 */
> >  	pfn = zone_start_pfn;
> > -	for (; pfn < zone_end_pfn; pfn += PAGES_PER_SECTION) {
> > +	for (; pfn < zone_end_pfn; pfn += PAGES_PER_SUB_SECTION) {
> >  		ms = __pfn_to_section(pfn);
> >  
> > -		if (unlikely(!valid_section(ms)))
> > +		if (unlikely(!pfn_valid(pfn)))
> >  			continue;
> >  
> >  		if (page_zone(pfn_to_page(pfn)) != zone)
> > @@ -485,10 +485,10 @@ static void shrink_pgdat_span(struct pglist_data *pgdat,
> >  	 * has only hole or not.
> >  	 */
> >  	pfn = pgdat_start_pfn;
> > -	for (; pfn < pgdat_end_pfn; pfn += PAGES_PER_SECTION) {
> > +	for (; pfn < pgdat_end_pfn; pfn += PAGES_PER_SUB_SECTION) {
> >  		ms = __pfn_to_section(pfn);
> >  
> > -		if (unlikely(!valid_section(ms)))
> > +		if (unlikely(!pfn_valid(pfn)))
> >  			continue;
> >  
> >  		if (pfn_to_nid(pfn) != nid)
> 
> The last loop from shrink_{pgdat,zone}_span can be reworked to unify both
> in one function, and both functions can be factored out a bit.
> Actually, I do have a patch that does that, I might dig it up.
> 
> The rest looks good:
> 
> Reviewed-by: Oscar Salvador <osalvador@suse.de>

I mean of course besides Ralph's comment.

-- 
Oscar Salvador
SUSE L3
