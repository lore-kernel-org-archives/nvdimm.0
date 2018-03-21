Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA21522568636
 for <linux-nvdimm@lists.01.org>; Wed, 21 Mar 2018 09:46:23 -0700 (PDT)
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-12-logang@deltatee.com> <20180321092702.GC7098@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <a75f5bce-8ab5-7d99-bb27-908d0cc7c6f6@deltatee.com>
Date: Wed, 21 Mar 2018 10:52:25 -0600
MIME-Version: 1.0
In-Reply-To: <20180321092702.GC7098@lst.de>
Content-Language: en-US
Subject: Re: [PATCH v3 11/11] nvmet: Optionally use PCI P2P memory
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>
List-ID: <linux-nvdimm@lists.01.org>



On 21/03/18 03:27 AM, Christoph Hellwig wrote:
>> +				  const char *page, size_t count)
>> +{
>> +	struct nvmet_port *port = to_nvmet_port(item);
>> +	struct device *dev;
>> +	struct pci_dev *p2p_dev = NULL;
>> +	bool use_p2pmem;
>> +
>> +	switch (page[0]) {
>> +	case 'y':
>> +	case 'Y':
>> +	case 'a':
>> +	case 'A':
>> +		use_p2pmem = true;
>> +		break;
>> +	case 'n':
>> +	case 'N':
>> +		use_p2pmem = false;
>> +		break;
>> +	default:
>> +		dev = bus_find_device_by_name(&pci_bus_type, NULL, page);
>> +		if (!dev) {
>> +			pr_err("No such PCI device: %s\n", page);
>> +			return -ENODEV;
>> +		}
>> +
>> +		use_p2pmem = true;
>> +		p2p_dev = to_pci_dev(dev);
>> +
>> +		if (!pci_has_p2pmem(p2p_dev)) {
>> +			pr_err("PCI device has no peer-to-peer memory: %s\n",
>> +			       page);
>> +			pci_dev_put(p2p_dev);
>> +			return -ENODEV;
>> +		}
>> +	}
> 
> Yikes.  Shouldn't auto just be the normal yes case instead of this
> string parsing mess?

Sorry, I don't follow. The code, as is, should automatically select the
device if the user  sets it to "yes" or "auto" or "y" or similar.
(Roughly similar to how kstrtobool() works, except '0' or '1' are not
accepted seeing they could overlap with PCI device names). In other
cases, it looks for the specific PCI device name to use exactly.

Are you saying it shouldn't work this way or are you saying the code to
implement it is too messy?

>> +	if (rsp->req.sg != &rsp->cmd->inline_sg) {
>> +		if (rsp->req.p2p_dev)
>> +			pci_p2pmem_free_sgl(rsp->req.p2p_dev, rsp->req.sg,
>> +					    rsp->req.sg_cnt);
>> +		else
>> +			sgl_free(rsp->req.sg);
>> +	}
> 
> Can we factor this into a helper, as the other target drivers (fc for now,
> tcp soon) using sgl allocatins should share the code?
> 
> (same for the alloc side)

Sure. Would the helpers belong in core.c?

Thanks,

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
