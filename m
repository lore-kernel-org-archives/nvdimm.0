Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 1301A1A203E
 for <linux-nvdimm@lists.01.org>; Sat, 23 Apr 2016 12:13:57 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 0/7] dax: handling media errors
Date: Sat, 23 Apr 2016 13:13:35 -0600
Message-Id: <1461438822-3592-1-git-send-email-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

Until now, dax has been disabled if media errors were found on
any device. This series attempts to address that.

The first three patches from Dan re-enable dax even when media
errors are present.

The fourth patch from Matthew removes the
zeroout path from dax entirely, making zeroout operations always
go through the driver (The motivation is that if a backing device
has media errors, and we create a sparse file on it, we don't
want the initial zeroing to happen via dax, we want to give the
block driver a chance to clear the errors).

The fifth patch changes the behaviour of dax_do_io by adding a
wrapper around it that is passed all the arguments also needed by
__blockdev_do_direct_IO. If (the new) __dax_do_io fails with -EIO
due to a bad block, we simply retry with the direct_IO path which
forces the IO to go through the block driver, and can attempt to
clear the error.

Patch 6 reduces our calls to clear_pmem from dax in the
truncate/hole-punch cases. We check if the range being truncated
is sector aligned/sized, and if so, send blkdev_issue_zeroout
instead of clear_pmem so that errors can be handled better by
the driver.

Patch 7 fixes a redundant comment in DAX and is mostly unrelated
to the rest of this series.

This series also depends on/is based on Jan Kara's DAX Locking
fixes series [1].


[1]: http://www.spinics.net/lists/linux-mm/msg105819.html

v3:
 - Wrapper-ize the direct_IO fallback again and make an exception
   for -EIOCBQUEUED (Jeff, Dan)
 - Reduce clear_pmem usage in DAX to the minimum

Dan Williams (3):
  block, dax: pass blk_dax_ctl through to drivers
  dax: fallback from pmd to pte on error
  dax: enable dax in the presence of known media errors (badblocks)

Matthew Wilcox (1):
  dax: use sb_issue_zerout instead of calling dax_clear_sectors

Vishal Verma (3):
  dax: handle media errors in dax_do_io
  dax: for truncate/hole-punch, do zeroing through the driver if
    possible
  dax: fix a comment in dax_zero_page_range and dax_truncate_page

 arch/powerpc/sysdev/axonram.c | 10 +++---
 block/ioctl.c                 |  9 -----
 drivers/block/brd.c           |  9 ++---
 drivers/nvdimm/pmem.c         | 17 +++++++---
 drivers/s390/block/dcssblk.c  | 12 +++----
 fs/block_dev.c                |  7 ++--
 fs/dax.c                      | 78 +++++++++++++++----------------------------
 fs/ext2/inode.c               | 12 +++----
 fs/ext4/inode.c               |  5 +--
 fs/xfs/xfs_aops.c             |  8 ++---
 fs/xfs/xfs_bmap_util.c        | 15 +++------
 include/linux/blkdev.h        |  3 +-
 include/linux/dax.h           | 31 ++++++++++++++++-
 13 files changed, 108 insertions(+), 108 deletions(-)

-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
