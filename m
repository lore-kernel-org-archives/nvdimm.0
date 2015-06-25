Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 00/17] libnvdimm: ->rw_bytes(), BLK, BTT, PMEM api,
 and unit tests
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jun 2015 05:36:17 -0400
Message-ID: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: boaz@plexistor.com, Neil Brown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, hch@lst.de, linux-acpi@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Thomas Gleixner <tglx@linutronix.de>, axboe@kernel.dk, toshi.kani@hp.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

->rw_bytes() is a byte-aligned interface for accessing persistent memory
namespaces.  The primary consumer of the ->rw_bytes() interface is the
BTT library.

BTT is a library that converts a byte-accessible namespace into a disk
with atomic sector update semantics (prevents sector tearing on crash or
power loss).  The sinister aspect of sector tearing is that most
applications do not know they have a atomic sector dependency.  At least
today's disk's rarely ever tear sectors and if they do you almost
certainly get a CRC error on access.  NVDIMMs will always tear and
always silently.

BLK is a driver for NVDIMMs that provide sliding mmio windows to access
persistent memory.

The PMEM api defines ensures writes have hit persistent media relative
to the completion of an i/o.

Changes since v1 [1]:

1/ The ->rw_bytes() interface has been removed from struct
block_device_operations and is now a common operation of NVDIMM
namespace devices.  Accordingly a BTT instance is now a libnvdimm
device-model peer of a namespace rather than a stacked block device
driver.  The BTT is no longer a driver in its own right, instead it is a
extension library used by a BLK or PMEM namespace.  This clarifies the
device model and reduced the core implementation by a couple hundred
lines of code.  (Christoph)

2/ Kill ND_MAX_REGIONS and ND_IOSTAT Kconfig options. (Christoph)

3/ Killed the access out of range check separately in PMEM, BLK, and BTT
(Christoph)

4/ Kill the central helper for blk queue properties (Christoph)

5/ Added Toshi's numa patches with a change to set the numa info at
device create time rather than driver probe time.

6/ Cherry picked the PMEM api.  The wider arch cleanups in the full
pmem-api series are too large / invasive to pick up at this late date.
The keeps the pmem.c driver x86-only for one more cycle.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-June/001246.html

Diffstat since v1:

 Documentation/nvdimm/btt.txt      |  24 ++-
 Documentation/nvdimm/nvdimm.txt   |  79 ++++----
 arch/x86/Kconfig                  |   1 +
 arch/x86/include/asm/cacheflush.h |  72 +++++++
 arch/x86/include/asm/io.h         |   6 +
 drivers/acpi/nfit.c               |  17 +-
 drivers/acpi/numa.c               |  50 ++++-
 drivers/nvdimm/Kconfig            |  56 ++----
 drivers/nvdimm/Makefile           |   2 +-
 drivers/nvdimm/blk.c              | 148 +++++++-------
 drivers/nvdimm/btt.c              | 166 ++++------------
 drivers/nvdimm/btt_devs.c         | 403 +++++++++++++++++---------------------
 drivers/nvdimm/bus.c              | 190 ++++--------------
 drivers/nvdimm/core.c             |  30 ---
 drivers/nvdimm/label.c            |   5 +-
 drivers/nvdimm/namespace_devs.c   | 252 +++++++++++++++++++-----
 drivers/nvdimm/nd-core.h          |  47 +----
 drivers/nvdimm/nd.h               |  51 +++--
 drivers/nvdimm/pmem.c             | 185 ++++++++---------
 drivers/nvdimm/region.c           |  85 +-------
 drivers/nvdimm/region_devs.c      | 182 +++++++++++++----
 include/linux/acpi.h              |   5 +
 include/linux/blkdev.h            |  44 -----
 include/linux/compiler.h          |   2 +
 include/linux/libnvdimm.h         |   2 +
 include/linux/nd.h                |  63 +++++-
 include/linux/pmem.h              | 153 +++++++++++++++
 include/uapi/linux/ndctl.h        |   2 -
 lib/Kconfig                       |   3 +
 tools/testing/nvdimm/Kbuild       |   2 +-
 tools/testing/nvdimm/test/nfit.c  |   1 +
 31 files changed, 1272 insertions(+), 1056 deletions(-)
 create mode 100644 include/linux/pmem.h

---

