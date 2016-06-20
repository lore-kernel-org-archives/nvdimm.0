Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x22f.google.com (mail-ob0-x22f.google.com
 [IPv6:2607:f8b0:4003:c01::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8DB841A1DFC
 for <linux-nvdimm@lists.01.org>; Mon, 20 Jun 2016 07:43:57 -0700 (PDT)
Received: by mail-ob0-x22f.google.com with SMTP id y7so150921obt.1
 for <linux-nvdimm@lists.01.org>; Mon, 20 Jun 2016 07:43:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8dc61bb4-fc9f-a855-d792-37e4e6a02db9@sandisk.com>
References: <146618127395.31030.11800447312061202344.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146618128465.31030.12159307386730181867.stgit@dwillia2-desk3.amr.corp.intel.com>
 <8dc61bb4-fc9f-a855-d792-37e4e6a02db9@sandisk.com>
Date: Mon, 20 Jun 2016 07:43:27 -0700
Message-ID: <CAPcyv4hHkMuj+E5_VZihi92fdimmzLk=ciryBrhR2ZfmK9SEKw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] block: convert to device_add_disk()
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
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Ulf Hansson <ulf.hansson@linaro.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, David Woodhouse <dwmw2@infradead.org>, "Michael S. Tsirkin" <mst@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Keith Busch <keith.busch@intel.com>, "David S. Miller" <davem@davemloft.net>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 20, 2016 at 6:33 AM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 06/17/2016 06:34 PM, Dan Williams wrote:
>>
>> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
>> index ef6b4d960bad..4e7cb5df8e43 100644
>> --- a/arch/um/drivers/ubd_kern.c
>> +++ b/arch/um/drivers/ubd_kern.c
>> @@ -823,12 +823,11 @@ static int ubd_disk_register(int major, u64 size,
>> int unit,
>>                 ubd_devs[unit].pdev.dev.release = ubd_device_release;
>>                 dev_set_drvdata(&ubd_devs[unit].pdev.dev,
>> &ubd_devs[unit]);
>>                 platform_device_register(&ubd_devs[unit].pdev);
>> -               disk->driverfs_dev = &ubd_devs[unit].pdev.dev;
>>         }
>>
>>         disk->private_data = &ubd_devs[unit];
>>         disk->queue = ubd_devs[unit].queue;
>> -       add_disk(disk);
>> +       device_add_disk(&ubd_devs[unit].pdev.dev, disk);
>>
>>         *disk_out = disk;
>>         return 0;
>
>
> Have you reviewed this patch yourself? I think the above change is an
> unintended behavior change.

Good catch! You are correct, this driver emits both parented an
un-parented disks.  I'll fix this up and re-check the others.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
