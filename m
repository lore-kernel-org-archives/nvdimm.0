Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 7 Aug 2015 07:04:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] dax: update I/O path to do proper PMEM flushing
Message-ID: <20150806210457.GC16638@dastard>
References: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
 <1438883000-9011-7-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1438883000-9011-7-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, Matthew Wilcox <willy@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 06, 2015 at 11:43:20AM -0600, Ross Zwisler wrote:
> Update the DAX I/O path so that all operations that store data (I/O
> writes, zeroing blocks, punching holes, etc.) properly synchronize the
> stores to media using the PMEM API.  This ensures that the data DAX is
> writing is durable on media before the operation completes.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
....
> +		if (pgsz < PAGE_SIZE) {
>  				memset(addr, 0, pgsz);
> -			else
> +				wb_cache_pmem((void __pmem *)addr, pgsz);
> +			} else {
>  				clear_page(addr);
> +				wb_cache_pmem((void __pmem *)addr, PAGE_SIZE);
> +			}

I'd much prefer to see these wrapped up in helper fuctions e.g.
clear_page_pmem() rather than scatter them around randomly.
Especially the barriers - the way they've been optimised is asking
for people to get it wrong in the future.  I'd much prefer to see
the operations paired properly in a helper first (i.e. obviously
correct) and then it can be optimised later if workloads start to
show the barrier as a bottleneck...

> +/*
> + * This function's stores and flushes need to be synced to media by a
> + * wmb_pmem() in the caller. We flush the data instead of writing it back
> + * because we don't expect to read this newly zeroed data in the near future.
> + */

That seems suboptimal. dax_new_buf() is called on newly allocated or
unwritten buffers we are about to write to. Immediately after this
we write the new data to the page, so we are effectively writting
the whole page here.

So why wouldn't we simply commit the whole page during the write and
capture all this zeroing in the one flush/commit/barrier op?

>  static void dax_new_buf(void *addr, unsigned size, unsigned first, loff_t pos,
>  			loff_t end)
>  {
>  	loff_t final = end - pos + first; /* The final byte of the buffer */
>  
> -	if (first > 0)
> +	if (first > 0) {
>  		memset(addr, 0, first);
> -	if (final < size)
> +		flush_cache_pmem((void __pmem *)addr, first);
> +	}
> +	if (final < size) {
>  		memset(addr + final, 0, size - final);
> +		flush_cache_pmem((void __pmem *)addr + final, size - final);
> +	}
>  }
>  
>  static bool buffer_written(struct buffer_head *bh)
> @@ -108,6 +123,7 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
>  	loff_t bh_max = start;
>  	void *addr;
>  	bool hole = false;
> +	bool need_wmb = false;
>  
>  	if (iov_iter_rw(iter) != WRITE)
>  		end = min(end, i_size_read(inode));
> @@ -145,18 +161,23 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
>  				retval = dax_get_addr(bh, &addr, blkbits);
>  				if (retval < 0)
>  					break;
> -				if (buffer_unwritten(bh) || buffer_new(bh))
> +				if (buffer_unwritten(bh) || buffer_new(bh)) {
>  					dax_new_buf(addr, retval, first, pos,
>  									end);
> +					need_wmb = true;
> +				}
>  				addr += first;
>  				size = retval - first;
>  			}
>  			max = min(pos + size, end);
>  		}
>  
> -		if (iov_iter_rw(iter) == WRITE)
> +		if (iov_iter_rw(iter) == WRITE) {
>  			len = copy_from_iter_nocache(addr, max - pos, iter);
> -		else if (!hole)
> +			if (!iter_is_iovec(iter))
> +				wb_cache_pmem((void __pmem *)addr, max - pos);
> +			need_wmb = true;

Conditional pmem cache writeback after a "nocache" copy to the pmem?
Comments, please.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
