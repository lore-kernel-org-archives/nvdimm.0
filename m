Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E3C1224CCC06
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 14:54:55 -0700 (PDT)
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
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <4f761f55-4e9a-dccb-d12f-c59d2cd689db@deltatee.com>
Date: Tue, 13 Mar 2018 16:00:56 -0600
MIME-Version: 1.0
In-Reply-To: <757fca36-dee4-e070-669e-f2788bd78e41@codeaurora.org>
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



On 13/03/18 03:22 PM, Sinan Kaya wrote:
> It sounds like you have very tight hardware expectations for this to work
> at this moment. You also don't want to generalize this code for others and
> address the shortcomings.

No, that's the way the community has pushed this work. Our original work
was very general and we were told it was unacceptable to put the onus on
the user and have things break if the hardware doesn't support it. I
think that's a reasonable requirement. So the hardware use-cases were
wittled down to the ones we can be confident about and support with
reasonable changes to the kernel today.

> To get you going, you should limit this change to the switch products that you have
> validated via white-listing PCI vendor/device ids. Please do not enable this feature
> for all other PCI devices or by default.

This doesn't seem necessary. We know that all PCIe switches available
today support P2P and we are highly confident that any switch that would
ever be produced would support P2P. As long as devices are behind a
switch you don't need any white listing. This is what the current patch
set implements. If you want to start including root ports then you will
need a white list (and solve all the other problems I mentioned earlier).

> I think your code qualifies as a virus until this issue is resolved (so NAK). 

That seems a bit hyperbolic... "a virus"??!... please keep things
constructive.

> You are delivering a general purpose P2P code with a lot of holes in it and
> expecting people to jump through it.
No, the code prevents users from screwing it up. It just requires a
switch in the hardware which is hardly a high bar to jump through
(provided you are putting some design thought into your hardware). And
given it requires semi-custom hardware today, it's not something that
needs to be on by default in any distributor kernel.

> Turning security off by default is also not acceptable. Linux requires ACS support
> even though you don't care about it for your particular application.

That's not true. Linux does not require ACS support. In fact it's
already off by default until you specifically turn on the IOMMU. (Which
is not always the most obvious thing to enable.) And the only thing it
really supports is enforcing isolation between VMs that are using
different pieces of hardware in the system.

> I'd hate ACS to be broken due to some operating system enabling your CONFIG option.

ACS isn't "broken" by enabling the config option. It just makes the
IOMMU groups and isolation less granular. (ie. devices behind a switch
will be in the same group and not isolated from each-other).

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
