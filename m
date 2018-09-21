Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB039211546E6
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 11:13:36 -0700 (PDT)
References: <20180913001156.4115-1-logang@deltatee.com>
 <20180913001156.4115-4-logang@deltatee.com>
 <20180921131550.GG224714@bhelgaas-glaptop.roam.corp.google.com>
 <20180921164813.GJ224714@bhelgaas-glaptop.roam.corp.google.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <506dd00c-35e9-e285-bc97-c689c766b4cf@deltatee.com>
Date: Fri, 21 Sep 2018 12:13:21 -0600
MIME-Version: 1.0
In-Reply-To: <20180921164813.GJ224714@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Subject: Re: [PATCH v6 03/13] PCI/P2PDMA: Add PCI p2pmem DMA mappings to
 adjust the bus offset
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
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

On 2018-09-21 10:48 AM, Bjorn Helgaas wrote:
>> I think the use of "map" in this context is slightly confusing because the
>> general expectation is that map/unmap must be balanced.

Yeah, Jason said the same thing, but having an empty unmap function
seems wasteful and Christoph said to just remove it. My opinion is that
it's not that big an issue one way or another -- if we have to add an
unmap later it's not really that hard.

>> If you keep "map", maybe add a sentence or two about why there's no
>> corresponding unmap?

Will do.

> Another wrinkle is that "map" usually takes an A and gives you back a
> B.  Now the caller has both A and B and both are still valid.
> Here we pass in an SGL and the SGL is transformed, so the caller only
> has B and A has been destroyed, i.e., the SGL can no longer be used as
> it was before, and there's no way to get A back.

I wouldn't say that. Our map_sg function is doing the same thing
dma_map_sg is: it sets the DMA address and length in the scatter list.
So B is still A just with other fields set. If the caller wanted to map
this SG in a different way they can still do so and the new DMA
address/length would override the old values. (Normally, you'd want to
unmap before doing something like that, but seeing our unmap is an empty
operation, we wouldn't have to do that.)

Logan


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
