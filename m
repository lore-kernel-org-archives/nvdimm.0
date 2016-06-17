Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id A0FD91A1E21
 for <linux-nvdimm@lists.01.org>; Fri, 17 Jun 2016 09:35:44 -0700 (PDT)
Subject: [PATCH v3 0/3] Introduce device_add_disk() to kill
 gendisk.driverfs_dev
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Jun 2016 09:34:34 -0700
Message-ID: <146618127395.31030.11800447312061202344.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-block@vger.kernel.org
Cc: axboe@fb.com, Ulf Hansson <ulf.hansson@linaro.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-nvdimm@lists.01.org, Keith Busch <keith.busch@intel.com>, David Woodhouse <dwmw2@infradead.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v2 [1]:

* Rebase on top of linux-block.git for-4.8/drivers

[1]: https://lkml.org/lkml/2016/3/11/414

---

Answer the "// FIXME: remove" include/linux/genhd.h.  This should be
functionally equivalent to the previous state.  These patches received a
build success notification from the kbuild robot across 116 configs.

The following series implements...

---

Dan Williams (3):
      block: introduce device_add_disk()
      block: convert to device_add_disk()
      block: remove ->driverfs_dev


 arch/powerpc/sysdev/axonram.c       |    3 +--
 arch/um/drivers/ubd_kern.c          |    3 +--
 block/genhd.c                       |   18 +++++++++---------
 drivers/block/cciss.c               |    3 +--
 drivers/block/floppy.c              |    3 +--
 drivers/block/mtip32xx/mtip32xx.c   |    5 ++---
 drivers/block/ps3disk.c             |    3 +--
 drivers/block/ps3vram.c             |    3 +--
 drivers/block/rsxx/dev.c            |    4 +---
 drivers/block/skd_main.c            |    8 +++-----
 drivers/block/sunvdc.c              |    3 +--
 drivers/block/virtio_blk.c          |    3 +--
 drivers/block/xen-blkfront.c        |    3 +--
 drivers/ide/ide-cd.c                |    3 +--
 drivers/ide/ide-gd.c                |    3 +--
 drivers/memstick/core/ms_block.c    |    3 +--
 drivers/memstick/core/mspro_block.c |    3 +--
 drivers/mmc/card/block.c            |    3 +--
 drivers/mtd/mtd_blkdevs.c           |    4 +---
 drivers/nvdimm/blk.c                |    3 +--
 drivers/nvdimm/btt.c                |    3 +--
 drivers/nvdimm/bus.c                |    2 +-
 drivers/nvdimm/pmem.c               |    3 +--
 drivers/nvme/host/core.c            |    3 +--
 drivers/s390/block/dasd_genhd.c     |    3 +--
 drivers/s390/block/dcssblk.c        |    3 +--
 drivers/s390/block/scm_blk.c        |    3 +--
 drivers/scsi/sd.c                   |    3 +--
 drivers/scsi/sr.c                   |    3 +--
 include/linux/genhd.h               |    8 ++++++--
 30 files changed, 46 insertions(+), 72 deletions(-)

--
Signature
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
