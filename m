Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 566ED222EDCDB
 for <linux-nvdimm@lists.01.org>; Tue,  2 Jan 2018 13:03:00 -0800 (PST)
Date: Tue, 2 Jan 2018 13:07:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4 18/18] xfs, dax: wire up dax_flush_dma support via a
 new xfs_sync_dma helper
Message-ID: <20180102210752.GG4857@magnolia>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407705701.38751.6157642918168721562.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407705701.38751.6157642918168721562.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Dec 23, 2017 at 04:57:37PM -0800, Dan Williams wrote:
> xfs_break_layouts() scans for active pNFS layouts, drops locks and
> rescans for those layouts to be broken. xfs_sync_dma performs
> xfs_break_layouts and also scans for active dax-dma pages, drops locks
> and rescans for those pages to go idle.
> 
> dax_flush_dma handles synchronizing against new page-busy events
> (get_user_pages). iIt invalidates all mappings to trigger the
> get_user_pages slow path which will eventually block on the
> XFS_MMAPLOCK. If it finds a dma-busy page it waits for a page-idle
> callback that will fire when the page reference count reaches 1 (recall
> ZONE_DEVICE pages are idle at count 1). While it is waiting, it drops
> locks so we do not deadlock the process that might be trying to elevate
> the page count of more pages before arranging for any of them to go idle
> as is typically the case of iov_iter_get_pages.
> 
> dax_flush_dma relies on the fs-provided wait_atomic_t_action_f
> (xfs_wait_dax_page) to handle evaluating the page reference count and
> dropping locks when waiting.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/xfs/Makefile    |    3 ++
>  fs/xfs/xfs_dma.c   |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_dma.h   |   24 +++++++++++++++
>  fs/xfs/xfs_file.c  |    6 ++--
>  fs/xfs/xfs_ioctl.c |    7 ++--
>  fs/xfs/xfs_iops.c  |    7 +++-
>  6 files changed, 118 insertions(+), 10 deletions(-)
>  create mode 100644 fs/xfs/xfs_dma.c
>  create mode 100644 fs/xfs/xfs_dma.h
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 7ceb41a9786a..f2cdc5a3eb6c 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -129,6 +129,9 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
>  				   xfs_qm.o \
>  				   xfs_quotaops.o
>  
> +# dax dma
> +xfs-$(CONFIG_FS_DAX)		+= xfs_dma.o
> +
>  # xfs_rtbitmap is shared with libxfs
>  xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
>  
> diff --git a/fs/xfs/xfs_dma.c b/fs/xfs/xfs_dma.c
> new file mode 100644
> index 000000000000..3df1a51a76c4
> --- /dev/null
> +++ b/fs/xfs/xfs_dma.c
> @@ -0,0 +1,81 @@
> +/*
> + * SPDX-License-Identifier: GPL-2.0
> + * Copyright(c) 2017 Intel Corporation. All rights reserved.
> + */
> +#include <linux/dax.h>
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_shared.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_bit.h"
> +#include "xfs_sb.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_inode.h"
> +#include "xfs_pnfs.h"
> +
> +/*
> + * xfs_wait_dax_page - helper for dax_flush_dma to drop locks and sleep
> + * wait for a page idle event. Returns 1 if the locks did not need to be
> + * dropped and the page is idle, returns -EINTR if the sleep was
> + * interrupted and returns 1 when it slept. dax_flush_dma()
> + * retries/rescans all mappings when the lock is dropped.

What does the return 0 case signify?  I'm guessing "returns 1 if the
locks did not need to be dropped and the page is idle"?

> + */
> +static int xfs_wait_dax_page(
> +	atomic_t		*count,
> +	unsigned int		mode)
> +{

static int
xfs_wait_dax_page(
	atomci_t		*count,
	unsigned int		mode)
{

IOWs, the function name gets its own line.  The same applies to every
other function definition.

> +	uint			iolock = XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL;
> +	struct page 		*page = refcount_to_page(count);

Space after 'page' ^^^ but before tab...

> +	struct address_space	*mapping = page->mapping;
> +	struct inode		*inode = mapping->host;
> +	struct xfs_inode	*ip = XFS_I(inode);
> +
> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL));
> +
> +	if (page_ref_count(page) == 1)
> +		return 0;
> +
> +	xfs_iunlock(ip, iolock);
> +	schedule();
> +	xfs_ilock(ip, iolock);
> +
> +	if (signal_pending_state(mode, current))
> +		return -EINTR;
> +	return 1;
> +}
> +
> +/*
> + * Synchronize [R]DMA before changing the file's block map. For pNFS,
> + * recall all layouts. For DAX, wait for transient DMA to complete. All
> + * other DMA is handled by pinning page cache pages.
> + *
> + * iolock must held XFS_IOLOCK_SHARED or XFS_IOLOCK_EXCL on entry and
> + * will be XFS_IOLOCK_EXCL and XFS_MMAPLOCK_EXCL on exit.

Is it guaranteed that we never emerge from xfs_break_layouts with
IOLOCK_SHARED?  I /think/ the answer is yes, but this seems like a
subtlety that would be easy to screw up.

> + */
> +int xfs_sync_dma(
> +	struct inode		*inode,
> +	uint			*iolock)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	int			error;
> +
> +	while (true) {
> +		error = xfs_break_layouts(inode, iolock);
> +		if (error)
> +			break;
> +
> +		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> +		*iolock |= XFS_MMAPLOCK_EXCL;
> +
> +		error = dax_flush_dma(inode->i_mapping, xfs_wait_dax_page);
> +		if (error <= 0)
> +			break;
> +		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> +		*iolock &= ~XFS_MMAPLOCK_EXCL;
> +	}
> +
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_dma.h b/fs/xfs/xfs_dma.h
> new file mode 100644
> index 000000000000..29635639b073
> --- /dev/null
> +++ b/fs/xfs/xfs_dma.h
> @@ -0,0 +1,24 @@
> +/*
> + * SPDX-License-Identifier: GPL-2.0
> + * Copyright(c) 2017 Intel Corporation. All rights reserved.
> + */
> +#ifndef __XFS_DMA__
> +#define __XFS_DMA__
> +#ifdef CONFIG_FS_DAX
> +int xfs_sync_dma(struct inode *inode, uint *iolock);
> +#else
> +#include "xfs_pnfs.h"
> +
> +static inline int xfs_sync_dma(struct inode *inode, uint *iolock)

