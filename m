Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: vishal@kernel.org
Subject: [PATCH 0/3] Expose known poison in SPA ranges to the block layer
Date: Sun, 20 Dec 2015 02:18:39 -0700
Message-Id: <1450603122-7205-1-git-send-email-vishal@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, Linda Knippers <linda.knippers@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Vishal Verma <vishal.l.verma@intel.com>

This series does a few things:
- Retrieve all known poison in the system physical address (SPA) space
  using ARS (Address Range Scrub) commands to firmware
- Store this poison in a new 'nd_poison' structure
- In pmem, consume the poison list and expose the ranges as bad sectors

This depends on the badblocks series sent out previously[1]

This was tested using nfit_test to add poison at specific address ranges.
More testing, specially on NVDIMM-N hardware is much appreciated!


[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-December/003239.html

Vishal Verma (3):
  nfit_test: Enable DSMs for all test NFITs
  libnvdimm: Add a poison list
  pmem: Use the poison list to expose badblocks

 drivers/acpi/nfit.c              | 193 +++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/core.c            |  63 +++++++++++++
 drivers/nvdimm/nd-core.h         |   1 +
 drivers/nvdimm/nd.h              |   6 ++
 drivers/nvdimm/pmem.c            | 124 +++++++++++++++++++++++++
 include/linux/libnvdimm.h        |   2 +
 tools/testing/nvdimm/test/nfit.c |   9 ++
 7 files changed, 398 insertions(+)

-- 
2.5.0

