Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 911622210D9CD
 for <linux-nvdimm@lists.01.org>; Mon, 26 Mar 2018 04:05:46 -0700 (PDT)
Date: Mon, 26 Mar 2018 12:11:38 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Message-ID: <20180326121138.00005e30@huawei.com>
In-Reply-To: <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-2-logang@deltatee.com>
 <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
 <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, Eric Wehage <Eric.Wehage@huawei.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 13 Mar 2018 10:43:55 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> On 12/03/18 09:28 PM, Sinan Kaya wrote:
> > On 3/12/2018 3:35 PM, Logan Gunthorpe wrote:
> > Regarding the switch business, It is amazing how much trouble you went into
> > limit this functionality into very specific hardware.
> > 
> > I thought that we reached to an agreement that code would not impose
> > any limits on what user wants.
> > 
> > What happened to all the emails we exchanged?  
> 
> It turns out that root ports that support P2P are far less common than 
> anyone thought. So it will likely have to be a white list.

This came as a bit of a surprise to our PCIe architect.

His follow up was whether it was worth raising an ECR for the PCIe spec
to add a capability bit to allow this to be discovered.  This might
long term avoid the need to maintain the white list for new devices.

So is it worth having a long term solution for making this discoverable?

Jonathan

> Nobody else 
> seems keen on allowing the user to enable this on hardware that doesn't 
> work. The easiest solution is still limiting it to using a switch. From 
> there, if someone wants to start creating a white-list then that's 
> probably the way forward to support root ports.
> 
> And there's also the ACS problem which means if you want to use P2P on 
> the root ports you'll have to disable ACS on the entire system. (Or 
> preferably, the IOMMU groups need to get more sophisticated to allow for 
> dynamic changes).
> 
> Additionally, once you allow for root ports you may find the IOMMU 
> getting in the way.
> 
> So there are great deal more issues to sort out if you don't restrict to 
> devices behind switches.
> 
> Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
