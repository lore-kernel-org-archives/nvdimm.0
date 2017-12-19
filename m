Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A706C2035BA04
 for <linux-nvdimm@lists.01.org>; Tue, 19 Dec 2017 06:59:02 -0800 (PST)
Date: Tue, 19 Dec 2017 16:03:47 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/17] memremap: change devm_memremap_pages interface
 to use struct dev_pagemap
Message-ID: <20171219150347.GC13124@lst.de>
References: <20171215140947.26075-1-hch@lst.de>
 <20171215140947.26075-17-hch@lst.de>
 <CAPcyv4ixo=A949dN4c=LVc6x+Bdk67ERSO8xR5FQwHnL9mxQAw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4ixo=A949dN4c=LVc6x+Bdk67ERSO8xR5FQwHnL9mxQAw@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Dec 17, 2017 at 10:51:56AM -0800, Dan Williams wrote:
> On Fri, Dec 15, 2017 at 6:09 AM, Christoph Hellwig <hch@lst.de> wrote:
> > From: Logan Gunthorpe <logang@deltatee.com>
> >
> > This new interface is similar to how struct device (and many others)
> > work. The caller initializes a 'struct dev_pagemap' as required
> > and calls 'devm_memremap_pages'. This allows the pagemap structure to
> > be embedded in another structure and thus container_of can be used. In
> > this way application specific members can be stored in a containing
> > struct.
> >
> > This will be used by the P2P infrastructure and HMM could probably
> > be cleaned up to use it as well (instead of having it's own, similar
> > 'hmm_devmem_pages_create' function).
> >
> > Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks good, I notice that this does not initialize pgmap->type to
> MEMORY_DEVICE_HOST, but since that value is zero and likely won't
> change we're ok.

I'll add it jut for clarity.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
