Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1B4702095B9C9
 for <linux-nvdimm@lists.01.org>; Wed, 23 Aug 2017 12:53:32 -0700 (PDT)
Subject: Re: [PATCH v5 7/7] libnvdimm: Add blk-mq pmem driver
References: <150333903164.55214.3813479680626005389.stgit@djiang5-desk3.ch.intel.com>
 <150334987495.55214.5621513659334023484.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4h5wm3C8BhQQpA8vZ3SCrcunLCW-rgrq6QCUHX74YJpgQ@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <cc37e79b-904e-a8a3-faae-28887ed28b0f@intel.com>
Date: Wed, 23 Aug 2017 12:56:04 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h5wm3C8BhQQpA8vZ3SCrcunLCW-rgrq6QCUHX74YJpgQ@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Koul, Vinod  <vinod.koul@intel.com>, Christoph Hellwig <hch@infradead.org>, dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



On 08/23/2017 11:39 AM, Dan Williams wrote:
> On Mon, Aug 21, 2017 at 2:11 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>> Adding a DMA supported blk-mq driver for pmem.
> 
> "Add support for offloading pmem block-device I/O operations to a DMA engine."
> 
>> This provides signficant CPU
> 
> *significant
> 
>> utilization reduction.
> 
> "at the cost of some increased latency and bandwidth reduction in some cases."
> 
>> By default the pmem driver will be using blk-mq with
> 
> "By default the current cpu-copy based pmem driver will load, but this
> driver can be manually selected with a modprobe configuration."
> 
>> DMA through the dmaengine API. DMA can be turned off with use_dma=0 kernel
>> parameter.
> 
> Do we need the module option? It seems for debug / testing a user can
> simply unload the ioatdma driver, otherwise we should use dma by
> default.
> 
>> Additional kernel parameters are provided:
>>
>> queue_depth: The queue depth for blk-mq. Typically in relation to what the
>>              DMA engine can provide per queue/channel. This needs to take
>>              into account of num_sg as well for some DMA engines. i.e.
>>              num_sg * queue_depth < total descriptors available per queue or
>>              channel.
>>
>> q_per_node: Hardware queues per node. Typically the number of channels the
>>             DMA engine can provide per socket.
>> num_sg: Number of scatterlist we can handle per I/O request.
> 
> Why do these need to be configurable?

The concern is with other arch/platforms that have different DMA
engines. The configurations would be platform dependent.

