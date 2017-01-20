Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A821181A5B
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jan 2017 09:28:27 -0800 (PST)
Received: by mail-oi0-x22c.google.com with SMTP id j15so46753617oih.2
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jan 2017 09:28:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <148488422405.37913.13366670089124790849.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148488422405.37913.13366670089124790849.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Jan 2017 09:28:26 -0800
Message-ID: <CAPcyv4ihKqqR-bzNXeeTZ--F4MbEfqnmCyiQ2s3Ngc0oq488WQ@mail.gmail.com>
Subject: Re: [PATCH 02/13] block, dax: introduce dax_operations
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 19, 2017 at 7:50 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Prepare for the removal of memcpy_to_pmem() and copy_from_iter_pmem() by
> introducing dax_ops. This allows for driver specific overrides for the
> routines that transfer data to a dax capable block device.
>
> Cc: <dm-devel@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/powerpc/sysdev/axonram.c |    6 +++++-
>  drivers/block/brd.c           |    6 +++++-
>  drivers/md/dm.c               |    6 +++++-
>  drivers/nvdimm/pmem.c         |    6 +++++-
>  drivers/s390/block/dcssblk.c  |    6 +++++-
>  fs/block_dev.c                |    6 ++++--
>  include/linux/blkdev.h        |    8 ++++++--
>  7 files changed, 35 insertions(+), 9 deletions(-)
>
[..]
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3086da5664f3..87920a379d20 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2725,13 +2725,17 @@ static const struct pr_ops dm_pr_ops = {
>         .pr_clear       = dm_pr_clear,
>  };
>
> +static const struct dax_operations dm_dax_ops = {
> +       .direct_access = dm_blk_direct_access,
> +};
> +
>  static const struct block_device_operations dm_blk_dops = {
>         .open = dm_blk_open,
>         .release = dm_blk_close,
>         .ioctl = dm_blk_ioctl,
> -       .direct_access = dm_blk_direct_access,
>         .getgeo = dm_blk_getgeo,
>         .pr_ops = &dm_pr_ops,
> +       .dax_ops = &dm_dax_ops,
>         .owner = THIS_MODULE
>  };

I just realized we need to do a bit more plumbing to support the
device-mapper case. We need to implement all the dax_operations at the
dm_dax_ops level and pass in the physical sector so that device-mapper
can look up the backing block-device to call the real dax_operation if
it is implemented.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
