Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA93021AE3CD1
 for <linux-nvdimm@lists.01.org>; Wed, 24 May 2017 14:43:17 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Wed, 24 May 2017 15:42:11 -0600
Message-Id: <1495662147-18277-1-git-send-email-logang@deltatee.com>
Subject: [RFC PATCH 00/16] Unmappable memory in SGLs for p2p transfers
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
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Berg <johannes.berg@intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ming Lei <ming.lei@canonical.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi,

This RFC patchset continues my work attempting to enforce iomem safety
within scatterlists. This takes a bit of a different tack from my
last series [1] which tried to introduce a common scatterlist mapping
function. Instead, this series takes the approach of marking SGLs that
may contain unmappable memory and fencing off only the marked instances
from calling sg_page and sg_virt, etc. This means we'd no longer need to
clean up every SGL user in the kernel and try to deal with cases that
assume every SGL always contains mappable memory with no error path.

Patches 1 through 5 are cleanup/prep patches that I'll likely be
submitting to their respective maintainers in short order.

Patch 6 converts SGLs to use pfn_t instead of the existing page_link
as suggested (and seemingly planned for) by Dan.

Patches 7 and 8 then add unmappable or io memory support to SGLs

Patches 9 through 14, similarly convert the bvec layer to use pfn_t

Patches 15 and 16 test the above work by applying it to the nvme-fabrics
code such that unmappable SGLs are being used without any BUG_ONS in
somewhat limitted testing cases.

Seeing this work is still incomplete and experimental, I'm looking to
get feedback on people's opinions of whether this is an acceptable
approach. If it is favourable, would people be open to seeing cleaned
up versions of patches 6, and 9 through 14 be submitted upstream?
(ie. just the parts for converting to pfn_t and continuing the
unmappable/iomem/p2pmem work out-of-tree for a time).

This work also opens up the possibility of having p2pmem not use
ZONE_DEVICE struct pages and instead just sticking with pfn_ts
with a specific p2p radix tree for looking up the backing device.
Presently, I'm ambivalent towards this and would like to hear other's
opinions.

This series is based on v4.12-rc2 and a git tree is available here:

https://github.com/sbates130272/linux-p2pmem.git io_pfn_t

Thanks for your time,

Logan

[1] https://lkml.org/lkml/2017/4/25/738

