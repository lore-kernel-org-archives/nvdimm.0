Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 1BC011A1FBE
 for <linux-nvdimm@lists.01.org>; Wed, 18 May 2016 13:56:58 -0700 (PDT)
Subject: [PATCH v3 0/5] "Device DAX" for persistent memory
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 May 2016 13:56:06 -0700
Message-ID: <146360496572.37439.6497663679891935585.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, hch@lst.de, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v2 [1]:

1/ Allow libnvdimm drivers to omit a ->remove() method (Johannes)

2/ Fix memory leak due to missing ida_destroy() in drivers/nvdimm/ and
drivers/dax/ (Johannes)

3/ Mark some dev_dbg() instances as dev_info() (Johannes)

4/ Clarify RCU usage in dax.c (Johannes), acked-by Paul.

---

Device DAX is the device-centric analogue of Filesystem DAX
(CONFIG_FS_DAX).  It allows memory ranges to be allocated and mapped
without need of an intervening file system or being bound to block
device semantics.

Why "Device DAX"?

1/ As I mentioned at LSF [2] we are starting to see platforms with
performance and feature differentiated memory ranges.  Environments like
high-performance-computing and usages like in-memory databases want
exclusive allocation of a memory range with zero conflicting
kernel/metadata allocations.  For dedicated applications of high
bandwidth or low latency memory device-DAX provides a predictable direct
map mechanism.

Note that this is only for the small number of "crazy" applications that
are willing to re-write to get every bit of performance.  For everyone
else we, Dave Hansen and I, are looking to add a mechanism to hot-plug
device-DAX ranges into the mm to get general memory management services
(oversubscribe / migration, etc) with the understanding that it may
sacrifice some predictability.

2/ For persistent memory there are similar applications that are willing
to re-write to take full advantage of byte-addressable persistence.
This mechanism satisfies those usages that only need a pre-allocated
file to mmap.

3/ It answers Dave Chinner's call to start thinking about pmem-native
solutions.  Device DAX specifically avoids block-device and file system
conflicts.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-May/005766.html
[2]: https://lwn.net/Articles/685107/

---

Dan Williams (5):
      libnvdimm: stop requiring a driver ->remove() method
      /dev/dax, pmem: direct access to persistent memory
      /dev/dax, core: file operations and dax-mmap
      Revert "block: enable dax for raw block devices"
      libnvdimm: release ida resources

 block/ioctl.c                       |   32 --
 drivers/Kconfig                     |    2
 drivers/Makefile                    |    1
 drivers/dax/Kconfig                 |   26 ++
 drivers/dax/Makefile                |    4
 drivers/dax/dax.c                   |  575 +++++++++++++++++++++++++++++++++++
 drivers/dax/dax.h                   |   24 +
 drivers/dax/pmem.c                  |  158 ++++++++++
 drivers/nvdimm/bus.c                |    9 -
 drivers/nvdimm/core.c               |    3
 drivers/nvdimm/dimm_devs.c          |    5
 drivers/nvdimm/nd-core.h            |    2
 drivers/nvdimm/region_devs.c        |    5
 fs/block_dev.c                      |   96 ++----
 include/linux/fs.h                  |    8
 include/uapi/linux/fs.h             |    1
 mm/huge_memory.c                    |    1
 mm/hugetlb.c                        |    1
 tools/testing/nvdimm/Kbuild         |    9 +
 tools/testing/nvdimm/config_check.c |    2
 20 files changed, 852 insertions(+), 112 deletions(-)
 create mode 100644 drivers/dax/Kconfig
 create mode 100644 drivers/dax/Makefile
 create mode 100644 drivers/dax/dax.c
 create mode 100644 drivers/dax/dax.h
 create mode 100644 drivers/dax/pmem.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
