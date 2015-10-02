Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 2 Oct 2015 10:51:27 -0700
From: Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH v2 19/25] pxa2xx-flash: switch from ioremap_cache to
 memremap
Message-ID: <20151002175127.GH107187@google.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150725023945.8664.34842.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150725023945.8664.34842.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com, linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, David Woodhouse <dwmw2@infradead.org>, hch@lst.de, linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

+ linux-mtd

On Fri, Jul 24, 2015 at 10:39:45PM -0400, Dan Williams wrote:
> In preparation for deprecating ioremap_cache() convert its usage in
> pxa2xx-flash to memremap.
> 
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Brian Norris <computersforpeace@gmail.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/mtd/maps/pxa2xx-flash.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
> index 12fa75df5008..758a8a7f86d9 100644
> --- a/drivers/mtd/maps/pxa2xx-flash.c
> +++ b/drivers/mtd/maps/pxa2xx-flash.c
> @@ -71,8 +71,8 @@ static int pxa2xx_flash_probe(struct platform_device *pdev)
>  		       info->map.name);
>  		return -ENOMEM;
>  	}
> -	info->map.cached =
> -		ioremap_cache(info->map.phys, info->map.size);
> +	info->map.cached = memremap(info->map.phys, info->map.size,
> +			MEMREMAP_CACHE);

Should the corresponding iounmap() be changed too? Looks like a pretty
thin wrapper right now, but it seems like the API would suggest we do
this anyway.

>  	if (!info->map.cached)
>  		printk(KERN_WARNING "Failed to ioremap cached %s\n",
>  		       info->map.name);
> 

Brian
