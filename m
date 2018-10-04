Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw1-f68.google.com (mail-yw1-f68.google.com
 [209.85.161.68])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B154121A00AE6
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 15:21:00 -0700 (PDT)
Received: by mail-yw1-f68.google.com with SMTP id v198-v6so4450023ywg.12
 for <linux-nvdimm@lists.01.org>; Thu, 04 Oct 2018 15:21:00 -0700 (PDT)
Subject: Re: [PATCH v9 13/13] nvmet: Optionally use PCI P2P memory
References: <20181004212747.6301-1-logang@deltatee.com>
 <20181004212747.6301-14-logang@deltatee.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <a3af4bda-0b73-c964-c7d6-5d59f0710768@grimberg.me>
Date: Thu, 4 Oct 2018 15:20:55 -0700
MIME-Version: 1.0
In-Reply-To: <20181004212747.6301-14-logang@deltatee.com>
Content-Language: en-US
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
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Steve Wise <swise@opengridcomputing.com>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>


> diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
> index e7b7406c4e22..4333e2c5b4f5 100644
> --- a/drivers/nvme/target/nvmet.h
> +++ b/drivers/nvme/target/nvmet.h
> @@ -26,6 +26,7 @@
>   #include <linux/configfs.h>
>   #include <linux/rcupdate.h>
>   #include <linux/blkdev.h>
> +#include <linux/radix-tree.h>
>   
>   #define NVMET_ASYNC_EVENTS		4
>   #define NVMET_ERROR_LOG_SLOTS		128
> @@ -77,6 +78,9 @@ struct nvmet_ns {
>   	struct completion	disable_done;
>   	mempool_t		*bvec_pool;
>   	struct kmem_cache	*bvec_cache;
> +
> +	int			use_p2pmem;
> +	struct pci_dev		*p2p_dev;
>   };
>   
>   static inline struct nvmet_ns *to_nvmet_ns(struct config_item *item)
> @@ -84,6 +88,11 @@ static inline struct nvmet_ns *to_nvmet_ns(struct config_item *item)
>   	return container_of(to_config_group(item), struct nvmet_ns, group);
>   }
>   
> +static inline struct device *nvmet_ns_dev(struct nvmet_ns *ns)
> +{
> +	return disk_to_dev(ns->bdev->bd_disk);
> +}

This needs to handle non bdev namespaces.

> +
>   struct nvmet_cq {
>   	u16			qid;
>   	u16			size;
> @@ -184,6 +193,9 @@ struct nvmet_ctrl {
>   
>   	char			subsysnqn[NVMF_NQN_FIELD_LEN];
>   	char			hostnqn[NVMF_NQN_FIELD_LEN];
> +
> +	struct device *p2p_client;
> +	struct radix_tree_root p2p_ns_map;
>   };
>   
>   struct nvmet_subsys {
> @@ -294,6 +306,9 @@ struct nvmet_req {
>   
>   	void (*execute)(struct nvmet_req *req);
>   	const struct nvmet_fabrics_ops *ops;
> +
> +	struct pci_dev *p2p_dev;
> +	struct device *p2p_client;
>   };
>   
>   extern struct workqueue_struct *buffered_io_wq;
> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index 9e091e78a2f0..3f7971d3706d 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -749,6 +749,8 @@ static void nvmet_rdma_handle_command(struct nvmet_rdma_queue *queue,
>   		cmd->send_sge.addr, cmd->send_sge.length,
>   		DMA_TO_DEVICE);
>   
> +	cmd->req.p2p_client = &queue->dev->device->dev;
> +
>   	if (!nvmet_req_init(&cmd->req, &queue->nvme_cq,
>   			&queue->nvme_sq, &nvmet_rdma_ops))
>   		return;

And this?
--
diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index ef286b72d958..3d12f5f4568d 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -2280,6 +2280,7 @@ nvmet_fc_handle_fcp_rqst(struct nvmet_fc_tgtport 
*tgtport,
         fod->req.cmd = &fod->cmdiubuf.sqe;
         fod->req.rsp = &fod->rspiubuf.cqe;
         fod->req.port = tgtport->pe->port;
+       fod->req.p2p_client = tgtport->dev;

         /* clear any response payload */
         memset(&fod->rspiubuf, 0, sizeof(fod->rspiubuf));
--

Other than that this looks good!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
