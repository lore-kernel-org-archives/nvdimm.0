Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
 [150.101.137.143])
 by ml01.01.org (Postfix) with ESMTP id A62AD21CF94FB
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 17:43:00 -0700 (PDT)
Date: Tue, 1 Aug 2017 10:42:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: persist S_IOMAP_IMMUTABLE in di_flags2
Message-ID: <20170801004201.GM17762@dastard>
References: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150135742595.35318.6882401569584241548.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150135742595.35318.6882401569584241548.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jul 29, 2017 at 12:43:46PM -0700, Dan Williams wrote:
> Record the immutable state in the on-disk inode so that on the next boot
> the protections against reflink and hole punch etc are automatically
> restored.

Keep in mind we can't do this without all the userspace side support
for the addition to the in-disk format....

> This deliberately does not add a FS_XFLAG_IOMAP_IMMUTABLE since
> fallocate(2) is the path to toggle this flag.

That's a problem. The flag needs to be added so that we can /view/
the state of the inode through xfs_io. Just because we can't set it
through the extended inode flag interface doesn't mean the flag
should not exist.

> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index c4fc79a0704f..1dcb521da456 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1021,7 +1021,8 @@ xfs_alloc_file_space(
>  	struct xfs_inode	*ip,
>  	xfs_off_t		offset,
>  	xfs_off_t		len,
> -	int			alloc_type)
> +	int			alloc_type,
> +	uint64_t		di_flags2)
>  {
>  	xfs_mount_t		*mp = ip->i_mount;
>  	xfs_off_t		count;
> @@ -1119,6 +1120,12 @@ xfs_alloc_file_space(
>  			break;
>  		}
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +		if (di_flags2) {
> +			/* fold inode attributes for this allocation */
> +			ip->i_d.di_flags2 |= di_flags2;
> +			di_flags2 = 0;
> +		}

Yikes, no! Darrick already mentioned this, but it needs pointing out
again...

Especially as it means that we are setting the immutable flag before
we've allocated all the extents to fill the file space. If we've
implemented immutable extent maps correctly, then xfs_bmapi_write()
should be rejecting any attempt to allocate or modify extents if
that flag is set on the inode, which means this code will now fail
to allocate/zero anything...

IOWs, this flag should be the last thing that is set on the inode
once it's been fully allocated and zeroed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
