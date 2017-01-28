Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F21E81FF4
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:40:10 -0800 (PST)
Subject: [RFC PATCH 00/17] introduce a dax_inode for dax_operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:36:04 -0800
Message-ID: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: snitzer@redhat.com, mawilcox@microsoft.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Recently there was an effort to introduce dax_operations to unwind the
abuse of the user-copy api in the pmem api [1]. Christoph noted that we
should not add new block-dax operations as it is further abuse of struct
block_device [2].

The ->direct_access() method in block_device_operations was an expedient
way to get the filesystem-dax capability bootstrapped. However, looking
forward to native persistent memory filesystems, they can forgo the
block layer and mount directly on a provider of dax services, a dax
inode.

For the time being, since current dax capable filesystems are block
based, we need a facility to look up this dax object via the
block-device name. If this approach looks reasonable I'll follow up with
reworking the proposed ->copy_from_iter(), ->flush(), and ->clear() dax
operations into this new scheme.

These patches survive a run of the libnvdimm unit tests, but I have not
tested the non-libnvdimm dax drivers.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-January/008586.html
[2]: https://lists.01.org/pipermail/linux-nvdimm/2017-January/008638.html

---

Dan Williams (17):
      dax: refactor dax-fs into a generic provider of dax inodes
      dax: convert dax_inode locking to srcu
      dax: add a facility to lookup a dax inode by 'host' device name
      dax: introduce dax_operations
      pmem: add dax_operations support
      axon_ram: add dax_operations support
      brd: add dax_operations support
      dcssblk: add dax_operations support
      block: kill bdev_dax_capable()
      block: introduce bdev_dax_direct_access()
      dm: add dax_operations support (producer)
      dm: add dax_operations support (consumer)
      fs: update mount_bdev() to lookup dax infrastructure
      ext2, ext4, xfs: retrieve dax_inode through iomap operations
      Revert "block: use DAX for partition table reads"
      fs, dax: convert filesystem-dax to bdev_dax_direct_access
      block: remove block_device_operations.direct_access and related infrastructure


 arch/powerpc/platforms/Kconfig  |    1 
 arch/powerpc/sysdev/axonram.c   |   37 +++
 block/Kconfig                   |    1 
 block/partition-generic.c       |   17 --
 drivers/Makefile                |    2 
 drivers/block/Kconfig           |    1 
 drivers/block/brd.c             |   48 +++-
 drivers/dax/Kconfig             |    9 +
 drivers/dax/Makefile            |    5 
 drivers/dax/dax.h               |   19 +-
 drivers/dax/device-dax.h        |   25 ++
 drivers/dax/device.c            |  257 ++++-------------------
 drivers/dax/pmem.c              |    2 
 drivers/dax/super.c             |  434 +++++++++++++++++++++++++++++++++++++++
 drivers/md/Kconfig              |    1 
 drivers/md/dm-core.h            |    3 
 drivers/md/dm-linear.c          |   15 +
 drivers/md/dm-snap.c            |    8 +
 drivers/md/dm-stripe.c          |   16 +
 drivers/md/dm-table.c           |    2 
 drivers/md/dm-target.c          |   10 +
 drivers/md/dm.c                 |   43 +++-
 drivers/nvdimm/Kconfig          |    1 
 drivers/nvdimm/pmem.c           |   46 +++-
 drivers/nvdimm/pmem.h           |    7 -
 drivers/s390/block/Kconfig      |    1 
 drivers/s390/block/dcssblk.c    |   41 +++-
 fs/block_dev.c                  |   75 ++-----
 fs/dax.c                        |  149 ++++++-------
 fs/ext2/inode.c                 |    1 
 fs/ext4/inode.c                 |    1 
 fs/iomap.c                      |    3 
 fs/super.c                      |   32 +++
 fs/xfs/xfs_aops.c               |   13 +
 fs/xfs/xfs_aops.h               |    1 
 fs/xfs/xfs_buf.h                |    1 
 fs/xfs/xfs_iomap.c              |    1 
 fs/xfs/xfs_super.c              |    3 
 include/linux/blkdev.h          |    7 -
 include/linux/dax.h             |   29 ++-
 include/linux/device-mapper.h   |   16 +
 include/linux/fs.h              |    1 
 include/linux/iomap.h           |    1 
 tools/testing/nvdimm/Kbuild     |    6 -
 tools/testing/nvdimm/pmem-dax.c |   12 -
 45 files changed, 927 insertions(+), 477 deletions(-)
 create mode 100644 drivers/dax/device-dax.h
 rename drivers/dax/{dax.c => device.c} (74%)
 create mode 100644 drivers/dax/super.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
