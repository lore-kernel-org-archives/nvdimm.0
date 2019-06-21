Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3636D21297063
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jun 2019 00:23:47 -0700 (PDT)
Subject: Re: [PATCH] mm/sparsemem: Cleanup 'section number' data types
References: <156107543656.1329419.11505835211949439815.stgit@dwillia2-desk3.amr.corp.intel.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <68b71c3a-6fbd-ce39-2699-09c85212d9f5@redhat.com>
Date: Fri, 21 Jun 2019 09:23:36 +0200
MIME-Version: 1.0
In-Reply-To: <156107543656.1329419.11505835211949439815.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, Oscar Salvador <osalvador@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On 21.06.19 02:06, Dan Williams wrote:
> David points out that there is a mixture of 'int' and 'unsigned long'
> usage for section number data types. Update the memory hotplug path to
> use 'unsigned long' consistently for section numbers.
> 
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Reported-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Hi Andrew,
> 
> This patch belatedly fixes up David's review feedback about moving over
> to 'unsigned long' for section numbers. Let me know if you want me to
> respin the full series, or if you'll just apply / fold this patch on
> top.
> 
>  mm/memory_hotplug.c |   10 +++++-----
>  mm/sparse.c         |    8 ++++----
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 4e8e65954f31..92bc44a73fc5 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -288,8 +288,8 @@ static int check_pfn_span(unsigned long pfn, unsigned long nr_pages,
>  int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
>  		struct mhp_restrictions *restrictions)
>  {
> -	unsigned long i;
> -	int start_sec, end_sec, err;
> +	int err;
> +	unsigned long nr, start_sec, end_sec;
>  	struct vmem_altmap *altmap = restrictions->altmap;
>  
>  	if (altmap) {
> @@ -310,7 +310,7 @@ int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
>  
>  	start_sec = pfn_to_section_nr(pfn);
>  	end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
> -	for (i = start_sec; i <= end_sec; i++) {
> +	for (nr = start_sec; nr <= end_sec; nr++) {
>  		unsigned long pfns;
>  
>  		pfns = min(nr_pages, PAGES_PER_SECTION
> @@ -541,7 +541,7 @@ void __remove_pages(struct zone *zone, unsigned long pfn,
>  		    unsigned long nr_pages, struct vmem_altmap *altmap)
>  {
>  	unsigned long map_offset = 0;
> -	int i, start_sec, end_sec;
> +	unsigned long nr, start_sec, end_sec;
>  
>  	if (altmap)
>  		map_offset = vmem_altmap_offset(altmap);
> @@ -553,7 +553,7 @@ void __remove_pages(struct zone *zone, unsigned long pfn,
>  
>  	start_sec = pfn_to_section_nr(pfn);
>  	end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
> -	for (i = start_sec; i <= end_sec; i++) {
> +	for (nr = start_sec; nr <= end_sec; nr++) {
>  		unsigned long pfns;
>  
>  		cond_resched();
> diff --git a/mm/sparse.c b/mm/sparse.c
> index b77ca21a27a4..6c4eab2b2bb0 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -229,21 +229,21 @@ void subsection_mask_set(unsigned long *map, unsigned long pfn,
>  void __init subsection_map_init(unsigned long pfn, unsigned long nr_pages)
>  {
>  	int end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
> -	int i, start_sec = pfn_to_section_nr(pfn);
> +	unsigned long nr, start_sec = pfn_to_section_nr(pfn);
>  
>  	if (!nr_pages)
>  		return;
>  
> -	for (i = start_sec; i <= end_sec; i++) {
> +	for (nr = start_sec; nr <= end_sec; nr++) {
>  		struct mem_section *ms;
>  		unsigned long pfns;
>  
>  		pfns = min(nr_pages, PAGES_PER_SECTION
>  				- (pfn & ~PAGE_SECTION_MASK));
> -		ms = __nr_to_section(i);
> +		ms = __nr_to_section(nr);
>  		subsection_mask_set(ms->usage->subsection_map, pfn, pfns);
>  
> -		pr_debug("%s: sec: %d pfns: %ld set(%d, %d)\n", __func__, i,
> +		pr_debug("%s: sec: %d pfns: %ld set(%d, %d)\n", __func__, nr,
>  				pfns, subsection_map_index(pfn),
>  				subsection_map_index(pfn + pfns - 1));
>  
> 

Thanks Dan!

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
