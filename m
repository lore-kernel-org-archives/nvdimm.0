Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22e.google.com (mail-it0-x22e.google.com
 [IPv6:2607:f8b0:4001:c0b::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C8CB5210DA7AF
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 12:11:22 -0700 (PDT)
Received: by mail-it0-x22e.google.com with SMTP id p129-v6so4158244ite.3
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 12:11:22 -0700 (PDT)
Subject: Re: [PATCH v5 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-8-logang@deltatee.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b5ab8fa3-34ac-3117-fa0d-5206c3939435@kernel.dk>
Date: Thu, 30 Aug 2018 13:11:18 -0600
MIME-Version: 1.0
In-Reply-To: <20180830185352.3369-8-logang@deltatee.com>
Content-Language: en-US
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
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 8/30/18 12:53 PM, Logan Gunthorpe wrote:
> QUEUE_FLAG_PCI_P2P is introduced meaning a driver's request queue
> supports targeting P2P memory.
> 
> When a request is submitted we check if PCI P2PDMA memory is assigned
> to the first page in the bio. If it is, we ensure the queue it's
> submitted to supports it, and enforce REQ_NOMERGE.

I think this belongs in the caller - both the validity check, and
passing in NOMERGE for this type of request. I don't want to impose
this overhead on everything, for a pretty niche case.

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
