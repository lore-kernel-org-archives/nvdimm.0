Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 53A7C1A1E24
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 15:04:30 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 0/9] re-enable DAX PMD support
Date: Tue, 23 Aug 2016 16:04:10 -0600
Message-Id: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
locking.  This series allows DAX PMDs to participate in the DAX radix tree
based locking scheme so that they can be re-enabled.

Changes since v1:
 - PMD entry locking is now done based on the starting offset of the PMD
   entry, rather than on the radix tree slot which was unreliable. (Jan)
 - Fixed the one issue I could find with hole punch.  As far as I can tell
   hole punch now works correctly for both PMD and PTE DAX entries, 4k zero
   pages and huge zero pages.
 - Fixed the way that ext2 returns the size of holes in ext2_get_block().
   (Jan)
 - Made the 'wait_table' global variable static in respnse to a sparse
   warning.
 - Fixed some more inconsitent usage between the names 'ret' and 'entry'
   for radix tree entry variables.

Ross Zwisler (9):
  ext4: allow DAX writeback for hole punch
  ext2: tell DAX the size of allocation holes
  ext4: tell DAX the size of allocation holes
  dax: remove buffer_size_valid()
  dax: make 'wait_table' global variable static
  dax: consistent variable naming for DAX entries
  dax: coordinate locking for offsets in PMD range
  dax: re-enable DAX PMD support
  dax: remove "depends on BROKEN" from FS_DAX_PMD

 fs/Kconfig          |   1 -
 fs/dax.c            | 297 +++++++++++++++++++++++++++++-----------------------
 fs/ext2/inode.c     |   3 +
 fs/ext4/inode.c     |   7 +-
 include/linux/dax.h |  29 ++++-
 mm/filemap.c        |   6 +-
 6 files changed, 201 insertions(+), 142 deletions(-)

-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
