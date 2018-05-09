Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1715E2034861F
 for <linux-nvdimm@lists.01.org>; Wed,  9 May 2018 05:27:35 -0700 (PDT)
Date: Wed, 9 May 2018 14:27:33 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v9 9/9] xfs, dax: introduce xfs_break_dax_layouts()
Message-ID: <20180509122733.lokyqv5aluwhlml7@quack2.suse.cz>
References: <152461278149.17530.2867511144531572045.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152461283072.17530.11313844322317294220.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152461283072.17530.11313844322317294220.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 24-04-18 16:33:50, Dan Williams wrote:
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
> Although XFS_MMAPLOCK_EXCL is dropped while waiting, XFS_IOLOCK_EXCL is
> held while sleeping. We need this to prevent starvation of the truncate
> path as continuous submission of direct-I/O could starve the truncate
> path indefinitely if the lock is dropped.
> 
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me except some nits below. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

for as much as it is worth with XFS code ;)

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
> +			0, 0, xfs_wait_dax_page(inode, did_unlock));
> +}
> +
>  int
>  xfs_break_layouts(
>  	struct inode		*inode,
> @@ -729,17 +760,23 @@ xfs_break_layouts(
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

Maybe move the assertion to xfs_break_dax_layouts()?

> +
> +			error = xfs_break_dax_layouts(inode, *iolock, &retry);
> +			/* fall through */
> +		case BREAK_WRITE:
> +			if (error || retry)
> +				break;

The error handling IMHO belongs above the 'fall through' comment above.

> +			error = xfs_break_leased_layouts(inode, iolock, &retry);
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			return -EINVAL;
> +		}
> +	} while (error == 0 && retry);

As a general 'taste' comment, I prefer if the 'retry' is always initialized
to 'false' at the beginning of the loop body in these kinds of loops. That
way it is obvious we are doing the right thing when looking at the loop
body and we don't have to verify that each case statement initializes
'retry' properly (in fact I'd remove the initialization from
xfs_break_dax_layouts() and xfs_break_leased_layouts()). But this is more a
matter of taste and consistency with other code in the area so I defer to
XFS maintainers for a final opinion. Darrick?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
