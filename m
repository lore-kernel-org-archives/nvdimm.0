Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3923D21939308
 for <linux-nvdimm@lists.01.org>; Mon,  3 Apr 2017 16:12:48 -0700 (PDT)
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-6-git-send-email-logang@deltatee.com>
 <20170331070950.GA9059@infradead.org>
 <435d4471-436b-87e6-8827-c9fc6cbdde2c@deltatee.com>
 <445bc352-75d7-438f-96ef-c2411215628d@deltatee.com>
 <CAPcyv4g=MHbjbY0GFPoLq3wAGwhcC7813O7iLUWGEChWh0M7Dw@mail.gmail.com>
 <ff0dd5ec-2562-9f1d-1335-d0a8813f2f50@deltatee.com>
 <CAPcyv4gx4g3Ry_A99yTodqwm2vH72oMSLKAKF7iEsmG5G4TcbQ@mail.gmail.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <22930db3-a194-8b60-5aab-4a8add1ddc55@deltatee.com>
Date: Mon, 3 Apr 2017 17:12:38 -0600
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gx4g3Ry_A99yTodqwm2vH72oMSLKAKF7iEsmG5G4TcbQ@mail.gmail.com>
Subject: Re: [RFC 5/8] scatterlist: Modify SG copy functions to support io
 memory.
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-ID: <linux-nvdimm@lists.01.org>



On 03/04/17 04:47 PM, Dan Williams wrote:
> I wouldn't necessarily conflate supporting pfn_t in the scatterlist
> with the stalled stuct-page-less DMA effor. A pfn_t_to_page()
> conversion will still work and be required. However you're right, the
> minute we use pfn_t for this we're into the realm of special case
> drivers that understand scatterlists with special "I/O-pfn_t" entries.

Well yes, it would certainly be possible to convert the scatterlist code
from page_link to pfn_t. (The only slightly tricky thing is that
scatterlist uses extra chaining bits and pfn_t uses extra flag bits so
they'd have to be harmonized somehow). But if we aren't moving toward
struct-page-less DMA, I fail to see the point of the conversion.

I'll definitely need IO scatterlists of some form or another and I like
pfn_t but right now it just seems like extra work with unclear benefit.
(Though, if someone told me that I can't use a third bit in the
page_link field then maybe that would be a good reason to move to pfn_t.)

> However, maybe that's what we want? I think peer-to-peer DMA is not a
> general purpose feature unless/until we get it standardized in PCI. So
> maybe drivers with special case scatterlist support is exactly what we
> want for now.

Well, I think this should be completely independent from PCI code. I see
no reason why we can't have infrastructure for DMA on iomem from any
bus. Largely all the work I've done in this area is completely agnostic
to the bus in use. (Except for any kind of white/black list when it is
used.)

The "special case scatterlist" is essentially what I'm proposing in the
patch I sent upthread, it just stores the flag in the page_link instead
of in a pfn_t.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
