From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 10/12] xfs: use iomap to implement DAX
Date: Wed, 14 Sep 2016 11:32:47 -0600
Message-ID: <20160914173247.GC30852@linux.intel.com>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
 <1473847291-18913-11-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473847291-18913-11-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
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

On Wed, Sep 14, 2016 at 12:01:29PM +0200, Christoph Hellwig wrote:
> Another users of buffer_heads bytes the dust.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  fs/xfs/xfs_file.c  | 61 +++++++++++++++---------------------------------------
>  fs/xfs/xfs_iomap.c | 11 ++++++----
>  2 files changed, 24 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 62649cc..663634f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
<>
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

I think this should be xfs_setfilesize(ip, pos, ret)?  'count' and 'ret' are
the same in non-error cases, but in error cases where iomap_dax_rw() does some
work and then encounters an error, 'ret' could be smaller.  In error cases
like this using 'ret' instead of 'count' will also keep the value we use in
i_size_write() equal to what we write via xfs_setfilesize() because
iocb->ki_pos == pos+ret, not pos+count.

Aside from that, even though I'm sure you'll want a review from an XFS
developer:

Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
