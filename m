Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12C5881EE4
 for <linux-nvdimm@lists.01.org>; Thu, 24 Nov 2016 01:22:22 -0800 (PST)
Date: Thu, 24 Nov 2016 10:22:18 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/6] dax: add tracepoints to dax_pmd_insert_mapping()
Message-ID: <20161124092218.GE24138@quack2.suse.cz>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-7-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1479926662-21718-7-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 23-11-16 11:44:22, Ross Zwisler wrote:
> Add tracepoints to dax_pmd_insert_mapping(), following the same logging
> conventions as the tracepoints in dax_iomap_pmd_fault().
> 
> Here is an example PMD fault showing the new tracepoints:
> 
> big-1544  [006] ....    48.153479: dax_pmd_fault: shared mapping write
> address 0x10505000 vm_start 0x10200000 vm_end 0x10700000 pgoff 0x200
> max_pgoff 0x1400
> 
> big-1544  [006] ....    48.155230: dax_pmd_insert_mapping: shared mapping
> write address 0x10505000 length 0x200000 pfn 0x100600 DEV|MAP radix_entry
> 0xc000e
> 
> big-1544  [006] ....    48.155266: dax_pmd_fault_done: shared mapping write
> address 0x10505000 vm_start 0x10200000 vm_end 0x10700000 pgoff 0x200
> max_pgoff 0x1400 NOPAGE
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dax.c                      | 10 +++++++---
>  include/linux/pfn_t.h         |  6 ++++++
>  include/trace/events/fs_dax.h | 42 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 2824414..d6ba4a3 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1236,10 +1236,10 @@ static int dax_pmd_insert_mapping(struct vm_area_struct *vma, pmd_t *pmd,
>  		.size = PMD_SIZE,
>  	};
>  	long length = dax_map_atomic(bdev, &dax);
> -	void *ret;
> +	void *ret = NULL;
>  
>  	if (length < 0) /* dax_map_atomic() failed */
> -		return VM_FAULT_FALLBACK;
> +		goto fallback;
>  	if (length < PMD_SIZE)
>  		goto unmap_fallback;
>  	if (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR)
> @@ -1252,13 +1252,17 @@ static int dax_pmd_insert_mapping(struct vm_area_struct *vma, pmd_t *pmd,
>  	ret = dax_insert_mapping_entry(mapping, vmf, *entryp, dax.sector,
>  			RADIX_DAX_PMD);
>  	if (IS_ERR(ret))
> -		return VM_FAULT_FALLBACK;
> +		goto fallback;
>  	*entryp = ret;
>  
> +	trace_dax_pmd_insert_mapping(vma, address, write, length, dax.pfn, ret);
>  	return vmf_insert_pfn_pmd(vma, address, pmd, dax.pfn, write);
>  
>  unmap_fallback:
>  	dax_unmap_atomic(bdev, &dax);
> +fallback:
> +	trace_dax_pmd_insert_mapping_fallback(vma, address, write, length,
> +			dax.pfn, ret);
>  	return VM_FAULT_FALLBACK;
>  }
>  
> diff --git a/include/linux/pfn_t.h b/include/linux/pfn_t.h
> index a3d90b9..033fc7b 100644
> --- a/include/linux/pfn_t.h
> +++ b/include/linux/pfn_t.h
> @@ -15,6 +15,12 @@
>  #define PFN_DEV (1ULL << (BITS_PER_LONG_LONG - 3))
>  #define PFN_MAP (1ULL << (BITS_PER_LONG_LONG - 4))
>  
> +#define PFN_FLAGS_TRACE \
> +	{ PFN_SG_CHAIN,	"SG_CHAIN" }, \
> +	{ PFN_SG_LAST,	"SG_LAST" }, \
> +	{ PFN_DEV,	"DEV" }, \
> +	{ PFN_MAP,	"MAP" }
> +
>  static inline pfn_t __pfn_to_pfn_t(unsigned long pfn, u64 flags)
>  {
>  	pfn_t pfn_t = { .val = pfn | (flags & PFN_FLAGS_MASK), };
> diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
> index 8814b1a..a03f820 100644
> --- a/include/trace/events/fs_dax.h
> +++ b/include/trace/events/fs_dax.h
> @@ -87,6 +87,48 @@ DEFINE_EVENT(dax_pmd_load_hole_class, name, \
>  DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole);
>  DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole_fallback);
>  
> +DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
> +	TP_PROTO(struct vm_area_struct *vma, unsigned long address, int write,
> +		long length, pfn_t pfn, void *radix_entry),
> +	TP_ARGS(vma, address, write, length, pfn, radix_entry),
> +	TP_STRUCT__entry(
> +		__field(unsigned long, vm_flags)
> +		__field(unsigned long, address)
> +		__field(int, write)
> +		__field(long, length)
> +		__field(u64, pfn_val)
> +		__field(void *, radix_entry)
> +	),
> +	TP_fast_assign(
> +		__entry->vm_flags = vma->vm_flags;
> +		__entry->address = address;
> +		__entry->write = write;
> +		__entry->length = length;
> +		__entry->pfn_val = pfn.val;
> +		__entry->radix_entry = radix_entry;
> +	),
> +	TP_printk("%s mapping %s address %#lx length %#lx pfn %#llx %s"
> +		" radix_entry %#lx",
> +		__entry->vm_flags & VM_SHARED ? "shared" : "private",
> +		__entry->write ? "write" : "read",
> +		__entry->address,
> +		__entry->length,
> +		__entry->pfn_val & ~PFN_FLAGS_MASK,
> +		__print_flags(__entry->pfn_val & PFN_FLAGS_MASK, "|",
> +			PFN_FLAGS_TRACE),
> +		(unsigned long)__entry->radix_entry
> +	)
> +)
> +
> +#define DEFINE_PMD_INSERT_MAPPING_EVENT(name) \
> +DEFINE_EVENT(dax_pmd_insert_mapping_class, name, \
> +	TP_PROTO(struct vm_area_struct *vma, unsigned long address, \
> +		int write, long length, pfn_t pfn, void *radix_entry), \
> +	TP_ARGS(vma, address, write, length, pfn, radix_entry))
> +
> +DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping);
> +DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping_fallback);
> +
>  #endif /* _TRACE_FS_DAX_H */
>  
>  /* This part must be outside protection */
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
