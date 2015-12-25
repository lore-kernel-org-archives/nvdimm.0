Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 0/2] Expose known poison in SPA ranges to the block layer
Date: Thu, 24 Dec 2015 19:21:41 -0700
Message-Id: <1451010103-11462-1-git-send-email-vishal.l.verma@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, Linda Knippers <linda.knippers@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

v2:
  - Move poison list walking from pmem to core (Dan)
  - If the pmem namespace starts at an offset, account for that (Dan)
  - Fix a bug in extended status checking for ars_status
  - Remove a duplicate include in pmem.c (only introduced in v1)
  - When doing an ars_status, don't error out if an ARS has not yet
    been performed.
  - When checking if ARS is supported, also check the extended status
    and make sure ARS for persistent memory is supported (as opposed to
    just volatile memory)
  - Print a dev_err message if find_poison fails
  - Collapse patches 2 and 3 into a single patch

This series does a few things:
- Retrieve all known poison in the system physical address (SPA) space
  using ARS (Address Range Scrub) commands to firmware
- Store this poison in a new 'nd_poison' structure
- In pmem, consume the poison list and expose the ranges as bad sectors

This depends on the badblocks series sent out previously.
A tree with the latest revisions of both the badblocks patchset and this
can be found at:
https://git.kernel.org/cgit/linux/kernel/git/vishal/nvdimm.git/log/?h=err_handling_latest


Vishal Verma (2):
  nfit_test: Enable DSMs for all test NFITs
  libnvdimm: Add a poison list and export badblocks

 drivers/acpi/nfit.c              | 203 +++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/core.c            | 187 ++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h         |   3 +
 drivers/nvdimm/nd.h              |   6 ++
 drivers/nvdimm/pmem.c            |   6 ++
 include/linux/libnvdimm.h        |   1 +
 tools/testing/nvdimm/test/nfit.c |   9 ++
 7 files changed, 415 insertions(+)

-- 
2.5.0

