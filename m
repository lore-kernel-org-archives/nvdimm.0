Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 99E0D1A1E04
 for <linux-nvdimm@lists.01.org>; Tue, 21 Jun 2016 13:47:14 -0700 (PDT)
Subject: [PATCH v4 0/5] Introduce device_add_disk() to kill
 gendisk.driverfs_dev
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 21 Jun 2016 13:46:01 -0700
Message-ID: <146654196111.34694.7735150373057824399.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: axboe@fb.com
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Ulf Hansson <ulf.hansson@linaro.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org, hch@lst.de, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, David Woodhouse <dwmw2@infradead.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v3 [1]:

1/ Broke out the non-trivial conversions into their own patches.

2/ Fix a behavior change in arch/um/drivers/ubd_kern.c. This driver
   optionally creates parented and un-parented block devices.  (Bart)

3/ Fix a behavior change in drivers/mmc/card/block.c. This driver does
   not use blk-core infrastructure for partitions and instead registers
   partitions as gendisk-children of the whole device gendisk.
   Crediting Bart since his report triggered this re-review.

4/ Use the local CARD_TO_DEV() helper in drivers/block/rsxx/dev.c.

5/ Use the local 'dev' variable that represents the parent device in
   drivers/scsi/sd.c.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-June/005988.html

---

Answer the "// FIXME: remove" include/linux/genhd.h.  This should be
functionally equivalent to the previous state.  These patches received a
build success notification from the kbuild robot across 122 configs.

---

Dan Williams (5):
      block: introduce device_add_disk()
      mmc: move 'parent' tracking to mmc_blk_data
      um: track 'parent' device in a local variable
      block: convert to device_add_disk()
      block: remove ->driverfs_dev


 arch/powerpc/sysdev/axonram.c       |    3 +--
 arch/um/drivers/ubd_kern.c          |    5 +++--
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
 drivers/mmc/card/block.c            |    5 +++--
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
 30 files changed, 50 insertions(+), 72 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
