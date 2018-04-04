Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 26F322264A1E8
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 02:55:20 -0700 (PDT)
Date: Wed, 4 Apr 2018 11:55:18 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v8 18/18] xfs, dax: introduce xfs_break_dax_layouts()
Message-ID: <20180404095518.65exgpxuca3tqhav@quack2.suse.cz>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152246902607.36038.15813002361509305325.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152246902607.36038.15813002361509305325.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, snitzer@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 30-03-18 21:03:46, Dan Williams wrote:
> xfs_break_dax_layouts(), similar to xfs_break_leased_layouts(), scans
> for busy / pinned dax pages and waits for those pages to go idle before
> any potential extent unmap operation.
> 
> dax_layout_busy_page() handles synchronizing against new page-busy
> events (get_user_pages). It invalidates all mappings to trigger the
> get_user_pages slow path which will eventually block on the xfs inode
> lock held in XFS_MMAPLOCK_EXCL mode. If dax_layout_busy_page() finds a
> busy page it returns it for xfs to wait for the page-idle event that
> will fire when the page reference count reaches 1 (recall ZONE_DEVICE
> pages are idle at count 1, see generic_dax_pagefree()).
> 
> While waiting, the XFS_MMAPLOCK_EXCL lock is dropped in order to not
> deadlock the process that might be trying to elevate the page count of
> more pages before arranging for any of them to go idle. I.e. the typical
> case of submitting I/O is that iov_iter_get_pages() elevates the
> reference count of all pages in the I/O before starting I/O on the first
> page. The process of elevating the reference count of all pages involved
> in an I/O may cause faults that need to take XFS_MMAPLOCK_EXCL.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

...

> ---
>  fs/xfs/xfs_file.c |   60 +++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 49 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 51e6506bdcb1..0342f6fb782f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -752,6 +752,38 @@ xfs_file_write_iter(
>  	return ret;
>  }
>  
> +static void
> +xfs_wait_var_event(
> +	struct inode		*inode,
> +	uint			iolock,
> +	bool			*did_unlock)
> +{
> +	struct xfs_inode        *ip = XFS_I(inode);
> +
> +	*did_unlock = true;
> +	xfs_iunlock(ip, iolock);
> +	schedule();
> +	xfs_ilock(ip, iolock);
> +}

With this scheme, there's a problem that it can be easily livelocked. E.g.
when I created a program that maps a file on DAX fs and does AIO DIO from
it indefinitely (with 64 iocbs in flight), truncate of that file never gets
past xfs_break_layouts(). The reason is that once we drop all locks, new
iocbs can be submitted, they grab new page references and these prevent
truncation next time... So I think we need to somehow fix this retry scheme
so that we guarantee forward progress of the truncate. E.g. if we kept
IOLOCK locked, that would prevent new iocbs from being submitted...

								Honza


> +
> +static int
> +xfs_break_dax_layouts(
> +	struct inode		*inode,
> +	uint			iolock,
> +	bool			*did_unlock)
> +{
> +	struct page		*page;
> +
> +	*did_unlock = false;
> +	page = dax_layout_busy_page(inode->i_mapping);
> +	if (!page)
> +		return 0;
> +
> +	return ___wait_var_event(&page->_refcount,
> +			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
> +			0, 0, xfs_wait_var_event(inode, iolock, did_unlock));
> +}
> +
>  int
>  xfs_break_layouts(
>  	struct inode		*inode,
> @@ -763,17 +795,23 @@ xfs_break_layouts(
>  
>  	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
>  
> -	switch (reason) {
> -	case BREAK_UNMAP:
> -		ASSERT(xfs_isilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL));
> -		/* fall through */
> -	case BREAK_WRITE:
> -		error = xfs_break_leased_layouts(inode, iolock, &retry);
> -		break;
> -	default:
> -		WARN_ON_ONCE(1);
> -		return -EINVAL;
> -	}
> +	do {
> +		switch (reason) {
> +		case BREAK_UNMAP:
> +			ASSERT(xfs_isilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL));
> +
> +			error = xfs_break_dax_layouts(inode, *iolock, &retry);
> +			/* fall through */
> +		case BREAK_WRITE:
> +			if (error || retry)
> +				break;
> +			error = xfs_break_leased_layouts(inode, iolock, &retry);
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			return -EINVAL;
> +		}
> +	} while (error == 0 && retry);
>  
>  	return error;
>  }
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
