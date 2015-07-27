Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 27 Jul 2015 10:03:48 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 24/25] arch: remove ioremap_wt, replace with
	arch_memremap
Message-ID: <20150727080347.GA18599@lst.de>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com> <20150725024015.8664.42950.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150725024015.8664.42950.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com, linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>, toshi.kani@hp.com, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

> +++ b/arch/frv/include/asm/io.h
> @@ -17,8 +17,6 @@
>  
>  #ifdef __KERNEL__
>  
> -#define ARCH_HAS_IOREMAP_WT
> -
>  #include <linux/types.h>
>  #include <asm/virtconvert.h>
>  #include <asm/string.h>
> @@ -267,20 +265,17 @@ static inline void __iomem *ioremap_nocache(unsigned long physaddr, unsigned lon
>  	return __ioremap(physaddr, size, IOMAP_NOCACHE_SER);
>  }
>  
> -static inline void __iomem *ioremap_wt(unsigned long physaddr, unsigned long size)
> -{
> -	return __ioremap(physaddr, size, IOMAP_WRITETHROUGH);
> -}
> -
> -static inline void __iomem *ioremap_fullcache(unsigned long physaddr, unsigned long size)
> -{
> -	return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
> -}


> +void *arch_memremap(resource_size_t offset, size_t size, unsigned long flags)
> +{
> +	return (void *) offset;
> +}
> +EXPORT_SYMBOL(arch_memremap);

This doesn't look like a correct replacement.

Also shouldn't the replacements of ioremap_fullcache or ioremap_wc be
in the previous patch?

A few more similar issues pop up for other architectures as well.
