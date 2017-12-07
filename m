Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DDD14221EA0C8
 for <linux-nvdimm@lists.01.org>; Thu,  7 Dec 2017 11:48:52 -0800 (PST)
References: <20171207150840.28409-1-hch@lst.de>
 <20171207150840.28409-15-hch@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <6260792f-cf6f-6b98-75a5-9e174107571a@deltatee.com>
Date: Thu, 7 Dec 2017 12:53:24 -0700
MIME-Version: 1.0
In-Reply-To: <20171207150840.28409-15-hch@lst.de>
Content-Language: en-US
Subject: Re: [PATCH 14/14] memremap: RCU protect data returned from
 dev_pagemap lookups
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
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 07/12/17 08:08 AM, Christoph Hellwig wrote:
> Take the RCU critical sections into the callers of to_vmem_altmap so that
> we can read the page map inside the critical section.  Also rename the
> remaining helper to __lookup_dev_pagemap to fit into the current naming
> scheme.
I'm not saying I disagree, but what's the reasoning behind the double 
underscore prefix to the function?

> +struct dev_pagemap *__lookup_dev_pagemap(struct page *start_page)
> +{
> +	struct dev_pagemap *pgmap;
> +
> +	pgmap = radix_tree_lookup(&pgmap_radix, page_to_pfn(start_page));
> +	if (!pgmap || !pgmap->base_pfn)
> +		return NULL;
> +	return pgmap;
> +}

I'm also wondering why we are still looking up the dev_pagemap via the 
radix tree when struct page already has a pointer to it (page->pgmap).

Thanks,

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
