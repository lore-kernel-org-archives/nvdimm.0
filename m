Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 957C821159819
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 10:10:22 -0700 (PDT)
Date: Thu, 27 Sep 2018 11:12:30 -0600
From: Keith Busch <keith.busch@linux.intel.com>
Subject: Re: [PATCH v8 13/13] nvmet: Optionally use PCI P2P memory
Message-ID: <20180927171230.GE19589@localhost.localdomain>
References: <20180927165420.5290-1-logang@deltatee.com>
 <20180927165420.5290-14-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180927165420.5290-14-logang@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 27, 2018 at 10:54:20AM -0600, Logan Gunthorpe wrote:
> We create a configfs attribute in each nvme-fabrics target port to
> enable p2p memory use. When enabled, the port will only then use the
> p2p memory if a p2p memory device can be found which is behind the
> same switch hierarchy as the RDMA port and all the block devices in
> use. If the user enabled it and no devices are found, then the system
> will silently fall back on using regular memory.
> 
> If appropriate, that port will allocate memory for the RDMA buffers
> for queues from the p2pmem device falling back to system memory should
> anything fail.
> 
> Ideally, we'd want to use an NVME CMB buffer as p2p memory. This would
> save an extra PCI transfer as the NVME card could just take the data
> out of it's own memory. However, at this time, only a limited number
> of cards with CMB buffers seem to be available.
> 
> Signed-off-by: Stephen Bates <sbates@raithlin.com>
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> [hch: partial rewrite of the initial code]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>

I haven't the necessary hardware to try this out, but looking forward
to it in the future. Looks good.

Reviewed-by: Keith Busch <keith.busch@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
