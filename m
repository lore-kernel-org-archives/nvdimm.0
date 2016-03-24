Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id DC86B1A1E84
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 16:18:14 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 0/5] dax: handling of media errors
Date: Thu, 24 Mar 2016 17:17:25 -0600
Message-Id: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
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
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
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

Dan Williams (3):
  block, dax: pass blk_dax_ctl through to drivers
  dax: fallback from pmd to pte on error
  dax: enable dax in the presence of known media errors (badblocks)

Vishal Verma (2):
  dax: use sb_issue_zerout instead of calling dax_clear_sectors
  dax: handle media errors in dax_do_io

 arch/powerpc/sysdev/axonram.c | 10 +++----
 block/ioctl.c                 |  9 ------
 drivers/block/brd.c           |  9 +++---
 drivers/nvdimm/pmem.c         | 17 ++++++++---
 drivers/s390/block/dcssblk.c  | 12 ++++----
 fs/block_dev.c                |  7 +++--
 fs/dax.c                      | 70 +++++++++++++++++++++----------------------
 fs/ext2/inode.c               | 12 ++++----
 fs/ext4/indirect.c            | 11 ++++---
 fs/ext4/inode.c               |  5 ++--
 fs/xfs/xfs_aops.c             |  7 +++--
 fs/xfs/xfs_bmap_util.c        |  9 ------
 include/linux/blkdev.h        |  3 +-
 include/linux/dax.h           |  7 +++--
 14 files changed, 93 insertions(+), 95 deletions(-)

-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
