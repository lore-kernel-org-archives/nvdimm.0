Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FD7D21219ADE
 for <linux-nvdimm@lists.01.org>; Tue, 23 Apr 2019 14:21:23 -0700 (PDT)
Subject: Re: [PATCH v6 06/12] mm/hotplug: Add mem-hotplug restrictions for
 remove_memory()
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552636696.2015392.12612320706815016081.stgit@dwillia2-desk3.amr.corp.intel.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <3dda9d08-a572-65b9-2f2f-da978a008deb@redhat.com>
Date: Tue, 23 Apr 2019 23:21:20 +0200
MIME-Version: 1.0
In-Reply-To: <155552636696.2015392.12612320706815016081.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 17.04.19 20:39, Dan Williams wrote:
> Teach the arch_remove_memory() path to consult the same 'struct
> mhp_restrictions' context as was specified at arch_add_memory() time.
> 
> No functional change, this is a preparation step for teaching
> __remove_pages() about how and when to allow sub-section hot-remove, and
> a cleanup for an unnecessary "is_dev_zone()" special case.

I am not yet sure if this is the right thing to do. When adding memory,
we obviously have to specify the "how". When removing memory, we usually
should be able to look such stuff up.


>  void __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
> -		    unsigned long nr_pages, struct vmem_altmap *altmap)
> +		unsigned long nr_pages, struct mhp_restrictions *restrictions)
>  {
>  	unsigned long i;
> -	unsigned long map_offset = 0;
>  	int sections_to_remove;
> +	unsigned long map_offset = 0;
> +	struct vmem_altmap *altmap = restrictions->altmap;
>  
> -	/* In the ZONE_DEVICE case device driver owns the memory region */
> -	if (is_dev_zone(zone)) {
> -		if (altmap)
> -			map_offset = vmem_altmap_offset(altmap);
> -	}
> +	if (altmap)
> +		map_offset = vmem_altmap_offset(altmap);
>  

Why weren't we able to use this exact same hunk before? (after my
resource deletion cleanup of course)

IOW, do we really need struct mhp_restrictions here?

After I factor out memory device handling into the caller of
arch_remove_memory(), also the next patch ("mm/sparsemem: Prepare for
sub-section ranges") should no longer need it. Or am I missing something?

-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
