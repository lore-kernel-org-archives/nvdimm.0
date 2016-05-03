Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 18FA91A1E3F
 for <linux-nvdimm@lists.01.org>; Tue,  3 May 2016 01:01:31 -0700 (PDT)
Date: Tue, 3 May 2016 10:01:27 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/3] ext2: Add alignment check for DAX mount
Message-ID: <20160503080127.GB12748@quack2.suse.cz>
References: <1462214578-27122-1-git-send-email-toshi.kani@hpe.com>
 <1462214578-27122-3-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462214578-27122-3-git-send-email-toshi.kani@hpe.com>
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

On Mon 02-05-16 12:42:57, Toshi Kani wrote:
> When a partition is not aligned by 4KB, mount -o dax succeeds,
> but any read/write access to the filesystem fails, except for
> metadata update.
> 
> Call bdev_direct_access to check the alignment when -o dax is
> specified.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Boaz Harrosh <boaz@plexistor.com>

The patch looks good. I've added it to my tree and will push it to Linus in
the coming merge window.

								Honza

> ---
>  fs/ext2/super.c |   21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index b78caf2..e636b56 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -922,14 +922,31 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
>  
>  	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
> +		struct blk_dax_ctl dax = {
> +			.sector = 0,
> +			.size = PAGE_SIZE,
> +		};
>  		if (blocksize != PAGE_SIZE) {
>  			ext2_msg(sb, KERN_ERR,
>  					"error: unsupported blocksize for dax");
>  			goto failed_mount;
>  		}
> -		if (!sb->s_bdev->bd_disk->fops->direct_access) {
> -			ext2_msg(sb, KERN_ERR,
> +		err = bdev_direct_access(sb->s_bdev, &dax);
> +		if (err < 0) {
> +			switch (err) {
> +			case -EOPNOTSUPP:
> +				ext2_msg(sb, KERN_ERR,
>  					"error: device does not support dax");
> +				break;
> +			case -EINVAL:
> +				ext2_msg(sb, KERN_ERR,
> +					"error: unaligned partition for dax");
> +				break;
> +			default:
> +				ext2_msg(sb, KERN_ERR,
> +					"error: dax access failed (%d)", err);
> +				break;
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
