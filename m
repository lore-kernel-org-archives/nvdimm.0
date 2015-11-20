Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fixes for 4.4-rc2
Date: Fri, 20 Nov 2015 21:44:16 +0000
Message-ID: <1448055854.29114.9.camel@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <3F77ECC266CB1440972063E20DD5132A@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Zwisler, Ross" <ross.zwisler@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from...

+AKA- git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

...to receive:

1/ A collection of crash and deadlock fixes for DAX that are also
tagged for -stable. +AKA-We will look to re-enable DAX pmd mappings in 4.5,
but for now 4.4 and -stable should disable it by default.

2/ A fixup to ext2 and ext4 to mirror the same warning emitted by XFS
when mounting with +ACI--o dax+ACI-

This set has received a build success notification from the kbuild
robot.

The following changes since commit 8005c49d9aea74d382f474ce11afbbc7d7130bec:

+AKA- Linux 4.4-rc1 (2015-11-15 17:00:27 -0800)

are available in the git repository at:

+AKA- git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to 2e6edc95382cc36423aff18a237173ad62d5ab52:

+AKA- block: protect rw+AF8-page against device teardown (2015-11-19 13:47:10 -0800)

----------------------------------------------------------------
Dan Williams (3):
+AKAAoACgAKAAoACg-ext2, ext4: warn when mounting with dax enabled
+AKAAoACgAKAAoACg-dax: disable pmd mappings
+AKAAoACgAKAAoACg-block: protect rw+AF8-page against device teardown

Yigal Korman (1):
+AKAAoACgAKAAoACg-mm, dax: fix DAX deadlocks (COW fault)

+AKA-block/blk.h+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAHwAoACg-2 --
+AKA-fs/Kconfig+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAfACgAKA-6 +-+-+-+-+-+-
+AKA-fs/block+AF8-dev.c+AKAAoACgAKAAoACgAKAAoACgAHw- 18 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+---
+AKA-fs/dax.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAHwAoACg-4 +-+-+-+-
+AKA-fs/ext2/super.c+AKAAoACgAKAAoACgAKAAoAB8AKAAoA-2 +-+-
+AKA-fs/ext4/super.c+AKAAoACgAKAAoACgAKAAoAB8AKAAoA-6 +-+-+-+-+--
+AKA-include/linux/blkdev.h +AHwAoACg-2 +-+-
+AKA-mm/memory.c+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAHwAoACg-8 +-+-+-+-----
+AKA-8 files changed, 39 insertions(+-), 9 deletions(-)

commit 2e6edc95382cc36423aff18a237173ad62d5ab52
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:+AKAAoACg-Thu Nov 19 13:29:28 2015 -0800

