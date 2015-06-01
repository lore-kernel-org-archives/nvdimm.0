Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <1433198166.23540.128.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 1/4] arch/*/asm/io.h: add ioremap_cache() to all
 architectures
From: Toshi Kani <toshi.kani@hp.com>
Date: Mon, 01 Jun 2015 16:36:06 -0600
In-Reply-To: <20150530185923.32590.98598.stgit@dwillia2-desk3.amr.corp.intel.com>
References: 
	<20150530185425.32590.3190.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150530185923.32590.98598.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: arnd@arndb.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de, ross.zwisler@linux.intel.com, akpm@linux-foundation.org, jgross@suse.com, x86@kernel.org, linux-nvdimm@lists.01.org, mcgrof@suse.com, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, stefan.bader@canonical.com, luto@amacapital.net, linux-mm@kvack.org, geert@linux-m68k.org, hmh@hmh.eng.br, tj@kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Sat, 2015-05-30 at 14:59 -0400, Dan Williams wrote:
> Similar to ioremap_wc() let architecture implementations optionally
> provide ioremap_cache().  As is, current ioremap_cache() users have
> architecture dependencies that prevent them from compiling on archs
> without ioremap_cache().  In some cases the architectures that have a
> cached ioremap() capability have an identifier other than
> "ioremap_cache".
> 
> Allow drivers to compile with ioremap_cache() support and fallback to a
> safe / uncached ioremap otherwise.
 :
> diff --git a/arch/mn10300/include/asm/io.h b/arch/mn10300/include/asm/io.h
> index 07c5b4a3903b..dcab414f40df 100644
> --- a/arch/mn10300/include/asm/io.h
> +++ b/arch/mn10300/include/asm/io.h
> @@ -283,6 +283,7 @@ static inline void __iomem *ioremap_nocache(unsigned long offset, unsigned long
>  
>  #define ioremap_wc ioremap_nocache
>  #define ioremap_wt ioremap_nocache
> +#define ioremap_cache ioremap_nocache

>From the comment in ioremap_nocache(), ioremap() may be cacheable in
this arch.  

> diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> index f56094cfdeff..a0665dfcab47 100644
> --- a/include/asm-generic/io.h
> +++ b/include/asm-generic/io.h
> @@ -793,6 +793,14 @@ static inline void __iomem *ioremap_wt(phys_addr_t offset, size_t size)
>  }
>  #endif
>  
> +#ifndef ioremap_cache
> +#define ioremap_cache ioremap_cache
> +static inline void __iomem *ioremap_cache(phys_addr_t offset, size_t size)
> +{
> +	return ioremap_nocache(offset, size);

Should this be defined as ioremap()?

> +}
> +#endif
> +
>  #ifndef iounmap
>  #define iounmap iounmap
>  
> diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
> index d8f8622fa044..f0f30464cecd 100644
> --- a/include/asm-generic/iomap.h
> +++ b/include/asm-generic/iomap.h
> @@ -70,6 +70,10 @@ extern void ioport_unmap(void __iomem *);
>  #define ioremap_wt ioremap_nocache
>  #endif
>  
> +#ifndef ARCH_HAS_IOREMAP_CACHE
> +#define ioremap_cache ioremap_nocache

Ditto.


Also, it'd be nice to remove ioremap_cached() and ioremap_fullcache()
with a separate patch in this opportunity.

Thanks,
-Toshi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
