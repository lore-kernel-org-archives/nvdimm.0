Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 00/15] libnvdimm: ->rw_bytes(), BLK-mode, unit tests,
 and misc features
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:54:47 -0400
Message-ID: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-nvdimm@lists.01.org
Cc: boaz@plexistor.com, toshi.kani@hp.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Dave Chinner <david@fromorbit.com>, Robert Moore <robert.moore@intel.com>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, linux-acpi@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de, mingo@kernel.org, linux-kernel@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

This patchset takes the position that a new block_device_operations op
is needed for nvdimm devices.  Jens, see "[PATCH 01/15] block: introduce
an ->rw_bytes() block device operation", it gates the rest of the series
moving forward.

Aside from adding a compile-time check to tools/testing/nvdimm/Kbuild
for validating all libnvdimm objects are built as modules, patches 2 to
6 are otherwise unchanged from the v6 libnvdimm posting [1].  The
remaining patches are feature additions and other cleanups that were
being held back while the base patchset was polished.

Patch 5 has an updated changelog speaking to the potential maintenance
burden of carrying tools/testing/nvdimm/ in-tree.  The benefits still
outweigh the risks in my opinion.

It should be noted that "[PATCH 14/15] libnvdimm: support read-only btt
backing devices" was developed in direct repsonse to working through the
implementation of unit tests for "[PATCH 15/15] libnvdimm, nfit: handle
acpi_nfit_memory_map flags" and its new "read-only by default" policy.
See the updates to the libndctl unit tests posted on the
linux-nvdimm@01.org mailing list.

[PATCH 01/15] block: introduce an ->rw_bytes() block device operation
[PATCH 02/15] libnvdimm: infrastructure for btt devices
[PATCH 03/15] nd_btt: atomic sector updates
[PATCH 04/15] libnvdimm, nfit, nd_blk: driver for BLK-mode access persistent memory
[PATCH 05/15] tools/testing/nvdimm: libnvdimm unit test infrastructure
[PATCH 06/15] libnvdimm: Non-Volatile Devices
[PATCH 07/15] fs/block_dev.c: skip rw_page if bdev has integrity
[PATCH 08/15] libnvdimm, btt: add support for blk integrity
[PATCH 09/15] libnvdimm, blk: add support for blk integrity
[PATCH 10/15] libnvdimm: fix up max_hw_sectors
[PATCH 11/15] libnvdimm: pmem, blk, and btt make_request cleanups
[PATCH 12/15] libnvdimm: enable iostat
[PATCH 13/15] libnvdimm: flag libnvdimm block devices as non-rotational
[PATCH 14/15] libnvdimm: support read-only btt backing devices
[PATCH 15/15] libnvdimm, nfit: handle acpi_nfit_memory_map flags

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-June/001166.html

---

Dan Williams (10):
      block: introduce an ->rw_bytes() block device operation
      libnvdimm: infrastructure for btt devices
      tools/testing/nvdimm: libnvdimm unit test infrastructure
      libnvdimm: Non-Volatile Devices
      libnvdimm: fix up max_hw_sectors
      libnvdimm: pmem, blk, and btt make_request cleanups
      libnvdimm: enable iostat
      libnvdimm: flag libnvdimm block devices as non-rotational
      libnvdimm: support read-only btt backing devices
      libnvdimm, nfit: handle acpi_nfit_memory_map flags

Ross Zwisler (1):
      libnvdimm, nfit, nd_blk: driver for BLK-mode access persistent memory

Vishal Verma (4):
      nd_btt: atomic sector updates
      fs/block_dev.c: skip rw_page if bdev has integrity
      libnvdimm, btt: add support for blk integrity
      libnvdimm, blk: add support for blk integrity


 Documentation/nvdimm/btt.txt          |  273 ++++++
 Documentation/nvdimm/nvdimm.txt       |  805 +++++++++++++++++
 MAINTAINERS                           |   39 +
 drivers/acpi/nfit.c                   |  491 ++++++++++
 drivers/acpi/nfit.h                   |   58 +
 drivers/nvdimm/Kconfig                |   54 +
 drivers/nvdimm/Makefile               |    7 
 drivers/nvdimm/blk.c                  |  368 ++++++++
 drivers/nvdimm/btt.c                  | 1569 +++++++++++++++++++++++++++++++++
 drivers/nvdimm/btt.h                  |  185 ++++
 drivers/nvdimm/btt_devs.c             |  473 ++++++++++
 drivers/nvdimm/bus.c                  |  176 ++++
 drivers/nvdimm/core.c                 |   99 ++
 drivers/nvdimm/dimm_devs.c            |    9 
 drivers/nvdimm/namespace_devs.c       |   63 +
 drivers/nvdimm/nd-core.h              |   48 +
 drivers/nvdimm/nd.h                   |   61 +
 drivers/nvdimm/pmem.c                 |   58 +
 drivers/nvdimm/region.c               |   97 ++
 drivers/nvdimm/region_devs.c          |  106 ++
 fs/block_dev.c                        |    4 
 include/linux/blkdev.h                |   44 +
 include/linux/libnvdimm.h             |   30 +
 include/uapi/linux/ndctl.h            |    2 
 tools/testing/nvdimm/Kbuild           |   40 +
 tools/testing/nvdimm/Makefile         |    7 
 tools/testing/nvdimm/config_check.c   |   15 
 tools/testing/nvdimm/test/Kbuild      |    8 
 tools/testing/nvdimm/test/iomap.c     |  151 +++
 tools/testing/nvdimm/test/nfit.c      | 1115 +++++++++++++++++++++++
 tools/testing/nvdimm/test/nfit_test.h |   29 +
 31 files changed, 6422 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/nvdimm/btt.txt
 create mode 100644 Documentation/nvdimm/nvdimm.txt
 create mode 100644 drivers/nvdimm/blk.c
 create mode 100644 drivers/nvdimm/btt.c
 create mode 100644 drivers/nvdimm/btt.h
 create mode 100644 drivers/nvdimm/btt_devs.c
 create mode 100644 tools/testing/nvdimm/Kbuild
 create mode 100644 tools/testing/nvdimm/Makefile
 create mode 100644 tools/testing/nvdimm/config_check.c
 create mode 100644 tools/testing/nvdimm/test/Kbuild
 create mode 100644 tools/testing/nvdimm/test/iomap.c
 create mode 100644 tools/testing/nvdimm/test/nfit.c
 create mode 100644 tools/testing/nvdimm/test/nfit_test.h
