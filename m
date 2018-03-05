Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B3B121E08288
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 12:35:58 -0800 (PST)
Date: Mon, 5 Mar 2018 13:42:12 -0700
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage
 the CMB
Message-ID: <20180305204212.GD30975@localhost.localdomain>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-8-logang@deltatee.com>
 <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
 <20180305160004.GA30975@localhost.localdomain>
 <36c78987-006a-a97f-1d18-b0a08cbea9d4@grimberg.me>
 <20180305201053.GK11337@mellanox.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180305201053.GK11337@mellanox.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 05, 2018 at 01:10:53PM -0700, Jason Gunthorpe wrote:
> So when reading the above mlx code, we see the first wmb() being used
> to ensure that CPU stores to cachable memory are visible to the DMA
> triggered by the doorbell ring.

IIUC, we don't need a similar barrier for NVMe to ensure memory is
visibile to DMA since the SQE memory is allocated DMA coherent when the
SQ is not within a CMB.
 
> The mmiowb() is used to ensure that DB writes are not combined and not
> issued in any order other than implied by the lock that encloses the
> whole thing. This is needed because uar_map is WC memory.
> 
> We don't have ordering with respect to two writel's here, so if ARM
> performance was a concern the writel could be switched to
> writel_relaxed().
> 
> Presumably nvme has similar requirments, although I guess the DB
> register is mapped UC not WC?

Yep, the NVMe DB register is required by the spec to be mapped UC.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
