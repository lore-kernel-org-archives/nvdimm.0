Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 4 Apr 2019 12:32:11 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 2/5] lib/memregion: Uplevel the pmem "region" ida to
 a global allocator
Message-ID: <20190404193211.GK22763@bombadil.infradead.org>
References: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155440491849.3190322.17551464505265122881.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155440491849.3190322.17551464505265122881.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Keith Busch <keith.busch@intel.com>, vishal.l.verma@intel.com, x86@kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 04, 2019 at 12:08:38PM -0700, Dan Williams wrote:
> +++ b/lib/Kconfig
> @@ -318,6 +318,12 @@ config DECOMPRESS_LZ4
>  config GENERIC_ALLOCATOR
>  	bool
>  
> +#
> +# Generic IDA for memory regions
> +#

Leaky abstraction -- nobody needs know that it's implemented as an IDA.
Suggest:

# Memory region ID allocation

...

> +++ b/lib/memregion.c
> @@ -0,0 +1,22 @@
> +#include <linux/idr.h>
> +#include <linux/module.h>
> +
> +static DEFINE_IDA(region_ida);
> +
> +int memregion_alloc(void)
> +{
> +	return ida_simple_get(&region_ida, 0, 0, GFP_KERNEL);
> +}
> +EXPORT_SYMBOL(memregion_alloc);
> +
> +void memregion_free(int id)
> +{
> +	ida_simple_remove(&region_ida, id);
> +}
> +EXPORT_SYMBOL(memregion_free);
> +
> +static void __exit memregion_exit(void)
> +{
> +	ida_destroy(&region_ida);
> +}
> +module_exit(memregion_exit);

 - Should these be EXPORT_SYMBOL_GPL?
 - Can we use the new interface, ida_alloc() and ida_free()?
 - Do we really want memregion_exit() to happen while there are still IDs
   allocated in the IDA?  I think this might well be better as:

	BUG_ON(!ida_empty(&region_ida));

Also, do we really want to call the structure the region_ida?  Why not
region_ids?
