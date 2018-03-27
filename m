Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 358AC225E964E
 for <linux-nvdimm@lists.01.org>; Tue, 27 Mar 2018 08:31:22 -0700 (PDT)
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-2-logang@deltatee.com>
 <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
 <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
 <20180326121138.00005e30@huawei.com>
 <20180326140118.GA221690@bhelgaas-glaptop.roam.corp.google.com>
 <c717eb06-1e83-f0f3-4d6c-15531aa808e0@deltatee.com>
 <20180327094701.0000300d@huawei.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <27171a6c-0e0b-4b2b-16ef-38bb3cf563a8@deltatee.com>
Date: Tue, 27 Mar 2018 09:37:37 -0600
MIME-Version: 1.0
In-Reply-To: <20180327094701.0000300d@huawei.com>
Content-Language: en-US
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
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
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, Eric Wehage <Eric.Wehage@huawei.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 27/03/18 02:47 AM, Jonathan Cameron wrote:
> I'll see if I can get our PCI SIG people to follow this through and see if
> it is just an omission or as Bjorn suggested, there is some reason we
> aren't thinking of that makes it hard.

That would be great! Thanks!

Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
