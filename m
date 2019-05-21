Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0728521275459
 for <linux-nvdimm@lists.01.org>; Tue, 21 May 2019 10:35:54 -0700 (PDT)
Date: Tue, 21 May 2019 10:35:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/18] dax: replace mmap entry in case of CoW
Message-ID: <20190521173540.GE5125@magnolia>
References: <20190429172649.8288-1-rgoldwyn@suse.de>
 <20190429172649.8288-11-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190429172649.8288-11-rgoldwyn@suse.de>
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
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: kilobyte@angband.pl, jack@suse.cz, linux-nvdimm@lists.01.org, nborisov@suse.com, david@fromorbit.com, dsterba@suse.cz, willy@infradead.org, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-fsdevel@vger.kernel.org, hch@lst.de, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 29, 2019 at 12:26:41PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> We replace the existing entry to the newly allocated one
> in case of CoW. Also, we mark the entry as PAGECACHE_TAG_TOWRITE
> so writeback marks this entry as writeprotected. This
> helps us snapshots so new write pagefaults after snapshots
> trigger a CoW.
> 
> btrfs does not support hugepages so we don't handle PMD.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/dax.c | 36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 718b1632a39d..07e8ff20161d 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -700,6 +700,9 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
>  	return 0;
>  }
>  
> +#define DAX_IF_DIRTY		(1ULL << 0)
> +#define DAX_IF_COW		(1ULL << 1)
> +
>  /*
>   * By this point grab_mapping_entry() has ensured that we have a locked entry
>   * of the appropriate size so we don't have to worry about downgrading PMDs to
> @@ -709,14 +712,17 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
>   */
>  static void *dax_insert_entry(struct xa_state *xas,
>  		struct address_space *mapping, struct vm_fault *vmf,
> -		void *entry, pfn_t pfn, unsigned long flags, bool dirty)
> +		void *entry, pfn_t pfn, unsigned long flags,
> +		unsigned long insert_flags)

I think unsigned int would have sufficed here.

>  {
>  	void *new_entry = dax_make_entry(pfn, flags);
> +	bool dirty = insert_flags & DAX_IF_DIRTY;
> +	bool cow = insert_flags & DAX_IF_COW;
>  
>  	if (dirty)
>  		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>  
> -	if (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE)) {
> +	if (cow || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
>  		unsigned long index = xas->xa_index;
>  		/* we are replacing a zero page with block mapping */
>  		if (dax_is_pmd_entry(entry))
> @@ -728,12 +734,12 @@ static void *dax_insert_entry(struct xa_state *xas,
>  
>  	xas_reset(xas);
>  	xas_lock_irq(xas);
> -	if (dax_entry_size(entry) != dax_entry_size(new_entry)) {
> +	if (cow || (dax_entry_size(entry) != dax_entry_size(new_entry))) {
>  		dax_disassociate_entry(entry, mapping, false);
>  		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
>  	}
>  
> -	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
> +	if (cow || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
>  		/*
>  		 * Only swap our new entry into the page cache if the current
>  		 * entry is a zero page or an empty entry.  If a normal PTE or
> @@ -753,6 +759,9 @@ static void *dax_insert_entry(struct xa_state *xas,
>  	if (dirty)
>  		xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
>  
> +	if (cow)
> +		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
> +
>  	xas_unlock_irq(xas);
>  	return entry;
>  }
> @@ -1032,7 +1041,7 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
>  	vm_fault_t ret;
>  
>  	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
> -			DAX_ZERO_PAGE, false);
> +			DAX_ZERO_PAGE, 0);
>  
>  	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
>  	trace_dax_load_hole(inode, vmf, ret);
> @@ -1296,6 +1305,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  	vm_fault_t ret = 0;
>  	void *entry;
>  	pfn_t pfn;
> +	unsigned long insert_flags = 0;
>  
>  	trace_dax_pte_fault(inode, vmf, ret);
>  	/*
> @@ -1357,6 +1367,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  			error = copy_user_dax(iomap.bdev, iomap.dax_dev,
>  					sector, PAGE_SIZE, vmf->cow_page, vaddr);
>  			break;
> +		case IOMAP_DAX_COW:
> +			/* Should not be setting this - fallthrough */
>  		default:
>  			WARN_ON_ONCE(1);
>  			error = -EIO;
> @@ -1377,6 +1389,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  
>  	switch (iomap.type) {
>  	case IOMAP_DAX_COW:
> +		insert_flags |= DAX_IF_COW;
> +		/* fallthrough */
>  	case IOMAP_MAPPED:
>  		if (iomap.flags & IOMAP_F_NEW) {
>  			count_vm_event(PGMAJFAULT);
> @@ -1396,8 +1410,10 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  			} else
>  				memset(addr, 0, PAGE_SIZE);
>  		}
> +		if (write && !sync)
> +			insert_flags |= DAX_IF_DIRTY;
>  		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
> -						 0, write && !sync);
> +						 0, insert_flags);
>  
>  		/*
>  		 * If we are doing synchronous page fault and inode needs fsync,
> @@ -1478,7 +1494,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
>  
>  	pfn = page_to_pfn_t(zero_page);
>  	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
> -			DAX_PMD | DAX_ZERO_PAGE, false);
> +			DAX_PMD | DAX_ZERO_PAGE, 0);
>  
>  	if (arch_needs_pgtable_deposit()) {
>  		pgtable = pte_alloc_one(vma->vm_mm);
> @@ -1528,6 +1544,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  	loff_t pos;
>  	int error;
>  	pfn_t pfn;
> +	unsigned long insert_flags = 0;
>  
>  	/*
>  	 * Check whether offset isn't beyond end of file now. Caller is
> @@ -1612,8 +1629,11 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  		if (error < 0)
>  			goto finish_iomap;
>  
> +		if (write && !sync)
> +			insert_flags |= DAX_IF_DIRTY;
> +
>  		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
> -						DAX_PMD, write && !sync);
> +						DAX_PMD, insert_flags);

Otherwise, this seems reasonable enough to me.  What do the DAX
developers think?

FWIW I'm not thrilled by the fact that Goldwyn isn't wiring up the
(rather similar looking) PMD code paths, but I grok that btrfs doesn't
support hugepages so he has no way to test that the code path actually
works so I'm ok with letting that go (until XFS joins the party) so long
as the pmd code path changes aren't too dissimilar to the pte code
paths.  Is that true?

--D

>  
>  		/*
>  		 * If we are doing synchronous page fault and inode needs fsync,
> -- 
> 2.16.4
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