I think we need to do this prior to reflinking into a file too, right?
Or at least we would if dax+reflink were a supported config.  I think
the reason we've never tripped over this is that neither pnfs nor dax
will have anything to do with reflinked files.

(brain creaking, trying to get back up to speed....)

--D

> +{
> +	int error = xfs_break_layouts(inode, iolock);
> +
> +	if (error)
> +		return error;
> +
> +	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_EXCL);
> +	*iolock |= XFS_MMAPLOCK_EXCL;
> +	return 0;
> +}
> +#endif /* CONFIG_FS_DAX */
> +#endif /* __XFS_DMA__ */
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 6df0c133a61e..84fc178da656 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -37,6 +37,7 @@
>  #include "xfs_log.h"
>  #include "xfs_icache.h"
>  #include "xfs_pnfs.h"
> +#include "xfs_dma.h"
>  #include "xfs_iomap.h"
>  #include "xfs_reflink.h"
>  
> @@ -778,12 +779,11 @@ xfs_file_fallocate(
>  		return -EOPNOTSUPP;
>  
>  	xfs_ilock(ip, iolock);
> -	error = xfs_break_layouts(inode, &iolock);
> +	error = xfs_sync_dma(inode, &iolock);
>  	if (error)
>  		goto out_unlock;
>  
> -	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> -	iolock |= XFS_MMAPLOCK_EXCL;
> +	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
>  
>  	if (mode & FALLOC_FL_PUNCH_HOLE) {
>  		error = xfs_free_file_space(ip, offset, len);
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 20dc65fef6a4..4340bef658b0 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -39,7 +39,7 @@
>  #include "xfs_icache.h"
>  #include "xfs_symlink.h"
>  #include "xfs_trans.h"
> -#include "xfs_pnfs.h"
> +#include "xfs_dma.h"
>  #include "xfs_acl.h"
>  #include "xfs_btree.h"
>  #include <linux/fsmap.h>
> @@ -643,12 +643,11 @@ xfs_ioc_space(
>  		return error;
>  
>  	xfs_ilock(ip, iolock);
> -	error = xfs_break_layouts(inode, &iolock);
> +	error = xfs_sync_dma(inode, &iolock);
>  	if (error)
>  		goto out_unlock;
>  
> -	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> -	iolock |= XFS_MMAPLOCK_EXCL;
> +	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
>  
>  	switch (bf->l_whence) {
>  	case 0: /*SEEK_SET*/
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 67bd97edc73b..c1055337b233 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -37,7 +37,7 @@
>  #include "xfs_da_btree.h"
>  #include "xfs_dir2.h"
>  #include "xfs_trans_space.h"
> -#include "xfs_pnfs.h"
> +#include "xfs_dma.h"
>  #include "xfs_iomap.h"
>  
>  #include <linux/capability.h>
> @@ -1030,11 +1030,12 @@ xfs_vn_setattr(
>  		struct xfs_inode	*ip = XFS_I(d_inode(dentry));
>  		uint			iolock = XFS_IOLOCK_EXCL;
>  
> -		error = xfs_break_layouts(d_inode(dentry), &iolock);
> +		error = xfs_sync_dma(d_inode(dentry), &iolock);
>  		if (error)
>  			return error;
>  
> -		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> +		ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
> +
>  		error = xfs_vn_setattr_size(dentry, iattr);
>  		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
>  	} else {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