+AKAAoACgAKA-block: protect rw+AF8-page against device teardown
+AKAAoACgAKA-
+AKAAoACgAKA-Fix use after free crashes like the following:
+AKAAoACgAKA-
+AKAAoACgAKAAoA-general protection fault: 0000 +AFsAIw-1+AF0- SMP
+AKAAoACgAKAAoA-Call Trace:
+AKAAoACgAKAAoACgAFsAPA-ffffffffa0050216+AD4AXQ- ? pmem+AF8-do+AF8-bvec.isra.12+-0xa6/0xf0 +AFs-nd+AF8-pmem+AF0-
+AKAAoACgAKAAoACgAFsAPA-ffffffffa0050ba2+AD4AXQ- pmem+AF8-rw+AF8-page+-0x42/0x80 +AFs-nd+AF8-pmem+AF0-
+AKAAoACgAKAAoACgAFsAPA-ffffffff8128fd90+AD4AXQ- bdev+AF8-read+AF8-page+-0x50/0x60
+AKAAoACgAKAAoACgAFsAPA-ffffffff812972f0+AD4AXQ- do+AF8-mpage+AF8-readpage+-0x510/0x770
+AKAAoACgAKAAoACgAFsAPA-ffffffff8128fd20+AD4AXQ- ? I+AF8-BDEV+-0x20/0x20
+AKAAoACgAKAAoACgAFsAPA-ffffffff811d86dc+AD4AXQ- ? lru+AF8-cache+AF8-add+-0x1c/0x50
+AKAAoACgAKAAoACgAFsAPA-ffffffff81297657+AD4AXQ- mpage+AF8-readpages+-0x107/0x170
+AKAAoACgAKAAoACgAFsAPA-ffffffff8128fd20+AD4AXQ- ? I+AF8-BDEV+-0x20/0x20
+AKAAoACgAKAAoACgAFsAPA-ffffffff8128fd20+AD4AXQ- ? I+AF8-BDEV+-0x20/0x20
+AKAAoACgAKAAoACgAFsAPA-ffffffff8129058d+AD4AXQ- blkdev+AF8-readpages+-0x1d/0x20
+AKAAoACgAKAAoACgAFsAPA-ffffffff811d615f+AD4AXQ- +AF8AXw-do+AF8-page+AF8-cache+AF8-readahead+-0x28f/0x310
+AKAAoACgAKAAoACgAFsAPA-ffffffff811d6039+AD4AXQ- ? +AF8AXw-do+AF8-page+AF8-cache+AF8-readahead+-0x169/0x310
+AKAAoACgAKAAoACgAFsAPA-ffffffff811c5abd+AD4AXQ- ? pagecache+AF8-get+AF8-page+-0x2d/0x1d0
+AKAAoACgAKAAoACgAFsAPA-ffffffff811c76f6+AD4AXQ- filemap+AF8-fault+-0x396/0x530
+AKAAoACgAKAAoACgAFsAPA-ffffffff811f816e+AD4AXQ- +AF8AXw-do+AF8-fault+-0x4e/0xf0
+AKAAoACgAKAAoACgAFsAPA-ffffffff811fce7d+AD4AXQ- handle+AF8-mm+AF8-fault+-0x11bd/0x1b50
+AKAAoACgAKA-
+AKAAoACgAKA-Cc: +ADw-stable+AEA-vger.kernel.org+AD4-
+AKAAoACgAKA-Cc: Jens Axboe +ADw-axboe+AEA-fb.com+AD4-
+AKAAoACgAKA-Cc: Alexander Viro +ADw-viro+AEA-zeniv.linux.org.uk+AD4-
+AKAAoACgAKA-Reported-by: kbuild test robot +ADw-lkp+AEA-intel.com+AD4-
+AKAAoACgAKA-Acked-by: Matthew Wilcox +ADw-willy+AEA-linux.intel.com+AD4-
+AKAAoACgAKAAWw-willy: symmetry fixups+AF0-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit 0df9d41ab5d43dc5b20abc8b22a6b6d098b03994
Author: Yigal Korman +ADw-yigal+AEA-plexistor.com+AD4-
Date:+AKAAoACg-Mon Nov 16 14:09:15 2015 +-0200

