Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B42E11A1E8F
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jul 2016 15:19:03 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id f189so323386oig.3
 for <linux-nvdimm@lists.01.org>; Wed, 06 Jul 2016 15:18:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160704075404.GB10278@linux-rxt1.site>
References: <1467606771-21704-1-git-send-email-vikas.cha.sajjan@hpe.com>
 <20160704075404.GB10278@linux-rxt1.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 6 Jul 2016 15:18:20 -0700
Message-ID: <CAPcyv4h3QT9fwkVL6B79S=8UO6K+D8fzybWgr_dVS11vEB5=9A@mail.gmail.com>
Subject: Re: [PATCH] nfit: use devm_add_action_or_reset()
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
To: joeyli <jlee@suse.com>
Cc: Vikas C Sajjan <vikas.cha.sajjan@hpe.com>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Thanks, applied.

On Mon, Jul 4, 2016 at 12:54 AM, joeyli <jlee@suse.com> wrote:
> On Mon, Jul 04, 2016 at 10:02:51AM +0530, Vikas C Sajjan wrote:
>> If devm_add_action() fails, we are explicitly calling the cleanup to free
>> the resources allocated. Lets use the helper devm_add_action_or_reset()
>> and return directly in case of error, since the cleanup function
>> has been already called by the helper if there was any error.
>>
>> Signed-off-by: Vikas C Sajjan <vikas.cha.sajjan@hpe.com>
>> ---
>>  drivers/acpi/nfit.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
>> index c2ad967..44ebe1e 100644
>> --- a/drivers/acpi/nfit.c
>> +++ b/drivers/acpi/nfit.c
>> @@ -1920,11 +1920,11 @@ static int acpi_nfit_insert_resource(struct acpi_nfit_desc *acpi_desc,
>>       if (ret)
>>               return ret;
>>
>> -     ret = devm_add_action(acpi_desc->dev, acpi_nfit_remove_resource, res);
>> -     if (ret) {
>> -             remove_resource(res);
>> +     ret = devm_add_action_or_reset(acpi_desc->dev,
>> +                                     acpi_nfit_remove_resource,
>> +                                     res);
>> +     if (ret)
>>               return ret;
>> -     }
>>
>>       return 0;
>>  }
>> --
>> 1.9.1
>>
>
> Reviewed-by: Lee, Chun-Yi <jlee@suse.com>
>
> Joey Lee
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
