Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v7 00/16] libnvdimm: non-volatile memory devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:13:19 -0400
Message-ID: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Boaz Harrosh <boaz@plexistor.com>, rafael@kernel.org, neilb@suse.de, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org, sfr@canb.auug.org.au, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, hch@lst.de, linux-acpi@vger.kernel.org, jmoyer@redhat.com, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, axboe@kernel.dk, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, linux-api@vger.kernel.org, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

A new sub-system in support of non-volatile memory storage devices.

Stephen, please add libnvdimm-for-next to -next:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm libnvdimm-for-next

Changes since v6 [1]:

1/ Deferred the patches dependent on ->rw_bytes() (BTT - stacked block
   driver, BLK - mmio aperture windows driver, NFIT_TEST - unit test
   infrastructure for all libnvdimm + nfit components) to their own
   patchset. Make the ->rw_bytes() implementation the first patch in
   that series (Christoph)

2/ Collected acks from Christoph and Rafael!

3/ Add a HAS_IOMEM dependency to CONFIG_BLK_DEV_PMEM following commit
   b6f2098fb708 "block: pmem: Add dependency on HAS_IOMEM" in 4.1-rc8.

4/ Move libnvdimm to subsys_initcall() and move arch/x86/kernel/pmem.c
   back to device_initcall().  This allows ACPI_NFIT to be built-in.
   (Linda)

5/ Drop the ACPI_DRIVER_ALL_NOTIFY_EVENTS flag in the nfit driver.
   (Rafael)

6/ Reference count the nvdimm_drvdata object.  This fixes a bug that was
   found when the unit tests were extended to test disabling an nvdimm
   while a region device still had references to label data.

Diffstat since v6:

 arch/x86/kernel/pmem.c          |  2 +-
 drivers/acpi/nfit.c             |  1 -
 drivers/nvdimm/Kconfig          |  1 +
 drivers/nvdimm/bus.c            |  2 +-
 drivers/nvdimm/core.c           |  2 +-
 drivers/nvdimm/dimm.c           | 21 ++++-----------------
 drivers/nvdimm/dimm_devs.c      | 34 ++++++++++++++++++++++++++++++++++
 drivers/nvdimm/namespace_devs.c | 43 +++++++++++++++++++++++++------------------
 drivers/nvdimm/nd-core.h        |  2 +-
 drivers/nvdimm/nd.h             |  3 +++
 drivers/nvdimm/region_devs.c    | 21 ++++++++-------------
 include/linux/libnvdimm.h       |  8 ++++++++
 12 files changed, 87 insertions(+), 53 deletions(-)

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-June/001166.html


---

Dan Williams (16):
      e820, efi: add ACPI 6.0 persistent memory types
      libnvdimm, nfit: initial libnvdimm infrastructure and NFIT support
      libnvdimm: control character device and nvdimm_bus sysfs attributes
      libnvdimm, nfit: dimm/memory-devices
      libnvdimm: control (ioctl) messages for nvdimm_bus and nvdimm devices
      libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver infrastructure
      libnvdimm, nfit: regions (block-data-window, persistent memory, volatile memory)
      libnvdimm: support for legacy (non-aliasing) nvdimms
      libnvdimm, pmem: move pmem to drivers/nvdimm/
      libnvdimm, pmem: add libnvdimm support to the pmem driver
      libnvdimm, nfit: add interleave-set state-tracking infrastructure
      libnvdimm: namespace indices: read and validate
      libnvdimm: pmem label sets and namespace instantiation.
      libnvdimm: blk labels and namespace instantiation
      libnvdimm: write pmem label set
      libnvdimm: write blk label set


 arch/arm64/kernel/efi.c          |    1 
 arch/ia64/kernel/efi.c           |    4 
 arch/x86/Kconfig                 |    3 
 arch/x86/boot/compressed/eboot.c |    4 
 arch/x86/include/uapi/asm/e820.h |    1 
 arch/x86/kernel/e820.c           |   28 +
 arch/x86/kernel/pmem.c           |   92 +-
 arch/x86/platform/efi/efi.c      |    3 
 drivers/Kconfig                  |    2 
 drivers/Makefile                 |    1 
 drivers/acpi/Kconfig             |   26 +
 drivers/acpi/Makefile            |    1 
 drivers/acpi/nfit.c              | 1123 ++++++++++++++++++++++++++
 drivers/acpi/nfit.h              |  100 ++
 drivers/block/Kconfig            |   11 
 drivers/block/Makefile           |    1 
 drivers/block/pmem.c             |  262 ------
 drivers/nvdimm/Kconfig           |   36 +
 drivers/nvdimm/Makefile          |   13 
 drivers/nvdimm/bus.c             |  668 +++++++++++++++
 drivers/nvdimm/core.c            |  396 +++++++++
 drivers/nvdimm/dimm.c            |  102 ++
 drivers/nvdimm/dimm_devs.c       |  542 +++++++++++++
 drivers/nvdimm/label.c           |  926 +++++++++++++++++++++
 drivers/nvdimm/label.h           |  141 +++
 drivers/nvdimm/namespace_devs.c  | 1645 ++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h         |   80 ++
 drivers/nvdimm/nd.h              |  135 +++
 drivers/nvdimm/pmem.c            |  278 ++++++
 drivers/nvdimm/region.c          |   96 ++
 drivers/nvdimm/region_devs.c     |  585 ++++++++++++++
 include/linux/efi.h              |    3 
 include/linux/libnvdimm.h        |  123 +++
 include/linux/nd.h               |   98 ++
 include/uapi/linux/Kbuild        |    1 
 include/uapi/linux/ndctl.h       |  197 +++++
 36 files changed, 7417 insertions(+), 311 deletions(-)
 create mode 100644 drivers/acpi/nfit.c
 create mode 100644 drivers/acpi/nfit.h
 delete mode 100644 drivers/block/pmem.c
 create mode 100644 drivers/nvdimm/Kconfig
 create mode 100644 drivers/nvdimm/Makefile
 create mode 100644 drivers/nvdimm/bus.c
 create mode 100644 drivers/nvdimm/core.c
 create mode 100644 drivers/nvdimm/dimm.c
 create mode 100644 drivers/nvdimm/dimm_devs.c
 create mode 100644 drivers/nvdimm/label.c
 create mode 100644 drivers/nvdimm/label.h
 create mode 100644 drivers/nvdimm/namespace_devs.c
 create mode 100644 drivers/nvdimm/nd-core.h
 create mode 100644 drivers/nvdimm/nd.h
 create mode 100644 drivers/nvdimm/pmem.c
 create mode 100644 drivers/nvdimm/region.c
 create mode 100644 drivers/nvdimm/region_devs.c
 create mode 100644 include/linux/libnvdimm.h
 create mode 100644 include/linux/nd.h
 create mode 100644 include/uapi/linux/ndctl.h
