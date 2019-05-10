Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CEA8F21268FA8
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 09:16:37 -0700 (PDT)
Date: Fri, 10 May 2019 09:16:07 -0700
From: Larry Bassel <larry.bassel@oracle.com>
Subject: Re: [PATCH, RFC 2/2] Implement sharing/unsharing of PMDs for FS/DAX
Message-ID: <20190510161607.GB27674@ubuette>
References: <1557417933-15701-1-git-send-email-larry.bassel@oracle.com>
 <1557417933-15701-3-git-send-email-larry.bassel@oracle.com>
 <20190509164914.GA3862@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190509164914.GA3862@bombadil.infradead.org>
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
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mike.kravetz@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

On 09 May 19 09:49, Matthew Wilcox wrote:
> On Thu, May 09, 2019 at 09:05:33AM -0700, Larry Bassel wrote:
> > This is based on (but somewhat different from) what hugetlbfs
> > does to share/unshare page tables.
> 
> Wow, that worked out far more cleanly than I was expecting to see.

Yes, I was pleasantly surprised. As I've mentioned already, I 
think this is at least partially due to the nature of DAX.

> 
> > @@ -4763,6 +4763,19 @@ void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
> >  				unsigned long *start, unsigned long *end)
> >  {
> >  }
> > +
> > +unsigned long page_table_shareable(struct vm_area_struct *svma,
> > +				   struct vm_area_struct *vma,
> > +				   unsigned long addr, pgoff_t idx)
> > +{
> > +	return 0;
> > +}
> > +
> > +bool vma_shareable(struct vm_area_struct *vma, unsigned long addr)
> > +{
> > +	return false;
> > +}
> 
> I don't think you need these stubs, since the only caller of them is
> also gated by MAY_SHARE_FSDAX_PMD ... right?

These are also called in mm/hugetlb.c, but those calls are gated by
CONFIG_ARCH_WANT_HUGE_PMD_SHARE. In fact if this is not set (though
it is the default), then one wouldn't get FS/DAX sharing even if
MAY_SHARE_FSDAX_PMD is set. I think that this isn't what we want
(perhaps the real question is how should these two config options interact?).
Removing the stubs would fix this and I will make that change.

Maybe these two functions should be moved into mm/memory.c as well.

> 
> > +	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
> > +		if (svma == vma)
> > +			continue;
> > +
> > +		saddr = page_table_shareable(svma, vma, addr, idx);
> > +		if (saddr) {
> > +			spmd = huge_pmd_offset(svma->vm_mm, saddr,
> > +					       vma_mmu_pagesize(svma));
> > +			if (spmd) {
> > +				get_page(virt_to_page(spmd));
> > +				break;
> > +			}
> > +		}
> > +	}
> 
> I'd be tempted to reduce the indentation here:
> 
> 	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
> 		if (svma == vma)
> 			continue;
> 
> 		saddr = page_table_shareable(svma, vma, addr, idx);
> 		if (!saddr)
> 			continue;
> 
> 		spmd = huge_pmd_offset(svma->vm_mm, saddr,
> 					vma_mmu_pagesize(svma));
> 		if (spmd)
> 			break;
> 	}
> 
> 
> > +	if (!spmd)
> > +		goto out;
> 
> ... and move the get_page() down to here, so we don't split the
> "when we find it" logic between inside and outside the loop.
> 
> 	get_page(virt_to_page(spmd));
> 
> > +
> > +	ptl = pmd_lockptr(mm, spmd);
> > +	spin_lock(ptl);
> > +
> > +	if (pud_none(*pud)) {
> > +		pud_populate(mm, pud,
> > +			    (pmd_t *)((unsigned long)spmd & PAGE_MASK));
> > +		mm_inc_nr_pmds(mm);
> > +	} else {
> > +		put_page(virt_to_page(spmd));
> > +	}
> > +	spin_unlock(ptl);
> > +out:
> > +	pmd = pmd_alloc(mm, pud, addr);
> > +	i_mmap_unlock_write(mapping);
> 
> I would swap these two lines.  There's no need to hold the i_mmap_lock
> while allocating this PMD, is there?  I mean, we don't for the !may_share
> case.
> 

These were done in the style of functions already in mm/hugetlb.c and I was
trying to change as little as necessary in my copy of those. I agree that
these are good suggestions. One could argue that if these changes
were made, they should also be made in mm/hugetlb.c, though
this is perhaps beyond the scope of getting FS/DAX PMD sharing
implemented -- your thoughts?

Thanks for the review, I'll wait a few more days for other comments
and then send out a v2.

Larry
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
