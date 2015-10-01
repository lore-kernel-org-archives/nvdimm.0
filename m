Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 1 Oct 2015 14:27:29 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/7] Revert "mm: take i_mmap_lock in
 unmap_mapping_range() for DAX"
Message-ID: <20151001202729.GA23495@linux.intel.com>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
 <1443685599-4843-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1443685599-4843-2-git-send-email-david@fromorbit.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, willy@linux.intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, linux-nvdimm@lists.01.org, jack@suse.cz, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 01, 2015 at 05:46:33PM +1000, Dave Chinner wrote:
> This reverts commit 46c043ede4711e8d598b9d63c5616c1fedb0605e.
> ---
>  fs/dax.c    | 36 ++++++++++++++++--------------------
>  mm/memory.c | 11 +++++++++--
>  2 files changed, 25 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 7ae6df7..400fe95 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -569,26 +569,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
>  		goto fallback;
>  
> -	if (buffer_unwritten(&bh) || buffer_new(&bh)) {
> -		int i;
> -		for (i = 0; i < PTRS_PER_PMD; i++)
> -			clear_pmem(kaddr + i * PAGE_SIZE, PAGE_SIZE);
> -		wmb_pmem();

The above two lines were updated to use the PMEM API with this commit:

commit d77e92e270ed ("dax: update PMD fault handler with PMEM API")

but they aren't updated in the reverted version here: 

> @@ -633,6 +620,15 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  		if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
>  			goto fallback;
>  
> +		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
> +			int i;
> +			for (i = 0; i < PTRS_PER_PMD; i++)
> +				clear_page(kaddr + i * PAGE_SIZE);
> +			count_vm_event(PGMAJFAULT);
> +			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
> +			result |= VM_FAULT_MAJOR;
> +		}
> +
>  		result |= vmf_insert_pfn_pmd(vma, address, pmd, pfn, write);
>  	}

This is the source of the follow-up sparse warning from the kbuild robot.


Also, if I understood your previous mails correctly you were targeting the
first two revert patches for v4.3 so we get back to v4.2 level locking, and
the rest of the series will target v4.4, correct?  How does this work?  Do the
patches need to be split into two series and tested separately?
