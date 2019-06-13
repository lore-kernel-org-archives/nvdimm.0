Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4EBD321281EDF
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jun 2019 13:13:53 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id j19so446089otq.2
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jun 2019 13:13:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-10-hch@lst.de>
 <20190613193427.GU22062@mellanox.com>
In-Reply-To: <20190613193427.GU22062@mellanox.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 13 Jun 2019 13:13:41 -0700
Message-ID: <CAPcyv4iwVPm2XBviR8E32VJG+ZZTHZLGxDdXS3et22CTT_3qNA@mail.gmail.com>
Subject: Re: [PATCH 09/22] memremap: lift the devmap_enable manipulation into
 devm_memremap_pages
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
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 12:35 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Thu, Jun 13, 2019 at 11:43:12AM +0200, Christoph Hellwig wrote:
> > Just check if there is a ->page_free operation set and take care of the
> > static key enable, as well as the put using device managed resources.
> > diff --git a/mm/hmm.c b/mm/hmm.c
> > index c76a1b5defda..6dc769feb2e1 100644
> > +++ b/mm/hmm.c
> > @@ -1378,8 +1378,6 @@ struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
> >       void *result;
> >       int ret;
> >
> > -     dev_pagemap_get_ops();
> > -
>
> Where was the matching dev_pagemap_put_ops() for this hmm case? This
> is a bug fix too?
>

It never existed. HMM turned on the facility and made everyone's
put_page() operations slower regardless of whether HMM was in active
use.

> The nouveau driver is the only one to actually call this hmm function
> and it does it as part of a probe function.
>
> Seems reasonable, however, in the unlikely event that it fails to init
> 'dmem' the driver will retain a dev_pagemap_get_ops until it unloads.
> This imbalance doesn't seem worth worrying about.

Right, unless/until the overhead of checking for put_page() callbacks
starts to hurt leaving pagemap_ops tied to lifetime of the driver load
seems acceptable because who unbinds their GPU device at runtime? On
the other hand it was simple enough for the pmem driver to drop the
reference each time a device was unbound just to close the loop.

>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

...minor typo.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
