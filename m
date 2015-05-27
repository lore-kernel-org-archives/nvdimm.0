Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [GIT PULL v4 00/21] libnd: non-volatile memory device support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 May 2015 18:24:42 -0400
Message-ID: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Boaz Harrosh <boaz@plexistor.com>, neilb@suse.de, Dave Chinner <david@fromorbit.com>, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, hch@lst.de, sfr@canb.auug.org.au, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Jens, please pull from...

   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm tags/libnd-for-jens

...to receive the libnd sub-system for the next merge window.  This has
been through 3 rounds of review.  Incremental diffstats and links to
previous postings:

v1: 39 files changed, 13102 insertions(+), 36 deletions(-)
    https://lists.01.org/pipermail/linux-nvdimm/2015-April/000484.html

v2: 30 files changed, 3166 insertions(+), 3935 deletions(-)
    https://lists.01.org/pipermail/linux-nvdimm/2015-April/000574.html

v3: 33 files changed, 2202 insertions(+), 1233 deletions(-)
    https://lists.01.org/pipermail/linux-nvdimm/2015-May/000804.html

v4: Full diffstat since v3

    Documentation/blockdev/libnd.txt  |   2 +-
    arch/x86/Kconfig                  |   4 ++
    arch/x86/kernel/pmem.c            |  92 +++++++++++++++++++++++------------
    drivers/acpi/nfit.c               |  20 ++++----
    drivers/acpi/nfit.h               |   4 +-
    drivers/block/Kconfig             |   8 ---
    drivers/block/Makefile            |   1 -
    drivers/block/e820_pmem.c         | 100 --------------------------------------
    drivers/block/nd/Kconfig          |  10 ++++
    drivers/block/nd/btt.h            |   2 +-
    drivers/block/nd/namespace_devs.c |   5 +-
    drivers/block/nd/pmem.c           |   2 +-
    drivers/block/nd/test/nfit.c      |  10 ++--
    include/acpi/acuuid.h             |  16 +++---
    14 files changed, 105 insertions(+), 171 deletions(-)
    delete mode 100644 drivers/block/e820_pmem.c

    1/ Kill drivers/block/e820_pmem.c, we can just register pmem
       regions directly from arch/x86/kernel/pmem.c without need for an
       intermediary driver (Christoph).

    2/ Update to latest NFIT UUID definitions (Toshi).  This
       merges cleanly with, and is identical to the include/acpi/
       NFIT enabling in Rafael's linux-pm.git/bleeding-edge branch.

    3/ Fix up some miscellaneous checkpatch issues (Robert).