+AKAAoACgAKA-mm, dax: fix DAX deadlocks (COW fault)
+AKAAoACgAKA-
+AKAAoACgAKA-DAX handling of COW faults has wrong locking sequence:
+AKAAoACgAKA-	dax+AF8-fault does i+AF8-mmap+AF8-lock+AF8-read
+AKAAoACgAKA-	do+AF8-cow+AF8-fault does i+AF8-mmap+AF8-unlock+AF8-write
+AKAAoACgAKA-
+AKAAoACgAKA-Ross's commit+AFs-1+AF0- missed a fix+AFs-2+AF0- that Kirill added to Matthew's
+AKAAoACgAKA-commit+AFs-3+AF0-.
+AKAAoACgAKA-
+AKAAoACgAKA-Original COW locking logic was introduced by Matthew here+AFs-4+AF0-.
+AKAAoACgAKA-
+AKAAoACgAKA-This should be applied to v4.3 as well.
+AKAAoACgAKA-
+AKAAoACgAKAAWw-1+AF0- 0f90cc6609c7 mm, dax: fix DAX deadlocks
+AKAAoACgAKAAWw-2+AF0- 52a2b53ffde6 mm, dax: use i+AF8-mmap+AF8-unlock+AF8-write() in do+AF8-cow+AF8-fault()
+AKAAoACgAKAAWw-3+AF0- 843172978bb9 dax: fix race between simultaneous faults
+AKAAoACgAKAAWw-4+AF0- 2e4cdab0584f mm: allow page fault handlers to perform the COW
+AKAAoACgAKA-
+AKAAoACgAKA-Cc: +ADw-stable+AEA-vger.kernel.org+AD4-
+AKAAoACgAKA-Cc: Boaz Harrosh +ADw-boaz+AEA-plexistor.com+AD4-
+AKAAoACgAKA-Cc: Alexander Viro +ADw-viro+AEA-zeniv.linux.org.uk+AD4-
+AKAAoACgAKA-Cc: Dave Chinner +ADw-dchinner+AEA-redhat.com+AD4-
+AKAAoACgAKA-Cc: Jan Kara +ADw-jack+AEA-suse.com+AD4-
+AKAAoACgAKA-Cc: +ACI-Kirill A. Shutemov+ACI- +ADw-kirill.shutemov+AEA-linux.intel.com+AD4-
+AKAAoACgAKA-Cc: Matthew Wilcox +ADw-matthew.r.wilcox+AEA-intel.com+AD4-
+AKAAoACgAKA-Acked-by: Ross Zwisler +ADw-ross.zwisler+AEA-linux.intel.com+AD4-
+AKAAoACgAKA-Signed-off-by: Yigal Korman +ADw-yigal+AEA-plexistor.com+AD4-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit ee82c9ed41e896bd47e121d87e4628de0f2656a3
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:+AKAAoACg-Sun Nov 15 16:06:32 2015 -0800

+AKAAoACgAKA-dax: disable pmd mappings
+AKAAoACgAKA-
+AKAAoACgAKA-While dax pmd mappings are functional in the nominal path they trigger
+AKAAoACgAKA-kernel crashes in the following paths:
+AKAAoACgAKA-
+AKAAoACgAKAAoA-BUG: unable to handle kernel paging request at ffffea0004098000
+AKAAoACgAKAAoA-IP: +AFsAPA-ffffffff812362f7+AD4AXQ- follow+AF8-trans+AF8-huge+AF8-pmd+-0x117/0x3b0
+AKAAoACgAKAAoABb-..+AF0-
+AKAAoACgAKAAoA-Call Trace:
+AKAAoACgAKAAoACgAFsAPA-ffffffff811f6573+AD4AXQ- follow+AF8-page+AF8-mask+-0x2d3/0x380
+AKAAoACgAKAAoACgAFsAPA-ffffffff811f6708+AD4AXQ- +AF8AXw-get+AF8-user+AF8-pages+-0xe8/0x6f0
+AKAAoACgAKAAoACgAFsAPA-ffffffff811f7045+AD4AXQ- get+AF8-user+AF8-pages+AF8-unlocked+-0x165/0x1e0
+AKAAoACgAKAAoACgAFsAPA-ffffffff8106f5b1+AD4AXQ- get+AF8-user+AF8-pages+AF8-fast+-0xa1/0x1b0
+AKAAoACgAKA-
+AKAAoACgAKAAoA-kernel BUG at arch/x86/mm/gup.c:131+ACE-
+AKAAoACgAKAAoABb-..+AF0-
+AKAAoACgAKAAoA-Call Trace:
+AKAAoACgAKAAoACgAFsAPA-ffffffff8106f34c+AD4AXQ- gup+AF8-pud+AF8-range+-0x1bc/0x220
+AKAAoACgAKAAoACgAFsAPA-ffffffff8106f634+AD4AXQ- get+AF8-user+AF8-pages+AF8-fast+-0x124/0x1b0
+AKAAoACgAKA-
+AKAAoACgAKAAoA-BUG: unable to handle kernel paging request at ffffea0004088000
+AKAAoACgAKAAoA-IP: +AFsAPA-ffffffff81235f49+AD4AXQ- copy+AF8-huge+AF8-pmd+-0x159/0x350
+AKAAoACgAKAAoABb-..+AF0-
+AKAAoACgAKAAoA-Call Trace:
+AKAAoACgAKAAoACgAFsAPA-ffffffff811fad3c+AD4AXQ- copy+AF8-page+AF8-range+-0x34c/0x9f0
+AKAAoACgAKAAoACgAFsAPA-ffffffff810a0daf+AD4AXQ- copy+AF8-process+-0x1b7f/0x1e10
+AKAAoACgAKAAoACgAFsAPA-ffffffff810a11c1+AD4AXQ- +AF8-do+AF8-fork+-0x91/0x590
+AKAAoACgAKA-
+AKAAoACgAKA-All of these paths are interpreting a dax pmd mapping as a transparent
+AKAAoACgAKA-huge page and making the assumption that the pfn is covered by the
+AKAAoACgAKA-memmap, i.e. that the pfn has an associated struct page.+AKAAoA-PTE mappings
+AKAAoACgAKA-do not suffer the same fate since they have the +AF8-PAGE+AF8-SPECIAL flag to
+AKAAoACgAKA-cause the gup path to fault.+AKAAoA-We can do something similar for the PMD
+AKAAoACgAKA-path, or otherwise defer pmd support for cases where a struct page is
+AKAAoACgAKA-available.+AKAAoA-For now, 4.4-rc and -stable need to disable dax pmd support
+AKAAoACgAKA-by default.
+AKAAoACgAKA-
+AKAAoACgAKA-For development the +ACI-depends on BROKEN+ACI- line can be removed from
+AKAAoACgAKA-CONFIG+AF8-FS+AF8-DAX+AF8-PMD.
+AKAAoACgAKA-
+AKAAoACgAKA-Cc: +ADw-stable+AEA-vger.kernel.org+AD4-
+AKAAoACgAKA-Cc: Jan Kara +ADw-jack+AEA-suse.com+AD4-
+AKAAoACgAKA-Cc: Dave Chinner +ADw-david+AEA-fromorbit.com+AD4-
+AKAAoACgAKA-Cc: Matthew Wilcox +ADw-willy+AEA-linux.intel.com+AD4-
+AKAAoACgAKA-Cc: Kirill A. Shutemov +ADw-kirill.shutemov+AEA-linux.intel.com+AD4-
+AKAAoACgAKA-Reported-by: Ross Zwisler +ADw-ross.zwisler+AEA-linux.intel.com+AD4-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

