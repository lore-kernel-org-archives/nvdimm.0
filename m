Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 46045223648BB
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jan 2018 14:26:19 -0800 (PST)
Date: Tue, 30 Jan 2018 15:31:54 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 1/4] acpi: nfit: Add support for detect platform CPU
 cache flush on power loss
Message-ID: <20180130223154.GA23836@linux.intel.com>
References: <151276655874.31888.13113966406333561201.stgit@djiang5-desk3.ch.intel.com>
 <151276680927.31888.15096916678580860198.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151276680927.31888.15096916678580860198.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 08, 2017 at 02:00:09PM -0700, Dave Jiang wrote:
> In ACPI 6.2a the platform capability structure has been added to the NFIT
> tables. That provides software the ability to determine whether a system
> supports the auto flushing of CPU caches on power loss. If the capability
> is supported, we do not need to do dax_write_cache(). Plumbing the path
				     dax_flush() ?

dax_write_cache() just sets or clears DAXDEV_WRITE_CACHE.  dax_flush() is the
place where we check DAXDEV_WRITE_CACHE and avoid calling arch_wb_cache_pmem()
if the platform supports a flush-on-fail CPU cache.

> to set the property on per region from the NFTI tables.
					     NFIT
> 
> This patch depends on the ACPI NFIT 6.2a platform capabilities support code
> in include/acpi/actbl1.h.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/acpi/nfit/core.c     |   20 ++++++++++++++++++++
>  drivers/acpi/nfit/nfit.h     |    1 +
>  drivers/nvdimm/pmem.c        |    4 +++-
>  drivers/nvdimm/region_devs.c |    1 +
>  include/linux/libnvdimm.h    |    5 +++++
>  5 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index ff2580e7611d..c08b3da61b93 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -838,6 +838,18 @@ static bool add_flush(struct acpi_nfit_desc *acpi_desc,
>  	return true;
>  }
>  
> +static bool add_platform_cap(struct acpi_nfit_desc *acpi_desc,
> +		struct acpi_nfit_capabilities *pcap)
> +{
> +	struct device *dev = acpi_desc->dev;
> +	u8 mask;

'mask' cannot be a u8, else you'll lose all the upper bits when you compute
it.  It needs to be a u32.

> +
> +	mask = pcap->highest_capability - 1 + pcap->highest_capability;

This calculation is broken.   Take the simplest case, highest_capability = 0.
This should translate into a mask of 0x1, so you only look at bit 0, but:

0 - 1 + 0 == -1

giving you a mask that includes all the bits.  I think the mask you're looking
for is:
	mask = (1 << (pcap->highest_capability + 1)) - 1;

> +	acpi_desc->platform_cap = pcap->capabilities & (u32)mask;
> +	dev_dbg(dev, "%s: cap: %#x\n", __func__, acpi_desc->platform_cap);
> +	return true;
> +}
> +
>  static void *add_table(struct acpi_nfit_desc *acpi_desc,
>  		struct nfit_table_prev *prev, void *table, const void *end)
>  {
<>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 7fbc5c5dc8e1..13f2ed80899e 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -35,6 +35,7 @@
>  #include "pmem.h"
>  #include "pfn.h"
>  #include "nd.h"
> +#include "nd-core.h"
>  
>  static struct device *to_dev(struct pmem_device *pmem)
>  {
> @@ -334,7 +335,8 @@ static int pmem_attach_disk(struct device *dev,
>  		dev_warn(dev, "unable to guarantee persistence of writes\n");
>  		fua = 0;
>  	}
> -	wbc = nvdimm_has_cache(nd_region);
> +	wbc = nvdimm_has_cache(nd_region) &
I'm guessing you meant:			  &&

> +		!test_bit(ND_REGION_PERSIST_CACHE, &nd_region->flags);
>  
>  	if (!devm_request_mem_region(dev, res->start, resource_size(res),
>  				dev_name(&ndns->dev))) {
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index abaf38c61220..87e8cd10de05 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -994,6 +994,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
>  	dev->groups = ndr_desc->attr_groups;
>  	nd_region->ndr_size = resource_size(ndr_desc->res);
>  	nd_region->ndr_start = ndr_desc->res->start;
> +
Unrelated whitespace change.

>  	nd_device_register(dev);
>  
>  	return nd_region;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
