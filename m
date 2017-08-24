Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 91B7C2095B9E7
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 14:27:08 -0700 (PDT)
Date: Thu, 24 Aug 2017 15:29:42 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/3] xfs: consolidate the various page fault handlers
Message-ID: <20170824212942.GB20489@linux.intel.com>
References: <20170824152207.30729-1-hch@lst.de>
 <20170824152207.30729-3-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170824152207.30729-3-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 05:22:06PM +0200, Christoph Hellwig wrote:
> Add a new __xfs_filemap_fault helper that implements all four page fault
> callouts, and make these methods themselves small stubs that set the
> correct write_fault flag, and exit early for the non-DAX case for the
> hugepage related ones.
> 
> Life would be so much simpler if we only had one method for all this.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

A few nits and a question below.  This looks much simpler and gets rid of a
lot of duplication.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

<>
>  STATIC int
>  xfs_filemap_huge_fault(
>  	struct vm_fault		*vmf,
>  	enum page_entry_size	pe_size)
>  {
> -	struct inode		*inode = file_inode(vmf->vma->vm_file);
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	int			ret;
> -
> -	if (!IS_DAX(inode))
> +	if (!IS_DAX(file_inode(vmf->vma->vm_file)))
>  		return VM_FAULT_FALLBACK;
>  
> -	trace_xfs_filemap_huge_fault(ip);
> -
> -	if (vmf->flags & FAULT_FLAG_WRITE) {
> -		sb_start_pagefault(inode->i_sb);
> -		file_update_time(vmf->vma->vm_file);
> -	}
> -
> -	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -	ret = dax_iomap_fault(vmf, pe_size, NULL, &xfs_iomap_ops);
> -	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -
> -	if (vmf->flags & FAULT_FLAG_WRITE)
> -		sb_end_pagefault(inode->i_sb);
> +	/* DAX can shortcut the normal fault path on write faults! */

Does this comment still make sense for the PMD case?  Here's what I *think* it
means: For DAX write faults we make the PTE writeable in the ->fault() code
and don't rely on a follow-up ->page_mkwrite() call.  This happens in
do_shared_fault(), where we return before the ->page_mkwrite() call because
the DAX write fault returns VM_FAULT_NOPAGE.

This is in contrast to the normal page fault case where the ->fault() call
ends up calling filemap_fault(), which populates the page read-only, and then
do_shared_fault() does a follow-up ->page_mkwrite() call which makes the page
writable.

First, is the above correct?  :)  If so, I think the comment doesn't make
sense for the PMD fault path because in that case we always make the PMD
writeable in the first ->huge_fault() call, as there is no follow-up
*_mkwrite()?

> +	return __xfs_filemap_fault(vmf, pe_size,
> +			(vmf->flags & FAULT_FLAG_WRITE));
> +}
>  
> -	return ret;
> +STATIC int
> +xfs_filemap_page_mkwrite(
> +	struct vm_fault		*vmf)
> +{
> +	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
>  }
>  
> -/*
> - * pfn_mkwrite was originally inteneded to ensure we capture time stamp
> - * updates on write faults. In reality, it's need to serialise against
> - * truncate similar to page_mkwrite. Hence we cycle the XFS_MMAPLOCK_SHARED
> - * to ensure we serialise the fault barrier in place.
> - */
>  static int

   STATIC

>  xfs_filemap_pfn_mkwrite(
>  	struct vm_fault		*vmf)
>  {
> -
> -	struct inode		*inode = file_inode(vmf->vma->vm_file);
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	int			ret = VM_FAULT_NOPAGE;
> -	loff_t			size;
> -
> -	trace_xfs_filemap_pfn_mkwrite(ip);
> -
> -	sb_start_pagefault(inode->i_sb);
> -	file_update_time(vmf->vma->vm_file);
> -
> -	/* check if the faulting page hasn't raced with truncate */
> -	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> -	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;

I see that this size check is gone from the new code, and we now rely on the
equivalent check in dax_iomap_fault().  Nice.

> -	if (vmf->pgoff >= size)
> -		ret = VM_FAULT_SIGBUS;
> -	else if (IS_DAX(inode))
> -		ret = dax_iomap_fault(vmf, PE_SIZE_PTE, NULL, &xfs_iomap_ops);
> -	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> -	sb_end_pagefault(inode->i_sb);
> -	return ret;
> -
> +	if (!IS_DAX(file_inode(vmf->vma->vm_file)))
> +		return VM_FAULT_NOPAGE;
> +	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
>  }
>  
>  static const struct vm_operations_struct xfs_file_vm_ops = {
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index bcc3cdf8e1c5..3f41d5340eb8 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -689,10 +689,26 @@ DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
>  DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
>  DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
>  
> -DEFINE_INODE_EVENT(xfs_filemap_fault);
> -DEFINE_INODE_EVENT(xfs_filemap_huge_fault);
> -DEFINE_INODE_EVENT(xfs_filemap_page_mkwrite);
> -DEFINE_INODE_EVENT(xfs_filemap_pfn_mkwrite);
> +TRACE_EVENT(xfs_filemap_fault,
> +	TP_PROTO(struct xfs_inode *ip, enum page_entry_size pe_size,
> +		 bool write_fault),
> +	TP_ARGS(ip, pe_size, write_fault),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_ino_t, ino)
> +		__field(enum page_entry_size, pe_size)
> +		__field(bool, write_fault)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> +		__entry->ino = ip->i_ino;
> +		__entry->pe_size = pe_size;
> +		__entry->write_fault = write_fault;
> +	),
> +	TP_printk("dev %d:%d ino 0x%llx pe_size %d write_fault %d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->ino, __entry->pe_size, __entry->write_fault)
> +)

I wonder if pe_size would be more readable as a string via __print_symbolic()
so we see "pe_size PMD" instead of "pe_size 1" from enum page_entry_size?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
