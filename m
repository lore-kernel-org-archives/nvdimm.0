Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.nue.novell.com (smtp.nue.novell.com [195.135.221.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 905241A1E01
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 16:10:19 -0700 (PDT)
Date: Tue, 28 Jun 2016 07:09:26 +0800
From: joeyli <jlee@suse.com>
Subject: Re: [PATCH v3] acpi, nfit: treat volatile virtual CD region as pmem
Message-ID: <20160627230926.GL3573@linux-rxt1.site>
References: <1467009960-20580-1-git-send-email-jlee@suse.com>
 <CAPcyv4hknQyYAT3PjsLTuPEwd=+ZbkF6ndsVJaG28TUPwJVxzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hknQyYAT3PjsLTuPEwd=+ZbkF6ndsVJaG28TUPwJVxzQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Lee,
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 27, 2016 at 10:34:32AM -0700, Dan Williams wrote:
> On Sun, Jun 26, 2016 at 11:46 PM, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> > This patch adds logic to treat volatile virtual CD region as pmem
> > region, then /dev/pmem* device can be mounted with iso9660.
> >
> > It's useful to work with the httpboot in EFI firmware to pull a remote
> > ISO file to the local memory region for booting and installation.
> >
> > Wiki page of UEFI HTTPBoot with OVMF:
> >         https://en.opensuse.org/UEFI_HTTPBoot_with_OVMF
> >
> > The ramdisk function in EDK2/OVMF generates a ACPI0012 root device that
> > it contains empty _STA but without _DSM:
> >
> > DefinitionBlock ("ssdt2.aml", "SSDT", 2, "INTEL ", "RamDisk ", 0x00001000)
> > {
> >     Scope (\_SB)
> >     {
> >         Device (NVDR)
> >         {
> >             Name (_HID, "ACPI0012")  // _HID: Hardware ID
> >             Name (_STR, Unicode ("NVDIMM Root Device"))  // _STR: Description String
> >             Method (_STA, 0, NotSerialized)  // _STA: Status
> >             {
> >                 Return (0x0F)
> >             }
> >         }
> >     }
> > }
> >
> > In section 5.2.25.2 of ACPI 6.1 spec, it mentions that the "SPA Range
> > Structure Index" of VCD SPA shall be set to zero. That means VCD SPA
> > will not be associated by any NVDIMM region mapping.
> >
> > The VCD's SPA Range Structure in NFIT is similar to virtual disk region
> > as following:
> >
> > [028h 0040   2]                Subtable Type : 0000 [System Physical Address Range]
> > [02Ah 0042   2]                       Length : 0038
> >
> > [02Ch 0044   2]                  Range Index : 0000
> > [02Eh 0046   2]        Flags (decoded below) : 0000
> >                    Add/Online Operation Only : 0
> >                       Proximity Domain Valid : 0
> > [030h 0048   4]                     Reserved : 00000000
> > [034h 0052   4]             Proximity Domain : 00000000
> > [038h 0056  16]           Address Range GUID : 77AB535A-45FC-624B-5560-F7B281D1F96E
> > [048h 0072   8]           Address Range Base : 00000000B6ABD018
> > [050h 0080   8]         Address Range Length : 0000000005500000
> > [058h 0088   8]         Memory Map Attribute : 0000000000000000
> >
> > The way to not associate a SPA range is to never reference it from a "flush hint",
> > "interleave", or "control region" table.
> >
> > After testing on OVMF, pmem driver can support the region that it doesn't
> > assoicate to any NVDIMM mapping. So, treat VCD like pmem is a idea to get
> > a pmem block device that it contains iso.
> >
> > v3:
> > To simplify patch, removed VCD region in libnvdimm.
> >
> > v2:
> > Removed the code for setting VCD to a read-only region.
> >
> > Cc: Gary Lin <GLin@suse.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > Cc: Linda Knippers <linda.knippers@hpe.com>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  drivers/acpi/nfit.c          |  8 +++++++-
> >  drivers/nvdimm/region_devs.c | 26 +++++++++++++++++++++++++-
> >  include/linux/libnvdimm.h    |  2 ++
> >  3 files changed, 34 insertions(+), 2 deletions(-)
> >
> > Index: linux/drivers/acpi/nfit.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/nfit.c
> > +++ linux/drivers/acpi/nfit.c
> > @@ -1995,7 +1995,7 @@ static int acpi_nfit_register_region(str
> >         if (nfit_spa->nd_region)
> >                 return 0;
> >
> > -       if (spa->range_index == 0) {
> > +       if (spa->range_index == 0 && nfit_spa_type(spa) != NFIT_SPA_VCD) {
> >                 dev_dbg(acpi_desc->dev, "%s: detected invalid spa index\n",
> >                                 __func__);
> 
> If we're adding the special casing might as well add it for all
> "virtual spa" tables.  I.e. introduce nfit_spa_is_virtual() and have
> it check for: NFIT_SPA_VDISK, NFIT_SPA_VCD, NFIT_SPA_PDISK, and
> NFIT_SPA_PCD.

Thanks for your suggestion. I will update and send version four.

Joey Lee
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
