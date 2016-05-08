Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 8A33F1A1EC1
 for <linux-nvdimm@lists.01.org>; Sun,  8 May 2016 15:36:05 -0700 (PDT)
Subject: [PATCH 0/7] "Device DAX" for persistent memory
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 08 May 2016 15:35:10 -0700
Message-ID: <146274690999.10891.10714722986208180484.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Device DAX is the device-centric analogue of Filesystem DAX
(CONFIG_FS_DAX).  It allows memory ranges to be allocated and mapped
without need of an intervening file system or being bound to block
device semantics.  Device DAX is strict and predictable.  Specifically
this interface:

1/ Guarantees fault granularity with respect to a given page size (pte,
pmd, or pud) set at configuration time.

2/ Enforces deterministic behavior by being strict about what fault
scenarios are supported.

This first implementation, for persistent memory, is targeted at
applications like hypervisors and some databases that only need an
allocate + map mechanism from the kernel.  Later this mechanism can be
used to enable direct access to other performance/feature differentiated
memory ranges.

This series is built on "[PATCH 00/13] prep for device-dax, untangle
pfn-device setup" [1], posted at the end of March.

A libnvdimm pmem namespace can be switched from its default /dev/pmemX
(block device) interface to /dev/daxX.Y with the ndctl utility:

    ndctl create-namespace -m dax -e namespace0.0 -f

This implementation passes a basic setup, map, fault, and shutdown
sequence.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-March/005086.html

---

Dan Williams (7):
      libnvdimm: cleanup nvdimm_namespace_common_probe(), kill 'host'
      libnvdimm, dax: introduce device-dax infrastructure
      libnvdimm, dax: reserve space to store labels for device-dax
      libnvdimm, dax: record the specified alignment of a dax-device instance
      /dev/dax, pmem: direct access to persistent memory
      /dev/dax, core: file operations and dax-mmap
      Revert "block: enable dax for raw block devices"


 block/ioctl.c                       |   32 --
 drivers/Kconfig                     |    2 
 drivers/Makefile                    |    1 
 drivers/dax/Kconfig                 |   25 ++
 drivers/dax/Makefile                |    4 
 drivers/dax/dax.c                   |  543 +++++++++++++++++++++++++++++++++++
 drivers/dax/dax.h                   |   24 ++
 drivers/dax/pmem.c                  |  168 +++++++++++
 drivers/nvdimm/Kconfig              |   13 +
 drivers/nvdimm/Makefile             |    1 
 drivers/nvdimm/bus.c                |    4 
 drivers/nvdimm/claim.c              |    2 
 drivers/nvdimm/dax_devs.c           |   99 ++++++
 drivers/nvdimm/namespace_devs.c     |   38 ++
 drivers/nvdimm/nd-core.h            |    1 
 drivers/nvdimm/nd.h                 |   25 ++
 drivers/nvdimm/pfn.h                |    4 
 drivers/nvdimm/pfn_devs.c           |  116 +++++--
 drivers/nvdimm/region.c             |    2 
 drivers/nvdimm/region_devs.c        |   29 ++
 fs/block_dev.c                      |   96 ++----
 include/linux/fs.h                  |    8 -
 include/uapi/linux/fs.h             |    1 
 include/uapi/linux/ndctl.h          |    2 
 mm/huge_memory.c                    |    1 
 mm/hugetlb.c                        |    1 
 tools/testing/nvdimm/Kbuild         |   10 +
 tools/testing/nvdimm/config_check.c |    2 
 28 files changed, 1094 insertions(+), 160 deletions(-)
 create mode 100644 drivers/dax/Kconfig
 create mode 100644 drivers/dax/Makefile
 create mode 100644 drivers/dax/dax.c
 create mode 100644 drivers/dax/dax.h
 create mode 100644 drivers/dax/pmem.c
 create mode 100644 drivers/nvdimm/dax_devs.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
