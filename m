Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E1A7921AEB0CD
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 16:29:36 -0700 (PDT)
Subject: [PATCH v3 0/8] Adding blk-mq and DMA support to pmem block driver
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 03 Aug 2017 16:31:46 -0700
Message-ID: <150180288552.66052.13066621908903037900.stgit@djiang5-desk3.ch.intel.com>
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

v3:
- Added patch to rename DMA_SG to DMA_SG_SG to make it explicit
- Added DMA_MEMCPY_SG transaction type to dmaengine
- Misc patch to add verification of DMA_MEMSET_SG that was missing
- Addressed all nd_pmem driver comments from Ross.

v2:
- Make dma_prep_memcpy_* into one function per Dan.
- Addressed various comments from Ross with code formatting and etc.
- Replaced open code with offset_in_page() macro per Johannes.

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

Dave Jiang (8):
      dmaengine: ioatdma: revert 7618d035 to allow sharing of DMA channels
      dmaengine: change transaction type DMA_SG to DMA_SG_SG
      dmaengine: Add DMA_MEMCPY_SG transaction op
      dmaengine: add verification of DMA_MEMSET_SG in dmaengine
      dmaengine: ioatdma: dma_prep_memcpy_sg support
      dmaengine: add SG support to dmaengine_unmap
      libnvdimm: Adding blk-mq support to the pmem driver
      libnvdimm: add DMA support for pmem blk-mq


 Documentation/dmaengine/provider.txt |    5 -
 drivers/crypto/ccp/ccp-dmaengine.c   |    2 
 drivers/dma/at_hdmac.c               |    8 -
 drivers/dma/dmaengine.c              |   51 ++++-
 drivers/dma/dmatest.c                |   12 +
 drivers/dma/fsldma.c                 |    2 
 drivers/dma/ioat/dma.h               |    4 
 drivers/dma/ioat/init.c              |    5 -
 drivers/dma/ioat/prep.c              |   57 ++++++
 drivers/dma/mv_xor.c                 |    6 -
 drivers/dma/nbpfaxi.c                |    2 
 drivers/dma/ste_dma40.c              |    6 -
 drivers/dma/xgene-dma.c              |    4 
 drivers/dma/xilinx/zynqmp_dma.c      |    2 
 drivers/nvdimm/pmem.c                |  333 ++++++++++++++++++++++++++++++++--
 drivers/nvdimm/pmem.h                |    3 
 include/linux/dmaengine.h            |   12 +
 17 files changed, 456 insertions(+), 58 deletions(-)

--
Signature
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
