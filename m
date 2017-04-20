Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4BD221954077
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 09:30:32 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id r203so57369910oib.3
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 09:30:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149245618859.10206.13182319600260215993.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149245618859.10206.13182319600260215993.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Apr 2017 09:30:31 -0700
Message-ID: <CAPcyv4iskwS2izbZEtf7vSsk06cd3C0jhbDF3sfsOkWakc6jaw@mail.gmail.com>
Subject: Re: [resend PATCH v2 11/33] dm: add dax_device and dax_operations
 support
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
Cc: Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 17, 2017 at 12:09 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Allocate a dax_device to represent the capacity of a device-mapper
> instance. Provide a ->direct_access() method via the new dax_operations
> indirection that mirrors the functionality of the current direct_access
> support via block_device_operations.  Once fs/dax.c has been converted
> to use dax_operations the old dm_blk_direct_access() will be removed.
>
> A new helper dm_dax_get_live_target() is introduced to separate some of
> the dm-specifics from the direct_access implementation.
>
> This enabling is only for the top-level dm representation to upper
> layers. Converting target direct_access implementations is deferred to a
> separate patch.
>
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Cc: Mike Snitzer <snitzer@redhat.com>

Hi Mike,

Any concerns with these dax_device and dax_operations changes to
device-mapper for the upcoming merge window?


> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/md/Kconfig            |    1
>  drivers/md/dm-core.h          |    1
>  drivers/md/dm.c               |   84 ++++++++++++++++++++++++++++++++++-------
>  include/linux/device-mapper.h |    1
>  4 files changed, 73 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index b7767da50c26..1de8372d9459 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -200,6 +200,7 @@ config BLK_DEV_DM_BUILTIN
>  config BLK_DEV_DM
>         tristate "Device mapper support"
>         select BLK_DEV_DM_BUILTIN
> +       select DAX
>         ---help---
>           Device-mapper is a low level volume manager.  It works by allowing
>           people to specify mappings for ranges of logical sectors.  Various
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index 136fda3ff9e5..538630190f66 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -58,6 +58,7 @@ struct mapped_device {
>         struct target_type *immutable_target_type;
>
>         struct gendisk *disk;
> +       struct dax_device *dax_dev;
>         char name[16];
>
>         void *interface_ptr;
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index dfb75979e455..bd56dfe43a99 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -16,6 +16,7 @@
>  #include <linux/blkpg.h>
>  #include <linux/bio.h>
>  #include <linux/mempool.h>
> +#include <linux/dax.h>
>  #include <linux/slab.h>
>  #include <linux/idr.h>
>  #include <linux/hdreg.h>
> @@ -908,31 +909,68 @@ int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
>  }
>  EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
>
> -static long dm_blk_direct_access(struct block_device *bdev, sector_t sector,
> -                                void **kaddr, pfn_t *pfn, long size)
> +static struct dm_target *dm_dax_get_live_target(struct mapped_device *md,
> +               sector_t sector, int *srcu_idx)
>  {
> -       struct mapped_device *md = bdev->bd_disk->private_data;
>         struct dm_table *map;
>         struct dm_target *ti;
> -       int srcu_idx;
> -       long len, ret = -EIO;
>
> -       map = dm_get_live_table(md, &srcu_idx);
> +       map = dm_get_live_table(md, srcu_idx);
>         if (!map)
> -               goto out;
> +               return NULL;
>
>         ti = dm_table_find_target(map, sector);
>         if (!dm_target_is_valid(ti))
> -               goto out;
> +               return NULL;
>
> -       len = max_io_len(sector, ti) << SECTOR_SHIFT;
> -       size = min(len, size);
> +       return ti;
> +}
>
> -       if (ti->type->direct_access)
> -               ret = ti->type->direct_access(ti, sector, kaddr, pfn, size);
> -out:
> +static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
> +               long nr_pages, void **kaddr, pfn_t *pfn)
> +{
> +       struct mapped_device *md = dax_get_private(dax_dev);
> +       sector_t sector = pgoff * PAGE_SECTORS;
> +       struct dm_target *ti;
> +       long len, ret = -EIO;
> +       int srcu_idx;
> +
> +       ti = dm_dax_get_live_target(md, sector, &srcu_idx);
> +
> +       if (!ti)
> +               goto out;
> +       if (!ti->type->direct_access)
> +               goto out;
> +       len = max_io_len(sector, ti) / PAGE_SECTORS;
> +       if (len < 1)
> +               goto out;
> +       nr_pages = min(len, nr_pages);
> +       if (ti->type->direct_access) {
> +               ret = ti->type->direct_access(ti, sector, kaddr, pfn,
> +                               nr_pages * PAGE_SIZE);
> +               /*
> +                * FIXME: convert ti->type->direct_access to return
> +                * nr_pages directly.
> +                */
> +               if (ret >= 0)
> +                       ret /= PAGE_SIZE;
> +       }
> + out:
>         dm_put_live_table(md, srcu_idx);
> -       return min(ret, size);
> +
> +       return ret;
> +}
> +
> +static long dm_blk_direct_access(struct block_device *bdev, sector_t sector,
> +               void **kaddr, pfn_t *pfn, long size)
> +{
> +       struct mapped_device *md = bdev->bd_disk->private_data;
> +       struct dax_device *dax_dev = md->dax_dev;
> +       long nr_pages = size / PAGE_SIZE;
> +
> +       nr_pages = dm_dax_direct_access(dax_dev, sector / PAGE_SECTORS,
> +                       nr_pages, kaddr, pfn);
> +       return nr_pages < 0 ? nr_pages : nr_pages * PAGE_SIZE;
>  }
>
>  /*
> @@ -1437,6 +1475,7 @@ static int next_free_minor(int *minor)
>  }
>
>  static const struct block_device_operations dm_blk_dops;
> +static const struct dax_operations dm_dax_ops;
>
>  static void dm_wq_work(struct work_struct *work);
>
> @@ -1483,6 +1522,12 @@ static void cleanup_mapped_device(struct mapped_device *md)
>         if (md->bs)
>                 bioset_free(md->bs);
>
> +       if (md->dax_dev) {
> +               kill_dax(md->dax_dev);
> +               put_dax(md->dax_dev);
> +               md->dax_dev = NULL;
> +       }
> +
>         if (md->disk) {
>                 spin_lock(&_minor_lock);
>                 md->disk->private_data = NULL;
> @@ -1510,6 +1555,7 @@ static void cleanup_mapped_device(struct mapped_device *md)
>  static struct mapped_device *alloc_dev(int minor)
>  {
>         int r, numa_node_id = dm_get_numa_node();
> +       struct dax_device *dax_dev;
>         struct mapped_device *md;
>         void *old_md;
>
> @@ -1574,6 +1620,12 @@ static struct mapped_device *alloc_dev(int minor)
>         md->disk->queue = md->queue;
>         md->disk->private_data = md;
>         sprintf(md->disk->disk_name, "dm-%d", minor);
> +
> +       dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops);
> +       if (!dax_dev)
> +               goto bad;
> +       md->dax_dev = dax_dev;
> +
>         add_disk(md->disk);
>         format_dev_t(md->name, MKDEV(_major, minor));
>
> @@ -2781,6 +2833,10 @@ static const struct block_device_operations dm_blk_dops = {
>         .owner = THIS_MODULE
>  };
>
> +static const struct dax_operations dm_dax_ops = {
> +       .direct_access = dm_dax_direct_access,
> +};
> +
>  /*
>   * module hooks
>   */
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index a7e6903866fd..bcba4d89089c 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -130,6 +130,7 @@ typedef int (*dm_busy_fn) (struct dm_target *ti);
>   */
>  typedef long (*dm_direct_access_fn) (struct dm_target *ti, sector_t sector,
>                                      void **kaddr, pfn_t *pfn, long size);
> +#define PAGE_SECTORS (PAGE_SIZE / 512)
>
>  void dm_error(const char *message);
>
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
