Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x244.google.com (mail-ot0-x244.google.com
 [IPv6:2607:f8b0:4003:c0f::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A88722212BE2
 for <linux-nvdimm@lists.01.org>; Sun, 17 Dec 2017 09:24:06 -0800 (PST)
Received: by mail-ot0-x244.google.com with SMTP id q3so11628598oth.2
 for <linux-nvdimm@lists.01.org>; Sun, 17 Dec 2017 09:28:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171215140947.26075-13-hch@lst.de>
References: <20171215140947.26075-1-hch@lst.de>
 <20171215140947.26075-13-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 17 Dec 2017 09:28:49 -0800
Message-ID: <CAPcyv4gTnFzT0a5Q3XrLRWjNzc5QtBq3Pypwxz2hsar5b+17hg@mail.gmail.com>
Subject: Re: [PATCH 12/17] mm: optimize dev_pagemap reference counting around
 get_dev_pagemap
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
> Change the calling convention so that get_dev_pagemap always consumes the
> previous reference instead of doing this using an explicit earlier call to
> put_dev_pagemap in the callers.
>
> The callers will still need to put the final reference after finishing the
> loop over the pages.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  kernel/memremap.c | 17 +++++++++--------
>  mm/gup.c          |  7 +++++--
>  2 files changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index 43d94db97ff4..26764085785d 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -506,22 +506,23 @@ struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start)
>   * @pfn: page frame number to lookup page_map
>   * @pgmap: optional known pgmap that already has a reference
>   *
> - * @pgmap allows the overhead of a lookup to be bypassed when @pfn lands in the
> - * same mapping.
> + * If @pgmap is non-NULL and covers @pfn it will be returned as-is.  If @pgmap
> + * is non-NULL but does not cover @pfn the reference to it while be released.

s/while/will/


Other than that you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
