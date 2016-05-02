Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id B0A521A1E29
 for <linux-nvdimm@lists.01.org>; Mon,  2 May 2016 12:50:29 -0700 (PDT)
Date: Mon, 2 May 2016 13:50:27 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 3/3] xfs: Add alignment check for DAX mount
Message-ID: <20160502195027.GC14421@linux.intel.com>
References: <1462214578-27122-1-git-send-email-toshi.kani@hpe.com>
 <1462214578-27122-4-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462214578-27122-4-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, hch@infradead.org, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org, tytso@mit.edu
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 02, 2016 at 12:42:58PM -0600, Toshi Kani wrote:
> When a partition is not aligned by 4KB, mount -o dax succeeds,
> but any read/write access to the filesystem fails, except for
> metadata update.
> 
> Call bdev_direct_access to check the alignment when -o dax is
> specified.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Boaz Harrosh <boaz@plexistor.com>
> ---
>  fs/xfs/xfs_super.c |   23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 187e14b..b7ee323 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1557,15 +1557,30 @@ xfs_fs_fill_super(
>  		sb->s_flags |= MS_I_VERSION;
>  
>  	if (mp->m_flags & XFS_MOUNT_DAX) {
> +		struct blk_dax_ctl dax = {
> +			.sector = 0,
> +			.size = PAGE_SIZE,
> +		};
>  		xfs_warn(mp,
> -	"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
> +		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>  		if (sb->s_blocksize != PAGE_SIZE) {
>  			xfs_alert(mp,
>  		"Filesystem block size invalid for DAX Turning DAX off.");
>  			mp->m_flags &= ~XFS_MOUNT_DAX;
> -		} else if (!sb->s_bdev->bd_disk->fops->direct_access) {
> -			xfs_alert(mp,
> -		"Block device does not support DAX Turning DAX off.");
> +		} else if ((error = bdev_direct_access(sb->s_bdev, &dax)) < 0) {
> +			switch (error) {
> +			case -EOPNOTSUPP:
> +				xfs_alert(mp,
> +			"Block device does not support DAX Turning DAX off.");

Since you're already in here editing all the strings, can you add a period to
make it more readable?   Applies to all strings.

> +			"Block device does not support DAX. Turning DAX off.");
							  ^

> +				break;
> +			case -EINVAL:
> +				xfs_alert(mp,
> +			"Partition alignment invalid for DAX Turning DAX off.");
> +				break;
> +			default:
> +				xfs_alert(mp,
> +			"DAX access failed (%d) DAX Turning DAX off.", error);

I DAX think you might DAX have too many DAXes in here. :)

> +			}
>  			mp->m_flags &= ~XFS_MOUNT_DAX;
>  		}
>  	}

Other than the nit-picking about the strings, this seems fine.

You can add this for the series:
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
