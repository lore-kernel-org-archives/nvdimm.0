Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x231.google.com (mail-wm0-x231.google.com
 [IPv6:2a00:1450:400c:c09::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 549F71A1ECC
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jul 2016 06:52:20 -0700 (PDT)
Received: by mail-wm0-x231.google.com with SMTP id f65so101165124wmi.0
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jul 2016 06:51:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <146705580308.39775.10937037092465199137.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146705579255.39775.12551436695635245858.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146705580308.39775.10937037092465199137.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 12 Jul 2016 15:51:32 +0200
Message-ID: <CAPDyKFqKQd2KcCAW=Qy3qaoi3sfUMoiq0u8QSUf1n=hFiDebiA@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] mmc: move 'parent' tracking to mmc_blk_data
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
Cc: linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 27 June 2016 at 21:30, Dan Williams <dan.j.williams@intel.com> wrote:
> In preparation for the removal of 'driverfs_dev' from 'struct gendisk',
> carry this data in mmc_blk_data. It is used for registration of parent
> disks and partitions.
>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

If not too late (sorry for the delay):

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
>  drivers/mmc/card/block.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 383184743f9a..d1733424bf6e 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -93,6 +93,7 @@ static DEFINE_SPINLOCK(mmc_blk_lock);
>   */
>  struct mmc_blk_data {
>         spinlock_t      lock;
> +       struct device   *parent;
>         struct gendisk  *disk;
>         struct mmc_queue queue;
>         struct list_head part;
> @@ -2270,7 +2271,7 @@ again:
>         md->disk->fops = &mmc_bdops;
>         md->disk->private_data = md;
>         md->disk->queue = md->queue.queue;
> -       md->disk->driverfs_dev = parent;
> +       md->parent = parent;
>         set_disk_ro(md->disk, md->read_only || default_ro);
>         md->disk->flags = GENHD_FL_EXT_DEVT;
>         if (area_type & (MMC_BLK_DATA_AREA_RPMB | MMC_BLK_DATA_AREA_BOOT))
> @@ -2458,7 +2459,7 @@ static int mmc_add_disk(struct mmc_blk_data *md)
>         int ret;
>         struct mmc_card *card = md->queue.card;
>
> -       add_disk(md->disk);
> +       device_add_disk(md->parent, md->disk);
>         md->force_ro.show = force_ro_show;
>         md->force_ro.store = force_ro_store;
>         sysfs_attr_init(&md->force_ro.attr);
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
