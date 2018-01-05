Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5658221F833D2
 for <linux-nvdimm@lists.01.org>; Fri,  5 Jan 2018 09:06:02 -0800 (PST)
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-5-logang@deltatee.com>
 <20180104215721.GF189897@bhelgaas-glaptop.roam.corp.google.com>
 <20180104153551.3118f71b@t450s.home>
 <20fdb5bb-0236-c093-ed53-e12664022f53@deltatee.com>
 <20180104203300.79487c98@w520.home>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <77ec7893-6ff5-ebdf-163d-fc4e02077cc2@deltatee.com>
Date: Fri, 5 Jan 2018 10:10:51 -0700
MIME-Version: 1.0
In-Reply-To: <20180104203300.79487c98@w520.home>
Content-Language: en-US
Subject: Re: [PATCH 04/12] pci-p2p: Clear ACS P2P flags for all client devices
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
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 04/01/18 08:33 PM, Alex Williamson wrote:
> That's exactly what IOMMU groups represent, the smallest set of devices
> which have DMA isolation from other devices.  By poking this hole, the
> IOMMU group is invalid.  We cannot turn off ACS only for a specific
> device, in order to enable p2p it needs to be disabled at every
> downstream port between the devices where we want to enable p2p.
> Depending on the topology, that could mean we're also enabling p2p for
> unrelated devices.  Those unrelated devices might be in active use and
> the p2p IOVAs now have a different destination which is no longer IOMMU
> translated.

Oh, so IOMMU groups are created based on the existing hierarchy at boot 
time and not based on the user's needs for isolation?

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
