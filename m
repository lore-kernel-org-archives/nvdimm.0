Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 5AF681A1E73
 for <linux-nvdimm@lists.01.org>; Tue, 10 May 2016 11:49:35 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v6 0/5] dax: handling media errors (clear-on-zero only)
Date: Tue, 10 May 2016 12:49:11 -0600
Message-Id: <1462906156-22303-1-git-send-email-vishal.l.verma@intel.com>
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
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Until now, dax has been disabled if media errors were found on
any device. This series attempts to address that.

The first two patches from Dan re-enable dax even when media
errors are present.

The third patch from Matthew removes the zeroout path from dax
entirely, making zeroout operations always go through the driver
(The motivation is that if a backing device has media errors,
and we create a sparse file on it, we don't want the initial
zeroing to happen via dax, we want to give the block driver a
chance to clear the errors).

Patch 4 reduces our calls to clear_pmem from dax in the
truncate/hole-punch cases. We check if the range being truncated
is sector aligned/sized, and if so, send blkdev_issue_zeroout
instead of clear_pmem so that errors can be handled better by
the driver.

Patch 5 fixes a redundant comment in DAX and is mostly unrelated
to the rest of this series.

This series also depends on/is based on Jan Kara's DAX Locking
fixes series [1].


[1]: http://www.spinics.net/lists/linux-mm/msg105819.html

v6:
 - Use IS_ALIGNED in dax_range_is_aligned instead of open coding
   an alignment check (Jan)
 - Collect all Reveiwed-by tags so far.

v5:
 - Drop the patch that attempts to clear-errors-on-write till we
   reach consensus on how to handle that.
 - Don't pass blk_dax_ctl to direct_access, instead pass in all the
   required arguments individually (Christoph, Dan)

v4:
 - Remove the dax->direct_IO fallbacks entirely. Instead, go through
   the usual direct_IO path when we're in O_DIRECT, and use dax_IO
   for other, non O_DIRECT IO. (Dan, Christoph)

v3:
 - Wrapper-ize the direct_IO fallback again and make an exception
   for -EIOCBQUEUED (Jeff, Dan)
 - Reduce clear_pmem usage in DAX to the minimum


Dan Williams (2):
  dax: fallback from pmd to pte on error
  dax: enable dax in the presence of known media errors (badblocks)

Matthew Wilcox (1):
  dax: use sb_issue_zerout instead of calling dax_clear_sectors

Vishal Verma (2):
  dax: for truncate/hole-punch, do zeroing through the driver if
    possible
  dax: fix a comment in dax_zero_page_range and dax_truncate_page

 Documentation/filesystems/dax.txt | 32 ++++++++++++++++
 arch/powerpc/sysdev/axonram.c     |  2 +-
 block/ioctl.c                     |  9 -----
 drivers/block/brd.c               |  2 +-
 drivers/nvdimm/pmem.c             | 10 ++++-
 drivers/s390/block/dcssblk.c      |  2 +-
 fs/block_dev.c                    |  2 +-
 fs/dax.c                          | 77 +++++++++++++--------------------------
 fs/ext2/inode.c                   |  7 ++--
 fs/xfs/xfs_bmap_util.c            | 15 ++------
 include/linux/blkdev.h            |  2 +-
 include/linux/dax.h               |  1 -
 12 files changed, 79 insertions(+), 82 deletions(-)

-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
