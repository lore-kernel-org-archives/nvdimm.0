Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 30 Jul 2015 22:58:02 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v3 01/24] mm: enhance region_is_ram() to
 region_intersects()
Message-ID: <20150730205802.GP30479@wotan.suse.de>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150730165345.33962.80299.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150730165345.33962.80299.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com, linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 30, 2015 at 12:53:45PM -0400, Dan Williams wrote:
> region_is_ram() is used to prevent the establishment of aliased mappings
> to physical "System RAM" with incompatible cache settings.  However, it
> uses "-1" to indicate both "unknown" memory ranges (ranges not described
> by platform firmware) and "mixed" ranges (where the parameters describe
> a range that partially overlaps "System RAM").
> 
> Fix this up by explicitly tracking the "unknown" vs "mixed" resource
> cases and returning REGION_INTERSECTS, REGION_MIXED, or REGION_DISJOINT.
> This re-write also adds support for detecting when the requested region
> completely eclipses all of a resource.  Note, the implementation treats
> overlaps between "unknown" and the requested memory type as
> REGION_INTERSECTS.
> 
> Finally, other memory types can be passed in by name, for now the only
> usage "System RAM".
> 
> Suggested-by: Luis R. Rodriguez <mcgrof@suse.com>
> Reviewed-by: Toshi Kani <toshi.kani@hp.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  include/linux/mm.h |    9 +++++++-
>  kernel/resource.c  |   61 +++++++++++++++++++++++++++++++---------------------
>  2 files changed, 44 insertions(+), 26 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 2e872f92dbac..84b05ebedb2d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -369,7 +369,14 @@ static inline int put_page_unless_one(struct page *page)
>  }
>  
>  extern int page_is_ram(unsigned long pfn);
> -extern int region_is_ram(resource_size_t phys_addr, unsigned long size);
> +
> +enum {

If you gave the enum a name, say enum region_intersect_type, you could then
use that for the return type of region_intersects.

> +	REGION_INTERSECTS,
> +	REGION_DISJOINT,
> +	REGION_MIXED,
> +};
> +
> +int region_intersects(resource_size_t offset, size_t size, const char *type);


If you used say a return type enum region_intersect_type, at compile time you'd
get a complaint if any branch was not handled for the different enum types.

  Luis
