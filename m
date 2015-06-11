Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v6 00/21] libnvdimm: non-volatile memory devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jun 2015 16:09:57 -0400
Message-ID: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Boaz Harrosh <boaz@plexistor.com>, rafael@kernel.org, neilb@suse.de, Dave Chinner <david@fromorbit.com>, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, hch@lst.de, sfr@canb.auug.org.au, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, axboe@kernel.dk, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, linux-api@vger.kernel.org, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

A new sub-system in support of non-volatile memory storage devices.  See
"[PATCH v6 21/21] libnvdimm: Non-Volatile Devices" for an overview.

Changes since v5 [1]:

1/ Add rationale/justification to the changelog for "[PATCH v6 20/21]
   tools/testing/nvdimm: libnvdimm unit test infrastructure".  Explain
   why QEMU is not suitable. (Christoph)

2/ Expand the changelog of "[PATCH v6 18/21] nd_btt: atomic sector
   updates" to give the reasoning behind architecture decisions related
   to scaling. (Christoph)

3/ Introduce ->rw_bytes() to struct block_device_operations and kill off
   the "ndio" implementation (save a couple hundred lines of glue code).
   (Christoph)

4/ Kill usage of __iomem in the namespace label implementation in favor
   of properly using byte-order helpers. (Christoph)

5/ Kill the include path munging in "[PATCH v6 20/21]
   tools/testing/nvdimm: libnvdimm unit test infrastructure" this makes
   the unit test implementation have near zero impact on the libnvdimm
   code base. (Christoph)

6/ Miscellaneous 80 column fixups. (Christoph)
   
7/ Restore BLK_DEV and PHYS_ADDR_T_64BIT dependencies to LIBNVDIMM.


