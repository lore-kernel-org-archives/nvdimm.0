Return-Path: <owner-linux-mm@kvack.org>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v9 10/12] mm/devm_memremap_pages: Enable sub-section remap
In-Reply-To: <155977193326.2443951.14201009973429527491.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155977186863.2443951.9036044808311959913.stgit@dwillia2-desk3.amr.corp.intel.com> <155977193326.2443951.14201009973429527491.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Sun, 16 Jun 2019 13:19:36 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Message-Id: <87zhmigeb3.fsf@linux.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: mhocko@suse.com, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, osalvador@suse.de
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> Teach devm_memremap_pages() about the new sub-section capabilities of
> arch_{add,remove}_memory(). Effectively, just replace all usage of
> align_start, align_end, and align_size with res->start, res->end, and
> resource_size(res). The existing sanity check will still make sure that
> the two separate remap attempts do not collide within a sub-section (2MB
> on x86).
>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  kernel/memremap.c |   61 +++++++++++++++++++++--------------------------=
------
>  1 file changed, 24 insertions(+), 37 deletions(-)
>
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index 57980ed4e571..a0e5f6b91b04 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -58,7 +58,7 @@ static unsigned long pfn_first(struct dev_pagemap *pgma=
p)
>  	struct vmem_altmap *altmap =3D &pgmap->altmap;
>  	unsigned long pfn;
>=20=20
> -	pfn =3D res->start >> PAGE_SHIFT;
> +	pfn =3D PHYS_PFN(res->start);
>  	if (pgmap->altmap_valid)
>  		pfn +=3D vmem_altmap_offset(altmap);
>  	return pfn;
> @@ -86,7 +86,6 @@ static void devm_memremap_pages_release(void *data)
>  	struct dev_pagemap *pgmap =3D data;
>  	struct device *dev =3D pgmap->dev;
>  	struct resource *res =3D &pgmap->res;
> -	resource_size_t align_start, align_size;
>  	unsigned long pfn;
>  	int nid;
>=20=20
> @@ -96,25 +95,21 @@ static void devm_memremap_pages_release(void *data)
>  	pgmap->cleanup(pgmap->ref);
>=20=20
>  	/* pages are dead and unused, undo the arch mapping */
> -	align_start =3D res->start & ~(PA_SECTION_SIZE - 1);
> -	align_size =3D ALIGN(res->start + resource_size(res), PA_SECTION_SIZE)
> -		- align_start;
> -
> -	nid =3D page_to_nid(pfn_to_page(align_start >> PAGE_SHIFT));
> +	nid =3D page_to_nid(pfn_to_page(PHYS_PFN(res->start)));

Why do we not require to align things to subsection size now?=20

-aneesh
