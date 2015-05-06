Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 May 2015 16:04:53 -0400
Message-ID: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, hch@lst.de, Alasdair Kergon <agk@redhat.com>, linux-nvdimm@lists.01.org, mingo@kernel.org, mgorman@suse.de, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, riel@redhat.com, Martin Schwidefsky <schwidefsky@de.ibm.com>, axboe@kernel.dk, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1 [1]:

1/ added include/asm-generic/pfn.h for the __pfn_t definition and helpers.

2/ added kmap_atomic_pfn_t()

3/ rebased on v4.1-rc2

[1]: http://marc.info/?l=linux-kernel&m=142653770511970&w=2

---

A lead in note, this looks scarier than it is.  Most of the code thrash
is automated via Coccinelle.  Also the subtle differences behind an
'unsigned long pfn' and a '__pfn_t' are mitigated by type-safety and a
Kconfig option (default disabled CONFIG_PMEM_IO) that globally controls
whether a pfn and a __pfn_t are equivalent.

The motivation for this change is persistent memory and the desire to
use it not only via the pmem driver, but also as a memory target for I/O
(DAX, O_DIRECT, DMA, RDMA, etc) in other parts of the kernel.  Aside
from the pmem driver and DAX, persistent memory is not able to be used
in these I/O scenarios due to the lack of a backing struct page, i.e.
persistent memory is not part of the memmap.  This patchset takes the
position that the solution is to teach I/O paths that want to operate on
persistent memory to do so by referencing a __pfn_t.  The alternatives
are discussed in the changelog for "[PATCH v2 01/10] arch: introduce
__pfn_t for persistent memory i/o", copied here:

    Alternatives:
    
    1/ Provide struct page coverage for persistent memory in
       DRAM.  The expectation is that persistent memory capacities make
       this untenable in the long term.
    
    2/ Provide struct page coverage for persistent memory with
       persistent memory.  While persistent memory may have near DRAM
       performance characteristics it may not have the same
       write-endurance of DRAM.  Given the update frequency of struct
       page objects it may not be suitable for persistent memory.
    
    3/ Dynamically allocate struct page.  This appears to be on
       the order of the complexity of converting code paths to use
       __pfn_t references instead of struct page, and the amount of
       setup required to establish a valid struct page reference is
       mostly wasted when the only usage in the block stack is to
       perform a page_to_pfn() conversion for dma-mapping.  Instances
       of kmap() / kmap_atomic() usage appear to be the only occasions
       in the block stack where struct page is non-trivially used.  A
       new kmap_atomic_pfn_t() is proposed to handle those cases.

---

Dan Williams (9):
      arch: introduce __pfn_t for persistent memory i/o
      block: add helpers for accessing a bio_vec page
      block: convert .bv_page to .bv_pfn bio_vec
      dma-mapping: allow archs to optionally specify a ->map_pfn() operation
      scatterlist: use sg_phys()
      x86: support dma_map_pfn()
      x86: support kmap_atomic_pfn_t() for persistent memory
      dax: convert to __pfn_t
      block: base support for pfn i/o

