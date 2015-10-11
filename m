Return-Path: <linux-ext4-owner@vger.kernel.org>
Date: Mon, 12 Oct 2015 10:14:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] ext2: Add locking for DAX faults
Message-ID: <20151011231443.GY27164@dastard>
References: <1444428128-12200-1-git-send-email-ross.zwisler@linux.intel.com>
 <1444428128-12200-3-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1444428128-12200-3-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

[Nit: please send all patches of the series to the same list of
recipients. Otherwise people with list based filters end up with the
series spread across different mailboxes and people not subscribed
to all lists don't get the full series and so are lacking in context
for proper review. ]

On Fri, Oct 09, 2015 at 04:02:08PM -0600, Ross Zwisler wrote:
> Add locking to ensure that DAX faults are isolated from ext2 operations
> that modify the data blocks allocation for an inode.  This is intended to
> be analogous to the work being done in XFS by Dave Chinner:
> 
> http://www.spinics.net/lists/linux-fsdevel/msg90260.html
> 
> Compared with XFS the ext2 case is greatly simplified by the fact that ext2
> already allocates and zeros new blocks before they are returned as part of
> ext2_get_block(), so DAX doesn't need to worry about getting unmapped or
> unwritten buffer heads.
> 
> This means that the only work we need to do in ext2 is to isolate the DAX
> faults from inode block allocation changes.  I believe this just means that
> we need to isolate the DAX faults from truncate operations.

Why limit this just to DAX page faults?

> The newly introduced dax_sem is intended to replicate the protection
> offered by i_mmaplock in XFS.  In addition to truncate the i_mmaplock also
> protects XFS operations like hole punching, fallocate down, extent
> manipulation IOCTLS like xfs_ioc_space() and extent swapping.  Truncate is
> the only one of these operations supported by ext2.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/ext2/ext2.h  |  1 +
>  fs/ext2/file.c  | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
>  fs/ext2/inode.c |  9 +++++++++
>  fs/ext2/super.c |  1 +
>  4 files changed, 58 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 8d15feb..ec3cd02 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -684,6 +684,7 @@ struct ext2_inode_info {
>  	struct rw_semaphore xattr_sem;
>  #endif
>  	rwlock_t i_meta_lock;
> +	struct rw_semaphore dax_sem;
>  
>  	/*
>  	 * truncate_mutex is for serialising ext2_truncate() against
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index 1982c3f..389c5d5 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -27,27 +27,70 @@
>  #include "acl.h"
>  
>  #ifdef CONFIG_FS_DAX
> +/*
> + * The lock ordering for ext2 DAX fault paths is:
> + *
> + * mmap_sem (MM)
> + *   ext2_inode_info->dax_sem
> + *     sb_start_pagefault (vfs, freeze - taken in DAX)
> + *       address_space->i_mmap_rwsem or page_lock (mutually exclusive in DAX)
> + *         ext2_inode_info->truncate_mutex

This is a different lock order to XFS - it puts the i_mmaplock
inside sb_start_pagefault(), not outside it. This ordering means the
timestamp updates during the page fault are also under
ext2_inode_info->dax_sem...

Other than that, I can't really comment on the rest of the changes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
