Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail01.adl2.internode.on.net (ipmail01.adl2.internode.on.net
 [150.101.137.133])
 by ml01.01.org (Postfix) with ESMTP id 35CFE20945BD5
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 17:05:30 -0700 (PDT)
Date: Tue, 26 Sep 2017 09:27:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/7] xfs: protect S_DAX transitions in XFS read path
Message-ID: <20170925232745.GK10955@dastard>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-4-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170925231404.32723-4-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 25, 2017 at 05:14:00PM -0600, Ross Zwisler wrote:
> In the current XFS read I/O path we check IS_DAX() in xfs_file_read_iter()
> to decide whether to do DAX I/O, direct I/O or buffered I/O.  This check is
> done without holding the XFS_IOLOCK, though, which means that if we allow
> S_DAX to be manipulated via the inode flag we can run into this race:
> 
> CPU 0				CPU 1
> -----				-----
> xfs_file_read_iter()
>   IS_DAX() << returns false
>   				xfs_ioctl_setattr()
> 				  xfs_ioctl_setattr_dax_invalidate()
> 				   xfs_ilock(XFS_MMAPLOCK|XFS_IOLOCK)
> 				  sets S_DAX
> 				  releases XFS_MMAPLOCK and XFS_IOLOCK
>   xfs_file_buffered_aio_read()
>   does buffered I/O to DAX inode, death
> 
> Fix this by ensuring that we only check S_DAX when we hold the XFS_IOLOCK
> in the read path.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/xfs/xfs_file.c | 42 +++++++++++++-----------------------------
>  1 file changed, 13 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index ebdd0bd..ca4c8fd 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -207,7 +207,6 @@ xfs_file_dio_aio_read(
>  {
>  	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
>  	size_t			count = iov_iter_count(to);
> -	ssize_t			ret;
>  
>  	trace_xfs_file_direct_read(ip, count, iocb->ki_pos);
>  
> @@ -215,12 +214,7 @@ xfs_file_dio_aio_read(
>  		return 0; /* skip atime */
>  
>  	file_accessed(iocb->ki_filp);
> -
> -	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> -	ret = iomap_dio_rw(iocb, to, &xfs_iomap_ops, NULL);
> -	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> -
> -	return ret;
> +	return iomap_dio_rw(iocb, to, &xfs_iomap_ops, NULL);

This puts file_accessed under the XFS_IOLOCK_SHARED now. Is that a
safe/sane thing to do for DIO?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
