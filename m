Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B3E59210DA7AF
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 12:17:53 -0700 (PDT)
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-8-logang@deltatee.com>
 <b5ab8fa3-34ac-3117-fa0d-5206c3939435@kernel.dk>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <7c5b9d2c-d94e-582c-f1d7-0827dbb7df7c@deltatee.com>
Date: Thu, 30 Aug 2018 13:17:40 -0600
MIME-Version: 1.0
In-Reply-To: <b5ab8fa3-34ac-3117-fa0d-5206c3939435@kernel.dk>
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
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 30/08/18 01:11 PM, Jens Axboe wrote:
> On 8/30/18 12:53 PM, Logan Gunthorpe wrote:
>> QUEUE_FLAG_PCI_P2P is introduced meaning a driver's request queue
>> supports targeting P2P memory.
>>
>> When a request is submitted we check if PCI P2PDMA memory is assigned
>> to the first page in the bio. If it is, we ensure the queue it's
>> submitted to supports it, and enforce REQ_NOMERGE.
> 
> I think this belongs in the caller - both the validity check, and
> passing in NOMERGE for this type of request. I don't want to impose
> this overhead on everything, for a pretty niche case.

Well, the point was to prevent driver writers from doing the wrong
thing. The WARN_ON would be a bit pointless in the driver if we rely on
the driver to either do the right thing or add the WARN_ON themselves.

If I'm going to change anything I'd drop the warning entirely and move
the NO_MERGE back into the caller...

Note: the check will be compiled out if the kernel does not support PCI P2P.

Logan


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
