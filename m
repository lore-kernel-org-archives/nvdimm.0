Return-Path: <linux-ext4-owner@vger.kernel.org>
Subject: [PATCH 0/8] dax fixes / cleanups: pmd vs thp, lifetime, and locking
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 17 Nov 2015 12:15:52 -0800
Message-ID: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.com>, Boaz Harrosh <boaz@plexistor.com>, Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Yigal Korman <yigal@plexistor.com>, stable@vger.kernel.org, Jens Axboe <axboe@fb.com>, Jeff Moyer <jmoyer@redhat.com>, linux-block@vger.kernel.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, akpm@linux-foundation.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

Changes since last posting [1]:

1/ Further cleanups to dax_clear_blocks(): Dropped increments of 'addr'
   since we call bdev_direct_access() before the next use, and dropped the
   BUG_ON for sector unaligned return values from bdev_direct_access().

2/ In [PATCH 8/8] introduce blk_dax_ctl to remove the need to have
   separate dax_map_atomic and __dax_map_atomic routines.  Note,
   blk_dax_ctl is not passed through to drivers, it gets unpacked in
   bdev_direct_access.  (Willy)

3/ New [PATCH 2/8]: Disable huge page dax mappings while we resolve
   various crash scenarios in this development cycle.

4/ New [PATCH 4/8]: Unmap all dax mappings at block device shutdown

I have kept the reviewed-by's received to date, let me know if these
incremental updates invalidate that review.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-November/002733.html

---

The first 4 patches in this series I consider 4.4-rc / -stable material.
The rest are for 4.5.  [PATCH 4/8] needs scrutiny.  It is yet another
example of where DAX behavior necessarily differs from page cache
behavior.  I still maintain that we should not be surprising unaware
applications with DAX semantics, i.e. that DAX should be per-inode
opt-in, not globally enabled for all inodes at fs mount time.

The largest patch in the set, [PATCH 8/8], addresses the lifetime of the
'addr' returned by bdev_direct_access.  That address is only valid while
the device driver is enabled.  The new dax_map_atomic() /
dax_unmap_atomic() pairing guarantees that 'addr' stays valid for the
duration of that mapping.

While dax_map_atomic() protects against 'addr' going invalid, the new
calls to truncate_pagecache() via invalidate_inodes() protect against
the 'pfn' returned from bdev_direct_access() going invalid.  Otherwise,
the storage media can be directly accessed after the driver has been
disabled.

---

[PATCH 1/8] ext2, ext4: warn when mounting with dax enabled
[PATCH 2/8] dax: disable pmd mappings
[PATCH 3/8] mm, dax: fix DAX deadlocks (COW fault)
[PATCH 4/8] mm, dax: truncate dax mappings at bdev or fs shutdown
[PATCH 5/8] pmem, dax: clean up clear_pmem()
[PATCH 6/8] dax: increase granularity of dax_clear_blocks() operations
[PATCH 7/8] dax: guarantee page aligned results from bdev_direct_access()
[PATCH 8/8] dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()

 arch/x86/include/asm/pmem.h |    7 -
 block/blk.h                 |    2 
 fs/Kconfig                  |    6 +
 fs/block_dev.c              |   15 +--
 fs/dax.c                    |  228 ++++++++++++++++++++++++++-----------------
 fs/ext2/super.c             |    2 
 fs/ext4/super.c             |    6 +
 fs/inode.c                  |   27 +++++
 include/linux/blkdev.h      |   19 +++-
 mm/memory.c                 |    8 +-
 mm/truncate.c               |   13 ++
 11 files changed, 217 insertions(+), 116 deletions(-)
