Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 0/9] introduce __pfn_t, evacuate struct page from sgls
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 05 Jun 2015 17:19:01 -0400
Message-ID: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, arnd@arndb.de, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, benh@kernel.crashing.org, torvalds@linux-foundation.org, heiko.carstens@de.ibm.com, hch@lst.de, Julia Lawall <Julia.Lawall@lip6.fr>, paulus@samba.org, hpa@zytor.com, tj@kernel.org, willy@linux.intel.com, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, mingo@kernel.org, schwidefsky@de.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Introduce __pfn_t which:

1/ Allows kernel internal DAX mappings to adhere to the lifetime of the
   the underlying block device.  In general, it enables a mechanism to
   allow any device driver to advertise "device memory" (CONFIG_DEV_PFN)
   to other parts of the kernel.

2/ Replaces usage of struct page in struct scatterlist.  A scatterlist
   need only carry enough information to generate a dma address, and
   removing struct page from scatterlists is a precursor to allowing DMA to
   device memory.  Some dma mapping implementations are not ready for a
   scatterlist-pfn to reference unampped device memory, those
   implementations are disabled by CONFIG_DEV_PFN=y.
   
Changes since v4 [1]:

1/ Drop the bio_vec conversion of struct page to __pfn_t for now.  Wait
   until there's a hierarchical block driver that would make use of direct
   dma to pmem.  (Christoph)

2/ Reorder the patch set to put the dax fixes first.

3/ Unconditionally convert struct scatterlist to use a pfn.  Strictly
   speaking the scatterlist conversion could also be deferred until we have
   a driver that attempts dma to pmem, but struct scatterlist really has no
   valid reason to carry a struct page. (Christoph)

4/ Rebased on block.git/for-next

---

Dan Williams (9):
      introduce __pfn_t for scatterlists and pmem
      x86: support kmap_atomic_pfn_t() for persistent memory
      dax: drop size parameter to ->direct_access()
      dax: fix mapping lifetime handling, convert to __pfn_t + kmap_atomic_pfn_t()
      dma-mapping: allow archs to optionally specify a ->map_pfn() operation
      scatterlist: use sg_phys()
      scatterlist: cleanup sg_chain() and sg_unmark_end()
      scatterlist: convert to __pfn_t
      x86: convert dma_map_ops to support mapping a __pfn_t.


 arch/Kconfig                                 |    6 +
 arch/arm/mm/dma-mapping.c                    |    2 
 arch/microblaze/kernel/dma.c                 |    2 
 arch/powerpc/sysdev/axonram.c                |   26 ++++--
 arch/x86/Kconfig                             |    7 ++
 arch/x86/kernel/amd_gart_64.c                |   22 ++++-
 arch/x86/kernel/pci-nommu.c                  |   22 ++++-
 arch/x86/kernel/pci-swiotlb.c                |    4 +
 arch/x86/pci/sta2x11-fixup.c                 |    4 +
 block/blk-merge.c                            |    2 
 drivers/block/brd.c                          |    9 --
 drivers/block/pmem.c                         |   16 +++
 drivers/crypto/omap-sham.c                   |    2 
 drivers/dma/imx-dma.c                        |    8 --
 drivers/dma/ste_dma40.c                      |    5 -
 drivers/iommu/amd_iommu.c                    |   21 +++--
 drivers/iommu/intel-iommu.c                  |   26 ++++--
 drivers/iommu/iommu.c                        |    2 
 drivers/mmc/card/queue.c                     |    4 -
 drivers/pci/Kconfig                          |    2 
 drivers/s390/block/dcssblk.c                 |   26 +++++-
 drivers/staging/android/ion/ion_chunk_heap.c |    4 -
 fs/block_dev.c                               |    4 -
 fs/dax.c                                     |   62 +++++++++++--
 include/asm-generic/dma-mapping-common.h     |   30 +++++++
 include/asm-generic/memory_model.h           |    1 
 include/asm-generic/pfn.h                    |  120 ++++++++++++++++++++++++++
 include/crypto/scatterwalk.h                 |    9 --
 include/linux/blkdev.h                       |    7 +-
 include/linux/dma-debug.h                    |   23 ++++-
 include/linux/dma-mapping.h                  |    8 ++
 include/linux/highmem.h                      |   23 +++++
 include/linux/mm.h                           |    1 
 include/linux/scatterlist.h                  |  103 ++++++++++++++++------
 include/linux/swiotlb.h                      |    4 +
 init/Kconfig                                 |   13 +++
 lib/dma-debug.c                              |   10 +-
 lib/swiotlb.c                                |   20 +++-
 mm/Makefile                                  |    1 
 mm/pfn.c                                     |   98 +++++++++++++++++++++
 samples/kfifo/dma-example.c                  |    8 +-
 41 files changed, 626 insertions(+), 141 deletions(-)
 create mode 100644 include/asm-generic/pfn.h
 create mode 100644 mm/pfn.c
