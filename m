Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1424206333.12687.8.camel@theros.lm.intel.com>
Subject: Re: [PATCH 3/3] pmem: Allow request_mem to fail,
 (CONFIG_BLK_DEV_PMEM_IGNORE_REQUEST_MEM_RET)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Tue, 17 Feb 2015 13:52:13 -0700
In-Reply-To: <54E1D36B.4000905@plexistor.com>
References: <54E1CF5B.9020905@plexistor.com>
	 <54E1D36B.4000905@plexistor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2015-02-16 at 13:24 +0200, Boaz Harrosh wrote:
> With old Kernels there was a bug in x86 where any unknown
> memory chip type would come up BUSY when calling
> request_mem_region_exclusive().
> 
> So for pmem to work with old Kernels and real NvDIMM chips
> we have a new Kconfig option CONFIG_BLK_DEV_PMEM_IGNORE_REQUEST_MEM_RET.
> 
> People have been running with hacked up pmem that will ignore
> the return code from request_mem_region_exclusive. So here it is
> official
> 
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>

I'm confused - I thought that this behavior was fixed by patch 1/3?
With that patch this memory reservation should not fail, correct?

If so, why do we need this patch?

> ---
>  drivers/block/Kconfig | 12 ++++++++++++
>  drivers/block/pmem.c  | 11 +++++++----
>  2 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index 3b3200f..10879b8 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -430,6 +430,18 @@ config BLK_DEV_PMEM_USE_PAGES
>  	  to other devices in the system, then you must say "Yes" here.
>  	  If unsure leave as Yes.
>  
> +config BLK_DEV_PMEM_IGNORE_REQUEST_MEM_RET
> +	bool "Ignore the return code from request_mem_region_exclusive"
> +	depends on BLK_DEV_PMEM
> +	help
> +	  In Old Kernels type-12 Memory type which is used by NvDIMM
> +	  chips Comes out busy when calling request_mem_region_exclusive,
> +	  because of a bug.
> +	  If this option is set to "yes". The pmem will ignore the
> +	  failure, and continue as usual. If you have an old Kernel and
> +	  a real NvDIMM chip you must say yes here.
> +	  (Ignored if BLK_DEV_PMEM_USE_PAGES=y)
> +
>  config CDROM_PKTCDVD
>  	tristate "Packet writing on CD/DVD media"
>  	depends on !UML
> diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
> index 9eb7ffe..f84d033 100644
> --- a/drivers/block/pmem.c
> +++ b/drivers/block/pmem.c
> @@ -197,10 +197,12 @@ int pmem_mapmem(struct pmem_device *pmem)
>  
>  	res_mem = request_mem_region_exclusive(pmem->phys_addr, pmem->size,
>  					       "pmem");
> -	if (!res_mem) {
> +	if (unlikely(!res_mem)) {
>  		pr_warn("pmem: request_mem_region_exclusive phys=0x%llx size=0x%zx failed\n",
> -			   pmem->phys_addr, pmem->size);
> -		return -EINVAL;
> +			pmem->phys_addr, pmem->size);
> +#ifndef CONFIG_BLK_DEV_PMEM_IGNORE_REQUEST_MEM_RET
> +		return -EBUSY;
> +#endif
>  	}
>  
>  	pmem->virt_addr = ioremap_cache(pmem->phys_addr, pmem->size);
> @@ -211,7 +213,8 @@ int pmem_mapmem(struct pmem_device *pmem)
>  	return 0;
>  
>  out_release:
> -	release_mem_region(pmem->phys_addr, pmem->size);
> +	if (res_mem)
> +		release_mem_region(pmem->phys_addr, pmem->size);
>  	return err;
>  }
>  



