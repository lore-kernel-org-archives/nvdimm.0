Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B8052222A54FB
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 00:20:37 -0800 (PST)
Date: Thu, 4 Jan 2018 09:25:40 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 10/18] mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
Message-ID: <20180104082540.GF2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407701384.38751.18357520725643239723.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407701384.38751.18357520725643239723.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, linux-nvdimm@lists.01.org, hch@lst.de, linux-xfs@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

This looks fine except for a few nitpicks below:

>  	}
>  
> +	dev_pagemap_enable_ops();
>  	pgmap->type = MEMORY_DEVICE_FS_DAX;
>  	pgmap->page_free = generic_dax_pagefree;
>  	pgmap->data = owner;
> @@ -215,6 +216,7 @@ void fs_dax_release(struct dax_device *dax_dev, void *owner)
>  	pgmap->type = MEMORY_DEVICE_HOST;
>  	pgmap->page_free = NULL;
>  	pgmap->data = NULL;
> +	dev_pagemap_disable_ops();

should these be get/put instead of enable/disable given that they
implement a refcount?

> +#ifdef CONFIG_DEV_PAGEMAP_OPS
> +void __put_devmap_managed_page(struct page *page);
> +DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
> +static inline bool put_devmap_managed_page(struct page *page)
>  {
> +	if (!static_branch_unlikely(&devmap_managed_key))
> +		return false;
> +	if (!is_zone_device_page(page))
> +		return false;
> +	switch (page->pgmap->type) {
> +	case MEMORY_DEVICE_PRIVATE:
> +	case MEMORY_DEVICE_PUBLIC:
> +	case MEMORY_DEVICE_FS_DAX:
> +		__put_devmap_managed_page(page);
> +		return true;
> +	default:
> +		break;
> +	}
> +	return false;

Should the switch be moved into the out of line version to keep
the inline instructions at a minimum?

> + * pages go idle.
> + */
> +void dev_pagemap_enable_ops(void)
> +{
> +	if (atomic_inc_return(&devmap_enable) == 1)
> +		static_branch_enable(&devmap_managed_key);
> +}
> +EXPORT_SYMBOL(dev_pagemap_enable_ops);

_GPL?

> +EXPORT_SYMBOL(dev_pagemap_disable_ops);

Same.



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
