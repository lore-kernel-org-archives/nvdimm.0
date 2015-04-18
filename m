Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 00/21] ND: NFIT-Defined / NVDIMM Subsystem
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Apr 2015 21:35:14 -0400
Message-ID: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Boaz Harrosh <boaz@plexistor.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Dave Chinner <david@fromorbit.com>, Robert Moore <robert.moore@intel.com>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, linux-acpi@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Since 2010 Intel has included non-volatile memory support on a few
storage-focused platforms with a feature named ADR (Asynchronous DRAM
Refresh).  These platforms were mostly targeted at custom applications
and never enjoyed standard discovery mechanisms for platform firmware
to advertise non-volatile memory capabilities.  This now changes with
the publication of version 6 of the ACPI specification [1] and its
inclusion of a new table for describing platform memory capabilities.
The NVDIMM Firmware Interface Table (NFIT), along with new EFI and E820
memory types, enumerates persistent memory ranges, memory-mapped-I/O
apertures, physical memory devices (DIMMs), and their associated
properties.

The ND-subsystem wraps a Linux device driver model around the objects
and address boundaries defined in the specification and introduces 3 new
drivers.

  nd_pmem: NFIT enabled version of the existing 'pmem' driver [2]
  nd_blk: mmio aperture method for accessing persistent storage
  nd_btt: give persistent memory disk semantics (atomic sector update)

See the documentation in patch2 for more details, and there is
supplemental documentation on pmem.io [4].  Please review, and
patches welcome...

For kicking the tires, this release is accompanied by a userspace
management library 'ndctl' that includes unit tests (make check) for all
of the kernel ABIs.  The nfit_test.ko module can be used to explore a
sample NFIT topology.

[1]: http://www.uefi.org/sites/default/files/resources/ACPI_6.0.pdf
[2]: https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/log/?h=x86/pmem
[3]: https://github.com/pmem/ndctl
[4]: http://pmem.io/documents/

--
Dan for the NFIT driver development team Andy Rudoff, Matthew Wilcox, Ross
Zwisler, and Vishal Verma


---

Dan Williams (19):
      e820, efi: add ACPI 6.0 persistent memory types
      ND NFIT-Defined/NVIDIMM Subsystem
      nd_acpi: initial core implementation and nfit skeleton
      nd: create an 'nd_bus' from an 'nfit_desc'
      nfit-test: manufactured NFITs for interface development
      nd: ndctl class device, and nd bus attributes
      nd: dimm devices (nfit "memory-devices")
      nd: ndctl.h, the nd ioctl abi
      nd_dimm: dimm driver and base nd-bus device-driver infrastructure
      nd: regions (block-data-window, persistent memory, volatile memory)
      nd_region: support for legacy nvdimms
      nd_pmem: add NFIT support to the pmem driver
      nd: add interleave-set state-tracking infrastructure
      nd: namespace indices: read and validate
      nd: pmem label sets and namespace instantiation.
      nd: blk labels and namespace instantiation
      nd: write pmem label set
      nd: write blk label set
      nd: infrastructure for btt devices

Ross Zwisler (1):
      nd_blk: nfit blk driver

Vishal Verma (1):
      nd_btt: atomic sector updates


 Documentation/blockdev/btt.txt    |  273 ++++++
 Documentation/blockdev/nd.txt     |  867 +++++++++++++++++++
 MAINTAINERS                       |   34 +
 arch/arm64/kernel/efi.c           |    1 
 arch/ia64/kernel/efi.c            |    1 
 arch/x86/boot/compressed/eboot.c  |    4 
 arch/x86/include/uapi/asm/e820.h  |    1 
 arch/x86/kernel/e820.c            |   25 -
 arch/x86/platform/efi/efi.c       |    3 
 drivers/block/Kconfig             |   13 
 drivers/block/Makefile            |    2 
 drivers/block/nd/Kconfig          |  130 +++
 drivers/block/nd/Makefile         |   39 +
 drivers/block/nd/acpi.c           |  443 ++++++++++
 drivers/block/nd/blk.c            |  269 ++++++
 drivers/block/nd/btt.c            | 1423 +++++++++++++++++++++++++++++++
 drivers/block/nd/btt.h            |  185 ++++
 drivers/block/nd/btt_devs.c       |  443 ++++++++++
 drivers/block/nd/bus.c            |  703 +++++++++++++++
 drivers/block/nd/core.c           |  963 +++++++++++++++++++++
 drivers/block/nd/dimm.c           |  126 +++
 drivers/block/nd/dimm_devs.c      |  701 +++++++++++++++
 drivers/block/nd/label.c          |  925 ++++++++++++++++++++
 drivers/block/nd/label.h          |  143 +++
 drivers/block/nd/namespace_devs.c | 1697 +++++++++++++++++++++++++++++++++++++
 drivers/block/nd/nd-private.h     |  203 ++++
 drivers/block/nd/nd.h             |  310 +++++++
 drivers/block/nd/nfit.h           |  238 +++++
 drivers/block/nd/pmem.c           |  122 ++-
 drivers/block/nd/region.c         |   95 ++
 drivers/block/nd/region_devs.c    | 1196 ++++++++++++++++++++++++++
 drivers/block/nd/test/Makefile    |    5 
 drivers/block/nd/test/iomap.c     |  199 ++++
 drivers/block/nd/test/nfit.c      | 1018 ++++++++++++++++++++++
 drivers/block/nd/test/nfit_test.h |   37 +
 include/linux/efi.h               |    3 
 include/linux/nd.h                |   98 ++
 include/uapi/linux/Kbuild         |    1 
 include/uapi/linux/ndctl.h        |  199 ++++
 39 files changed, 13102 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/blockdev/btt.txt
 create mode 100644 Documentation/blockdev/nd.txt
 create mode 100644 drivers/block/nd/Kconfig
 create mode 100644 drivers/block/nd/Makefile
 create mode 100644 drivers/block/nd/acpi.c
 create mode 100644 drivers/block/nd/blk.c
 create mode 100644 drivers/block/nd/btt.c
 create mode 100644 drivers/block/nd/btt.h
 create mode 100644 drivers/block/nd/btt_devs.c
 create mode 100644 drivers/block/nd/bus.c
 create mode 100644 drivers/block/nd/core.c
 create mode 100644 drivers/block/nd/dimm.c
 create mode 100644 drivers/block/nd/dimm_devs.c
 create mode 100644 drivers/block/nd/label.c
 create mode 100644 drivers/block/nd/label.h
 create mode 100644 drivers/block/nd/namespace_devs.c
 create mode 100644 drivers/block/nd/nd-private.h
 create mode 100644 drivers/block/nd/nd.h
 create mode 100644 drivers/block/nd/nfit.h
 rename drivers/block/{pmem.c => nd/pmem.c} (68%)
 create mode 100644 drivers/block/nd/region.c
 create mode 100644 drivers/block/nd/region_devs.c
 create mode 100644 drivers/block/nd/test/Makefile
 create mode 100644 drivers/block/nd/test/iomap.c
 create mode 100644 drivers/block/nd/test/nfit.c
 create mode 100644 drivers/block/nd/test/nfit_test.h
 create mode 100644 include/linux/nd.h
 create mode 100644 include/uapi/linux/ndctl.h
