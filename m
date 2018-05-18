Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B865207E6360
 for <linux-nvdimm@lists.01.org>; Fri, 18 May 2018 02:41:34 -0700 (PDT)
Date: Fri, 18 May 2018 11:46:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v10] mm: introduce MEMORY_DEVICE_FS_DAX and
 CONFIG_DEV_PAGEMAP_OPS
Message-ID: <20180518094616.GA25838@lst.de>
References: <152658753673.26786.16458605771414761966.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152658753673.26786.16458605771414761966.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, Thomas Meyer <thomas@m3y3r.de>
List-ID: <linux-nvdimm@lists.01.org>

This looks reasonable to me.  A few more comments below.

> This patch replaces and consolidates patch 2 [1] and 4 [2] from the v9
> series [3] for "dax: fix dma vs truncate/hole-punch".

Can you repost the whole series?  Otherwise things might get a little
too confusing.

>  		WARN_ON(IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API));
> +		return 0;
>  	} else if (pfn_t_devmap(pfn)) {
> +		struct dev_pagemap *pgmap;

This should probably become something like:

	bool supported = false;

	...


	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn)) {
		...
		supported = true;
	} else if (pfn_t_devmap(pfn)) {
		pgmap = get_dev_pagemap(pfn_t_to_pfn(pfn), NULL);
		if (pgmap && pgmap->type == MEMORY_DEVICE_FS_DAX)
			supported = true;
		put_dev_pagemap(pgmap);
	}

	if (!supported) {
		pr_debug("VFS (%s): error: dax support not enabled\n",
			sb->s_id);
		return -EOPNOTSUPP;
	}
	return 0;

> +	select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)

Btw, what was the reason again we couldn't get rid of FS_DAX_LIMITED?

> +void generic_dax_pagefree(struct page *page, void *data)
> +{
> +	wake_up_var(&page->_refcount);
> +}
> +EXPORT_SYMBOL_GPL(generic_dax_pagefree);

Why is this here and exported instead of static in drivers/nvdimm/pmem.c?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
