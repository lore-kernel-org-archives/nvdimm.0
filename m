Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C8321A1E05
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jul 2016 05:04:55 -0700 (PDT)
Date: Mon, 18 Jul 2016 14:03:59 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] dax: remote unused fault wrappers
Message-ID: <20160718120359.GC6782@quack2.suse.cz>
References: <20160714214049.20075-1-ross.zwisler@linux.intel.com>
 <20160714214049.20075-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160714214049.20075-2-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-nvdimm@lists.01.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 14-07-16 15:40:49, Ross Zwisler wrote:
> Remove the unused wrappers dax_fault() and dax_pmd_fault().  After this
> removal, rename __dax_fault() and __dax_pmd_fault() to dax_fault() and
> dax_pmd_fault() respectively, and update all callers.
> 
> The dax_fault() and dax_pmd_fault() wrappers were initially intended to
> capture some filesystem independent functionality around page faults
> (calling sb_start_pagefault() & sb_end_pagefault(), updating file
> mtime and ctime).  However, the following commits:
> 
> commit 5726b27b09cc ("ext2: Add locking for DAX faults")
> commit ea3d7209ca01 ("ext4: fix races between page faults and hole punching")
> 
> Added locking to the ext2 and ext4 filesystems after these common
> operations but before __dax_fault() and __dax_pmd_fault() were called.
> This means that these wrappers are no longer used, and are unlikely to be
> used in the future.  XFS has had locking analogous to what was recently
> added to ext2 and ext4 since DAX support was initially introduced by:
> 
> commit 6b698edeeef0 ("xfs: add DAX file operations support")
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> diff --git a/fs/dax.c b/fs/dax.c
> index e207f8f..432b9e6 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -819,16 +819,16 @@ static int dax_insert_mapping(struct address_space *mapping,
>  }
>  
>  /**
> - * __dax_fault - handle a page fault on a DAX file
> + * dax_fault - handle a page fault on a DAX file
>   * @vma: The virtual memory area where the fault occurred
>   * @vmf: The description of the fault
>   * @get_block: The filesystem method used to translate file offsets to blocks
>   *
>   * When a page fault occurs, filesystems may call this helper in their
> - * fault handler for DAX files. __dax_fault() assumes the caller has done all
> + * fault handler for DAX files. dax_fault() assumes the caller has done all
>   * the necessary locking for the page fault to proceed successfully.
>   */
> -int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> +int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  			get_block_t get_block)
>  {
>  	struct file *file = vma->vm_file;
> @@ -913,33 +913,6 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  		return VM_FAULT_SIGBUS | major;
>  	return VM_FAULT_NOPAGE | major;
>  }
> -EXPORT_SYMBOL(__dax_fault);
> -
> -/**
> - * dax_fault - handle a page fault on a DAX file
> - * @vma: The virtual memory area where the fault occurred
> - * @vmf: The description of the fault
> - * @get_block: The filesystem method used to translate file offsets to blocks
> - *
> - * When a page fault occurs, filesystems may call this helper in their
> - * fault handler for DAX files.
> - */
> -int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> -	      get_block_t get_block)
> -{
> -	int result;
> -	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
> -
> -	if (vmf->flags & FAULT_FLAG_WRITE) {
> -		sb_start_pagefault(sb);
> -		file_update_time(vma->vm_file);
> -	}
> -	result = __dax_fault(vma, vmf, get_block);
> -	if (vmf->flags & FAULT_FLAG_WRITE)
> -		sb_end_pagefault(sb);
> -
> -	return result;
> -}
>  EXPORT_SYMBOL_GPL(dax_fault);
>  
>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
> @@ -967,7 +940,16 @@ static void __dax_dbg(struct buffer_head *bh, unsigned long address,
>  
>  #define dax_pmd_dbg(bh, address, reason)	__dax_dbg(bh, address, reason, "dax_pmd")
>  
> -int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> +/**
> + * dax_pmd_fault - handle a PMD fault on a DAX file
> + * @vma: The virtual memory area where the fault occurred
> + * @vmf: The description of the fault
> + * @get_block: The filesystem method used to translate file offsets to blocks
> + *
> + * When a page fault occurs, filesystems may call this helper in their
> + * pmd_fault handler for DAX files.
> + */
> +int dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  		pmd_t *pmd, unsigned int flags, get_block_t get_block)
>  {
>  	struct file *file = vma->vm_file;
> @@ -1119,7 +1101,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  		 *
>  		 * The PMD path doesn't have an equivalent to
>  		 * dax_pfn_mkwrite(), though, so for a read followed by a
> -		 * write we traverse all the way through __dax_pmd_fault()
> +		 * write we traverse all the way through dax_pmd_fault()
>  		 * twice.  This means we can just skip inserting a radix tree
>  		 * entry completely on the initial read and just wait until
>  		 * the write to insert a dirty entry.
> @@ -1148,33 +1130,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  	result = VM_FAULT_FALLBACK;
>  	goto out;
>  }
> -EXPORT_SYMBOL_GPL(__dax_pmd_fault);
> -
> -/**
> - * dax_pmd_fault - handle a PMD fault on a DAX file
> - * @vma: The virtual memory area where the fault occurred
> - * @vmf: The description of the fault
> - * @get_block: The filesystem method used to translate file offsets to blocks
> - *
> - * When a page fault occurs, filesystems may call this helper in their
> - * pmd_fault handler for DAX files.
> - */
> -int dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> -			pmd_t *pmd, unsigned int flags, get_block_t get_block)
> -{
> -	int result;
> -	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
> -
> -	if (flags & FAULT_FLAG_WRITE) {
> -		sb_start_pagefault(sb);
> -		file_update_time(vma->vm_file);
> -	}
> -	result = __dax_pmd_fault(vma, address, pmd, flags, get_block);
> -	if (flags & FAULT_FLAG_WRITE)
> -		sb_end_pagefault(sb);
> -
> -	return result;
> -}
>  EXPORT_SYMBOL_GPL(dax_pmd_fault);
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index 868c023..5efeefe 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -51,7 +51,7 @@ static int ext2_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	}
>  	down_read(&ei->dax_sem);
>  
> -	ret = __dax_fault(vma, vmf, ext2_get_block);
> +	ret = dax_fault(vma, vmf, ext2_get_block);
>  
>  	up_read(&ei->dax_sem);
>  	if (vmf->flags & FAULT_FLAG_WRITE)
> @@ -72,7 +72,7 @@ static int ext2_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
>  	}
>  	down_read(&ei->dax_sem);
>  
> -	ret = __dax_pmd_fault(vma, addr, pmd, flags, ext2_get_block);
> +	ret = dax_pmd_fault(vma, addr, pmd, flags, ext2_get_block);
>  
>  	up_read(&ei->dax_sem);
>  	if (flags & FAULT_FLAG_WRITE)
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index df44c87..6664f9c 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -202,7 +202,7 @@ static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	if (IS_ERR(handle))
>  		result = VM_FAULT_SIGBUS;
>  	else
> -		result = __dax_fault(vma, vmf, ext4_dax_get_block);
> +		result = dax_fault(vma, vmf, ext4_dax_get_block);
>  
>  	if (write) {
>  		if (!IS_ERR(handle))
> @@ -237,7 +237,7 @@ static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
>  	if (IS_ERR(handle))
>  		result = VM_FAULT_SIGBUS;
>  	else
> -		result = __dax_pmd_fault(vma, addr, pmd, flags,
> +		result = dax_pmd_fault(vma, addr, pmd, flags,
>  					 ext4_dax_get_block);
>  
>  	if (write) {
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 47fc632..1b3dc9dd 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1551,7 +1551,7 @@ xfs_filemap_page_mkwrite(
>  	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  
>  	if (IS_DAX(inode)) {
> -		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault);
> +		ret = dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault);
>  	} else {
>  		ret = block_page_mkwrite(vma, vmf, xfs_get_blocks);
>  		ret = block_page_mkwrite_return(ret);
> @@ -1585,7 +1585,7 @@ xfs_filemap_fault(
>  		 * changes to xfs_get_blocks_direct() to map unwritten extent
>  		 * ioend for conversion on read-only mappings.
>  		 */
> -		ret = __dax_fault(vma, vmf, xfs_get_blocks_dax_fault);
> +		ret = dax_fault(vma, vmf, xfs_get_blocks_dax_fault);
>  	} else
>  		ret = filemap_fault(vma, vmf);
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> @@ -1622,7 +1622,7 @@ xfs_filemap_pmd_fault(
>  	}
>  
>  	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -	ret = __dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault);
> +	ret = dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault);
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  
>  	if (flags & FAULT_FLAG_WRITE)
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 43d5f0b..9c6dc77 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -14,7 +14,6 @@ ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *,
>  int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
>  int dax_truncate_page(struct inode *, loff_t from, get_block_t);
>  int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
> -int __dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
>  int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
>  void dax_wake_mapping_entry_waiter(struct address_space *mapping,
>  				   pgoff_t index, bool wake_all);
> @@ -46,19 +45,15 @@ static inline int __dax_zero_page_range(struct block_device *bdev,
>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
>  int dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
>  				unsigned int flags, get_block_t);
> -int __dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
> -				unsigned int flags, get_block_t);
>  #else
>  static inline int dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
>  				pmd_t *pmd, unsigned int flags, get_block_t gb)
>  {
>  	return VM_FAULT_FALLBACK;
>  }
> -#define __dax_pmd_fault dax_pmd_fault
>  #endif
>  int dax_pfn_mkwrite(struct vm_area_struct *, struct vm_fault *);
>  #define dax_mkwrite(vma, vmf, gb)	dax_fault(vma, vmf, gb)
> -#define __dax_mkwrite(vma, vmf, gb)	__dax_fault(vma, vmf, gb)
>  
>  static inline bool vma_is_dax(struct vm_area_struct *vma)
>  {
> -- 
> 2.9.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
