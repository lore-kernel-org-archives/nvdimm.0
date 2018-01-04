Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6317121F833AB
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 03:07:35 -0800 (PST)
Date: Thu, 4 Jan 2018 12:12:33 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 17/18] mm, fs, dax: dax_flush_dma, handle dma vs
 block-map-change collisions
Message-ID: <20180104111233.GD29010@quack2.suse.cz>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407705124.38751.12934858054023659736.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407705124.38751.12934858054023659736.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, Matthew Wilcox <mawilcox@microsoft.com>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, hch@lst.de, linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, "Darrick J. Wong" <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sat 23-12-17 16:57:31, Dan Williams wrote:
> +static struct page *dma_busy_page(void *entry)
> +{
> +	unsigned long pfn, end_pfn;
> +
> +	for_each_entry_pfn(entry, pfn, end_pfn) {
> +		struct page *page = pfn_to_page(pfn);
> +
> +		if (page_ref_count(page) > 1)
> +			return page;
> +	}
> +	return NULL;
> +}
> +
>  /*
>   * Find radix tree entry at given index. If it points to an exceptional entry,
>   * return it with the radix tree entry locked. If the radix tree doesn't
> @@ -557,6 +570,87 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
>  	return entry;
>  }
>  
> +int dax_flush_dma(struct address_space *mapping, wait_atomic_t_action_f action)

I don't quite like the 'dma' terminology when this is all about page
references in fact. How about renaming like dma_busy_page() ->
devmap_page_referenced() instead and dax_flush_dma() -> dax_wait_pages_unused()
or something like that?

> +{
> +	pgoff_t	indices[PAGEVEC_SIZE];
> +	struct pagevec pvec;
> +	pgoff_t	index, end;
> +	unsigned i;
> +
> +	/* in the limited case get_user_pages for dax is disabled */
> +	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
> +		return 0;
> +
> +	if (!dax_mapping(mapping))
> +		return 0;
> +
> +	if (mapping->nrexceptional == 0)
> +		return 0;
> +
> +retry:
> +	pagevec_init(&pvec);
> +	index = 0;
> +	end = -1;
> +	unmap_mapping_range(mapping, 0, 0, 1);

unmap_mapping_range() would be IMHO be more logical in the callers. Maybe
a cleaner API would be like providing a function
dax_find_referenced_page(mapping) which either returns NULL or a page that
has elevated refcount. Filesystem can then drop locks it needs to and call
wait_on_atomic_one() (possibly hidden in a DAX helper). When wait finishes,
filesystem can do the retry. That way the whole lock, unlock, wait, retry
logic is clearly visible in fs code, there's no need of 'action' function
or propagation of locking state etc.

> +	/*
> +	 * Flush dax_dma_lock() sections to ensure all possible page
> +	 * references have been taken, or will block on the fs
> +	 * 'mmap_lock'.
> +	 */
> +	synchronize_rcu();

Frankly, I don't like synchronize_rcu() in a relatively hot path like this.
Cannot we just abuse get_dev_pagemap() to fail if truncation is in progress
for the pfn? We could indicate that by some bit in struct page or something
like that.

> +	while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
> +				min(end - index, (pgoff_t)PAGEVEC_SIZE),
> +				indices)) {
> +		int rc = 0;
> +
> +		for (i = 0; i < pagevec_count(&pvec); i++) {
> +			struct page *pvec_ent = pvec.pages[i];
> +			struct page *page = NULL;
> +			void *entry;
> +
> +			index = indices[i];
> +			if (index >= end)
> +				break;
> +
> +			if (!radix_tree_exceptional_entry(pvec_ent))
> +				continue;

This would be a bug so I'm not sure we need to handle that.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
