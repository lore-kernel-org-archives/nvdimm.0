Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <550957B9.5050803@gmail.com>
Date: Wed, 18 Mar 2015 12:47:21 +0200
From: Boaz Harrosh <openosd@gmail.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, Al Viro <viro@ZenIV.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-arch@vger.kernel.org, riel@redhat.com, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 03/16/2015 10:25 PM, Dan Williams wrote:
> Avoid the impending disaster of requiring struct page coverage for what
> is expected to be ever increasing capacities of persistent memory.  

If you are saying "disaster", than we need to believe you. Or is there
a scientific proof for this.

Actually what you are proposing below, is the "real disaster".
(I do hope it is not impending)

> In conversations with Rik van Riel, Mel Gorman, and Jens Axboe at the
> recently concluded Linux Storage Summit it became clear that struct page
> is not required in many places, it was simply convenient to re-use.
> 
> Introduce helpers and infrastructure to remove struct page usage where
> it is not necessary.  One use case for these changes is to implement a
> write-back-cache in persistent memory for software-RAID.  Another use
> case for the scatterlist changes is RDMA to a pfn-range.
> 
> This compiles and boots, but 0day-kbuild-robot coverage is needed before
> this set exits "RFC".  Obviously, the coccinelle script needs to be
> re-run on the block updates for kernel.next.  As is, this only includes
> the resulting auto-generated-patch against 4.0-rc3.
> 
> ---
> 
> Dan Williams (6):
>       block: add helpers for accessing a bio_vec page
>       block: convert bio_vec.bv_page to bv_pfn
>       dma-mapping: allow archs to optionally specify a ->map_pfn() operation
>       scatterlist: use sg_phys()
>       x86: support dma_map_pfn()
>       block: base support for pfn i/o
> 
> Matthew Wilcox (1):
>       scatterlist: support "page-less" (__pfn_t only) entries
> 
> 
>  arch/Kconfig                                 |    3 +
>  arch/arm/mm/dma-mapping.c                    |    2 -
>  arch/microblaze/kernel/dma.c                 |    2 -
>  arch/powerpc/sysdev/axonram.c                |    2 -
>  arch/x86/Kconfig                             |   12 +++
>  arch/x86/kernel/amd_gart_64.c                |   22 ++++--
>  arch/x86/kernel/pci-nommu.c                  |   22 ++++--
>  arch/x86/kernel/pci-swiotlb.c                |    4 +
>  arch/x86/pci/sta2x11-fixup.c                 |    4 +
>  arch/x86/xen/pci-swiotlb-xen.c               |    4 +
>  block/bio-integrity.c                        |    8 +-
>  block/bio.c                                  |   83 +++++++++++++++------
>  block/blk-core.c                             |    9 ++
>  block/blk-integrity.c                        |    7 +-
>  block/blk-lib.c                              |    2 -
>  block/blk-merge.c                            |   15 ++--
>  block/bounce.c                               |   26 +++----
>  drivers/block/aoe/aoecmd.c                   |    8 +-
>  drivers/block/brd.c                          |    2 -
>  drivers/block/drbd/drbd_bitmap.c             |    5 +
>  drivers/block/drbd/drbd_main.c               |    4 +
>  drivers/block/drbd/drbd_receiver.c           |    4 +
>  drivers/block/drbd/drbd_worker.c             |    3 +
>  drivers/block/floppy.c                       |    6 +-
>  drivers/block/loop.c                         |    8 +-
>  drivers/block/nbd.c                          |    8 +-
>  drivers/block/nvme-core.c                    |    2 -
>  drivers/block/pktcdvd.c                      |   11 ++-
>  drivers/block/ps3disk.c                      |    2 -
>  drivers/block/ps3vram.c                      |    2 -
>  drivers/block/rbd.c                          |    2 -
>  drivers/block/rsxx/dma.c                     |    3 +
>  drivers/block/umem.c                         |    2 -
>  drivers/block/zram/zram_drv.c                |   10 +--
>  drivers/dma/ste_dma40.c                      |    5 -
>  drivers/iommu/amd_iommu.c                    |   21 ++++-
>  drivers/iommu/intel-iommu.c                  |   26 +++++--
>  drivers/iommu/iommu.c                        |    2 -
>  drivers/md/bcache/btree.c                    |    4 +
>  drivers/md/bcache/debug.c                    |    6 +-
>  drivers/md/bcache/movinggc.c                 |    2 -
>  drivers/md/bcache/request.c                  |    6 +-
>  drivers/md/bcache/super.c                    |   10 +--
>  drivers/md/bcache/util.c                     |    5 +
>  drivers/md/bcache/writeback.c                |    2 -
>  drivers/md/dm-crypt.c                        |   12 ++-
>  drivers/md/dm-io.c                           |    2 -
>  drivers/md/dm-verity.c                       |    2 -
>  drivers/md/raid1.c                           |   50 +++++++------
>  drivers/md/raid10.c                          |   38 +++++-----
>  drivers/md/raid5.c                           |    6 +-
>  drivers/mmc/card/queue.c                     |    4 +
>  drivers/s390/block/dasd_diag.c               |    2 -
>  drivers/s390/block/dasd_eckd.c               |   14 ++--
>  drivers/s390/block/dasd_fba.c                |    6 +-
>  drivers/s390/block/dcssblk.c                 |    2 -
>  drivers/s390/block/scm_blk.c                 |    2 -
>  drivers/s390/block/scm_blk_cluster.c         |    2 -
>  drivers/s390/block/xpram.c                   |    2 -
>  drivers/scsi/mpt2sas/mpt2sas_transport.c     |    6 +-
>  drivers/scsi/mpt3sas/mpt3sas_transport.c     |    6 +-
>  drivers/scsi/sd_dif.c                        |    4 +
>  drivers/staging/android/ion/ion_chunk_heap.c |    4 +
>  drivers/staging/lustre/lustre/llite/lloop.c  |    2 -
>  drivers/xen/biomerge.c                       |    4 +
>  drivers/xen/swiotlb-xen.c                    |   29 +++++--
>  fs/btrfs/check-integrity.c                   |    6 +-
>  fs/btrfs/compression.c                       |   12 ++-
>  fs/btrfs/disk-io.c                           |    4 +
>  fs/btrfs/extent_io.c                         |    8 +-
>  fs/btrfs/file-item.c                         |    8 +-
>  fs/btrfs/inode.c                             |   18 +++--
>  fs/btrfs/raid56.c                            |    4 +
>  fs/btrfs/volumes.c                           |    2 -
>  fs/buffer.c                                  |    4 +
>  fs/direct-io.c                               |    2 -
>  fs/exofs/ore.c                               |    4 +
>  fs/exofs/ore_raid.c                          |    2 -
>  fs/ext4/page-io.c                            |    2 -
>  fs/f2fs/data.c                               |    4 +
>  fs/f2fs/segment.c                            |    2 -
>  fs/gfs2/lops.c                               |    4 +
>  fs/jfs/jfs_logmgr.c                          |    4 +
>  fs/logfs/dev_bdev.c                          |   10 +--
>  fs/mpage.c                                   |    2 -
>  fs/splice.c                                  |    2 -
>  include/asm-generic/dma-mapping-common.h     |   30 ++++++++
>  include/asm-generic/memory_model.h           |    4 +
>  include/asm-generic/scatterlist.h            |    6 ++
>  include/crypto/scatterwalk.h                 |   10 +++
>  include/linux/bio.h                          |   24 +++---
>  include/linux/blk_types.h                    |   21 +++++
>  include/linux/blkdev.h                       |    2 +
>  include/linux/dma-debug.h                    |   23 +++++-
>  include/linux/dma-mapping.h                  |    8 ++
>  include/linux/scatterlist.h                  |  101 ++++++++++++++++++++++++--
>  include/linux/swiotlb.h                      |    5 +
>  kernel/power/block_io.c                      |    2 -
>  lib/dma-debug.c                              |    4 +
>  lib/swiotlb.c                                |   20 ++++-
>  mm/iov_iter.c                                |   22 +++---
>  mm/page_io.c                                 |    8 +-
>  net/ceph/messenger.c                         |    2 -

