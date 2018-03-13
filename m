Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B41BF224872B8
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 09:38:02 -0700 (PDT)
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-2-logang@deltatee.com>
 <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
Date: Tue, 13 Mar 2018 10:43:55 -0600
MIME-Version: 1.0
In-Reply-To: <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
Content-Language: en-US
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Sinan Kaya <okaya@codeaurora.org>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 12/03/18 09:28 PM, Sinan Kaya wrote:
> On 3/12/2018 3:35 PM, Logan Gunthorpe wrote:
> Regarding the switch business, It is amazing how much trouble you went into
> limit this functionality into very specific hardware.
> 
> I thought that we reached to an agreement that code would not impose
> any limits on what user wants.
> 
> What happened to all the emails we exchanged?

It turns out that root ports that support P2P are far less common than 
anyone thought. So it will likely have to be a white list. Nobody else 
seems keen on allowing the user to enable this on hardware that doesn't 
work. The easiest solution is still limiting it to using a switch. From 
there, if someone wants to start creating a white-list then that's 
probably the way forward to support root ports.

And there's also the ACS problem which means if you want to use P2P on 
the root ports you'll have to disable ACS on the entire system. (Or 
preferably, the IOMMU groups need to get more sophisticated to allow for 
dynamic changes).

Additionally, once you allow for root ports you may find the IOMMU 
getting in the way.

So there are great deal more issues to sort out if you don't restrict to 
devices behind switches.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