commit ef83b6e8f40bb24b92ad73b5889732346e54a793
Author: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-
Date:+AKAAoACg-Tue Sep 29 15:48:11 2015 -0400

+AKAAoACgAKA-ext2, ext4: warn when mounting with dax enabled
+AKAAoACgAKA-
+AKAAoACgAKA-Similar to XFS warn when mounting DAX while it is still considered under
+AKAAoACgAKA-development.+AKAAoA-Also, aspects of the DAX implementation, for example
+AKAAoACgAKA-synchronization against multiple faults and faults causing block
+AKAAoACgAKA-allocation, depend on the correct implementation in the filesystem.+AKAAoA-The
+AKAAoACgAKA-maturity of a given DAX implementation is filesystem specific.
+AKAAoACgAKA-
+AKAAoACgAKA-Cc: +ADw-stable+AEA-vger.kernel.org+AD4-
+AKAAoACgAKA-Cc: +ACI-Theodore Ts'o+ACI- +ADw-tytso+AEA-mit.edu+AD4-
+AKAAoACgAKA-Cc: Matthew Wilcox +ADw-willy+AEA-linux.intel.com+AD4-
+AKAAoACgAKA-Cc: linux-ext4+AEA-vger.kernel.org
+AKAAoACgAKA-Cc: Kirill A. Shutemov +ADw-kirill.shutemov+AEA-linux.intel.com+AD4-
+AKAAoACgAKA-Reported-by: Dave Chinner +ADw-david+AEA-fromorbit.com+AD4-
+AKAAoACgAKA-Acked-by: Jan Kara +ADw-jack+AEA-suse.com+AD4-
+AKAAoACgAKA-Signed-off-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

