Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 43E9D1A1F00
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jul 2016 22:27:55 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id l72so2801070oig.2
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jul 2016 22:27:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160715051553.GE27155@linux-rxt1.site>
References: <146855333714.573.13934675433503265133.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160715051553.GE27155@linux-rxt1.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Jul 2016 22:27:07 -0700
Message-ID: <CAPcyv4ioH59KiQruBZS4oGHFPWF1F4StwWq-kdaMF2ACmix7sA@mail.gmail.com>
Subject: Re: [PATCH 1/2] nfit: fix _FIT evaluation memory leak
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
Cc: Xiao Guangrong <guangrong.xiao@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 14, 2016 at 10:15 PM, joeyli <jlee@suse.com> wrote:
> Hi Dan,
>
> On Thu, Jul 14, 2016 at 08:28:57PM -0700, Dan Williams wrote:
>> acpi_evaluate_object() allocates memory. Free the buffer allocated
>> during acpi_nfit_add().
>>
>> Cc: <stable@vger.kernel.org>
>> Cc: Vishal Verma <vishal.l.verma@intel.com>
>> Reported-by: Xiao Guangrong <guangrong.xiao@intel.com>
>> Reported-by: Haozhong Zhang <haozhong.zhang@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/acpi/nfit.c |    7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
>> index 0497175ee6cb..008dbaaa2b75 100644
>> --- a/drivers/acpi/nfit.c
>> +++ b/drivers/acpi/nfit.c
>> @@ -2414,12 +2414,15 @@ static int acpi_nfit_add(struct acpi_device *adev)
>>                       acpi_desc->nfit =
>>                               (struct acpi_nfit_header *)obj->buffer.pointer;
>>                       sz = obj->buffer.length;
>> +                     rc = acpi_nfit_init(acpi_desc, sz);
>>               } else
>>                       dev_dbg(dev, "%s invalid type %d, ignoring _FIT\n",
>>                                __func__, (int) obj->type);
>> -     }
>> +             kfree(buf.pointer);
>> +             acpi_desc->nfit = NULL;
>
> Looks "acpi_desc->nfit = NULL" statement will be removed in [PATCH 2/2]
> immediately. Why add it in PATCH 1?

I was debating it, but for code readability of -stable kernels (where
patch2 will not be included) I want to make it clear that nothing uses
the value of ->nfit outside of acpi_nfit_init().

>
>> +     } else
>> +             rc = acpi_nfit_init(acpi_desc, sz);
>>
>> -     rc = acpi_nfit_init(acpi_desc, sz);
>>       if (rc) {
>>               nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
>>               return rc;
>>
>
> Other parts are no problem to me.

Thanks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
