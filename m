Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1438119191.3214.407.camel@hp.com>
Subject: Re: [PATCH v2 04/25] mm: enhance region_is_ram() to distinguish
 'unknown' vs 'mixed'
From: Toshi Kani <toshi.kani@hp.com>
Date: Tue, 28 Jul 2015 15:33:11 -0600
In-Reply-To: <20150725023821.8664.81275.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150725023821.8664.81275.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2015-07-24 at 22:38 -0400, Dan Williams wrote:
> region_is_ram() is used to prevent the establishment of aliased mappings
> to physical "System RAM" with incompatible cache settings.  However, it
> uses "-1" to indicate both "unknown" memory ranges (ranges not described
> by platform firmware) and "mixed" ranges (where the parameters describe
> a range that partially overlaps "System RAM").
> 
> Fix this up by explicitly tracking the "unknown" vs "mixed" resource
> cases. In addition to clarifying that "-1" means the requested spanned
> RAM and non-RAM resource, this re-write also adds support for detecting
> when the requested range completely covers all of a resource.

Agreed - this is a good enhancement.

> Finally, the implementation treats overlaps between "unknown" and RAM as
> RAM.

This sounds right for this interface.  iomem_map_sanity_check() checks the
boundary condition with the resource table.

> Cc: Toshi Kani <toshi.kani@hp.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

The changes look good as well.

Reviewed-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi
