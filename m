Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0AD8F2095AE46
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 16:06:07 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id k77so10167856oib.2
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 16:08:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150369480912.6962.5373358327146419354.stgit@djiang5-desk3.ch.intel.com>
References: <150369446130.6962.4195769527575520889.stgit@djiang5-desk3.ch.intel.com>
 <150369480912.6962.5373358327146419354.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Aug 2017 16:08:42 -0700
Message-ID: <CAPcyv4hgeRj1Dx9UpE1z3Z-dJQT=W0WSW-n2T2T3myUzEfDQ+g@mail.gmail.com>
Subject: Re: [PATCH v6 8/8] libnvdimm: Add blk-mq pmem driver
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Vinod Koul <vinod.koul@intel.com>, Christoph Hellwig <hch@infradead.org>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 25, 2017 at 2:00 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding a DMA supported blk-mq driver for pmem. This provides significant

s/Adding/Add/

> CPU utilization reduction at the cost of some increased latency and
> bandwidth reduction in some cases.  By default the current cpu-copy based
> pmem driver will load, but this driver can be manually selected with a
> modprobe configuration. The pmem driver will be using blk-mq with DMA
> through the dmaengine API.
>
> Numbers below are measured against pmem simulated via DRAM using
> memmap=NN!SS.  DMA engine used is the ioatdma on Intel Skylake Xeon
> platform.  Keep in mind the performance for persistent memory
> will differ.
> Fio 2.21 was used.
>
> 64k: 1 task queuedepth=1
> CPU Read:  7631 MB/s  99.7% CPU    DMA Read: 2415 MB/s  54% CPU
> CPU Write: 3552 MB/s  100% CPU     DMA Write 2173 MB/s  54% CPU
>
> 64k: 16 tasks queuedepth=16
> CPU Read: 36800 MB/s  1593% CPU    DMA Read:  29100 MB/s  607% CPU
> CPU Write 20900 MB/s  1589% CPU    DMA Write: 23400 MB/s  585% CPU
>
> 2M: 1 task queuedepth=1
> CPU Read:  6013 MB/s  99.3% CPU    DMA Read:  7986 MB/s  59.3% CPU
> CPU Write: 3579 MB/s  100% CPU     DMA Write: 5211 MB/s  58.3% CPU
>
> 2M: 16 tasks queuedepth=16
> CPU Read:  18100 MB/s 1588% CPU    DMA Read:  21300 MB/s 180.9% CPU
> CPU Write: 14100 MB/s 1594% CPU    DMA Write: 20400 MB/s 446.9% CPU
>
> Also, due to a significant portion of the code being shared with the
> pmem driver, the common code are broken out into a kernel module
> called pmem_core to be shared between the two drivers.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  drivers/nvdimm/Kconfig     |   21 ++
>  drivers/nvdimm/Makefile    |    6
>  drivers/nvdimm/pmem.c      |  264 -------------------
>  drivers/nvdimm/pmem.h      |   48 +++
>  drivers/nvdimm/pmem_core.c |  298 ++++++++++++++++++++++
>  drivers/nvdimm/pmem_dma.c  |  606 ++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 979 insertions(+), 264 deletions(-)
>  create mode 100644 drivers/nvdimm/pmem_core.c
>  create mode 100644 drivers/nvdimm/pmem_dma.c
>
> diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
> index 5bdd499..bb0f8a8 100644
> --- a/drivers/nvdimm/Kconfig
> +++ b/drivers/nvdimm/Kconfig
> @@ -17,12 +17,16 @@ menuconfig LIBNVDIMM
>
>  if LIBNVDIMM
>
> +config BLK_DEV_PMEM_CORE
> +       tristate
> +
>  config BLK_DEV_PMEM
>         tristate "PMEM: Persistent memory block device support"
>         default LIBNVDIMM
>         select DAX
>         select ND_BTT if BTT
>         select ND_PFN if NVDIMM_PFN
> +       select BLK_DEV_PMEM_CORE
>         help
>           Memory ranges for PMEM are described by either an NFIT
>           (NVDIMM Firmware Interface Table, see CONFIG_NFIT_ACPI), a
> @@ -36,6 +40,23 @@ config BLK_DEV_PMEM
>
>           Say Y if you want to use an NVDIMM
>
> +config BLK_DEV_PMEM_DMA
> +       tristate "PMEM: Persistent memory block device multi-queue support"
> +       depends on DMA_ENGINE

