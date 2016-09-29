Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5BA8B1A1E3E
 for <linux-nvdimm@lists.01.org>; Thu, 29 Sep 2016 15:49:34 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 00/12] re-enable DAX PMD support
Date: Thu, 29 Sep 2016 16:49:18 -0600
Message-Id: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
locking.  This series allows DAX PMDs to participate in the DAX radix tree
based locking scheme so that they can be re-enabled.

Ted, can you please take the ext2 + ext4 patches through your tree?  Dave,
can you please take the rest through the XFS tree?

Changes since v3:
 - Corrected dax iomap code namespace for functions defined in fs/dax.c.
   (Dave Chinner)
 - Added leading "dax" namespace to new static functions in fs/dax.c.
   (Dave Chinner)
 - Made all DAX PMD code in fs/dax.c conditionally compiled based on
   CONFIG_FS_DAX_PMD.  Otherwise a stub in include/linux/dax.h that just
   returns VM_FAULT_FALLBACK will be used.  (Dave Chinner)
 - Removed dynamic debugging messages from DAX PMD fault path.  Debugging
   tracepoints will be added later to both the PTE and PMD paths via a
   later patch set. (Dave Chinner)
 - Added a comment to ext2_dax_vm_ops explaining why we don't support DAX
   PMD faults in ext2. (Dave Chinner)

This was built upon xfs/for-next with PMD performance fixes from Toshi Kani
and Dan Williams.  Dan's patch has already been merged for v4.8, and
Toshi's patches are currently queued in Andrew Morton's mm tree for v4.9
inclusion.

Here is a tree containing my changes and all the fixes that I've been testing:
https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_pmd_v4

This tree has passed xfstests for ext2, ext4 and XFS both with and without DAX,
and has passed targeted testing where I inserted, removed and flushed DAX PTEs
and PMDs in every combination I could think of.

Previously reported performance numbers:

In some simple mmap I/O testing with FIO the use of PMD faults more than
doubles I/O performance as compared with PTE faults.  Here is the FIO script I
used for my testing:

  [global]
  bs=4k
  size=2G
  directory=/mnt/pmem0
  ioengine=mmap
  [randrw]
  rw=randrw

Here are the performance results with XFS using only pte faults:
   READ: io=1022.7MB, aggrb=557610KB/s, minb=557610KB/s, maxb=557610KB/s, mint=1878msec, maxt=1878msec
  WRITE: io=1025.4MB, aggrb=559084KB/s, minb=559084KB/s, maxb=559084KB/s, mint=1878msec, maxt=1878msec

Here are performance numbers for that same test using PMD faults:
   READ: io=1022.7MB, aggrb=1406.7MB/s, minb=1406.7MB/s, maxb=1406.7MB/s, mint=727msec, maxt=727msec
  WRITE: io=1025.4MB, aggrb=1410.4MB/s, minb=1410.4MB/s, maxb=1410.4MB/s, mint=727msec, maxt=727msec

This was done on a random lab machine with a PMEM device made from memmap'd
RAM.  To get XFS to use PMD faults, I did the following:

  mkfs.xfs -f -d su=2m,sw=1 /dev/pmem0
  mount -o dax /dev/pmem0 /mnt/pmem0
  xfs_io -c "extsize 2m" /mnt/pmem0

Ross Zwisler (12):
  ext4: allow DAX writeback for hole punch
  ext4: tell DAX the size of allocation holes
  dax: remove buffer_size_valid()
  ext2: remove support for DAX PMD faults
  dax: make 'wait_table' global variable static
  dax: consistent variable naming for DAX entries
  dax: coordinate locking for offsets in PMD range
  dax: remove dax_pmd_fault()
  dax: correct dax iomap code namespace
  dax: add struct iomap based DAX PMD support
  xfs: use struct iomap based DAX PMD fault path
  dax: remove "depends on BROKEN" from FS_DAX_PMD

 fs/Kconfig          |   1 -
 fs/dax.c            | 650 +++++++++++++++++++++++++++-------------------------
 fs/ext2/file.c      |  35 +--
 fs/ext4/inode.c     |   7 +-
 fs/xfs/xfs_aops.c   |  25 +-
 fs/xfs/xfs_aops.h   |   3 -
 fs/xfs/xfs_file.c   |  10 +-
 include/linux/dax.h |  48 +++-
 mm/filemap.c        |   6 +-
 9 files changed, 402 insertions(+), 383 deletions(-)

-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