Diffstat since v5 [1]: "ebba6912e36e libnvdimm: Non-Volatile Devices"
[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-June/001035.html

 drivers/acpi/Makefile                 |   1 -
 drivers/acpi/nfit.c                   | 228 +++++++++++++++++++++-----------------
 drivers/acpi/nfit.h                   |  20 ++--
 drivers/nvdimm/Kconfig                |   6 +-
 drivers/nvdimm/Makefile               |   1 -
 drivers/nvdimm/blk.c                  |  39 +++----
 drivers/nvdimm/btt.c                  |  85 ++++++++-------
 drivers/nvdimm/btt_devs.c             | 163 +++++++++++++--------------
 drivers/nvdimm/bus.c                  | 156 +++++++++++---------------
 drivers/nvdimm/core.c                 |  72 ++----------
 drivers/nvdimm/dimm.c                 |   4 +-
 drivers/nvdimm/dimm_devs.c            |  31 +++---
 drivers/nvdimm/label.c                | 284 ++++++++++++++++++++++++------------------------
 drivers/nvdimm/label.h                |   8 +-
 drivers/nvdimm/namespace_devs.c       | 142 ++++++++++++------------
 drivers/nvdimm/nd-core.h              |  28 +++--
 drivers/nvdimm/nd.h                   | 113 ++-----------------
 drivers/nvdimm/pmem.c                 |  38 +++----
 drivers/nvdimm/region.c               |   2 +-
 drivers/nvdimm/region_devs.c          |  90 +++++++--------
 include/linux/blkdev.h                |  44 ++++++++
 include/linux/libnvdimm.h             |  14 ++-
 include/uapi/linux/ndctl.h            |   8 +-
 tools/testing/nvdimm/Kbuild           |   2 -
 tools/testing/nvdimm/test/nfit.c      |  63 ++++++-----
 tools/testing/nvdimm/test/nfit_test.h |   3 +-
 26 files changed, 768 insertions(+), 877 deletions(-)


---

[PATCH v6 01/21] e820, efi: add ACPI 6.0 persistent memory types
[PATCH v6 02/21] libnvdimm, nfit: initial libnvdimm infrastructure and NFIT support
[PATCH v6 03/21] libnvdimm: control character device and nvdimm_bus sysfs attributes
[PATCH v6 04/21] libnvdimm, nfit: dimm/memory-devices
[PATCH v6 05/21] libnvdimm: control (ioctl) messages for nvdimm_bus and nvdimm devices
[PATCH v6 06/21] libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver infrastructure
[PATCH v6 07/21] libnvdimm, nfit: regions (block-data-window, persistent memory, volatile memory)
[PATCH v6 08/21] libnvdimm: support for legacy (non-aliasing) nvdimms
[PATCH v6 09/21] libnvdimm, pmem: move pmem to drivers/nvdimm/
[PATCH v6 10/21] libnvdimm, pmem: add libnvdimm support to the pmem driver
[PATCH v6 11/21] libnvdimm, nfit: add interleave-set state-tracking infrastructure
[PATCH v6 12/21] libnvdimm: namespace indices: read and validate
[PATCH v6 13/21] libnvdimm: pmem label sets and namespace instantiation.
[PATCH v6 14/21] libnvdimm: blk labels and namespace instantiation
[PATCH v6 15/21] libnvdimm: write pmem label set
[PATCH v6 16/21] libnvdimm: write blk label set
[PATCH v6 17/21] libnvdimm: infrastructure for btt devices
[PATCH v6 18/21] nd_btt: atomic sector updates
[PATCH v6 19/21] libnvdimm, nfit, nd_blk: driver for BLK-mode access persistent memory
[PATCH v6 20/21] tools/testing/nvdimm: libnvdimm unit test infrastructure
[PATCH v6 21/21] libnvdimm: Non-Volatile Devices

 Documentation/nvdimm/btt.txt          |  273 +++++
 Documentation/nvdimm/nvdimm.txt       |  805 ++++++++++++++++
 MAINTAINERS                           |   39 +
 arch/arm64/kernel/efi.c               |    1 
 arch/ia64/kernel/efi.c                |    4 
 arch/x86/Kconfig                      |    3 
 arch/x86/boot/compressed/eboot.c      |    4 
 arch/x86/include/uapi/asm/e820.h      |    1 
 arch/x86/kernel/e820.c                |   28 -
 arch/x86/kernel/pmem.c                |   92 +-
 arch/x86/platform/efi/efi.c           |    3 
 drivers/Kconfig                       |    2 
 drivers/Makefile                      |    1 
 drivers/acpi/Kconfig                  |   26 +
 drivers/acpi/Makefile                 |    1 
 drivers/acpi/nfit.c                   | 1546 ++++++++++++++++++++++++++++++
 drivers/acpi/nfit.h                   |  155 +++
 drivers/block/Kconfig                 |   11 
 drivers/block/Makefile                |    1 
 drivers/nvdimm/Kconfig                |   75 +
 drivers/nvdimm/Makefile               |   20 
 drivers/nvdimm/blk.c                  |  241 +++++
 drivers/nvdimm/btt.c                  | 1449 ++++++++++++++++++++++++++++
 drivers/nvdimm/btt.h                  |  186 ++++
 drivers/nvdimm/btt_devs.c             |  432 ++++++++
 drivers/nvdimm/bus.c                  |  746 ++++++++++++++
 drivers/nvdimm/core.c                 |  416 ++++++++
 drivers/nvdimm/dimm.c                 |  115 ++
 drivers/nvdimm/dimm_devs.c            |  517 ++++++++++
 drivers/nvdimm/label.c                |  926 ++++++++++++++++++
 drivers/nvdimm/label.h                |  141 +++
 drivers/nvdimm/namespace_devs.c       | 1698 +++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h              |  111 ++
 drivers/nvdimm/nd.h                   |  168 +++
 drivers/nvdimm/pmem.c                 |  107 +-
 drivers/nvdimm/region.c               |  189 ++++
 drivers/nvdimm/region_devs.c          |  667 +++++++++++++
 include/linux/blkdev.h                |   44 +
 include/linux/efi.h                   |    3 
 include/linux/libnvdimm.h             |  139 +++
 include/linux/nd.h                    |   98 ++
 include/uapi/linux/Kbuild             |    1 
 include/uapi/linux/ndctl.h            |  199 ++++
 tools/testing/nvdimm/Kbuild           |   35 +
 tools/testing/nvdimm/Makefile         |    7 
 tools/testing/nvdimm/test/Kbuild      |    8 
 tools/testing/nvdimm/test/iomap.c     |  151 +++
 tools/testing/nvdimm/test/nfit.c      | 1112 ++++++++++++++++++++++
 tools/testing/nvdimm/test/nfit_test.h |   29 +
 49 files changed, 12934 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/nvdimm/btt.txt
 create mode 100644 Documentation/nvdimm/nvdimm.txt
 create mode 100644 drivers/acpi/nfit.c
 create mode 100644 drivers/acpi/nfit.h
 create mode 100644 drivers/nvdimm/Kconfig
 create mode 100644 drivers/nvdimm/Makefile
 create mode 100644 drivers/nvdimm/blk.c
 create mode 100644 drivers/nvdimm/btt.c
 create mode 100644 drivers/nvdimm/btt.h
 create mode 100644 drivers/nvdimm/btt_devs.c
 create mode 100644 drivers/nvdimm/bus.c
 create mode 100644 drivers/nvdimm/core.c
 create mode 100644 drivers/nvdimm/dimm.c
 create mode 100644 drivers/nvdimm/dimm_devs.c
 create mode 100644 drivers/nvdimm/label.c
 create mode 100644 drivers/nvdimm/label.h
 create mode 100644 drivers/nvdimm/namespace_devs.c
 create mode 100644 drivers/nvdimm/nd-core.h
 create mode 100644 drivers/nvdimm/nd.h
 rename drivers/{block/pmem.c => nvdimm/pmem.c} (69%)
 create mode 100644 drivers/nvdimm/region.c
 create mode 100644 drivers/nvdimm/region_devs.c
 create mode 100644 include/linux/libnvdimm.h
 create mode 100644 include/linux/nd.h
 create mode 100644 include/uapi/linux/ndctl.h
 create mode 100644 tools/testing/nvdimm/Kbuild
 create mode 100644 tools/testing/nvdimm/Makefile
 create mode 100644 tools/testing/nvdimm/test/Kbuild
 create mode 100644 tools/testing/nvdimm/test/iomap.c
 create mode 100644 tools/testing/nvdimm/test/nfit.c
 create mode 100644 tools/testing/nvdimm/test/nfit_test.h
