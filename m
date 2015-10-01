Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 1 Oct 2015 16:45:04 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/7] Revert "mm: take i_mmap_lock in
 unmap_mapping_range() for DAX"
Message-ID: <20151001224504.GA7634@linux.intel.com>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
 <1443685599-4843-2-git-send-email-david@fromorbit.com>
 <20151001202729.GA23495@linux.intel.com>
 <1443737659.4886.3.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1443737659.4886.3.camel@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "david@fromorbit.com" <david@fromorbit.com>, "jack@suse.cz" <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 01, 2015 at 10:14:22PM +0000, Williams, Dan J wrote:
> Subject: pmem, dax: clean up clear_pmem()
> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Both, __dax_pmd_fault, and clear_pmem() were taking special steps to
> clear memory a page at a time to take advantage of non-temporal
> clear_page() implementations.  However, x86_64 does not use
> non-temporal instructions for clear_page(), and arch_clear_pmem() was
> always incurring the cost of __arch_wb_cache_pmem().
> 
> Clean up the assumption that doing clear_pmem() a page at a time is more
> performant.
> 
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/include/asm/pmem.h |    7 +------
>  fs/dax.c                    |    4 +---
>  2 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
> index d8ce3ec816ab..1544fabcd7f9 100644
> --- a/arch/x86/include/asm/pmem.h
> +++ b/arch/x86/include/asm/pmem.h
> @@ -132,12 +132,7 @@ static inline void arch_clear_pmem(void __pmem *addr, size_t size)
>  {
>  	void *vaddr = (void __force *)addr;
>  
> -	/* TODO: implement the zeroing via non-temporal writes */
> -	if (size == PAGE_SIZE && ((unsigned long)vaddr & ~PAGE_MASK) == 0)
> -		clear_page(vaddr);
> -	else
> -		memset(vaddr, 0, size);
> -
> +	memset(vaddr, 0, size);
>  	__arch_wb_cache_pmem(vaddr, size);
>  }
>  
> diff --git a/fs/dax.c b/fs/dax.c
> index b36d6d2e7f87..3faff9227135 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -625,9 +625,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  			goto fallback;
>  
>  		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
> -			int i;
> -			for (i = 0; i < PTRS_PER_PMD; i++)
> -				clear_page(kaddr + i * PAGE_SIZE);
> +			clear_pmem(kaddr, HPAGE_SIZE);
>  			count_vm_event(PGMAJFAULT);
>  			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
>  			result |= VM_FAULT_MAJOR;
> 

This clear_pmem() needs a wmb_pmem() after it.  I'll make a quick series with
the clean revert and this guy at the end and try and get them in v4.3 - sound
good?
