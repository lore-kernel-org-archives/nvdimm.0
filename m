Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 62A89222F4E13
 for <linux-nvdimm@lists.01.org>; Sat, 23 Dec 2017 16:59:24 -0800 (PST)
Subject: [PATCH v4 00/18] dax: fix dma vs truncate/hole-punch
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Dec 2017 16:56:00 -0800
Message-ID: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, Peter Zijlstra <peterz@infradead.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andreas Dilger <adilger.kernel@dilger.ca>, hch@lst.de, Matthew Wilcox <mawilcox@microsoft.com>, Michael Ellerman <mpe@ellerman.id.au>, Ingo Molnar <mingo@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v3 [1]:
* Kill the i_daxdma_lock, and do not impose any new locking constraints
  on filesystem implementations (Dave)

* Reuse the existing i_mmap_lock for synchronizing against
  get_user_pages() by unmapping and causing punch-hole/truncate to
  re-fault the page before get_user_pages() can elevate the page reference
  count (Jan)

* Create a dax-specifc address_space_operations instance for each
  filesystem. This allows page->mapping to be set for dax pages. (Jan).

* Change the ext4 and ext2 policy of 'mount -o dax' vs a device that
  does not support dax. This converts any environments that may have
  been using 'page-less' dax back to using page cache.

* Rename wait_on_devmap_idle() to wait_on_atomic_one(), a generic
  facility for waiting for an atomic counter to reach a value of '1'.

[1]: https://lwn.net/Articles/737273/

---

Background:

get_user_pages() pins file backed memory pages for access by dma
devices. However, it only pins the memory pages not the page-to-file
offset association. If a file is truncated the pages are mapped out of
the file and dma may continue indefinitely into a page that is owned by
a device driver. This breaks coherency of the file vs dma, but the
assumption is that if userspace wants the file-space truncated it does
not matter what data is inbound from the device, it is not relevant
anymore. The only expectation is that dma can safely continue while the
filesystem reallocates the block(s).

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

The dax_flush_dma() routine is called by filesystems with a lock held
against mm faults (i_mmap_lock). It then invalidates all mappings to
trigger any subsequent get_user_pages() to block on i_mmap_lock. Finally
it scans/rescans all pages in the mapping until it observes all pages
idle.

So far this solution only targets xfs since it already implements
xfs_break_layouts in all the locations that would need this
synchronization. It applies on top of the vmem_altmap / dev_pagemap
reworks from Christoph.

---

Dan Williams (18):
      mm, dax: introduce pfn_t_special()
      ext4: auto disable dax instead of failing mount
      ext2: auto disable dax instead of failing mount
      dax: require 'struct page' by default for filesystem dax
      dax: stop using VM_MIXEDMAP for dax
      dax: stop using VM_HUGEPAGE for dax
      dax: store pfns in the radix
      tools/testing/nvdimm: add 'bio_delay' mechanism
      mm, dax: enable filesystems to trigger dev_pagemap ->page_free callbacks
      mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
      fs, dax: introduce DEFINE_FSDAX_AOPS
      xfs: use DEFINE_FSDAX_AOPS
      ext4: use DEFINE_FSDAX_AOPS
      ext2: use DEFINE_FSDAX_AOPS
      mm, fs, dax: use page->mapping to warn if dma collides with truncate
      wait_bit: introduce {wait_on,wake_up}_atomic_one
      mm, fs, dax: dax_flush_dma, handle dma vs block-map-change collisions
      xfs, dax: wire up dax_flush_dma support via a new xfs_sync_dma helper


 arch/powerpc/platforms/Kconfig        |    1 
 arch/powerpc/sysdev/axonram.c         |    2 
 drivers/dax/device.c                  |    1 
 drivers/dax/super.c                   |  100 ++++++++++-
 drivers/nvdimm/pmem.c                 |    3 
 drivers/s390/block/Kconfig            |    1 
 drivers/s390/block/dcssblk.c          |    3 
 fs/Kconfig                            |    8 +
 fs/dax.c                              |  295 ++++++++++++++++++++++++++++-----
 fs/ext2/ext2.h                        |    1 
 fs/ext2/file.c                        |    1 
 fs/ext2/inode.c                       |   23 ++-
 fs/ext2/namei.c                       |   18 --
 fs/ext2/super.c                       |   13 +
 fs/ext4/file.c                        |    1 
 fs/ext4/inode.c                       |    6 +
 fs/ext4/super.c                       |   15 +-
 fs/xfs/Makefile                       |    3 
 fs/xfs/xfs_aops.c                     |    2 
 fs/xfs/xfs_aops.h                     |    1 
 fs/xfs/xfs_dma.c                      |   81 +++++++++
 fs/xfs/xfs_dma.h                      |   24 +++
 fs/xfs/xfs_file.c                     |    8 -
 fs/xfs/xfs_ioctl.c                    |    7 -
 fs/xfs/xfs_iops.c                     |   12 +
 fs/xfs/xfs_super.c                    |   20 +-
 include/linux/dax.h                   |   70 +++++++-
 include/linux/memremap.h              |   28 +--
 include/linux/mm.h                    |   62 +++++--
 include/linux/pfn_t.h                 |   13 +
 include/linux/vma.h                   |   23 +++
 include/linux/wait_bit.h              |   13 +
 kernel/memremap.c                     |   30 +++
 kernel/sched/wait_bit.c               |   59 ++++++-
 mm/Kconfig                            |    5 +
 mm/gup.c                              |    5 +
 mm/hmm.c                              |   13 -
 mm/huge_memory.c                      |    6 -
 mm/ksm.c                              |    3 
 mm/madvise.c                          |    2 
 mm/memory.c                           |   22 ++
 mm/migrate.c                          |    3 
 mm/mlock.c                            |    5 -
 mm/mmap.c                             |    8 -
 mm/swap.c                             |    3 
 tools/testing/nvdimm/Kbuild           |    1 
 tools/testing/nvdimm/test/iomap.c     |   62 +++++++
 tools/testing/nvdimm/test/nfit.c      |   34 ++++
 tools/testing/nvdimm/test/nfit_test.h |    1 
 49 files changed, 918 insertions(+), 203 deletions(-)
 create mode 100644 fs/xfs/xfs_dma.c
 create mode 100644 fs/xfs/xfs_dma.h
 create mode 100644 include/linux/vma.h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