God! Look at this endless list of files and it is only the very beginning.
It does not even work and touches only 10% of what will need to be touched
for this to work, and very very marginally at that. There will always be
"another subsystem" that will not work. For example NUMA how will you do
NUMA aware pmem? and this is just a simple example. (I'm saying NUMA
because our tests show a huge drop in performance if you do not do
NUMA aware allocation)

Al, Jens, Christoph Andrew. Think of the immediate stability nightmare and
the long term torture to maintain two code paths. Two set of tests, and
the combinatorial explosions of tests.

I'm not the one afraid of hard work, if it was for a good cause, but for what?
really for what? The block layer, and RDMA, and networking, and spline, and what
ever the heck any one wants to imagine to do with pmem, already works perfectly
stable. right now!

We have set up RDMA pmem target without a single line of extra code,
and the RDMA client was trivial to write. We are sending down block layer
BIOs from pmem from day one, and even iscsi NFS and any kind of networking
directly from pmem, for almost a year now.

All it takes is two simple patches to mm that creates a pages-section
for pmem. The Kernel DOCs do says that a page is a construct that keeps track
of the sate of a physical page in memory. A memory mapped pmem is perfectly
that, and it has state that needs tracking just the same, Say that converted
block layers of yours now happens to be an iscsi and goes through the network
stack, it starts to need ref-counting, flags ... It has state.

Matthew Dan. I don't get it. Don't you guys at Intel have nothing to do? why
change half the Kernel? for what? to achieve what? all your wildest dreams
about pmem are right here already. What is it that you guys want to do with
this code that we cannot already do? And I can show you two tons of things
you cannot do with this code that we can already do. With two simple patches.

If it is stability that you are concerned with, "what if a pmem-page gets
to the wrong mm subsystem?" There are a couple small hardening patches and
and extra page-flag allocated, that can make the all thing foolproof. Though
up until now I have not encountered any problem.

>  103 files changed, 658 insertions(+), 335 deletions(-)

Please look, this is only the beginning. And does not even work. Let us come
back to our senses. As true hackers lets do the minimum effort to achieve new
heights. All it really takes to do all this is 2 little patches.

Cheers
Boaz

