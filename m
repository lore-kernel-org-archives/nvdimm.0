Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D86221E082AE
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 17:08:01 -0800 (PST)
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-8-logang@deltatee.com>
 <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
 <20180305160004.GA30975@localhost.localdomain>
 <3f56c76d-6a5c-7c2f-5442-c9209749b598@deltatee.com>
 <CAOSf1CHvaz0QTCkptQwsdyPp6uvvHqtM51N0MfrO9RqYf9W0tg@mail.gmail.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <416d8d27-200f-befb-1c30-14544fffcba0@deltatee.com>
Date: Mon, 5 Mar 2018 18:14:02 -0700
MIME-Version: 1.0
In-Reply-To: <CAOSf1CHvaz0QTCkptQwsdyPp6uvvHqtM51N0MfrO9RqYf9W0tg@mail.gmail.com>
Content-Language: en-US
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage the
 CMB
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
To: Oliver <oohall@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 05/03/18 05:49 PM, Oliver wrote:
> It's in arch/powerpc/kernel/io.c as _memcpy_toio() and it has two full barriers!
> 
> Awesome!
> 
> Our io.h indicates that our iomem accessors are designed to provide x86ish
> strong ordering of accesses to MMIO space. The git log indicates
> arch/powerpc/kernel/io.c has barely been touched in the last decade so
> odds are most of that code was written in the elder days when people
> were less aware of ordering issues. It might just be overly conservative
> by today's standards, but maybe not (see below).

Yes, that seems overly conservative.

> (I'm not going to suggest ditching the lwsync trick. mpe is not going
> to take that patch
> without a really good reason)

Well, that's pretty gross. Is this not exactly the situation mmiowb() is 
meant to solve? See [1].

Though, you're right in principle. Even if power was similar to other 
systems in this way, it's still a risk that if these pages get passed 
somewhere in the kernel that uses a spin lock like that without an 
mmiowb() call, then it's going to have a bug. For now, the risk is 
pretty low as we know exactly where all the p2pmem pages will be used 
but if it gets into other places, all bets are off. I did do some work 
trying to make a safe version of io-pages and also trying to change from 
pages to pfn_t in large areas but neither approach seemed likely to get 
any traction in the community, at least not in the near term.

Logan

[1] ACQUIRES VS I/O ACCESSES in 
https://www.kernel.org/doc/Documentation/memory-barriers.txt

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
