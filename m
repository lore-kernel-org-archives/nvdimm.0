Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1126F21A04817
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 10:59:34 -0700 (PDT)
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-6-git-send-email-logang@deltatee.com>
 <20170331070950.GA9059@infradead.org>
 <435d4471-436b-87e6-8827-c9fc6cbdde2c@deltatee.com>
 <445bc352-75d7-438f-96ef-c2411215628d@deltatee.com>
 <CAPcyv4g=MHbjbY0GFPoLq3wAGwhcC7813O7iLUWGEChWh0M7Dw@mail.gmail.com>
 <ff0dd5ec-2562-9f1d-1335-d0a8813f2f50@deltatee.com>
 <CAPcyv4gx4g3Ry_A99yTodqwm2vH72oMSLKAKF7iEsmG5G4TcbQ@mail.gmail.com>
 <22930db3-a194-8b60-5aab-4a8add1ddc55@deltatee.com>
 <CAPcyv4gL=Z42x52So1iL-MNhPY67Pktz3c0J_h0tj_60TowNuQ@mail.gmail.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <6206d74b-b2e2-f1f7-5a9d-60f20d837374@deltatee.com>
Date: Fri, 7 Apr 2017 11:59:20 -0600
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gL=Z42x52So1iL-MNhPY67Pktz3c0J_h0tj_60TowNuQ@mail.gmail.com>
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

Hi Dan,

On 03/04/17 06:07 PM, Dan Williams wrote:
> The completely agnostic part is where I get worried, but I shouldn't
> say anymore until I actually read the patch.The worry is cases where
> this agnostic enabling allows unsuspecting code paths to do the wrong
> thing. Like bypass iomem safety.

Yup, you're right the iomem safety issue is a really difficult problem.
I think replacing struct page with pfn_t in a bunch of places is
probably going to be a requirement for my work. However, this is going
to be a very large undertaking.

I've done an audit of sg_page users and there will indeed be some
difficult cases. However, I'm going to start doing some cleanup and
semantic changes to hopefully move in that direction. The first step
I've chosen to look at is to create an sg_kmap interface which replaces
about 77 (out of ~340) sg_page users. I'm hoping the new interface can
have the semantic that sg_kmap can fail (which would happen in the case
that no suitable page exists).

Eventually, I'd want to get to a place where sg_page either doesn't
exists or can fail and is always checked. At that point swapping out
pfn_t in the sgl would be manageable.

Thoughts?

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