Logan Gunthorpe (16):
  dmaengine: ste_dma40, imx-dma: Cleanup scatterlist layering violations
  staging: ccree: Cleanup: remove references to page_link
  kfifo: Cleanup example to not use page_link
  um: add dummy ioremap and iounmap functions
  tile: provide default ioremap declaration
  scatterlist: convert page_link to pfn_t
  scatterlist: support unmappable memory in the scatterlist
  scatterlist: add iomem support to sg_miter and sg_copy_*
  bvec: introduce bvec_page and bvec_set_page accessors
  bvec: massive conversion of all bv_page users
  bvec: convert to using pfn_t internally
  bvec: use sg_set_pfn when mapping a bio to an sgl
  block: bio: introduce bio_add_pfn
  block: bio: go straight from pfn_t to phys instead of through page
  dma-mapping: introduce and use unmappable safe sg_virt call
  nvmet: use unmappable sgl in rdma target

 arch/powerpc/sysdev/axonram.c                      |   2 +-
 arch/tile/mm/pgtable.c                             |  13 ++
 arch/um/include/asm/io.h                           |  17 ++
 block/bio-integrity.c                              |   8 +-
 block/bio.c                                        |  58 +++----
 block/blk-core.c                                   |   2 +-
 block/blk-integrity.c                              |   6 +-
 block/blk-lib.c                                    |   2 +-
 block/blk-merge.c                                  |  10 +-
 block/blk-zoned.c                                  |   6 +-
 block/bounce.c                                     |  27 +--
 drivers/block/aoe/aoecmd.c                         |   4 +-
 drivers/block/brd.c                                |   3 +-
 drivers/block/drbd/drbd_bitmap.c                   |   6 +-
 drivers/block/drbd/drbd_main.c                     |   4 +-
 drivers/block/drbd/drbd_receiver.c                 |   4 +-
 drivers/block/drbd/drbd_worker.c                   |   2 +-
 drivers/block/floppy.c                             |   4 +-
 drivers/block/loop.c                               |  12 +-
 drivers/block/ps3disk.c                            |   2 +-
 drivers/block/ps3vram.c                            |   2 +-
 drivers/block/rbd.c                                |   2 +-
 drivers/block/rsxx/dma.c                           |   3 +-
 drivers/block/umem.c                               |   2 +-
 drivers/block/zram/zram_drv.c                      |  14 +-
 drivers/dma/imx-dma.c                              |   7 +-
 drivers/dma/ste_dma40.c                            |   5 +-
 drivers/lightnvm/pblk-core.c                       |   2 +-
 drivers/lightnvm/pblk-read.c                       |   6 +-
 drivers/md/bcache/btree.c                          |   2 +-
 drivers/md/bcache/debug.c                          |   4 +-
 drivers/md/bcache/request.c                        |   4 +-
 drivers/md/bcache/super.c                          |  10 +-
 drivers/md/bcache/util.c                           |   6 +-
 drivers/md/dm-crypt.c                              |  16 +-
 drivers/md/dm-integrity.c                          |  18 +-
 drivers/md/dm-io.c                                 |   2 +-
 drivers/md/dm-log-writes.c                         |  12 +-
 drivers/md/dm-verity-target.c                      |   4 +-
 drivers/md/raid5.c                                 |  10 +-
 drivers/memstick/core/mspro_block.c                |   2 +-
 drivers/nvdimm/blk.c                               |   4 +-
 drivers/nvdimm/btt.c                               |   5 +-
 drivers/nvdimm/pmem.c                              |   2 +-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/host/nvme.h                           |   2 +-
 drivers/nvme/host/pci.c                            |   5 +-
 drivers/nvme/target/Kconfig                        |  12 ++
 drivers/nvme/target/io-cmd.c                       |   2 +-
 drivers/nvme/target/rdma.c                         |  29 +++-
 drivers/s390/block/dasd_diag.c                     |   2 +-
 drivers/s390/block/dasd_eckd.c                     |  14 +-
 drivers/s390/block/dasd_fba.c                      |   6 +-
 drivers/s390/block/dcssblk.c                       |   2 +-
 drivers/s390/block/scm_blk.c                       |   2 +-
 drivers/s390/block/scm_blk_cluster.c               |   2 +-
 drivers/s390/block/xpram.c                         |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   6 +-
 drivers/scsi/sd.c                                  |  16 +-
 drivers/scsi/sd_dif.c                              |   4 +-
 drivers/staging/ccree/ssi_buffer_mgr.c             |  17 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |   4 +-
 .../lustre/lnet/klnds/socklnd/socklnd_lib.c        |  10 +-
 drivers/staging/lustre/lnet/lnet/lib-move.c        |   4 +-
 drivers/staging/lustre/lnet/lnet/router.c          |   6 +-
 drivers/staging/lustre/lnet/selftest/brw_test.c    |   4 +-
 drivers/staging/lustre/lnet/selftest/conrpc.c      |  10 +-
 drivers/staging/lustre/lnet/selftest/framework.c   |   2 +-
 drivers/staging/lustre/lnet/selftest/rpc.c         |   4 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |   2 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |   2 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      |   2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |   6 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_plain.c   |   4 +-
 drivers/target/target_core_file.c                  |   4 +-
 drivers/xen/biomerge.c                             |   4 +-
 fs/9p/vfs_addr.c                                   |   6 +-
 fs/afs/rxrpc.c                                     |   4 +-
 fs/block_dev.c                                     |   8 +-
 fs/btrfs/check-integrity.c                         |   4 +-
 fs/btrfs/compression.c                             |  14 +-
 fs/btrfs/disk-io.c                                 |   4 +-
 fs/btrfs/extent_io.c                               |   8 +-
 fs/btrfs/file-item.c                               |   8 +-
 fs/btrfs/inode.c                                   |  14 +-
 fs/btrfs/raid56.c                                  |   4 +-
 fs/buffer.c                                        |   2 +-
 fs/cifs/connect.c                                  |   3 +-
 fs/cifs/file.c                                     |   6 +-
 fs/cifs/misc.c                                     |   2 +-
 fs/cifs/smb2ops.c                                  |   2 +-
 fs/cifs/transport.c                                |   3 +-
 fs/crypto/bio.c                                    |   2 +-
 fs/direct-io.c                                     |   2 +-
 fs/exofs/ore.c                                     |   4 +-
 fs/exofs/ore_raid.c                                |   2 +-
 fs/ext4/page-io.c                                  |   2 +-
 fs/ext4/readpage.c                                 |   2 +-
 fs/f2fs/data.c                                     |  12 +-
 fs/gfs2/lops.c                                     |   4 +-
 fs/gfs2/meta_io.c                                  |   2 +-
 fs/iomap.c                                         |   2 +-
 fs/mpage.c                                         |   2 +-
 fs/orangefs/inode.c                                |   3 +-
 fs/splice.c                                        |   2 +-
 fs/xfs/xfs_aops.c                                  |   2 +-
 include/linux/bio.h                                |  34 +++-
 include/linux/bvec.h                               |  21 ++-
 include/linux/dma-mapping.h                        |   9 +-
 include/linux/pfn_t.h                              |  42 ++++-
 include/linux/scatterlist.h                        | 189 +++++++++++++++------
 kernel/power/swap.c                                |   2 +-
 lib/Kconfig                                        |  11 ++
 lib/iov_iter.c                                     |  24 +--
 lib/scatterlist.c                                  |  65 ++++++-
 mm/page_io.c                                       |   8 +-
 net/ceph/messenger.c                               |   6 +-
 samples/kfifo/dma-example.c                        |   8 +-
 118 files changed, 690 insertions(+), 393 deletions(-)
 create mode 100644 arch/um/include/asm/io.h

--
2.1.4
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
