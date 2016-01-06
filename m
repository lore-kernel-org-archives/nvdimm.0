Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 0/4] fs, block: handle end of life
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 05 Jan 2016 20:56:16 -0800
Message-ID: <20160106045616.38788.61076.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1 [1]:

1/ move the del_gendisk() refactoring to its own patch (Dave)

2/ add unmap_dax_inodes to the xfs shutdown path (Dave)

3/ kill the unnecessary ->quiesce super operation and rename ->bdi_gone
   to ->force_failure. (Dave)

4/ rework tricky call to get_super() with a NULL bdev parameter. (Dave)

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-January/003797.html

---

As mentioned in [PATCH v2 2/4] "block: introduce del_gendisk_queue()" ,
historically we have waited for filesystem specific heuristics to
attempt to guess when a block device is gone.  Sometimes this works, but
in other cases the system can hang waiting for the fs to trigger its
shutdown protocol.

Now with DAX we need new actions, like unmapping all inodes, to be taken
upon a device loss event or fs corruption event.

For now, the approach taken in the following patches only affects xfs
and block drivers that are converted to use del_gendisk_queue().  We can
add more filesystems and driver support over time.

---

Dan Williams (4):
      block: prepare for del_gendisk_queue()
      block: introduce del_gendisk_queue()
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
