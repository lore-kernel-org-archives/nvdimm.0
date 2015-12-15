Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1450202219.29051.30.camel@hpe.com>
References: <1450198746-14161-1-git-send-email-toshi.kani@hpe.com>
	<CAPcyv4i_uRBsceQ1bqd02orKwZ47qB_ggwRQFL0HQ0x=w1DPfQ@mail.gmail.com>
	<1450201779.29051.28.camel@hpe.com>
	<CAPcyv4iC+UXptC5OJ21SyGuVhiOyHAq6dRT5v3dn_J0+6ySe2A@mail.gmail.com>
	<1450202219.29051.30.camel@hpe.com>
Date: Tue, 15 Dec 2015 10:05:22 -0800
Message-ID: <CAPcyv4iuMDgQbKtt2Gy_VEdATKEFxN4M1hUn7n6sDDYoRMJKyw@mail.gmail.com>
Subject: Re: [PATCH RESEND] ACPI/Kconfig: Make ACPI_NFIT depend on EFI_STUB on X86
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 15, 2015 at 9:56 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> On Tue, 2015-12-15 at 09:53 -0800, Dan Williams wrote:
[..]
>> > > > diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
>> > > > index 5eef4cb..5368baa 100644
>> > > > --- a/drivers/acpi/Kconfig
>> > > > +++ b/drivers/acpi/Kconfig
>> > > > @@ -441,6 +441,7 @@ config ACPI_NFIT
>> > > >         depends on PHYS_ADDR_T_64BIT
>> > > >         depends on BLK_DEV
>> > > >         depends on ARCH_HAS_MMIO_FLUSH
>> > > > +       depends on !X86 || (X86 && EFI_STUB)
>> > > >         select LIBNVDIMM
>> > > >         help
>> > > >           Infrastructure to probe ACPI 6 compliant platforms for
>> > >
>> > > This seems wrong to me.
>> > >
>> > > In general Kconfig "depends on" are only about compile-time code
>> > > dependency, not about working around random bugs in external
>> > > projects.
>> >
>> > I agree that they do not have a compile dependency, and it looks rather
>> > odd.  On the other hand, proper support of the ACPI NFIT extensions has
>> > a
>> > functional dependency to setup_e820() as this is the only code that can
>> > handle the EFI_PERSISTENT_MEMORY type today.
>>
>> What about non-EFI/legeacy-boot systems that only emit e820-type-7?
>> We lose support for them with this patch, right?
>
> No, having EFI_STUB does not break the legacy BIOS boot.
>

Sorry let me clarify.  A kernel compiled without EFI_STUB loses NFIT
support.  Non-EFI and legacy-boot systems don't have this grub bug to
worry about, so the dependency is overly restrictive, "breaks", those
environments.
