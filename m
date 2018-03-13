Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F379921ED1C7D
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 16:02:30 -0700 (PDT)
Date: Tue, 13 Mar 2018 18:08:50 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Message-ID: <20180313230850.GA45763@bhelgaas-glaptop.roam.corp.google.com>
References: <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
 <52cbbbc4-c488-f83f-8d02-14d455b4efd7@codeaurora.org>
 <3e738f95-d73c-4182-2fa1-8664aafb1ab7@deltatee.com>
 <703aa92c-0c1c-4852-5887-6f6e6ccde0fb@codeaurora.org>
 <a0af83f8-2cbc-862b-6f8b-231991527cfc@deltatee.com>
 <3ea80992-a0fc-08f2-d93d-ae0ec4e3f4ce@codeaurora.org>
 <4eb6850c-df1b-fd44-3ee0-d43a50270b53@deltatee.com>
 <757fca36-dee4-e070-669e-f2788bd78e41@codeaurora.org>
 <4f761f55-4e9a-dccb-d12f-c59d2cd689db@deltatee.com>
 <BB94077B-7EB3-49C4-862D-BF77D0A692CC@raithlin.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BB94077B-7EB3-49C4-862D-BF77D0A692CC@raithlin.com>
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
To: Stephen Bates <sbates@raithlin.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Sinan Kaya <okaya@codeaurora.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 13, 2018 at 10:31:55PM +0000, Stephen  Bates wrote:
> >> It sounds like you have very tight hardware expectations for this to work
> >> at this moment. You also don't want to generalize this code for others and
> >> address the shortcomings.
> >  No, that's the way the community has pushed this work
> 
> Hi Sinan
> 
> Thanks for all the input. As Logan has pointed out the switch
> requirement is something that has evolved over time based on input
> from the community. You are more than welcome to have an opinion on
> this (and you have made that opinion clear ;-)). Over time the
> patchset may evolve from its current requirements but right now we
> are aligned with the feedback from the community.

This part of the community hasn't been convinced of the need to have
two bridges, e.g., both an Upstream Port and a Downstream Port, or two
conventional PCI bridges, above the peers.

Every PCI-to-PCI bridge is required to support routing transactions
between devices on its secondary side.  Therefore, I think it is
sufficient to verify that the potential peers share a single common
upstream bridge.  This could be a conventional PCI bridge, a Switch
Downstream Port, or a Root Port.

I've seen the response that peers directly below a Root Port could not
DMA to each other through the Root Port because of the "route to self"
issue, and I'm not disputing that.  But enforcing a requirement for
two upstream bridges introduces a weird restriction on conventional
PCI topologies, makes the code hard to read, and I don't think it's
necessary.

If it *is* necessary because Root Ports and devices below them behave
differently than in conventional PCI, I think you should include a
reference to the relevant section of the spec and check directly for a
Root Port.  I would prefer that over trying to exclude Root Ports by
looking for two upstream bridges.

Bjorn
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
