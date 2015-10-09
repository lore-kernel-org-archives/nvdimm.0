Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1444428128-12200-3-git-send-email-ross.zwisler@linux.intel.com>
References: <1444428128-12200-1-git-send-email-ross.zwisler@linux.intel.com>
	<1444428128-12200-3-git-send-email-ross.zwisler@linux.intel.com>
Date: Fri, 9 Oct 2015 15:18:11 -0700
Message-ID: <CAPcyv4jeb=58Y5zG3WKJfPckUecFwUiTW-MZQb7rzvpwPMa4Ow@mail.gmail.com>
Subject: Re: [PATCH 2/2] ext2: Add locking for DAX faults
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 9, 2015 at 3:02 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
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
>
> The newly introduced dax_sem is intended to replicate the protection
> offered by i_mmaplock in XFS.  In addition to truncate the i_mmaplock also
> protects XFS operations like hole punching, fallocate down, extent
> manipulation IOCTLS like xfs_ioc_space() and extent swapping.  Truncate is
> the only one of these operations supported by ext2.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
[..]

...not a review of the ext2 changes.

> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index c60a248..2b974fc 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1085,6 +1085,7 @@ static void ext2_free_branches(struct inode *inode, __le32 *p, __le32 *q, int de
>                 ext2_free_data(inode, p, q);
>  }
>
> +/* dax_sem must be held when calling this function */
>  static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
>  {

How about  a "WARN_ON(!rwsem_is_locked(&ei->dax_sem));" to backstop
this assumption?
