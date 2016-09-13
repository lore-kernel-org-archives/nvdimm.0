From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 05/10] dax: provide an iomap based dax read/write path
Date: Tue, 13 Sep 2016 17:00:56 -0600
Message-ID: <20160913230056.GE26002@linux.intel.com>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473438884-674-6-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Sep 09, 2016 at 06:34:39PM +0200, Christoph Hellwig wrote:
> This is a much simpler implementation of the DAX read/write path that makes
> use of the iomap infrastructure.  It does not try to mirror the direct I/O
> calling conventions and thus doesn't have to deal with i_dio_count or the
> end_io handler, but instead leaves locking and filesystem-specific I/O
> completion to the caller.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  fs/dax.c              | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/iomap.h |   2 +
>  2 files changed, 105 insertions(+)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 84343ce..57ad456 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -31,6 +31,8 @@
>  #include <linux/vmstat.h>
>  #include <linux/pfn_t.h>
>  #include <linux/sizes.h>
> +#include <linux/iomap.h>
> +#include "internal.h"
>  
>  /*
>   * We use lowest available bit in exceptional entry for locking, other two
> @@ -1241,3 +1243,104 @@ int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
>  	return dax_zero_page_range(inode, from, length, get_block);
>  }
>  EXPORT_SYMBOL_GPL(dax_truncate_page);
> +
> +#ifdef CONFIG_FS_IOMAP
> +static loff_t
> +iomap_dax_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> +		struct iomap *iomap)
> +{
> +	struct iov_iter *iter = data;
> +	loff_t end = pos + length, done = 0;
> +	ssize_t ret = 0;
> +
> +	if (iov_iter_rw(iter) == READ) {
> +		end = min(end, i_size_read(inode));
> +		if (pos >= end)
> +			return 0;
> +
> +		if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_UNWRITTEN)
> +			return iov_iter_zero(min(length, end - pos), iter);
> +	}
> +
> +	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED))
> +		return -EIO;
> +
> +	while (pos < end) {
> +		unsigned offset = pos & (PAGE_SIZE - 1);
> +		struct blk_dax_ctl dax = { 0 };
> +		ssize_t map_len;
> +
> +		dax.sector = iomap->blkno +
> +			(((pos & PAGE_MASK) - iomap->offset) >> 9);
> +		dax.size = (length + offset + PAGE_SIZE - 1) & PAGE_MASK;
> +		map_len = dax_map_atomic(iomap->bdev, &dax);
> +		if (map_len < 0) {
> +			ret = map_len;
> +			break;
> +		}
> +
> +		dax.addr += offset;
> +		map_len -= offset;
> +		if (map_len > end - pos)
> +			map_len = end - pos;
> +
> +		if (iov_iter_rw(iter) == WRITE)
> +			map_len = copy_from_iter_pmem(dax.addr, map_len, iter);
> +		else
> +			map_len = copy_to_iter(dax.addr, map_len, iter);
> +		dax_unmap_atomic(iomap->bdev, &dax);
> +		if (map_len <= 0) {
> +			ret = map_len ? map_len : -EFAULT;
> +			break;
> +		}
> +
> +		pos += map_len;
> +		length -= map_len;
> +		done += map_len;
> +	}
> +
> +	return done ? done : ret;
> +}
> +
> +/**
> + * iomap_dax_rw - Perform I/O to a DAX file
> + * @iocb: The control block for this I/O
> + * @iter: The addresses to do I/O from or to
> + * @ops: iomap ops passed from the file system
> + *
> + * This funtions performs read and write operations to directly mapped

	   function

> + * persistent memory.  The callers needs to take care of read/write exclusion
> + * and evicting any page cache pages in the region under I/O.
> + */
> +ssize_t
> +iomap_dax_rw(struct kiocb *iocb, struct iov_iter *iter,
> +		struct iomap_ops *ops)
> +{
> +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> +	loff_t pos = iocb->ki_pos, ret = 0, done = 0;

Just a note that 'ret' is loff_t about half the time in the iomap code and
ssize_t the other half.  I guess it doesn't really matter since they should
both be big unsigned values (64 bits on x96_64), but it's a bit inconsistent.

> +	size_t count = iov_iter_count(iter);
> +	unsigned flags = 0;
> +
> +	if (!count)
> +		return 0;
> +
> +	if (iov_iter_rw(iter) == WRITE)
> +		flags |= IOMAP_WRITE;
> +
> +	do {
> +		ret = iomap_apply(inode, pos, count, flags, ops, iter,
> +				  iomap_dax_actor);
> +		if (ret <= 0)
> +			break;
> +		pos += ret;
> +		done += ret;
> +	} while ((count = iov_iter_count(iter)));
> +
> +	if (!done)
> +		return ret;
> +
> +	iocb->ki_pos += done;
> +	return done;
> +}

I think you can remove the special casing around 'done' and 'count' and make
this a bit simpler:

ssize_t
iomap_dax_rw(struct kiocb *iocb, struct iov_iter *iter,
		struct iomap_ops *ops)
{
	struct inode *inode = iocb->ki_filp->f_mapping->host;
	loff_t pos = iocb->ki_pos, ret = 0, done = 0;
	unsigned flags = 0;
	size_t count;

	if (iov_iter_rw(iter) == WRITE)
		flags |= IOMAP_WRITE;

	 while ((count = iov_iter_count(iter))) {
		ret = iomap_apply(inode, pos, count, flags, ops, iter,
				  iomap_dax_actor);
		if (ret <= 0)
			break;
		pos += ret;
		done += ret;
	}

	iocb->ki_pos += done;
	return done ? done : ret;
}

This is now very similar to iomap_file_buffered_write().

> +EXPORT_SYMBOL_GPL(iomap_dax_rw);
> +#endif /* CONFIG_FS_IOMAP */
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 14d7067..3d5f785 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -65,6 +65,8 @@ struct iomap_ops {
>  
>  ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
>  		struct iomap_ops *ops);
> +ssize_t iomap_dax_rw(struct kiocb *iocb, struct iov_iter *iter,
> +		struct iomap_ops *ops);
>  int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
>  		bool *did_zero, struct iomap_ops *ops);
>  int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
> -- 
> 2.1.4
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
