Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id D41511A1F7E
 for <linux-nvdimm@lists.01.org>; Tue, 29 Mar 2016 19:00:48 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 0/5] dax: handling of media errors
Date: Tue, 29 Mar 2016 19:59:45 -0600
Message-Id: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
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
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
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

One pending item is addressing clear_pmem usages in dax.c. clear_pmem is
'unsafe' as it attempts to simply memcpy, and does not go through the driver.
We have a few options of solving this:
 1. Remove all usages of clear_pmem that are not sector-aligned. For the
    ones that are aligned, replace them with a bio submission that goes
    through the driver to clear errors.
 2. Export from the block layer, either an API to zero sub-sector ranges,
    or in general, clear errors in a range. The dax attempts to clear_pmem
    can then use either of these and not be hit be media errors.

I'll send out a v3 with a crack at option 1, but I wanted to get these
changes (especially the ones in xfs) out for review.

The fifth patch changes all the callers of dax_do_io to check for
EIO, and fallback to direct_IO as needed. This forces the IO to
go through the block driver, and can attempt to clear the error.


v2:
 - Use blockdev_issue_zeroout in xfs instead of sb_issue_zeroout (Christoph)
 - Un-wrapper-ize dax_do_io and leave the fallback to direct_IO to callers
   (Christoph)
 - Rebase to v4.6-rc1 (fixup a couple of conflicts in ext4 and xfs)


Dan Williams (3):
  block, dax: pass blk_dax_ctl through to drivers
  dax: fallback from pmd to pte on error
  dax: enable dax in the presence of known media errors (badblocks)

Vishal Verma (2):
  dax: use sb_issue_zerout instead of calling dax_clear_sectors
  dax: handle media errors in dax_do_io

 arch/powerpc/sysdev/axonram.c | 10 +++++-----
 block/ioctl.c                 |  9 ---------
 drivers/block/brd.c           |  9 +++++----
 drivers/nvdimm/pmem.c         | 17 +++++++++++++----
 drivers/s390/block/dcssblk.c  | 12 ++++++------
 fs/block_dev.c                | 19 +++++++++++++++----
 fs/dax.c                      | 36 ++----------------------------------
 fs/ext2/inode.c               | 29 ++++++++++++++++++-----------
 fs/ext4/indirect.c            | 18 +++++++++++++-----
 fs/ext4/inode.c               | 21 ++++++++++++++-------
 fs/xfs/xfs_aops.c             | 14 ++++++++++++--
 fs/xfs/xfs_bmap_util.c        | 15 ++++-----------
 include/linux/blkdev.h        |  3 +--
 include/linux/dax.h           |  1 -
 14 files changed, 108 insertions(+), 105 deletions(-)

-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