Dan Williams (8):
      libnvdimm: infrastructure for btt devices
      tools/testing/nvdimm: libnvdimm unit test infrastructure
      libnvdimm: Non-Volatile Devices
      libnvdimm, pmem: fix up max_hw_sectors
      pmem: make_request cleanups
      libnvdimm: enable iostat
      pmem: flag pmem block devices as non-rotational
      libnvdimm, nfit: handle unarmed dimms, mark namespaces read-only

Ross Zwisler (2):
      libnvdimm, nfit, nd_blk: driver for BLK-mode access persistent memory
      arch, x86: pmem api for ensuring durability of persistent memory updates

Toshi Kani (3):
      acpi: Add acpi_map_pxm_to_online_node()
      libnvdimm: Set numa_node to NVDIMM devices
      libnvdimm: Add sysfs numa_node to NVDIMM devices

Vishal Verma (4):
      nd_btt: atomic sector updates
      fs/block_dev.c: skip rw_page if bdev has integrity
      libnvdimm, btt: add support for blk integrity
      libnvdimm, blk: add support for blk integrity


 Documentation/nvdimm/btt.txt          |  283 ++++++
 Documentation/nvdimm/nvdimm.txt       |  808 ++++++++++++++++++
 MAINTAINERS                           |   39 +
 arch/x86/Kconfig                      |    1 
 arch/x86/include/asm/cacheflush.h     |   72 ++
 arch/x86/include/asm/io.h             |    6 
 drivers/acpi/nfit.c                   |  498 +++++++++++
 drivers/acpi/nfit.h                   |   58 +
 drivers/acpi/numa.c                   |   50 +
 drivers/nvdimm/Kconfig                |   42 +
 drivers/nvdimm/Makefile               |    7 
 drivers/nvdimm/blk.c                  |  384 +++++++++
 drivers/nvdimm/btt.c                  | 1479 +++++++++++++++++++++++++++++++++
 drivers/nvdimm/btt.h                  |  185 ++++
 drivers/nvdimm/btt_devs.c             |  426 ++++++++++
 drivers/nvdimm/bus.c                  |   60 +
 drivers/nvdimm/core.c                 |   69 ++
 drivers/nvdimm/dimm_devs.c            |    9 
 drivers/nvdimm/label.c                |    5 
 drivers/nvdimm/namespace_devs.c       |  295 ++++++-
 drivers/nvdimm/nd-core.h              |    5 
 drivers/nvdimm/nd.h                   |   86 ++
 drivers/nvdimm/pmem.c                 |  181 ++--
 drivers/nvdimm/region.c               |   28 +
 drivers/nvdimm/region_devs.c          |  238 +++++
 fs/block_dev.c                        |    4 
 include/linux/acpi.h                  |    5 
 include/linux/compiler.h              |    2 
 include/linux/libnvdimm.h             |   32 +
 include/linux/nd.h                    |   63 +
 include/linux/pmem.h                  |  153 +++
 lib/Kconfig                           |    3 
 tools/testing/nvdimm/Kbuild           |   40 +
 tools/testing/nvdimm/Makefile         |    7 
 tools/testing/nvdimm/config_check.c   |   15 
 tools/testing/nvdimm/test/Kbuild      |    8 
 tools/testing/nvdimm/test/iomap.c     |  151 +++
 tools/testing/nvdimm/test/nfit.c      | 1116 +++++++++++++++++++++++++
 tools/testing/nvdimm/test/nfit_test.h |   29 +
 39 files changed, 6759 insertions(+), 183 deletions(-)
 create mode 100644 Documentation/nvdimm/btt.txt
 create mode 100644 Documentation/nvdimm/nvdimm.txt
 create mode 100644 drivers/nvdimm/blk.c
 create mode 100644 drivers/nvdimm/btt.c
 create mode 100644 drivers/nvdimm/btt.h
 create mode 100644 drivers/nvdimm/btt_devs.c
 create mode 100644 include/linux/pmem.h
 create mode 100644 tools/testing/nvdimm/Kbuild
 create mode 100644 tools/testing/nvdimm/Makefile
 create mode 100644 tools/testing/nvdimm/config_check.c
 create mode 100644 tools/testing/nvdimm/test/Kbuild
 create mode 100644 tools/testing/nvdimm/test/iomap.c
 create mode 100644 tools/testing/nvdimm/test/nfit.c
 create mode 100644 tools/testing/nvdimm/test/nfit_test.h
