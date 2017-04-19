Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x236.google.com (mail-yb0-x236.google.com
 [IPv6:2607:f8b0:4002:c09::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1CC7C21954075
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 08:44:25 -0700 (PDT)
Received: by mail-yb0-x236.google.com with SMTP id 6so5543990ybq.2
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 08:44:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170419173138.06621e66@thinkpad>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149245617283.10206.846177305206642788.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170419173138.06621e66@thinkpad>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Apr 2017 08:44:23 -0700
Message-ID: <CAPcyv4jJogQ_dXL1KMDUhC-JPo1JFmGRSPh1pC-8Pqkgj1xCYA@mail.gmail.com>
Subject: Re: [resend PATCH v2 08/33] dcssblk: add dax_operations support
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
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 19, 2017 at 8:31 AM, Gerald Schaefer
<gerald.schaefer@de.ibm.com> wrote:
> On Mon, 17 Apr 2017 12:09:32 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
>> Setup a dax_dev to have the same lifetime as the dcssblk block device
>> and add a ->direct_access() method that is equivalent to
>> dcssblk_direct_access(). Once fs/dax.c has been converted to use
>> dax_operations the old dcssblk_direct_access() will be removed.
>>
>> Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/s390/block/Kconfig   |    1 +
>>  drivers/s390/block/dcssblk.c |   54 +++++++++++++++++++++++++++++++++++-------
>>  2 files changed, 46 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/s390/block/Kconfig b/drivers/s390/block/Kconfig
>> index 4a3b62326183..0acb8c2f9475 100644
>> --- a/drivers/s390/block/Kconfig
>> +++ b/drivers/s390/block/Kconfig
>> @@ -14,6 +14,7 @@ config BLK_DEV_XPRAM
>>
>>  config DCSSBLK
>>       def_tristate m
>> +     select DAX
>>       prompt "DCSSBLK support"
>>       depends on S390 && BLOCK
>>       help
>> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
>> index 415d10a67b7a..682a9eb4934d 100644
>> --- a/drivers/s390/block/dcssblk.c
>> +++ b/drivers/s390/block/dcssblk.c
>> @@ -18,6 +18,7 @@
>>  #include <linux/interrupt.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/pfn_t.h>
>> +#include <linux/dax.h>
>>  #include <asm/extmem.h>
>>  #include <asm/io.h>
>>
>> @@ -30,8 +31,10 @@ static int dcssblk_open(struct block_device *bdev, fmode_t mode);
>>  static void dcssblk_release(struct gendisk *disk, fmode_t mode);
>>  static blk_qc_t dcssblk_make_request(struct request_queue *q,
>>                                               struct bio *bio);
>> -static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
>> +static long dcssblk_blk_direct_access(struct block_device *bdev, sector_t secnum,
>>                        void **kaddr, pfn_t *pfn, long size);
>> +static long dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>> +             long nr_pages, void **kaddr, pfn_t *pfn);
>>
>>  static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
>>
>> @@ -40,7 +43,11 @@ static const struct block_device_operations dcssblk_devops = {
>>       .owner          = THIS_MODULE,
>>       .open           = dcssblk_open,
>>       .release        = dcssblk_release,
>> -     .direct_access  = dcssblk_direct_access,
>> +     .direct_access  = dcssblk_blk_direct_access,
>> +};
>> +
>> +static const struct dax_operations dcssblk_dax_ops = {
>> +     .direct_access = dcssblk_dax_direct_access,
>>  };
>>
>>  struct dcssblk_dev_info {
>> @@ -57,6 +64,7 @@ struct dcssblk_dev_info {
>>       struct request_queue *dcssblk_queue;
>>       int num_of_segments;
>>       struct list_head seg_list;
>> +     struct dax_device *dax_dev;
>>  };
>>
>>  struct segment_info {
>> @@ -389,6 +397,8 @@ dcssblk_shared_store(struct device *dev, struct device_attribute *attr, const ch
>>       }
>>       list_del(&dev_info->lh);
>>
>> +     kill_dax(dev_info->dax_dev);
>> +     put_dax(dev_info->dax_dev);
>>       del_gendisk(dev_info->gd);
>>       blk_cleanup_queue(dev_info->dcssblk_queue);
>>       dev_info->gd->queue = NULL;
>> @@ -525,6 +535,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
>>       int rc, i, j, num_of_segments;
>>       struct dcssblk_dev_info *dev_info;
>>       struct segment_info *seg_info, *temp;
>> +     struct dax_device *dax_dev;
>>       char *local_buf;
>>       unsigned long seg_byte_size;
>>
>> @@ -654,6 +665,11 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
>>       if (rc)
>>               goto put_dev;
>>
>> +     dax_dev = alloc_dax(dev_info, dev_info->gd->disk_name,
>> +                     &dcssblk_dax_ops);
>> +     if (!dax_dev)
>> +             goto put_dev;
>> +
>
> The returned dax_dev should be stored into dev_info->dax_dev, for later use
> by kill/put_dax(). This can also be done directly, so that we don't need the
> local dax_dev variable here.
>
> Also, in the error case, a proper rc should be set before going to put_dev,
> probably -ENOMEM.
>
> I took a quick look at the patches for the other affected drivers, and it
> looks like axonram also has the "missing rc" issue, and brd the "missing
> brd->dax_dev init" issue, pmem seems to be fine.

Thank you for taking a look. I'll get this fixed up.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
