Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/6] I/O path improvements for ND_BLK and PMEM
Date: Thu, 28 May 2015 16:35:47 -0600
Message-Id: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

This series adds a new PMEM API consisting of three functions:
persistent_copy(), persistent_flush() and persistent_sync().

These three functions are then used in the I/O paths for both the ND_BLK driver
and the PMEM driver to ensure that writes actually make it to the DIMM and
become durable before the I/O operation completes.

The first two patches in the series are just cleanup and correctness patches.

Patch three provides a reasonable architecture neutral default implementation
for these three APIs for architectures that do not implement the PMEM API.
These defaults allow all architectures to mostly work, aliasing
persistent_copy() to memcpy() and having persistent_flush() and
persistent_sync() be noops.  With this patch set this implementation is
provided at the pmem.h level.

It's possible that other future consumers of the PMEM API (DAX, possibly
others) would prefer to have a different default behavior for architectures
that don't support the PMEM API.  If this is the case we could move the choice
about what to do for those architectures down into consumer-specific header
files, so nd.h for libnd, for example.  If DAX and other consumers are fine
with our defaults it's nicer to keep them common and in a global place.  Please
let us know how other future consumers of the PMEM API feel about this.

Patches 5 and 6 update the I/O paths for flush hints and NVDIMM flags.

This series applies cleanly to Dan's "ndctl-for-next" tree:

https://git.kernel.org/cgit/linux/kernel/git/djbw/nvdimm.git/log/?h=libnd-for-next

One last note - I'm going to be unavailable soon, so patch feedback will most
likely be handled by Dan Williams.  Thanks, Dan. :)

Ross Zwisler (6):
  pmem: add force casts to avoid __iomem annotation
  nfit: Fix up address spaces, sparse warnings
  x86, pmem: add PMEM API for persistent memory
  pmem, nd_blk: update I/O paths to use PMEM API
  nd_blk: add support for flush hints
  nd_blk: add support for NVDIMM flags

 MAINTAINERS                       |  1 +
 arch/x86/Kconfig                  |  3 ++
 arch/x86/include/asm/cacheflush.h | 23 ++++++++++
 drivers/acpi/nfit.c               | 89 ++++++++++++++++++++++++++++++++++-----
 drivers/acpi/nfit.h               | 28 +++++++++++-
 drivers/block/nd/pmem.c           | 22 +++++++---
 include/linux/pmem.h              | 79 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/ndctl.h        |  5 +++
 8 files changed, 232 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/pmem.h

-- 
1.9.3

