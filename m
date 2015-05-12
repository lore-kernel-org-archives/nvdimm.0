Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v3 00/11] evacuate struct page from the block layer,
 introduce __pfn_t
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 May 2015 00:29:28 -0400
Message-ID: <20150512042629.11521.70356.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, j.glisse@gmail.com, mingo@kernel.org, Alasdair Kergon <agk@redhat.com>, linux-arch@vger.kernel.org, linux-nvdimm@lists.01.org, hch@lst.de, mgorman@suse.de, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, riel@redhat.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>, axboe@kernel.dk, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v2 [1]:
[1]: https://lwn.net/Articles/643437/

1/ Linus pointed out that comparing a __pfn_t value against PAGE_OFFSET
was both inefficient, when PAGE_OFFSET is a large constant, and
incorrect for archs that set PAGE_OFFSET to zero.  Instead, take
advantage of the standard alignment of a 'struct page *' to store a set
of flags.  In this patch set the only flag defined is PFN_DEV to
indicate "this pfn originated from device memory".  A potential future
flag is PFN_DEV_MAPPED if the device has arranged for an associated
struct page for the __pfn_t.

2/ Fix DAX against pmem device disable/removal using
kmap_atomic_pfn_t().  We can later exploit these annotations to protect
against the "stray pointer problem" whereby a kernel bug in an unrelated
part of the system causes inadvertent scribbling over pmem.

3/ Made the series easier to merge as it no longer causes compile errors
by default for new usages of bv_page arriving in the next merge window.

4/ arch/x86/kernel/kmap.c => mm/pfn.c since it is generic functionality.

5/ Updated the kmap_atomic() helpers in bio.h to use kmap_atomic_pfn_t()

Incremental diffstat:

 arch/powerpc/sysdev/axonram.c      |  9 +++++--
 arch/x86/Kconfig                   |  2 +-
 arch/x86/kernel/Makefile           |  1 -
 block/bio.c                        |  4 +--
 block/blk-core.c                   |  2 +-
 drivers/block/brd.c                |  3 +--
 drivers/block/pmem.c               |  9 ++++---
 drivers/s390/block/dcssblk.c       | 11 +++++---
 fs/block_dev.c                     |  4 +--
 fs/dax.c                           | 57 ++++++++++++++++++++++++++++++++--------
 include/asm-generic/pfn.h          | 73 ++++++++++++++++++++++++++++++++++------------------
 include/linux/bio.h                | 14 +++++-----
 include/linux/blk_types.h          |  2 +-
 include/linux/blkdev.h             |  7 +++--
 init/Kconfig                       | 12 ++++-----
 mm/Makefile                        |  1 +
 arch/x86/kernel/kmap.c => mm/pfn.c |  0
 17 files changed, 140 insertions(+), 71 deletions(-)
 rename arch/x86/kernel/kmap.c => mm/pfn.c (100%)

While we wait for the debate [2] to settle about what to do about i/o
paths that ostensibly require struct page, these patches enable a
stacked/tiered storage driver to manage pmem fronting slower storage
media.

[2]: https://lists.01.org/pipermail/linux-nvdimm/2015-May/000727.html

---

Dan Williams (10):
      arch: introduce __pfn_t for persistenti/device memory
      block: add helpers for accessing a bio_vec page
      block: convert .bv_page to .bv_pfn bio_vec
      dma-mapping: allow archs to optionally specify a ->map_pfn() operation
      scatterlist: use sg_phys()
      x86: support dma_map_pfn()
      x86: support kmap_atomic_pfn_t() for persistent memory
      block: convert kmap helpers to kmap_atomic_pfn_t()
      dax: convert to __pfn_t
      block: base support for pfn i/o

