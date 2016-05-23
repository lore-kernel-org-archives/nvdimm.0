Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 7D76B1A1E0F
 for <linux-nvdimm@lists.01.org>; Mon, 23 May 2016 16:52:06 -0700 (PDT)
Date: Mon, 23 May 2016 17:51:43 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [GIT PULL] dax-misc for 4.7
Message-ID: <20160523235143.GD17835@omniknight.lm.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-misc-for-4.7

...to receive the dax error handling topic branch for 4.7.

Most of these changes have been stable since before the merge window, but getting
the different trees/patchsets integrated into this topic branch took a couple more
days. These have also been in linux-next for almost a week, and have received a
positive 0day notification for a successful build for 118 configs.

Note that this branch depends on Ted's ext4 dev branch, and should be merged after
that. The pull request is based on this branch so that the shortlog and diffstat
look correct.

The merge with libnvdimm-for-next will cause a conflict, and I have a branch
with the expected resolution at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-for-4.7-merge

Notably, the automatic merge ends up with two copies of a function in fs/block_dev.c
blkdev_dax_capable(), and bdev_dax_capable(), where blkdev_dax_capable is unused, and
should be removed [1].

[1]: http://www.spinics.net/lists/kernel/msg2258671.html


The following changes since commit 12735f881952c32b31bc4e433768f18489f79ec9:

  ext4: pre-zero allocated blocks for DAX IO (2016-05-13 00:51:15 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-misc-for-4.7

for you to fetch changes up to 40543f62cbdce42633e3fe10923099feee272e1f:

  dax: fix a comment in dax_zero_page_range and dax_truncate_page (2016-05-18 12:16:58 -0600)

----------------------------------------------------------------
DAX error handling for 4.7

- Until now, dax has been disabled if media errors were found on
  any device. This enables the use of DAX in the presence of these
  errors by making all sector-aligned zeroing go through the driver.
- The driver (already) has the ability to clear errors on writes that
  are sent through the block layer using 'DSMs' defined in ACPI 6.1.

Other misc changes:

- When mounting DAX filesystems, check to make sure the partition
  is page aligned. This is a requirement for DAX, and previously, we
  allowed such unaligned mounts to succeed, but subsequent reads/writes
  would fail.

- Misc/cleanup fixes from Jan that remove unused code from DAX related to
  zeroing, writeback, and some size checks.

----------------------------------------------------------------
Christoph Hellwig (1):
      dax: export a low-level __dax_zero_page_range helper

Dan Williams (2):
      dax: fallback from pmd to pte on error
      dax: enable dax in the presence of known media errors (badblocks)

Jan Kara (7):
      dax: Remove complete_unwritten argument
      ext2: Fix block zeroing in ext2_get_blocks() for DAX
      ext2: Avoid DAX zeroing to corrupt data
      dax: Remove dead zeroing code from fault handlers
      dax: Remove zeroing from dax_io()
      dax: Remove pointless writeback from dax_do_io()
      dax: Remove redundant inode size checks

Matthew Wilcox (1):
      dax: use sb_issue_zerout instead of calling dax_clear_sectors

NeilBrown (1):
      DAX: move RADIX_DAX_ definitions to dax.c

Toshi Kani (6):
      block: Add vfs_msg() interface
      block: Add bdev_dax_supported() for dax mount checks
      ext4: Add alignment check for DAX mount
      ext2: Add alignment check for DAX mount
      xfs: Add alignment check for DAX mount
      block: Update blkdev_dax_capable() for consistency

Vishal Verma (2):
      dax: for truncate/hole-punch, do zeroing through the driver if possible
      dax: fix a comment in dax_zero_page_range and dax_truncate_page

 Documentation/filesystems/dax.txt |  32 +++++
 arch/powerpc/sysdev/axonram.c     |   2 +-
 block/ioctl.c                     |  30 -----
 drivers/block/brd.c               |   2 +-
 drivers/nvdimm/pmem.c             |  10 +-
 drivers/s390/block/dcssblk.c      |   4 +-
 fs/block_dev.c                    |  91 ++++++++++++-
 fs/dax.c                          | 266 +++++++++++---------------------------
 fs/ext2/file.c                    |   4 +-
 fs/ext2/inode.c                   |  12 +-
 fs/ext2/super.c                   |  11 +-
 fs/ext4/file.c                    |   4 +-
 fs/ext4/super.c                   |  11 +-
 fs/xfs/xfs_bmap_util.c            |  15 +--
 fs/xfs/xfs_file.c                 |   7 +-
 fs/xfs/xfs_super.c                |  12 +-
 include/linux/blkdev.h            |  15 ++-
 include/linux/dax.h               |  25 ++--
 include/linux/fs.h                |   9 --
 include/linux/radix-tree.h        |   9 --
 20 files changed, 257 insertions(+), 314 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
