Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE8DE2202E49B
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 09:17:24 -0700 (PDT)
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
 <932bbf48-9d86-97ec-17bb-052099aff99e@deltatee.com>
 <6e36d43b0493455a8547bc50c8ec77ba@AcuMS.aculab.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <f5c1d284-5bc1-8007-08fd-1837c70b0daa@deltatee.com>
Date: Wed, 14 Mar 2018 10:23:27 -0600
MIME-Version: 1.0
In-Reply-To: <6e36d43b0493455a8547bc50c8ec77ba@AcuMS.aculab.com>
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
To: David Laight <David.Laight@ACULAB.COM>, Sinan Kaya <okaya@codeaurora.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 14/03/18 06:16 AM, David Laight wrote:
> That surprises me (unless I missed something last time I read the spec).
> While P2P writes are relatively easy to handle, reads and any other TLP that
> require acks are a completely different proposition.
> There are no additional fields that can be set in the read TLP and will be
> reflected back in the ack(s) than can be used to route the acks back to the
> correct initiator.
>
> I'm pretty sure that to support P2P reads a switch would have to save
> the received read TLP and (possibly later on) issue read TLP of its own
> for the required data.
> I'm not even sure it is easy to interleave the P2P reads with those
> coming from the root.
> That requires a potentially infinite queue of pending requests.

This is wrong. A completion is a TLP just like any other and makes use
of the Destination ID field in the header to route it back to the
original requester.

> Some x86 root ports support P2P writes (maybe with a bios option).
> It would be a shame not to be able to do P2P writes on such systems
> even though P2P reads won't work.

Yes, and this has been discussed many times. It won't be changing in the
near term.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
