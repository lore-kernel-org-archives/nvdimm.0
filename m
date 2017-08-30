Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A4B2D2095BB75
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 13:55:29 -0700 (PDT)
Subject: [PATCH v7 0/9] libnvdimm: add DMA supported blk-mq pmem driver
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 30 Aug 2017 13:55:32 -0700
Message-ID: <150412628764.69288.12074115435918322858.stgit@djiang5-desk3.ch.intel.com>
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

- Per Dan's suggestions
  - Moved all common code from attach_disk to pmem_core as helper functions.
  - Fixed up Kconfig dependencies
  - Cleaned up header file inclusions
  - Removed module parameters
  - Split pmem_core refactor into own patch
  - Removed REQ_FLUSH define

v6:
- Put all common code for pmem drivers in pmem_core per Dan's suggestion.
- Added support code to get number of available DMA chans
- Fixed up Kconfig so that when pmem is built into the kernel, pmem_dma won't
  show up. 

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

The following series implements a DMA driven blk-mq pmem driver and
also adds infrastructure code to ioatdma and dmaengine in order to
support copying to and from scatterlist in order to process block
requests provided by blk-mq. The usage of DMA engines available on certain
platforms allow us to drastically reduce CPU utilization and at the same time
maintain performance that is good enough. Experimentations have been done on
DRAM backed pmem block device that showed the utilization of DMA engine is
beneficial. By default nd_pmem.ko will be loaded. This can be overridden
through module blacklisting in order to load nd_pmem_dma.ko.

---

Dave Jiang (9):
      dmaengine: ioatdma: revert 7618d035 to allow sharing of DMA channels
      dmaengine: Add DMA_MEMCPY_SG transaction op
      dmaengine: ioatdma: dma_prep_memcpy_sg support
      dmaengine: add function to provide per descriptor xfercap for dma engine
      dmaengine: add SG support to dmaengine_unmap
      dmaengine: provide number of available channels
      libnvdimm: remove definition of REQ_FLUSH
      libnvdimm: move common function for pmem to pmem_core
      libnvdimm: Add DMA based blk-mq pmem driver


 Documentation/dmaengine/provider.txt |    3 
 drivers/dma/dmaengine.c              |   72 +++++
 drivers/dma/ioat/dma.h               |    4 
 drivers/dma/ioat/init.c              |    6 
 drivers/dma/ioat/prep.c              |   57 ++++
 drivers/nvdimm/Kconfig               |   28 ++
 drivers/nvdimm/Makefile              |    6 
 drivers/nvdimm/pmem.c                |  408 +----------------------------
 drivers/nvdimm/pmem.h                |   55 ++++
 drivers/nvdimm/pmem_core.c           |  451 ++++++++++++++++++++++++++++++++
 drivers/nvdimm/pmem_dma.c            |  475 ++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h            |   49 +++-
 12 files changed, 1213 insertions(+), 401 deletions(-)
 create mode 100644 drivers/nvdimm/pmem_core.c
 create mode 100644 drivers/nvdimm/pmem_dma.c

--
Signature
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
