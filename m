Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v5 00/21] libnvdimm: non-volatile memory devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 01 Jun 2015 20:14:08 -0400
Message-ID: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Changes since v4 [1]:

1/ Rename libnd to libnvdimm, move the implementation from
   drivers/block/nd to drivers/nvdimm, and replace the "nd" prefix with
   "nvdimm" where it makes sense.  For example, the module name and public
   header filename for the major library entry points are libnvdimm.ko
   and libnvdimm.h respectively.  The entry points are prefixed with
   "nvdimm" and the primary bus objects are renamed, i.e.
   s/nd_bus/nvdimm_bus/ and s/nd_dimm/nvdimm/.  The "nd" prefix remains
   as a short lead-in identifier for implementation internal items that
   are not nvdimms like regions, commands, labels, etc... (Christoph [2])

2/ Move the unit test infrastructure to an external module in
   tools/testing/nvdimm.  The linker hack received a strong NAK from
   Christoph and it is also problematic that an "allmodconfig" build would
   result in including the mocked symbols.  With the move and conversion to
   an external module we keep the unit tests in tree where they can be
   maintained effectively without impacting production builds. (Christoph
   [2])

3/ Fixup some miscellaneous 0day sparse reports [3]

4/ Rebased on top of linux-pm.git/acpica (Rafael [4])

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-May/000804.html
[2]: https://lists.01.org/pipermail/linux-nvdimm/2015-May/000923.html
[3]: https://lists.01.org/pipermail/linux-nvdimm/2015-May/000983.html
[4]: https://lists.01.org/pipermail/linux-nvdimm/2015-May/000921.html

Diffstat since v4:

 Documentation/{blockdev => nvdimm}/btt.txt         |   0
 .../{blockdev/libnd.txt => nvdimm/nvdimm.txt}      |  97 ++++----
 drivers/acpi/nfit.c                                | 148 ++++++------
 drivers/acpi/nfit.h                                |  19 +-
 drivers/block/nd/Makefile                          |  29 ---
 drivers/block/nd/test/Makefile                     |   5 -
 drivers/{block/nd => nvdimm}/Kconfig               |  42 +---
 drivers/nvdimm/Makefile                            |  21 ++
 drivers/{block/nd => nvdimm}/blk.c                 |   6 +-
 drivers/{block/nd => nvdimm}/btt.c                 |   6 +-
 drivers/{block/nd => nvdimm}/btt.h                 |   0
 drivers/{block/nd => nvdimm}/btt_devs.c            |  38 +--
 drivers/{block/nd => nvdimm}/bus.c                 | 258 ++++++++++-----------
 drivers/{block/nd => nvdimm}/core.c                | 196 ++++++++--------
 drivers/{block/nd => nvdimm}/dimm.c                |  44 ++--
 drivers/{block/nd => nvdimm}/dimm_devs.c           | 188 +++++++--------
 drivers/{block/nd => nvdimm}/label.c               | 116 ++++-----
 drivers/{block/nd => nvdimm}/label.h               |  22 +-
 drivers/{block/nd => nvdimm}/namespace_devs.c      | 108 ++++-----
 drivers/{block/nd => nvdimm}/nd-private.h          |  62 +++--
 drivers/{block/nd => nvdimm}/nd.h                  |  44 ++--
 drivers/{block/nd => nvdimm}/pmem.c                |   6 +-
 drivers/{block/nd => nvdimm}/region.c              |  10 +-
 drivers/{block/nd => nvdimm}/region_devs.c         | 126 +++++-----
 include/linux/{libnd.h => libnvdimm.h}             |  68 +++---
 tools/testing/nvdimm/Kbuild                        |  37 +++
 tools/testing/nvdimm/Makefile                      |   7 +
 tools/testing/nvdimm/test/Kbuild                   |   8 +
 .../block/nd => tools/testing/nvdimm}/test/iomap.c |   0
 .../block/nd => tools/testing/nvdimm}/test/nfit.c  | 122 +++-------
 .../nd => tools/testing/nvdimm}/test/nfit_test.h   |   0
 31 files changed, 895 insertions(+), 938 deletions(-)
 rename Documentation/{blockdev => nvdimm}/btt.txt (100%)
 rename Documentation/{blockdev/libnd.txt => nvdimm/nvdimm.txt} (92%)
 delete mode 100644 drivers/block/nd/Makefile
 delete mode 100644 drivers/block/nd/test/Makefile
 rename drivers/{block/nd => nvdimm}/Kconfig (72%)
 create mode 100644 drivers/nvdimm/Makefile
 rename drivers/{block/nd => nvdimm}/blk.c (98%)
 rename drivers/{block/nd => nvdimm}/btt.c (99%)
 rename drivers/{block/nd => nvdimm}/btt.h (100%)
 rename drivers/{block/nd => nvdimm}/btt_devs.c (90%)
 rename drivers/{block/nd => nvdimm}/bus.c (68%)
 rename drivers/{block/nd => nvdimm}/core.c (62%)
 rename drivers/{block/nd => nvdimm}/dimm.c (71%)
 rename drivers/{block/nd => nvdimm}/dimm_devs.c (69%)
 rename drivers/{block/nd => nvdimm}/label.c (89%)
 rename drivers/{block/nd => nvdimm}/label.h (87%)
 rename drivers/{block/nd => nvdimm}/namespace_devs.c (94%)
 rename drivers/{block/nd => nvdimm}/nd-private.h (57%)
 rename drivers/{block/nd => nvdimm}/nd.h (86%)
 rename drivers/{block/nd => nvdimm}/pmem.c (99%)
 rename drivers/{block/nd => nvdimm}/region.c (96%)
 rename drivers/{block/nd => nvdimm}/region_devs.c (83%)
 rename include/linux/{libnd.h => libnvdimm.h} (62%)
 create mode 100644 tools/testing/nvdimm/Kbuild
 create mode 100644 tools/testing/nvdimm/Makefile
 create mode 100644 tools/testing/nvdimm/test/Kbuild
 rename {drivers/block/nd => tools/testing/nvdimm}/test/iomap.c (100%)
 rename {drivers/block/nd => tools/testing/nvdimm}/test/nfit.c (91%)
 rename {drivers/block/nd => tools/testing/nvdimm}/test/nfit_test.h (100%)

