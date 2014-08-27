Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/4] Add persistent memory driver
Date: Wed, 27 Aug 2014 15:11:58 -0600
Message-Id: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Boaz Harrosh <boaz@plexistor.com>, Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

PMEM is a modified version of the Block RAM Driver, BRD. The major difference
is that BRD allocates its backing store pages from the page cache, whereas
PMEM uses reserved memory that has been ioremapped.

One benefit of this approach is that there is a direct mapping between
filesystem block numbers and virtual addresses.  In PMEM, filesystem blocks N,
N+1, N+2, etc. will all be adjacent in the virtual memory space. This property
allows us to set up PMD mappings (2 MiB) for DAX.

This patch set is builds upon the work that Matthew Wilcox has been doing for
DAX:

https://lkml.org/lkml/2014/8/27/31

Specifically, my implementation of pmem_direct_access() in patch 4/4 uses API
enhancements introduced in Matthew's DAX patch v10 02/21:

https://lkml.org/lkml/2014/8/27/48

Ross Zwisler (4):
  pmem: Initial version of persistent memory driver
  pmem: Add support for getgeo()
  pmem: Add support for rw_page()
  pmem: Add support for direct_access()

 MAINTAINERS            |   6 +
 drivers/block/Kconfig  |  41 ++++++
 drivers/block/Makefile |   1 +
 drivers/block/pmem.c   | 375 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 423 insertions(+)
 create mode 100644 drivers/block/pmem.c

-- 
1.9.3

