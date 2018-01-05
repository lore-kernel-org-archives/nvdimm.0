Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E1E122280C4F
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 15:55:58 -0800 (PST)
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-5-logang@deltatee.com>
 <20180104215721.GF189897@bhelgaas-glaptop.roam.corp.google.com>
 <20180104153551.3118f71b@t450s.home>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <20fdb5bb-0236-c093-ed53-e12664022f53@deltatee.com>
Date: Thu, 4 Jan 2018 17:00:47 -0700
MIME-Version: 1.0
In-Reply-To: <20180104153551.3118f71b@t450s.home>
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
To: Alex Williamson <alex.williamson@redhat.com>, Bjorn Helgaas <helgaas@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 04/01/18 03:35 PM, Alex Williamson wrote:
> Yep, flipping these ACS bits invalidates any IOMMU groups that depend
> on the isolation of that downstream port and I suspect also any peers
> within the same PCI slot of that port and their downstream devices.  The
> entire sub-hierarchy grouping needs to be re-evaluated.  This
> potentially affects running devices that depend on that isolation, so
> I'm not sure how that happens dynamically.  A boot option might be
> easier.  Thanks,

I don't see how this is the case in current kernel code. It appears to 
only enable ACS globally if the IOMMU requests it.

I also don't see how turning off ACS isolation for a specific device is 
going to hurt anything. The IOMMU should still be able to keep going on 
unaware that anything has changed. The only worry is that a security 
hole may now be created if a user was relying on the isolation between 
two devices that are in different VMs or something. However, if a user 
was relying on this, they probably shouldn't have turned on P2P in the 
first place.

We started with a fairly unintelligent choice to simply disable ACS on 
any kernel that had CONFIG_PCI_P2P set. However, this did not seem like 
a good idea going forward. Instead, we now selectively disable the ACS 
bit only on the downstream ports that are involved in P2P transactions. 
This seems like the safest choice and still allows people to (carefully) 
use P2P adjacent to other devices that need to be isolated.

I don't think anyone wants another boot option that must be set in order 
to use this functionality (and only some hardware would require this). 
That's just a huge pain for users.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
