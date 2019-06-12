Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com
 [IPv6:2a00:1450:4864:20::543])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D37E321290D20
 for <linux-nvdimm@lists.01.org>; Tue, 11 Jun 2019 19:33:38 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id w13so23198935eds.4
 for <linux-nvdimm@lists.01.org>; Tue, 11 Jun 2019 19:33:38 -0700 (PDT)
Date: Wed, 12 Jun 2019 05:33:36 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC PATCH v2 2/2] Implement sharing/unsharing of PMDs for FS/DAX
Message-ID: <20190612023336.hbqs2ag4bv2qv2eh@box>
References: <1559937063-8323-1-git-send-email-larry.bassel@oracle.com>
 <1559937063-8323-3-git-send-email-larry.bassel@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1559937063-8323-3-git-send-email-larry.bassel@oracle.com>
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
To: Larry Bassel <larry.bassel@oracle.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org, mike.kravetz@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 07, 2019 at 12:51:03PM -0700, Larry Bassel wrote:
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 3a54c9d..1c1ed4e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4653,9 +4653,9 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
>  }
>  
>  #ifdef CONFIG_ARCH_HAS_HUGE_PMD_SHARE
> -static unsigned long page_table_shareable(struct vm_area_struct *svma,
> -				struct vm_area_struct *vma,
> -				unsigned long addr, pgoff_t idx)
> +unsigned long page_table_shareable(struct vm_area_struct *svma,
> +				   struct vm_area_struct *vma,
> +				   unsigned long addr, pgoff_t idx)
>  {
>  	unsigned long saddr = ((idx - svma->vm_pgoff) << PAGE_SHIFT) +
>  				svma->vm_start;
> @@ -4678,7 +4678,7 @@ static unsigned long page_table_shareable(struct vm_area_struct *svma,
>  	return saddr;
>  }
>  
> -static bool vma_shareable(struct vm_area_struct *vma, unsigned long addr)
> +bool vma_shareable(struct vm_area_struct *vma, unsigned long addr)
>  {
>  	unsigned long base = addr & PUD_MASK;
>  	unsigned long end = base + PUD_SIZE;

This is going to be build error. mm/hugetlb.o doesn't build unlessp CONFIG_HUGETLBFS=y.

And I think both functions doesn't cover all DAX cases: VMA can be not
aligned (due to vm_start and/or vm_pgoff) to 2M even if the file has 2M
ranges allocated. See transhuge_vma_suitable().

And as I said before, nothing guarantees contiguous 2M ranges on backing
storage.

And in general I found piggybacking on hugetlb hacky.

The solution has to stand on its own with own justification. Saying it
worked for hugetlb and it has to work here would not fly. hugetlb is much
more restrictive on use cases. THP has more corner cases.

> diff --git a/mm/memory.c b/mm/memory.c
> index ddf20bd..1ca8f75 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3932,6 +3932,109 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_ARCH_HAS_HUGE_PMD_SHARE
> +static pmd_t *huge_pmd_offset(struct mm_struct *mm,
> +			      unsigned long addr, unsigned long sz)
> +{
> +	pgd_t *pgd;
> +	p4d_t *p4d;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +
> +	pgd = pgd_offset(mm, addr);
> +	if (!pgd_present(*pgd))
> +		return NULL;
> +	p4d = p4d_offset(pgd, addr);
> +	if (!p4d_present(*p4d))
> +		return NULL;
> +
> +	pud = pud_offset(p4d, addr);
> +	if (sz != PUD_SIZE && pud_none(*pud))
> +		return NULL;
> +	/* hugepage or swap? */
> +	if (pud_huge(*pud) || !pud_present(*pud))
> +		return (pmd_t *)pud;

So do we or do we not support PUD pages? This is just broken.
> +
> +	pmd = pmd_offset(pud, addr);
> +	if (sz != PMD_SIZE && pmd_none(*pmd))
> +		return NULL;
> +	/* hugepage or swap? */
> +	if (pmd_huge(*pmd) || !pmd_present(*pmd))
> +		return pmd;
> +
> +	return NULL;
> +}
> +

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
