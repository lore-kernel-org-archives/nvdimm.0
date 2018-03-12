Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 05DB722487290
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 12:34:56 -0700 (PDT)
Date: Mon, 12 Mar 2018 13:41:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 05/11] PCI/P2PDMA: Add P2P DMA driver writer's
 documentation
Message-ID: <20180312134114.1e4b12f8@lwn.net>
In-Reply-To: <20180312193525.2855-6-logang@deltatee.com>
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-6-logang@deltatee.com>
MIME-Version: 1.0
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
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 12 Mar 2018 13:35:19 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> Add a restructured text file describing how to write drivers
> with support for P2P DMA transactions. The document describes
> how to use the APIs that were added in the previous few
> commits.
> 
> Also adds an index for the PCI documentation tree even though this
> is the only PCI document that has ben converted to restructured text
> at this time.

This all seems good, but...could we consider moving this documentation to
driver-api/PCI as it's converted to RST?  That would keep it together with
similar materials and bring a bit more coherence to Documentation/ as a
whole.

Thanks,

jon
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
