Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3871821E2DA78
 for <linux-nvdimm@lists.01.org>; Mon, 21 Aug 2017 14:08:04 -0700 (PDT)
Subject: [PATCH v5 0/7] libnvdimm: add DMA support for pmem blk-mq
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 21 Aug 2017 14:10:35 -0700
Message-ID: <150333903164.55214.3813479680626005389.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dmaengine@vger.kernel.org, hch@infradead.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

v5:
- Added support to report descriptor transfer capability limit from dmaengine.
- Fixed up scatterlist support for dma_unmap_data per Dan's comments.
- Made the driver a separate pmem blk driver per Christoph's suggestion
  and also fixed up all the issues pointed out by Christoph.
- Added pmem badblock checking/handling per Robert and also made DMA op to
  be used by all buffer sizes.

v4: 
- Addressed kbuild test bot issues. Passed kbuild test bot, 179 configs.

v3:
- Added patch to rename DMA_SG to DMA_SG_SG to make it explicit
- Added DMA_MEMCPY_SG transaction type to dmaengine
- Misc patch to add verification of DMA_MEMSET_SG that was missing
- Addressed all nd_pmem driver comments from Ross.

v2:
- Make dma_prep_memcpy_* into one function per Dan.
- Addressed various comments from Ross with code formatting and etc.
- Replaced open code with offset_in_page() macro per Johannes.

The following series implements a blk-mq pmem driver and
also adds infrastructure code to ioatdma and dmaengine in order to
support copying to and from scatterlist in order to process block
requests provided by blk-mq. The usage of DMA engines available on certain
platforms allow us to drastically reduce CPU utilization and at the same time
maintain performance that is good enough. Experimentations have been done on
DRAM backed pmem block device that showed the utilization of DMA engine is
beneficial. By default nd_pmem.ko will be loaded. This can be overridden
through module blacklisting in order to load nd_pmem_mq.ko.

---

Dave Jiang (7):
      dmaengine: ioatdma: revert 7618d035 to allow sharing of DMA channels
      dmaengine: Add DMA_MEMCPY_SG transaction op
      dmaengine: add verification of DMA_MEMSET_SG in dmaengine
      dmaengine: ioatdma: dma_prep_memcpy_sg support
      dmaengine: add function to provide per descriptor xfercap for dma engine
      dmaengine: add SG support to dmaengine_unmap
      libnvdimm: Add blk-mq pmem driver


 Documentation/dmaengine/provider.txt |    3 
 drivers/dma/dmaengine.c              |   31 +
 drivers/dma/ioat/dma.h               |    4 
 drivers/dma/ioat/init.c              |    6 
 drivers/dma/ioat/prep.c              |   57 ++
 drivers/nvdimm/Kconfig               |   23 +
 drivers/nvdimm/Makefile              |    3 
 drivers/nvdimm/pmem.h                |    3 
 drivers/nvdimm/pmem_mq.c             |  853 ++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h            |   42 ++
 10 files changed, 1021 insertions(+), 4 deletions(-)
 create mode 100644 drivers/nvdimm/pmem_mq.c

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
