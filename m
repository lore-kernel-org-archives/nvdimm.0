Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 07DCD2249272D
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 09:04:43 -0800 (PST)
References: <20180228234006.21093-11-logang@deltatee.com>
 <749e3752-4349-0bdf-5243-3d510c2b26db@grimberg.me>
 <40d69074-31a8-d06a-ade9-90de7712c553@deltatee.com>
 <5649098f-b775-815b-8b9a-f34628873ff4@grimberg.me>
 <20180301184249.GI19007@ziepe.ca>
 <edaf476a-cfe9-0598-1aa5-14802a9a1477@deltatee.com>
 <20180301224540.GL19007@ziepe.ca>
 <77591162-4CCD-446E-A27C-1CDB4996ACB7@raithlin.com>
 <20180301234930.GG14799@localhost.localdomain>
 <CE2A5D93-E735-4414-8DC1-B308B74A1C5B@raithlin.com>
 <20180302161842.GB14861@ziepe.ca>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <a9e2eb46-50ff-e8c6-3b00-a297876c190b@deltatee.com>
Date: Fri, 2 Mar 2018 10:10:31 -0700
MIME-Version: 1.0
In-Reply-To: <20180302161842.GB14861@ziepe.ca>
Content-Language: en-US
Subject: Re: [PATCH v2 10/10] nvmet: Optionally use PCI P2P memory
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
To: Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 02/03/18 09:18 AM, Jason Gunthorpe wrote:

> This allocator is already seems not useful for the P2P target memory
> on a Mellanox NIC due to the way it has a special allocation flow
> (windowing) and special usage requirements..
> 
> Nor can it be usefull for the doorbell memory in the NIC.

No one says every P2P use has to use P2P memory. Doorbells are obviously 
not P2P memory. But it's the p2mem interface that's important and the 
interface absolutely does not belong in the NVMe driver. Once you have 
the P2P memory interface you need an allocator behind it and the obvious 
place is in the P2P code to handle the common case where you're just 
mapping a BAR. We don't need to implement a genalloc in every driver 
that has P2P memory attached with it. If some hardware wants to expose 
memory that requires complicated allocation it's up to them to solve 
that problem but that isn't enough justification, to me, to push common 
code into every driver.

> Both of these are existing use cases for P2P with out of tree patches..

And we have out of tree code that uses the generic allocator part of 
p2pmem.

> The allocator seems to only be able to solve the CMB problem, and I
> think due to that it is better to put this allocator in the NVMe
> driver and not the core code.. At least until we find a 2nd user that
> needs the same allocation scheme...

See the first P2PMEM RFC. We used Chelsio's NIC instead of the CMB with 
a very similar allocation scheme. We'd still be enabling that NIC in the 
same way if we didn't run into hardware issues with it. A simple BAR 
with memory behind it is always going to be the most common case.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