Is there a "depends on" we can add that checks for dmaengine drivers
that emit public channels? If all dmaengine drivers are restricted to
slave-dma we should hide this driver.

> +       depends on BLK_DEV_PMEM=m || !BLK_DEV_PMEM
> +       default LIBNVDIMM
> +       select DAX
> +       select ND_BTT if BTT
> +       select ND_PFN if NVDIMM_PFN

These last 3 selects can move to BLK_DEV_PMEM_CORE.

> +       select BLK_DEV_PMEM_CORE
> +       help
> +         This driver utilizes block layer multi-queue

I don't think the multi-queue detail helps the user decide whether to
use this driver or not.

> +         using DMA engines to help offload the data copying. The desire for
> +         this driver is to reduce CPU utilization with some sacrifice in
> +         latency and performance.
> +
> +         Say Y if you want to use an NVDIMM

I think we need to give a bit more background here on the tradeoffs
and mention that DAX completely bypasses the benefits of DMA offload.

> +
>  config ND_BLK
>         tristate "BLK: Block data window (aperture) device support"
>         default LIBNVDIMM
> diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
> index 909554c..cecc280 100644
> --- a/drivers/nvdimm/Makefile
> +++ b/drivers/nvdimm/Makefile
> @@ -1,11 +1,17 @@
>  obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
> +obj-$(CONFIG_BLK_DEV_PMEM_CORE) += nd_pmem_core.o
>  obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
> +obj-$(CONFIG_BLK_DEV_PMEM_DMA) += nd_pmem_dma.o
>  obj-$(CONFIG_ND_BTT) += nd_btt.o
>  obj-$(CONFIG_ND_BLK) += nd_blk.o
>  obj-$(CONFIG_X86_PMEM_LEGACY) += nd_e820.o
>
> +nd_pmem_core-y := pmem_core.o

Please split the pmem_core refactor into its own patch, and then
follow-on with the new driver.

> +
>  nd_pmem-y := pmem.o
>
> +nd_pmem_dma-y := pmem_dma.o
> +
>  nd_btt-y := btt.o
>
>  nd_blk-y := blk.o
[..]
> diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
> index 5434321..7e363fc 100644
> --- a/drivers/nvdimm/pmem.h
> +++ b/drivers/nvdimm/pmem.h
> @@ -4,6 +4,13 @@
>  #include <linux/types.h>
>  #include <linux/pfn_t.h>
>  #include <linux/fs.h>
> +#include <linux/blk-mq.h>
> +#include "nd.h"
> +
> +/* account for REQ_FLUSH rename, replace with REQ_PREFLUSH after v4.8-rc1 */
> +#ifndef REQ_FLUSH
> +#define REQ_FLUSH REQ_PREFLUSH
> +#endif

This can be deleted now.

