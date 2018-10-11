Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12D2121A07A80
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 20:19:01 -0700 (PDT)
Date: Wed, 10 Oct 2018 22:18:58 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v9 00/13] Copy Offload in NVMe Fabrics with P2P PCI Memory
Message-ID: <20181011031858.GL5906@bhelgaas-glaptop.roam.corp.google.com>
References: <20181004212747.6301-1-logang@deltatee.com>
 <20181010201918.GF5906@bhelgaas-glaptop.roam.corp.google.com>
 <5c674a1b-2471-33eb-44f4-fe1bb8807a22@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5c674a1b-2471-33eb-44f4-fe1bb8807a22@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 10, 2018 at 05:03:33PM -0600, Logan Gunthorpe wrote:
> 
> 
> On 2018-10-10 2:19 p.m., Bjorn Helgaas wrote:
> > I added the reviewed-by tags from Christoph, Jens' ack on the blkdev.h
> > change, and applied these to pci/peer-to-peer with the intent of
> > merging these for v4.20.
> > 
> > I gave up on waiting for an ack for the memremap.h and mm.h changes.
> > 
> > I dropped the "nvme-pci: Add a quirk for a pseudo CMB" quirk because
> > of Christoph's objection.  After this is all merged, I won't need to
> > be involved, and you and the NVMe folks can hash that out.
> > 
> > If there are updates to "nvmet: Optionally use PCI P2P memory" based
> > on Sagi's comments, send an incremental patch and I'll fold them in.
> 
> Thanks for picking this up. However, I hate to throw a wrench in the
> works, but I had a v10[1] queued up because kbuild found some problems
> with the series over the weekend. I can send v10 off right away if you
> want to just replace it in your branch or, if you'd like, I can generate
> some incremental patches. Let me know which you'd prefer.

I applied the updates from your v10 to my pci/peer-to-peer branch.

> [1] https://github.com/sbates130272/linux-p2pmem pci-p2p-v10
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
