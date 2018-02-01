Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
 [150.101.137.129])
 by ml01.01.org (Postfix) with ESMTP id 9AF67223CCEF2
 for <linux-nvdimm@lists.01.org>; Thu,  1 Feb 2018 15:38:12 -0800 (PST)
Date: Fri, 2 Feb 2018 10:44:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2 2/2] xfs: fix rt_dev usage for DAX
Message-ID: <20180201234413.idd27uqzqbg54ddk@destitution>
References: <151751717968.69886.6978962571680635420.stgit@djiang5-desk3.ch.intel.com>
 <151751718516.69886.135497175511444689.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151751718516.69886.135497175511444689.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 01, 2018 at 01:33:05PM -0700, Dave Jiang wrote:
> When using realtime device (rtdev) with xfs where the data device is not
> DAX capable, two issues arise. One is when data device is not DAX but the
> realtime device is DAX capable, we currently disable DAX.
> After passing this check, we are also not marking the inode as DAX capable.
> This change will allow DAX enabled if the data device or the realtime
> device is DAX capable. S_DAX will be marked for the inode if the file is
> residing on a DAX capable device. This will prevent the case of rtdev is not
> DAX and data device is DAX to create realtime files.

I'm confused by this description. I'm not sure what is broken, nor
what you are trying to fix.

I think what you want to do is enable DAX on RT devices separately
to the data device and vice versa?

i.e. is this what you are trying to acheive?

datadev dax	rtdev dax		DAX enabled on
-----------     ---------		--------------
no		no			neither
yes		no			datadev
no		yes			rtdev
yes		yes			both


> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reported-by: Darrick Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_iops.c  |    3 ++-
>  fs/xfs/xfs_super.c |    9 ++++++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 56475fcd76f2..ab352c325301 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1204,7 +1204,8 @@ xfs_diflags_to_iflags(
>  	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
>  	    !xfs_is_reflink_inode(ip) &&
>  	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
> -	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
> +	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX) &&
> +	    blk_queue_dax(bdev_get_queue(inode->i_sb->s_bdev)))

This does not discriminate between the rtdev or the data dev. This
needs to call xfs_find_bdev_for_inode() to get the right device
for the inode config.

Further, if we add or remove the RT flag to the inode at a later
point in time (e.g. via ioctl) we also need to re-evaluate the S_DAX
flag at that point in time.

Which brings me to the real problem here: dynamically changing the
S_DAX flag is racy, dangerous and broken. It's not clear that this
should be allowed at all as the inode may have already been mmap()d
by the time the ioctl is called to set/clear the rt file state.

IOWs, right now we cannot support mixed DAX mode filesystems because
the generic DAX code does not support dynamic changing of the DAX
flag on an inode and so checking the block device state here is
irrelevant....

>  		inode->i_flags |= S_DAX;
>  }
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e8a687232614..5ac478924dce 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1649,11 +1649,18 @@ xfs_fs_fill_super(
>  		sb->s_flags |= SB_I_VERSION;
>  
>  	if (mp->m_flags & XFS_MOUNT_DAX) {
> +		bool rtdev_is_dax = false;
> +
>  		xfs_warn(mp,
>  		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>  
> +		if (mp->m_rtdev_targp->bt_daxdev)
> +			if (bdev_dax_supported(mp->m_rtdev_targp->bt_bdev,
> +					      sb->s_blocksize) == 0)
> +				rtdev_is_dax = true;

.... as this code here needs to turn off DAX here if any device
in the filesystem doesn't support DAX....


FWIW, the logic in the code is terrible (not your fault, Dave).
The logic reads

	if (NOT bdev_dax_supported(rtdev)) then
		rtdev supports DAX

That also needs fixing - we're checking something that has a boolean
return state (yes or no) and so it should define them in a way that
makes the caller logic read cleanly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
