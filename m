Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D8F6121E082AA
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 22:57:40 -0800 (PST)
Subject: [PATCH v5 00/11] dax: fix dma vs truncate/hole-punch
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Mar 2018 22:54:49 -0800
Message-ID: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
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
To: linux-nvdimm@lists.01.org
Cc: Theodore Ts'o <tytso@mit.edu>, Michal Hocko <mhocko@suse.com>, jack@suse.cz, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-ext4@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Changes since v4 [1]:
* Kill the DEFINE_FSDAX_AOPS macro and just open code new
  address_space_operations instances for each fs (Matthew, Jan, Dave,
  Christoph)

* Rename routines that had a 'dma_' prefix with 'dax_layout_' and merge
  the dax-layout-break into xfs_break_layouts() (Dave, Christoph)

* Rework the implementation to have the fsdax core find the pages, but
  leave the responsibility of waiting on those pages to the filesystem
  (Dave).

* Drop the nfit_test infrastructure for testing this mechanism, I plan
  to investigate better mechanisms for injecting arbitrary put_page()
  delays for dax pages relative to an extent unmap operation. The
  dm_delay target does not do what I want since it operates at whole
  device level. A better test interface would be a mechanism to delay
  I/O completion based on whether a bio referenced a given LBA.

Not changed since v4:
* This implementation still relies on RCU for synchronizing
  get_user_pages() and get_user_pages_fast() against
  dax_layout_busy_page(). We could perform the operation with just
  barriers if we knew at get_user_pages() time that the pages were flagged
  for truncation.  However, dax_layout_busy_page() does not have the
  information to flag that a page is actually going to be truncated, only
  that it *might* be truncated.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-December/013704.html

----

Background:

get_user_pages() in the filesystem pins file backed memory pages for
access by devices performing dma. However, it only pins the memory pages
not the page-to-file offset association. If a file is truncated the
pages are mapped out of the file and dma may continue indefinitely into
a page that is owned by a device driver. This breaks coherency of the
file vs dma, but the assumption is that if userspace wants the
file-space truncated it does not matter what data is inbound from the
device, it is not relevant anymore. The only expectation is that dma can
safely continue while the filesystem reallocates the block(s).

Problem:

This expectation that dma can safely continue while the filesystem
changes the block map is broken by dax. With dax the target dma page
*is* the filesystem block. The model of leaving the page pinned for dma,
but truncating the file block out of the file, means that the filesytem
is free to reallocate a block under active dma to another file and now
the expected data-incoherency situation has turned into active
data-corruption.

Solution:

Defer all filesystem operations (fallocate(), truncate()) on a dax mode
file while any page/block in the file is under active dma. This solution
assumes that dma is transient. Cases where dma operations are known to
not be transient, like RDMA, have been explicitly disabled via
commits like 5f1d43de5416 "IB/core: disable memory registration of
filesystem-dax vmas".

The dax_layout_busy_page() routine is called by filesystems with a lock
held against mm faults (i_mmap_lock) to find pinned / busy dax pages.
The process of looking up a busy page invalidates all mappings
to trigger any subsequent get_user_pages() to block on i_mmap_lock.
The filesystem continues to call dax_layout_busy_page() until it finally
returns no more active pages. This approach assumes that the page
pinning is transient, if that assumption is violated the system would
have likely hung from the uncompleted I/O.


---

Dan Williams (11):
      dax: store pfns in the radix
      xfs, dax: introduce xfs_dax_aops
      ext4, dax: introduce ext4_dax_aops
      ext2, dax: introduce ext2_dax_aops
      fs, dax: use page->mapping to warn if truncate collides with a busy page
      mm, dax: enable filesystems to trigger dev_pagemap ->page_free callbacks
      mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
      wait_bit: introduce {wait_on,wake_up}_atomic_one
      mm, fs, dax: handle layout changes to pinned dax mappings
      xfs: prepare xfs_break_layouts() for another layout type
      xfs, dax: introduce xfs_break_dax_layouts()


 drivers/dax/super.c      |   96 +++++++++++++++--
 drivers/nvdimm/pmem.c    |    3 -
 fs/Kconfig               |    1 
 fs/dax.c                 |  259 +++++++++++++++++++++++++++++++++++++---------
 fs/ext2/ext2.h           |    1 
 fs/ext2/inode.c          |   28 ++++-
 fs/ext2/namei.c          |   18 ---
 fs/ext2/super.c          |    6 +
 fs/ext4/inode.c          |   11 ++
 fs/ext4/super.c          |    6 +
 fs/xfs/xfs_aops.c        |    7 +
 fs/xfs/xfs_aops.h        |    1 
 fs/xfs/xfs_file.c        |   94 ++++++++++++++++-
 fs/xfs/xfs_inode.h       |    9 ++
 fs/xfs/xfs_ioctl.c       |    9 +-
 fs/xfs/xfs_iops.c        |   17 ++-
 fs/xfs/xfs_pnfs.c        |    8 +
 fs/xfs/xfs_pnfs.h        |    4 -
 fs/xfs/xfs_super.c       |   20 ++--
 include/linux/dax.h      |   45 +++++++-
 include/linux/memremap.h |   28 ++---
 include/linux/mm.h       |   61 ++++++++---
 include/linux/wait_bit.h |   13 ++
 kernel/memremap.c        |   30 +++++
 kernel/sched/wait_bit.c  |   59 +++++++++-
 mm/Kconfig               |    5 +
 mm/gup.c                 |    5 +
 mm/hmm.c                 |   13 --
 mm/swap.c                |    3 -
 29 files changed, 663 insertions(+), 197 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
