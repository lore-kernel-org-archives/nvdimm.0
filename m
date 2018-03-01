Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C6EA22402E1A
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 15:23:23 -0800 (PST)
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-11-logang@deltatee.com>
 <749e3752-4349-0bdf-5243-3d510c2b26db@grimberg.me>
 <40d69074-31a8-d06a-ade9-90de7712c553@deltatee.com>
 <5649098f-b775-815b-8b9a-f34628873ff4@grimberg.me>
 <20180301184249.GI19007@ziepe.ca>
 <edaf476a-cfe9-0598-1aa5-14802a9a1477@deltatee.com>
 <20180301224540.GL19007@ziepe.ca>
 <77591162-4CCD-446E-A27C-1CDB4996ACB7@raithlin.com>
 <20180301232038.GO19007@ziepe.ca>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <bb1bb433-1a7c-2088-f150-e8627f46b884@deltatee.com>
Date: Thu, 1 Mar 2018 16:29:19 -0700
MIME-Version: 1.0
In-Reply-To: <20180301232038.GO19007@ziepe.ca>
Content-Language: en-US
Subject: Re: [PATCH v2 10/10] nvmet: Optionally use PCI P2P memory
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
To: Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 01/03/18 04:20 PM, Jason Gunthorpe wrote:
> On Thu, Mar 01, 2018 at 11:00:51PM +0000, Stephen  Bates wrote:

> No, locality matters. If you have a bunch of NICs and bunch of drives
> and the allocator chooses to put all P2P memory on a single drive your
> performance will suck horribly even if all the traffic is offloaded.
> 
> Performance will suck if you have speed differences between the PCI-E
> devices. Eg a bunch of Gen 3 x8 NVMe cards paired with a Gen 4 x16 NIC
> will not reach full performance unless the p2p buffers are properly
> balanced between all cards.

This would be solved better by choosing the closest devices in the 
hierarchy in the p2pmem_find function (ie. preferring devices involved 
in the transaction). Also, based on the current code, it's a bit of a 
moot point seeing it requires all devices to be on the same switch. So 
unless you have a giant switch hidden somewhere you're not going to get 
too many NIC/NVME pairs.

In any case, we are looking at changing both those things so distance in 
the topology is preferred and the ability to span multiple switches is 
allowed. We're also discussing changing it to "user picks" which 
simplifies all of this.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
