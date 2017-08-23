Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F07D2095DCB9
 for <linux-nvdimm@lists.01.org>; Wed, 23 Aug 2017 02:55:03 -0700 (PDT)
Date: Wed, 23 Aug 2017 11:57:33 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/2] dax: fix deadlock due to misaligned PMD faults
Message-ID: <20170823095733.GA2100@quack2.suse.cz>
References: <20170822220926.13799-1-ross.zwisler@linux.intel.com>
 <20170822222436.18926-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170822222436.18926-1-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Slusarz, Marcin  <marcin.slusarz@intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton" <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 22-08-17 16:24:35, Ross Zwisler wrote:
> In DAX there are two separate places where the 2MiB range of a PMD is
> defined.
> 
> The first is in the page tables, where a PMD mapping inserted for a given
> address spans from (vmf->address & PMD_MASK) to
> ((vmf->address & PMD_MASK) + PMD_SIZE - 1).  That is, from the 2MiB
> boundary below the address to the 2MiB boundary above the address.
> 
> So, for example, a fault at address 3MiB (0x30 0000) falls within the PMD
> that ranges from 2MiB (0x20 0000) to 4MiB (0x40 0000).
> 
> The second PMD range is in the mapping->page_tree, where a given file
> offset is covered by a radix tree entry that spans from one 2MiB aligned
> file offset to another 2MiB aligned file offset.
> 
> So, for example, the file offset for 3MiB (pgoff 768) falls within the PMD
> range for the order 9 radix tree entry that ranges from 2MiB (pgoff 512) to
> 4MiB (pgoff 1024).
> 
> This system works so long as the addresses and file offsets for a given
> mapping both have the same offsets relative to the start of each PMD.
> 
> Consider the case where the starting address for a given file isn't 2MiB
> aligned - say our faulting address is 3 MiB (0x30 0000), but that
> corresponds to the beginning of our file (pgoff 0).  Now all the PMDs in
> the mapping are misaligned so that the 2MiB range defined in the page
> tables never matches up with the 2MiB range defined in the radix tree.
> 
> The current code notices this case for DAX faults to storage with the
> following test in dax_pmd_insert_mapping():
> 
> 	if (pfn_t_to_pfn(pfn) & PG_PMD_COLOUR)
> 		goto unlock_fallback;
> 
> This test makes sure that the pfn we get from the driver is 2MiB aligned,
> and relies on the assumption that the 2MiB alignment of the pfn we get back
> from the driver matches the 2MiB alignment of the faulting address.
> 
> However, faults to holes were not checked and we could hit the problem
> described above.
> 
> This was reported in response to the NVML nvml/src/test/pmempool_sync
> TEST5:
> 
> 	$ cd nvml/src/test/pmempool_sync
> 	$ make TEST5
> 
> You can grab NVML here:
> 
> 	https://github.com/pmem/nvml/
> 
> The dmesg warning you see when you hit this error is:
> 
> WARNING: CPU: 13 PID: 2900 at fs/dax.c:641 dax_insert_mapping_entry+0x2df/0x310
> 
> Where we notice in dax_insert_mapping_entry() that the radix tree entry we
> are about to replace doesn't match the locked entry that we had previously
> inserted into the tree.  This happens because the initial insertion was
> done in grab_mapping_entry() using a pgoff calculated from the faulting
> address (vmf->address), and the replacement in
> dax_pmd_load_hole() => dax_insert_mapping_entry() is done using vmf->pgoff.
> 
> In our failure case those two page offsets (one calculated from
> vmf->address, one using vmf->pgoff) point to different order 9 radix tree
> entries.
> 
> This failure case can result in a deadlock because the radix tree unlock
> also happens on the pgoff calculated from vmf->address.  This means that
> the locked radix tree entry that we swapped in to the tree in
> dax_insert_mapping_entry() using vmf->pgoff is never unlocked, so all
> future faults to that 2MiB range will block forever.
> 
> Fix this by validating that the faulting address's PMD offset matches the
> PMD offset from the start of the file.  This check is done at the very
> beginning of the fault and covers faults that would have mapped to storage
> as well as faults to holes.  I left the COLOUR check in
> dax_pmd_insert_mapping() in place in case we ever hit the insanity
> condition where the alignment of the pfn we get from the driver doesn't
> match the alignment of the userspace address.

Hum, I'm confused with all these offsets and their alignment requirements.
So let me try to get this straight. We have three different things here:

1) virtual address A where we fault
2) file offset FA corresponding to the virtual address - computed as
   linear_page_index(vma, A) = (A - vma->start) >> PAGE_SHIFT + vma->pgoff
   - and stored in vmf->pgoff
3) physical address (or sector in filesystem terminology) the file offset
   maps to.

and then we have the aligned virtual address B = (A & PMD_MASK) and
corresponding file offset FB we've got from linear_page_index(vma, B). Now
if I've correctly understood what you've written above, the problem is that
although B is aligned, FB doesn't have to be. That can happen either when
vma->start is not aligned (which is the example you give above?) or when
vma->pgoff is non aligned. And as a result FA >> 9 != FB >> 9 leading to
issues.

OK, makes sense. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: "Slusarz, Marcin" <marcin.slusarz@intel.com>
> Cc: <stable@vger.kernel.org>
> 
> ---
> 
> Sorry for the quick v2, I realized that I didn't talk about the deadlock
> that results from this issue.  Patch title and changelog have been updated,
> the code is the same.
> 
> This applies cleanly to the current v4.13-rc6 based linux/master.
> 
> In my opinion this should be be merged for v4.13 (pending reviews, of course).
> 
> Patch 2 is just a cleanup and can wait for v4.14 if anyone is worried about
> it.
> 
> This series has passed my regression testing using xfstests and the NVML
> test that was used to initially find the problem.
> 
> ---
>  fs/dax.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 306c2b6..865d42c 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1383,6 +1383,16 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
>  
>  	trace_dax_pmd_fault(inode, vmf, max_pgoff, 0);
>  
> +	/*
> +	 * Make sure that the faulting address's PMD offset (color) matches
> +	 * the PMD offset from the start of the file.  This is necessary so
> +	 * that a PMD range in the page table overlaps exactly with a PMD
> +	 * range in the radix tree.
> +	 */
> +	if ((vmf->pgoff & PG_PMD_COLOUR) !=
> +	    ((vmf->address >> PAGE_SHIFT) & PG_PMD_COLOUR))
> +		goto fallback;
> +
>  	/* Fall back to PTEs if we're going to COW */
>  	if (write && !(vma->vm_flags & VM_SHARED))
>  		goto fallback;
> -- 
> 2.9.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
