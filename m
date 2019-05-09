Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 9 May 2019 09:49:14 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH, RFC 2/2] Implement sharing/unsharing of PMDs for FS/DAX
Message-ID: <20190509164914.GA3862@bombadil.infradead.org>
References: <1557417933-15701-1-git-send-email-larry.bassel@oracle.com>
 <1557417933-15701-3-git-send-email-larry.bassel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557417933-15701-3-git-send-email-larry.bassel@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Larry Bassel <larry.bassel@oracle.com>
Cc: mike.kravetz@oracle.com, dan.j.williams@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 09, 2019 at 09:05:33AM -0700, Larry Bassel wrote:
> This is based on (but somewhat different from) what hugetlbfs
> does to share/unshare page tables.

Wow, that worked out far more cleanly than I was expecting to see.

> @@ -4763,6 +4763,19 @@ void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
>  				unsigned long *start, unsigned long *end)
>  {
>  }
> +
> +unsigned long page_table_shareable(struct vm_area_struct *svma,
> +				   struct vm_area_struct *vma,
> +				   unsigned long addr, pgoff_t idx)
> +{
> +	return 0;
> +}
> +
> +bool vma_shareable(struct vm_area_struct *vma, unsigned long addr)
> +{
> +	return false;
> +}

I don't think you need these stubs, since the only caller of them is
also gated by MAY_SHARE_FSDAX_PMD ... right?

> +	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
> +		if (svma == vma)
> +			continue;
> +
> +		saddr = page_table_shareable(svma, vma, addr, idx);
> +		if (saddr) {
> +			spmd = huge_pmd_offset(svma->vm_mm, saddr,
> +					       vma_mmu_pagesize(svma));
> +			if (spmd) {
> +				get_page(virt_to_page(spmd));
> +				break;
> +			}
> +		}
> +	}

I'd be tempted to reduce the indentation here:

	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
		if (svma == vma)
			continue;

		saddr = page_table_shareable(svma, vma, addr, idx);
		if (!saddr)
			continue;

		spmd = huge_pmd_offset(svma->vm_mm, saddr,
					vma_mmu_pagesize(svma));
		if (spmd)
			break;
	}


> +	if (!spmd)
> +		goto out;

... and move the get_page() down to here, so we don't split the
"when we find it" logic between inside and outside the loop.

	get_page(virt_to_page(spmd));

> +
> +	ptl = pmd_lockptr(mm, spmd);
> +	spin_lock(ptl);
> +
> +	if (pud_none(*pud)) {
> +		pud_populate(mm, pud,
> +			    (pmd_t *)((unsigned long)spmd & PAGE_MASK));
> +		mm_inc_nr_pmds(mm);
> +	} else {
> +		put_page(virt_to_page(spmd));
> +	}
> +	spin_unlock(ptl);
> +out:
> +	pmd = pmd_alloc(mm, pud, addr);
> +	i_mmap_unlock_write(mapping);

I would swap these two lines.  There's no need to hold the i_mmap_lock
while allocating this PMD, is there?  I mean, we don't for the !may_share
case.
