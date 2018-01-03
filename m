Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F3627222A54D9
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jan 2018 06:16:28 -0800 (PST)
Date: Wed, 3 Jan 2018 15:21:30 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 03/18] ext2: auto disable dax instead of failing mount
Message-ID: <20180103142130.GH4911@quack2.suse.cz>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407697703.38751.2935252018151032360.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407697703.38751.2935252018151032360.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat 23-12-17 16:56:17, Dan Williams wrote:
> Bring the ext2 filesystem in line with xfs that only warns and continues
> when the "-o dax" option is specified to mount and the backing device
> does not support dax. This is in preparation for removing dax support
> from devices that do not enable get_user_pages() operations on dax
> mappings. In other words 'gup' support is required and configurations
> that were using so called 'page-less' dax will be converted back to
> using the page cache.
> 
> Removing the broken 'page-less' dax support is a pre-requisite for
> removing the "EXPERIMENTAL" warning when mounting a filesystem in dax
> mode.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/super.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 7646818ab266..38f9222606ee 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -959,8 +959,11 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
>  		err = bdev_dax_supported(sb, blocksize);
> -		if (err)
> -			goto failed_mount;
> +		if (err) {
> +			ext2_msg(sb, KERN_ERR,
> +				"DAX unsupported by block device. Turning off DAX.");
> +			sbi->s_mount_opt &= ~EXT2_MOUNT_DAX;
> +		}
>  	}
>  
>  	/* If the blocksize doesn't match, re-read the thing.. */
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
