Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 622B3223DB0ED
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 01:45:28 -0800 (PST)
Date: Sat, 10 Mar 2018 10:51:44 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 10/11] xfs: prepare xfs_break_layouts() for another
 layout type
Message-ID: <20180310095144.GB31604@lst.de>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066494277.40260.7360641938196726871.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152066494277.40260.7360641938196726871.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

>  
> +int
> +xfs_break_layouts(
> +	struct inode		*inode,
> +	uint			*iolock,
> +	unsigned long		flags)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	uint			iolock_assert = 0;
> +	int			ret = 0;
> +
> +	if (flags & XFS_BREAK_REMOTE)
> +		iolock_assert |= XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL;
> +	if (flags & XFS_BREAK_MAPS)
> +		iolock_assert |= XFS_MMAPLOCK_EXCL;
> +
> +	ASSERT(xfs_isilocked(ip, iolock_assert));
> +
> +	if (flags & XFS_BREAK_REMOTE)
> +		ret = xfs_break_leased_layouts(inode, iolock);
> +	return ret;

This just looks weird as hell.  We already pass in what to drop/reacquire
in the iolock argument.  I don't think we need another argument controlled
by the same callers to assert it.

> @@ -768,7 +790,7 @@ xfs_file_fallocate(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	long			error;
>  	enum xfs_prealloc_flags	flags = 0;
> -	uint			iolock = XFS_IOLOCK_EXCL;
> +	uint			iolock = XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL;

This is a behavior change that should not be in a patch titled
"prepare xfs_break_layouts() for another layout type" but in one
explicitly changing this and documenting why.

In summary:  I think this should be replaced with a patch that
allows xfs_break_layouts to be called with the mmap lock held, and
change the callers that want the mmap lock to pass it with a good
explanation, and we should get rid of the XFS_BREAK_* flags here.
(need to check the next patch if there is any other good reason for
them to be added later, though).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