---

Dan Williams (18):
      e820, efi: add ACPI 6.0 persistent memory types
      libnvdimm, nfit: initial libnvdimm infrastructure and NFIT support
      libnvdimm: control character device and libnvdimm bus sysfs attributes
      libnvdimm, nfit: dimm/memory-devices
      libnvdimm: control (ioctl) messages for libnvdimm bus and dimm devices
      libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver infrastructure
      libnvdimm, nfit: regions (block-data-window, persistent memory, volatile memory)
      libnvdimm: support for legacy (non-aliasing) nvdimms
      libnvdimm, nd_pmem: add libnvdimm support to the pmem driver
      libnvdimm, nfit: add interleave-set state-tracking infrastructure
      libnvdimm: namespace indices: read and validate
      libnvdimm: pmem label sets and namespace instantiation.
      libnvdimm: blk labels and namespace instantiation
      libnvdimm: write pmem label set
      libnvdimm: write blk label set
      libnvdimm: infrastructure for btt devices
      tools/testing/nvdimm: manufactured NFITs for interface development
      libnvdimm: Non-Volatile Devices

Ross Zwisler (2):
      pmem: Dynamically allocate partition numbers
      libnvdimm, nfit, nd_blk: driver for BLK-mode access persistent memory

Vishal Verma (1):
      nd_btt: atomic sector updates


 Documentation/nvdimm/btt.txt          |  273 +++++
 Documentation/nvdimm/nvdimm.txt       |  805 ++++++++++++++++
 MAINTAINERS                           |   39 +
 arch/arm64/kernel/efi.c               |    1 
 arch/ia64/kernel/efi.c                |    4 
 arch/x86/Kconfig                      |    4 
 arch/x86/boot/compressed/eboot.c      |    4 
 arch/x86/include/uapi/asm/e820.h      |    1 
 arch/x86/kernel/e820.c                |   28 -
 arch/x86/kernel/pmem.c                |   92 +-
 arch/x86/platform/efi/efi.c           |    3 
 drivers/Kconfig                       |    2 
 drivers/Makefile                      |    1 
 drivers/acpi/Kconfig                  |   27 +
 drivers/acpi/Makefile                 |    2 
 drivers/acpi/nfit.c                   | 1474 +++++++++++++++++++++++++++++
 drivers/acpi/nfit.h                   |  161 +++
 drivers/block/Kconfig                 |   11 
 drivers/block/Makefile                |    1 
 drivers/nvdimm/Kconfig                |   79 ++
 drivers/nvdimm/Makefile               |   21 
 drivers/nvdimm/blk.c                  |  252 +++++
 drivers/nvdimm/btt.c                  | 1440 ++++++++++++++++++++++++++++
 drivers/nvdimm/btt.h                  |  186 ++++
 drivers/nvdimm/btt_devs.c             |  443 +++++++++
 drivers/nvdimm/bus.c                  |  770 +++++++++++++++
 drivers/nvdimm/core.c                 |  472 +++++++++
 drivers/nvdimm/dimm.c                 |  115 ++
 drivers/nvdimm/dimm_devs.c            |  516 ++++++++++
 drivers/nvdimm/label.c                |  926 ++++++++++++++++++
 drivers/nvdimm/label.h                |  143 +++
 drivers/nvdimm/namespace_devs.c       | 1702 +++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-private.h           |  107 ++
 drivers/nvdimm/nd.h                   |  261 +++++
 drivers/nvdimm/pmem.c                 |  107 +-
 drivers/nvdimm/region.c               |  189 ++++
 drivers/nvdimm/region_devs.c          |  667 +++++++++++++
 include/linux/efi.h                   |    3 
 include/linux/libnvdimm.h             |  131 +++
 include/linux/nd.h                    |   98 ++
 include/uapi/linux/Kbuild             |    1 
 include/uapi/linux/ndctl.h            |  199 ++++
 tools/testing/nvdimm/Kbuild           |   37 +
 tools/testing/nvdimm/Makefile         |    7 
 tools/testing/nvdimm/test/Kbuild      |    8 
 tools/testing/nvdimm/test/iomap.c     |  151 +++
 tools/testing/nvdimm/test/nfit.c      | 1101 +++++++++++++++++++++
 tools/testing/nvdimm/test/nfit_test.h |   28 +
 48 files changed, 13004 insertions(+), 89 deletions(-)
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
 create mode 100644 drivers/nvdimm/nd-private.h
 create mode 100644 drivers/nvdimm/nd.h
 rename drivers/{block/pmem.c => nvdimm/pmem.c} (70%)
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
