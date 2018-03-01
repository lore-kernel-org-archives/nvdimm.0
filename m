Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from CAN01-TO1-obe.outbound.protection.outlook.com
 (mail-eopbgr670099.outbound.protection.outlook.com [40.107.67.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9ABA22423821
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 08:08:58 -0800 (PST)
From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH v2 10/10] nvmet: Optionally use PCI P2P memory
Date: Thu, 1 Mar 2018 16:15:04 +0000
Message-ID: <A95AE6BF-1CAC-48F5-B676-DA7BD6D5BF24@raithlin.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-11-logang@deltatee.com>
 <749e3752-4349-0bdf-5243-3d510c2b26db@grimberg.me>
In-Reply-To: <749e3752-4349-0bdf-5243-3d510c2b26db@grimberg.me>
Content-Language: en-US
Content-ID: <196AA3290052DF43BEE7534D9534469B@CANPRD01.PROD.OUTLOOK.COM>
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
To: Sagi Grimberg <sagi@grimberg.me>, Logan Gunthorpe <logang@deltatee.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Steve Wise <swise@opengridcomputing.com>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

> > Ideally, we'd want to use an NVME CMB buffer as p2p memory. This would
> > save an extra PCI transfer as the NVME card could just take the data
> > out of it's own memory. However, at this time, cards with CMB buffers
> > don't seem to be available.

> Can you describe what would be the plan to have it when these devices
> do come along? I'd say that p2p_dev needs to become a nvmet_ns reference
> and not from nvmet_ctrl. Then, when cmb capable devices come along, the
> ns can prefer to use its own cmb instead of locating a p2p_dev device?

Hi Sagi

Thanks for the review! That commit message is somewhat dated as NVMe controllers with CMBs that support RDS and WDS are now commercially available [1]. However we have not yet tried to do any kind of optimization around this yet in terms of determining which p2p_dev to use. Your suggest above looks good and we can look into this kind of optimization in due course.

[1] http://www.eideticom.com/uploads/images/NoLoad_Product_Spec.pdf
    
>> +	ctrl->p2p_dev = pci_p2pmem_find(&ctrl->p2p_clients);

> This is the first p2p_dev found right? What happens if I have more than
> a single p2p device? In theory I'd have more p2p memory I can use. Have
> you considered making pci_p2pmem_find return the least used suitable
> device?
    
Yes pci_p2pmem_find will always return the first valid p2p_dev found. At the very least we should update this allocate over all the valid p2p_dev. Since the load on any given p2p_dev will vary over time I think a random allocation of the devices makes sense (at least for now). 

Stephen

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
