Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB31F224872BC
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 10:43:23 -0700 (PDT)
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-2-logang@deltatee.com>
 <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
 <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <52cbbbc4-c488-f83f-8d02-14d455b4efd7@codeaurora.org>
Date: Tue, 13 Mar 2018 13:49:41 -0400
MIME-Version: 1.0
In-Reply-To: <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
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

On 3/13/2018 12:43 PM, Logan Gunthorpe wrote:
> 
> 
> On 12/03/18 09:28 PM, Sinan Kaya wrote:
>> On 3/12/2018 3:35 PM, Logan Gunthorpe wrote:
>> Regarding the switch business, It is amazing how much trouble you went into
>> limit this functionality into very specific hardware.
>>
>> I thought that we reached to an agreement that code would not impose
>> any limits on what user wants.
>>
>> What happened to all the emails we exchanged?
> 
> It turns out that root ports that support P2P are far less common than anyone thought. So it will likely have to be a white list. Nobody else seems keen on allowing the user to enable this on hardware that doesn't work. The easiest solution is still limiting it to using a switch. From there, if someone wants to start creating a white-list then that's probably the way forward to support root ports.

I thought only few root ports had problem. Thanks for clarifying that.

> 
> And there's also the ACS problem which means if you want to use P2P on the root ports you'll have to disable ACS on the entire system. (Or preferably, the IOMMU groups need to get more sophisticated to allow for dynamic changes).
> 

Do you think you can keep a pointer to the parent bridge instead of querying it
via get_upstream_bridge_port() here so that we can reuse your
pci_p2pdma_disable_acs() in the future.

+int pci_p2pdma_disable_acs(struct pci_dev *pdev)
+{
+	struct pci_dev *up;
+	int pos;
+	u16 ctrl;
+
+	up = get_upstream_bridge_port(pdev);
+	if (!up)
+		return 0;

Some future device would only deal with pci_p2pdma_add_client(() for whitelisting
instead of changing all of your code.

We should at least limit the usage of get_upstream_bridge_port() family of functions
to probe time only.

> Additionally, once you allow for root ports you may find the IOMMU getting in the way.

We can tell iommu to do one to one translation by passing iommu.passthrough=1 to kernel
command line to have identical behavior to your switch case.

> 
> So there are great deal more issues to sort out if you don't restrict to devices behind switches.
> 
> Logan
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
