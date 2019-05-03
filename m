Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 249DA2123781E
 for <linux-nvdimm@lists.01.org>; Fri,  3 May 2019 01:06:27 -0700 (PDT)
Date: Fri, 3 May 2019 10:06:23 +0200
From: Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v7 02/12] mm/sparsemem: Introduce common definitions for
 the size and mask of a section
Message-ID: <20190503080622.GD15740@linux>
References: <155677652226.2336373.8700273400832001094.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155677653274.2336373.11220321059915670288.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <155677653274.2336373.11220321059915670288.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, akpm@linux-foundation.org, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 01, 2019 at 10:55:32PM -0700, Dan Williams wrote:
> Up-level the local section size and mask from kernel/memremap.c to
> global definitions.  These will be used by the new sub-section hotplug
> support.
> =

> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: J=E9r=F4me Glisse <jglisse@redhat.com>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  include/linux/mmzone.h |    2 ++
>  kernel/memremap.c      |   10 ++++------
>  mm/hmm.c               |    2 --
>  3 files changed, 6 insertions(+), 8 deletions(-)
> =

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index f0bbd85dc19a..6726fc175b51 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1134,6 +1134,8 @@ static inline unsigned long early_pfn_to_nid(unsign=
ed long pfn)
>   * PFN_SECTION_SHIFT		pfn to/from section number
>   */
>  #define PA_SECTION_SHIFT	(SECTION_SIZE_BITS)
> +#define PA_SECTION_SIZE		(1UL << PA_SECTION_SHIFT)
> +#define PA_SECTION_MASK		(~(PA_SECTION_SIZE-1))

As discussed here [1], we do not need the new PA_SECTION_MASK if we work wi=
th
pfns/pages directly, so I'd drop it if you go that way.

Besides that:

Reviewed-by: Oscar Salvador <osalvador@suse.de>

[1] https://patchwork.kernel.org/patch/10926047/

-- =

Oscar Salvador
SUSE L3
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
