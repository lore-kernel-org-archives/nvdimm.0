Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 5 Feb 2016 18:24:26 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] devm_memremap: Fix error value when memremap failed
Message-ID: <20160206012426.GA12447@linux.intel.com>
References: <1454722827-15744-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1454722827-15744-1-git-send-email-toshi.kani@hpe.com>
Sender: owner-linux-mm@kvack.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 05, 2016 at 06:40:27PM -0700, Toshi Kani wrote:
> devm_memremap() returns an ERR_PTR() value in case of error.
> However, it returns NULL when memremap() failed.  This causes
> the caller, such as the pmem driver, to proceed and oops later.
> 
> Change devm_memremap() to return ERR_PTR(-ENXIO) when memremap()
> failed.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Yep, good catch.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> ---
>  kernel/memremap.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index 70ee377..3427cca 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -136,8 +136,10 @@ void *devm_memremap(struct device *dev, resource_size_t offset,
>  	if (addr) {
>  		*ptr = addr;
>  		devres_add(dev, ptr);
> -	} else
> +	} else {
>  		devres_free(ptr);
> +		return ERR_PTR(-ENXIO);
> +	}
>  
>  	return addr;
>  }
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
