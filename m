Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A596C225892AF
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 16:15:21 -0700 (PDT)
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
 <20180313230850.GA45763@bhelgaas-glaptop.roam.corp.google.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <8de5d3dd-a78f-02d5-0eea-4365364143b6@deltatee.com>
Date: Tue, 13 Mar 2018 17:21:20 -0600
MIME-Version: 1.0
In-Reply-To: <20180313230850.GA45763@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
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
To: Bjorn Helgaas <helgaas@kernel.org>, Stephen Bates <sbates@raithlin.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Sinan Kaya <okaya@codeaurora.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 13/03/18 05:08 PM, Bjorn Helgaas wrote:
> On Tue, Mar 13, 2018 at 10:31:55PM +0000, Stephen  Bates wrote:
> If it *is* necessary because Root Ports and devices below them behave
> differently than in conventional PCI, I think you should include a
> reference to the relevant section of the spec and check directly for a
> Root Port.  I would prefer that over trying to exclude Root Ports by
> looking for two upstream bridges.

Well we've established that we don't want to allow root ports.

But we need to, at a minimum, do two pci_upstream_bridge() calls...

Remember, we need to check that a number of devices are behind the same
switch. So we need to find a _common_ upstream port for several devices.
Excluding the multifunction device case (which I don't think is
applicable for reasons we've discussed before), this will *never* be the
first upstream port for a given device. We need to find the upstream
port of the switch and ensure all devices share that same port. If a
device is behind a switch, it's pci_upstream_bridge() is the downstream
switch port which is unique to that device. So a peer device would have
a different pci_upstream_bridge() port but share the same
pci_upstream_bridge(pci_upstream_bridge()) port (assuming they are on
the same switch).

The alternative, is to walk the entire tree of upstream ports and check
that all devices have a common port somewhere in the tree that isn't the
root complex. Arguably this is the right way to do it and would support
a network of switches but is a fair bit more complex to code.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
