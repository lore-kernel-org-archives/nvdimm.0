Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x229.google.com (mail-io0-x229.google.com
 [IPv6:2607:f8b0:4001:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EADF21A1E07
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jul 2016 17:43:40 -0700 (PDT)
Received: by mail-io0-x229.google.com with SMTP id q83so53333506iod.1
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jul 2016 17:43:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160726205843.GA5520@omniknight.lm.intel.com>
References: <5797C9DE.3070901@redhat.com>
 <20160726205843.GA5520@omniknight.lm.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Jul 2016 17:43:39 -0700
Message-ID: <CAPcyv4hUGX_nCvtGQjwvGOkCPPwCXODVJ1gZbAOW3QvmP_i5bQ@mail.gmail.com>
Subject: Re: btt ndctl question
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linda Knippers <lknipper@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 26, 2016 at 1:58 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> On 07/26, Linda Knippers wrote:
>> My system has 4 8G NVDIMMs and I have them configured in different ways, as you can
>> see from the ndctl output:
>>
>> $ ndctl list
>> [
>>   {
>>     "dev":"namespace3.0",
>>     "mode":"raw",
>>     "size":8589934592,
>>     "blockdev":"pmem3"
>>   },
>>   {
>>     "dev":"namespace2.0",
>>     "mode":"memory",
>>     "size":8587837440,
>>     "uuid":"2567d762-68ae-486b-a6eb-2d3ab1b9dca9",
>>     "blockdev":"pmem2"
>>   },
>>   {
>>     "dev":"namespace1.0",
>>     "mode":"sector",
>>     "uuid":"44fb474e-7db8-4438-ad95-05ecb9f2075e",
>>     "sector_size":4096,
>>     "blockdev":"pmem1s"
>>   },
>>   {
>>     "dev":"namespace0.0",
>>     "mode":"memory",
>>     "size":8453619712,
>>     "uuid":"933ed54b-5b64-47f1-8409-c88f7c846522",
>>     "blockdev":"pmem0"
>>   }
>> ]
>>
>> The two memory namespaces have different sizes because one is --map=dev and the other is --map=mem.
>> It would be nice if the map option was displayed but my question is about the size value for the
>> btt device, or lack of one.
>>
>> All the namespaces show a size except for the btt.  The btt only shows a sector size.  There
>> is no size value exposed by the btt sysfs information, which is probably why it's not in ndctl.
>>
>> I know the size can be gotten from the block device but it looks like an omission here.
>> Is this a bug or a feature?
>
> Probably an omission :)
> This patch should expose a size attribute in sysfs:
>
> $ cat /sys/bus/nd/devices/btt7.0/size
> 32440320
>
> I can look at the 'ndctl list' enabling too if this looks good.
>
> 8<------
>
> From fb119bf4380d1d65d82754e581bbd41161c2100f Mon Sep 17 00:00:00 2001
> From: Vishal Verma <vishal.l.verma@intel.com>
> Date: Tue, 26 Jul 2016 14:54:39 -0600
> Subject: [PATCH] nvdimm, btt: add a size attribute for BTTs
>
> To be consistent with other namespaces, expose a 'size' attribute for
> BTT devices also.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Linda Knippers <linda.knippers@hpe.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/nvdimm/btt.c      |  1 +
>  drivers/nvdimm/btt_devs.c | 15 +++++++++++++++
>  drivers/nvdimm/nd.h       |  1 +
>  3 files changed, 17 insertions(+)
>
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 68a7c3c..71ce0dc 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1270,6 +1270,7 @@ static int btt_blk_init(struct btt *btt)
>                 }
>         }
>         set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
> +       btt->nd_btt->size = btt->nlba * btt->sector_size;
>         revalidate_disk(btt->btt_disk);
>
>         return 0;
> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> index 3fa7919..b54cfc7 100644
> --- a/drivers/nvdimm/btt_devs.c
> +++ b/drivers/nvdimm/btt_devs.c
> @@ -140,10 +140,25 @@ static ssize_t namespace_store(struct device *dev,
>  }
>  static DEVICE_ATTR_RW(namespace);
>
> +
> +static ssize_t size_show(struct device *dev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct nd_btt *nd_btt = to_nd_btt(dev);
> +       ssize_t rc;
> +
> +       nvdimm_bus_lock(dev);
> +       rc = sprintf(buf, "%llu\n", nd_btt->size);
> +       nvdimm_bus_unlock(dev);
> +       return rc;

Why is nvdimm_bus_lock() used here?

I think you want to follow the pattern of size_show() in
drivers/nvdimm/pfn_devs.c.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
