Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 186FA222EDCDE
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jan 2018 07:34:46 -0800 (PST)
Date: Wed, 3 Jan 2018 16:39:48 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 07/18] dax: store pfns in the radix
Message-ID: <20180103153948.GK4911@quack2.suse.cz>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407699792.38751.2859846645388380112.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407699792.38751.2859846645388380112.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat 23-12-17 16:56:38, Dan Williams wrote:
> In preparation for examining the busy state of dax pages in the truncate
> path, switch from sectors to pfns in the radix.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me after comments are fixed as Ross asked. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/dax/super.c |   15 ++++++++--
>  fs/dax.c            |   75 ++++++++++++++++++---------------------------------
>  2 files changed, 39 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 473af694ad1c..516124ae1ccf 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -124,10 +124,19 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
>  		return len < 0 ? len : -EIO;
>  	}
>  
> -	if ((IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn))
> -			|| pfn_t_devmap(pfn))
> +	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn)) {
> +		/*
> +		 * An arch that has enabled the pmem api should also
> +		 * have its drivers support pfn_t_devmap()
> +		 *
> +		 * This is a developer warning and should not trigger in
> +		 * production. dax_flush() will crash since it depends
> +		 * on being able to do (page_address(pfn_to_page())).
> +		 */
> +		WARN_ON(IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API));
> +	} else if (pfn_t_devmap(pfn)) {
>  		/* pass */;
> -	else {
> +	} else {
>  		pr_debug("VFS (%s): error: dax support not enabled\n",
>  				sb->s_id);
>  		return -EOPNOTSUPP;
> diff --git a/fs/dax.c b/fs/dax.c
> index 78b72c48374e..54071cd27e8c 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -72,16 +72,15 @@ fs_initcall(init_dax_wait_table);
>  #define RADIX_DAX_ZERO_PAGE	(1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 2))
>  #define RADIX_DAX_EMPTY		(1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 3))
>  
> -static unsigned long dax_radix_sector(void *entry)
> +static unsigned long dax_radix_pfn(void *entry)
>  {
>  	return (unsigned long)entry >> RADIX_DAX_SHIFT;
>  }
>  
> -static void *dax_radix_locked_entry(sector_t sector, unsigned long flags)
> +static void *dax_radix_locked_entry(unsigned long pfn, unsigned long flags)
>  {
>  	return (void *)(RADIX_TREE_EXCEPTIONAL_ENTRY | flags |
> -			((unsigned long)sector << RADIX_DAX_SHIFT) |
> -			RADIX_DAX_ENTRY_LOCK);
> +			(pfn << RADIX_DAX_SHIFT) | RADIX_DAX_ENTRY_LOCK);
>  }
>  
>  static unsigned int dax_radix_order(void *entry)
> @@ -525,12 +524,13 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
>   */
>  static void *dax_insert_mapping_entry(struct address_space *mapping,
>  				      struct vm_fault *vmf,
> -				      void *entry, sector_t sector,
> +				      void *entry, pfn_t pfn_t,
>  				      unsigned long flags, bool dirty)
>  {
>  	struct radix_tree_root *page_tree = &mapping->page_tree;
> -	void *new_entry;
> +	unsigned long pfn = pfn_t_to_pfn(pfn_t);
>  	pgoff_t index = vmf->pgoff;
> +	void *new_entry;
>  
>  	if (dirty)
>  		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> @@ -547,7 +547,7 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
>  	}
>  
>  	spin_lock_irq(&mapping->tree_lock);
> -	new_entry = dax_radix_locked_entry(sector, flags);
> +	new_entry = dax_radix_locked_entry(pfn, flags);
>  
>  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
>  		/*
> @@ -659,17 +659,14 @@ static void dax_mapping_entry_mkclean(struct address_space *mapping,
>  	i_mmap_unlock_read(mapping);
>  }
>  
> -static int dax_writeback_one(struct block_device *bdev,
> -		struct dax_device *dax_dev, struct address_space *mapping,
> -		pgoff_t index, void *entry)
> +static int dax_writeback_one(struct dax_device *dax_dev,
> +		struct address_space *mapping, pgoff_t index, void *entry)
>  {
>  	struct radix_tree_root *page_tree = &mapping->page_tree;
> -	void *entry2, **slot, *kaddr;
> -	long ret = 0, id;
> -	sector_t sector;
> -	pgoff_t pgoff;
> +	void *entry2, **slot;
> +	unsigned long pfn;
> +	long ret = 0;
>  	size_t size;
> -	pfn_t pfn;
>  
>  	/*
>  	 * A page got tagged dirty in DAX mapping? Something is seriously
> @@ -688,7 +685,7 @@ static int dax_writeback_one(struct block_device *bdev,
>  	 * compare sectors as we must not bail out due to difference in lockbit
>  	 * or entry type.
>  	 */
> -	if (dax_radix_sector(entry2) != dax_radix_sector(entry))
> +	if (dax_radix_pfn(entry2) != dax_radix_pfn(entry))
>  		goto put_unlocked;
>  	if (WARN_ON_ONCE(dax_is_empty_entry(entry) ||
>  				dax_is_zero_entry(entry))) {
> @@ -718,29 +715,11 @@ static int dax_writeback_one(struct block_device *bdev,
>  	 * 'entry'.  This allows us to flush for PMD_SIZE and not have to
>  	 * worry about partial PMD writebacks.
>  	 */
> -	sector = dax_radix_sector(entry);
> +	pfn = dax_radix_pfn(entry);
>  	size = PAGE_SIZE << dax_radix_order(entry);
>  
> -	id = dax_read_lock();
> -	ret = bdev_dax_pgoff(bdev, sector, size, &pgoff);
> -	if (ret)
> -		goto dax_unlock;
> -
> -	/*
> -	 * dax_direct_access() may sleep, so cannot hold tree_lock over
> -	 * its invocation.
> -	 */
> -	ret = dax_direct_access(dax_dev, pgoff, size / PAGE_SIZE, &kaddr, &pfn);
> -	if (ret < 0)
> -		goto dax_unlock;
> -
> -	if (WARN_ON_ONCE(ret < size / PAGE_SIZE)) {
> -		ret = -EIO;
> -		goto dax_unlock;
> -	}
> -
> -	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(pfn));
> -	dax_flush(dax_dev, kaddr, size);
> +	dax_mapping_entry_mkclean(mapping, index, pfn);
> +	dax_flush(dax_dev, page_address(pfn_to_page(pfn)), size);
>  	/*
>  	 * After we have flushed the cache, we can clear the dirty tag. There
>  	 * cannot be new dirty data in the pfn after the flush has completed as
> @@ -751,8 +730,6 @@ static int dax_writeback_one(struct block_device *bdev,
>  	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_DIRTY);
>  	spin_unlock_irq(&mapping->tree_lock);
>  	trace_dax_writeback_one(mapping->host, index, size >> PAGE_SHIFT);
> - dax_unlock:
> -	dax_read_unlock(id);
>  	put_locked_mapping_entry(mapping, index);
>  	return ret;
>  
> @@ -810,8 +787,8 @@ int dax_writeback_mapping_range(struct address_space *mapping,
>  				break;
>  			}
>  
> -			ret = dax_writeback_one(bdev, dax_dev, mapping,
> -					indices[i], pvec.pages[i]);
> +			ret = dax_writeback_one(dax_dev, mapping, indices[i],
> +					pvec.pages[i]);
>  			if (ret < 0) {
>  				mapping_set_error(mapping, ret);
>  				goto out;
> @@ -879,6 +856,7 @@ static int dax_load_hole(struct address_space *mapping, void *entry,
>  	int ret = VM_FAULT_NOPAGE;
>  	struct page *zero_page;
>  	void *entry2;
> +	pfn_t pfn;
>  
>  	zero_page = ZERO_PAGE(0);
>  	if (unlikely(!zero_page)) {
> @@ -886,14 +864,15 @@ static int dax_load_hole(struct address_space *mapping, void *entry,
>  		goto out;
>  	}
>  
> -	entry2 = dax_insert_mapping_entry(mapping, vmf, entry, 0,
> +	pfn = page_to_pfn_t(zero_page);
> +	entry2 = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
>  			RADIX_DAX_ZERO_PAGE, false);
>  	if (IS_ERR(entry2)) {
>  		ret = VM_FAULT_SIGBUS;
>  		goto out;
>  	}
>  
> -	vm_insert_mixed(vmf->vma, vaddr, page_to_pfn_t(zero_page));
> +	vm_insert_mixed(vmf->vma, vaddr, pfn);
>  out:
>  	trace_dax_load_hole(inode, vmf, ret);
>  	return ret;
> @@ -1200,8 +1179,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  		if (error < 0)
>  			goto error_finish_iomap;
>  
> -		entry = dax_insert_mapping_entry(mapping, vmf, entry,
> -						 dax_iomap_sector(&iomap, pos),
> +		entry = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
>  						 0, write && !sync);
>  		if (IS_ERR(entry)) {
>  			error = PTR_ERR(entry);
> @@ -1286,13 +1264,15 @@ static int dax_pmd_load_hole(struct vm_fault *vmf, struct iomap *iomap,
>  	void *ret = NULL;
>  	spinlock_t *ptl;
>  	pmd_t pmd_entry;
> +	pfn_t pfn;
>  
>  	zero_page = mm_get_huge_zero_page(vmf->vma->vm_mm);
>  
>  	if (unlikely(!zero_page))
>  		goto fallback;
>  
> -	ret = dax_insert_mapping_entry(mapping, vmf, entry, 0,
> +	pfn = page_to_pfn_t(zero_page);
> +	ret = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
>  			RADIX_DAX_PMD | RADIX_DAX_ZERO_PAGE, false);
>  	if (IS_ERR(ret))
>  		goto fallback;
> @@ -1415,8 +1395,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  		if (error < 0)
>  			goto finish_iomap;
>  
> -		entry = dax_insert_mapping_entry(mapping, vmf, entry,
> -						dax_iomap_sector(&iomap, pos),
> +		entry = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
>  						RADIX_DAX_PMD, write && !sync);
>  		if (IS_ERR(entry))
>  			goto finish_iomap;
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
