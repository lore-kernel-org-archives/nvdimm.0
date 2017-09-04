Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B57DE21E3EA8A
 for <linux-nvdimm@lists.01.org>; Mon,  4 Sep 2017 03:23:36 -0700 (PDT)
Date: Mon, 4 Sep 2017 12:26:19 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] dax: fix FS_DAX=n BLOCK=y compilation
Message-ID: <20170904102619.GA1761@quack2.suse.cz>
References: <150445955491.4453.8477796864040491127.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150445955491.4453.8477796864040491127.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, kbuild test robot <fengguang.wu@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Sun 03-09-17 10:25:55, Dan Williams wrote:
> The 0day kbuild robot reports:
> 
> >> drivers//dax/super.c:64:20: error: redefinition of 'fs_dax_get_by_bdev'
>     struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>                        ^~~~~~~~~~~~~~~~~~
>    In file included from drivers//dax/super.c:22:0:
>    include/linux/dax.h:76:34: note: previous definition of 'fs_dax_get_by_bdev' was here
>     static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>                                      ^~~~~~~~~~~~~~~~~~
> 
> Protect the definition of fs_dax_get_by_bdev() in drivers/dax/super.c
> with an ifdef.
> 
> Fixes: 78f354735081 ("dax: introduce a fs_dax_get_by_bdev() helper")
> Cc: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

OK, or you could have both !DAX and DAX implementations in
include/linux/dax.h as inline together? It would look a bit more logical to
me. But I don't care much. So

Reviewed-by: Jan Kara <jack@suse.cz>

							Honza


> ---
>  drivers/dax/super.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index b699aac268a6..3600ff786646 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -61,6 +61,7 @@ int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
>  }
>  EXPORT_SYMBOL(bdev_dax_pgoff);
>  
> +#if IS_ENABLED(CONFIG_FS_DAX)
>  struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>  {
>  	if (!blk_queue_dax(bdev->bd_queue))
> @@ -68,6 +69,7 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>  	return fs_dax_get_by_host(bdev->bd_disk->disk_name);
>  }
>  EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> +#endif
>  
>  /**
>   * __bdev_dax_supported() - Check if the device supports dax for filesystem
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
