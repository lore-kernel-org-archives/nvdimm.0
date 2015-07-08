Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/3] Correctness fixes for NFIT BLK I/O path
Date: Wed,  8 Jul 2015 10:00:18 -0600
Message-Id: <1436371221-30296-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Greg KH <gregkh@linuxfoundation.org>, Jeff Moyer <jmoyer@redhat.com>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

Patch 1 is just a quick update to MAINTAINERS for include/linux/pmem.h.

Patches 2 and 3 in this series contain correctness fixes for the NFIT BLK I/O
path, which in my opinion need to be pulled in for v4.2.  These fixes include
making sure that the block control registers are properly flushed before the
associated apertures are accessed, which is necessary for proper operation.
This series also updates the I/O path to use non-temporal stores, and to
respect the "latch" flag outlined in the DSM specification.

Ross Zwisler (3):
  pmem: add maintainer for include/linux/pmem.h
  nfit: update block I/O path to use PMEM API
  nfit: add support for NVDIMM "latch" flag

 MAINTAINERS         |   1 +
 drivers/acpi/nfit.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/acpi/nfit.h |  16 +++++++-
 3 files changed, 125 insertions(+), 6 deletions(-)

-- 
1.9.3

