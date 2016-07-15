Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 082B31A1F00
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jul 2016 22:25:21 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id w18so148921781oiw.3
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jul 2016 22:24:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1468555535-30902-1-git-send-email-jlee@suse.com>
References: <1468555535-30902-1-git-send-email-jlee@suse.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Jul 2016 22:24:32 -0700
Message-ID: <CAPcyv4hg=CGMCopRnxNdB33yJ0E9qpyyYQUix0yh2KtS_kFzgw@mail.gmail.com>
Subject: Re: [PATCH v4] acpi, nfit: treat virtual ramdisk SPA as pmem region
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Lee, Chun-Yi  <jlee@suse.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Gary Lin" <GLin@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 14, 2016 at 9:05 PM, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> This patch adds logic to treat virtual ramdisk SPA as pmem region, then
> ramdisk's /dev/pmem* device can be mounted with iso9660.
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
> Structure Index" of virtual SPA shall be set to zero. That means virtual SPA
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
> The way to not associate a SPA range is to never reference it from a "flush hint",
> "interleave", or "control region" table.
>
> After testing on OVMF, pmem driver can support the region that it doesn't
> assoicate to any NVDIMM mapping. So, treat VCD like pmem is a idea to get
> a pmem block device that it contains iso.
>
> v4:
> Instoduce nfit_spa_is_virtual() to check virtual ramdisk SPA and create
> pmem region.
>
> v3:
> To simplify patch, removed useless VCD region in libnvdimm.
>
> v2:
> Removed the code for setting VCD to a read-only region.
>
> Cc: Gary Lin <GLin@suse.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Linda Knippers <linda.knippers@hpe.com>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>

Applied, thanks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
