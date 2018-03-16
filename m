Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7AF52095607F
 for <linux-nvdimm@lists.01.org>; Fri, 16 Mar 2018 11:58:19 -0700 (PDT)
Date: Fri, 16 Mar 2018 20:04:43 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 12/15] xfs: require mmap lock for xfs_break_layouts()
Message-ID: <20180316190443.GF3671@lst.de>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152112914933.24669.5543317105428477772.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152112914933.24669.5543317105428477772.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Thu, Mar 15, 2018 at 08:52:29AM -0700, Dan Williams wrote:
> In preparation for adding coordination between truncate operations and
> busy dax-pages, extend xfs_break_layouts() to assume it must be called
> with the mmap lock held. This locking scheme will be required for
> coordinating the break of 'dax layouts' (non-idle dax (ZONE_DEVICE)
> pages mapped into the file's address space).

This requirement wasn't really there in the last series, why do we
require it now?

As far as I can tell all we'd need is to just drop this assert:

> -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
> +				| XFS_MMAPLOCK_EXCL));

entirely.

>  	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
>  		xfs_iunlock(ip, *iolock);
>  		error = break_layout(inode, true);
> -		*iolock = XFS_IOLOCK_EXCL;
> +		*iolock &= ~XFS_IOLOCK_SHARED;
> +		*iolock |= XFS_IOLOCK_EXCL;
>  		xfs_ilock(ip, *iolock);

And take this one hunk from your patch.

To enable the DAX use case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
