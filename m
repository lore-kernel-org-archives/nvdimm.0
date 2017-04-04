Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-f196.google.com (mail-wr0-f196.google.com
 [209.85.128.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 503AF2193930E
 for <linux-nvdimm@lists.01.org>; Tue,  4 Apr 2017 03:40:22 -0700 (PDT)
Received: by mail-wr0-f196.google.com with SMTP id t20so2689422wra.2
 for <linux-nvdimm@lists.01.org>; Tue, 04 Apr 2017 03:40:22 -0700 (PDT)
Subject: Re: [RFC 3/8] nvmet: Use p2pmem in nvme target
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-4-git-send-email-logang@deltatee.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <bce6b009-7756-3cf7-5053-2628b26c8d97@grimberg.me>
Date: Tue, 4 Apr 2017 13:40:16 +0300
MIME-Version: 1.0
In-Reply-To: <1490911959-5146-4-git-send-email-logang@deltatee.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Logan Gunthorpe <logang@deltatee.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

Hey Logan,

> We create a configfs attribute in each nvme-fabrics target port to
> enable p2p memory use. When enabled, the port will only then use the
> p2p memory if a p2p memory device can be found which is behind the
> same switch as the RDMA port and all the block devices in use. If
> the user enabled it an no devices are found, then the system will
> silently fall back on using regular memory.

What should we do if we have more than a single device that satisfies
this? I'd say that it would be better to have the user ask for a
specific device and fail it if it doesn't meet the above conditions...

> If appropriate, that port will allocate memory for the RDMA buffers
> for queues from the p2pmem device falling back to system memory should
> anything fail.

That's good :)

> Ideally, we'd want to use an NVME CMB buffer as p2p memory. This would
> save an extra PCI transfer as the NVME card could just take the data
> out of it's own memory. However, at this time, cards with CMB buffers
> don't seem to be available.

Even if it was available, it would be hard to make real use of this
given that we wouldn't know how to pre-post recv buffers (for in-capsule
data). But let's leave this out of the scope entirely...

> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index ecc4fe8..7fd4840 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -23,6 +23,7 @@
>  #include <linux/string.h>
>  #include <linux/wait.h>
>  #include <linux/inet.h>
> +#include <linux/p2pmem.h>
>  #include <asm/unaligned.h>
>
>  #include <rdma/ib_verbs.h>
> @@ -64,6 +65,7 @@ struct nvmet_rdma_rsp {
>  	struct rdma_rw_ctx	rw;
>
>  	struct nvmet_req	req;
> +	struct p2pmem_dev       *p2pmem;

Why do you need this? you have a reference to the
queue itself.

> @@ -107,6 +109,8 @@ struct nvmet_rdma_queue {
>  	int			send_queue_size;
>
>  	struct list_head	queue_list;
> +
> +	struct p2pmem_dev	*p2pmem;
>  };
>
>  struct nvmet_rdma_device {
> @@ -185,7 +189,8 @@ nvmet_rdma_put_rsp(struct nvmet_rdma_rsp *rsp)
>  	spin_unlock_irqrestore(&rsp->queue->rsps_lock, flags);
>  }
>
> -static void nvmet_rdma_free_sgl(struct scatterlist *sgl, unsigned int nents)
> +static void nvmet_rdma_free_sgl(struct scatterlist *sgl, unsigned int nents,
> +				struct p2pmem_dev *p2pmem)
>  {
>  	struct scatterlist *sg;
>  	int count;
> @@ -193,13 +198,17 @@ static void nvmet_rdma_free_sgl(struct scatterlist *sgl, unsigned int nents)
>  	if (!sgl || !nents)
>  		return;
>
> -	for_each_sg(sgl, sg, nents, count)
> -		__free_page(sg_page(sg));
> +	for_each_sg(sgl, sg, nents, count) {
> +		if (p2pmem)
> +			p2pmem_free_page(p2pmem, sg_page(sg));
> +		else
> +			__free_page(sg_page(sg));
> +	}
>  	kfree(sgl);
>  }
>
>  static int nvmet_rdma_alloc_sgl(struct scatterlist **sgl, unsigned int *nents,
> -		u32 length)
> +		u32 length, struct p2pmem_dev *p2pmem)
>  {
>  	struct scatterlist *sg;
>  	struct page *page;
> @@ -216,7 +225,11 @@ static int nvmet_rdma_alloc_sgl(struct scatterlist **sgl, unsigned int *nents,
>  	while (length) {
>  		u32 page_len = min_t(u32, length, PAGE_SIZE);
>
> -		page = alloc_page(GFP_KERNEL);
> +		if (p2pmem)
> +			page = p2pmem_alloc_page(p2pmem);
> +		else
> +			page = alloc_page(GFP_KERNEL);
> +
>  		if (!page)
>  			goto out_free_pages;
>
> @@ -231,7 +244,10 @@ static int nvmet_rdma_alloc_sgl(struct scatterlist **sgl, unsigned int *nents,
>  out_free_pages:
>  	while (i > 0) {
>  		i--;
> -		__free_page(sg_page(&sg[i]));
> +		if (p2pmem)
> +			p2pmem_free_page(p2pmem, sg_page(&sg[i]));
> +		else
> +			__free_page(sg_page(&sg[i]));
>  	}
>  	kfree(sg);
>  out:
> @@ -484,7 +500,8 @@ static void nvmet_rdma_release_rsp(struct nvmet_rdma_rsp *rsp)
>  	}
>
>  	if (rsp->req.sg != &rsp->cmd->inline_sg)
> -		nvmet_rdma_free_sgl(rsp->req.sg, rsp->req.sg_cnt);
> +		nvmet_rdma_free_sgl(rsp->req.sg, rsp->req.sg_cnt,
> +				    rsp->p2pmem);
>
>  	if (unlikely(!list_empty_careful(&queue->rsp_wr_wait_list)))
>  		nvmet_rdma_process_wr_wait_list(queue);
> @@ -625,8 +642,16 @@ static u16 nvmet_rdma_map_sgl_keyed(struct nvmet_rdma_rsp *rsp,
>  	if (!len)
>  		return 0;
>
> +	rsp->p2pmem = rsp->queue->p2pmem;
>  	status = nvmet_rdma_alloc_sgl(&rsp->req.sg, &rsp->req.sg_cnt,
> -			len);
> +			len, rsp->p2pmem);
> +
> +	if (status && rsp->p2pmem) {
> +		rsp->p2pmem = NULL;
> +		status = nvmet_rdma_alloc_sgl(&rsp->req.sg, &rsp->req.sg_cnt,
> +					      len, rsp->p2pmem);
> +	}
> +

Not sure its a good practice to rely on rsp->p2pmem not being NULL...
Would be nice if the allocation routines can hide it from us...

>  	if (status)
>  		return status;
>
> @@ -984,6 +1009,7 @@ static void nvmet_rdma_free_queue(struct nvmet_rdma_queue *queue)
>  				!queue->host_qid);
>  	}
>  	nvmet_rdma_free_rsps(queue);
> +	p2pmem_put(queue->p2pmem);

What does this pair with? p2pmem_find_compat()?

>  	ida_simple_remove(&nvmet_rdma_queue_ida, queue->idx);
>  	kfree(queue);
>  }
> @@ -1179,6 +1205,52 @@ static int nvmet_rdma_cm_accept(struct rdma_cm_id *cm_id,
>  	return ret;
>  }
>
> +/*
> + * If allow_p2pmem is set, we will try to use P2P memory for our
> + * sgl lists. This requires the p2pmem device to be compatible with
> + * the backing device for every namespace this device will support.
> + * If not, we fall back on using system memory.
> + */
> +static void nvmet_rdma_queue_setup_p2pmem(struct nvmet_rdma_queue *queue)
> +{
> +	struct device **dma_devs;
> +	struct nvmet_ns *ns;
> +	int ndevs = 1;
> +	int i = 0;
> +	struct nvmet_subsys_link *s;
> +
> +	if (!queue->port->allow_p2pmem)
> +		return;
> +
> +	list_for_each_entry(s, &queue->port->subsystems, entry) {
> +		list_for_each_entry_rcu(ns, &s->subsys->namespaces, dev_link) {
> +			ndevs++;
> +		}
> +	}

This code has no business in nvmet-rdma. Why not keep nr_ns in
nvmet_subsys in the first place?

> +
> +	dma_devs = kmalloc((ndevs + 1) * sizeof(*dma_devs), GFP_KERNEL);
> +	if (!dma_devs)
> +		return;
> +
> +	dma_devs[i++] = &queue->dev->device->dev;
> +
> +	list_for_each_entry(s, &queue->port->subsystems, entry) {
> +		list_for_each_entry_rcu(ns, &s->subsys->namespaces, dev_link) {
> +			dma_devs[i++] = disk_to_dev(ns->bdev->bd_disk);
> +		}
> +	}
> +
> +	dma_devs[i++] = NULL;
> +
> +	queue->p2pmem = p2pmem_find_compat(dma_devs);

This is a problem. namespaces can be added at any point in time. No one
guarantee that dma_devs are all the namepaces we'll ever see.

> +
> +	if (queue->p2pmem)
> +		pr_debug("using %s for rdma nvme target queue",
> +			 dev_name(&queue->p2pmem->dev));
> +
> +	kfree(dma_devs);
> +}
> +
>  static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
>  		struct rdma_cm_event *event)
>  {
> @@ -1199,6 +1271,8 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
>  	}
>  	queue->port = cm_id->context;
>
> +	nvmet_rdma_queue_setup_p2pmem(queue);
> +

Why is all this done for each queue? looks completely redundant to me.

>  	ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
>  	if (ret)
>  		goto release_queue;

You seemed to skip the in-capsule buffers for p2pmem (inline_page), I'm
curious why?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
