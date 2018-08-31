Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3ADC82110BD6C
 for <linux-nvdimm@lists.01.org>; Fri, 31 Aug 2018 09:26:24 -0700 (PDT)
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-2-logang@deltatee.com>
 <20180831171906.00002751@huawei.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <a1f6e2d9-8b7d-10ae-5963-50b447cacb44@deltatee.com>
Date: Fri, 31 Aug 2018 10:26:08 -0600
MIME-Version: 1.0
In-Reply-To: <20180831171906.00002751@huawei.com>
Content-Language: en-US
Subject: Re: [PATCH v5 01/13] PCI/P2PDMA: Support peer-to-peer memory
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
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 31/08/18 10:19 AM, Jonathan Cameron wrote:
> This feels like a somewhat simplistic starting point rather than a
> generally correct estimate to use.  Should we be taking the bandwidth of
> those links into account for example, or any discoverable latencies?
> Not all PCIe switches are alike - particularly when it comes to P2P.

I don't think this is necessary. There won't typically be a ton of
choice in terms of devices to use and if there is, the hardware will
probably be fairly homogenous. For example, it would be unusual to have
an NVMe drive on a x4 and another one on an x8. Or mixing say Gen3
switches with Gen4 would also be very strange. In weird unusual cases
like this where the user specifically wants to use a faster device they
can specify the specific device in the configfs interface.

I think the latency would probably be proportional to the distance which
is what we are already using.

> I guess that can be a topic for future development if it turns out people
> have horrible mixed systems.

Yup!

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
