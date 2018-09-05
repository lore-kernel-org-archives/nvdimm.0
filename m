Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A726B21959CB2
 for <linux-nvdimm@lists.01.org>; Wed,  5 Sep 2018 14:10:12 -0700 (PDT)
Date: Wed, 5 Sep 2018 23:13:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
Message-ID: <20180905211351.GA2927@lst.de>
References: <20180905195647.GA1626@lst.de>
 <bcc1b3cf-2fd9-fa61-9cfb-b0e4d84e5d94@kernel.dk>
 <20180905201152.GA1893@lst.de>
 <eb42fb94-9da6-955b-8524-0a0f5ac4bd19@deltatee.com>
 <2a3394bd-5f13-4818-43f4-dfc61f501e05@kernel.dk>
 <e3ef26e6-6c8d-25b8-fa64-14594a51263c@deltatee.com>
 <3af4d1d4-da07-c0a6-8464-9ddc1378f2f4@kernel.dk>
 <f9e660cd-b597-bb6e-56a2-82fe71cb3649@deltatee.com>
 <34d9b2f7-9e6d-4a0a-77e5-ec0e99610f5c@kernel.dk>
 <c41c802c-9235-5383-2dfa-af9c1553f11b@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c41c802c-9235-5383-2dfa-af9c1553f11b@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 05, 2018 at 03:03:18PM -0600, Logan Gunthorpe wrote:
> There is no special p2p submission process. In the nvme-of case we are
> using the existing process and with the code in blk-core it didn't
> change it's process at all. Creating a helper will create one and I can
> look at making a pci_p2pdma_submit_bio() for v6; but if the developer
> screws up and still calls the regular submit_bio() things will only be
> very subtly broken and that won't be obvious.

I thought about that when reviewing the previous series, and even
started hacking it up.  In the end I decided against it for the above
reason - it just adds code, but doesn't actually help with anything
as it is trivial to forget, and not using it will in fact just work.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
