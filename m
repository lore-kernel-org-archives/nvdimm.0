Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A15BD21165245
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 16:03:58 -0700 (PDT)
References: <20181004212747.6301-1-logang@deltatee.com>
 <20181010201918.GF5906@bhelgaas-glaptop.roam.corp.google.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <5c674a1b-2471-33eb-44f4-fe1bb8807a22@deltatee.com>
Date: Wed, 10 Oct 2018 17:03:33 -0600
MIME-Version: 1.0
In-Reply-To: <20181010201918.GF5906@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-CA
Subject: Re: [PATCH v9 00/13] Copy Offload in NVMe Fabrics with P2P PCI Memory
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
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 2018-10-10 2:19 p.m., Bjorn Helgaas wrote:
> I added the reviewed-by tags from Christoph, Jens' ack on the blkdev.h
> change, and applied these to pci/peer-to-peer with the intent of
> merging these for v4.20.
> 
> I gave up on waiting for an ack for the memremap.h and mm.h changes.
> 
> I dropped the "nvme-pci: Add a quirk for a pseudo CMB" quirk because
> of Christoph's objection.  After this is all merged, I won't need to
> be involved, and you and the NVMe folks can hash that out.
> 
> If there are updates to "nvmet: Optionally use PCI P2P memory" based
> on Sagi's comments, send an incremental patch and I'll fold them in.

Thanks for picking this up. However, I hate to throw a wrench in the
works, but I had a v10[1] queued up because kbuild found some problems
with the series over the weekend. I can send v10 off right away if you
want to just replace it in your branch or, if you'd like, I can generate
some incremental patches. Let me know which you'd prefer.

Thanks,

Logan

[1] https://github.com/sbates130272/linux-p2pmem pci-p2p-v10
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
