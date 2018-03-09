Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCC742256860F
 for <linux-nvdimm@lists.01.org>; Thu,  8 Mar 2018 21:02:26 -0800 (PST)
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 08/10] nvme-pci: Add support for P2P memory in requests
Date: Fri, 9 Mar 2018 05:08:36 +0000
Message-ID: <1520572115.11647.3.camel@wdc.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-9-logang@deltatee.com>
 <c6639530-48ba-4655-c772-7d88a030e37e@grimberg.me>
 <1CE68E79-E5FD-4EE2-BD88-B3EE57E43ACE@raithlin.com>
In-Reply-To: <1CE68E79-E5FD-4EE2-BD88-B3EE57E43ACE@raithlin.com>
Content-Language: en-US
Content-ID: <C229E9B9532B144A863F407D859C647F@namprd04.prod.outlook.com>
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
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "sbates@raithlin.com" <sbates@raithlin.com>, "logang@deltatee.com" <logang@deltatee.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, "jglisse@redhat.com" <jglisse@redhat.com>, "keith.busch@intel.com" <keith.busch@intel.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@mellanox.com" <jgg@mellanox.com>, "bhelgaas@google.com" <bhelgaas@google.com>, "maxg@mellanox.com" <maxg@mellanox.com>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-03-01 at 15:58 +0000, Stephen  Bates wrote:
> > Any plans adding the capability to nvme-rdma? Should be
> > straight-forward... In theory, the use-case would be rdma backend
> > fabric behind. Shouldn't be hard to test either...
> 
> Nice idea Sagi. Yes we have been starting to look at that. Though again we
> would probably want to impose the "attached to the same PCIe switch" rule
> which might be less common to satisfy in initiator systems. 
> 
> Down the road I would also like to discuss the best way to use this P2P
> framework to facilitate copies between NVMe namespaces (on both PCIe and
> fabric attached namespaces) without having to expose the CMB up to user
> space. Wasn't something like that done in the SCSI world at some point
> Martin?

Are you perhaps referring to the following patch series: "Copy Offload"
(https://www.spinics.net/lists/linux-scsi/msg74680.html /
https://lwn.net/Articles/592094/)? I will contact Martin off-list and in
case he wouldn't have the time myself to revive that patch series then I
will free up some time to work on this.

Bart.




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
