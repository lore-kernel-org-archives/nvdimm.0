Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D07CB21B02822
 for <linux-nvdimm@lists.01.org>; Tue,  4 Sep 2018 08:47:36 -0700 (PDT)
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-11-logang@deltatee.com>
 <20180904151638.GL335@mellanox.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <d5548f5d-59df-f38e-255d-59b46a17a219@deltatee.com>
Date: Tue, 4 Sep 2018 09:47:07 -0600
MIME-Version: 1.0
In-Reply-To: <20180904151638.GL335@mellanox.com>
Content-Language: en-US
Subject: Re: [PATCH v5 10/13] nvme-pci: Add support for P2P memory in requests
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
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 04/09/18 09:16 AM, Jason Gunthorpe wrote:
>>  	if (iod->nents) {
>> -		dma_unmap_sg(dev->dev, iod->sg, iod->nents, dma_dir);
>> +		/* P2PDMA requests do not need to be unmapped */
>> +		if (!is_pci_p2pdma_page(sg_page(iod->sg)))
>> +			dma_unmap_sg(dev->dev, iod->sg, iod->nents, dma_dir);
> 
> This seems like a poor direction, if we add IOMMU hairpin support we
> will need unmapping.

It can always be added later. In any case, you'll have to convince
Christoph who requested the change; I'm not that invested in this decision.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
