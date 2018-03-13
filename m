Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D1F3121E4902B
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 12:04:29 -0700 (PDT)
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-2-logang@deltatee.com>
 <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
 <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
 <52cbbbc4-c488-f83f-8d02-14d455b4efd7@codeaurora.org>
 <3e738f95-d73c-4182-2fa1-8664aafb1ab7@deltatee.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <703aa92c-0c1c-4852-5887-6f6e6ccde0fb@codeaurora.org>
Date: Tue, 13 Mar 2018 15:10:48 -0400
MIME-Version: 1.0
In-Reply-To: <3e738f95-d73c-4182-2fa1-8664aafb1ab7@deltatee.com>
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

On 3/13/2018 2:44 PM, Logan Gunthorpe wrote:
>> Do you think you can keep a pointer to the parent bridge instead of querying it
>> via get_upstream_bridge_port() here so that we can reuse your
>> pci_p2pdma_disable_acs() in the future.
> 
> Keep a pointer where? pci_p2pdma_disable_acs() and pci_p2pdma_add_client() are used in completely different cases on completely different devices. There really is no overlap and no obvious place to store the port pointer (except in the struct pci_dev itself, in which case why not just call the function again).

I was thinking of this for the pci_p2pdma_add_client() case for the
parent pointer.

+struct pci_p2pdma_client {
+	struct list_head list;
+	struct pci_dev *client;
+	struct pci_dev *provider;
+};

You are right second code seems to be there to disable ACS altogether
when this kernel configuration is selected.

It doesn't have any relationship to the client code.

But then, Why bother searching for the switch at all?

Even if the switch is there, there is no guarantee that it is currently
being used for P2P.

It seems that we are going with the assumption that enabling this config
option implies you want P2P, then we can simplify this code as well.

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
