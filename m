Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A819A2111FE4E
 for <linux-nvdimm@lists.01.org>; Wed,  5 Sep 2018 13:32:17 -0700 (PDT)
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-8-logang@deltatee.com>
 <b5ab8fa3-34ac-3117-fa0d-5206c3939435@kernel.dk>
 <20180901082812.GB670@lst.de>
 <5f79c012-c6e1-56bb-62fd-0689181fb2c9@deltatee.com>
 <59b28977-8f2a-6228-2050-03fae6bdbedd@kernel.dk>
 <1b4283da-44df-4a02-3167-e295243cef78@deltatee.com>
 <09258b9b-3aed-9890-b31a-bd70a133966c@kernel.dk>
 <20180905195647.GA1626@lst.de>
 <bcc1b3cf-2fd9-fa61-9cfb-b0e4d84e5d94@kernel.dk>
 <20180905201152.GA1893@lst.de>
 <eb42fb94-9da6-955b-8524-0a0f5ac4bd19@deltatee.com>
 <2a3394bd-5f13-4818-43f4-dfc61f501e05@kernel.dk>
 <e3ef26e6-6c8d-25b8-fa64-14594a51263c@deltatee.com>
 <3af4d1d4-da07-c0a6-8464-9ddc1378f2f4@kernel.dk>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <f9e660cd-b597-bb6e-56a2-82fe71cb3649@deltatee.com>
Date: Wed, 5 Sep 2018 14:32:06 -0600
MIME-Version: 1.0
In-Reply-To: <3af4d1d4-da07-c0a6-8464-9ddc1378f2f4@kernel.dk>
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
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>



On 05/09/18 02:19 PM, Jens Axboe wrote:
> On 9/5/18 2:18 PM, Logan Gunthorpe wrote:
>>
>>
>> On 05/09/18 02:14 PM, Jens Axboe wrote:
>>> But if the caller must absolutely know where the bio will end up, then
>>> it seems super redundant. So I'd vote for killing this check, it buys
>>> us absolutely nothing and isn't even exhaustive in its current form.
>>
>>
>> Ok, I'll remove it for v6.
> 
> Since the drivers needs to know it's doing it right, it might not
> hurt to add a sanity check helper for that. Just have the driver
> call it, and don't add it in the normal IO submission path.

I'm not sure I really see the value in that. It's the same principle in
asking the driver to do the WARN: if the developer knew enough to use
the special helper, they probably knew well enough to do the rest correctly.

I guess one other thing to point out is that, on x86, if a driver
submits P2P pages to a PCI device that doesn't have kernel support,
everything will likely just work. Even though the driver isn't doing any
of the work correctly and the requests are not being mapped with
pci_p2pdma_map() functions. Such code on other arches would likely
break. So developers may be lulled into thinking they're doing the
correct thing when in fact they are not and the WARN in the common code
would prevent that.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
