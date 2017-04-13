Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14BC12194EB6F
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:06:43 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 13 Apr 2017 16:05:13 -0600
Message-Id: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 00/22] Introduce common scatterlist map function
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
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Sumit Semwal <sumit.semwal@linaro.org>, Ming Lin <ming.l@ssi.samsung.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, target-devel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: Steve Wise <swise@opengridcomputing.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Everyone,

As part of my effort to enable P2P DMA transactions with PCI cards,
we've identified the need to be able to safely put IO memory into
scatterlists (and eventually other spots). This probably involves a
conversion from struct page to pfn_t but that migration is a ways off
and those decisions are yet to be made.

As an initial step in that direction, I've started cleaning up some of the
scatterlist code by trying to carve out a better defined layer between it
and it's users. The longer term goal would be to remove sg_page or replace
it with something that can potentially fail.

This patchset is the first step in that effort. I've introduced
a common function to map scatterlist memory and converted all the common
kmap(sg_page()) cases. This removes about 66 sg_page calls (of ~331).

Seeing this is a fairly large cleanup set that touches a wide swath of
the kernel I have limited the people I've sent this to. I'd suggest we look
toward merging the first patch and then I can send the individual subsystem
patches on to their respective maintainers and get them merged
independantly. (This is to avoid the conflicts I created with my last
cleanup set... Sorry) Though, I'm certainly open to other suggestions to get
it merged.

The patchset is based on v4.11-rc6 and can be found in the sg_map
branch from this git tree:

https://github.com/sbates130272/linux-p2pmem.git

Thanks,

Logan


Logan Gunthorpe (22):
  scatterlist: Introduce sg_map helper functions
  nvmet: Make use of the new sg_map helper function
  libiscsi: Make use of new the sg_map helper function
  target: Make use of the new sg_map function at 16 call sites
  drm/i915: Make use of the new sg_map helper function
  crypto: hifn_795x: Make use of the new sg_map helper function
  crypto: shash, caam: Make use of the new sg_map helper function
  crypto: chcr: Make use of the new sg_map helper function
  dm-crypt: Make use of the new sg_map helper in 4 call sites
  staging: unisys: visorbus: Make use of the new sg_map helper function
  RDS: Make use of the new sg_map helper function
  scsi: ipr, pmcraid, isci: Make use of the new sg_map helper in 4 call
    sites
  scsi: hisi_sas, mvsas, gdth: Make use of the new sg_map helper
    function
  scsi: arcmsr, ips, megaraid: Make use of the new sg_map helper
    function
  scsi: libfc, csiostor: Change to sg_copy_buffer in two drivers
  xen-blkfront: Make use of the new sg_map helper function
  mmc: sdhci: Make use of the new sg_map helper function
  mmc: spi: Make use of the new sg_map helper function
  mmc: tmio: Make use of the new sg_map helper function
  mmc: sdricoh_cs: Make use of the new sg_map helper function
  mmc: tifm_sd: Make use of the new sg_map helper function
  memstick: Make use of the new sg_map helper function

 crypto/shash.c                                  |   9 +-
 drivers/block/xen-blkfront.c                    |  33 +++++--
 drivers/crypto/caam/caamalg.c                   |   8 +-
 drivers/crypto/chelsio/chcr_algo.c              |  28 +++---
 drivers/crypto/hifn_795x.c                      |  32 ++++---
 drivers/dma-buf/dma-buf.c                       |   3 +
 drivers/gpu/drm/i915/i915_gem.c                 |  27 +++---
 drivers/md/dm-crypt.c                           |  38 +++++---
 drivers/memstick/host/jmb38x_ms.c               |  23 ++++-
 drivers/memstick/host/tifm_ms.c                 |  22 ++++-
 drivers/mmc/host/mmc_spi.c                      |  26 +++--
 drivers/mmc/host/sdhci.c                        |  35 ++++++-
 drivers/mmc/host/sdricoh_cs.c                   |  14 ++-
 drivers/mmc/host/tifm_sd.c                      |  88 +++++++++++++----
 drivers/mmc/host/tmio_mmc.h                     |  12 ++-
 drivers/mmc/host/tmio_mmc_dma.c                 |   5 +
 drivers/mmc/host/tmio_mmc_pio.c                 |  24 +++++
 drivers/nvme/target/fabrics-cmd.c               |  16 +++-
 drivers/scsi/arcmsr/arcmsr_hba.c                |  16 +++-
 drivers/scsi/csiostor/csio_scsi.c               |  54 +----------
 drivers/scsi/cxgbi/libcxgbi.c                   |   5 +
 drivers/scsi/gdth.c                             |   9 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c          |  14 ++-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c          |  13 ++-
 drivers/scsi/ipr.c                              |  27 +++---
 drivers/scsi/ips.c                              |   8 +-
 drivers/scsi/isci/request.c                     |  42 ++++----
 drivers/scsi/libfc/fc_libfc.c                   |  49 ++--------
 drivers/scsi/libiscsi_tcp.c                     |  32 ++++---
 drivers/scsi/megaraid.c                         |   9 +-
 drivers/scsi/mvsas/mv_sas.c                     |  10 +-
 drivers/scsi/pmcraid.c                          |  19 ++--
 drivers/staging/unisys/visorhba/visorhba_main.c |  12 ++-
 drivers/target/iscsi/iscsi_target.c             |  27 ++++--
 drivers/target/target_core_rd.c                 |   3 +-
 drivers/target/target_core_sbc.c                | 122 +++++++++++++++++-------
 drivers/target/target_core_transport.c          |  18 ++--
 drivers/target/target_core_user.c               |  43 ++++++---
 include/linux/scatterlist.h                     |  97 +++++++++++++++++++
 include/scsi/libiscsi_tcp.h                     |   3 +-
 include/target/target_core_backend.h            |   4 +-
 net/rds/ib_recv.c                               |  17 +++-
 42 files changed, 739 insertions(+), 357 deletions(-)

--
2.1.4
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
