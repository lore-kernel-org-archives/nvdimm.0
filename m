Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 00/21] libnd: non-volatile memory device support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 May 2015 16:56:10 -0400
Message-ID: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Boaz Harrosh <boaz@plexistor.com>, neilb@suse.de, Dave Chinner <david@fromorbit.com>, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, hch@lst.de, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v2 [1]:

1/ Rebase on the ACPICA enabling for the NFIT data structures.  The
   ACPICA project owns the definition of ACPI data structures in
   include/acpi/.  This release incorporates the NFIT and UUID definitions
   from ACPICA release R05_15_15 [2]. (Rafael, Bob)

2/ Move the ACPI NFIT driver to drivers/acpi/ (Rafael)

3/ Include documentation of the overall subsystem (Rafael)

4/ Arrange for stable block device names in the case where the platform
   configuration has not changed (Toshi and Robert)

5/ Move test infrastructure to the end of the series (Jeff)

6/ Fix up the Kconfig text for CONFIG_ND_BLK to be more descriptive
   (Andy)

7/ Report and continue upon detecting unknown NFIT tables rather than
   failing (Jeff)

8/ Rename the namespace 'type' attribute to 'nstype' so that lsblk does
   not mistake libnd block devices for scsi disks. (Robert and Christoph)

9/ Convert nd_region_{acquire|release}_lane() to user percpu variable
   infrastructure (Ross)

Thanks for all of the review!

Note, there are incremental changes to address caching, persistent
flushing, queue flags, and expanded sector size support that are
deferred until this base support is cleared to merge.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-April/000574.html
[2]: https://github.com/acpica/acpica/tree/R05_15_15

Here is the diffstat relative to v2:

 Documentation/blockdev/libnd.txt            | 804 ++++++++++++++++++++++++++++
 MAINTAINERS                                 |  39 +-
 arch/ia64/kernel/efi.c                      |   2 +-
 arch/x86/kernel/e820.c                      |   4 +-
 drivers/acpi/Kconfig                        |  27 +
 drivers/acpi/Makefile                       |   1 +
 drivers/{block/nd/acpi.c => acpi/nfit.c}    | 581 ++++++++++----------
 drivers/acpi/nfit.h                         | 160 ++++++
 drivers/block/Kconfig                       |   8 +
 drivers/block/Makefile                      |   1 +
 drivers/block/{nd/e820.c => e820_pmem.c}    |  32 +-
 drivers/block/nd/Kconfig                    |  72 +--
 drivers/block/nd/Makefile                   |  12 -
 drivers/block/nd/acpi_nfit.h                | 321 -----------
 drivers/block/nd/blk.c                      |  20 +-
 drivers/block/nd/btt.c                      |  59 +-
 drivers/block/nd/btt.h                      |   7 +-
 drivers/block/nd/btt_devs.c                 |   2 +-
 drivers/block/nd/bus.c                      |   2 +-
 drivers/block/nd/core.c                     |   9 +-
 drivers/block/nd/dimm_devs.c                |   9 +
 drivers/block/nd/label.c                    |  23 +-
 drivers/block/nd/namespace_devs.c           |  14 +-
 drivers/block/nd/nd-private.h               |   5 +-
 drivers/block/nd/nd.h                       |  18 +-
 drivers/block/nd/pmem.c                     |  25 +-
 drivers/block/nd/region.c                   |  64 ++-
 drivers/block/nd/region_devs.c              |  54 +-
 drivers/block/nd/test/nfit.c                | 794 ++++++++++++++-------------
 drivers/block/nd/test/nfit_test.h           |   2 +
 include/acpi/actbl1.h                       | 154 ++++++
 include/acpi/acuuid.h                       |  89 +++
 {drivers/block/nd => include/linux}/libnd.h |  21 +-
 33 files changed, 2202 insertions(+), 1233 deletions(-)
 create mode 100644 Documentation/blockdev/libnd.txt
 rename drivers/{block/nd/acpi.c => acpi/nfit.c} (69%)
 create mode 100644 drivers/acpi/nfit.h
 rename drivers/block/{nd/e820.c => e820_pmem.c} (69%)
 delete mode 100644 drivers/block/nd/acpi_nfit.h
 create mode 100644 include/acpi/acuuid.h
 rename {drivers/block/nd => include/linux}/libnd.h (81%)

