Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D40D421E1DAFA
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 13:18:28 -0700 (PDT)
Date: Thu, 3 Aug 2017 14:20:40 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 5/5] libnvdimm: add DMA support for pmem blk-mq
Message-ID: <20170803202039.GB18341@linux.intel.com>
References: <150169902310.59677.18062301799811367806.stgit@djiang5-desk3.ch.intel.com>
 <150169928551.59677.14690799553760064519.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150169928551.59677.14690799553760064519.stgit@djiang5-desk3.ch.intel.com>
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
Cc: vinod.koul@intel.com, dmaengine@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 02, 2017 at 11:41:25AM -0700, Dave Jiang wrote:
> Adding DMA support for pmem blk reads. This provides signficant CPU
> reduction with large memory reads with good performance. DMAs are triggered
> with test against bio_multiple_segment(), so the small I/Os (4k or less?)
> are still performed by the CPU in order to reduce latency. By default
> the pmem driver will be using blk-mq with DMA.
> 
> Numbers below are measured against pmem simulated via DRAM using
> memmap=NN!SS.  DMA engine used is the ioatdma on Intel Skylake Xeon
> platform.  Keep in mind the performance for actual persistent memory
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
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

<>

> +static int pmem_handle_cmd_dma(struct pmem_cmd *cmd, bool is_write)
> +{
...
> +err_set_unmap:
> +	dmaengine_unmap_put(unmap);
> +err_unmap_buffer:
> +	dma_unmap_page(dev, dma_addr, len, dir);
> +err_unmap_sg:
> +	if (dir == DMA_TO_DEVICE)
> +		dir = DMA_FROM_DEVICE;
> +	else
> +		dir = DMA_TO_DEVICE;
> +	dma_unmap_sg(dev, cmd->sg, cmd->sg_nents, dir);
> +	dmaengine_unmap_put(unmap);
> +err:
> +	blk_mq_end_request(cmd->rq, -ENXIO);

Should this be:

	blk_mq_end_request(cmd->rq, rc);

?

Otherwise:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> +	return rc;
> +}
> +
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
