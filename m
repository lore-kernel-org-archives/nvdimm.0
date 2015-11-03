Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 3 Nov 2015 12:01:40 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 03/15] block, dax: fix lifetime of in-kernel dax
 mappings with dax_map_atomic()
Message-ID: <20151103190140.GB23366@linux.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151102042958.6610.65193.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151102042958.6610.65193.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@fb.com, Jens Axboe <axboe@kernel.dk>, jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.com>, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Nov 01, 2015 at 11:29:58PM -0500, Dan Williams wrote:
> The DAX implementation needs to protect new calls to ->direct_access()
> and usage of its return value against unbind of the underlying block
> device.  Use blk_queue_enter()/blk_queue_exit() to either prevent
> blk_cleanup_queue() from proceeding, or fail the dax_map_atomic() if the
> request_queue is being torn down.
> 
> Cc: Jan Kara <jack@suse.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
<>
> @@ -42,9 +76,9 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
>  		long count, sz;
>  
>  		sz = min_t(long, size, SZ_1M);
> -		count = bdev_direct_access(bdev, sector, &addr, &pfn, sz);
> -		if (count < 0)
> -			return count;
> +		addr = __dax_map_atomic(bdev, sector, size, &pfn, &count);

I think you can use dax_map_atomic() here instead, allowing you to avoid
having a local pfn variable that otherwise goes unused.

> @@ -138,21 +176,27 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
>  				bh->b_size -= done;
>  			}
>  
> -			hole = iov_iter_rw(iter) != WRITE && !buffer_written(bh);
> +			hole = rw == READ && !buffer_written(bh);
>  			if (hole) {
>  				addr = NULL;
>  				size = bh->b_size - first;
>  			} else {
> -				retval = dax_get_addr(bh, &addr, blkbits);
> -				if (retval < 0)
> +				dax_unmap_atomic(bdev, kmap);
> +				kmap = __dax_map_atomic(bdev,
> +						to_sector(bh, inode),
> +						bh->b_size, &pfn, &map_len);

Same as above, you can use dax_map_atomic() here instead and nix the pfn variable.

> @@ -305,11 +353,10 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
>  		goto out;
>  	}
>  
> -	error = bdev_direct_access(bh->b_bdev, sector, &addr, &pfn, bh->b_size);
> -	if (error < 0)
> -		goto out;
> -	if (error < PAGE_SIZE) {
> -		error = -EIO;
> +	addr = __dax_map_atomic(bdev, to_sector(bh, inode), bh->b_size,
> +			&pfn, NULL);
> +	if (IS_ERR(addr)) {
> +		error = PTR_ERR(addr);

Just a note that we lost the check for bdev_direct_access() returning less
than PAGE_SIZE.  Are we sure this can't happen and that it's safe to remove
the check?

> @@ -609,15 +655,20 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  		result = VM_FAULT_NOPAGE;
>  		spin_unlock(ptl);
>  	} else {
> -		sector = bh.b_blocknr << (blkbits - 9);
> -		length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
> -						bh.b_size);
> -		if (length < 0) {
> +		long length;
> +		unsigned long pfn;
> +		void __pmem *kaddr = __dax_map_atomic(bdev,
> +				to_sector(&bh, inode), HPAGE_SIZE, &pfn,
> +				&length);

Let's use PMD_SIZE instead of HPAGE_SIZE to be consistent with the rest of the
DAX code.

> +
> +		if (IS_ERR(kaddr)) {
>  			result = VM_FAULT_SIGBUS;
>  			goto out;
>  		}
> -		if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
> +		if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR)) {
> +			dax_unmap_atomic(bdev, kaddr);
>  			goto fallback;
> +		}
>  
>  		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
>  			clear_pmem(kaddr, HPAGE_SIZE);

Ditto, let's use PMD_SIZE for consistency (I realize this was changed ealier
in the series).
