Return-Path: <owner-linux-mm@kvack.org>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v9 04/12] mm/sparsemem: Convert kmalloc_section_memmap() to populate_section_memmap()
In-Reply-To: <155977189139.2443951.460884430946346998.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155977186863.2443951.9036044808311959913.stgit@dwillia2-desk3.amr.corp.intel.com> <155977189139.2443951.460884430946346998.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Sun, 16 Jun 2019 11:36:47 +0530
MIME-Version: 1.0
Content-Type: text/plain
Message-Id: <8736kahxmw.fsf@linux.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, Logan Gunthorpe <logang@deltatee.com>, Oscar Salvador <osalvador@suse.de>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.orgosalvador@suse.demhocko@suse.com
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> Allow sub-section sized ranges to be added to the memmap.
> populate_section_memmap() takes an explict pfn range rather than
> assuming a full section, and those parameters are plumbed all the way
> through to vmmemap_populate(). There should be no sub-section usage in
> current deployments. New warnings are added to clarify which memmap
> allocation paths are sub-section capable.
>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/mm/init_64.c |    4 ++-
>  include/linux/mm.h    |    4 ++-
>  mm/sparse-vmemmap.c   |   21 +++++++++++------
>  mm/sparse.c           |   61 +++++++++++++++++++++++++++++++------------------
>  4 files changed, 57 insertions(+), 33 deletions(-)
>
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 8335ac6e1112..688fb0687e55 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1520,7 +1520,9 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>  {
>  	int err;
>  
> -	if (boot_cpu_has(X86_FEATURE_PSE))
> +	if (end - start < PAGES_PER_SECTION * sizeof(struct page))
> +		err = vmemmap_populate_basepages(start, end, node);
> +	else if (boot_cpu_has(X86_FEATURE_PSE))
>  		err = vmemmap_populate_hugepages(start, end, node, altmap);
>  	else if (altmap) {
>  		pr_err_once("%s: no cpu support for altmap allocations\n",

Can we move this to another patch? I am wondering what the x86 behaviour
here is? If the range is less that PAGES_PER_SECTION we don't allow to
use pmem as the map device? We sliently use memory range?

-aneesh
