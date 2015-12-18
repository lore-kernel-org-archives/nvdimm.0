Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: arm64/efi handling of persistent memory
Date: Fri, 18 Dec 2015 01:33:25 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BEBD864@G9W0745.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>
Cc: "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "Kani, Toshimitsu" <toshi.kani@hpe.com>, "Knippers, Linda" <linda.knippers@hpe.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Similar to the questions about the arm64 efi boot stub
handing persistent memory, some of the arm64 kernel code 
looks fishy.

In arch/arm64/kernel/efi.c:

static int __init is_normal_ram(efi_memory_desc_t *md)
{
        if (md->attribute & EFI_MEMORY_WB)
                return 1;
        return 0;
}

static __init int is_reserve_region(efi_memory_desc_t *md)
{
        switch (md->type) {
        case EFI_LOADER_CODE:
        case EFI_LOADER_DATA:
        case EFI_BOOT_SERVICES_CODE:
        case EFI_BOOT_SERVICES_DATA:
        case EFI_CONVENTIONAL_MEMORY:
        case EFI_PERSISTENT_MEMORY:
                return 0;
        default:
                break;
        }
        return is_normal_ram(md);
}

static __init void reserve_regions(void)
{
...
                if (is_normal_ram(md))
                        early_init_dt_add_memory_arch(paddr, size);

                if (is_reserve_region(md)) {
                        memblock_reserve(paddr, size);
...

static bool __init efi_virtmap_init(void)
{
...
                if (!is_normal_ram(md))
                        prot = __pgprot(PROT_DEVICE_nGnRE);
                else if (md->type == EFI_RUNTIME_SERVICES_CODE ||
                         !PAGE_ALIGNED(md->phys_addr))
                        prot = PAGE_KERNEL_EXEC;
                else
                        prot = PAGE_KERNEL;

Concerns include:

1. is_normal_ram() will see the WB bit and return 1 regardless
of the type.  That seems similar to the arm EFI boot stub issue.
The three callers are shown above.

2. is_reserve_region() treating EFI_PERSISTENT_MEMORY the same
as EFI_CONVENTIONAL_MEMORY looks wrong.

3. We're contemplating working around the grub problem by
reporting EFI_RESERVED_MEMORY plus the NV attribute rather
than EFI_PERSISTENT_MEMORY.

If this is done, then is_reserve_region() will fall through
to is_normal_ram(), which will see the WB bit and return 1.
That seems backwards... but seems correct for persistent
memory, reporting it as a reserved region.  That might avoid the
the EFI_PERSISTENT_MEMORY handling problem (if the preceding
call to is_normal_ram() didn't already cause problems).

---
Robert Elliott, HPE Persistent Memory


