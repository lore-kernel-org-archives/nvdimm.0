Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00B912095DBA8
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 15:51:18 -0700 (PDT)
Date: Thu, 27 Jul 2017 16:53:22 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 6/7] dax: Implement dax_pfn_mkwrite()
Message-ID: <20170727225322.GG22000@linux.intel.com>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-7-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170727131245.28279-7-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 27, 2017 at 03:12:44PM +0200, Jan Kara wrote:
> Implement a function that marks existing page table entry (PTE or PMD)
> as writeable and takes care of marking it dirty in the radix tree. This
> function will be used to finish synchronous page fault where the page
> table entry is first inserted as read-only and then needs to be marked
> as read-write.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/dax.c            | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h |  1 +
>  2 files changed, 49 insertions(+)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 8a6cf158c691..90b763c86dc2 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1485,3 +1485,51 @@ int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
>  	}
>  }
>  EXPORT_SYMBOL_GPL(dax_iomap_fault);
> +
> +/**
> + * dax_pfn_mkwrite - make page table entry writeable on a DAX file
> + * @vmf: The description of the fault
> + * @pe_size: size of entry to be marked writeable
> + *
> + * This function mark PTE or PMD entry as writeable in page tables for mmaped
> + * DAX file. It takes care of marking corresponding radix tree entry as dirty
> + * as well.
> + */
> +int dax_pfn_mkwrite(struct vm_fault *vmf, enum page_entry_size pe_size)

I wonder if this incarnation of this function should be named something other
than *_pfn_mkwrite so that it's clear that unlike in previous versions of the
codd, this version isn't supposed to be called via
vm_operations_struct->pfn_mkwrite, but is instead a helper for sync faults?
Maybe just dax_mkwrite()?

> +{
> +	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> +	void *entry, **slot;
> +	pgoff_t index = vmf->pgoff;
> +	pfn_t pfn = pfn_to_pfn_t(pte_pfn(vmf->orig_pte));
> +	int vmf_ret, error;
> +
> +	spin_lock_irq(&mapping->tree_lock);
> +	entry = get_unlocked_mapping_entry(mapping, index, &slot);
> +	/* Did we race with someone splitting entry or so? */
> +	if (!entry || (pe_size == PE_SIZE_PTE && !dax_is_pte_entry(entry)) ||
> +	    (pe_size == PE_SIZE_PMD && !dax_is_pmd_entry(entry))) {
> +		put_unlocked_mapping_entry(mapping, index, entry);
> +		spin_unlock_irq(&mapping->tree_lock);

The previous version of this function had tracepoints in this failure path and
in the successful completion path.  I use this kind of tracing daily for
debugging, so lets add it back in.

> +		return VM_FAULT_NOPAGE;
> +	}
> +	radix_tree_tag_set(&mapping->page_tree, index, PAGECACHE_TAG_DIRTY);
> +	entry = lock_slot(mapping, slot);
> +	spin_unlock_irq(&mapping->tree_lock);
> +	switch (pe_size) {
> +	case PE_SIZE_PTE:
> +		error = vm_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);

This path goes through the 'mkwrite' branch in insert_pfn() where we validate
that the PFN we are about to map matches the one pointed to by the existing
PTE, but I don't see any checks in this path that validate against
vmf->orig_pte?

This kind of check was done by the old
dax_pfn_mkwrite()->finish_mkwrite_fault() path via the pte_same() check in
finish_mkwrite_fault().

Do we need to add an equivalent check somewhere in this path, since we're
going through the trouble of setting vmf->orig_pte in the DAX fault handlers?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
