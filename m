Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A52BD224E691B
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 11:21:09 -0800 (PST)
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-11-logang@deltatee.com>
 <749e3752-4349-0bdf-5243-3d510c2b26db@grimberg.me>
 <40d69074-31a8-d06a-ade9-90de7712c553@deltatee.com>
 <5649098f-b775-815b-8b9a-f34628873ff4@grimberg.me>
 <20180301184249.GI19007@ziepe.ca>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <edaf476a-cfe9-0598-1aa5-14802a9a1477@deltatee.com>
Date: Thu, 1 Mar 2018 12:27:03 -0700
MIME-Version: 1.0
In-Reply-To: <20180301184249.GI19007@ziepe.ca>
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
To: Jason Gunthorpe <jgg@ziepe.ca>, Sagi Grimberg <sagi@grimberg.me>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 01/03/18 11:42 AM, Jason Gunthorpe wrote:
> On Thu, Mar 01, 2018 at 08:35:55PM +0200, Sagi Grimberg wrote:
> This is also why I don't entirely understand why this series has a
> generic allocator for p2p mem, it makes little sense to me.

> Why wouldn't the nmve driver just claim the entire CMB of its local
> device for its own use? Why involve p2p core code in this?

We'd prefer to have a generic way to get p2pmem instead of restricting 
ourselves to only using CMBs. We did work in the past where the P2P 
memory was part of an IB adapter and not the NVMe card. So this won't 
work if it's an NVMe only interface.

As Stephen mentioned, we also use a couple devices that only exposes P2P 
memory and this isn't related to NVMe at all. So there's value in having 
a generic interface and allocator to enable all devices to provide this 
memory.

If there were a hypothetical situation where a driver wants to use some 
of the memory for P2P and some of it for other purposes then they'd just 
divide it themselves and only pass a subset to 
pci_p2pdma_add_resource(). However, as per our changes to the nvme-pci 
code, it's really just easier to use the allocator for everything inside 
the driver.

Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
