Return-Path: <linux-ext4-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/2] Add updated DAX locking to ext2
Date: Fri,  9 Oct 2015 16:02:06 -0600
Message-Id: <1444428128-12200-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The first patch in this series is a somewhat related bug fix.  The second patch
adds new locking to ext2 to isolate DAX faults (page faults, PMD faults, page
mkwrite and pfn mkwrite) from ext2 operations that modify a given inode's data
block allocations.

In my first attempt at this fix I attempted to expand the protection offered by
ext2_inode_info->truncate_mutex so that we took truncate_mutex before our DAX
fault paths were entered.  The DAX fault handlers would then call a version of
ext2_get_block() that assumed truncate_mutex was already held.

This *almost* works, but it turns out that it introduces a lock ordering
inversion between truncate_mutex and a given page's page_lock.  With my series
as it is, the lock ordering looks like this:

mmap_sem (MM)
  ext2_inode_info->dax_sem
    sb_start_pagefault (vfs, freeze - taken in DAX)
      address_space->i_mmap_rwsem or page_lock (mutually exclusive in DAX)
        ext2_inode_info->truncate_mutex

With truncate_mutex being taken before the page fault handler, as in my initial
attempt, our lock ordering is instead:

mmap_sem (MM)
  ext2_inode_info->truncate_mutex
    sb_start_pagefault (vfs, freeze - taken in DAX)
      address_space->i_mmap_rwsem or page_lock (mutually exclusive in DAX)

This is fine for DAX, but it turns out that you can't actually take
truncate_mutex before a page_lock because some operations call ext2_get_block()
while already holding page_lock from calls higher in the stack.  This means
that whatever locks are taken in ext2_get_block() must be below page_lock in
the locking order, else you can deadlock.  To solve this I had to introduce a
new lock that would sit above page_lock in the locking order.  This is the new
"dax_sem" semaphore.

Folks with ext2 experience, have I missed any other cases that need to be
protected by dax_sem?  I took a hard look at all the cases in XFS that are
protected by i_mmaplock and convinced myself that truncate was the only one of
them present in ext2.

I've tested this series using xfstests with DAX both enabled and disabled.
Lockdep was on and working, and didn't have any complaints.

Ross Zwisler (2):
  dax: dax_pfn_mkwrite() truncate race check
  ext2: Add locking for DAX faults

 fs/dax.c        | 13 +++++++++++--
 fs/ext2/ext2.h  |  1 +
 fs/ext2/file.c  | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
 fs/ext2/inode.c |  9 +++++++++
 fs/ext2/super.c |  1 +
 5 files changed, 69 insertions(+), 6 deletions(-)

-- 
2.1.0

