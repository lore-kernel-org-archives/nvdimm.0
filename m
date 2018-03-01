Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E41D224E691B
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 11:30:44 -0800 (PST)
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-4-logang@deltatee.com>
 <20180301174941.GG13722@bhelgaas-glaptop.roam.corp.google.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <731c648d-5af3-1d5c-7169-07df12b79a41@deltatee.com>
Date: Thu, 1 Mar 2018 12:36:43 -0700
MIME-Version: 1.0
In-Reply-To: <20180301174941.GG13722@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Add PCI p2pmem dma mappings to
 adjust the bus offset
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
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 01/03/18 10:49 AM, Bjorn Helgaas wrote:
>> +int pci_p2pdma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
>> +		      enum dma_data_direction dir)
> 
> Same question as before about why the mixture of "pci_*" interfaces
> that take "struct device *" parameters.

In this case, per the discussion in v1, it was felt the _map_sg() 
function should take the same arguments as dma_map_sg().

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
