Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5E51211A6D4C
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 08:41:48 -0700 (PDT)
Date: Mon, 11 Jun 2018 17:41:46 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 10/12] filesystem-dax: Introduce dax_lock_page()
Message-ID: <20180611154146.jc5xt4gyaihq64lm@quack2.suse.cz>
References: <152850182079.38390.8280340535691965744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152850187437.38390.2257981090761438811.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152850187437.38390.2257981090761438811.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri 08-06-18 16:51:14, Dan Williams wrote:
> In preparation for implementing support for memory poison (media error)
> handling via dax mappings, implement a lock_page() equivalent. Poison
> error handling requires rmap and needs guarantees that the page->mapping
> association is maintained / valid (inode not freed) for the duration of
> the lookup.
> 
> In the device-dax case it is sufficient to simply hold a dev_pagemap
> reference. In the filesystem-dax case we need to use the entry lock.
> 
> Export the entry lock via dax_lock_page() that uses rcu_read_lock() to
> protect against the inode being freed, and revalidates the page->mapping
> association under xa_lock().
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Some comments below...

> diff --git a/fs/dax.c b/fs/dax.c
> index cccf6cad1a7a..b7e71b108fcf 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -361,6 +361,82 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
>  	}
>  }
>  
> +struct page *dax_lock_page(unsigned long pfn)
> +{

Why do you return struct page here? Any reason behind that? Because struct
page exists and can be accessed through pfn_to_page() regardless of result
of this function so it looks a bit confusing. Also dax_lock_page() name
seems a bit confusing. Maybe dax_lock_pfn_mapping_entry()?

> +	pgoff_t index;
> +	struct inode *inode;
> +	wait_queue_head_t *wq;
> +	void *entry = NULL, **slot;
> +	struct address_space *mapping;
> +	struct wait_exceptional_entry_queue ewait;
> +	struct page *ret = NULL, *page = pfn_to_page(pfn);
> +
> +	rcu_read_lock();
> +	for (;;) {
> +		mapping = READ_ONCE(page->mapping);
> +
> +		if (!mapping || !IS_DAX(mapping->host))
> +			break;
> +
> +		/*
> +		 * In the device-dax case there's no need to lock, a
> +		 * struct dev_pagemap pin is sufficient to keep the
> +		 * inode alive.
> +		 */
> +		inode = mapping->host;
> +		if (S_ISCHR(inode->i_mode)) {
> +			ret = page;
> +			break;
> +		}
> +
> +		xa_lock_irq(&mapping->i_pages);
> +		if (mapping != page->mapping) {
> +			xa_unlock_irq(&mapping->i_pages);
> +			continue;
> +		}
> +		index = page->index;
> +
> +		init_wait(&ewait.wait);
> +		ewait.wait.func = wake_exceptional_entry_func;

This initialization could be before the loop.

> +
> +		entry = __radix_tree_lookup(&mapping->i_pages, index, NULL,
> +				&slot);
> +		if (!entry ||
> +		    WARN_ON_ONCE(!radix_tree_exceptional_entry(entry))) {
> +			xa_unlock_irq(&mapping->i_pages);
> +			break;
> +		} else if (!slot_locked(mapping, slot)) {
> +			lock_slot(mapping, slot);
> +			ret = page;
> +			xa_unlock_irq(&mapping->i_pages);
> +			break;
> +		}
> +
> +		wq = dax_entry_waitqueue(mapping, index, entry, &ewait.key);
> +		prepare_to_wait_exclusive(wq, &ewait.wait,
> +				TASK_UNINTERRUPTIBLE);
> +		xa_unlock_irq(&mapping->i_pages);
> +		rcu_read_unlock();
> +		schedule();
> +		finish_wait(wq, &ewait.wait);
> +		rcu_read_lock();
> +	}
> +	rcu_read_unlock();

I don't like how this duplicates a lot of get_unlocked_mapping_entry().
Can we possibly factor this out similary as done for wait_event()?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