[..]
> diff --git a/drivers/nvdimm/pmem_dma.c b/drivers/nvdimm/pmem_dma.c
> new file mode 100644
> index 0000000..3a5e4f6
> --- /dev/null
> +++ b/drivers/nvdimm/pmem_dma.c
> @@ -0,0 +1,606 @@
> +/*
> + * Persistent Memory Block Multi-Queue Driver
> + * - This driver is largely adapted from Ross's pmem block driver.
> + * Copyright (c) 2014-2017, Intel Corporation.
> + * Copyright (c) 2015, Christoph Hellwig <hch@lst.de>.
> + * Copyright (c) 2015, Boaz Harrosh <boaz@plexistor.com>.

This file should be all Intel code now, right?

> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#include <asm/cacheflush.h>
> +#include <linux/blkdev.h>
> +#include <linux/hdreg.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/badblocks.h>
> +#include <linux/memremap.h>
> +#include <linux/vmalloc.h>
> +#include <linux/blk-mq.h>
> +#include <linux/pfn_t.h>
> +#include <linux/slab.h>
> +#include <linux/uio.h>
> +#include <linux/dax.h>
> +#include <linux/nd.h>
> +#include <linux/blk-mq.h>
> +#include <linux/dmaengine.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/nodemask.h>
> +#include "pmem.h"
> +#include "pfn.h"
> +#include "nd.h"

I assume some of these headers can be cleaned up?

> +
> +#define QUEUE_DEPTH    128
> +#define SG_ALLOCATED   128

How are these contstants determined?

> +static int use_dma = 1;

I think this is better handled by loading / unloading the dma driver
rather than an explicit module option.

[..]
> +static int pmem_attach_disk(struct device *dev,
> +               struct nd_namespace_common *ndns)
> +{
> +       struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
> +       struct nd_region *nd_region = to_nd_region(dev->parent);
> +       struct vmem_altmap __altmap, *altmap = NULL;
> +       int nid = dev_to_node(dev), fua, wbc;
> +       struct resource *res = &nsio->res;
> +       struct nd_pfn *nd_pfn = NULL;
> +       struct dax_device *dax_dev;
> +       struct nd_pfn_sb *pfn_sb;
> +       struct pmem_device *pmem;
> +       struct resource pfn_res;
> +       struct device *gendev;
> +       struct gendisk *disk;
> +       void *addr;
> +       int rc;
> +       struct dma_chan *chan = NULL;
> +
> +       /* while nsio_rw_bytes is active, parse a pfn info block if present */
> +       if (is_nd_pfn(dev)) {
> +               nd_pfn = to_nd_pfn(dev);
> +               altmap = nvdimm_setup_pfn(nd_pfn, &pfn_res, &__altmap);
> +               if (IS_ERR(altmap))
> +                       return PTR_ERR(altmap);
> +       }
> +
> +       /* we're attaching a block device, disable raw namespace access */
> +       devm_nsio_disable(dev, nsio);
> +
> +       pmem = devm_kzalloc(dev, sizeof(*pmem), GFP_KERNEL);
> +       if (!pmem)
> +               return -ENOMEM;
> +
> +       dev_set_drvdata(dev, pmem);
> +       pmem->phys_addr = res->start;
> +       pmem->size = resource_size(res);
> +       fua = nvdimm_has_flush(nd_region);
> +       if (!IS_ENABLED(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) || fua < 0) {
> +               dev_warn(dev, "unable to guarantee persistence of writes\n");
> +               fua = 0;
> +       }
> +       wbc = nvdimm_has_cache(nd_region);
> +
> +       if (!devm_request_mem_region(dev, res->start, resource_size(res),
> +                               dev_name(&ndns->dev))) {
> +               dev_warn(dev, "could not reserve region %pR\n", res);
> +               return -EBUSY;
> +       }
> +
> +       if (use_dma) {
> +               chan = dma_find_channel(DMA_MEMCPY_SG);
> +               if (!chan) {
> +                       use_dma = 0;
> +                       dev_warn(dev, "Forced back to CPU, no DMA\n");
> +               } else {
> +               }
> +       }
> +
> +       pmem->tag_set.ops = &pmem_mq_ops;
> +       if (use_dma) {
> +               dma_cap_mask_t dma_mask;
> +               int node = 0, count;
> +
> +               dma_cap_zero(dma_mask);
> +               dma_cap_set(DMA_MEMCPY_SG, dma_mask);
> +               count = dma_get_channel_count(&dma_mask, pmem_dma_filter_fn,
> +                               (void *)(unsigned long)node);
> +               if (count)
> +                       pmem->tag_set.nr_hw_queues = count;
> +               else {
> +                       use_dma = 0;
> +                       pmem->tag_set.nr_hw_queues = num_online_cpus();
> +               }
> +       } else
> +               pmem->tag_set.nr_hw_queues = num_online_cpus();
> +
> +       dev_dbg(dev, "%d HW queues allocated\n", pmem->tag_set.nr_hw_queues);
> +
> +       pmem->tag_set.queue_depth = QUEUE_DEPTH;
> +       pmem->tag_set.numa_node = dev_to_node(dev);
> +
> +       if (use_dma) {
> +               pmem->tag_set.cmd_size = sizeof(struct pmem_cmd) +
> +                       sizeof(struct scatterlist) * SG_ALLOCATED;
> +       } else
> +               pmem->tag_set.cmd_size = sizeof(struct pmem_cmd);
> +
> +       pmem->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
> +       pmem->tag_set.driver_data = pmem;
> +
> +       rc = blk_mq_alloc_tag_set(&pmem->tag_set);
> +       if (rc < 0)
> +               return rc;
> +
> +       pmem->q = blk_mq_init_queue(&pmem->tag_set);
> +       if (IS_ERR(pmem->q)) {
> +               blk_mq_free_tag_set(&pmem->tag_set);
> +               return -ENOMEM;
> +       }
> +
> +       if (devm_add_action_or_reset(dev, pmem_release_queue, pmem)) {
> +               pmem_release_queue(pmem);
> +               return -ENOMEM;
> +       }
> +
> +       pmem->pfn_flags = PFN_DEV;
> +       if (is_nd_pfn(dev)) {
> +               addr = devm_memremap_pages(dev, &pfn_res,
> +                               &pmem->q->q_usage_counter, altmap);
> +               pfn_sb = nd_pfn->pfn_sb;
> +               pmem->data_offset = le64_to_cpu(pfn_sb->dataoff);
> +               pmem->pfn_pad = resource_size(res) - resource_size(&pfn_res);
> +               pmem->pfn_flags |= PFN_MAP;
> +               res = &pfn_res; /* for badblocks populate */
> +               res->start += pmem->data_offset;
> +       } else if (pmem_should_map_pages(dev)) {
> +               addr = devm_memremap_pages(dev, &nsio->res,
> +                               &pmem->q->q_usage_counter, NULL);
> +               pmem->pfn_flags |= PFN_MAP;
> +       } else
> +               addr = devm_memremap(dev, pmem->phys_addr,
> +                               pmem->size, ARCH_MEMREMAP_PMEM);
> +
> +       /*
> +        * At release time the queue must be frozen before
> +        * devm_memremap_pages is unwound
> +        */
> +       if (devm_add_action_or_reset(dev, pmem_freeze_queue, pmem->q))
> +               return -ENOMEM;
> +
> +       if (IS_ERR(addr))
> +               return PTR_ERR(addr);
> +       pmem->virt_addr = addr;
> +
> +       blk_queue_write_cache(pmem->q, wbc, fua);
> +       blk_queue_physical_block_size(pmem->q, PAGE_SIZE);
> +       blk_queue_logical_block_size(pmem->q, pmem_sector_size(ndns));
> +       if (use_dma) {
> +               u64 xfercap = dma_get_desc_xfercap(chan);
> +
> +               /* set it to some sane size if DMA driver didn't export */
> +               if (xfercap == 0)
> +                       xfercap = SZ_1M;
> +
> +               dev_dbg(dev, "xfercap: %#llx\n", xfercap);
> +               /* max xfer size is per_descriptor_cap * num_of_sg */
> +               blk_queue_max_hw_sectors(pmem->q,
> +                               SG_ALLOCATED * xfercap / 512);
> +               blk_queue_max_segments(pmem->q, SG_ALLOCATED);
> +       }
> +               blk_queue_max_hw_sectors(pmem->q, UINT_MAX);
> +       queue_flag_set_unlocked(QUEUE_FLAG_NONROT, pmem->q);
> +       queue_flag_set_unlocked(QUEUE_FLAG_DAX, pmem->q);
> +       pmem->q->queuedata = pmem;
> +
> +       disk = alloc_disk_node(0, nid);
> +       if (!disk)
> +               return -ENOMEM;
> +       pmem->disk = disk;
> +
> +       disk->fops              = &pmem_fops;
> +       disk->queue             = pmem->q;
> +       disk->flags             = GENHD_FL_EXT_DEVT;
> +       nvdimm_namespace_disk_name(ndns, disk->disk_name);
> +       set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
> +                       / 512);
> +       if (devm_init_badblocks(dev, &pmem->bb))
> +               return -ENOMEM;
> +       nvdimm_badblocks_populate(nd_region, &pmem->bb, res);
> +       disk->bb = &pmem->bb;
> +
> +       dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops);
> +       if (!dax_dev) {
> +               put_disk(disk);
> +               return -ENOMEM;
> +       }
> +       dax_write_cache(dax_dev, wbc);
> +       pmem->dax_dev = dax_dev;
> +
> +       gendev = disk_to_dev(disk);
> +       gendev->groups = pmem_attribute_groups;
> +
> +       device_add_disk(dev, disk);
> +       if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
> +               return -ENOMEM;
> +
> +       revalidate_disk(disk);
> +
> +       pmem->bb_state = sysfs_get_dirent(disk_to_dev(disk)->kobj.sd,
> +                                         "badblocks");
> +       if (!pmem->bb_state)
> +               dev_warn(dev, "'badblocks' notification disabled\n");
> +
> +       return 0;
> +}

This routine is mostly a copy paste from the original pmem version,
can we refactor this into some common helpers and duplicate less code?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
