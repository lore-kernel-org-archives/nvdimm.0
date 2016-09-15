From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/12] xfs: use iomap to implement DAX
Date: Wed, 14 Sep 2016 22:29:33 -0700
Message-ID: <20160915052933.GH9314@birch.djwong.org>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
 <1473847291-18913-11-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473847291-18913-11-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, ross.zwisler@linux.intel.com, Dave Chinner <david@fromorbit.com>
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 14, 2016 at 12:01:29PM +0200, Christoph Hellwig wrote:
> Another users of buffer_heads bytes the dust.

Yay!

Babbling below. :)

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c  | 61 +++++++++++++++---------------------------------------
>  fs/xfs/xfs_iomap.c | 11 ++++++----
>  2 files changed, 24 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 62649cc..663634f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -332,10 +332,7 @@ xfs_file_dax_read(
>  	struct kiocb		*iocb,
>  	struct iov_iter		*to)
>  {
> -	struct address_space	*mapping = iocb->ki_filp->f_mapping;
> -	struct inode		*inode = mapping->host;
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	struct iov_iter		data = *to;
> +	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
>  	size_t			count = iov_iter_count(to);
>  	ssize_t			ret = 0;
>  
> @@ -345,11 +342,7 @@ xfs_file_dax_read(
>  		return 0; /* skip atime */
>  
>  	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
> -	ret = dax_do_io(iocb, inode, &data, xfs_get_blocks_direct, NULL, 0);
> -	if (ret > 0) {
> -		iocb->ki_pos += ret;
> -		iov_iter_advance(to, ret);
> -	}
> +	ret = iomap_dax_rw(iocb, to, &xfs_iomap_ops);
>  	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
>  
>  	file_accessed(iocb->ki_filp);
> @@ -711,52 +704,32 @@ xfs_file_dax_write(
>  	struct kiocb		*iocb,
>  	struct iov_iter		*from)
>  {
> -	struct address_space	*mapping = iocb->ki_filp->f_mapping;
> -	struct inode		*inode = mapping->host;
> +	struct inode		*inode = iocb->ki_filp->f_mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
> -	ssize_t			ret = 0;
>  	int			iolock = XFS_IOLOCK_EXCL;
> -	struct iov_iter		data;
> +	ssize_t			ret, error = 0;
> +	size_t			count;
> +	loff_t			pos;
>  
>  	xfs_rw_ilock(ip, iolock);
>  	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
>  	if (ret)
>  		goto out;
>  
> -	/*
> -	 * Yes, even DAX files can have page cache attached to them:  A zeroed
> -	 * page is inserted into the pagecache when we have to serve a write
> -	 * fault on a hole.  It should never be dirtied and can simply be
> -	 * dropped from the pagecache once we get real data for the page.
> -	 *
> -	 * XXX: This is racy against mmap, and there's nothing we can do about
> -	 * it. dax_do_io() should really do this invalidation internally as
> -	 * it will know if we've allocated over a holei for this specific IO and
> -	 * if so it needs to update the mapping tree and invalidate existing
> -	 * PTEs over the newly allocated range. Remove this invalidation when
> -	 * dax_do_io() is fixed up.
> -	 */
> -	if (mapping->nrpages) {
> -		loff_t end = iocb->ki_pos + iov_iter_count(from) - 1;
> -
> -		ret = invalidate_inode_pages2_range(mapping,
> -						    iocb->ki_pos >> PAGE_SHIFT,
> -						    end >> PAGE_SHIFT);
> -		WARN_ON_ONCE(ret);
> -	}
> +	pos = iocb->ki_pos;
> +	count = iov_iter_count(from);
>  
> -	trace_xfs_file_dax_write(ip, iov_iter_count(from), iocb->ki_pos);
> +	trace_xfs_file_dax_write(ip, count, pos);
>  
> -	data = *from;
> -	ret = dax_do_io(iocb, inode, &data, xfs_get_blocks_direct,
> -			xfs_end_io_direct_write, 0);
> -	if (ret > 0) {
> -		iocb->ki_pos += ret;
> -		iov_iter_advance(from, ret);
> +	ret = iomap_dax_rw(iocb, from, &xfs_iomap_ops);
> +	if (ret > 0 && iocb->ki_pos > i_size_read(inode)) {
> +		i_size_write(inode, iocb->ki_pos);
> +		error = xfs_setfilesize(ip, pos, count);
>  	}
> +
>  out:
>  	xfs_rw_iunlock(ip, iolock);
> -	return ret;
> +	return error ? error : ret;
>  }
>  
>  STATIC ssize_t
> @@ -1495,7 +1468,7 @@ xfs_filemap_page_mkwrite(
>  	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  
>  	if (IS_DAX(inode)) {
> -		ret = dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault);
> +		ret = iomap_dax_fault(vma, vmf, &xfs_iomap_ops);
>  	} else {
>  		ret = iomap_page_mkwrite(vma, vmf, &xfs_iomap_ops);
>  		ret = block_page_mkwrite_return(ret);
> @@ -1529,7 +1502,7 @@ xfs_filemap_fault(
>  		 * changes to xfs_get_blocks_direct() to map unwritten extent
>  		 * ioend for conversion on read-only mappings.
>  		 */
> -		ret = dax_fault(vma, vmf, xfs_get_blocks_dax_fault);
> +		ret = iomap_dax_fault(vma, vmf, &xfs_iomap_ops);
>  	} else
>  		ret = filemap_fault(vma, vmf);
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index c3cc175..23f7811 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -935,11 +935,13 @@ error_on_bmapi_transaction:
>  	return error;
>  }
>  
> -static inline bool imap_needs_alloc(struct xfs_bmbt_irec *imap, int nimaps)
> +static inline bool imap_needs_alloc(struct inode *inode,
> +		struct xfs_bmbt_irec *imap, int nimaps)
>  {
>  	return !nimaps ||
>  		imap->br_startblock == HOLESTARTBLOCK ||
> -		imap->br_startblock == DELAYSTARTBLOCK;
> +		imap->br_startblock == DELAYSTARTBLOCK ||
> +		(IS_DAX(inode) && ISUNWRITTEN(imap));
>  }
>  
>  static int
> @@ -960,7 +962,8 @@ xfs_file_iomap_begin(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	if ((flags & IOMAP_WRITE) && !xfs_get_extsz_hint(ip)) {
> +	if ((flags & IOMAP_WRITE) &&
> +	    !IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
>  		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
>  				iomap);
>  	}

(Thinking ahead to copy on write with dax, dio, and iomap; I don't have
any objections to the patch itself at this time.)

I'm a little confused about xfs_file_iomap_begin() and IOMAP_WRITE --
prior to this patchset, it was only called via page_mkwrite and what
used to be write_begin, and all it did was create a delalloc reservation
to back the write (or actually allocate blocks if extsize was set).

Now I see that iomap_dax_rw() will also call iomap_begin with
IOMAP_WRITE set in flags.  But in this case we're about to send some
dirty data to pmem, so we really need the extent to map physical
storage, which is taken care of above.

Thinking ahead to integrating reflink with DAX (and presumably
directio) in both cases _file_iomap_begin has to return a real extent.
If the range we're writing is shared, then that means that I'd have to
ensure the range is reserved in the COW fork (the reflink patches already do
this).  Next, if the caller requires a firm mapping (i.e. dax or dio)
I'd have to allocate the range in the COW fork and have that mapping
returned to the caller.

So I guess it would look something like this:

/* reserve reflink cow range like the reflink patches already do */
if (flags & (IOMAP_WRITE | IOMAP_ZERO) && xfs_is_reflink_inode(ip))
	xfs_reflink_reserve_cow_range(ip, offset, length);

/* do the cow thing if need be */
if ((flags & IOMAP_WRITE) &&
    xfs_is_reflink_inode(ip) &&
    (IS_DAX(inode) || (flags & IOMAP_DIO)) {
	xfs_reflink_allocate_cow_range(ip, offset, length);

	if (xfs_reflink_is_cow_pending(ip, offset))
		xfs_reflink_find_cow_mapping(ip, offset, &imap, &need_alloc);
	else
		xfs_bmapi_read(offset, &imap)
} else
	xfs_bmapi_read(offset, &imap) /* non-cow io */

Does that look plausible?  If _iomap_begin will have one type of caller
that only needs a delalloc reservation and another type that actually
needs a firm mapping, should we make a new IOMAP flag to indicate that
the caller really needs a firm mapping?  IS_DAX is fine for detecting
the DAX case as this patchset shows, but what about directio?

(At this point Dave suggests on IRC that we just make a dio specific
iomap_begin.  That eliminates the flag, though it'd be a fairly similar
function.)

DAX has another twist in there -- prior to making a writable mapping,
we'd have to allocate the cow extent, copy the contents (if unaligned),
and invalidate all the old mappings so that everyone can fault in the
new storage location.  I think.  Sleep now.

--D

> @@ -980,7 +983,7 @@ xfs_file_iomap_begin(
>  		return error;
>  	}
>  
> -	if ((flags & IOMAP_WRITE) && imap_needs_alloc(&imap, nimaps)) {
> +	if ((flags & IOMAP_WRITE) && imap_needs_alloc(inode, &imap, nimaps)) {
>  		/*
>  		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
>  		 * pages to keep the chunks of work done where somewhat symmetric
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
