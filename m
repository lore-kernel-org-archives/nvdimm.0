Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ACA821A1E04
 for <linux-nvdimm@lists.01.org>; Wed, 22 Jun 2016 07:32:58 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id f189so24600952oig.3
 for <linux-nvdimm@lists.01.org>; Wed, 22 Jun 2016 07:32:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a5024a02-adfb-c027-7a40-417cc10911af@sandisk.com>
References: <146654196111.34694.7735150373057824399.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146654197737.34694.9376917839573236856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <a5024a02-adfb-c027-7a40-417cc10911af@sandisk.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 22 Jun 2016 07:32:26 -0700
Message-ID: <CAPcyv4gmNtnS47YDOCw6EjQ4Kz7OF8TN+j95cQxU4ZWmTUXZyw@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] um: track 'parent' device in a local variable
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 21, 2016 at 11:20 PM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 06/21/2016 10:47 PM, Dan Williams wrote:
>>
>> In preparation for the removal of 'driverfs_dev' from 'struct gendisk'
>> use a local variable to track the parented vs un-parented case in
>> ubd_disk_register().
>>
>> Cc: Jeff Dike <jdike@addtoit.com>
>> Cc: Richard Weinberger <richard@nod.at>
>> Reported-by: Bart Van Assche <bart.vanassche@sandisk.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  arch/um/drivers/ubd_kern.c |    5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
>> index ef6b4d960bad..8ec7b4112f55 100644
>> --- a/arch/um/drivers/ubd_kern.c
>> +++ b/arch/um/drivers/ubd_kern.c
>> @@ -801,6 +801,7 @@ static void ubd_device_release(struct device *dev)
>>  static int ubd_disk_register(int major, u64 size, int unit,
>>                              struct gendisk **disk_out)
>>  {
>> +       struct device *dev = NULL;
>>         struct gendisk *disk;
>>
>>         disk = alloc_disk(1 << UBD_SHIFT);
>> @@ -823,12 +824,12 @@ static int ubd_disk_register(int major, u64 size,
>> int unit,
>>                 ubd_devs[unit].pdev.dev.release = ubd_device_release;
>>                 dev_set_drvdata(&ubd_devs[unit].pdev.dev,
>> &ubd_devs[unit]);
>>                 platform_device_register(&ubd_devs[unit].pdev);
>> -               disk->driverfs_dev = &ubd_devs[unit].pdev.dev;
>> +               dev = &ubd_devs[unit].pdev.dev;
>>         }
>>
>>         disk->private_data = &ubd_devs[unit];
>>         disk->queue = ubd_devs[unit].queue;
>> -       add_disk(disk);
>> +       device_add_disk(dev, disk);
>>
>>         *disk_out = disk;
>>         return 0;
>
>
> Hello Dan,
>
> The Reported-by tag is intended to give people credit who find bugs in the
> upstream kernel. What I reported was a bug not in the upstream kernel but in
> a previous version of this patch series so I think the "Reported-by" tag can
> be left out from this patch.

I see nothing wrong with using it to give credit to patches during
review, I also do this when static analysis finds a problem in a patch
before it gets upstream.  If the report fixes upstream code then I
additionally add a "Fixes" tag.  If you'd rather I don't list you as
reported-by that's fine, but there's nothing in the definition of
Reported-by in Documentation/SubmittingPatches that requires the bug
to be upstream first.

> Additionally, please consider to use a more descriptive name instead of
> "dev", e.g. "parent".

Sure, will do.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
