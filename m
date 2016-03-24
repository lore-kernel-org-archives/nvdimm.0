Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 7979A1A1ECD
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:26:25 -0700 (PDT)
Subject: [PATCH 00/13] prep for device-dax, untangle pfn-device setup
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:25:21 -0700
Message-ID: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The infrastructure for setting up a pfn-device (struct page memmap array
allocation for reserved memory) is generally useful.  Untangle it from
the pmem driver and make it available as core libnvdimm functionality.
The motivation for this work is an investigation into a standalone
device-dax facility, but the changes stand on their own.

Outside of exporting nvdimm_setup_pfn() as a generic facility this also
includes the following benefits:

1/ fix a section alignment vs badblocks tracking bug

2/ struct pmem_device sheds 24 bytes

3/ struct blk_device is replaced with some (smaller in total) extensions
   to struct nd_namespace_blk.

4/ Reduce pointer chasing by retrieving driver private data from
   ->queuedata rather than bio->bi_bdev->bd_disk->private_data.

---

Dan Williams (13):
      libnvdimm, pfn: fix nvdimm_namespace_add_poison() vs section alignment
      libnvdimm, pmem: kill pmem->ndns
      libnvdimm, pfn, convert nd_pfn_probe() to devm
      libnvdimm, btt, convert nd_btt_probe() to devm
      libnvdimm, blk: use devm_add_action to release bdev resources
      libnvdimm, blk: use ->queuedata for driver private data
      libnvdimm, pmem: use ->queuedata for driver private data
      libnvdimm, blk: move i/o infrastructure to nd_namespace_blk
      libnvdimm, pmem: use devm_add_action to release bdev resources
      libnvdimm, pmem: clean up resource print / request
      libnvdimm, pmem, pfn: make pmem_rw_bytes generic and refactor pfn setup
      libnvdimm, pmem, pfn: move pfn setup to the core
      libnvdimm, pmem: kill ->pmem_queue and ->pmem_disk


 drivers/nvdimm/blk.c              |  208 ++++++++--------
 drivers/nvdimm/btt.c              |   20 +-
 drivers/nvdimm/btt_devs.c         |   24 +-
 drivers/nvdimm/claim.c            |   61 +++++
 drivers/nvdimm/core.c             |   41 ++-
 drivers/nvdimm/nd.h               |   50 +++-
 drivers/nvdimm/pfn_devs.c         |  208 +++++++++++++++-
 drivers/nvdimm/pmem.c             |  475 +++++++++----------------------------
 include/linux/nd.h                |   11 +
 tools/testing/nvdimm/Kbuild       |    1 
 tools/testing/nvdimm/test/iomap.c |   27 ++
 11 files changed, 579 insertions(+), 547 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
