Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F3C421159819
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 10:10:09 -0700 (PDT)
Date: Thu, 27 Sep 2018 11:10:13 -0600
From: Keith Busch <keith.busch@linux.intel.com>
Subject: Re: [PATCH v8 09/13] nvme-pci: Use PCI p2pmem subsystem to manage
 the CMB
Message-ID: <20180927171013.GC19589@localhost.localdomain>
References: <20180927165420.5290-1-logang@deltatee.com>
 <20180927165420.5290-10-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180927165420.5290-10-logang@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 27, 2018 at 10:54:16AM -0600, Logan Gunthorpe wrote:
> Register the CMB buffer as p2pmem and use the appropriate allocation
> functions to create and destroy the IO submission queues.
> 
> If the CMB supports WDS and RDS, publish it for use as P2P memory
> by other devices.
> 
> Kernels without CONFIG_PCI_P2PDMA will also no longer support NVMe CMB.
> However, seeing the main use-cases for the CMB is P2P operations,
> this seems like a reasonable dependency.
> 
> We drop the __iomem safety on the buffer seeing that, by convention, it's
> safe to directly access memory mapped by memremap()/devm_memremap_pages().
> Architectures where this is not safe will not be supported by memremap()
> and therefore will not be support PCI P2P and have no support for CMB.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>

Looks good to me.

Reviewed-by: Keith Busch <keith.busch@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
