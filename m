Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 29 Jan 2016 10:54:07 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/2] block: revert runtime dax control of the raw block
 device
Message-ID: <20160129175407.GA5224@linux.intel.com>
References: <20160129151835.18752.9423.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160129151841.18752.6457.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160129151841.18752.6457.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, axboe@fb.com, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 29, 2016 at 07:18:41AM -0800, Dan Williams wrote:
> Dynamically enabling DAX requires that the page cache first be flushed
> and invalidated.  This must occur atomically with the change of DAX mode
> otherwise we confuse the fsync/msync tracking and violate data
> durability guarantees.  Eliminate the possibilty of DAX-disabled to
> DAX-enabled transitions for now and revisit this for the next cycle.
> 
> Cc: Jan Kara <jack@suse.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Matthew Wilcox <willy@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Sure, makes sense.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> ---
>  block/ioctl.c           |   38 --------------------------------------
>  fs/block_dev.c          |   28 ----------------------------
>  include/linux/fs.h      |    3 ---
>  include/uapi/linux/fs.h |    1 -
>  4 files changed, 70 deletions(-)
> 
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 77f5d17779d6..d8996bbd7f12 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -434,42 +434,6 @@ bool blkdev_dax_capable(struct block_device *bdev)
>  
>  	return true;
>  }
> -
> -static int blkdev_daxset(struct block_device *bdev, unsigned long argp)
> -{
> -	unsigned long arg;
> -	int rc = 0;
> -
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EACCES;
> -
> -	if (get_user(arg, (int __user *)(argp)))
> -		return -EFAULT;
> -	arg = !!arg;
> -	if (arg == !!(bdev->bd_inode->i_flags & S_DAX))
> -		return 0;
> -
> -	if (arg)
> -		arg = S_DAX;
> -
> -	if (arg && !blkdev_dax_capable(bdev))
> -		return -ENOTTY;
> -
> -	inode_lock(bdev->bd_inode);
> -	if (bdev->bd_map_count == 0)
> -		inode_set_flags(bdev->bd_inode, arg, S_DAX);
> -	else
> -		rc = -EBUSY;
> -	inode_unlock(bdev->bd_inode);
> -	return rc;
> -}
> -#else
> -static int blkdev_daxset(struct block_device *bdev, int arg)
> -{
> -	if (arg)
> -		return -ENOTTY;
> -	return 0;
> -}
>  #endif
>  
>  static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
> @@ -634,8 +598,6 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>  	case BLKTRACESETUP:
>  	case BLKTRACETEARDOWN:
>  		return blk_trace_ioctl(bdev, cmd, argp);
> -	case BLKDAXSET:
> -		return blkdev_daxset(bdev, arg);
>  	case BLKDAXGET:
>  		return put_int(arg, !!(bdev->bd_inode->i_flags & S_DAX));
>  		break;
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 7b9cd49622b1..afb437484362 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1736,37 +1736,13 @@ static int blkdev_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
>  	return __dax_pmd_fault(vma, addr, pmd, flags, blkdev_get_block, NULL);
>  }
>  
> -static void blkdev_vm_open(struct vm_area_struct *vma)
> -{
> -	struct inode *bd_inode = bdev_file_inode(vma->vm_file);
> -	struct block_device *bdev = I_BDEV(bd_inode);
> -
> -	inode_lock(bd_inode);
> -	bdev->bd_map_count++;
> -	inode_unlock(bd_inode);
> -}
> -
> -static void blkdev_vm_close(struct vm_area_struct *vma)
> -{
> -	struct inode *bd_inode = bdev_file_inode(vma->vm_file);
> -	struct block_device *bdev = I_BDEV(bd_inode);
> -
> -	inode_lock(bd_inode);
> -	bdev->bd_map_count--;
> -	inode_unlock(bd_inode);
> -}
> -
>  static const struct vm_operations_struct blkdev_dax_vm_ops = {
> -	.open		= blkdev_vm_open,
> -	.close		= blkdev_vm_close,
>  	.fault		= blkdev_dax_fault,
>  	.pmd_fault	= blkdev_dax_pmd_fault,
>  	.pfn_mkwrite	= blkdev_dax_fault,
>  };
>  
>  static const struct vm_operations_struct blkdev_default_vm_ops = {
> -	.open		= blkdev_vm_open,
> -	.close		= blkdev_vm_close,
>  	.fault		= filemap_fault,
>  	.map_pages	= filemap_map_pages,
>  };
> @@ -1774,18 +1750,14 @@ static const struct vm_operations_struct blkdev_default_vm_ops = {
>  static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>  	struct inode *bd_inode = bdev_file_inode(file);
> -	struct block_device *bdev = I_BDEV(bd_inode);
>  
>  	file_accessed(file);
> -	inode_lock(bd_inode);
> -	bdev->bd_map_count++;
>  	if (IS_DAX(bd_inode)) {
>  		vma->vm_ops = &blkdev_dax_vm_ops;
>  		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
>  	} else {
>  		vma->vm_ops = &blkdev_default_vm_ops;
>  	}
> -	inode_unlock(bd_inode);
>  
>  	return 0;
>  }
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index b10002d4a5f5..ae681002100a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -484,9 +484,6 @@ struct block_device {
>  	int			bd_fsfreeze_count;
>  	/* Mutex for freeze */
>  	struct mutex		bd_fsfreeze_mutex;
> -#ifdef CONFIG_FS_DAX
> -	int			bd_map_count;
> -#endif
>  };
>  
>  /*
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 41e0433b4a83..149bec83a907 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -222,7 +222,6 @@ struct fsxattr {
>  #define BLKSECDISCARD _IO(0x12,125)
>  #define BLKROTATIONAL _IO(0x12,126)
>  #define BLKZEROOUT _IO(0x12,127)
> -#define BLKDAXSET _IO(0x12,128)
>  #define BLKDAXGET _IO(0x12,129)
>  
>  #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
> 
