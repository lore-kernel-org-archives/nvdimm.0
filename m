Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82410220E8E0E
 for <linux-nvdimm@lists.01.org>; Tue, 24 Apr 2018 16:42:59 -0700 (PDT)
Subject: [PATCH v9 0/9] dax: fix dma vs truncate/hole-punch
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 24 Apr 2018 16:33:01 -0700
Message-ID: <152461278149.17530.2867511144531572045.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, Mike Snitzer <snitzer@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, hch@lst.de, Thomas Meyer <thomas@m3y3r.de>, kbuild test robot <lkp@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Alasdair Kergon <agk@redhat.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <mawilcox@microsoft.com>, stable@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v8 [1]:
* Rebase on v4.17-rc2

* Fix get_user_pages_fast() for ZONE_DEVICE pages to revalidate the pte,
  pmd, pud after taking references (Jan)

* Kill dax_layout_lock(). With get_user_pages_fast() for ZONE_DEVICE
  fixed we can then rely on the {pte,pmd}_lock to synchronize
  dax_layout_busy_page() vs new page references (Jan)

* Hold the iolock over repeated invocations of dax_layout_busy_page() to
  enable truncate/hole-punch to make forward progress in the presence of
  a constant stream of new direct-I/O requests (Jan).

[1]: https://lists.01.org/pipermail/linux-nvdimm/2018-March/015058.html

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

Dan Williams (9):
      dax, dm: introduce ->fs_{claim,release}() dax_device infrastructure
      mm, dax: enable filesystems to trigger dev_pagemap ->page_free callbacks
      memremap: split devm_memremap_pages() and memremap() infrastructure
      mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
      mm: fix __gup_device_huge vs unmap
      mm, fs, dax: handle layout changes to pinned dax mappings
      xfs: prepare xfs_break_layouts() to be called with XFS_MMAPLOCK_EXCL
      xfs: prepare xfs_break_layouts() for another layout type
      xfs, dax: introduce xfs_break_dax_layouts()


 drivers/dax/super.c      |   99 ++++++++++++++++++++--
 drivers/md/dm.c          |   57 +++++++++++++
 drivers/nvdimm/pmem.c    |    3 -
 fs/Kconfig               |    2 
 fs/dax.c                 |   97 +++++++++++++++++++++
 fs/ext2/super.c          |    6 +
 fs/ext4/super.c          |    6 +
 fs/xfs/xfs_file.c        |   72 +++++++++++++++-
 fs/xfs/xfs_inode.h       |   16 ++++
 fs/xfs/xfs_ioctl.c       |    8 --
 fs/xfs/xfs_iops.c        |   16 ++--
 fs/xfs/xfs_pnfs.c        |   16 ++--
 fs/xfs/xfs_pnfs.h        |    6 +
 fs/xfs/xfs_super.c       |   20 ++--
 include/linux/dax.h      |   71 +++++++++++++++-
 include/linux/memremap.h |   25 ++----
 include/linux/mm.h       |   71 ++++++++++++----
 kernel/Makefile          |    3 -
 kernel/iomem.c           |  167 +++++++++++++++++++++++++++++++++++++
 kernel/memremap.c        |  208 ++++++----------------------------------------
 mm/Kconfig               |    5 +
 mm/gup.c                 |   37 ++++++--
 mm/hmm.c                 |   13 ---
 mm/swap.c                |    3 -
 24 files changed, 730 insertions(+), 297 deletions(-)
 create mode 100644 kernel/iomem.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
