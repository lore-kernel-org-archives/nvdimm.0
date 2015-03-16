Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/6] Add persistent memory driver
Date: Mon, 16 Mar 2015 15:12:54 -0600
Message-Id: <1426540380-24503-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, riel@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

PMEM is a modified version of the Block RAM Driver, BRD. The major difference
is that BRD allocates its backing store pages from the page cache, whereas
PMEM uses reserved memory that has been ioremapped.

One benefit of this approach is that there is a direct mapping between
filesystem block numbers and virtual addresses.  In PMEM, filesystem blocks N,
N+1, N+2, etc. will all be adjacent in the virtual memory space. This property
allows us to set up PMD mappings (2 MiB) for DAX.

This patch set is builds upon the work that Matthew Wilcox has been doing for
DAX, which has been merged into the v4.0 kernel series.

For more information on PMEM and for some instructions on how to use it, please
check out PMEM's github tree:

https://github.com/01org/prd

Cc: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk
Cc: hch@infradead.org
Cc: riel@redhat.com

Boaz Harrosh (1):
  pmem: Let each device manage private memory region

Ross Zwisler (5):
  pmem: Initial version of persistent memory driver
  pmem: Add support for getgeo()
  pmem: Add support for rw_page()
  pmem: Add support for direct_access()
  pmem: Clean up includes

 MAINTAINERS            |   6 +
 drivers/block/Kconfig  |  41 +++++
 drivers/block/Makefile |   1 +
 drivers/block/pmem.c   | 401 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 449 insertions(+)
 create mode 100644 drivers/block/pmem.c

-- 
1.9.3

