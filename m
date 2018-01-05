Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 367D821F833AE
 for <linux-nvdimm@lists.01.org>; Fri,  5 Jan 2018 09:13:11 -0800 (PST)
Date: Fri, 5 Jan 2018 10:18:15 -0700
From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 04/12] pci-p2p: Clear ACS P2P flags for all client devices
Message-ID: <20180105101815.0fcbc142@t450s.home>
In-Reply-To: <77ec7893-6ff5-ebdf-163d-fc4e02077cc2@deltatee.com>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-5-logang@deltatee.com>
 <20180104215721.GF189897@bhelgaas-glaptop.roam.corp.google.com>
 <20180104153551.3118f71b@t450s.home>
 <20fdb5bb-0236-c093-ed53-e12664022f53@deltatee.com>
 <20180104203300.79487c98@w520.home>
 <77ec7893-6ff5-ebdf-163d-fc4e02077cc2@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 5 Jan 2018 10:10:51 -0700
Logan Gunthorpe <logang@deltatee.com> wrote:

> On 04/01/18 08:33 PM, Alex Williamson wrote:
> > That's exactly what IOMMU groups represent, the smallest set of devices
> > which have DMA isolation from other devices.  By poking this hole, the
> > IOMMU group is invalid.  We cannot turn off ACS only for a specific
> > device, in order to enable p2p it needs to be disabled at every
> > downstream port between the devices where we want to enable p2p.
> > Depending on the topology, that could mean we're also enabling p2p for
> > unrelated devices.  Those unrelated devices might be in active use and
> > the p2p IOVAs now have a different destination which is no longer IOMMU
> > translated.  
> 
> Oh, so IOMMU groups are created based on the existing hierarchy at boot 
> time and not based on the user's needs for isolation?

Yes, IOMMU groups expose the isolation of the system as devices are
discovered.  Nothing currently accounts for intentionally decreasing
the isolation between devices.  Thanks,

Alex
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
