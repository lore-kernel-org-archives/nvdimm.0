Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 0/3] numa allocations for devm and pmem
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Sep 2015 21:17:37 -0400
Message-ID: <20150926011243.2848.82422.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm@lists.01.org, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

I noticed that pmem should be using blk_alloc_queue_node() and then I
wondered about the devm allocations...  So, here is a quick conversion
of devm to use dev_to_node() for node local allocations by default and
as a result pmem to allocate all its driver infrastructure near to the
device.

---

Dan Williams (3):
      devm: make allocations numa aware by default
      devm_memremap_pages: use numa_mem_id
      pmem, memremap: convert to numa aware allocations


 drivers/base/devres.c  |   19 ++++++++++---------
 drivers/nvdimm/pmem.c  |    5 +++--
 include/linux/device.h |   16 ++++++++++++----
 kernel/memremap.c      |    9 +++++----
 4 files changed, 30 insertions(+), 19 deletions(-)
