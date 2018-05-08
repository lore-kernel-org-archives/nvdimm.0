Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 641E4203BEA46
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 13:19:28 -0700 (PDT)
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
 <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
 <20180508141331.7cd737cb@w520.home>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
Date: Tue, 8 May 2018 14:19:05 -0600
MIME-Version: 1.0
In-Reply-To: <20180508141331.7cd737cb@w520.home>
Content-Language: en-US
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
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
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>



On 08/05/18 02:13 PM, Alex Williamson wrote:
> Well, I'm a bit confused, this patch series is specifically disabling
> ACS on switches, but per the spec downstream switch ports implementing
> ACS MUST implement direct translated P2P.  So it seems the only
> potential gap here is the endpoint, which must support ATS or else
> there's nothing for direct translated P2P to do.  The switch port plays
> no part in the actual translation of the request, ATS on the endpoint
> has already cached the translation and is now attempting to use it.
> For the switch port, this only becomes a routing decision, the request
> is already translated, therefore ACS RR and EC can be ignored to
> perform "normal" (direct) routing, as if ACS were not present.  It would
> be a shame to go to all the trouble of creating this no-ACS mode to find
> out the target hardware supports ATS and should have simply used it, or
> we should have disabled the IOMMU altogether, which leaves ACS disabled.

Ah, ok, I didn't think it was the endpoint that had to implement ATS.
But in that case, for our application, we need NVMe cards and RDMA NICs
to all have ATS support and I expect that is just as unlikely. At least
none of the endpoints on my system support it. Maybe only certain GPUs
have this support.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
