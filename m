Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AD7312193930D
 for <linux-nvdimm@lists.01.org>; Mon,  3 Apr 2017 17:07:57 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id d2so12544553oig.1
 for <linux-nvdimm@lists.01.org>; Mon, 03 Apr 2017 17:07:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <22930db3-a194-8b60-5aab-4a8add1ddc55@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-6-git-send-email-logang@deltatee.com>
 <20170331070950.GA9059@infradead.org>
 <435d4471-436b-87e6-8827-c9fc6cbdde2c@deltatee.com>
 <445bc352-75d7-438f-96ef-c2411215628d@deltatee.com>
 <CAPcyv4g=MHbjbY0GFPoLq3wAGwhcC7813O7iLUWGEChWh0M7Dw@mail.gmail.com>
 <ff0dd5ec-2562-9f1d-1335-d0a8813f2f50@deltatee.com>
 <CAPcyv4gx4g3Ry_A99yTodqwm2vH72oMSLKAKF7iEsmG5G4TcbQ@mail.gmail.com>
 <22930db3-a194-8b60-5aab-4a8add1ddc55@deltatee.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 3 Apr 2017 17:07:55 -0700
Message-ID: <CAPcyv4gL=Z42x52So1iL-MNhPY67Pktz3c0J_h0tj_60TowNuQ@mail.gmail.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 3, 2017 at 4:12 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
> On 03/04/17 04:47 PM, Dan Williams wrote:
>> I wouldn't necessarily conflate supporting pfn_t in the scatterlist
>> with the stalled stuct-page-less DMA effor. A pfn_t_to_page()
>> conversion will still work and be required. However you're right, the
>> minute we use pfn_t for this we're into the realm of special case
>> drivers that understand scatterlists with special "I/O-pfn_t" entries.
>
> Well yes, it would certainly be possible to convert the scatterlist code
> from page_link to pfn_t. (The only slightly tricky thing is that
> scatterlist uses extra chaining bits and pfn_t uses extra flag bits so
> they'd have to be harmonized somehow). But if we aren't moving toward
> struct-page-less DMA, I fail to see the point of the conversion.
>
> I'll definitely need IO scatterlists of some form or another and I like
> pfn_t but right now it just seems like extra work with unclear benefit.
> (Though, if someone told me that I can't use a third bit in the
> page_link field then maybe that would be a good reason to move to pfn_t.)
>
>> However, maybe that's what we want? I think peer-to-peer DMA is not a
>> general purpose feature unless/until we get it standardized in PCI. So
>> maybe drivers with special case scatterlist support is exactly what we
>> want for now.
>
> Well, I think this should be completely independent from PCI code. I see
> no reason why we can't have infrastructure for DMA on iomem from any
> bus. Largely all the work I've done in this area is completely agnostic
> to the bus in use. (Except for any kind of white/black list when it is
> used.)

The completely agnostic part is where I get worried, but I shouldn't
say anymore until I actually read the patch.The worry is cases where
this agnostic enabling allows unsuspecting code paths to do the wrong
thing. Like bypass iomem safety.

> The "special case scatterlist" is essentially what I'm proposing in the
> patch I sent upthread, it just stores the flag in the page_link instead
> of in a pfn_t.

Makes sense. The suggestion of pfn_t was to try to get more type
safety throughout the stack. So that, again, unsuspecting code paths
that get an I/O pfn aren't able to do things like page_address() or
kmap() without failing.

I'll stop commenting now and set aside some time to go read the patches.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
