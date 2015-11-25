Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 0/7] dax cleanups and lifetime fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Nov 2015 10:36:56 -0800
Message-ID: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, Jeff Moyer <jmoyer@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1: [1]

1/ Dropped the patches that were merged for v4.4-rc2

2/ Introduce a new super-block flag that filesystems can use to error
   out early when there is no longer a backing device available. Use it to
   prevent a spurious warning triggered by ext4 on surprise removal. (Dave)

3/ Include the unmap_partition implementation initially posted here [2].

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-November/002876.html
[2]: https://lists.01.org/pipermail/linux-nvdimm/2015-November/002922.html

Testing this patch set reveals that xfs needs more XFS_FORCED_SHUTDOWN
checks, especially in the unmount path.  Currently we deadlock here on
umount after block device removal:

 INFO: task umount:2187 blocked for more than 120 seconds.
       Tainted: G           O    4.4.0-rc2+ #1953  
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 umount          D ffff8800d2fbfd70     0  2187   2095 0x00000080
  ffff8800d2fbfd70 ffffffff81f94f98 ffff88031fc97bd8 ffff88030af5ad80
  ffff8800db71db00 ffff8800d2fc0000 ffff8800db8dbde0 ffff8800d93b6708
  ffff8800d93b6760 ffff8800d93b66d8 ffff8800d2fbfd88 ffffffff818f0695
 Call Trace:
  [<ffffffff818f0695>] schedule+0x35/0x80
  [<ffffffffa01e134e>] xfs_ail_push_all_sync+0xbe/0x110 [xfs]
  [<ffffffff810ecc30>] ? wait_woken+0x80/0x80
  [<ffffffffa01c8d91>] xfs_unmountfs+0x81/0x1b0 [xfs]
  [<ffffffffa01c991b>] ? xfs_mru_cache_destroy+0x6b/0x90 [xfs]
  [<ffffffffa01cbf30>] xfs_fs_put_super+0x30/0x90 [xfs]
  [<ffffffff81247eca>] generic_shutdown_super+0x6a/0xf0

Earlier in this trace xfs has already performed:

 XFS (pmem0m): xfs_do_force_shutdown(0x2) called from line 1197 of file fs/xfs/xfs_log.c.

...but xfs_log_work_queue() continues to run periodically.

---

The motivation for these lifetime fixes is to prevent crashes and
mapping leaks when using dax.  Most of the safety guarantees in this
series come from the protection afforded by blk_queue_enter +
blk_queue_exit.  After a successful blk_queue_enter we can issue any
block device operations we want without needing to worry about the block
layer infrastructure for the device being torn down.

blk_queue_enter is chosen for this "is bdev alive?" check over
SB_I_BDI_DEAD or error returns from get_blocks() because it synchronizes
with blk_cleanup_queue.  SB_I_BDI_DEAD is there to let a file system
optionally error out early before getting -ENODEV from the block layer,
but it's optional an asynchronous.

---

Dan Williams (7):
      pmem, dax: clean up clear_pmem()
      dax: increase granularity of dax_clear_blocks() operations
      dax: guarantee page aligned results from bdev_direct_access()
      dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()
      fs: notify superblocks of backing-device death
      ext4: skip inode dirty when backing device is gone
      mm, dax: unmap dax mappings at bdev shutdown


 arch/x86/include/asm/pmem.h  |    7 -
 block/genhd.c                |   93 +++++++++++++++--
 drivers/block/brd.c          |    3 -
 drivers/nvdimm/pmem.c        |    3 -
 drivers/s390/block/dcssblk.c |    6 -
 fs/block_dev.c               |   73 ++++++++++++--
 fs/dax.c                     |  224 +++++++++++++++++++++++++-----------------
 fs/fs-writeback.c            |    3 +
 include/linux/blkdev.h       |   17 +++
 include/linux/fs.h           |    3 +
 include/linux/genhd.h        |    1 
 11 files changed, 304 insertions(+), 129 deletions(-)
