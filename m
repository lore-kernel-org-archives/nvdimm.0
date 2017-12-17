Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D926022137DAE
 for <linux-nvdimm@lists.01.org>; Sun, 17 Dec 2017 09:29:27 -0800 (PST)
Received: by mail-oi0-x243.google.com with SMTP id x20so9215258oix.12
 for <linux-nvdimm@lists.01.org>; Sun, 17 Dec 2017 09:34:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171215140947.26075-15-hch@lst.de>
References: <20171215140947.26075-1-hch@lst.de>
 <20171215140947.26075-15-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 17 Dec 2017 09:34:11 -0800
Message-ID: <CAPcyv4i2naLJjWzm+q0ORRfyHkT0f5dFBFKutuaXE3OgPcHX5g@mail.gmail.com>
Subject: Re: [PATCH 14/17] memremap: simplify duplicate region handling in
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
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 15, 2017 at 6:09 AM, Christoph Hellwig <hch@lst.de> wrote:
> __radix_tree_insert already checks for duplicates and returns -EEXIST in
> that case, so remove the duplicate (and racy) duplicates check.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  kernel/memremap.c | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index 891491ddccdb..901404094df1 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -395,17 +395,6 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
>         align_end = align_start + align_size - 1;
>
>         foreach_order_pgoff(res, order, pgoff) {
> -               struct dev_pagemap *dup;
> -
> -               rcu_read_lock();
> -               dup = find_dev_pagemap(res->start + PFN_PHYS(pgoff));
> -               rcu_read_unlock();
> -               if (dup) {
> -                       dev_err(dev, "%s: %pr collides with mapping for %s\n",
> -                                       __func__, res, dev_name(dup->dev));
> -                       error = -EBUSY;
> -                       break;
> -               }
>                 error = __radix_tree_insert(&pgmap_radix,
>                                 PHYS_PFN(res->start) + pgoff, order, page_map);
>                 if (error) {


This is not racy, we'll catch the error on insert, and I think the
extra debug information is useful for debugging a broken memory map or
alignment math.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
