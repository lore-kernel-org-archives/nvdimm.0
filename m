Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 17 Feb 2016 10:29:45 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86/mm: Add x86 valid_phys_addr_range() for /dev/mem
Message-ID: <20160217092945.GB19001@gmail.com>
References: <1455069975-14291-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1455069975-14291-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de, linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>


* Toshi Kani <toshi.kani@hpe.com> wrote:

> x86 does not define ARCH_HAS_VALID_PHYS_ADDR_RANGE, which
> leads /dev/mem to use the default valid_phys_addr_range()
> and valid_mmap_phys_addr_range() in drivers/char/mem.c.
> 
> The default valid_phys_addr_range() allows any range lower
> than __pa(high_memory), which is the end of system RAM, and
> disallows any range higher than it.
> 
> Persistent memory may be located at lower and/or higher
> address of __pa(high_memory) depending on their memory slots.
> When using crash(8) via /dev/mem for analyzing data in
> persistent memory, it can only access to the one lower than
> __pa(high_memory).
> 
> Add x86 valid_phys_addr_range() and valid_mmap_phys_addr_range()
> to provide better checking:
>  - Physical address range is valid when it is fully backed by
>    IORESOURCE_MEM, regardless of __pa(high_memory).
>  - Other ranges, including holes, are invalid.
> 
> This also allows crash(8) to access persistent memory ranges
> via /dev/mem (with a minor change to remove high_memory check
> from crash itself).
> 
> Note, /dev/mem makes additional check with devmem_is_allowed()
> for read/write when CONFIG_STRICT_DEVMEM is set, and does always
> for mmap.  CONFIG_IO_STRICT_DEVMEM provides further restriction.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> ---
> This patch applies on top of the patch-set below, and is based
> on the tip tree.
> https://lkml.org/lkml/2016/1/26/886
> ---
>  arch/x86/include/asm/io.h |    3 +++
>  arch/x86/mm/init.c        |   24 ++++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> index de25aad..189901a 100644
> --- a/arch/x86/include/asm/io.h
> +++ b/arch/x86/include/asm/io.h
> @@ -36,6 +36,7 @@
>  
>  #define ARCH_HAS_IOREMAP_WC
>  #define ARCH_HAS_IOREMAP_WT
> +#define ARCH_HAS_VALID_PHYS_ADDR_RANGE
>  
>  #include <linux/string.h>
>  #include <linux/compiler.h>
> @@ -326,6 +327,8 @@ extern void __iomem *ioremap_wc(resource_size_t offset, unsigned long size);
>  extern void __iomem *ioremap_wt(resource_size_t offset, unsigned long size);
>  
>  extern bool is_early_ioremap_ptep(pte_t *ptep);
> +extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
> +extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
>  
>  #ifdef CONFIG_XEN
>  #include <xen/xen.h>
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 493f541..35cf96f 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -624,6 +624,30 @@ void __init init_mem_mapping(void)
>  	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
>  }
>  
> +/**
> + * valid_phys_addr_range - check phys addr for /dev/mem read and write
> + *
> + * Return true if a target physical address is marked as IORESOURCE_MEM.
> + */
> +int valid_phys_addr_range(phys_addr_t addr, size_t size)
> +{
> +	return (region_intersects(addr, size, IORESOURCE_MEM,
> +				  IORES_DESC_NONE) == REGION_INTERSECTS);
> +}
> +
> +/**
> + * valid_mmap_phys_addr_range - check phys addr for /dev/mem mmap
> + *
> + * Return true if a target physical address is marked as IORESOURCE_MEM.
> + */
> +int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
> +{
> +	resource_size_t addr = pfn << PAGE_SHIFT;
> +
> +	return (region_intersects(addr, size, IORESOURCE_MEM,
> +				  IORES_DESC_NONE) == REGION_INTERSECTS);
> +}
> +
>  /*
>   * devmem_is_allowed() checks to see if /dev/mem access to a certain address
>   * is valid. The argument is a physical page number.

So it's hard to judge the quality of these new APIs without seeing their actual 
usecases. So please Cc: me to whatever work this is used in, and I'll have a look 
in that context.

Thanks,

	Ingo
