Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 42BA721BC6A24
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 11:49:05 -0700 (PDT)
Subject: Re: [RFC 1/8] Introduce Peer-to-Peer memory (p2pmem) device
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-2-git-send-email-logang@deltatee.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <cb102386-0314-a3a3-ed44-b42debdf1512@codeaurora.org>
Date: Fri, 31 Mar 2017 14:49:01 -0400
MIME-Version: 1.0
In-Reply-To: <1490911959-5146-2-git-send-email-logang@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Logan,

> +/**
> + * p2pmem_unregister() - unregister a p2pmem device
> + * @p: the device to unregister
> + *
> + * The device will remain until all users are done with it
> + */
> +void p2pmem_unregister(struct p2pmem_dev *p)
> +{
> +	if (!p)
> +		return;
> +
> +	dev_info(&p->dev, "unregistered");
> +	device_del(&p->dev);
> +	ida_simple_remove(&p2pmem_ida, p->id);

Don't you need to clean up the p->pool here.

> +	put_device(&p->dev);
> +}
> +EXPORT_SYMBOL(p2pmem_unregister);
> +

I don't like the ugliness around the switch port to be honest. 

Going to whitelist/blacklist looks simpler in my opinion.

Sinan


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
