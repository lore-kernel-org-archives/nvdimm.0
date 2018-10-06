Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com
 [IPv6:2607:f8b0:4864:20::42c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1B8E92194D3AE
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 18:16:09 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id s5-v6so5819043pfj.7
 for <linux-nvdimm@lists.01.org>; Fri, 05 Oct 2018 18:16:09 -0700 (PDT)
Subject: Re: [PATCH v9 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
References: <20181004212747.6301-1-logang@deltatee.com>
 <20181004212747.6301-8-logang@deltatee.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <485de371-0e84-6f20-7f3b-cec5635b87fe@kernel.dk>
Date: Fri, 5 Oct 2018 19:16:04 -0600
MIME-Version: 1.0
In-Reply-To: <20181004212747.6301-8-logang@deltatee.com>
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

On 10/4/18 3:27 PM, Logan Gunthorpe wrote:
> QUEUE_FLAG_PCI_P2P is introduced meaning a driver's request queue
> supports targeting P2P memory. This will be used by P2P providers and
> orchestrators (in subsequent patches) to ensure block devices can
> support P2P memory before submitting P2P backed pages to submit_bio().

Nit pick, but the subject line still says that it checks support
for requests. This patch just adds the ability to flag support
in the queue.

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
