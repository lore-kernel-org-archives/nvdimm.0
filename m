Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id CD4BC1A1ED2
 for <linux-nvdimm@lists.01.org>; Thu,  3 Mar 2016 13:53:37 -0800 (PST)
Subject: [PATCH v2 0/3] libnvdimm, pfn: support section misaligned pmem
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 03 Mar 2016 13:53:04 -0800
Message-ID: <20160303215304.1014.69931.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

Permit platforms with section-misaligned persistent memory to establish
memory-mode (pfn) namespaces.  This sacrifices 64-128MB of pmem to gain
third-party DMA/RDMA support.

Changes since v1 [1]:

1/ Dropped "mm: fix mixed zone detection in devm_memremap_pages" since
   it was pulled into Andrew's tree.

2/ Moved CONFIG_SPARSEMEM #ifdef guards into drivers/nvdimm/pfn.h

3/ Added "libnvdimm, pmem: adjust for section collisions with 'System
   RAM'", i.e. support for reserving head and tail capacity out of a
   namespace to permit a section aligned range to be used for a
   'pfn'-device instance.

4/ Added 'resource' and 'size' attributes to an active pfn instance.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-February/004727.html

This series is built on top of tip.git/core/resources.

---

Dan Williams (3):
      libnvdimm, pmem: fix 'pfn' support for section-misaligned namespaces
      libnvdimm, pmem: adjust for section collisions with 'System RAM'
      libnvdimm, pfn: 'resource'-address and 'size' attributes for pfn devices


 drivers/nvdimm/namespace_devs.c |    7 ++
 drivers/nvdimm/pfn.h            |   23 ++++++
 drivers/nvdimm/pfn_devs.c       |   61 ++++++++++++++++
 drivers/nvdimm/pmem.c           |  145 ++++++++++++++++++++++++++++++---------
 4 files changed, 200 insertions(+), 36 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
