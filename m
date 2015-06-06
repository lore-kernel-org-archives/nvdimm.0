Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Sat, 6 Jun 2015 07:58:22 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v4 4/9] dax: fix mapping lifetime handling, convert to
 __pfn_t + kmap_atomic_pfn_t()
Message-ID: <20150606115822.GI2729@linux.intel.com>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150605211924.20751.434.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150605211924.20751.434.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, arnd@arndb.de, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, hch@lst.de, mingo@kernel.org, tj@kernel.org, paulus@samba.org, hpa@zytor.com, schwidefsky@de.ibm.com, ross.zwisler@linux.intel.com, torvalds@linux-foundation.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 05, 2015 at 05:19:24PM -0400, Dan Williams wrote:
> @@ -35,13 +35,16 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
>  	might_sleep();
>  	do {
>  		void *addr;
> -		unsigned long pfn;
> +		__pfn_t pfn;
>  		long count;
>  
> -		count = bdev_direct_access(bdev, sector, &addr, &pfn, size);
> +		count = bdev_direct_access(bdev, sector, &pfn, size);
>  		if (count < 0)
>  			return count;
>  		BUG_ON(size < count);
> +		addr = kmap_atomic_pfn_t(pfn);
> +		if (!addr)
> +			return -EIO;
>  		while (count > 0) {
>  			unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
>  			if (pgsz > count)

This part is incomplete.  When bdev_direct_access() could return an
address, it was possible for that address to be unaligned (eg when
'sector' was not a multiple of 8).  DAX has never had full support for
devices that weren't a 4k sector size, but I was trying to not make that
assumption in more places than I had to.  So this function needs a lot
more simplification (or it needs to add '(sector & 7) << 9' to addr ...
assuming that the partition this bdev represents actually starts at a
multiple of 8 ... bleh!).

>  
> -static long dax_get_addr(struct buffer_head *bh, void **addr, unsigned blkbits)
> +static long dax_get_pfn(struct buffer_head *bh, __pfn_t *pfn, unsigned blkbits)
>  {
> -	unsigned long pfn;
>  	sector_t sector = bh->b_blocknr << (blkbits - 9);
> -	return bdev_direct_access(bh->b_bdev, sector, addr, &pfn, bh->b_size);
> +	return bdev_direct_access(bh->b_bdev, sector, pfn, bh->b_size);
>  }

This function should just be deleted.  It offers essentially nothing
over just calling bdev_direct_access().

> @@ -142,9 +146,19 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
>  				addr = NULL;
>  				size = bh->b_size - first;
>  			} else {
> -				retval = dax_get_addr(bh, &addr, blkbits);
> +				if (kmap) {
> +					kunmap_atomic_pfn_t(kmap);
> +					kmap = NULL;
> +				}
> +				retval = dax_get_pfn(bh, &pfn, blkbits);
>  				if (retval < 0)
>  					break;
> +				kmap = kmap_atomic_pfn_t(pfn);
> +				if (!kmap) {
> +					retval = -EIO;
> +					break;
> +				}
> +				addr = kmap;
>  				if (buffer_unwritten(bh) || buffer_new(bh))
>  					dax_new_buf(addr, retval, first, pos,
>  									end);

Interesting approach.  The patch I sent you was more complex ... this
probably ends up working out better since it has fewer places to check
for kmap returning an error.

