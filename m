Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 0/6] Correctness fixes for NFIT BLK I/O path
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 11 Jul 2015 10:40:37 -0400
Message-ID: <20150711142806.25013.16924.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, ross.zwisler@linux.intel.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1 [1]:

1/ Fixup the unit test in response to the 4.2-rc1 merge (handle the new
   usage of ioremap_wt).

2/ Add unit test infrastructure for NFIT "flush" sub-table entries

3/ Fix the mock DSM implementation's usage of ENOTTY

4/ Replace usage of devm_ioremap_resource() with devm_ioremap_nocache()
   for mapping flush table addresses.  Multiple DIMMs are allowed to
   share the same flush address.  Also, the side effect of stray writes
   to a flush address are simply extra memory controller buffer flushes,
   so we don't strictly need exclusive resource ownership.

5/ Fixed the warning "unable to guarantee persistence of writes" to
   consider the case of a platform without PMEM API support, but *with*
   flush address entries.

6/ Fixed the "latch" flag retrieval code to proceed with a sane default
   in the case the "DIMM flags" DSM is not implemented.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-July/001499.html


Summary:

This set of fixes to the BLK I/O path is a bit larger than I would have
liked for an -rc update, but they are necessary for correct operation of
a BLK-mode namespace.  Originally posted as part of the initial PMEM API
submission at the end of May [2], they got deferred while we iterated on
the details of memremap_pmem(), memcpy_to_pmem(), and wmb_pmem().  Now
that those APIs are upstream these patches finish off enabling
persistence guarantees for BLK-mode persistent memory.

[2]: https://lists.01.org/pipermail/linux-nvdimm/2015-May/000929.html

---

Dan Williams (3):
      tools/testing/nvdimm: mock ioremap_wt
      tools/testing/nvdimm: fix return code for unimplemented commands
      tools/testing/nvdimm: add mock acpi_nfit_flush_address entries to nfit_test

Ross Zwisler (3):
      pmem: add maintainer for include/linux/pmem.h
      nfit: update block I/O path to use PMEM API
      nfit: add support for NVDIMM "latch" flag


 MAINTAINERS                       |    1 
 drivers/acpi/nfit.c               |  130 ++++++++++++++++++++++++++++++++++---
 drivers/acpi/nfit.h               |   20 +++++-
 tools/testing/nvdimm/Kbuild       |    3 +
 tools/testing/nvdimm/test/iomap.c |   27 ++++++++
 tools/testing/nvdimm/test/nfit.c  |   52 ++++++++++++++-
 6 files changed, 217 insertions(+), 16 deletions(-)