The libndctl changes for these updates are available in ndctl.git:
https://github.com/pmem/ndctl

For this set to move forward it needs acks from ACPI and BLOCK layer
developers.  I am assuming this will ultimately go upstream via the
block tree.  A branch in nvdimm.git will be prepared at the end of the
week to give the pending acks some time to land.  Additional feedback
welcome, and hopefully it can be addressed incrementally from this
baseline going forward, i.e. aiming for inclusion in -next and no more
rebases before the 4.2 merge window opens.

---

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
 Documentation/blockdev/libnd.txt  |  804 +++++++++++++++++
 MAINTAINERS                       |   39 +
 arch/arm64/kernel/efi.c           |    1 
 arch/ia64/kernel/efi.c            |    4 
 arch/x86/boot/compressed/eboot.c  |    4 
 arch/x86/include/uapi/asm/e820.h  |    1 
 arch/x86/kernel/e820.c            |   28 +
 arch/x86/kernel/pmem.c            |    2 
 arch/x86/platform/efi/efi.c       |    3 
 drivers/acpi/Kconfig              |   27 +
 drivers/acpi/Makefile             |    1 
 drivers/acpi/nfit.c               | 1474 ++++++++++++++++++++++++++++++++
 drivers/acpi/nfit.h               |  160 +++
 drivers/block/Kconfig             |   21 
 drivers/block/Makefile            |    3 
 drivers/block/e820_pmem.c         |  100 ++
 drivers/block/nd/Kconfig          |   91 ++
 drivers/block/nd/Makefile         |   29 +
 drivers/block/nd/blk.c            |  252 +++++
 drivers/block/nd/btt.c            | 1438 +++++++++++++++++++++++++++++++
 drivers/block/nd/btt.h            |  186 ++++
 drivers/block/nd/btt_devs.c       |  443 ++++++++++
 drivers/block/nd/bus.c            |  770 +++++++++++++++++
 drivers/block/nd/core.c           |  472 ++++++++++
 drivers/block/nd/dimm.c           |  115 +++
 drivers/block/nd/dimm_devs.c      |  516 +++++++++++
 drivers/block/nd/label.c          |  922 ++++++++++++++++++++
 drivers/block/nd/label.h          |  143 +++
 drivers/block/nd/namespace_devs.c | 1701 +++++++++++++++++++++++++++++++++++++
 drivers/block/nd/nd-private.h     |  111 ++
 drivers/block/nd/nd.h             |  257 ++++++
 drivers/block/nd/pmem.c           |  107 ++
 drivers/block/nd/region.c         |  189 ++++
 drivers/block/nd/region_devs.c    |  667 +++++++++++++++
 drivers/block/nd/test/Makefile    |    5 
 drivers/block/nd/test/iomap.c     |  151 +++
 drivers/block/nd/test/nfit.c      | 1171 +++++++++++++++++++++++++
 drivers/block/nd/test/nfit_test.h |   28 +
 include/acpi/actbl1.h             |  154 +++
 include/acpi/acuuid.h             |   89 ++
 include/linux/efi.h               |    3 
 include/linux/libnd.h             |  129 +++
 include/linux/nd.h                |   98 ++
 include/uapi/linux/Kbuild         |    1 
 include/uapi/linux/ndctl.h        |  199 ++++
 46 files changed, 13324 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/blockdev/btt.txt
 create mode 100644 Documentation/blockdev/libnd.txt
 create mode 100644 drivers/acpi/nfit.c
 create mode 100644 drivers/acpi/nfit.h
 create mode 100644 drivers/block/e820_pmem.c
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
 rename drivers/block/{pmem.c => nd/pmem.c} (70%)
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
