Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F2E41A1EC0
 for <linux-nvdimm@lists.01.org>; Tue,  3 May 2016 00:58:15 -0700 (PDT)
Date: Tue, 3 May 2016 09:58:11 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/3] ext4: Add alignment check for DAX mount
Message-ID: <20160503075811.GA12748@quack2.suse.cz>
References: <1462214578-27122-1-git-send-email-toshi.kani@hpe.com>
 <1462214578-27122-2-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462214578-27122-2-git-send-email-toshi.kani@hpe.com>
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

On Mon 02-05-16 12:42:56, Toshi Kani wrote:
> When a partition is not aligned by 4KB, mount -o dax succeeds,
> but any read/write access to the filesystem fails, except for
> metadata update.
> 
> Call bdev_direct_access to check the alignment when -o dax is
> specified.
> 
> Reported-by: Micah Parrish <micah.parrish@hpe.com>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Boaz Harrosh <boaz@plexistor.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext4/super.c |   20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 304c712..51ac78e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3416,14 +3416,30 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  
>  	if (sbi->s_mount_opt & EXT4_MOUNT_DAX) {
> +		struct blk_dax_ctl dax = {
> +			.sector = 0,
> +			.size = PAGE_SIZE,
> +		};
>  		if (blocksize != PAGE_SIZE) {
>  			ext4_msg(sb, KERN_ERR,
>  					"error: unsupported blocksize for dax");
>  			goto failed_mount;
>  		}
> -		if (!sb->s_bdev->bd_disk->fops->direct_access) {
> -			ext4_msg(sb, KERN_ERR,
> +		err = bdev_direct_access(sb->s_bdev, &dax);
> +		if (err < 0) {
> +			switch (err) {
> +			case -EOPNOTSUPP:
> +				ext4_msg(sb, KERN_ERR,
>  					"error: device does not support dax");
> +				break;
> +			case -EINVAL:
> +				ext4_msg(sb, KERN_ERR,
> +					"error: unaligned partition for dax");
> +				break;
> +			default:
> +				ext4_msg(sb, KERN_ERR,
> +					"error: dax access failed (%d)", err);
> +			}
>  			goto failed_mount;
>  		}
>  	}
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
