Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 16A3522551B80
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 00:36:32 -0700 (PDT)
Date: Thu, 22 Mar 2018 08:43:03 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 14/14] xfs, dax: introduce xfs_break_dax_layouts()
Message-ID: <20180322074303.GC28713@lst.de>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167311132.5268.8502709708606276650.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152167311132.5268.8502709708606276650.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 21, 2018 at 03:58:31PM -0700, Dan Williams wrote:
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
> ---
>  fs/xfs/xfs_file.c |   59 ++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 49 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7f37fadf007e..d4573f93fddb 100644
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
> @@ -766,16 +798,23 @@ xfs_break_layouts(
>  				| (reason == BREAK_UNMAPI
>  					? XFS_MMAPLOCK_EXCL : 0)));
>  
> -	switch (reason) {
> -	case BREAK_UNMAPI:
> -		/* fall through */
> -	case BREAK_WRITE:
> -		error = xfs_break_leased_layouts(inode, iolock, &did_unlock);
> -		break;
> -	default:
> -		error = -EINVAL;
> -		break;
> -	}
> +	do {
> +		switch (reason) {
> +		case BREAK_UNMAPI:
> +			error = xfs_break_dax_layouts(inode, *iolock,
> +					&did_unlock);
> +			/* fall through */
> +		case BREAK_WRITE:
> +			if (error || did_unlock)
> +				break;
> +			error = xfs_break_leased_layouts(inode, iolock,
> +					&did_unlock);
> +			break;
> +		default:
> +			error = -EINVAL;
> +			break;
> +		}
> +	} while (error == 0 && did_unlock);

Nitpick:  I think did_unlock should probably be called done in this context,
and how about something like this:

	for (;;) {
		switch (reason) {
		case BREAK_UNMAPI:
			error = xfs_break_dax_layouts(inode, *iolock, &done);
			if (error || done)
				return error;
			/*fallthrough*/
		case BREAK_WRITE:
			error = xfs_break_leased_layouts(inode, iolock, &done);
			if (error || done)
				return error;
			break;
		default:
			WARN_ON_ONCE(1);
			return -EINVAL;
		}
	}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