> 
>>
>> Numbers below are measured against pmem simulated via DRAM using
>> memmap=NN!SS.  DMA engine used is the ioatdma on Intel Skylake Xeon
>> platform.  Keep in mind the performance for persistent memory
>> will differ.
>> Fio 2.21 was used.
>>
>> 64k: 1 task queuedepth=1
>> CPU Read:  7631 MB/s  99.7% CPU    DMA Read: 2415 MB/s  54% CPU
>> CPU Write: 3552 MB/s  100% CPU     DMA Write 2173 MB/s  54% CPU
>>
>> 64k: 16 tasks queuedepth=16
>> CPU Read: 36800 MB/s  1593% CPU    DMA Read:  29100 MB/s  607% CPU
>> CPU Write 20900 MB/s  1589% CPU    DMA Write: 23400 MB/s  585% CPU
>>
>> 2M: 1 task queuedepth=1
>> CPU Read:  6013 MB/s  99.3% CPU    DMA Read:  7986 MB/s  59.3% CPU
>> CPU Write: 3579 MB/s  100% CPU     DMA Write: 5211 MB/s  58.3% CPU
>>
>> 2M: 16 tasks queuedepth=16
>> CPU Read:  18100 MB/s 1588% CPU    DMA Read:  21300 MB/s 180.9% CPU
>> CPU Write: 14100 MB/s 1594% CPU    DMA Write: 20400 MB/s 446.9% CPU
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  drivers/nvdimm/Kconfig   |   23 +
>>  drivers/nvdimm/Makefile  |    3
>>  drivers/nvdimm/pmem.h    |    3
>>  drivers/nvdimm/pmem_mq.c |  853 ++++++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 882 insertions(+)
>>  create mode 100644 drivers/nvdimm/pmem_mq.c
>>
>> diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
>> index 5bdd499..c88c2bb 100644
>> --- a/drivers/nvdimm/Kconfig
>> +++ b/drivers/nvdimm/Kconfig
>> @@ -36,6 +36,29 @@ config BLK_DEV_PMEM
>>
>>           Say Y if you want to use an NVDIMM
>>
>> +config BLK_DEV_PMEM_MQ
> 
> Lets call the driver pmem_dma instead of pmem_mq, the "mq" is just a
> side effect of enabling dma support.
> 
>> +       tristate "PMEM: Persistent memory block device multi-queue support"
>> +       depends on m
> 
> Not sure what the exact kconfig syntax should be, but the policy I'm
> looking for is that this driver should be allowed to be built-in if
> the pmem driver is disabled.
> 
>> +       default LIBNVDIMM
>> +       select DAX
>> +       select ND_BTT if BTT
>> +       select ND_PFN if NVDIMM_PFN
> 
> I think these should probably move to a common symbol used by both
> pmem and pmem_dma.
> 
>> +       select DMA_ENGINE
> 
> Shouldn't this be "depends on"?
> 
>> +       help
>> +         Memory ranges for PMEM are described by either an NFIT
>> +         (NVDIMM Firmware Interface Table, see CONFIG_NFIT_ACPI), a
>> +         non-standard OEM-specific E820 memory type (type-12, see
>> +         CONFIG_X86_PMEM_LEGACY), or it is manually specified by the
>> +         'memmap=nn[KMG]!ss[KMG]' kernel command line (see
>> +         Documentation/admin-guide/kernel-parameters.rst).  This driver
>> +         converts these persistent memory ranges into block devices that are
>> +         capable of DAX (direct-access) file system mappings.  See
>> +         Documentation/nvdimm/nvdimm.txt for more details. This driver
>> +         utilizes block layer multi-queue in order to support using DMA
>> +         engines to help offload the data copying.
> 
> Rather than duplicating some of the pmem text I think this help text
> should only talk about the incremental differences relative to the
> base pmem driver.
> 
>> +
>> +         Say Y if you want to use an NVDIMM
>> +
>>  config ND_BLK
>>         tristate "BLK: Block data window (aperture) device support"
>>         default LIBNVDIMM
>> diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
>> index 909554c..8bfd107 100644
>> --- a/drivers/nvdimm/Makefile
>> +++ b/drivers/nvdimm/Makefile
>> @@ -1,11 +1,14 @@
>>  obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
>>  obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
>> +obj-$(CONFIG_BLK_DEV_PMEM_MQ) += nd_pmem_mq.o
>>  obj-$(CONFIG_ND_BTT) += nd_btt.o
>>  obj-$(CONFIG_ND_BLK) += nd_blk.o
>>  obj-$(CONFIG_X86_PMEM_LEGACY) += nd_e820.o
>>
>>  nd_pmem-y := pmem.o
>>
>> +nd_pmem_mq-y := pmem_mq.o
>> +
> 
> s/mq/dma/
> 
> I also think it's okay to drop the nd_ prefix for this.
> 
>>  nd_btt-y := btt.o
>>
>>  nd_blk-y := blk.o
>> diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
>> index 5434321..bbbe982 100644
>> --- a/drivers/nvdimm/pmem.h
>> +++ b/drivers/nvdimm/pmem.h
>> @@ -4,6 +4,7 @@
>>  #include <linux/types.h>
>>  #include <linux/pfn_t.h>
>>  #include <linux/fs.h>
>> +#include <linux/blk-mq.h>
>>
>>  #ifdef CONFIG_ARCH_HAS_PMEM_API
>>  #define ARCH_MEMREMAP_PMEM MEMREMAP_WB
>> @@ -35,6 +36,8 @@ struct pmem_device {
>>         struct badblocks        bb;
>>         struct dax_device       *dax_dev;
>>         struct gendisk          *disk;
>> +       struct blk_mq_tag_set   tag_set;
>> +       struct request_queue    *q;
>>  };
>>
>>  long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>> diff --git a/drivers/nvdimm/pmem_mq.c b/drivers/nvdimm/pmem_mq.c
>> new file mode 100644
>> index 0000000..db2fc2a
>> --- /dev/null
>> +++ b/drivers/nvdimm/pmem_mq.c
> 
> [snip bulk of driver code]
> 
> Rather than copy-paste most of the existing pmem driver let's refactor
> all the common bits into a pmem-core module.
> 
>> +MODULE_AUTHOR("Dave Jiang <dave.jiang@intel.com>");
> 
> Drop this MODULE_AUTHOR(), I think this is better handled with a
> MAINTAINERS entry.
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
