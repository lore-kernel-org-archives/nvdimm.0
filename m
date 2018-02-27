Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 27 Feb 2018 18:02:16 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 06/12] ext2, dax: replace IS_DAX() with IS_FSDAX()
Message-ID: <20180227170216.ubyy676wfniztvx2@quack2.suse.cz>
References: <151970519370.26729.1011551137381425076.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151970522696.26729.5581903247926963915.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151970522696.26729.5581903247926963915.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 26-02-18 20:20:27, Dan Williams wrote:
> In preparation for fixing the broken definition of S_DAX in the
> CONFIG_FS_DAX=n + CONFIG_DEV_DAX=y case, convert all IS_DAX() usages to
> use explicit tests for FSDAX since DAX is ambiguous.
> 
> Cc: Jan Kara <jack@suse.com>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: <stable@vger.kernel.org>
> Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/ext2/file.c  |    6 +++---
>  fs/ext2/inode.c |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> 
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index 5ac98d074323..702a36df6c01 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -119,7 +119,7 @@ static const struct vm_operations_struct ext2_dax_vm_ops = {
>  
>  static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> -	if (!IS_DAX(file_inode(file)))
> +	if (!IS_FSDAX(file_inode(file)))
>  		return generic_file_mmap(file, vma);
>  
>  	file_accessed(file);
> @@ -158,14 +158,14 @@ int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  
>  static ssize_t ext2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  {
> -	if (IS_DAX(iocb->ki_filp->f_mapping->host))
> +	if (IS_FSDAX(iocb->ki_filp->f_mapping->host))
>  		return ext2_dax_read_iter(iocb, to);
>  	return generic_file_read_iter(iocb, to);
>  }
>  
>  static ssize_t ext2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  {
> -	if (IS_DAX(iocb->ki_filp->f_mapping->host))
> +	if (IS_FSDAX(iocb->ki_filp->f_mapping->host))
>  		return ext2_dax_write_iter(iocb, from);
>  	return generic_file_write_iter(iocb, from);
>  }
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index e04295e99d90..72284f9fd034 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -733,7 +733,7 @@ static int ext2_get_blocks(struct inode *inode,
>  		goto cleanup;
>  	}
>  
> -	if (IS_DAX(inode)) {
> +	if (IS_FSDAX(inode)) {
>  		/*
>  		 * We must unmap blocks before zeroing so that writeback cannot
>  		 * overwrite zeros with stale data from block device page cache.
> @@ -940,7 +940,7 @@ ext2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>  	loff_t offset = iocb->ki_pos;
>  	ssize_t ret;
>  
> -	if (WARN_ON_ONCE(IS_DAX(inode)))
> +	if (WARN_ON_ONCE(IS_FSDAX(inode)))
>  		return -EIO;
>  
>  	ret = blockdev_direct_IO(iocb, inode, iter, ext2_get_block);
> @@ -1294,7 +1294,7 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
>  
>  	inode_dio_wait(inode);
>  
> -	if (IS_DAX(inode)) {
> +	if (IS_FSDAX(inode)) {
>  		error = iomap_zero_range(inode, newsize,
>  					 PAGE_ALIGN(newsize) - newsize, NULL,
>  					 &ext2_iomap_ops);
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
