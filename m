Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCBE921E49050
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 16:39:48 -0700 (PDT)
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
 <2b152932-2f44-408b-e3ed-b4608d95f82e@deltatee.com>
 <156c24fb-6e27-28f6-0b36-7fd83311ce37@codeaurora.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <932bbf48-9d86-97ec-17bb-052099aff99e@deltatee.com>
Date: Tue, 13 Mar 2018 17:45:58 -0600
MIME-Version: 1.0
In-Reply-To: <156c24fb-6e27-28f6-0b36-7fd83311ce37@codeaurora.org>
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



On 13/03/18 05:19 PM, Sinan Kaya wrote:
> It is still a switch it can move packets but, maybe it can move data at
> 100kbps speed. 

As Stephen pointed out, it's a requirement of the PCIe spec that a
switch supports P2P. If you want to sell a switch that does P2P with bad
performance then that's on you to deal with.

> What prevents that switch from trying P2P and having a bad user experience?

The fact that no one would buy such a switch as it would have a bad user
experience with regular PCI transfers. A P2P TLP is not special on a
switch as it's routed in just the same way as any others. There'd also
be no cost gain in making such a broken-by-design device.

> If everything is so broken, I was suggesting to at least list the switches
> you have tested.
> 
> What's the problem with this?

More complexity for zero gain.

> Why do you want to assume that all switches are good and all root ports are
> bad?

Because the assumption that all switches are good is more than
reasonable and simplifies the code and maintenance significantly. No one
wants to maintain a white list when they don't have to.

> What if the design is so canned that you can't change anything? 

Based on the feedback we've got so far and the developers that have
participated in getting it to where it is, it is not "canned".

> I have been asking things like getting rid of switch search in ACS
> enablement towards achieving generic P2P. You seem to be pushing back.
> You said yourself P2P and isolation doesn't go together at this point
> but you also care about isolation for other devices that are not doing
> P2P.

P2P and isolation will never be compatible at any point. They are two
opposite concepts. So we could just disable isolation across the whole
system and for our purposes that would be fine. But it's relatively
simple to limit this and only disable it behind switches. So why
wouldn't we? It enables use cases like having an isolated card on the
root complex used in a VM while having P2P on cards behind switches. I
personally have no interest in doing this but I also have no reason to
prevent it with my code.

> It is not a requirement for you but it is a requirement for me (ARM64 guy).
> Linux happens to run on multiple architectures. One exception invalidates your
> point.

It is not a requirement of an architecture or people that use a specific
architecture. It is a requirement of the use-case and you have not said
any use case or how we could do better. If you're running VMs that
require isolation you will need to be *very* careful if you also want to
do P2P between cards which requires no isolation. But, based on my
understanding, most people will want to do one or the other -- not both.
If you want to do P2P you enable the P2P config option, if you want
isolation you don't.

> If you are assuming that your kernel option should not be used by general
> distributions like Ubuntu/redhat etc. and requires a kernel compilation,
> creating a dependency to EXPERT is the right way to do. 

I don't have a problem adding EXPERT as a dependency. We can do that for
v4. I'd rather hope that distros actually read and understand the
kconfig help text before enabling an off-by-default option. But maybe
I'm asking too much.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
