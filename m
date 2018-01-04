Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1596521CB2E22
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 13:54:40 -0800 (PST)
Date: Thu, 4 Jan 2018 15:59:42 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 01/12] pci-p2p: Support peer to peer memory
Message-ID: <20180104215941.GG189897@bhelgaas-glaptop.roam.corp.google.com>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-2-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180104190137.7654-2-logang@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 04, 2018 at 12:01:26PM -0700, Logan Gunthorpe wrote:
> Some PCI devices may have memory mapped in a BAR space that's
> intended for use in Peer-to-Peer transactions. In order to enable
> such transactions the memory must be registered with ZONE_DEVICE pages
> so it can be used by DMA interfaces in existing drivers.
> ...

> + * pci_p2pmem_alloc_sgl - allocate p2p memory in an sgl
> + * @pdev:	the device to allocate memory from
> + * @sgl:	the allocated sgl
> + * @nents:      the number of sgs in the list
> + * @length:     number of bytes to allocate

Your later patches use "SGL" in English text.  If that's the conventional
capitalization, please use it here, too.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
