Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9802021F833CA
 for <linux-nvdimm@lists.01.org>; Fri,  5 Jan 2018 10:53:18 -0800 (PST)
Date: Fri, 5 Jan 2018 12:01:35 -0700
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 09/12] nvme-pci: Use PCI p2pmem subsystem to manage the CMB
Message-ID: <20180105190135.GB10657@localhost.localdomain>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-10-logang@deltatee.com>
 <20180105181152.GA10657@localhost.localdomain>
 <6c89e4b4-1854-c251-a5ec-7e54bc8085fc@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6c89e4b4-1854-c251-a5ec-7e54bc8085fc@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 05, 2018 at 11:19:28AM -0700, Logan Gunthorpe wrote:
> Although it is not explicitly stated anywhere, pci_alloc_p2pmem() should
> always be at least 4k aligned. This is because the gen_pool that implements
> it is created with PAGE_SHIFT for its min_alloc_order.

Ah, I see that now. Thanks for the explanation.

Does it need to be created with page sized minimum alloc order? That
granularity makes it difficult to fit SQs in CMB on archs with larger
pages when we only needed 4k alignment.

I was also hoping to extend this for PRP/SGL in CMB where even 4k is
too high a granularity to make it really useful.

It looks like creating the gen pool with a smaller minimum and
gen_pool_first_fit_order_align algo would satisfy my use cases, but I'm
not sure if there's another reason you've set it to page alignment.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
