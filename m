Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr40059.outbound.protection.outlook.com [40.107.4.59])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4D90212B6D66
 for <linux-nvdimm@lists.01.org>; Sun, 11 Aug 2019 15:58:36 -0700 (PDT)
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 5/5] memremap: provide a not device managed memremap_pages
Date: Sun, 11 Aug 2019 22:56:07 +0000
Message-ID: <20190811225601.GC15116@mellanox.com>
References: <20190811081247.22111-1-hch@lst.de>
 <20190811081247.22111-6-hch@lst.de>
In-Reply-To: <20190811081247.22111-6-hch@lst.de>
Content-Language: en-US
Content-ID: <8D1BA42D29E93F4995158A7AF3F2DFA1@eurprd05.prod.outlook.com>
MIME-Version: 1.0
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bharata B Rao <bharata@linux.ibm.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Aug 11, 2019 at 10:12:47AM +0200, Christoph Hellwig wrote:
> The kvmppc ultravisor code wants a device private memory pool that is
> system wide and not attached to a device.  Instead of faking up one
> provide a low-level memremap_pages for it.  Note that this function is
> not exported, and doesn't have a cleanup routine associated with it to
> discourage use from more driver like users.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>  include/linux/memremap.h |  1 +
>  mm/memremap.c            | 74 ++++++++++++++++++++++++----------------
>  2 files changed, 45 insertions(+), 30 deletions(-)
> 
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 8f0013e18e14..eac23e88a94a 100644
> +++ b/include/linux/memremap.h
> @@ -123,6 +123,7 @@ static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
>  }
>  
>  #ifdef CONFIG_ZONE_DEVICE
> +void *memremap_pages(struct dev_pagemap *pgmap, int nid);
>  void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
>  void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
>  struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 09a087ca30ff..7b7575330db4 100644
> +++ b/mm/memremap.c
> @@ -137,27 +137,12 @@ static void dev_pagemap_percpu_release(struct percpu_ref *ref)
>  	complete(&pgmap->done);
>  }
>  
> -/**
> - * devm_memremap_pages - remap and provide memmap backing for the given resource
> - * @dev: hosting device for @res
> - * @pgmap: pointer to a struct dev_pagemap
> - *
> - * Notes:
> - * 1/ At a minimum the res and type members of @pgmap must be initialized
> - *    by the caller before passing it to this function
> - *
> - * 2/ The altmap field may optionally be initialized, in which case
> - *    PGMAP_ALTMAP_VALID must be set in pgmap->flags.
> - *
> - * 3/ The ref field may optionally be provided, in which pgmap->ref must be
> - *    'live' on entry and will be killed and reaped at
> - *    devm_memremap_pages_release() time, or if this routine fails.
> - *
> - * 4/ res is expected to be a host memory range that could feasibly be
> - *    treated as a "System RAM" range, i.e. not a device mmio range, but
> - *    this is not enforced.
> +/*
> + * This version is not intended for system resources only, and there is no

Was 'is not' what was intended here? I'm having a hard time reading
this.

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
