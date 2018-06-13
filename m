Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 55B6621191F2A
 for <linux-nvdimm@lists.01.org>; Wed, 13 Jun 2018 03:41:17 -0700 (PDT)
Date: Wed, 13 Jun 2018 12:41:13 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v11 4/7] mm, fs, dax: handle layout changes to pinned dax
 mappings
Message-ID: <20180613104113.zkz4yqpwkccr7nn6@quack2.suse.cz>
References: <152669369110.34337.14271778212195820353.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152669371377.34337.10697370528066177062.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180612210536.GA15998@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180612210536.GA15998@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 12-06-18 15:05:36, Ross Zwisler wrote:
> On Fri, May 18, 2018 at 06:35:13PM -0700, Dan Williams wrote:
> > Background:
> > 
> > get_user_pages() in the filesystem pins file backed memory pages for
> > access by devices performing dma. However, it only pins the memory pages
> > not the page-to-file offset association. If a file is truncated the
> > pages are mapped out of the file and dma may continue indefinitely into
> > a page that is owned by a device driver. This breaks coherency of the
> > file vs dma, but the assumption is that if userspace wants the
> > file-space truncated it does not matter what data is inbound from the
> > device, it is not relevant anymore. The only expectation is that dma can
> > safely continue while the filesystem reallocates the block(s).
> > 
> > Problem:
> > 
> > This expectation that dma can safely continue while the filesystem
> > changes the block map is broken by dax. With dax the target dma page
> > *is* the filesystem block. The model of leaving the page pinned for dma,
> > but truncating the file block out of the file, means that the filesytem
> > is free to reallocate a block under active dma to another file and now
> > the expected data-incoherency situation has turned into active
> > data-corruption.
> > 
> > Solution:
> > 
> > Defer all filesystem operations (fallocate(), truncate()) on a dax mode
> > file while any page/block in the file is under active dma. This solution
> > assumes that dma is transient. Cases where dma operations are known to
> > not be transient, like RDMA, have been explicitly disabled via
> > commits like 5f1d43de5416 "IB/core: disable memory registration of
> > filesystem-dax vmas".
> > 
> > The dax_layout_busy_page() routine is called by filesystems with a lock
> > held against mm faults (i_mmap_lock) to find pinned / busy dax pages.
> > The process of looking up a busy page invalidates all mappings
> > to trigger any subsequent get_user_pages() to block on i_mmap_lock.
> > The filesystem continues to call dax_layout_busy_page() until it finally
> > returns no more active pages. This approach assumes that the page
> > pinning is transient, if that assumption is violated the system would
> > have likely hung from the uncompleted I/O.
> > 
> > Cc: Jeff Moyer <jmoyer@redhat.com>
> > Cc: Dave Chinner <david@fromorbit.com>
> > Cc: Matthew Wilcox <mawilcox@microsoft.com>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> > Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Reported-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> <>
> > @@ -492,6 +505,90 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
> >  	return entry;
> >  }
> >  
> > +/**
> > + * dax_layout_busy_page - find first pinned page in @mapping
> > + * @mapping: address space to scan for a page with ref count > 1
> > + *
> > + * DAX requires ZONE_DEVICE mapped pages. These pages are never
> > + * 'onlined' to the page allocator so they are considered idle when
> > + * page->count == 1. A filesystem uses this interface to determine if
> > + * any page in the mapping is busy, i.e. for DMA, or other
> > + * get_user_pages() usages.
> > + *
> > + * It is expected that the filesystem is holding locks to block the
> > + * establishment of new mappings in this address_space. I.e. it expects
> > + * to be able to run unmap_mapping_range() and subsequently not race
> > + * mapping_mapped() becoming true.
> > + */
> > +struct page *dax_layout_busy_page(struct address_space *mapping)
> > +{
> > +	pgoff_t	indices[PAGEVEC_SIZE];
> > +	struct page *page = NULL;
> > +	struct pagevec pvec;
> > +	pgoff_t	index, end;
> > +	unsigned i;
> > +
> > +	/*
> > +	 * In the 'limited' case get_user_pages() for dax is disabled.
> > +	 */
> > +	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
> > +		return NULL;
> > +
> > +	if (!dax_mapping(mapping) || !mapping_mapped(mapping))
> > +		return NULL;
> > +
> > +	pagevec_init(&pvec);
> > +	index = 0;
> > +	end = -1;
> > +
> > +	/*
> > +	 * If we race get_user_pages_fast() here either we'll see the
> > +	 * elevated page count in the pagevec_lookup and wait, or
> > +	 * get_user_pages_fast() will see that the page it took a reference
> > +	 * against is no longer mapped in the page tables and bail to the
> > +	 * get_user_pages() slow path.  The slow path is protected by
> > +	 * pte_lock() and pmd_lock(). New references are not taken without
> > +	 * holding those locks, and unmap_mapping_range() will not zero the
> > +	 * pte or pmd without holding the respective lock, so we are
> > +	 * guaranteed to either see new references or prevent new
> > +	 * references from being established.
> > +	 */
> > +	unmap_mapping_range(mapping, 0, 0, 1);
> > +
> > +	while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
> > +				min(end - index, (pgoff_t)PAGEVEC_SIZE),
> > +				indices)) {
> > +		for (i = 0; i < pagevec_count(&pvec); i++) {
> > +			struct page *pvec_ent = pvec.pages[i];
> > +			void *entry;
> > +
> > +			index = indices[i];
> > +			if (index >= end)
> > +				break;
> > +
> > +			if (!radix_tree_exceptional_entry(pvec_ent))
> > +				continue;
> > +
> > +			xa_lock_irq(&mapping->i_pages);
> > +			entry = get_unlocked_mapping_entry(mapping, index, NULL);
> > +			if (entry)
> > +				page = dax_busy_page(entry);
> > +			put_unlocked_mapping_entry(mapping, index, entry);
> > +			xa_unlock_irq(&mapping->i_pages);
> > +			if (page)
> > +				break;
> > +		}
> > +		pagevec_remove_exceptionals(&pvec);
> > +		pagevec_release(&pvec);
> 
> I must be missing something - now that we're using the common 4k zero page, we
> should only ever have exceptional entries in the DAX radix tree, right?
> 
> If so, it seems like these two pagevec_* calls could/should go away, and the
> !radix_tree_exceptional_entry() check in the for loop above should be
> surrounded by a WARN_ON_ONCE()?
> 
> Or has something changed that I'm overlooking?

You are right this would work as well but what Dan did is a common pattern
to handle pagevecs and I somewhat prefer it over "optimized" DAX variant.
Adding WARN_ON_ONCE() would be nice.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
