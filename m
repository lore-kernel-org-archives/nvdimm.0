Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 18 Dec 2015 13:27:51 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: arm64/efi handling of persistent memory
Message-ID: <20151218132751.GD2638@codeblueprint.co.uk>
References: <94D0CD8314A33A4D9D801C0FE68B40295BEBD864@G9W0745.americas.hpqcorp.net>
 <20151218110651.GL25034@bivouac.eciton.net>
 <20151218115224.GE29219@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151218115224.GE29219@leverpostej>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "Kani, Toshimitsu" <toshi.kani@hpe.com>, "Knippers, Linda" <linda.knippers@hpe.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 18 Dec, at 11:52:24AM, Mark Rutland wrote:
> On Fri, Dec 18, 2015 at 11:06:51AM +0000, Leif Lindholm wrote:
> > On Fri, Dec 18, 2015 at 01:33:25AM +0000, Elliott, Robert (Persistent Memory) wrote:
> > > Similar to the questions about the arm64 efi boot stub
> > > handing persistent memory, some of the arm64 kernel code 
> > > looks fishy.
> 
> [...]
> 
> > > 2. is_reserve_region() treating EFI_PERSISTENT_MEMORY the same
> > > as EFI_CONVENTIONAL_MEMORY looks wrong.
> > 
> > Yeah... That one was introduced by
> > ad5fb870c486 ("e820, efi: add ACPI 6.0 persistent memory types")
> > without any ACKs from ARM people :/
> 
> Do we need to do anythign to avoid his kind of thing in future? e.g. a
> MAINTAINERS patch for the ARM EFI bits?
> 
> Or do we just need to pay attention to linux-efi?

It never hit linux-efi, and I wasn't Cc'd, which means the entries
that do exist in MAINTAINERS were ignored anyway.

Because what would usually happens in that situation is that I would
ask ARM people to chime in.

It looks like all the NVDIMM changes came via Dan's nvdimm tree.
