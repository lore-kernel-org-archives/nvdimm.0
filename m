Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4759F22546BA6
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 13:51:18 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <CAPcyv4h7mcFphv3j_vW-CGxXa2pjQgLqpBOLzHuTzAFzygai-Q@mail.gmail.com>
 <1519936477.4592.23.camel@au1.ibm.com>
 <CAPcyv4goHsYytq60ehJUori8Xq+Z0p8dV-8_oRALj244H4YtwQ@mail.gmail.com>
 <2079ba48-5ae5-5b44-cce1-8175712dd395@deltatee.com>
Message-ID: <43ba615f-a6e1-9444-65e1-494169cb415d@deltatee.com>
Date: Thu, 1 Mar 2018 14:57:06 -0700
MIME-Version: 1.0
In-Reply-To: <2079ba48-5ae5-5b44-cce1-8175712dd395@deltatee.com>
Content-Language: en-US
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, benh@au1.ibm.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Oliver OHalloran <oliveroh@au1.ibm.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 01/03/18 02:45 PM, Logan Gunthorpe wrote:
> It handles it fine for many situations. But when you try to map 
> something that is at the end of the physical address space then the 
> spares-vmemmap needs virtual address space that's the size of the 
> physical address space divided by PAGE_SIZE which may be a little bit 
> too large...

Though, considering this more, maybe this shouldn't be a problem...

Lets say you have 56bits of address space. That's 64PB. If you use need 
a sparse vmemmap for the entire space it will take 16TB which leaves you 
with 63.98PB of address space left. (Similar calculations for other 
numbers of address bits.)

So I'm not sure what the problem with this is.

We still have to ensure all the arches map the memory with the right 
cache bits but that should be relatively easy to solve.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
