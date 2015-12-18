Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 18 Dec 2015 11:06:51 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: arm64/efi handling of persistent memory
Message-ID: <20151218110651.GL25034@bivouac.eciton.net>
References: <94D0CD8314A33A4D9D801C0FE68B40295BEBD864@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BEBD864@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "Kani, Toshimitsu" <toshi.kani@hpe.com>, "Knippers, Linda" <linda.knippers@hpe.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 18, 2015 at 01:33:25AM +0000, Elliott, Robert (Persistent Memory) wrote:
> Similar to the questions about the arm64 efi boot stub
> handing persistent memory, some of the arm64 kernel code 
> looks fishy.
> 
> In arch/arm64/kernel/efi.c:
> 
> static int __init is_normal_ram(efi_memory_desc_t *md)
> {
>         if (md->attribute & EFI_MEMORY_WB)
>                 return 1;
>         return 0;
> }
> 
> static __init int is_reserve_region(efi_memory_desc_t *md)
> {
>         switch (md->type) {
>         case EFI_LOADER_CODE:
>         case EFI_LOADER_DATA:
>         case EFI_BOOT_SERVICES_CODE:
>         case EFI_BOOT_SERVICES_DATA:
>         case EFI_CONVENTIONAL_MEMORY:
>         case EFI_PERSISTENT_MEMORY:
>                 return 0;
>         default:
>                 break;
>         }
>         return is_normal_ram(md);
> }
> 
> static __init void reserve_regions(void)
> {
> ...
>                 if (is_normal_ram(md))
>                         early_init_dt_add_memory_arch(paddr, size);
> 
>                 if (is_reserve_region(md)) {
>                         memblock_reserve(paddr, size);
> ...
> 
> static bool __init efi_virtmap_init(void)
> {
> ...
>                 if (!is_normal_ram(md))
>                         prot = __pgprot(PROT_DEVICE_nGnRE);
>                 else if (md->type == EFI_RUNTIME_SERVICES_CODE ||
>                          !PAGE_ALIGNED(md->phys_addr))
>                         prot = PAGE_KERNEL_EXEC;
>                 else
>                         prot = PAGE_KERNEL;
> 
> Concerns include:
> 
> 1. is_normal_ram() will see the WB bit and return 1 regardless
> of the type.  That seems similar to the arm EFI boot stub issue.
> The three callers are shown above.

So, first and third cases look OK to me, but the bit where we add
things to memblock just for being WB is bogus.

> 2. is_reserve_region() treating EFI_PERSISTENT_MEMORY the same
> as EFI_CONVENTIONAL_MEMORY looks wrong.

Yeah... That one was introduced by
ad5fb870c486 ("e820, efi: add ACPI 6.0 persistent memory types")
without any ACKs from ARM people :/

While it probably wouldn't wreck your system, it is unlikely to do
what you'd want.

> 3. We're contemplating working around the grub problem by
> reporting EFI_RESERVED_MEMORY plus the NV attribute rather
> than EFI_PERSISTENT_MEMORY.

That sounds a bit ... nuclear.
Would you then be expecting to retreive information about the NV
device out of hw description, or via PCI, rather than the UEFI memory
map?

> If this is done, then is_reserve_region() will fall through
> to is_normal_ram(), which will see the WB bit and return 1.
> That seems backwards... but seems correct for persistent
> memory, reporting it as a reserved region.  That might avoid the
> the EFI_PERSISTENT_MEMORY handling problem (if the preceding
> call to is_normal_ram() didn't already cause problems).

So ... the code is convoluted and could probably do with a
refresh. But is_normal_ram() returning 1 means is_reserve_region()
will return 1, meaning we end up reserving it in memblock and not
allocating in it.

However, this is for is_reserve_region() - we will still have added it
to memblock with early_init_dt_add_memory_arch(), which may have
unwanted side effects.

I thought Ard had some patches in flight to address this, but they
don't appear to be in yet.

/
    Leif
