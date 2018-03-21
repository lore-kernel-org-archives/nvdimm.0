Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 03724225E964E
 for <linux-nvdimm@lists.01.org>; Wed, 21 Mar 2018 02:20:32 -0700 (PDT)
Date: Wed, 21 Mar 2018 10:27:02 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 11/11] nvmet: Optionally use PCI P2P memory
Message-ID: <20180321092702.GC7098@lst.de>
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-12-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180312193525.2855-12-logang@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

> +				  const char *page, size_t count)
> +{
> +	struct nvmet_port *port = to_nvmet_port(item);
> +	struct device *dev;
> +	struct pci_dev *p2p_dev = NULL;
> +	bool use_p2pmem;
> +
> +	switch (page[0]) {
> +	case 'y':
> +	case 'Y':
> +	case 'a':
> +	case 'A':
> +		use_p2pmem = true;
> +		break;
> +	case 'n':
> +	case 'N':
> +		use_p2pmem = false;
> +		break;
> +	default:
> +		dev = bus_find_device_by_name(&pci_bus_type, NULL, page);
> +		if (!dev) {
> +			pr_err("No such PCI device: %s\n", page);
> +			return -ENODEV;
> +		}
> +
> +		use_p2pmem = true;
> +		p2p_dev = to_pci_dev(dev);
> +
> +		if (!pci_has_p2pmem(p2p_dev)) {
> +			pr_err("PCI device has no peer-to-peer memory: %s\n",
> +			       page);
> +			pci_dev_put(p2p_dev);
> +			return -ENODEV;
> +		}
> +	}

Yikes.  Shouldn't auto just be the normal yes case instead of this
string parsing mess?

> +	if (rsp->req.sg != &rsp->cmd->inline_sg) {
> +		if (rsp->req.p2p_dev)
> +			pci_p2pmem_free_sgl(rsp->req.p2p_dev, rsp->req.sg,
> +					    rsp->req.sg_cnt);
> +		else
> +			sgl_free(rsp->req.sg);
> +	}

Can we factor this into a helper, as the other target drivers (fc for now,
tcp soon) using sgl allocatins should share the code?

(same for the alloc side)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
