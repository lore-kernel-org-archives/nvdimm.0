Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 72FBA2248728C
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 15:42:56 -0700 (PDT)
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-2-logang@deltatee.com>
 <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
 <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
 <52cbbbc4-c488-f83f-8d02-14d455b4efd7@codeaurora.org>
 <3e738f95-d73c-4182-2fa1-8664aafb1ab7@deltatee.com>
 <703aa92c-0c1c-4852-5887-6f6e6ccde0fb@codeaurora.org>
 <a0af83f8-2cbc-862b-6f8b-231991527cfc@deltatee.com>
 <3ea80992-a0fc-08f2-d93d-ae0ec4e3f4ce@codeaurora.org>
 <4eb6850c-df1b-fd44-3ee0-d43a50270b53@deltatee.com>
 <757fca36-dee4-e070-669e-f2788bd78e41@codeaurora.org>
 <4f761f55-4e9a-dccb-d12f-c59d2cd689db@deltatee.com>
 <016dc910-f96a-8a60-4bda-fa24eea98ea5@codeaurora.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <2b152932-2f44-408b-e3ed-b4608d95f82e@deltatee.com>
Date: Tue, 13 Mar 2018 16:48:55 -0600
MIME-Version: 1.0
In-Reply-To: <016dc910-f96a-8a60-4bda-fa24eea98ea5@codeaurora.org>
Content-Language: en-US
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
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
To: Sinan Kaya <okaya@codeaurora.org>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 13/03/18 04:29 PM, Sinan Kaya wrote:
> If hardware doesn't support it, blacklisting should have been the right
> path and I still think that you should remove all switch business from the code.
> I did not hear enough justification for having a switch requirement
> for P2P.

I disagree.

> You are also saying that root ports have issues not because of functionality but
> because of performance. 

No... performance can also be an issue but the main justification for
this is that many root ports do not support P2P at all and can fail in
different ways (usually just dropping the TLPs).

> What if I come up with a very cheap/crappy switch (something like used in data
> mining)?

Good luck. That's not how hardware is designed. PCIe switches that have
any hope to compete with the existing market will need features like
NTB, non-transparent ports, etc... and that implies a certain symmetry
(ie there isn't a special host port because there may be more than one
and it may move around) which implies that packets will always be able
to forward between each ports which implies P2P will work.

> I have been doing my best to provide feedback. It feels like you are throwing
> them over the wall to be honest.
> 
> You keep implying "not my problem".

Well, the fact of the matter is that extending this in all the ways
people like you want face huge problems on all sides. These are not
trivial issues and holding back work that works for our problem because
it doesn't solve your problem is IMO just going to grind development in
this area to a halt. We have to have something we can agree on which is
safe to start building on. The building can't just emerge fully formed
in one go.

P2P proposal go back a long time and have never gotten anywhere because
there are limitations and people want it to do things that are hard but
don't want to contribute the work to solving those problems.

>> Well, if it's a problem for someone they'll have to solve it. We're
>> targeting JBOFs that have no use for ACS / IOMMU groups at all.
> 
> IMO, you (not somebody) should address this one way or the other before this
> series land in upstream.

The real way to address this (as I've mentioned before) is with some way
of doing ACS and iomem groups dynamically. But this is a huge project in
itself and is never going to be part of the P2P patchset.

> Another assumption: There are other architectures like ARM64 where IOMMU
> is enabled by default even if you don't use VMs for security reasons.
> IOMMU blocks stray transactions.

True, but it doesn't change my point: ACS is not a requirement for Linux
many many systems do not have it on at all or by default.

> Didn't the ACS behavior change suddenly for no good reason when we enabled
> your code even though I might not be using the P2P but I happen to have
> a kernel with P2P config option?

Well no, presumably you made a conscious choice to turn the config
option on and build a custom kernel for your box. That doesn't seem very
sudden and the reason is that the two concepts are very much at odds
with each other: you can't have isolation and still have transactions
between devices.

Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
