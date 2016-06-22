Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 33AD61A1E08
 for <linux-nvdimm@lists.01.org>; Wed, 22 Jun 2016 10:03:43 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id f189so31523373oig.3
 for <linux-nvdimm@lists.01.org>; Wed, 22 Jun 2016 10:03:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87fd92ea-5b21-1590-9842-1d33669e6da7@sandisk.com>
References: <146654196111.34694.7735150373057824399.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146654197196.34694.11595948607042214658.stgit@dwillia2-desk3.amr.corp.intel.com>
 <87fd92ea-5b21-1590-9842-1d33669e6da7@sandisk.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 22 Jun 2016 10:03:11 -0700
Message-ID: <CAPcyv4gxTj7zC+i2Wn3GHF-twpkVMJSwJ=A7wWuHLRNwjUGLUg@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] mmc: move 'parent' tracking to mmc_blk_data
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
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-block@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 21, 2016 at 11:38 PM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 06/21/2016 10:46 PM, Dan Williams wrote:
>>
>> In preparation for the removal of 'driverfs_dev' from 'struct gendisk',
>> carry this data in mmc_blk_data. It is used for registration of parent
>> disks and partitions.
>>
>> Cc: Ulf Hansson <ulf.hansson@linaro.org>
>> Reported-by: Bart Van Assche <bart.vanassche@sandisk.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/mmc/card/block.c |    5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> index 383184743f9a..d1733424bf6e 100644
>> --- a/drivers/mmc/card/block.c
>> +++ b/drivers/mmc/card/block.c
>> @@ -93,6 +93,7 @@ static DEFINE_SPINLOCK(mmc_blk_lock);
>>   */
>>  struct mmc_blk_data {
>>         spinlock_t      lock;
>> +       struct device   *parent;
>>         struct gendisk  *disk;
>>         struct mmc_queue queue;
>>         struct list_head part;
>> @@ -2270,7 +2271,7 @@ again:
>>         md->disk->fops = &mmc_bdops;
>>         md->disk->private_data = md;
>>         md->disk->queue = md->queue.queue;
>> -       md->disk->driverfs_dev = parent;
>> +       md->parent = parent;
>>         set_disk_ro(md->disk, md->read_only || default_ro);
>>         md->disk->flags = GENHD_FL_EXT_DEVT;
>>         if (area_type & (MMC_BLK_DATA_AREA_RPMB | MMC_BLK_DATA_AREA_BOOT))
>> @@ -2458,7 +2459,7 @@ static int mmc_add_disk(struct mmc_blk_data *md)
>>         int ret;
>>         struct mmc_card *card = md->queue.card;
>>
>> -       add_disk(md->disk);
>> +       device_add_disk(md->parent, md->disk);
>>         md->force_ro.show = force_ro_show;
>>         md->force_ro.store = force_ro_store;
>>         sysfs_attr_init(&md->force_ro.attr);
>
>
> What will the impact be of this patch on code that accesses driverfs_dev
> like printk_all_partitions()? Will this patch hurt bisectability?

Hmm, yes there will be a point in the history where
printk_all_partitions() will print " (driver?)" for mmc devices
instead of " driver: %s".  I would not classify that as breaking
bisection, but it's easy enough to fix up in v5.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
