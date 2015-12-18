Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151218114546.GD29219@leverpostej>
References: <94D0CD8314A33A4D9D801C0FE68B40295BEBD864@G9W0745.americas.hpqcorp.net>
	<20151218110651.GL25034@bivouac.eciton.net>
	<20151218114546.GD29219@leverpostej>
Date: Fri, 18 Dec 2015 14:07:10 +0100
Message-ID: <CAKv+Gu_KEDMdeF5zWL6EEwJyo+kt0u6HeaqrcVOEP9YHeu7uuw@mail.gmail.com>
Subject: Re: arm64/efi handling of persistent memory
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "Kani, Toshimitsu" <toshi.kani@hpe.com>, "Knippers, Linda" <linda.knippers@hpe.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 18 December 2015 at 12:45, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Dec 18, 2015 at 11:06:51AM +0000, Leif Lindholm wrote:
>> On Fri, Dec 18, 2015 at 01:33:25AM +0000, Elliott, Robert (Persistent Memory) wrote:
>> > Similar to the questions about the arm64 efi boot stub
>> > handing persistent memory, some of the arm64 kernel code
>> > looks fishy.
>> >
>> > In arch/arm64/kernel/efi.c:
>> >
>> > static int __init is_normal_ram(efi_memory_desc_t *md)
>> > {
>> >         if (md->attribute & EFI_MEMORY_WB)
>> >                 return 1;
>> >         return 0;
>> > }
>> >
>> > static __init int is_reserve_region(efi_memory_desc_t *md)
>> > {
>> >         switch (md->type) {
>> >         case EFI_LOADER_CODE:
>> >         case EFI_LOADER_DATA:
>> >         case EFI_BOOT_SERVICES_CODE:
>> >         case EFI_BOOT_SERVICES_DATA:
>> >         case EFI_CONVENTIONAL_MEMORY:
>> >         case EFI_PERSISTENT_MEMORY:
>> >                 return 0;
>> >         default:
>> >                 break;
>> >         }
>> >         return is_normal_ram(md);
>> > }
>> >
>> > static __init void reserve_regions(void)
>> > {
>> > ...
>> >                 if (is_normal_ram(md))
>> >                         early_init_dt_add_memory_arch(paddr, size);
>> >
>> >                 if (is_reserve_region(md)) {
>> >                         memblock_reserve(paddr, size);
>> > ...
>> >
>> > static bool __init efi_virtmap_init(void)
>> > {
>> > ...
>> >                 if (!is_normal_ram(md))
>> >                         prot = __pgprot(PROT_DEVICE_nGnRE);
>> >                 else if (md->type == EFI_RUNTIME_SERVICES_CODE ||
>> >                          !PAGE_ALIGNED(md->phys_addr))
>> >                         prot = PAGE_KERNEL_EXEC;
>> >                 else
>> >                         prot = PAGE_KERNEL;
>> >
>> > Concerns include:
>> >
>> > 1. is_normal_ram() will see the WB bit and return 1 regardless
>> > of the type.  That seems similar to the arm EFI boot stub issue.
>> > The three callers are shown above.
>>
>> So, first and third cases look OK to me, but the bit where we add
>> things to memblock just for being WB is bogus.
>
> We should be able to do this much more simply by only ever adding what
> we know is safe. We can "reserve" portions by nomapping them. e.g.
>
> bool can_add_to_memblock(efi_memory_desc_t *md)
> {
>         if (!(md->attribute & EFI_MEMORY_WB))
>                 return false;
>
>         switch (md->type) {
>         case EFI_LOADER_CODE:
>         case EFI_LOADER_DATA:
>         case EFI_BOOT_SERVICES_CODE:
>         case EFI_BOOT_SERVICES_DATA:
>         case EFI_CONVENTIONAL_MEMORY:
>                 return true;
>         }
>
>         return false;
> }
>
> for_each_efi_memory_desc(&memmap, md) {
>         if (can_add_to_memblock(md))
>                 early_init_dt_add_memory_arch(...);
>         else
>                 memblock_mark_nomap(...);
> }
>
> Though I suspect Ard might know some reason that won't work.
>

Before we start hacking away at this at the arm64/EFI level, do we
have any documentation and/or consensus regarding how persistent
memory should be treated in the first place? Should it be covered by
memblock? Should it be covered by the linear mapping? Should it be
memblock_reserve()'d?

>> > 2. is_reserve_region() treating EFI_PERSISTENT_MEMORY the same
>> > as EFI_CONVENTIONAL_MEMORY looks wrong.
>>
>> Yeah... That one was introduced by
>> ad5fb870c486 ("e820, efi: add ACPI 6.0 persistent memory types")
>> without any ACKs from ARM people :/
>>
>> While it probably wouldn't wreck your system, it is unlikely to do
>> what you'd want.
>
> It might corrupt that data you wanted to persist, so it's definitely a
> bug. Severity is arguable.
>
>> > 3. We're contemplating working around the grub problem by
>> > reporting EFI_RESERVED_MEMORY plus the NV attribute rather
>> > than EFI_PERSISTENT_MEMORY.
>
> I'm missing something. Robert, do you mean GRUB has a similar bug?
>
>> That sounds a bit ... nuclear.
>> Would you then be expecting to retreive information about the NV
>> device out of hw description, or via PCI, rather than the UEFI memory
>> map?
>
> That's going to cause much more pain. We should fix this code.
>
>> > If this is done, then is_reserve_region() will fall through
>> > to is_normal_ram(), which will see the WB bit and return 1.
>> > That seems backwards... but seems correct for persistent
>> > memory, reporting it as a reserved region.  That might avoid the
>> > the EFI_PERSISTENT_MEMORY handling problem (if the preceding
>> > call to is_normal_ram() didn't already cause problems).
>>
>> So ... the code is convoluted and could probably do with a
>> refresh. But is_normal_ram() returning 1 means is_reserve_region()
>> will return 1, meaning we end up reserving it in memblock and not
>> allocating in it.
>>
>> However, this is for is_reserve_region() - we will still have added it
>> to memblock with early_init_dt_add_memory_arch(), which may have
>> unwanted side effects.
>
> See above for a suggestion on that front.
>
>> I thought Ard had some patches in flight to address this, but they
>> don't appear to be in yet.
>
> The nomap stuff is in the arm64 git repo, in aarch64/efi [1] and
> for-next/core [2]. That alone doesn't seem to address this, though.
>
> Thanks,
> Mark.
>
> [1] https://git.kernel.org/cgit/linux/kernel/git/arm64/linux.git/log/?h=aarch64/efi
> [2] https://git.kernel.org/cgit/linux/kernel/git/arm64/linux.git/log/?h=for-next/core
