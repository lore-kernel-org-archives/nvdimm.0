Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 0/5] block, dax: updates for 4.4
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Oct 2015 13:10:15 -0400
Message-ID: <20151022171015.38343.72043.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, jack@suse.cz, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, david@fromorbit.com, linux-kernel@vger.kernel.org, hch@lst.de, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, willy@linux.intel.com, akpm@linux-foundation.org, ross.zwisler@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1: https://lists.01.org/pipermail/linux-nvdimm/2015-October/002538.html

1/ Rename file_bd_inode to bdev_file_inode (Jan Kara)

2/ Clarify sb_start_pagefault() comment (Jan Kara)

3/ Collect Reviewed-by's

---

As requested [1], break out the block specific updates from the dax-gup
series [2], to merge via the block tree.

1/ Enable dax mappings for raw block devices.  This addresses the review
   comments (from Ross and Honza) from the RFC [3].

2/ Introduce dax_map_atomic() to fix races between device teardown and
   new mapping requests.  This depends on commit 2a9067a91825 "block:
   generic request_queue reference counting" in for-4.4/integrity branch
   of the block tree.

3/ Cleanup clear_pmem() and its usage in dax.  This depends on commit
   0f90cc6609c7 "mm, dax: fix DAX deadlocks" that was merged into v4.3-rc6.

These pass the nvdimm unit tests and have passed a 0day-kbuild-robot run.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-October/002531.html
[2]: https://lists.01.org/pipermail/linux-nvdimm/2015-October/002387.html
[3]: https://lists.01.org/pipermail/linux-nvdimm/2015-October/002512.html

---

Dan Williams (5):
      pmem, dax: clean up clear_pmem()
      dax: increase granularity of dax_clear_blocks() operations
      block, dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()
      block: introduce bdev_file_inode()
      block: enable dax for raw block devices

 arch/x86/include/asm/pmem.h |    7 --
 block/blk.h                 |    2 
 fs/block_dev.c              |   79 ++++++++++++++++-
 fs/dax.c                    |  196 +++++++++++++++++++++++++++----------------
 include/linux/blkdev.h      |    2 
 5 files changed, 197 insertions(+), 89 deletions(-)
