Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B6B2C21D4919D
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 15:22:10 -0700 (PDT)
Subject: [PATCH 0/5] Adding blk-mq and DMA support to pmem block driver
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 31 Jul 2017 15:24:18 -0700
Message-ID: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: vinod.koul@intel.com, dan.j.williams@intel.com
Cc: dmaengine@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The following series implements adds blk-mq support to the pmem block driver
and also adds infrastructure code to ioatdma and dmaengine in order to
support copying to and from scatterlist in order to process block
requests provided by blk-mq. The usage of DMA engines available on certain
platforms allow us to drastically reduce CPU utilization and at the same time
maintain performance that is good enough. Experimentations have been done on
DRAM backed pmem block device that showed the utilization of DMA engine is
beneficial. User can revert back to original behavior by providing
queue_mode=0 to the nd_pmem kernel module if desired.

---

Dave Jiang (5):
      dmaengine: ioatdma: revert 7618d035 to allow sharing of DMA channels
      dmaengine: ioatdma: dma_prep_memcpy_to/from_sg support
      dmaengine: add SG support to dmaengine_unmap
      libnvdimm: Adding blk-mq support to the pmem driver
      libnvdimm: add DMA support for pmem blk-mq


 drivers/dma/dmaengine.c   |   45 +++++-
 drivers/dma/ioat/dma.h    |    8 +
 drivers/dma/ioat/init.c   |    6 -
 drivers/dma/ioat/prep.c   |  105 ++++++++++++++
 drivers/nvdimm/pmem.c     |  340 ++++++++++++++++++++++++++++++++++++++++++---
 drivers/nvdimm/pmem.h     |    3 
 include/linux/dmaengine.h |   14 ++
 7 files changed, 488 insertions(+), 33 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
