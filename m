Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id C57ED1A1E8A
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 10:13:37 -0700 (PDT)
Date: Wed, 23 Mar 2016 11:12:26 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 03/10] dax: Remove complete_unwritten argument
Message-ID: <20160323171226.GB5544@linux.intel.com>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458566575-28063-4-git-send-email-jack@suse.cz>
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
Cc: linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, Wilcox,
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 21, 2016 at 02:22:48PM +0100, Jan Kara wrote:
> Fault handlers currently take complete_unwritten argument to convert
> unwritten extents after PTEs are updated. However no filesystem uses
> this anymore as the code is racy. Remove the unused argument.

This looks good.  Looking at this reminded me that at some point it may be
good to clean up our buffer head flags checks and make sure we don't have
checks that don't make sense - we still check for buffer_unwritten() in
buffer_written(), for instance. 

The handling of BH_New isn't consistent among filesystems, either - XFS & ext4
go out of their way to make sure BH_New is not set, while ext2 sets BH_New.

But I think those are separate from this patch, I think.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/block_dev.c      |  4 ++--
>  fs/dax.c            | 43 +++++++++----------------------------------
>  fs/ext2/file.c      |  4 ++--
>  fs/ext4/file.c      |  4 ++--
>  fs/xfs/xfs_file.c   |  7 +++----
>  include/linux/dax.h | 17 +++++++----------
>  include/linux/fs.h  |  1 -
>  7 files changed, 25 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 3172c4e2f502..a59f155f9aaf 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1746,7 +1746,7 @@ static const struct address_space_operations def_blk_aops = {
>   */
>  static int blkdev_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
> -	return __dax_fault(vma, vmf, blkdev_get_block, NULL);
> +	return __dax_fault(vma, vmf, blkdev_get_block);
>  }
>  
>  static int blkdev_dax_pfn_mkwrite(struct vm_area_struct *vma,
> @@ -1758,7 +1758,7 @@ static int blkdev_dax_pfn_mkwrite(struct vm_area_struct *vma,
>  static int blkdev_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
>  		pmd_t *pmd, unsigned int flags)
>  {
> -	return __dax_pmd_fault(vma, addr, pmd, flags, blkdev_get_block, NULL);
> +	return __dax_pmd_fault(vma, addr, pmd, flags, blkdev_get_block);
>  }
>  
>  static const struct vm_operations_struct blkdev_dax_vm_ops = {
> diff --git a/fs/dax.c b/fs/dax.c
> index b32e1b5eb8d4..d496466652cd 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -607,19 +607,13 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
>   * @vma: The virtual memory area where the fault occurred
>   * @vmf: The description of the fault
>   * @get_block: The filesystem method used to translate file offsets to blocks
> - * @complete_unwritten: The filesystem method used to convert unwritten blocks
> - *	to written so the data written to them is exposed. This is required for
> - *	required by write faults for filesystems that will return unwritten
> - *	extent mappings from @get_block, but it is optional for reads as
> - *	dax_insert_mapping() will always zero unwritten blocks. If the fs does
> - *	not support unwritten extents, the it should pass NULL.
>   *
>   * When a page fault occurs, filesystems may call this helper in their
>   * fault handler for DAX files. __dax_fault() assumes the caller has done all
>   * the necessary locking for the page fault to proceed successfully.
>   */
>  int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> -			get_block_t get_block, dax_iodone_t complete_unwritten)
> +			get_block_t get_block)
>  {
>  	struct file *file = vma->vm_file;
>  	struct address_space *mapping = file->f_mapping;
> @@ -722,23 +716,9 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  		page = NULL;
>  	}
>  
> -	/*
> -	 * If we successfully insert the new mapping over an unwritten extent,
> -	 * we need to ensure we convert the unwritten extent. If there is an
> -	 * error inserting the mapping, the filesystem needs to leave it as
> -	 * unwritten to prevent exposure of the stale underlying data to
> -	 * userspace, but we still need to call the completion function so
> -	 * the private resources on the mapping buffer can be released. We
> -	 * indicate what the callback should do via the uptodate variable, same
> -	 * as for normal BH based IO completions.
> -	 */
> +	/* Filesystem should not return unwritten buffers to us! */
> +	WARN_ON_ONCE(buffer_unwritten(&bh));
>  	error = dax_insert_mapping(inode, &bh, vma, vmf);
> -	if (buffer_unwritten(&bh)) {
> -		if (complete_unwritten)
> -			complete_unwritten(&bh, !error);
> -		else
> -			WARN_ON_ONCE(!(vmf->flags & FAULT_FLAG_WRITE));
> -	}
>  
>   out:
>  	if (error == -ENOMEM)
> @@ -767,7 +747,7 @@ EXPORT_SYMBOL(__dax_fault);
>   * fault handler for DAX files.
>   */
>  int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> -	      get_block_t get_block, dax_iodone_t complete_unwritten)
> +	      get_block_t get_block)
>  {
>  	int result;
>  	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
> @@ -776,7 +756,7 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  		sb_start_pagefault(sb);
>  		file_update_time(vma->vm_file);
>  	}
> -	result = __dax_fault(vma, vmf, get_block, complete_unwritten);
> +	result = __dax_fault(vma, vmf, get_block);
>  	if (vmf->flags & FAULT_FLAG_WRITE)
>  		sb_end_pagefault(sb);
>  
> @@ -810,8 +790,7 @@ static void __dax_dbg(struct buffer_head *bh, unsigned long address,
>  #define dax_pmd_dbg(bh, address, reason)	__dax_dbg(bh, address, reason, "dax_pmd")
>  
>  int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> -		pmd_t *pmd, unsigned int flags, get_block_t get_block,
> -		dax_iodone_t complete_unwritten)
> +		pmd_t *pmd, unsigned int flags, get_block_t get_block)
>  {
>  	struct file *file = vma->vm_file;
>  	struct address_space *mapping = file->f_mapping;
> @@ -870,6 +849,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  		if (get_block(inode, block, &bh, 1) != 0)
>  			return VM_FAULT_SIGBUS;
>  		alloc = true;
> +		WARN_ON_ONCE(buffer_unwritten(&bh));
>  	}
>  
>  	bdev = bh.b_bdev;
> @@ -1015,9 +995,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>   out:
>  	i_mmap_unlock_read(mapping);
>  
> -	if (buffer_unwritten(&bh))
> -		complete_unwritten(&bh, !(result & VM_FAULT_ERROR));
> -
>  	return result;
>  
>   fallback:
> @@ -1037,8 +1014,7 @@ EXPORT_SYMBOL_GPL(__dax_pmd_fault);
>   * pmd_fault handler for DAX files.
>   */
>  int dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> -			pmd_t *pmd, unsigned int flags, get_block_t get_block,
> -			dax_iodone_t complete_unwritten)
> +			pmd_t *pmd, unsigned int flags, get_block_t get_block)
>  {
>  	int result;
>  	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
> @@ -1047,8 +1023,7 @@ int dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  		sb_start_pagefault(sb);
>  		file_update_time(vma->vm_file);
>  	}
> -	result = __dax_pmd_fault(vma, address, pmd, flags, get_block,
> -				complete_unwritten);
> +	result = __dax_pmd_fault(vma, address, pmd, flags, get_block);
>  	if (flags & FAULT_FLAG_WRITE)
>  		sb_end_pagefault(sb);
>  
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index c1400b109805..868c02317b05 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -51,7 +51,7 @@ static int ext2_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	}
>  	down_read(&ei->dax_sem);
>  
> -	ret = __dax_fault(vma, vmf, ext2_get_block, NULL);
> +	ret = __dax_fault(vma, vmf, ext2_get_block);
>  
>  	up_read(&ei->dax_sem);
>  	if (vmf->flags & FAULT_FLAG_WRITE)
> @@ -72,7 +72,7 @@ static int ext2_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
>  	}
>  	down_read(&ei->dax_sem);
>  
> -	ret = __dax_pmd_fault(vma, addr, pmd, flags, ext2_get_block, NULL);
> +	ret = __dax_pmd_fault(vma, addr, pmd, flags, ext2_get_block);
>  
>  	up_read(&ei->dax_sem);
>  	if (flags & FAULT_FLAG_WRITE)
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 6659e216385e..cf20040a1a49 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -207,7 +207,7 @@ static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	if (IS_ERR(handle))
>  		result = VM_FAULT_SIGBUS;
>  	else
> -		result = __dax_fault(vma, vmf, ext4_dax_mmap_get_block, NULL);
> +		result = __dax_fault(vma, vmf, ext4_dax_mmap_get_block);
>  
>  	if (write) {
>  		if (!IS_ERR(handle))
> @@ -243,7 +243,7 @@ static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
>  		result = VM_FAULT_SIGBUS;
>  	else
>  		result = __dax_pmd_fault(vma, addr, pmd, flags,
> -				ext4_dax_mmap_get_block, NULL);
> +				ext4_dax_mmap_get_block);
>  
>  	if (write) {
>  		if (!IS_ERR(handle))
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 52883ac3cf84..2ecdb39d2424 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1526,7 +1526,7 @@ xfs_filemap_page_mkwrite(
>  	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  
>  	if (IS_DAX(inode)) {
> -		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault, NULL);
> +		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault);
>  	} else {
>  		ret = block_page_mkwrite(vma, vmf, xfs_get_blocks);
>  		ret = block_page_mkwrite_return(ret);
> @@ -1560,7 +1560,7 @@ xfs_filemap_fault(
>  		 * changes to xfs_get_blocks_direct() to map unwritten extent
>  		 * ioend for conversion on read-only mappings.
>  		 */
> -		ret = __dax_fault(vma, vmf, xfs_get_blocks_dax_fault, NULL);
> +		ret = __dax_fault(vma, vmf, xfs_get_blocks_dax_fault);
>  	} else
>  		ret = filemap_fault(vma, vmf);
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> @@ -1597,8 +1597,7 @@ xfs_filemap_pmd_fault(
>  	}
>  
>  	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -	ret = __dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault,
> -			      NULL);
> +	ret = __dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault);
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  
>  	if (flags & FAULT_FLAG_WRITE)
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 636dd59ab505..7c45ac7ea1d1 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -10,10 +10,8 @@ ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
>  int dax_clear_sectors(struct block_device *bdev, sector_t _sector, long _size);
>  int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
>  int dax_truncate_page(struct inode *, loff_t from, get_block_t);
> -int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
> -		dax_iodone_t);
> -int __dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
> -		dax_iodone_t);
> +int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
> +int __dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
>  
>  #ifdef CONFIG_FS_DAX
>  struct page *read_dax_sector(struct block_device *bdev, sector_t n);
> @@ -27,21 +25,20 @@ static inline struct page *read_dax_sector(struct block_device *bdev,
>  
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  int dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
> -				unsigned int flags, get_block_t, dax_iodone_t);
> +				unsigned int flags, get_block_t);
>  int __dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
> -				unsigned int flags, get_block_t, dax_iodone_t);
> +				unsigned int flags, get_block_t);
>  #else
>  static inline int dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
> -				pmd_t *pmd, unsigned int flags, get_block_t gb,
> -				dax_iodone_t di)
> +				pmd_t *pmd, unsigned int flags, get_block_t gb)
>  {
>  	return VM_FAULT_FALLBACK;
>  }
>  #define __dax_pmd_fault dax_pmd_fault
>  #endif
>  int dax_pfn_mkwrite(struct vm_area_struct *, struct vm_fault *);
> -#define dax_mkwrite(vma, vmf, gb, iod)		dax_fault(vma, vmf, gb, iod)
> -#define __dax_mkwrite(vma, vmf, gb, iod)	__dax_fault(vma, vmf, gb, iod)
> +#define dax_mkwrite(vma, vmf, gb)	dax_fault(vma, vmf, gb)
> +#define __dax_mkwrite(vma, vmf, gb)	__dax_fault(vma, vmf, gb)
>  
>  static inline bool vma_is_dax(struct vm_area_struct *vma)
>  {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index bb703ef728d1..960fa5e0f7c3 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -72,7 +72,6 @@ typedef int (get_block_t)(struct inode *inode, sector_t iblock,
>  			struct buffer_head *bh_result, int create);
>  typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  			ssize_t bytes, void *private);
> -typedef void (dax_iodone_t)(struct buffer_head *bh_map, int uptodate);
>  
>  #define MAY_EXEC		0x00000001
>  #define MAY_WRITE		0x00000002
> -- 
> 2.6.2
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
