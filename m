Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 586FA224CCC2E
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 11:38:34 -0700 (PDT)
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-2-logang@deltatee.com>
 <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
 <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
 <52cbbbc4-c488-f83f-8d02-14d455b4efd7@codeaurora.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <3e738f95-d73c-4182-2fa1-8664aafb1ab7@deltatee.com>
Date: Tue, 13 Mar 2018 12:44:34 -0600
MIME-Version: 1.0
In-Reply-To: <52cbbbc4-c488-f83f-8d02-14d455b4efd7@codeaurora.org>
Content-Language: en-US
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
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
To: Sinan Kaya <okaya@codeaurora.org>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 13/03/18 11:49 AM, Sinan Kaya wrote:
>> And there's also the ACS problem which means if you want to use P2P on the root ports you'll have to disable ACS on the entire system. (Or preferably, the IOMMU groups need to get more sophisticated to allow for dynamic changes).
>>
> 
> Do you think you can keep a pointer to the parent bridge instead of querying it
> via get_upstream_bridge_port() here so that we can reuse your
> pci_p2pdma_disable_acs() in the future.

Keep a pointer where? pci_p2pdma_disable_acs() and 
pci_p2pdma_add_client() are used in completely different cases on 
completely different devices. There really is no overlap and no obvious 
place to store the port pointer (except in the struct pci_dev itself, in 
which case why not just call the function again).

> +int pci_p2pdma_disable_acs(struct pci_dev *pdev)
> +{
> +	struct pci_dev *up;
> +	int pos;
> +	u16 ctrl;
> +
> +	up = get_upstream_bridge_port(pdev);
> +	if (!up)
> +		return 0;
> 
> Some future device would only deal with pci_p2pdma_add_client(() for whitelisting
> instead of changing all of your code.

That's a problem for whoever writes the future code.

> We should at least limit the usage of get_upstream_bridge_port() family of functions
> to probe time only.

Why?

> We can tell iommu to do one to one translation by passing iommu.passthrough=1 to kernel
> command line to have identical behavior to your switch case.

Well, someone will need to write code for all available IOMMUs to 
support this. That's a very big project.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
