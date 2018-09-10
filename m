Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D7C321A07A92
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 11:11:28 -0700 (PDT)
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
 <20180910164144.GA24591@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <fc4f14ae-9490-f901-a60c-2bd1522ef137@deltatee.com>
Date: Mon, 10 Sep 2018 12:11:01 -0600
MIME-Version: 1.0
In-Reply-To: <20180910164144.GA24591@lst.de>
Content-Language: en-US
Subject: Re: [PATCH v5 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>



On 10/09/18 10:41 AM, Christoph Hellwig wrote:
> On Wed, Sep 05, 2018 at 03:03:18PM -0600, Logan Gunthorpe wrote:
>> There is no special p2p submission process. In the nvme-of case we are
>> using the existing process and with the code in blk-core it didn't
>> change it's process at all. Creating a helper will create one and I can
>> look at making a pci_p2pdma_submit_bio() for v6; but if the developer
>> screws up and still calls the regular submit_bio() things will only be
>> very subtly broken and that won't be obvious.
> 
> I just saw you added that "helper" in your tree.  Please don't, it is
> a negative value add as it doesn't help anything with the checking.

Alright, so what's the consensus then? Just have a check in
nvmet_bdev_execute_rw() to add REQ_NOMERGE when appropriate? Jens is
pretty dead set against adding to the common path.

Logan


P.S. Here's the commit in question for anyone else on the list:

https://github.com/sbates130272/linux-p2pmem/commit/eeabe0bc94491d3eec4fe872274a9e3b4cdea538
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
