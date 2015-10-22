Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 22 Oct 2015 11:35:49 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] block: enable dax for raw block devices
Message-ID: <20151022093549.GE14445@quack.suse.cz>
References: <20151022064142.12700.11849.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151022064211.12700.77105.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151022064211.12700.77105.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@fb.com, jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, hch@lst.de, Jeff Moyer <jmoyer@redhat.com>, willy@linux.intel.com, ross.zwisler@linux.intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 22-10-15 02:42:11, Dan Williams wrote:
> If an application wants exclusive access to all of the persistent memory
> provided by an NVDIMM namespace it can use this raw-block-dax facility
> to forgo establishing a filesystem.  This capability is targeted
> primarily to hypervisors wanting to provision persistent memory for
> guests.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/block_dev.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 53 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 3255dcec96b4..c27cd1a21a13 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1687,13 +1687,65 @@ static const struct address_space_operations def_blk_aops = {
>  	.is_dirty_writeback = buffer_check_dirty_writeback,
>  };
>  
> +#ifdef CONFIG_FS_DAX
> +/*
> + * In the raw block case we do not need to contend with truncation nor
> + * unwritten file extents.  Without those concerns there is no need for
> + * additional locking beyond the mmap_sem context that these routines
> + * are already executing under.
> + *
> + * Note, there is no protection if the block device is dynamically
> + * resized (partition grow/shrink) during a fault. A stable block device
> + * size is already not enforced in the blkdev_direct_IO path.
> + *
> + * For DAX, it is the responsibility of the block device driver to
> + * ensure the whole-disk device size is stable while requests are in
> + * flight.
> + *
> + * Finally, these paths do not synchronize against freezing
> + * (sb_start_pagefault(), etc...) since bdev_sops does not support
> + * freezing.

Well, for devices freezing is handled directly in the block layer code
(blk_stop_queue()) since there's no need to put some metadata structures
into a consistent state. So the comment about bdev_sops is somewhat
strange. Otherwise the patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.com>

								Honza
 
> + */
> +static int blkdev_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> +{
> +	return __dax_fault(vma, vmf, blkdev_get_block, NULL);
> +}
> +
> +static int blkdev_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
> +		pmd_t *pmd, unsigned int flags)
> +{
> +	return __dax_pmd_fault(vma, addr, pmd, flags, blkdev_get_block, NULL);
> +}
> +
> +static const struct vm_operations_struct blkdev_dax_vm_ops = {
> +	.page_mkwrite	= blkdev_dax_fault,
> +	.fault		= blkdev_dax_fault,
> +	.pmd_fault	= blkdev_dax_pmd_fault,
> +};
> +
> +static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct inode *bd_inode = file_bd_inode(file);
> +
> +	if (!IS_DAX(bd_inode))
> +		return generic_file_mmap(file, vma);
> +
> +	file_accessed(file);
> +	vma->vm_ops = &blkdev_dax_vm_ops;
> +	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
> +	return 0;
> +}
> +#else
> +#define blkdev_mmap generic_file_mmap
> +#endif
> +
>  const struct file_operations def_blk_fops = {
>  	.open		= blkdev_open,
>  	.release	= blkdev_close,
>  	.llseek		= block_llseek,
>  	.read_iter	= blkdev_read_iter,
>  	.write_iter	= blkdev_write_iter,
> -	.mmap		= generic_file_mmap,
> +	.mmap		= blkdev_mmap,
>  	.fsync		= blkdev_fsync,
>  	.unlocked_ioctl	= block_ioctl,
>  #ifdef CONFIG_COMPAT
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
