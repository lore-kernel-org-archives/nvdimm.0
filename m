Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1450202219.29051.30.camel@hpe.com>
Subject: Re: [PATCH RESEND] ACPI/Kconfig: Make ACPI_NFIT depend on EFI_STUB
 on X86
From: Toshi Kani <toshi.kani@hpe.com>
Date: Tue, 15 Dec 2015 10:56:59 -0700
In-Reply-To: <CAPcyv4iC+UXptC5OJ21SyGuVhiOyHAq6dRT5v3dn_J0+6ySe2A@mail.gmail.com>
References: <1450198746-14161-1-git-send-email-toshi.kani@hpe.com>
	 <CAPcyv4i_uRBsceQ1bqd02orKwZ47qB_ggwRQFL0HQ0x=w1DPfQ@mail.gmail.com>
	 <1450201779.29051.28.camel@hpe.com>
	 <CAPcyv4iC+UXptC5OJ21SyGuVhiOyHAq6dRT5v3dn_J0+6ySe2A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2015-12-15 at 09:53 -0800, Dan Williams wrote:
> On Tue, Dec 15, 2015 at 9:49 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> > On Tue, 2015-12-15 at 09:21 -0800, Dan Williams wrote:
> > > On Tue, Dec 15, 2015 at 8:59 AM, Toshi Kani <toshi.kani@hpe.com>
> > > wrote:
> > > > ACPI 6.0 defines NFIT table and new persistent memory types for
> > > > EFI memory table (EFI_PERSISTENT_MEMORY) and e820 table
> > > > (E820_PMEM).
> > > > 
> > > > setup_e820() enabled by EFI_STUB converts EFI_PERSISTENT_MEMORY to
> > > > E820_PMEM for the e820_map table on x86 EFI platforms.  When
> > > > EFI_STUB
> > > > is disabled, x86 kernels rely on the bootloader to perform this
> > > > conversion.
> > > > 
> > > > It was found that the upstream grub bootloader since 2012 has a bug
> > > > that converts EFI_PERSISTENT_MEMORY (or any new type) to E820_RAM,
> > > > which causes the kernel to use persistent memory ranges as regular
> > > > memory and corrupts the data in NVDIMM.
> > > > 
> > > > Therefore, this patch sets ACPI_NFIT to depend on EFI_STUB on x86.
> > > > This assures that ACPI_NFIT kernels are self-contained and are
> > > > protected from the upstream grub bug on x86.
> > > > 
> > > > Note, X86_PMEM_LEGACY allows the kernel to use the pmem driver on
> > > > pre-ACPI 6.0 platforms, and does not require ACPI_NFIT enabled.
> > > > 
> > > > References:
> > > > http://www.mail-archive.com/grub-devel@gnu.org/msg23961.html
> > > > Reported-by: Robert Elliott <elliott@hpe.com>
> > > > Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> > > > Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > ---
> > > >  drivers/acpi/Kconfig |    1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> > > > index 5eef4cb..5368baa 100644
> > > > --- a/drivers/acpi/Kconfig
> > > > +++ b/drivers/acpi/Kconfig
> > > > @@ -441,6 +441,7 @@ config ACPI_NFIT
> > > >         depends on PHYS_ADDR_T_64BIT
> > > >         depends on BLK_DEV
> > > >         depends on ARCH_HAS_MMIO_FLUSH
> > > > +       depends on !X86 || (X86 && EFI_STUB)
> > > >         select LIBNVDIMM
> > > >         help
> > > >           Infrastructure to probe ACPI 6 compliant platforms for
> > > 
> > > This seems wrong to me.
> > > 
> > > In general Kconfig "depends on" are only about compile-time code
> > > dependency, not about working around random bugs in external
> > > projects.
> > 
> > I agree that they do not have a compile dependency, and it looks rather
> > odd.  On the other hand, proper support of the ACPI NFIT extensions has
> > a
> > functional dependency to setup_e820() as this is the only code that can
> > handle the EFI_PERSISTENT_MEMORY type today.
> 
> What about non-EFI/legeacy-boot systems that only emit e820-type-7?
> We lose support for them with this patch, right?

No, having EFI_STUB does not break the legacy BIOS boot.

Thanks,
-Toshi

