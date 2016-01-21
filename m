Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 0/5] DAX fsync/msync fixes
Date: Thu, 21 Jan 2016 10:45:59 -0700
Message-Id: <1453398364-22537-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Changes from v1:
 - Fixed a macro collision for "PMD_INDEX" reported by 0-day for the "tile"
   architecture:

  config: tile-allyesconfig (attached as .config)
  reproduce:
  	wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
          chmod +x ~/bin/make.cross
         	# save the attached .config to linux build tree
          make.cross ARCH=tile
  
  All warnings (new ones prefixed by >>):
  
  >> fs/dax.c:330:0: warning: "PMD_INDEX" redefined [enabled by default]
     arch/tile/include/asm/pgtable_64.h:35:0: note: this is the location of the previous definition
  >> fs/dax.c:330:0: warning: "PMD_INDEX" redefined [enabled by default]
     arch/tile/include/asm/pgtable_64.h:35:0: note: this is the location of the previous definition

Thanks, 0-day!

This set applies cleanly on top of v8 of my "DAX fsync/msync support" set,
which is in -mm and -next.  That set has not yet been merged for v4.5
which is why the my work tree is still based on -next:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=fsync_fixes_v2

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

 fs/dax.c | 110 +++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 86 insertions(+), 24 deletions(-)

-- 
2.5.0

