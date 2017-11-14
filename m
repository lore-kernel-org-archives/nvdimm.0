Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
 [150.101.137.129])
 by ml01.01.org (Postfix) with ESMTP id EEA972035BB37
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 20:08:49 -0800 (PST)
Date: Tue, 14 Nov 2017 15:12:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs, dax: unify IOMAP_F_DIRTY read vs write handling
 policy in the dax core
Message-ID: <20171114041228.GA4094@dastard>
References: <151062258598.8554.8157038002895095232.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151062258598.8554.8157038002895095232.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 13, 2017 at 05:27:54PM -0800, Dan Williams wrote:
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index b43be199fbdf..888b60189983 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1087,9 +1087,9 @@ xfs_file_iomap_begin(
>  		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
>  	}
>  
> -	if ((flags & IOMAP_WRITE) && xfs_ipincount(ip) &&
> -	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> -		iomap->flags |= IOMAP_F_DIRTY;
> +	if (xfs_ipincount(ip))
> +		if (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP)
> +			iomap->flags |= IOMAP_F_DIRTY;

Please make a helper for this, and use it in xfs_file_fsync() where
the same dirty checks are done. e.g.

static inline bool
xfs_inode_need_fsync(struct xfs_inode *ip, bool datasync)
{
	if (!xfs_ipincount(ip))
		return false;
	if (xfs_inode_clean(ip))
		return false;
	if (datasync &&
	    !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
		return false;
	return true;
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
