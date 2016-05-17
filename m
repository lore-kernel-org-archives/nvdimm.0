Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 736C21A1F89
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 15:07:39 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id x201so48061048oif.3
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 15:07:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1462897437-16626-7-git-send-email-toshi.kani@hpe.com>
References: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
 <1462897437-16626-7-git-send-email-toshi.kani@hpe.com>
Date: Tue, 17 May 2016 15:07:33 -0700
Message-ID: <CAPcyv4im1zfO9PtnBMm9OArwYz9h8DkP-9CC+73GDOUx6XNDRQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] block: Update blkdev_dax_capable() for consistency
From: Dan Williams <dan.j.williams@intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, micah.parrish@hpe.com, Jens Axboe <axboe@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 10, 2016 at 9:23 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> blkdev_dax_capable() is similar to bdev_dax_supported(), but needs
> to remain as a separate interface for checking dax capability of
> a raw block device.
>
> Rename and relocate blkdev_dax_capable() to keep them maintained
> consistently, and call bdev_direct_access() for the dax capability
> check.
>
> There is no change in the behavior.
>
> Link: https://lkml.org/lkml/2016/5/9/950
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Boaz Harrosh <boaz@plexistor.com>
> ---
>  block/ioctl.c          |   30 ------------------------------
>  fs/block_dev.c         |   39 +++++++++++++++++++++++++++++++++++++--
>  include/linux/blkdev.h |    1 +
>  include/linux/fs.h     |    8 --------
>  4 files changed, 38 insertions(+), 40 deletions(-)
>
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 4ff1f92..7eeda07 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -4,7 +4,6 @@
>  #include <linux/gfp.h>
>  #include <linux/blkpg.h>
>  #include <linux/hdreg.h>
> -#include <linux/badblocks.h>
>  #include <linux/backing-dev.h>
>  #include <linux/fs.h>
>  #include <linux/blktrace_api.h>
> @@ -407,35 +406,6 @@ static inline int is_unrecognized_ioctl(int ret)
>                 ret == -ENOIOCTLCMD;
>  }
>
> -#ifdef CONFIG_FS_DAX
> -bool blkdev_dax_capable(struct block_device *bdev)
> -{
> -       struct gendisk *disk = bdev->bd_disk;
> -
> -       if (!disk->fops->direct_access)
> -               return false;
> -
> -       /*
> -        * If the partition is not aligned on a page boundary, we can't
> -        * do dax I/O to it.
> -        */
> -       if ((bdev->bd_part->start_sect % (PAGE_SIZE / 512))
> -                       || (bdev->bd_part->nr_sects % (PAGE_SIZE / 512)))
> -               return false;
> -
> -       /*
> -        * If the device has known bad blocks, force all I/O through the
> -        * driver / page cache.
> -        *
> -        * TODO: support finer grained dax error handling
> -        */
> -       if (disk->bb && disk->bb->count)
> -               return false;
> -
> -       return true;
> -}
> -#endif
> -
>  static int blkdev_flushbuf(struct block_device *bdev, fmode_t mode,
>                 unsigned cmd, unsigned long arg)
>  {
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index db55638..5d79093 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -29,6 +29,7 @@
>  #include <linux/log2.h>
>  #include <linux/cleancache.h>
>  #include <linux/dax.h>
> +#include <linux/badblocks.h>
>  #include <asm/uaccess.h>
>  #include "internal.h"
>
> @@ -554,6 +555,40 @@ int bdev_dax_supported(struct super_block *sb, int blocksize)
>  }
>  EXPORT_SYMBOL_GPL(bdev_dax_supported);
>
> +/**
> + * bdev_dax_capable() - Return if the raw device is capable for dax
> + * @bdev: The device for raw block device access
> + */
> +bool bdev_dax_capable(struct block_device *bdev)
> +{
> +       struct gendisk *disk = bdev->bd_disk;
> +       struct blk_dax_ctl dax = {
> +               .size = PAGE_SIZE,
> +       };
> +
> +       if (!IS_ENABLED(CONFIG_FS_DAX))
> +               return false;
> +
> +       dax.sector = 0;
> +       if (bdev_direct_access(bdev, &dax) < 0)
> +               return false;
> +
> +       dax.sector = bdev->bd_part->nr_sects - (PAGE_SIZE / 512);
> +       if (bdev_direct_access(bdev, &dax) < 0)
> +               return false;

So I just noticed that this new implementation of bdev_dax_capable()
prevents us from enabling DAX in the presence of errors, which was the
goal of Vishal's pending patches for 4.7.

I like the goal of centralizing checks, but this collides the base DAX
capability with the ability to perform an actual accesses at a given
address.

All the immediate solutions that come to mind right now are pretty
ugly, like an ignore errors flag...

Hmm, what about explicitly returning -EBADBLOCK and updating size to
return the offset of the error?  That might be useful information to
have in general...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
