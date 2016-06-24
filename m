Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1466754710-5948-1-git-send-email-jlee@suse.com>
References: <1466754710-5948-1-git-send-email-jlee@suse.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jun 2016 10:59:56 -0700
Message-ID: <CAPcyv4iFNP8Dj40-i_w_5fiE=zj3SLrkm-2MbxAO6JbKu14i2Q@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm, nfit: treat volatile virtual CD region as pmem
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linda Knippers <linda.knippers@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Gary Lin <GLin@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 24, 2016 at 12:51 AM, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> This patch adds logic to treat volatile virtual CD region as pmem
> region, then /dev/pmem* device can be mounted with iso9660.
>
> It's useful to work with the httpboot in EFI firmware to pull a remote
> ISO file to the local memory region for booting and installation.
>
> Wiki page of UEFI HTTPBoot with OVMF:
>         https://en.opensuse.org/UEFI_HTTPBoot_with_OVMF
>
> The ramdisk function in EDK2/OVMF generates a ACPI0012 root device that
> it contains empty _STA but without _DSM:
>
> DefinitionBlock ("ssdt2.aml", "SSDT", 2, "INTEL ", "RamDisk ", 0x00001000)
> {
>     Scope (\_SB)
>     {
>         Device (NVDR)
>         {
>             Name (_HID, "ACPI0012")  // _HID: Hardware ID
>             Name (_STR, Unicode ("NVDIMM Root Device"))  // _STR: Description String
>             Method (_STA, 0, NotSerialized)  // _STA: Status
>             {
>                 Return (0x0F)
>             }
>         }
>     }
> }
>
> In section 5.2.25.2 of ACPI 6.1 spec, it mentions that the "SPA Range
> Structure Index" of VCD SPA shall be set to zero. That means VCD SPA
> will not be associated by any NVDIMM region mapping.
>
> The VCD's SPA Range Structure in NFIT is similar to virtual disk region
> as following:
>
> [028h 0040   2]                Subtable Type : 0000 [System Physical Address Range]
> [02Ah 0042   2]                       Length : 0038
>
> [02Ch 0044   2]                  Range Index : 0000
> [02Eh 0046   2]        Flags (decoded below) : 0000
>                    Add/Online Operation Only : 0
>                       Proximity Domain Valid : 0
> [030h 0048   4]                     Reserved : 00000000
> [034h 0052   4]             Proximity Domain : 00000000
> [038h 0056  16]           Address Range GUID : 77AB535A-45FC-624B-5560-F7B281D1F96E
> [048h 0072   8]           Address Range Base : 00000000B6ABD018
> [050h 0080   8]         Address Range Length : 0000000005500000
> [058h 0088   8]         Memory Map Attribute : 0000000000000000
>
> The range index set to zero that means the VCD region not associated by
> any NVDIMM region mapping, and it will not assoicate to "flush hint",
> "interleave" or "control region".

No, per the spec zero is a reserved value and we should ignore such
SPA tables.  The way to not associate a SPA range is to never
reference it from a "flush hint", "interleave", or "control region"
table.

>
> After testing on OVMF, pmem driver can support the region that it doesn't
> assoicate to any NVDIMM mapping. So, treat VCD as pmem is a idea to get
> a pmem block device that it containts iso.
>
> v2
> Removed the code for setting VCD to a read-only region.
>
> Cc: Gary Lin <GLin@suse.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Linda Knippers <linda.knippers@hpe.com>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  drivers/acpi/nfit.c          |  8 +++++++-
>  drivers/nvdimm/region_devs.c | 26 +++++++++++++++++++++++++-
>  include/linux/libnvdimm.h    |  2 ++
>  3 files changed, 34 insertions(+), 2 deletions(-)
>

I don't think we need "nd_vcd_device_type".  I think this patch can
just be reduced to:

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 32579a7b71d5..d289e772c20a 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1948,6 +1948,7 @@ static int acpi_nfit_init_mapping(struct
acpi_nfit_desc *acpi_desc,
        nd_mapping->nvdimm = nvdimm;
        switch (nfit_spa_type(spa)) {
        case NFIT_SPA_PM:
+       case NFIT_SPA_VCD:
        case NFIT_SPA_VOLATILE:
                nd_mapping->start = memdev->address;
                nd_mapping->size = memdev->region_size;
