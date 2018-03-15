Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FCB9220C2A52
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 08:54:04 -0700 (PDT)
Subject: [PATCH v6 00/15] dax: fix dma vs truncate/hole-punch
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Mar 2018 08:51:22 -0700
Message-ID: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, Matthew Wilcox <mawilcox@microsoft.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Changes since v5 [1]:
* Split the introduction of dax-specific address_space_operations into
  its own patch, and place them in fs/libfs.c (Christoph)

* Kill some more straggling dead code implementing dax support for block
  devices.

* Mark devm_memremap_pages EXPORT_SYMBOL_GPL (Christoph)

* Introduce {xfs,ext4,ext2}_dax_writepages() and kill the dynamic check
  for IS_DAX() in the typical _writepages() implementations in these
  filesystems. (Christoph)

* Rework xfs_break_layouts() to assume the XFS_MMAPLOCK_EXCL is held at
  entry. (Christoph)

* Replace the XFS_BREAK_WRITE and XFS_BREAK_MAPS flags with the
  BREAK_WRITE and BREAK_TRUNCATE enum values since BREAK_WRITE is a
  subset of BREAK_TRUNCATE. (Christoph)

* Replace wait_for_atomic_one() with Peter's new wait_var_event()
  facility [2]. (Peter)

[1]: https://lists.01.org/pipermail/linux-nvdimm/2018-March/014585.html
[2]: https://patchwork.kernel.org/patch/10284383/

---

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

Dan Williams (15):
      dax: store pfns in the radix
      fs, dax: prepare for dax-specific address_space_operations
      block, dax: remove dead code in blkdev_writepages()
      xfs, dax: introduce xfs_dax_aops
      ext4, dax: introduce ext4_dax_aops
      ext2, dax: introduce ext2_dax_aops
      fs, dax: use page->mapping to warn if truncate collides with a busy page
      mm, dax: enable filesystems to trigger dev_pagemap ->page_free callbacks
      mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
      memremap: mark devm_memremap_pages() EXPORT_SYMBOL_GPL
      mm, fs, dax: handle layout changes to pinned dax mappings
      xfs: require mmap lock for xfs_break_layouts()
      xfs: communicate lock drop events from xfs_break_layouts()
      xfs: prepare xfs_break_layouts() for another layout type
      xfs, dax: introduce xfs_break_dax_layouts()


 drivers/dax/super.c      |   96 ++++++++++++++++---
 drivers/nvdimm/pmem.c    |    3 -
 fs/Kconfig               |    1 
 fs/block_dev.c           |    5 -
 fs/dax.c                 |  232 ++++++++++++++++++++++++++++++++++++----------
 fs/ext2/ext2.h           |    1 
 fs/ext2/inode.c          |   43 +++++----
 fs/ext2/namei.c          |   18 ----
 fs/ext2/super.c          |    6 +
 fs/ext4/inode.c          |   38 ++++++--
 fs/ext4/super.c          |    6 +
 fs/libfs.c               |   27 +++++
 fs/xfs/xfs_aops.c        |   21 +++-
 fs/xfs/xfs_aops.h        |    1 
 fs/xfs/xfs_file.c        |   87 ++++++++++++++++-
 fs/xfs/xfs_inode.h       |   16 +++
 fs/xfs/xfs_ioctl.c       |    8 --
 fs/xfs/xfs_iops.c        |   21 +++-
 fs/xfs/xfs_pnfs.c        |   17 ++-
 fs/xfs/xfs_pnfs.h        |    4 -
 fs/xfs/xfs_super.c       |   20 ++--
 include/linux/dax.h      |   51 +++++++++-
 include/linux/fs.h       |    3 +
 include/linux/memremap.h |   28 ++----
 include/linux/mm.h       |   61 +++++++++---
 kernel/memremap.c        |   32 +++++-
 mm/Kconfig               |    5 +
 mm/gup.c                 |    5 +
 mm/hmm.c                 |   13 ---
 mm/swap.c                |    3 -
 30 files changed, 653 insertions(+), 219 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
