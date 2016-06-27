Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.nue.novell.com (smtp.nue.novell.com [195.135.221.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA5891A1E03
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 00:12:29 -0700 (PDT)
Date: Mon, 27 Jun 2016 15:11:42 +0800
From: joeyli <jlee@suse.com>
Subject: Re: [PATCH v2] libnvdimm, nfit: treat volatile virtual CD region as
 pmem
Message-ID: <20160627071142.GK3573@linux-rxt1.site>
References: <1466754710-5948-1-git-send-email-jlee@suse.com>
 <CAPcyv4iFNP8Dj40-i_w_5fiE=zj3SLrkm-2MbxAO6JbKu14i2Q@mail.gmail.com>
 <20160625122154.GJ3573@linux-rxt1.site>
 <CAA9_cmcXv0LBrd5gRwp66dpURf80Z5fdrKTy3ncz1aq4iTV8UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA9_cmcXv0LBrd5gRwp66dpURf80Z5fdrKTy3ncz1aq4iTV8UQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Lee,
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jun 25, 2016 at 09:08:16AM -0700, Dan Williams wrote:
> On Sat, Jun 25, 2016 at 5:21 AM, joeyli <jlee@suse.com> wrote:
> > iOn Fri, Jun 24, 2016 at 10:59:56AM -0700, Dan Williams wrote:
> >> On Fri, Jun 24, 2016 at 12:51 AM, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> >> > This patch adds logic to treat volatile virtual CD region as pmem
> >> > region, then /dev/pmem* device can be mounted with iso9660.
> >> >
> >> > It's useful to work with the httpboot in EFI firmware to pull a remote
> >> > ISO file to the local memory region for booting and installation.
> >> >
> >> > Wiki page of UEFI HTTPBoot with OVMF:
> >> >         https://en.opensuse.org/UEFI_HTTPBoot_with_OVMF
> >> >
> >> > The ramdisk function in EDK2/OVMF generates a ACPI0012 root device that
> >> > it contains empty _STA but without _DSM:
> >> >
> >> > DefinitionBlock ("ssdt2.aml", "SSDT", 2, "INTEL ", "RamDisk ", 0x00001000)
> >> > {
> >> >     Scope (\_SB)
> >> >     {
> >> >         Device (NVDR)
> >> >         {
> >> >             Name (_HID, "ACPI0012")  // _HID: Hardware ID
> >> >             Name (_STR, Unicode ("NVDIMM Root Device"))  // _STR: Description String
> >> >             Method (_STA, 0, NotSerialized)  // _STA: Status
> >> >             {
> >> >                 Return (0x0F)
> >> >             }
> >> >         }
> >> >     }
> >> > }
> >> >
> >> > In section 5.2.25.2 of ACPI 6.1 spec, it mentions that the "SPA Range
> >> > Structure Index" of VCD SPA shall be set to zero. That means VCD SPA
> >> > will not be associated by any NVDIMM region mapping.
> >> >
> >> > The VCD's SPA Range Structure in NFIT is similar to virtual disk region
> >> > as following:
> >> >
> >> > [028h 0040   2]                Subtable Type : 0000 [System Physical Address Range]
> >> > [02Ah 0042   2]                       Length : 0038
> >> >
> >> > [02Ch 0044   2]                  Range Index : 0000
> >> > [02Eh 0046   2]        Flags (decoded below) : 0000
> >> >                    Add/Online Operation Only : 0
> >> >                       Proximity Domain Valid : 0
> >> > [030h 0048   4]                     Reserved : 00000000
> >> > [034h 0052   4]             Proximity Domain : 00000000
> >> > [038h 0056  16]           Address Range GUID : 77AB535A-45FC-624B-5560-F7B281D1F96E
> >> > [048h 0072   8]           Address Range Base : 00000000B6ABD018
> >> > [050h 0080   8]         Address Range Length : 0000000005500000
> >> > [058h 0088   8]         Memory Map Attribute : 0000000000000000
> >> >
> >> > The range index set to zero that means the VCD region not associated by
> >> > any NVDIMM region mapping, and it will not assoicate to "flush hint",
> >> > "interleave" or "control region".
> >>
> >> No, per the spec zero is a reserved value and we should ignore such
> >> SPA tables.  The way to not associate a SPA range is to never
> >> reference it from a "flush hint", "interleave", or "control region"
> >> table.
> >>
> >
> > In 5.2.25.2 section of ACPI 6.1 spec, it mentions:
> >
> > Platform is allowed to implement this structure just to describe system
> > physical address ranges that describe Virtual CD and Virtual Disk. For
> > Virtual CD Region and Virtual Disk Region (both volatile and persistent),
> > the following fields - Proximity Domain, SPA Range Structure Index, Flags, and
> >                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > Address Range Memory Mapping Attribute, are not relevant and shall be set to 0.
> >                                                             ^^^^^^^^^^^^^^^^^^^
> >
> > The above sentences conflict with the "SPA Range Structure Index" description
> > in Table 5-128 because the SPA index _shall_ be set to zero for virtual CD and
> > virtual Disk. Looks the "SPA index" is not really _reserved_.
> 
> If we had multiple VCD regions userspace would benefit from some way
> to the distinguish them which is why sysfs exports the spa range
> index.  If there are no memdev associations the spa range index is
> likely the only identifying attribute we have left.
>

Yes, this is a benefit when using multiple VCD regions. 

Maybe the SPA index of VCD doesn't need to be zero, and it also doesn't need
associated by NVDIMM region mapping. But ACPI spec needs to be changed.

Hi Linda, do you have any opinion for that the VCD SPA index shell be set to zero? 
 
> >
> >> >
> >> > After testing on OVMF, pmem driver can support the region that it doesn't
> >> > assoicate to any NVDIMM mapping. So, treat VCD as pmem is a idea to get
> >> > a pmem block device that it containts iso.
> >> >
> >> > v2
> >> > Removed the code for setting VCD to a read-only region.
> >> >
> >> > Cc: Gary Lin <GLin@suse.com>
> >> > Cc: Dan Williams <dan.j.williams@intel.com>
> >> > Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> >> > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> >> > Cc: Linda Knippers <linda.knippers@hpe.com>
> >> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> >> > ---
> >> >  drivers/acpi/nfit.c          |  8 +++++++-
> >> >  drivers/nvdimm/region_devs.c | 26 +++++++++++++++++++++++++-
> >> >  include/linux/libnvdimm.h    |  2 ++
> >> >  3 files changed, 34 insertions(+), 2 deletions(-)
> >> >
> >>
> >> I don't think we need "nd_vcd_device_type".  I think this patch can
> >> just be reduced to:
> >>
> >> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> >> index 32579a7b71d5..d289e772c20a 100644
> >> --- a/drivers/acpi/nfit.c
> >> +++ b/drivers/acpi/nfit.c
> >> @@ -1948,6 +1948,7 @@ static int acpi_nfit_init_mapping(struct
> >> acpi_nfit_desc *acpi_desc,
> >>         nd_mapping->nvdimm = nvdimm;
> >>         switch (nfit_spa_type(spa)) {
> >>         case NFIT_SPA_PM:
> >> +       case NFIT_SPA_VCD:
> >>         case NFIT_SPA_VOLATILE:
> >>                 nd_mapping->start = memdev->address;
> >>                 nd_mapping->size = memdev->region_size;
> >
> > It does not work.
> >
> > Actually I removed the above code in version two because it useless.
> >
> > VCD SPA should not be referenced by any "NVDIMM Region Mapping Structure",
> > so it does not have any memdev in memdevs list for mapping. That means
> > acpi_nfit_init_mapping() never be called in acpi_nfit_register_region().
> 
> Ah, sorry!  I should probably mock this up in nfit_test before making
> assertions like that.  I still want to find a way to minimize this
> patch and not introduce a new region type, because it just complicates
> the implementation for no discernible benefit.

Thanks for your suggestions. In next version, I will removed the VCD region in
libnvdimm to simplify my patch. Then all changes will only in acpi/nfit.


Thanks a lot!
Joey Lee
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
