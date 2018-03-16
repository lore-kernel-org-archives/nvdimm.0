Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37E4220954BA9
 for <linux-nvdimm@lists.01.org>; Fri, 16 Mar 2018 12:01:37 -0700 (PDT)
Date: Fri, 16 Mar 2018 20:08:01 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 13/15] xfs: communicate lock drop events from
 xfs_break_layouts()
Message-ID: <20180316190801.GG3671@lst.de>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152112915950.24669.2377167541944853596.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152112915950.24669.2377167541944853596.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Thu, Mar 15, 2018 at 08:52:39AM -0700, Dan Williams wrote:
> In preparation for adding a new layout type, teach xfs_break_layouts()
> to return a positive number if it needed to drop locks while trying to
> break leases. For all layouts to be successfully broken each layout type
> needs to be able to assert that the layouts were broken with the locks
> held.
> 
> The existing a xfs_break_layouts() is pushed down a level to
> xfs_break_leased_layouts() and the new xfs_break_layouts() will
> coordinate interpreting the return code from the low level 'break'
> helpers.

With that the subject line is rather confusing, given that the
externally visible xfs_break_layouts does not communicate the lock
drop events.  So maybe this should just be titled something about
refactoring.  Or just merged into the next patch which reshuffles
everything again anyway.

>  int
> -xfs_break_layouts(
> +xfs_break_leased_layouts(
>  	struct inode		*inode,
>  	uint			*iolock)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error;
> -
> -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
> -				| XFS_MMAPLOCK_EXCL));
> +	int			did_unlock = 0;
>  
>  	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
>  		xfs_iunlock(ip, *iolock);
> +		did_unlock = 1;
>  		error = break_layout(inode, true);
>  		*iolock &= ~XFS_IOLOCK_SHARED;
>  		*iolock |= XFS_IOLOCK_EXCL;
>  		xfs_ilock(ip, *iolock);
>  	}
>  
> -	return error;
> +	if (error < 0)
> +		return error;
> +	return did_unlock;

And I suspect the cleaner interface would be to just pass a 
bool *did_unlock argument.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
