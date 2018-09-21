Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A089211518C2
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 06:07:07 -0700 (PDT)
Date: Fri, 21 Sep 2018 08:07:05 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v6 02/13] PCI/P2PDMA: Add sysfs group to display p2pmem
 stats
Message-ID: <20180921130705.GF224714@bhelgaas-glaptop.roam.corp.google.com>
References: <20180913001156.4115-1-logang@deltatee.com>
 <20180913001156.4115-3-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180913001156.4115-3-logang@deltatee.com>
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

On Wed, Sep 12, 2018 at 06:11:45PM -0600, Logan Gunthorpe wrote:
> Add a sysfs group to display statistics about P2P memory that is
> registered in each PCI device.
> 
> Attributes in the group display the total amount of P2P memory, the
> amount available and whether it is published or not.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> +What:		/sys/bus/pci/devices/.../p2pmem/available
> +Date:		November 2017
> +Contact:	Logan Gunthorpe <logang@deltatee.com>
> +Description:
> +		If the device has any Peer-to-Peer memory registered, this
> +	        file contains the amount of memory that has not been
> +		allocated (in decimal).
> +
> +What:		/sys/bus/pci/devices/.../p2pmem/size
> +Date:		November 2017
> +Contact:	Logan Gunthorpe <logang@deltatee.com>
> +Description:
> +		If the device has any Peer-to-Peer memory registered, this
> +	        file contains the total amount of memory that the device
> +		provides (in decimal).

Maybe reorder this so the "size" (total amount) is documented before
"available" (some subset of "size")?

> +
> +What:		/sys/bus/pci/devices/.../p2pmem/published
> +Date:		November 2017
> +Contact:	Logan Gunthorpe <logang@deltatee.com>
> +Description:
> +		If the device has any Peer-to-Peer memory registered, this
> +	        file contains a '1' if the memory has been published for
> +		use inside the kernel or a '0' if it is only intended
> +		for use within the driver that published it.

It doesn't read quite right to talk about "use within the driver that
*published* it".  Is it really published in that case?  That sounds more
like "private".  I expected something like the following (but I don't claim
to understand the whole use model here):

  ... this file contains a '1' if the memory has been published for use
  outside the driver that owns the device.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
