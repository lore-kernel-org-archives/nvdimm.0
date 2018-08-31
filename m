Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD3922110BD74
 for <linux-nvdimm@lists.01.org>; Fri, 31 Aug 2018 08:45:12 -0700 (PDT)
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-7-logang@deltatee.com>
 <382af881-0ae1-0274-4628-0137071125b1@infradead.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <f0edec85-02d1-4592-5bce-629fb5e0ceae@deltatee.com>
Date: Fri, 31 Aug 2018 09:44:53 -0600
MIME-Version: 1.0
In-Reply-To: <382af881-0ae1-0274-4628-0137071125b1@infradead.org>
Content-Language: en-US
Subject: Re: [PATCH v5 06/13] PCI/P2PDMA: Add P2P DMA driver writer's
 documentation
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
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Jonathan Corbet <corbet@lwn.net>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hey,

Thanks for the review. I'll make the fixes for the next version.

On 30/08/18 06:34 PM, Randy Dunlap wrote:
>> +With the client list in hand, the orchestrator may then call> +:c:func:`pci_p2pmem_find()` to obtain a published P2P memory provider
>> +that is supported (behind the same root port) as all the clients. If more
>> +than one provider is supported, the one nearest to all the clients will
>> +be chosen first. If there are more than one provider is an equal distance
>> +away, the one returned will be chosen at random. This function returns the PCI
> 
> random or just arbitrarily?

Randomly. See pci_p2pmem_find() in patch 1. We use prandom_u32_max() to
select any of the supported devices.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
