Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 0/5] DAX fsync/msync fixes
Date: Fri, 22 Jan 2016 14:36:08 -0700
Message-Id: <1453498573-6328-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Changes from v2:
 - Added a WARN_ON_ONCE() to dax_radix_entry() to enforce the assumption
   that we never insert a PMD DAX entry that isn't dirty. (Jan)

 - Added checks to ensure that 'entry' is non-NULL before passing it to
   RADIX_DAX_TYPE().  This worked correclty before because RADIX_DAX_TYPE()
   just checks the value of 'entry' and doesn't dereference it, but it
   reads better and is less likely to cause unnecessary worry. (Jan)

 - Added Reviewed-by tags from Jan & fixed a comment typo.

This set applies cleanly on top of v8 of my "DAX fsync/msync support" set,
which is in -mm and -next.  That set has not yet been merged for v4.5
which is why the my work tree is still based on -next:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=fsync_fixes_v3

---
Original summary:

This series fixes several issues in v8 of my "DAX fsync/msync support"
patch series [1].  Thank you to Jan Kara for his excellent review.

Jan pointed out that we probably have an issue with the way hole punch
interacts with the fsync/msync code.  This is the item that I'll work on
next, but I wanted to send this series out now as I think it will be
independent of the hole punch fixes.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-January/003952.html

Ross Zwisler (5):
  dax: never rely on bh.b_dev being set by get_block()
  dax: clear TOWRITE flag after flush is complete
  dax: improve documentation for fsync/msync
  dax: fix PMD handling for fsync/msync
  dax: fix clearing of holes in __dax_pmd_fault()

 fs/dax.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 86 insertions(+), 23 deletions(-)

-- 
2.5.0

