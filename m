Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 78D3F224E692B
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 11:04:15 -0800 (PST)
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-11-logang@deltatee.com>
 <749e3752-4349-0bdf-5243-3d510c2b26db@grimberg.me>
 <40d69074-31a8-d06a-ade9-90de7712c553@deltatee.com>
 <5649098f-b775-815b-8b9a-f34628873ff4@grimberg.me>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <7163af93-2f37-a8b6-986a-3cb2e62bee29@deltatee.com>
Date: Thu, 1 Mar 2018 12:10:12 -0700
MIME-Version: 1.0
In-Reply-To: <5649098f-b775-815b-8b9a-f34628873ff4@grimberg.me>
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
To: Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Steve Wise <swise@opengridcomputing.com>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>


> Wouldn't it all be simpler if the p2p_dev resolution would be private
> to the namespace?
> 
> So is adding some all the namespaces in a subsystem must comply to
> using p2p? Seems a little bit harsh if its not absolutely needed. Would
> be nice to export a subsystems between two ports (on two HCAs, across
> NUMA nodes) where the home node (primary path) would use p2p and
> failover would use host memory...
> 
> Can you help me understand why this is absolutely not feasible?

Yes, it would simplify things. However, as best as I can tell, when we 
allocate memory we don't know what namespace it will be used for. If 
there is a way, I could probably rework it so there's a P2P device per 
namespace.

Can you show me how we'd know the namespace to use in 
nvmet_rdma_map_sgl_keyed()?

Thanks,

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