Matthew Wilcox (1):
      scatterlist: support "page-less" (__pfn_t only) entries


 arch/Kconfig                                 |    6 ++
 arch/arm/mm/dma-mapping.c                    |    2 -
 arch/microblaze/kernel/dma.c                 |    2 -
 arch/powerpc/sysdev/axonram.c                |    6 +-
 arch/x86/Kconfig                             |    7 ++
 arch/x86/kernel/Makefile                     |    1 
 arch/x86/kernel/amd_gart_64.c                |   22 +++++-
 arch/x86/kernel/kmap.c                       |   95 ++++++++++++++++++++++++++
 arch/x86/kernel/pci-nommu.c                  |   22 +++++-
 arch/x86/kernel/pci-swiotlb.c                |    4 +
 arch/x86/pci/sta2x11-fixup.c                 |    4 +
 arch/x86/xen/pci-swiotlb-xen.c               |    4 +
 block/bio-integrity.c                        |    8 +-
 block/bio.c                                  |   82 ++++++++++++++++------
 block/blk-core.c                             |   13 +++-
 block/blk-integrity.c                        |    7 +-
 block/blk-lib.c                              |    2 -
 block/blk-merge.c                            |   15 ++--
 block/bounce.c                               |   26 ++++---
 drivers/block/aoe/aoecmd.c                   |    8 +-
 drivers/block/brd.c                          |    6 +-
 drivers/block/drbd/drbd_bitmap.c             |    5 +
 drivers/block/drbd/drbd_main.c               |    6 +-
 drivers/block/drbd/drbd_receiver.c           |    4 +
 drivers/block/drbd/drbd_worker.c             |    3 +
 drivers/block/floppy.c                       |    6 +-
 drivers/block/loop.c                         |   13 ++--
 drivers/block/nbd.c                          |    8 +-
 drivers/block/nvme-core.c                    |    2 -
 drivers/block/pktcdvd.c                      |   11 ++-
 drivers/block/pmem.c                         |   16 +++-
 drivers/block/ps3disk.c                      |    2 -
 drivers/block/ps3vram.c                      |    2 -
 drivers/block/rbd.c                          |    2 -
 drivers/block/rsxx/dma.c                     |    2 -
 drivers/block/umem.c                         |    2 -
 drivers/block/zram/zram_drv.c                |   10 +--
 drivers/dma/ste_dma40.c                      |    5 -
 drivers/iommu/amd_iommu.c                    |   21 ++++--
 drivers/iommu/intel-iommu.c                  |   26 +++++--
 drivers/iommu/iommu.c                        |    2 -
 drivers/md/bcache/btree.c                    |    4 +
 drivers/md/bcache/debug.c                    |    6 +-
 drivers/md/bcache/movinggc.c                 |    2 -
 drivers/md/bcache/request.c                  |    6 +-
 drivers/md/bcache/super.c                    |   10 +--
 drivers/md/bcache/util.c                     |    5 +
 drivers/md/bcache/writeback.c                |    2 -
 drivers/md/dm-crypt.c                        |   12 ++-
 drivers/md/dm-io.c                           |    2 -
 drivers/md/dm-log-writes.c                   |   14 ++--
 drivers/md/dm-verity.c                       |    2 -
 drivers/md/raid1.c                           |   50 +++++++-------
 drivers/md/raid10.c                          |   38 +++++-----
 drivers/md/raid5.c                           |    6 +-
 drivers/mmc/card/queue.c                     |    4 +
 drivers/s390/block/dasd_diag.c               |    2 -
 drivers/s390/block/dasd_eckd.c               |   14 ++--
 drivers/s390/block/dasd_fba.c                |    6 +-
 drivers/s390/block/dcssblk.c                 |    8 +-
 drivers/s390/block/scm_blk.c                 |    2 -
 drivers/s390/block/scm_blk_cluster.c         |    2 -
 drivers/s390/block/xpram.c                   |    2 -
 drivers/scsi/mpt2sas/mpt2sas_transport.c     |    6 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c     |    6 +-
 drivers/scsi/sd_dif.c                        |    4 +
 drivers/staging/android/ion/ion_chunk_heap.c |    4 +
 drivers/staging/lustre/lustre/llite/lloop.c  |    2 -
 drivers/target/target_core_file.c            |    4 +
 drivers/xen/biomerge.c                       |    4 +
 drivers/xen/swiotlb-xen.c                    |   29 +++++---
 fs/9p/vfs_addr.c                             |    2 -
 fs/block_dev.c                               |    2 -
 fs/btrfs/check-integrity.c                   |    6 +-
 fs/btrfs/compression.c                       |   12 ++-
 fs/btrfs/disk-io.c                           |    5 +
 fs/btrfs/extent_io.c                         |    8 +-
 fs/btrfs/file-item.c                         |    8 +-
 fs/btrfs/inode.c                             |   19 +++--
 fs/btrfs/raid56.c                            |    4 +
 fs/btrfs/volumes.c                           |    2 -
 fs/buffer.c                                  |    4 +
 fs/dax.c                                     |    9 +-
 fs/direct-io.c                               |    2 -
 fs/exofs/ore.c                               |    4 +
 fs/exofs/ore_raid.c                          |    2 -
 fs/ext4/page-io.c                            |    2 -
 fs/ext4/readpage.c                           |    4 +
 fs/f2fs/data.c                               |    4 +
 fs/f2fs/segment.c                            |    2 -
 fs/gfs2/lops.c                               |    4 +
 fs/jfs/jfs_logmgr.c                          |    4 +
 fs/logfs/dev_bdev.c                          |   10 +--
 fs/mpage.c                                   |    2 -
 fs/splice.c                                  |    2 -
 include/asm-generic/dma-mapping-common.h     |   30 ++++++++
 include/asm-generic/memory_model.h           |    1 
 include/asm-generic/pfn.h                    |   67 ++++++++++++++++++
 include/asm-generic/scatterlist.h            |   10 +++
 include/crypto/scatterwalk.h                 |   10 +++
 include/linux/bio.h                          |   24 ++++---
 include/linux/blk_types.h                    |   20 +++++
 include/linux/blkdev.h                       |    6 +-
 include/linux/dma-debug.h                    |   23 +++++-
 include/linux/dma-mapping.h                  |    8 ++
 include/linux/highmem.h                      |   23 ++++++
 include/linux/mm.h                           |    1 
 include/linux/scatterlist.h                  |   91 ++++++++++++++++++++++---
 include/linux/swiotlb.h                      |    4 +
 init/Kconfig                                 |   13 ++++
 kernel/power/block_io.c                      |    2 -
 lib/dma-debug.c                              |   10 ++-
 lib/iov_iter.c                               |   22 +++---
 lib/swiotlb.c                                |   20 ++++-
 mm/page_io.c                                 |   10 +--
 net/ceph/messenger.c                         |    2 -
 116 files changed, 896 insertions(+), 372 deletions(-)
 create mode 100644 arch/x86/kernel/kmap.c
 create mode 100644 include/asm-generic/pfn.h
