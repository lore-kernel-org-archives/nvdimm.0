Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9786E22546B9A
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 14:50:42 -0800 (PST)
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-11-logang@deltatee.com>
 <749e3752-4349-0bdf-5243-3d510c2b26db@grimberg.me>
 <40d69074-31a8-d06a-ade9-90de7712c553@deltatee.com>
 <5649098f-b775-815b-8b9a-f34628873ff4@grimberg.me>
 <20180301184249.GI19007@ziepe.ca>
 <edaf476a-cfe9-0598-1aa5-14802a9a1477@deltatee.com>
 <20180301224540.GL19007@ziepe.ca>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <cd55324c-f5bb-6bfb-a7b3-e128c797ca6b@deltatee.com>
Date: Thu, 1 Mar 2018 15:56:38 -0700
MIME-Version: 1.0
In-Reply-To: <20180301224540.GL19007@ziepe.ca>
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
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 01/03/18 03:45 PM, Jason Gunthorpe wrote:
> I can appreciate you might have some special use case for that, but it
> absolutely should require special configuration and not just magically
> happen.

Well if driver doesn't want someone doing p2p transfers with the memory 
it shouldn't publish it to be used for exactly that purpose.

> You bring up IB adaptor memory - if we put that into the allocator
> then what is to stop the NMVe driver just using it instead of the CMB
> buffer? That would be totally wrong in almost all cases.

If you mean for SQEs in the NVMe driver, look at the code, it 
specifically allocates it from it's own device. If you mean the 
nvmet-rdma then it's using that memory exactly as it was meant to. 
Again, if the IB driver doesn't want someone to use that memory for P2P 
transfers it shouldn't publish it as such.

> Seems like a very subtle and hard to debug performance trap to leave
> for the users, and pretty much the only reason to use P2P is
> performance... So why have such a dangerous interface?

It's not at all dangerous, the code specifically only uses P2P memory 
that's local enough. And the majority of the code is there to make sure 
it will all work in all cases.

Honestly, though, I'd love to go back to the case where the user selects 
which p2pmem device to use, but that was very unpopular last year. It 
would simplify a bunch of things though.

Also, no, the reason to use P2P is not performance. Only if you have 
very specific hardware can you get a performance bump and it isn't all 
that significant. The reason to use P2P is so you can design performant 
systems with small CPUs, less or slower DRAM, and low lane counts to the 
CPU, etc.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
