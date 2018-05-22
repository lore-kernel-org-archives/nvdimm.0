Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E9381203B85B8
 for <linux-nvdimm@lists.01.org>; Tue, 22 May 2018 14:28:35 -0700 (PDT)
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-7-logang@deltatee.com>
 <59b7762e-6d38-7746-20f3-22fd762ecfe7@infradead.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <9e20024d-8b32-61ff-4b9a-c9392082987f@deltatee.com>
Date: Tue, 22 May 2018 15:28:19 -0600
MIME-Version: 1.0
In-Reply-To: <59b7762e-6d38-7746-20f3-22fd762ecfe7@infradead.org>
Content-Language: en-US
Subject: Re: [PATCH v4 06/14] PCI/P2PDMA: Add P2P DMA driver writer's
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
Cc: Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Jonathan Corbet <corbet@lwn.net>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Thanks for the review Randy! I'll make the changes for the next time we
post the series.

On 22/05/18 03:24 PM, Randy Dunlap wrote:
>> +The first task an orchestrator driver must do is compile a list of
>> +all client drivers that will be involved in a given transaction. For
>> +example, the NVMe Target driver creates a list including all NVMe drives
>                                                                      ^^^^^^
>                                                                    or drivers ?
> Could be either, I guess, but the previous sentence says "compile a list of drivers."

I did mean "drives". But perhaps "devices" would be more clear. A list
of all NVMe drivers doesn't make much sense as I'm pretty sure there is
only one NVMe driver.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
