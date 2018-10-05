Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 760FB21959CB2
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 08:39:57 -0700 (PDT)
References: <20181004212747.6301-1-logang@deltatee.com>
 <20181004212747.6301-12-logang@deltatee.com> <20181005071044.GB23834@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <4f844956-fe91-0ace-4f8e-4da3a747e593@deltatee.com>
Date: Fri, 5 Oct 2018 09:39:36 -0600
MIME-Version: 1.0
In-Reply-To: <20181005071044.GB23834@lst.de>
Content-Language: en-CA
Subject: Re: [PATCH v9 11/13] nvme-pci: Add a quirk for a pseudo CMB
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>



On 2018-10-05 1:10 a.m., Christoph Hellwig wrote:
> On Thu, Oct 04, 2018 at 03:27:45PM -0600, Logan Gunthorpe wrote:
>> Introduce a quirk to use CMB-like memory on older devices that have
>> an exposed BAR but do not advertise support for using CMBLOC and
>> CMBSIZE.
>>
>> We'd like to use some of these older cards to test P2P memory.
> 
> I can't sat that I really like adding support for non-standardized
> "features" (vs bugs) in the nvme driver.
> 

I can live with this patch being dropped.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
