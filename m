Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01on0069.outbound.protection.outlook.com [104.47.2.69])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A676220955F24
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 12:04:55 -0800 (PST)
Date: Mon, 5 Mar 2018 13:10:53 -0700
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage
 the CMB
Message-ID: <20180305201053.GK11337@mellanox.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-8-logang@deltatee.com>
 <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
 <20180305160004.GA30975@localhost.localdomain>
 <36c78987-006a-a97f-1d18-b0a08cbea9d4@grimberg.me>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <36c78987-006a-a97f-1d18-b0a08cbea9d4@grimberg.me>
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
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 05, 2018 at 09:57:27PM +0200, Sagi Grimberg wrote:

> Keith, while we're on this, regardless of cmb, is SQE memcopy and DB update
> ordering always guaranteed?
> 
> If you look at mlx4 (rdma device driver) that works exactly the same as
> nvme you will find:
> --
>                 qp->sq.head += nreq;
> 
>                 /*
>                  * Make sure that descriptors are written before
>                  * doorbell record.
>                  */
>                 wmb();
> 
>                 writel(qp->doorbell_qpn,
>                        to_mdev(ibqp->device)->uar_map + MLX4_SEND_DOORBELL);
> 
>                 /*
>                  * Make sure doorbells don't leak out of SQ spinlock
>                  * and reach the HCA out of order.
>                  */
>                 mmiowb();
> --
> 
> That seems to explicitly make sure to place a barrier before updating
> the doorbell. So as I see it, either ordering is guaranteed and the
> above code is redundant, or nvme needs to do the same.

A wmb() is always required before operations that can trigger DMA.

The reason ARM has a barrier in writel() is not to make it ordered
with respect to CPU stores to cachable memory, but to make it ordered
with respect to *other* writels.

Eg Linux defines this:

writel(A, mem);
writel(B, mem);

To always produce two TLPs on PCI-E when mem is UC BAR memory.

And ARM cannot guarentee that without the extra barrier.

So now we see stuff like this:

writel_relaxed(A, mem);
writel_relaxed(B, mem+4);

Which says the TLPs to A and B can be issued in any order..

So when reading the above mlx code, we see the first wmb() being used
to ensure that CPU stores to cachable memory are visible to the DMA
triggered by the doorbell ring.

The mmiowb() is used to ensure that DB writes are not combined and not
issued in any order other than implied by the lock that encloses the
whole thing. This is needed because uar_map is WC memory.

We don't have ordering with respect to two writel's here, so if ARM
performance was a concern the writel could be switched to
writel_relaxed().

Presumably nvme has similar requirments, although I guess the DB
register is mapped UC not WC?

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
