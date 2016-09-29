Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D5C81A1DEB
 for <linux-nvdimm@lists.01.org>; Wed, 28 Sep 2016 19:26:11 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id t83so75977408oie.3
 for <linux-nvdimm@lists.01.org>; Wed, 28 Sep 2016 19:26:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hsZQYsw=d5tn=yY-tBzMnTT2YP+ZJHd4EtLpxxf-S_ow@mail.gmail.com>
References: <1475107811-8880-1-git-send-email-vishal.l.verma@intel.com>
 <1475107811-8880-2-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4hsZQYsw=d5tn=yY-tBzMnTT2YP+ZJHd4EtLpxxf-S_ow@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Sep 2016 19:26:10 -0700
Message-ID: <CAPcyv4hBCtUBs=YZeqfVmjJrfdoo8HXJQWQXG9bz5Lxx5utvQg@mail.gmail.com>
Subject: Re: [PATCH 1/3] nfit: don't start a full scrub by default for an MCE
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 28, 2016 at 5:53 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Sep 28, 2016 at 5:10 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
>> Starting a full Address Range Scrub (ARS) on hitting a memory error
>> machine check exception may not always be desirable. Provide a way
>> through sysfs to toggle the behavior between just adding the address
>> (cache line) where the MCE happened to the poison list and doing a full
>> scrub. The former (selective insertion of the address) is done
>> unconditionally.
>
>
>>
>> Cc: linux-acpi@vger.kernel.org
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Linda Knippers <linda.knippers@hpe.com>
>> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>> ---
>>  drivers/acpi/nfit/core.c | 23 ++++++++++++++++++++---
>>  drivers/acpi/nfit/mce.c  | 24 +++++++++++++++++++-----
>>  drivers/acpi/nfit/nfit.h |  6 ++++++
>>  3 files changed, 45 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>> index 80cc7c0..ec1069e 100644
>> --- a/drivers/acpi/nfit/core.c
>> +++ b/drivers/acpi/nfit/core.c
>> @@ -901,6 +901,14 @@ static ssize_t scrub_show(struct device *dev,
>
> I think scrub_show() should display the current auto-scrub mode, right?
>
>>         return rc;
>>  }
>>
>> +/*
>> + * The 'scrub' attribute can only have following values written to it:
>> + * '1': Start an on-demand scrub, and enable a full scrub to happen if a
>> + *      machine check exception for a memory error is received.
>> + * '2': Switch to the default mode where a machine check will only insert
>> + *      the address on which the memory error was received into the poison
>> + *      and badblocks lists.
>> + */
>>  static ssize_t scrub_store(struct device *dev,
>>                 struct device_attribute *attr, const char *buf, size_t size)
>>  {
>> @@ -911,15 +919,24 @@ static ssize_t scrub_store(struct device *dev,
>>         rc = kstrtol(buf, 0, &val);
>>         if (rc)
>>                 return rc;
>> -       if (val != 1)
>> -               return -EINVAL;
>>
>>         device_lock(dev);
>>         nd_desc = dev_get_drvdata(dev);
>>         if (nd_desc) {
>>                 struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
>>
>> -               rc = acpi_nfit_ars_rescan(acpi_desc);
>> +               switch (val) {
>> +               case MCE_SCRUB_ON:
>> +                       rc = acpi_nfit_ars_rescan(acpi_desc);
>> +                       acpi_desc->scrub_mode = MCE_SCRUB_ON;
>> +                       break;
>> +               case MCE_SCRUB_OFF:
>> +                       acpi_desc->scrub_mode = MCE_SCRUB_OFF;
>> +                       break;
>
> Shouldn't this still kick off a scrub?  It's awkward that the only way
> to run a scrub is to put the driver into automatic re-scrub mode.

Hmm, although it will probably still be awkward if we make it do a
scrub in this case.  Might be better to have a separate "auto_scrub"
property that sets what to do on latent error detection.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
