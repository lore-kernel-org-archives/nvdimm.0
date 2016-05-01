Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x22a.google.com (mail-wm0-x22a.google.com
 [IPv6:2a00:1450:400c:c09::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE7981A1F03
 for <linux-nvdimm@lists.01.org>; Sun,  1 May 2016 02:35:18 -0700 (PDT)
Received: by mail-wm0-x22a.google.com with SMTP id g17so99562011wme.1
 for <linux-nvdimm@lists.01.org>; Sun, 01 May 2016 02:35:18 -0700 (PDT)
Message-ID: <5725CDD2.60904@plexistor.com>
Date: Sun, 01 May 2016 12:35:14 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] ext4: Add alignment check for DAX mount
References: <1461962375-3720-1-git-send-email-toshi.kani@hpe.com>
 <1461962375-3720-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1461962375-3720-2-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca, tytso@mit.edu, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 04/29/2016 11:39 PM, Toshi Kani wrote:
> When a partition is not aligned by 4KB, mount -o dax succeeds,
> but any read/write access to the filesystem fails, except for
> metadata update.
> 
> Add alignment check to ext4_fill_super() when -o dax is specified.
> 
> Reported-by: Micah Parrish <micah.parrish@hpe.com>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/ext4/super.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 304c712..90a8670 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3421,6 +3421,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  					"error: unsupported blocksize for dax");
>  			goto failed_mount;
>  		}
> +		if (sb->s_bdev->bd_part->start_sect % (PAGE_SIZE / 512) ||
> +		    sb->s_bdev->bd_part->nr_sects % (PAGE_SIZE / 512)) {

Can you please not do this like this? For me is a layering violation only
the device should know what are its limits.

I would prefer if you just try to bdev_direct_access() the 0 sector and if
it fails then fail here. This way you let the device decide what it needs
and if/how to support unaligned partitions.
(For example it could by shrinking its size)

Thanks
Boaz

> +			ext4_msg(sb, KERN_ERR,
> +					"error: unaligned partition for dax");
> +			goto failed_mount;
> +		}
>  		if (!sb->s_bdev->bd_disk->fops->direct_access) {
>  			ext4_msg(sb, KERN_ERR,
>  					"error: device does not support dax");
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
