Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 00/20] libnd: non-volatile memory device support
Date: Wed, 29 Apr 2015 02:25:04 +0200
Message-ID: <2127273.OhQ7MIpEUu@vostro.rjw.lan>
In-Reply-To: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Boaz Harrosh <boaz@plexistor.com>, Neil Brown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, Christoph Hellwig <hch@lst.de>, linux-acpi@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tuesday, April 28, 2015 02:24:12 PM Dan Williams wrote:
> Changes since v1 [1]: Incorporates feedback received prior to April 24.
> 
> 1/ Ingo said [2]:
> 
>        "So why on earth is this whole concept and the naming itself
>        ('drivers/block/nd/' stands for 'NFIT Defined', apparently)
>        revolving around a specific 'firmware' mindset and revolving
>        around specific, weirdly named, overly complicated looking
>        firmware interfaces that come with their own new weird
>        glossary??"
> 
>    Indeed, we of course consulted the NFIT specification to determine
>    the shape of the sub-system, but then let its terms and data
>    structures permeate too deep into the implementation.  That is fixed
>    now with all NFIT specifics factored out into acpi.c.  The NFIT is no
>    longer required reading to review libnd.  Only three concepts are
>    needed:
> 
>       i/ PMEM - contiguous memory range where cpu stores are
> 	 persistent once they are flushed through the memory
>          controller.
> 
>      ii/ BLK - mmio apertures (sliding windows) that can be
> 	 programmed to access an aperture's-worth of persistent
>          media at a time.
> 
>     iii/ DPA - "dimm-physical-address", address space local to a
> 	 dimm.  A dimm may provide both PMEM-mode and BLK-mode
> 	 access to a range of DPA.  libnd manages allocation of DPA
>          to either PMEM or BLK-namespaces to resolve this aliasing. 
> 
>    The v1..v2 diffstat below shows the migration of nfit-specifics to
>    acpi.c and the new state of libnd being nfit-free.  "nd" now only
>    refers to "non-volatile devices".  Note, reworked documentation will
>    return once the review has settled.
> 
>    Documentation/blockdev/nd.txt     |  867 ---------------------
>    MAINTAINERS                       |   34 +-
>    arch/ia64/kernel/efi.c            |    5 +-
>    arch/x86/kernel/e820.c            |   11 +-
>    arch/x86/kernel/pmem.c            |    2 +-
>    drivers/block/Makefile            |    2 +-
>    drivers/block/nd/Kconfig          |  135 ++--
>    drivers/block/nd/Makefile         |   32 +-
>    drivers/block/nd/acpi.c           | 1506 +++++++++++++++++++++++++++++++------
>    drivers/block/nd/acpi_nfit.h      |  321 ++++++++
>    drivers/block/nd/blk.c            |   27 +-
>    drivers/block/nd/btt.c            |    6 +-
>    drivers/block/nd/btt_devs.c       |    8 +-
>    drivers/block/nd/bus.c            |  337 +++++----
>    drivers/block/nd/core.c           |  574 +-------------
>    drivers/block/nd/dimm.c           |   11 -
>    drivers/block/nd/dimm_devs.c      |  292 ++-----
>    drivers/block/nd/e820.c           |  100 +++
>    drivers/block/nd/libnd.h          |  122 +++
>    drivers/block/nd/namespace_devs.c |   10 +-
>    drivers/block/nd/nd-private.h     |  107 +--
>    drivers/block/nd/nd.h             |   91 +--
>    drivers/block/nd/nfit.h           |  238 ------
>    drivers/block/nd/pmem.c           |   56 +-
>    drivers/block/nd/region.c         |   78 +-
>    drivers/block/nd/region_devs.c    |  783 +++----------------
>    drivers/block/nd/test/iomap.c     |   86 +--
>    drivers/block/nd/test/nfit.c      | 1115 +++++++++++++++------------
>    drivers/block/nd/test/nfit_test.h |   15 +-
>    include/uapi/linux/ndctl.h        |  130 ++--
>    30 files changed, 3166 insertions(+), 3935 deletions(-)
>    delete mode 100644 Documentation/blockdev/nd.txt
>    create mode 100644 drivers/block/nd/acpi_nfit.h
>    create mode 100644 drivers/block/nd/e820.c
>    create mode 100644 drivers/block/nd/libnd.h
>    delete mode 100644 drivers/block/nd/nfit.h
> 
>    [1]: https://lists.01.org/pipermail/linux-nvdimm/2015-April/000484.html
>    [2]: https://lists.01.org/pipermail/linux-nvdimm/2015-April/000520.html
> 
> 2/ Christoph asked the pmem ida conversion to be moved to its own patch
>    (done), and to consider leaving the current pmem.c in drivers/block/.
>    Instead, I converted the e820-type-12 enabling to be the first
>    non-ACPI-NFIT based consumer of libnd.  The new nd_e820 driver simply
>    registers e820-type-12 ranges as libnd PMEM regions.  Among other
>    things this conversion enables BTT for these ranges.  The alternative
>    is to move drivers/block/nd/nd.h internals out to include/linux/
>    which I think is worse.
> 
> 3/ Toshi reported that the NFIT parsing fails to handle the case of a
>    PMEM range with a single-dimm (non-aliasing) interleave description.
>    Support for this case was added and is tested by default by the
>    nfit_test.1 configuration.
> 
> 4/ Toshi reported that we should not be treating a missing _STA property
>    as a "dimm disabled by firmware" case.  (fixed).
> 
> 5/ Christoph noted that ND_ARCH_HAS_IOREMAP_CACHE needs to be moved to
>    arch code.  It is gone for now and we'll revisit when adding cached
>    mappings back to the PMEM driver.
> 
> 6/ Toshi mentioned that the presence of two different nd_bus_probe()
>    functions was confusing.  (cleaned up).
> 
> 7/ Robert asked for s/btt_checksum/nd_btt_checksum/ (done).
> 
> 8/ Linda asked for nfit_test to honor dynamic cma reservations via the
>    cma= command line (done).  The cma requirements have also been
>    reduced to 128M as only the simulated DAX regions need CMA.  The rest
>    can use vmalloc().
> 
> ---
> 
> Available here:
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm nd-v2
> 
> ---
> 
> Dan Williams (18):
>       e820, efi: add ACPI 6.0 persistent memory types
>       libnd, nd_acpi: initial libnd infrastructure and NFIT support
>       nd_acpi, nfit-test: manufactured NFITs for interface development
>       libnd: ndctl class device, and nd bus attributes
>       libnd, nd_acpi: dimm/memory-devices
>       libnd: ndctl.h, the nd ioctl abi
>       libnd, nd_dimm: dimm driver and base libnd device-driver infrastructure
>       libnd, nd_acpi: regions (block-data-window, persistent memory, volatile memory)
>       libnd: support for legacy (non-aliasing) nvdimms
>       pmem: use ida
>       libnd, nd_pmem: add libnd support to the pmem driver
>       libnd, nd_acpi: add interleave-set state-tracking infrastructure
>       libnd: namespace indices: read and validate
>       libnd: pmem label sets and namespace instantiation.
>       libnd: blk labels and namespace instantiation
>       libnd: write pmem label set
>       libnd: write blk label set
>       libnd: infrastructure for btt devices
> 
> Ross Zwisler (1):
>       libnd, nd_acpi, nd_blk: driver for BLK-mode access persistent memory
> 
> Vishal Verma (1):
>       nd_btt: atomic sector updates

I'm wondering what's wrong with CCing all of the series to linux-acpi?

Is there anything in it that the people on that list should not see, by any
chance?

Like patch [01/20], for the most obvious example.  It even has "ACPI 6" in the
subject ...

Rafael

