Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id C2CBF1A1E00
 for <linux-nvdimm@lists.01.org>; Sun, 26 Jun 2016 16:13:24 -0700 (PDT)
Subject: [PATCH 0/2] nfit_test: convert to vmalloc()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Jun 2016 16:12:08 -0700
Message-ID: <146698272810.40036.6685354433183952465.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

While backporting nfit_test to distro kernels a conflict between CMA and
SWIOTLB was discovered. CMA requirements have also been a stumbling
point for others trying to execute the tests.

---

Dan Williams (2):
      libnvdimm, pmem: allow nfit_test to override pmem_direct_access()
      tools/testing/nvdimm: replace CONFIG_DMA_CMA dependency with vmalloc()


 drivers/nvdimm/pmem.c                 |   18 ++---------
 drivers/nvdimm/pmem.h                 |   24 +++++++++++++++
 include/linux/pfn_t.h                 |    5 ++-
 kernel/memremap.c                     |    6 ----
 tools/testing/nvdimm/Kbuild           |    5 ++-
 tools/testing/nvdimm/pmem-dax.c       |   54 +++++++++++++++++++++++++++++++++
 tools/testing/nvdimm/test/iomap.c     |   19 +++++++++++-
 tools/testing/nvdimm/test/nfit.c      |   48 ++++-------------------------
 tools/testing/nvdimm/test/nfit_test.h |    2 +
 9 files changed, 115 insertions(+), 66 deletions(-)
 create mode 100644 drivers/nvdimm/pmem.h
 create mode 100644 tools/testing/nvdimm/pmem-dax.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
