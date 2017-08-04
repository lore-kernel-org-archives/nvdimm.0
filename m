Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6308921AEB0CD
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 13:31:07 -0700 (PDT)
Date: Fri, 4 Aug 2017 13:33:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 4/5] xfs: introduce XFS_DIFLAG2_IOMAP_IMMUTABLE
Message-ID: <20170804203312.GF24087@magnolia>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150181371001.32119.599597939855384271.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150181371001.32119.599597939855384271.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 03, 2017 at 07:28:30PM -0700, Dan Williams wrote:
> Add an on-disk inode flag to record the state of the S_IOMAP_IMMUTABLE
> in-memory vfs inode flags. This allows the protections against reflink
> and hole punch to be automatically restored on a sub-sequent boot when
> the in-memory inode is established.
> 
> The FS_XFLAG_IOMAP_IMMUTABLE is introduced to allow xfs_io to read the
> state of the flag, but toggling the flag requires going through
> fallocate(FALLOC_FL_[UN]SEAL_BLOCK_MAP). Support for toggling this
> on-disk state is saved for a later patch.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Suggested-by: "Darrick J. Wong" <darrick.wong@oracle.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |    5 ++++-
>  fs/xfs/xfs_inode.c         |    2 ++
>  fs/xfs/xfs_ioctl.c         |    1 +
>  fs/xfs/xfs_iops.c          |    8 +++++---
>  include/uapi/linux/fs.h    |    1 +
>  5 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index d4d9bef20c3a..9e720e55776b 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1063,12 +1063,15 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define XFS_DIFLAG2_DAX_BIT	0	/* use DAX for this inode */
>  #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
>  #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
> +#define XFS_DIFLAG2_IOMAP_IMMUTABLE_BIT 3 /* set S_IOMAP_IMMUTABLE for this inode */

So... the greedy part of my brain that doesn't want to give out flags2
bits has been wondering, what if we just didn't have an on-disk
IOMAP_IMMUTABLE bit, and set FS_XFLAG based only on the in-core
S_IOMAP_IMMUTABLE bit?  If a program wants the immutable iomap
semantics, they will have to code some variant on the following:

fd = open(...);
ret = fallocate(fd, FALLOC_FL_SEAL_BLOCK_MAP, 0, len...)
if (ret) {
	printf("couldn't seal block map");
	close(fd);
	return;
}

mmap(fd...);
/* do sensitive io operations here */
munmap(fd...);

close(fd);

Therefore the cost of not having the on-disk flag is that we'll have to
do more unshare/alloc/test/set cycles than we would if we could remember
the iomap-immutable state across unmounts and inode reclaiming.
However, if the data map is already ready to go, this shouldn't have a
lot of overhead since we only have to iterate the in-core extents.

Just trying to make sure we /need/ the inode flag bit. :)

--D

>  #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
>  #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
>  #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
> +#define XFS_DIFLAG2_IOMAP_IMMUTABLE (1 << XFS_DIFLAG2_IOMAP_IMMUTABLE_BIT)
>  
>  #define XFS_DIFLAG2_ANY \
> -	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)
> +	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
> +	 XFS_DIFLAG2_IOMAP_IMMUTABLE)
>  
>  /*
>   * Inode number format:
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ceef77c0416a..4ca22e272ce6 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -674,6 +674,8 @@ _xfs_dic2xflags(
>  			flags |= FS_XFLAG_DAX;
>  		if (di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
>  			flags |= FS_XFLAG_COWEXTSIZE;
> +		if (di_flags2 & XFS_DIFLAG2_IOMAP_IMMUTABLE)
> +			flags |= FS_XFLAG_IOMAP_IMMUTABLE;
>  	}
>  
>  	if (has_attr)
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 2e64488bc4de..df2eef0f9d45 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -978,6 +978,7 @@ xfs_set_diflags(
>  		return;
>  
>  	di_flags2 = (ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
> +	di_flags2 |= (ip->i_d.di_flags2 & XFS_DIFLAG2_IOMAP_IMMUTABLE);
>  	if (xflags & FS_XFLAG_DAX)
>  		di_flags2 |= XFS_DIFLAG2_DAX;
>  	if (xflags & FS_XFLAG_COWEXTSIZE)
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 469c9fa4c178..174ef95453f5 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1186,9 +1186,10 @@ xfs_diflags_to_iflags(
>  	struct xfs_inode	*ip)
>  {
>  	uint16_t		flags = ip->i_d.di_flags;
> +	uint64_t		flags2 = ip->i_d.di_flags2;
>  
>  	inode->i_flags &= ~(S_IMMUTABLE | S_APPEND | S_SYNC |
> -			    S_NOATIME | S_DAX);
> +			    S_NOATIME | S_DAX | S_IOMAP_IMMUTABLE);
>  
>  	if (flags & XFS_DIFLAG_IMMUTABLE)
>  		inode->i_flags |= S_IMMUTABLE;
> @@ -1201,9 +1202,10 @@ xfs_diflags_to_iflags(
>  	if (S_ISREG(inode->i_mode) &&
>  	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
>  	    !xfs_is_reflink_inode(ip) &&
> -	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
> -	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
> +	    (ip->i_mount->m_flags & XFS_MOUNT_DAX || flags2 & XFS_DIFLAG2_DAX))
>  		inode->i_flags |= S_DAX;
> +	if (flags2 & XFS_DIFLAG2_IOMAP_IMMUTABLE)
> +		inode->i_flags |= S_IOMAP_IMMUTABLE;
>  }
>  
>  /*
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index b7495d05e8de..4765e024ad74 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -182,6 +182,7 @@ struct fsxattr {
>  #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
>  #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
>  #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
> +#define FS_XFLAG_IOMAP_IMMUTABLE 0x00020000	/* block map immutable */
>  #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
>  
>  /* the read-only stuff doesn't really belong here, but any other place is
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