Matthew Wilcox (1):
      scatterlist: support "page-less" (__pfn_t only) entries


 Documentation/block/biodoc.txt               |    4 +
 arch/Kconfig                                 |    6 ++
 arch/arm/mm/dma-mapping.c                    |    2 -
 arch/microblaze/kernel/dma.c                 |    2 -
 arch/powerpc/sysdev/axonram.c                |   13 ++-
 arch/x86/Kconfig                             |    7 ++
 arch/x86/kernel/amd_gart_64.c                |   22 +++++-
 arch/x86/kernel/pci-nommu.c                  |   22 +++++-
 arch/x86/kernel/pci-swiotlb.c                |    4 +
 arch/x86/pci/sta2x11-fixup.c                 |    4 +
 arch/x86/xen/pci-swiotlb-xen.c               |    4 +
 block/bio-integrity.c                        |    8 +-
 block/bio.c                                  |   82 +++++++++++++++-------
 block/blk-core.c                             |   13 +++
 block/blk-integrity.c                        |    7 +-
 block/blk-lib.c                              |    2 -
 block/blk-merge.c                            |   15 ++--
 block/bounce.c                               |   26 +++----
 drivers/block/aoe/aoecmd.c                   |    8 +-
 drivers/block/brd.c                          |    7 +-
 drivers/block/drbd/drbd_bitmap.c             |    5 +
 drivers/block/drbd/drbd_main.c               |    6 +-
 drivers/block/drbd/drbd_receiver.c           |    4 +
 drivers/block/drbd/drbd_worker.c             |    3 +
 drivers/block/floppy.c                       |    6 +-
 drivers/block/loop.c                         |   13 ++-
 drivers/block/nbd.c                          |    8 +-
 drivers/block/nvme-core.c                    |    2 -
 drivers/block/pktcdvd.c                      |   11 ++-
 drivers/block/pmem.c                         |   19 ++++-
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
 drivers/md/raid1.c                           |   50 +++++++------
 drivers/md/raid10.c                          |   38 +++++-----
 drivers/md/raid5.c                           |    6 +-
 drivers/mmc/card/queue.c                     |    4 +
 drivers/s390/block/dasd_diag.c               |    2 -
 drivers/s390/block/dasd_eckd.c               |   14 ++--
 drivers/s390/block/dasd_fba.c                |    6 +-
 drivers/s390/block/dcssblk.c                 |   15 +++-
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
 fs/block_dev.c                               |    4 +
 fs/btrfs/check-integrity.c                   |    6 +-
 fs/btrfs/compression.c                       |   12 ++-
 fs/btrfs/disk-io.c                           |    5 +
 fs/btrfs/extent_io.c                         |    8 +-
 fs/btrfs/file-item.c                         |    8 +-
 fs/btrfs/inode.c                             |   19 +++--
 fs/btrfs/raid56.c                            |    4 +
 fs/btrfs/volumes.c                           |    2 -
 fs/buffer.c                                  |    4 +
 fs/dax.c                                     |   62 +++++++++++++---
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
 include/asm-generic/pfn.h                    |   95 +++++++++++++++++++++++++
 include/asm-generic/scatterlist.h            |   10 +++
 include/crypto/scatterwalk.h                 |   10 +++
 include/linux/bio.h                          |   28 ++++---
 include/linux/blk_types.h                    |   31 ++++++++
 include/linux/blkdev.h                       |    9 +-
 include/linux/dma-debug.h                    |   23 +++++-
 include/linux/dma-mapping.h                  |    8 ++
 include/linux/highmem.h                      |   23 ++++++
 include/linux/mm.h                           |    1 
 include/linux/scatterlist.h                  |   91 ++++++++++++++++++++++--
 include/linux/swiotlb.h                      |    4 +
 init/Kconfig                                 |   13 +++
 kernel/power/block_io.c                      |    2 -
 lib/dma-debug.c                              |   10 ++-
 lib/iov_iter.c                               |   22 +++---
 lib/swiotlb.c                                |   20 ++++-
 mm/Makefile                                  |    1 
 mm/page_io.c                                 |   10 +--
 mm/pfn.c                                     |   98 ++++++++++++++++++++++++++
 net/ceph/messenger.c                         |    2 -
 117 files changed, 1003 insertions(+), 391 deletions(-)
 create mode 100644 include/asm-generic/pfn.h
 create mode 100644 mm/pfn.c