This branch has passed a full run through Fengguang's 0-day-kbuild-robot
with no outstanding reports, and it passes* our unit tests defined in
the ndctl repo (https://github.com/pmem/ndctl).  As you can see the
magnitude of the review feedback has dropped off precipitously so I feel
confident in recommending this branch as a merge candidate.  Some
general notes and credits appear in the tag-message below.

Thanks Jens!

* We have a handful of minor features pending behind this release that
  are exercised in the latest unit tests.  However, these patches have
  been held back to save the libnd review effort from chasing a moving
  target.

===

The following changes since commit 4c1eaa2344fb26bb5e936fb4d8ee307343ea0089:

  drivers/block/pmem: Fix 32-bit build warning in pmem_alloc() (2015-04-01 17:03:57 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm tags/libnd-for-jens

for you to fetch changes up to dbcc765a7830454abb78e5352147324605455116:

  libnd: Non-Volatile Devices (2015-05-27 02:48:52 -0400)

----------------------------------------------------------------
Initial LIBND submission

The LIBND sub-system provides generic support for non-volatile memory
devices.  It extends the kernel's existing X86_PMEM_LEGACY support to also
enable devices that conform to the NVDIMM Firmware Interface Table (NFIT)
specification published with ACPI 6 (http://www.uefi.org/specifications).
NFIT describes devices that may include both a BLK (mmio aperture I/O)
mode of operation as well as PMEM (direct cpu load/store to a persistent
memory range).  In addition to the generic LIBND bus driver implementation
and the I/O drivers (BLK and PMEM), a driver for layering atomic sector
update semantics on top of byte-addressable-memory, BTT, is also included.
See Documentation/blockdev/libnd.txt and Documentation/blockdev/btt.txt
for more details.

Thanks to: Ross Zwisler, Jeff Moyer, Vishal Verma, Christoph Hellwig,
Ingo Molnar, Neil Brown, Boaz Harrosh, Robert Elliott, Matthew Wilcox,
Andy Rudoff, Linda Knippers, Toshi Kani, Nicholas Moulin, Rafael
Wysocki, and Bob Moore.

----------------------------------------------------------------
Dan Williams (18):
      e820, efi: add ACPI 6.0 persistent memory types
      libnd, nfit: initial libnd infrastructure and NFIT support
      libnd: control character device and libnd bus sysfs attributes
      libnd, nfit: dimm/memory-devices
      libnd: control (ioctl) messages for libnd bus and dimm devices
      libnd, nd_dimm: dimm driver and base libnd device-driver infrastructure
      libnd, nfit: regions (block-data-window, persistent memory, volatile memory)
      libnd: support for legacy (non-aliasing) nvdimms
      libnd, nd_pmem: add libnd support to the pmem driver
      libnd, nfit: add interleave-set state-tracking infrastructure
      libnd: namespace indices: read and validate
      libnd: pmem label sets and namespace instantiation.
      libnd: blk labels and namespace instantiation
      libnd: write pmem label set
      libnd: write blk label set
      libnd: infrastructure for btt devices
      nfit-test: manufactured NFITs for interface development
      libnd: Non-Volatile Devices

Ross Zwisler (2):
      pmem: Dynamically allocate partition numbers
      libnd, nfit, nd_blk: driver for BLK-mode access persistent memory

Vishal Verma (1):
      nd_btt: atomic sector updates

 Documentation/blockdev/btt.txt    |  273 ++++++
 Documentation/blockdev/libnd.txt  |  804 ++++++++++++++++++
 MAINTAINERS                       |   39 +-
 arch/arm64/kernel/efi.c           |    1 +
 arch/ia64/kernel/efi.c            |    4 +
 arch/x86/Kconfig                  |    4 +
 arch/x86/boot/compressed/eboot.c  |    4 +
 arch/x86/include/uapi/asm/e820.h  |    1 +
 arch/x86/kernel/e820.c            |   28 +-
 arch/x86/kernel/pmem.c            |   92 +-
 arch/x86/platform/efi/efi.c       |    3 +
 drivers/acpi/Kconfig              |   27 +
 drivers/acpi/Makefile             |    1 +
 drivers/acpi/nfit.c               | 1474 ++++++++++++++++++++++++++++++++
 drivers/acpi/nfit.h               |  160 ++++
 drivers/block/Kconfig             |   13 +-
 drivers/block/Makefile            |    2 +-
 drivers/block/nd/Kconfig          |  101 +++
 drivers/block/nd/Makefile         |   29 +
 drivers/block/nd/blk.c            |  252 ++++++
 drivers/block/nd/btt.c            | 1438 +++++++++++++++++++++++++++++++
 drivers/block/nd/btt.h            |  186 ++++
 drivers/block/nd/btt_devs.c       |  443 ++++++++++
 drivers/block/nd/bus.c            |  770 +++++++++++++++++
 drivers/block/nd/core.c           |  472 ++++++++++
 drivers/block/nd/dimm.c           |  115 +++
 drivers/block/nd/dimm_devs.c      |  516 +++++++++++
 drivers/block/nd/label.c          |  922 ++++++++++++++++++++
 drivers/block/nd/label.h          |  143 ++++
 drivers/block/nd/namespace_devs.c | 1702 +++++++++++++++++++++++++++++++++++++
 drivers/block/nd/nd-private.h     |  111 +++
 drivers/block/nd/nd.h             |  257 ++++++
 drivers/block/{ => nd}/pmem.c     |  107 ++-
 drivers/block/nd/region.c         |  189 ++++
 drivers/block/nd/region_devs.c    |  667 +++++++++++++++
 drivers/block/nd/test/Makefile    |    5 +
 drivers/block/nd/test/iomap.c     |  151 ++++
 drivers/block/nd/test/nfit.c      | 1171 +++++++++++++++++++++++++
 drivers/block/nd/test/nfit_test.h |   28 +
 include/acpi/actbl1.h             |  154 ++++
 include/acpi/acuuid.h             |   89 ++
 include/linux/efi.h               |    3 +-
 include/linux/libnd.h             |  129 +++
 include/linux/nd.h                |   98 +++
 include/uapi/linux/Kbuild         |    1 +
 include/uapi/linux/ndctl.h        |  199 +++++
 46 files changed, 13289 insertions(+), 89 deletions(-)
 create mode 100644 Documentation/blockdev/btt.txt
 create mode 100644 Documentation/blockdev/libnd.txt
 create mode 100644 drivers/acpi/nfit.c
 create mode 100644 drivers/acpi/nfit.h
 create mode 100644 drivers/block/nd/Kconfig
 create mode 100644 drivers/block/nd/Makefile
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
 rename drivers/block/{ => nd}/pmem.c (70%)
 create mode 100644 drivers/block/nd/region.c
 create mode 100644 drivers/block/nd/region_devs.c
 create mode 100644 drivers/block/nd/test/Makefile
 create mode 100644 drivers/block/nd/test/iomap.c
 create mode 100644 drivers/block/nd/test/nfit.c
 create mode 100644 drivers/block/nd/test/nfit_test.h
 create mode 100644 include/acpi/acuuid.h
 create mode 100644 include/linux/libnd.h
 create mode 100644 include/linux/nd.h
 create mode 100644 include/uapi/linux/ndctl.h
