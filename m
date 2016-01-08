Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v3 0/5] fs, block: handle end of life
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 07 Jan 2016 16:42:54 -0800
Message-ID: <20160108004254.36061.32864.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <dchinner@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v2 [1]:

1/ Split "block: introduce del_gendisk_queue()" into a patch that
   introduces del_gendisk_queue() with no functional difference to the
   open coded version and "block: introduce force_failure_partition()
   and unmap_dax_inodes()" which adds the new behavior.

2/ Collect Dave's ack on "xfs: unmap dax at shutdown (force_failure)"

---

As mentioned in [PATCH v3 3/5] "block: introduce
force_failure_partition() and unmap_dax_inodes()" historically we have
waited for filesystem specific heuristics to attempt to guess when a
block device is gone.  Sometimes this works, but in other cases the
system can hang waiting for the fs to trigger its shutdown protocol.

Now with DAX we need new actions, like unmapping all inodes, to be taken
upon a device loss event or fs corruption event.

For now, the approach taken in the following patches only affects xfs
and block drivers that are converted to use del_gendisk_queue().  We can
add more filesystems and driver support over time.

---

Dan Williams (5):
      block: prepare for del_gendisk_queue()
      block: introduce del_gendisk_queue()
      block: introduce force_failure_partition() and unmap_dax_inodes()
      xfs: unmap dax at shutdown (force_failure)
      block, xfs: implement 'force_failure' notifications


 block/genhd.c                |   87 +++++++++++++++++++++++++++++++++++-------
 drivers/block/brd.c          |    9 +---
 drivers/nvdimm/pmem.c        |    3 -
 drivers/s390/block/dcssblk.c |    6 +--
 fs/block_dev.c               |   22 +++++++++++
 fs/inode.c                   |   28 ++++++++++++++
 fs/xfs/xfs_fsops.c           |    9 ++++
 fs/xfs/xfs_super.c           |    8 ++++
 include/linux/fs.h           |    3 +
 include/linux/genhd.h        |    1 
 10 files changed, 150 insertions(+), 26 deletions(-)
