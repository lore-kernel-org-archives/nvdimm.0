Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1455316203.2925.132.camel@hpe.com>
References: <1454439311-23690-1-git-send-email-toshi.kani@hpe.com>
	<1454439311-23690-4-git-send-email-toshi.kani@hpe.com>
	<CAPcyv4ik0GRYkYdaKvu4rPC9a+Q-e93uCZMpx1W8=Cvwwdh6jw@mail.gmail.com>
	<1455316203.2925.132.camel@hpe.com>
Date: Fri, 12 Feb 2016 15:32:18 -0800
Message-ID: <CAPcyv4i=TpX=V6mN0zrsqvUyonKY1WkbP=wJ0QqjQtj_kiSJQw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ACPI: Change NFIT driver to set PMEM type to iomem entry
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 12, 2016 at 2:30 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> On Fri, 2016-02-12 at 11:41 -0800, Dan Williams wrote:
>> On Tue, Feb 2, 2016 at 10:55 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
>> > Change acpi_nfit_register_region() to call iomem_set_desc() with
>> > IORES_DESC_PERSISTENT_MEMORY for NFIT_SPA_PM ranges found in ACPI
>> > NFIT table.
>> >
>> > When FW sets E820_PMEM in e820 and EFI_PERSISTENT_MEMORY in EFI,
>> > this code simply sets PMEM type again to "Persistent Memory" entries
>> > in the iomem table.  When FW sets reserved type for persistent
>> > memory ranges, it sets PMEM type to "reserved" entries covering
>> > PMEM ranges.
>> >
>> > This allows the EINJ driver, which calls region_intersects() with
>> > IORES_DESC_PERSISTENT_MEMORY to check persistent memory ranges,
>> > to work continuously even if FW sets reserved type to persistent
>> > memory in e820 and EFI.
>> >
>> > Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
>> > Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
>> > Cc: Dan Williams <dan.j.williams@intel.com>
>> > Cc: Ingo Molnar <mingo@kernel.org>
>> > Cc: Borislav Petkov <bp@suse.de>
>> > Cc: Andrew Morton <akpm@linux-foundation.org>
>> > ---
>> >  drivers/acpi/nfit.c |    6 ++++++
>> >  1 file changed, 6 insertions(+)
>> >
>> > diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
>> > index ad6d8c6..add04f0 100644
>> > --- a/drivers/acpi/nfit.c
>> > +++ b/drivers/acpi/nfit.c
>> > @@ -1781,6 +1781,12 @@ static int acpi_nfit_register_region(struct
>> > acpi_nfit_desc *acpi_desc,
>> >
>> >         nvdimm_bus = acpi_desc->nvdimm_bus;
>> >         if (nfit_spa_type(spa) == NFIT_SPA_PM) {
>> > +               rc = iomem_set_desc(spa->address, spa->length,
>> > +                                       IORES_DESC_PERSISTENT_MEMORY);
>> > +               if (rc)
>> > +                       dev_dbg(acpi_desc->dev,
>> > +                               "error setting iomem desc: %d\n", rc);
>> > +
>>
>> Hmm, if we set the type on driver load, should we clear the type on
>> driver unload?
>
> I think this type update should stay for the life-cycle of this iomem entry
> itself since this range is PMEM even after the driver is unloaded.  This is
> an extension of the boot-time iomem table initialization from e820/EFI,
> which allows ACPI to set a correct type.  This is independent from driver's
> resource allocations.
>
>> Actually it might be more straightforward to specify a type at
>> request_region() time.  That way it gets released at release_region().
>> We're already setting a resource name at request_region time, adding a
>> type annotation at the time seems appropriate.
>
> I first considered simply setting "namespaceX.X" as PMEM.  However,
> region_intersects() and its friends only check the top-level entries, not
> their children, of the iomem table.  And I think a child should have the
> same type as the parent as I fixed it in patch 1/3.

Did we investigate updating region_intersects() to check children?
When a child sub-divides a region with different types it may be the
wrong answer to check the parent.  Is there a problem with moving
checking to the child?