diff --git a/block/blk.h b/block/blk.h
index da722eb786df..c43926d3d74d 100644
--- a/block/blk.h
+-+-+- b/block/blk.h
+AEAAQA- -72,8 +-72,6 +AEAAQA- void blk+AF8-dequeue+AF8-request(struct request +ACo-rq)+ADs-
+AKA-void +AF8AXw-blk+AF8-queue+AF8-free+AF8-tags(struct request+AF8-queue +ACo-q)+ADs-
+AKA-bool +AF8AXw-blk+AF8-end+AF8-bidi+AF8-request(struct request +ACo-rq, int error,
+AKA-			+AKAAoACgAKA-unsigned int nr+AF8-bytes, unsigned int bidi+AF8-bytes)+ADs-
-int blk+AF8-queue+AF8-enter(struct request+AF8-queue +ACo-q, gfp+AF8-t gfp)+ADs-
-void blk+AF8-queue+AF8-exit(struct request+AF8-queue +ACo-q)+ADs-
+AKA-void blk+AF8-freeze+AF8-queue(struct request+AF8-queue +ACo-q)+ADs-
+AKA-
+AKA-static inline void blk+AF8-queue+AF8-enter+AF8-live(struct request+AF8-queue +ACo-q)
diff --git a/fs/Kconfig b/fs/Kconfig
index da3f32f1a4e4..6ce72d8d1ee1 100644
--- a/fs/Kconfig
+-+-+- b/fs/Kconfig
+AEAAQA- -46,6 +-46,12 +AEAAQA- config FS+AF8-DAX
+AKA-	+AKAAoA-or if unsure, say N.+AKAAoA-Saying Y will increase the size of the kernel
+AKA-	+AKAAoA-by about 5kB.
+AKA-
+-config FS+AF8-DAX+AF8-PMD
+-	bool
+-	default FS+AF8-DAX
+-	depends on FS+AF8-DAX
+-	depends on BROKEN
+-
+AKA-endif +ACM- BLOCK
+AKA-
+AKAAIw- Posix ACL utility routines
diff --git a/fs/block+AF8-dev.c b/fs/block+AF8-dev.c
index bb0dfb1c7af1..c25639e907bd 100644
--- a/fs/block+AF8-dev.c
+-+-+- b/fs/block+AF8-dev.c
+AEAAQA- -390,9 +-390,17 +AEAAQA- int bdev+AF8-read+AF8-page(struct block+AF8-device +ACo-bdev, sector+AF8-t sector,
+AKA-			struct page +ACo-page)
+AKAAew-
+AKA-	const struct block+AF8-device+AF8-operations +ACo-ops +AD0- bdev-+AD4-bd+AF8-disk-+AD4-fops+ADs-
+-	int result +AD0- -EOPNOTSUPP+ADs-
+-
+AKA-	if (+ACE-ops-+AD4-rw+AF8-page +AHwAfA- bdev+AF8-get+AF8-integrity(bdev))
-		return -EOPNOTSUPP+ADs-
-	return ops-+AD4-rw+AF8-page(bdev, sector +- get+AF8-start+AF8-sect(bdev), page, READ)+ADs-
+-		return result+ADs-
+-
+-	result +AD0- blk+AF8-queue+AF8-enter(bdev-+AD4-bd+AF8-queue, GFP+AF8-KERNEL)+ADs-
+-	if (result)
+-		return result+ADs-
+-	result +AD0- ops-+AD4-rw+AF8-page(bdev, sector +- get+AF8-start+AF8-sect(bdev), page, READ)+ADs-
+-	blk+AF8-queue+AF8-exit(bdev-+AD4-bd+AF8-queue)+ADs-
+-	return result+ADs-
+AKAAfQ-
+AKA-EXPORT+AF8-SYMBOL+AF8-GPL(bdev+AF8-read+AF8-page)+ADs-
+AKA-
+AEAAQA- -421,14 +-429,20 +AEAAQA- int bdev+AF8-write+AF8-page(struct block+AF8-device +ACo-bdev, sector+AF8-t sector,
+AKA-	int result+ADs-
+AKA-	int rw +AD0- (wbc-+AD4-sync+AF8-mode +AD0APQ- WB+AF8-SYNC+AF8-ALL) ? WRITE+AF8-SYNC : WRITE+ADs-
+AKA-	const struct block+AF8-device+AF8-operations +ACo-ops +AD0- bdev-+AD4-bd+AF8-disk-+AD4-fops+ADs-
+-
+AKA-	if (+ACE-ops-+AD4-rw+AF8-page +AHwAfA- bdev+AF8-get+AF8-integrity(bdev))
+AKA-		return -EOPNOTSUPP+ADs-
+-	result +AD0- blk+AF8-queue+AF8-enter(bdev-+AD4-bd+AF8-queue, GFP+AF8-KERNEL)+ADs-
+-	if (result)
+-		return result+ADs-
+-
+AKA-	set+AF8-page+AF8-writeback(page)+ADs-
+AKA-	result +AD0- ops-+AD4-rw+AF8-page(bdev, sector +- get+AF8-start+AF8-sect(bdev), page, rw)+ADs-
+AKA-	if (result)
+AKA-		end+AF8-page+AF8-writeback(page)+ADs-
+AKA-	else
+AKA-		unlock+AF8-page(page)+ADs-
+-	blk+AF8-queue+AF8-exit(bdev-+AD4-bd+AF8-queue)+ADs-
+AKA-	return result+ADs-
+AKAAfQ-
+AKA-EXPORT+AF8-SYMBOL+AF8-GPL(bdev+AF8-write+AF8-page)+ADs-
diff --git a/fs/dax.c b/fs/dax.c
index d1e5cb7311a1..43671b68220e 100644
--- a/fs/dax.c
+-+-+- b/fs/dax.c
+AEAAQA- -541,6 +-541,10 +AEAAQA- int +AF8AXw-dax+AF8-pmd+AF8-fault(struct vm+AF8-area+AF8-struct +ACo-vma, unsigned long address,
+AKA-	unsigned long pfn+ADs-
+AKA-	int result +AD0- 0+ADs-
+AKA-
+-	/+ACo- dax pmd mappings are broken wrt gup and fork +ACo-/
+-	if (+ACE-IS+AF8-ENABLED(CONFIG+AF8-FS+AF8-DAX+AF8-PMD))
+-		return VM+AF8-FAULT+AF8-FALLBACK+ADs-
+-
+AKA-	/+ACo- Fall back to PTEs if we're going to COW +ACo-/
+AKA-	if (write +ACYAJg- +ACE-(vma-+AD4-vm+AF8-flags +ACY- VM+AF8-SHARED))
+AKA-		return VM+AF8-FAULT+AF8-FALLBACK+ADs-
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 3a71cea68420..748d35afc902 100644
--- a/fs/ext2/super.c
+-+-+- b/fs/ext2/super.c
+AEAAQA- -569,6 +-569,8 +AEAAQA- static int parse+AF8-options(char +ACo-options, struct super+AF8-block +ACo-sb)
+AKA-			/+ACo- Fall through +ACo-/
+AKA-		case Opt+AF8-dax:
+AKAAIw-ifdef CONFIG+AF8-FS+AF8-DAX
+-			ext2+AF8-msg(sb, KERN+AF8-WARNING,
+-		+ACI-DAX enabled. Warning: EXPERIMENTAL, use at your own risk+ACI-)+ADs-
+AKA-			set+AF8-opt(sbi-+AD4-s+AF8-mount+AF8-opt, DAX)+ADs-
+AKAAIw-else
+AKA-			ext2+AF8-msg(sb, KERN+AF8-INFO, +ACI-dax option not supported+ACI-)+ADs-
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 753f4e68b820..c9ab67da6e5a 100644
--- a/fs/ext4/super.c
+-+-+- b/fs/ext4/super.c
+AEAAQA- -1664,8 +-1664,12 +AEAAQA- static int handle+AF8-mount+AF8-opt(struct super+AF8-block +ACo-sb, char +ACo-opt, int token,
+AKA-		+AH0-
+AKA-		sbi-+AD4-s+AF8-jquota+AF8-fmt +AD0- m-+AD4-mount+AF8-opt+ADs-
+AKAAIw-endif
-+ACM-ifndef CONFIG+AF8-FS+AF8-DAX
+AKA-	+AH0- else if (token +AD0APQ- Opt+AF8-dax) +AHs-
+-+ACM-ifdef CONFIG+AF8-FS+AF8-DAX
+-		ext4+AF8-msg(sb, KERN+AF8-WARNING,
+-		+ACI-DAX enabled. Warning: EXPERIMENTAL, use at your own risk+ACI-)+ADs-
+-			sbi-+AD4-s+AF8-mount+AF8-opt +AHwAPQ- m-+AD4-mount+AF8-opt+ADs-
+-+ACM-else
+AKA-		ext4+AF8-msg(sb, KERN+AF8-INFO, +ACI-dax option not supported+ACI-)+ADs-
+AKA-		return -1+ADs-
+AKAAIw-endif
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3fe27f8d91f0..c0d2b7927c1f 100644
--- a/include/linux/blkdev.h
+-+-+- b/include/linux/blkdev.h
+AEAAQA- -794,6 +-794,8 +AEAAQA- extern int scsi+AF8-cmd+AF8-ioctl(struct request+AF8-queue +ACo-, struct gendisk +ACo-, fmode+AF8-t,
+AKA-extern int sg+AF8-scsi+AF8-ioctl(struct request+AF8-queue +ACo-, struct gendisk +ACo-, fmode+AF8-t,
+AKA-			+AKA-struct scsi+AF8-ioctl+AF8-command +AF8AXw-user +ACo-)+ADs-
+AKA-
+-extern int blk+AF8-queue+AF8-enter(struct request+AF8-queue +ACo-q, gfp+AF8-t gfp)+ADs-
+-extern void blk+AF8-queue+AF8-exit(struct request+AF8-queue +ACo-q)+ADs-
+AKA-extern void blk+AF8-start+AF8-queue(struct request+AF8-queue +ACo-q)+ADs-
+AKA-extern void blk+AF8-stop+AF8-queue(struct request+AF8-queue +ACo-q)+ADs-
+AKA-extern void blk+AF8-sync+AF8-queue(struct request+AF8-queue +ACo-q)+ADs-
diff --git a/mm/memory.c b/mm/memory.c
index deb679c31f2a..c387430f06c3 100644
--- a/mm/memory.c
+-+-+- b/mm/memory.c
+AEAAQA- -3015,9 +-3015,9 +AEAAQA- static int do+AF8-cow+AF8-fault(struct mm+AF8-struct +ACo-mm, struct vm+AF8-area+AF8-struct +ACo-vma,
+AKA-		+AH0- else +AHs-
+AKA-			/+ACo-
+AKA-			+AKAAKg- The fault handler has no page to lock, so it holds
-			+AKAAKg- i+AF8-mmap+AF8-lock for write to protect against truncate.
+-			+AKAAKg- i+AF8-mmap+AF8-lock for read to protect against truncate.
+AKA-			+AKAAKg-/
-			i+AF8-mmap+AF8-unlock+AF8-write(vma-+AD4-vm+AF8-file-+AD4-f+AF8-mapping)+ADs-
+-			i+AF8-mmap+AF8-unlock+AF8-read(vma-+AD4-vm+AF8-file-+AD4-f+AF8-mapping)+ADs-
+AKA-		+AH0-
+AKA-		goto uncharge+AF8-out+ADs-
+AKA-	+AH0-
+AEAAQA- -3031,9 +-3031,9 +AEAAQA- static int do+AF8-cow+AF8-fault(struct mm+AF8-struct +ACo-mm, struct vm+AF8-area+AF8-struct +ACo-vma,
+AKA-	+AH0- else +AHs-
+AKA-		/+ACo-
+AKA-		+AKAAKg- The fault handler has no page to lock, so it holds
-		+AKAAKg- i+AF8-mmap+AF8-lock for write to protect against truncate.
+-		+AKAAKg- i+AF8-mmap+AF8-lock for read to protect against truncate.
+AKA-		+AKAAKg-/
-		i+AF8-mmap+AF8-unlock+AF8-write(vma-+AD4-vm+AF8-file-+AD4-f+AF8-mapping)+ADs-
+-		i+AF8-mmap+AF8-unlock+AF8-read(vma-+AD4-vm+AF8-file-+AD4-f+AF8-mapping)+ADs-
+AKA-	+AH0-
+AKA-	return ret+ADs-
+AKA-uncharge+AF8-out: