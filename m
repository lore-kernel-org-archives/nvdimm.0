Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from hqemgate15.nvidia.com (hqemgate15.nvidia.com [216.228.121.64])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD32B2194EB7F
 for <linux-nvdimm@lists.01.org>; Fri, 19 Apr 2019 16:09:52 -0700 (PDT)
Subject: Re: [PATCH v6 04/12] mm/hotplug: Prepare shrink_{zone, pgdat}_span
 for sub-section removal
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552635609.2015392.6246305135559796835.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Ralph Campbell <rcampbell@nvidia.com>
Message-ID: <001f15a6-26bb-cbab-587f-d897b2dc9094@nvidia.com>
Date: Fri, 19 Apr 2019 16:09:51 -0700
MIME-Version: 1.0
In-Reply-To: <155552635609.2015392.6246305135559796835.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, david@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Just noticed this by inspection.
I can't say I'm very familiar with the code.

On 4/17/19 11:39 AM, Dan Williams wrote:
> Sub-section hotplug support reduces the unit of operation of hotplug
> from section-sized-units (PAGES_PER_SECTION) to sub-section-sized units
> (PAGES_PER_SUBSECTION). Teach shrink_{zone,pgdat}_span() to consider
> PAGES_PER_SUBSECTION boundaries as the points where pfn_valid(), not
> valid_section(), can toggle.
> 
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>   include/linux/mmzone.h |    2 ++
>   mm/memory_hotplug.c    |   16 ++++++++--------
>   2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index cffde898e345..b13f0cddf75e 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1164,6 +1164,8 @@ static inline unsigned long section_nr_to_pfn(unsigned long sec)
>   
>   #define SECTION_ACTIVE_SIZE ((1UL << SECTION_SIZE_BITS) / BITS_PER_LONG)
>   #define SECTION_ACTIVE_MASK (~(SECTION_ACTIVE_SIZE - 1))
> +#define PAGES_PER_SUB_SECTION (SECTION_ACTIVE_SIZE / PAGE_SIZE)
> +#define PAGE_SUB_SECTION_MASK (~(PAGES_PER_SUB_SECTION-1))
>   
>   struct mem_section_usage {
>   	/*
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 8b7415736d21..d5874f9d4043 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -327,10 +327,10 @@ static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
>   {
>   	struct mem_section *ms;
>   
> -	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SECTION) {
> +	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUB_SECTION) {
>   		ms = __pfn_to_section(start_pfn);
>   
> -		if (unlikely(!valid_section(ms)))
> +		if (unlikely(!pfn_valid(start_pfn)))
>   			continue;

Note that "struct mem_section *ms;" is now set but not used.
You can remove the definition and initialization of "ms".

>   		if (unlikely(pfn_to_nid(start_pfn) != nid))
> @@ -355,10 +355,10 @@ static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
>   
>   	/* pfn is the end pfn of a memory section. */
>   	pfn = end_pfn - 1;
> -	for (; pfn >= start_pfn; pfn -= PAGES_PER_SECTION) {
> +	for (; pfn >= start_pfn; pfn -= PAGES_PER_SUB_SECTION) {
>   		ms = __pfn_to_section(pfn);
>   
> -		if (unlikely(!valid_section(ms)))
> +		if (unlikely(!pfn_valid(pfn)))
>   			continue;

Ditto about "ms".

>   		if (unlikely(pfn_to_nid(pfn) != nid))
> @@ -417,10 +417,10 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
>   	 * it check the zone has only hole or not.
>   	 */
>   	pfn = zone_start_pfn;
> -	for (; pfn < zone_end_pfn; pfn += PAGES_PER_SECTION) {
> +	for (; pfn < zone_end_pfn; pfn += PAGES_PER_SUB_SECTION) {
>   		ms = __pfn_to_section(pfn);
>   
> -		if (unlikely(!valid_section(ms)))
> +		if (unlikely(!pfn_valid(pfn)))
>   			continue;

Ditto about "ms".

>   		if (page_zone(pfn_to_page(pfn)) != zone)
> @@ -485,10 +485,10 @@ static void shrink_pgdat_span(struct pglist_data *pgdat,
>   	 * has only hole or not.
>   	 */
>   	pfn = pgdat_start_pfn;
> -	for (; pfn < pgdat_end_pfn; pfn += PAGES_PER_SECTION) {
> +	for (; pfn < pgdat_end_pfn; pfn += PAGES_PER_SUB_SECTION) {
>   		ms = __pfn_to_section(pfn);
>   
> -		if (unlikely(!valid_section(ms)))
> +		if (unlikely(!pfn_valid(pfn)))
>   			continue;

Ditto about "ms".

>   		if (pfn_to_nid(pfn) != nid)
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
