Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [resend PATCH 0/3] fs, bdev: handle end of life
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 04 Jan 2016 10:20:00 -0800
Message-ID: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Per Dave, resend to include the xfs list on the full set.  These are
against v4.4-rc5.

---

As mentioned in [PATCH 1/3] "block, fs: reliably communicate bdev
end-of-life", historically we have waited for filesystem specific
heuristics to attempt to guess when a block device is gone.  Sometimes
this works, but in other cases the system can hang waiting for the fs to
trigger its shutdown protocol.

Now with DAX we need new actions, like unmapping all inodes, to be taken
upon a shutdown event.  Those actions need to be taken whether the
shutdown event comes from the block device being torn down, or some
other file system specific event.

For now, the approach taken in the following patches only affects xfs
and block drivers that are converted to use del_gendisk_queue().  We can
add more filesystems and driver support over time.

Note that 'bdi_gone' was chosen over 'shutdown' so as not to be confused
with generic_shutdown_super()

---

Dan Williams (3):
      block, fs: reliably communicate bdev end-of-life
      xfs: handle shutdown notifications
      writeback: fix false positive WARN in __mark_inode_dirty


 block/genhd.c                |   87 +++++++++++++++++++++++++++++++++++-------
 drivers/block/brd.c          |    3 -
 drivers/nvdimm/pmem.c        |    3 -
 drivers/s390/block/dcssblk.c |    6 +--
 fs/block_dev.c               |   79 +++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_super.c           |    9 ++++
 include/linux/fs.h           |    4 ++
 include/linux/genhd.h        |    1 
 mm/backing-dev.c             |    7 +++
 9 files changed, 166 insertions(+), 33 deletions(-)
