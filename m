Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE65F22487299
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 20:22:00 -0700 (PDT)
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-2-logang@deltatee.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
Date: Mon, 12 Mar 2018 23:28:17 -0400
MIME-Version: 1.0
In-Reply-To: <20180312193525.2855-2-logang@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 3/12/2018 3:35 PM, Logan Gunthorpe wrote:
> +int pci_p2pdma_add_client(struct list_head *head, struct device *dev)

It feels like code tried to be a generic p2pdma provider first. Then got
converted to PCI, yet all dev parameters are still struct device.

Maybe, dev parameter should also be struct pci_dev so that you can get rid of
all to_pci_dev() calls in this code including find_parent_pci_dev() function.

Regarding the switch business, It is amazing how much trouble you went into
limit this functionality into very specific hardware.

I thought that we reached to an agreement that code would not impose
any limits on what user wants.

What happened to all the emails we exchanged?

I understand you are coming from what you tested. Considering that you
are singing up for providing a generic PCI functionality into the kernel,
why don't you just blacklist the products that you had problems with and
yet still allow other architectures to use your code with their root ports?

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
