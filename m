Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmailnode02.adl6.internode.on.net
 (ipmailnode02.adl6.internode.on.net [150.101.137.148])
 by ml01.01.org (Postfix) with ESMTP id 825DE20945BC4
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 17:28:05 -0700 (PDT)
Date: Tue, 26 Sep 2017 10:31:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] xfs: re-enable XFS per-inode DAX
Message-ID: <20170926003114.GN10955@dastard>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-8-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170925231404.32723-8-ross.zwisler@linux.intel.com>
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

On Mon, Sep 25, 2017 at 05:14:04PM -0600, Ross Zwisler wrote:
> Re-enable the XFS per-inode DAX flag, preventing S_DAX from changing when
> any mappings are present.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/xfs/xfs_ioctl.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 386b437..7a24dd5 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1012,12 +1012,10 @@ xfs_diflags_to_linux(
>  		inode->i_flags |= S_NOATIME;
>  	else
>  		inode->i_flags &= ~S_NOATIME;
> -#if 0	/* disabled until the flag switching races are sorted out */
>  	if ((xflags & FS_XFLAG_DAX) || (ip->i_mount->m_flags & XFS_MOUNT_DAX))
>  		inode->i_flags |= S_DAX;
>  	else
>  		inode->i_flags &= ~S_DAX;
> -#endif
>  }
>  
>  static bool
> @@ -1049,6 +1047,8 @@ xfs_ioctl_setattr_xflags(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	uint64_t		di_flags2;
> +	struct address_space	*mapping = VFS_I(ip)->i_mapping;
> +	bool			dax_changing;
>  
>  	/* Can't change realtime flag if any extents are allocated. */
>  	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
> @@ -1084,10 +1084,23 @@ xfs_ioctl_setattr_xflags(
>  	if (di_flags2 && ip->i_d.di_version < 3)
>  		return -EINVAL;
>  
> +	dax_changing = xfs_is_dax_state_changing(fa->fsx_xflags, ip);
> +	if (dax_changing) {
> +		i_mmap_lock_read(mapping);
> +		if (mapping_mapped(mapping)) {
> +			i_mmap_unlock_read(mapping);
> +			return -EBUSY;
> +		}
> +	}
> +
>  	ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
>  	ip->i_d.di_flags2 = di_flags2;
>  
>  	xfs_diflags_to_linux(ip);
> +
> +	if (dax_changing)
> +		i_mmap_unlock_read(mapping);

Is this safe to be taking here under the ILOCK_EXCL? i.e. this is
the lock order here:

IOLOCK_EXCL -> MMAPLOCK_EXCL -> ILOCK_EXCL -> i_mmap_rwsem

The truncate path must run outside the ILOCK
context, and it does this order via unmap_mapping_range:

IOLOCK_EXCL -> MMAPLOCK_EXCL -> i_mmap_rwsem

On a page fault, we do:

	mmap_sem -> MMAPLOCK_EXCL -> page lock -> ILOCK_EXCL

Which gives the order

IOLOCK_EXCL
  -> mmap_sem
     -> MMAPLOCK_EXCL
	-> page lock
	   -> ILOCK_EXCL
	      -> i_mmap_rwsem

What I'm not clear on is what the orders between page locks and
pte locks and i_mapping_tree_lock and i_mmap_rwsem. If there's any
locks that the filesystem can take above the ILOCK that are also
taken under the i_mmap_rwsem, then we have a deadlock vector.

Historically we've avoided any mm/ level interactions under the
ILOCK_EXCL because of it's location in the page fault path locking
order (e.g. lockdep will go nuts if we take a page fault with the
ILOCK held). Hence I'm extremely wary of putting any other mm/ level
locks under the ILOCK like this without a clear explanation of the
locking orders and why it won't deadlock....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
