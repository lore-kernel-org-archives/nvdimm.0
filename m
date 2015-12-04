Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: ARM EFI stub and the EfiPersistentMemory type
Date: Fri, 4 Dec 2015 21:51:22 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BE85E04@G4W3202.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "Kani, Toshimitsu" <toshi.kani@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "bp@suse.de" <bp@suse.de>, "yinghai@kernel.org" <yinghai@kernel.org>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "msalter@redhat.com" <msalter@redhat.com>, "roy.franz@linaro.org" <roy.franz@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

drivers/firmware/efi/libstub/efi-stub-helper.c get_dram_base() 
parses the UEFI memory map, but just looks at the EFI_MEMORY_WB 
attribute while searching for the base memory address, 
not the type:

unsigned long get_dram_base(efi_system_table_t *sys_table_arg) {
...
        for_each_efi_memory_desc(&map, md)
                if (md->attribute & EFI_MEMORY_WB)
                        if (membase > md->phys_addr)
                                membase = md->phys_addr;


This is used by drivers/firmware/efi/libstub/arm-stub.c to
decide where to place the kernel image:

unsigned long efi_entry(void *handle, efi_system_table_t *sys_table, {
...
        dram_base = get_dram_base(sys_table);
        if (dram_base == EFI_ERROR) {
                pr_efi_err(sys_table, "Failed to find DRAM base\n");
                goto fail;
        }
        status = handle_kernel_image(sys_table, image_addr, &image_size,
                                     &reserve_addr,
                                     &reserve_size,
                                     dram_base, image);

Most types, including EfiPersistentMemory (14) and 
EfiReservedMemoryType (0), end up with WB|WT|WC|UC attributes.

So, if persistent memory happened to be below conventional memory,
it appears that this code would end up loading the kernel into
persistent memory, which would not be good.  The same for 
reserved memory ranges. I think it needs to check and only
operate on EfiConventionalMemory (maybe with a few others).

Example UEFI memory map (on an x86 system):

efi: mem00: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000092fff] (0 B for 588 KiB)
efi: mem01: [Reserved           |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000093000-0x0000000000093fff] (588 KiB for 4 KiB)
efi: mem02: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000094000-0x000000000009ffff] (592 KiB for 48 KiB)
efi: mem03: [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000100000-0x00000000013e8fff] (1 MiB for 19364 KiB)
efi: mem04: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000013e9000-0x0000000001ffffff] (20388 KiB for 12380 KiB)
efi: mem05: [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000002000000-0x00000000032e8fff] (32 MiB for 19364 KiB)
efi: mem06: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000032e9000-0x000000000fffffff] (52132 KiB for 210012 KiB)
efi: mem07: [Boot Code          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000010000000-0x0000000010048fff] (256 MiB for 292 KiB)
efi: mem08: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000010049000-0x00000000234f4fff] (262436 KiB for 316080 KiB)
efi: mem09: [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000234f5000-0x000000003ecfffff] (578516 KiB for 450604 KiB)
efi: mem10: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000003ed00000-0x000000003ed7ffff] (1005 MiB for 512 KiB)
efi: mem11: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000003ed80000-0x000000006affbfff] (1029632 KiB for 723440 KiB)
efi: mem12: [Reserved           |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000006affc000-0x000000006b5fbfff] (1753072 KiB for 6 MiB)
efi: mem13: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000006b5fc000-0x000000006b5fcfff] (1759216 KiB for 4 KiB)
efi: mem14: [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000006b5fd000-0x000000006b67dfff] (1759220 KiB for 516 KiB)
efi: mem15: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000006b67e000-0x000000006ecfafff] (1759736 KiB for 55796 KiB)
efi: mem16: [Boot Code          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000006ecfb000-0x000000006ecfbfff] (1815532 KiB for 4 KiB)
efi: mem17: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000006ecfc000-0x00000000712a5fff] (1815536 KiB for 38568 KiB)
efi: mem18: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000712a6000-0x0000000071337fff] (1854104 KiB for 584 KiB)
efi: mem19: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000071338000-0x000000007135dfff] (1854688 KiB for 152 KiB)
efi: mem20: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007135e000-0x0000000071387fff] (1854840 KiB for 168 KiB)
efi: mem21: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000071388000-0x000000007138bfff] (1855008 KiB for 16 KiB)
efi: mem22: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007138c000-0x0000000071835fff] (1855024 KiB for 4776 KiB)
efi: mem23: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000071836000-0x0000000071836fff] (1859800 KiB for 4 KiB)
efi: mem24: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000071837000-0x0000000071856fff] (1859804 KiB for 128 KiB)
efi: mem25: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000071857000-0x0000000071857fff] (1859932 KiB for 4 KiB)
efi: mem26: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000071858000-0x0000000071859fff] (1859936 KiB for 8 KiB)
efi: mem27: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007185a000-0x000000007185bfff] (1859944 KiB for 8 KiB)
efi: mem28: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007185c000-0x000000007185cfff] (1859952 KiB for 4 KiB)
efi: mem29: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007185d000-0x000000007185ffff] (1859956 KiB for 12 KiB)
efi: mem30: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000071860000-0x0000000071860fff] (1859968 KiB for 4 KiB)
efi: mem31: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000071861000-0x0000000071863fff] (1859972 KiB for 12 KiB)
efi: mem32: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000071864000-0x0000000071864fff] (1859984 KiB for 4 KiB)
efi: mem33: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000071865000-0x0000000071865fff] (1859988 KiB for 4 KiB)
efi: mem34: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000071866000-0x0000000071866fff] (1859992 KiB for 4 KiB)
efi: mem35: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000071867000-0x0000000071869fff] (1859996 KiB for 12 KiB)
efi: mem36: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007186a000-0x000000007186afff] (1860008 KiB for 4 KiB)
efi: mem37: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007186b000-0x000000007186bfff] (1860012 KiB for 4 KiB)
efi: mem38: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007186c000-0x0000000072e0afff] (1860016 KiB for 22140 KiB)
efi: mem39: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072e0b000-0x0000000072e0efff] (1882156 KiB for 16 KiB)
efi: mem40: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072e0f000-0x0000000072e7bfff] (1882172 KiB for 436 KiB)
efi: mem41: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072e7c000-0x0000000072e7efff] (1882608 KiB for 12 KiB)
efi: mem42: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072e7f000-0x0000000072e80fff] (1882620 KiB for 8 KiB)
efi: mem43: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072e81000-0x0000000072e82fff] (1882628 KiB for 8 KiB)
efi: mem44: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000072e83000-0x0000000076cfefff] (1882636 KiB for 63984 KiB)
efi: mem45: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000076cff000-0x00000000774e0fff] (1946620 KiB for 8072 KiB)
efi: mem46: [Loader Code        |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000774e1000-0x00000000774fefff] (1954692 KiB for 120 KiB)
efi: mem47: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000774ff000-0x0000000077925fff] (1954812 KiB for 4252 KiB)
efi: mem48: [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000077926000-0x000000007792ffff] (1959064 KiB for 40 KiB)
efi: mem49: [Boot Code          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000077930000-0x00000000784fefff] (1959104 KiB for 12092 KiB)
efi: mem50: [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000784ff000-0x00000000788fefff] (1971196 KiB for 4 MiB)
efi: mem51: [Runtime Code       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000788ff000-0x00000000790fefff] (1975292 KiB for 8 MiB)
efi: mem52: [Reserved           |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000790ff000-0x00000000791fefff] (1983484 KiB for 1 MiB)
efi: mem53: [ACPI Memory NVS    |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000791ff000-0x000000007b5fefff] (1984508 KiB for 36 MiB)
efi: mem54: [ACPI Reclaim Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007b5ff000-0x000000007b7fefff] (2021372 KiB for 2 MiB)
efi: mem55: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007b7ff000-0x000000007b7fffff] (2023420 KiB for 4 KiB)
efi: mem56: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x000000087fffffff] (4 GiB for 30 GiB)
efi: mem57: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000c80000000-0x000000147fffffff] (50 GiB for 32 GiB)
efi: mem58: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000080000000-0x000000008fffffff] (2 GiB for 256 MiB)
efi: mem59: [Persistent Memory  |   |  |NV|  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (34 GiB for 16 GiB)
efi: mem60: [Persistent Memory  |   |  |NV|  |  |  |  |   |WB|WT|WC|UC] range=[0x0000001480000000-0x0000001a7fffffff] (82 GiB for 24 GiB)


---
Robert Elliott, HPE Persistent Memory


