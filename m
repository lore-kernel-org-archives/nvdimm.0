From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Date: Tue, 13 Sep 2016 17:10:39 -0600
Message-ID: <20160913231039.GF26002@linux.intel.com>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473438884-674-7-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Sep 09, 2016 at 06:34:40PM +0200, Christoph Hellwig wrote:
> Very similar to the existing dax_fault function, but instead of using
> the get_block callback we rely on the iomap_ops vector from iomap.c.
> That also avoids having to do two calls into the file system for write
> faults.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c              | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/iomap.h |   2 +
>  2 files changed, 115 insertions(+)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 57ad456..a170a94 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1343,4 +1343,117 @@ iomap_dax_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	return done;
>  }
>  EXPORT_SYMBOL_GPL(iomap_dax_rw);
> +
> +/**
> + * iomap_dax_fault - handle a page fault on a DAX file
> + * @vma: The virtual memory area where the fault occurred
> + * @vmf: The description of the fault
> + * @ops: iomap ops passed from the file system
> + *
> + * When a page fault occurs, filesystems may call this helper in their fault
> + * or mkwrite handler for DAX files. Sssumes the caller has done all the

					Assumes

> + * necessary locking for the page fault to proceed successfully.
> + */
> +int iomap_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> +			struct iomap_ops *ops)
> +{
> +	struct address_space *mapping = vma->vm_file->f_mapping;
> +	struct inode *inode = mapping->host;
> +	unsigned long vaddr = (unsigned long)vmf->virtual_address;
> +	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
> +	sector_t sector;
> +	struct iomap iomap = { 0 };
> +	unsigned flags = 0;
> +	int error, major = 0;
> +	void *entry;
> +
> +	/*
> +	 * Check whether offset isn't beyond end of file now. Caller is supposed
> +	 * to hold locks serializing us with truncate / punch hole so this is
> +	 * a reliable test.
> +	 */
> +	if (pos >= i_size_read(inode))
> +		return VM_FAULT_SIGBUS;
> +
> +	entry = grab_mapping_entry(mapping, vmf->pgoff);
> +	if (IS_ERR(entry)) {
> +		error = PTR_ERR(entry);
> +		goto out;
> +	}
> +
> +	if ((vmf->flags & FAULT_FLAG_WRITE) && !vmf->cow_page)
> +		flags |= IOMAP_WRITE;
> +
> +	/*
> +	 * Note that we don't bother to use iomap_apply here: DAX required
> +	 * the file system block size to be equal the page size, which means
> +	 * that we never have to deal with more than a single extent here.
> +	 */
> +	error = ops->iomap_begin(inode, pos, PAGE_SIZE, flags, &iomap);
> +	if (error)
> +		goto unlock_entry;
> +	if (WARN_ON_ONCE(iomap.offset + iomap.length < pos + PAGE_SIZE)) {
> +		error = -EIO;		/* fs corruption? */
> +		goto unlock_entry;
> +	}
> +
> +	sector = iomap.blkno + (((pos & PAGE_MASK) - iomap.offset) >> 9);
> +
> +	if (vmf->cow_page) {
> +		switch (iomap.type) {
> +		case IOMAP_HOLE:
> +		case IOMAP_UNWRITTEN:
> +			clear_user_highpage(vmf->cow_page, vaddr);
> +			break;
> +		case IOMAP_MAPPED:
> +			error = copy_user_dax(iomap.bdev, sector, PAGE_SIZE,
> +					vmf->cow_page, vaddr);
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			error = -EIO;
> +			break;
> +		}
> +
> +		if (error)
> +			goto unlock_entry;
> +		if (!radix_tree_exceptional_entry(entry)) {
> +			vmf->page = entry;
> +			return VM_FAULT_LOCKED;
> +		}
> +		vmf->entry = entry;
> +		return VM_FAULT_DAX_LOCKED;
> +	}
> +
> +	switch (iomap.type) {
> +	case IOMAP_MAPPED:
> +		if (iomap.flags & IOMAP_F_NEW) {
> +			count_vm_event(PGMAJFAULT);
> +			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
> +			major = VM_FAULT_MAJOR;
> +		}
> +		break;
> +	case IOMAP_UNWRITTEN:
> +	case IOMAP_HOLE:
> +		if (!(vmf->flags & FAULT_FLAG_WRITE))
> +			return dax_load_hole(mapping, entry, vmf);
> +	default:
> +		WARN_ON_ONCE(1);
> +		error = -EIO;
> +	}
> +
> +	/* Filesystem should not return unwritten buffers to us! */

This comment is above a WARN_ON_ONCE() that checks for unwritten buffers in
dax_fault(), but that test isn't present in this code nor do we disallow
unwritten buffers (apparently, based on the IOMAP_UNWRITTEN handling above).
This comment should probably be removed.

> +	error = dax_insert_mapping(mapping, iomap.bdev, sector, PAGE_SIZE,
> +			&entry, vma, vmf);
> +unlock_entry:

If you stick a space in front of the labels (as is done in the rest of dax.c)
it prevents future patches from using them at the beginning of hunks.  Here's a
patch adding a random space as an example:

@@ -908,6 +908,7 @@ out:
                return VM_FAULT_OOM | major;
        /* -EBUSY is fine, somebody else faulted on the same PTE */
        if ((error < 0) && (error != -EBUSY))
                return VM_FAULT_SIGBUS | major;
+
        return VM_FAULT_NOPAGE | major;
 }

vs

@@ -908,6 +908,7 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
                return VM_FAULT_OOM | major;
        /* -EBUSY is fine, somebody else faulted on the same PTE */
        if ((error < 0) && (error != -EBUSY))
                return VM_FAULT_SIGBUS | major;
+
        return VM_FAULT_NOPAGE | major;
 }

where 'out' is a label without a leading space in the first case and with a
leading space in the second.

With these few nits addressed:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> +	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
> +out:
> +	if (error == -ENOMEM)
> +		return VM_FAULT_OOM | major;
> +	/* -EBUSY is fine, somebody else faulted on the same PTE */
> +	if (error < 0 && error != -EBUSY)
> +		return VM_FAULT_SIGBUS | major;
> +	return VM_FAULT_NOPAGE | major;
> +}
> +EXPORT_SYMBOL_GPL(iomap_dax_fault);
>  #endif /* CONFIG_FS_IOMAP */
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 3d5f785..a4ef953 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -73,6 +73,8 @@ int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
>  		struct iomap_ops *ops);
>  int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  		struct iomap_ops *ops);
> +int iomap_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> +			struct iomap_ops *ops);
>  int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		loff_t start, loff_t len, struct iomap_ops *ops);
>  
> -- 
> 2.1.4
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
