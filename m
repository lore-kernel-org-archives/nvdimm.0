Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x22f.google.com (mail-ob0-x22f.google.com
 [IPv6:2607:f8b0:4003:c01::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D96E31A1F76
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 08:18:07 -0700 (PDT)
Received: by mail-ob0-x22f.google.com with SMTP id j9so56724613obd.3
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 08:18:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5723676F.9000006@hpe.com>
References: <146189587309.28821.2994135280775533869.stgit@dwillia2-desk3.amr.corp.intel.com>
 <5723676F.9000006@hpe.com>
Date: Fri, 29 Apr 2016 08:18:06 -0700
Message-ID: <CAPcyv4jUkr-h+Wor9Pda35CS17VAKC8pAm4xkO7A0eRQWUSd2A@mail.gmail.com>
Subject: Re: [PATCH] nfit: fix format interface code byte order per ACPI6.1
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 29, 2016 at 6:53 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>
>
> On 4/28/2016 10:11 PM, Dan Williams wrote:
>> ACPI6.1 clarifies that DCR fields are stored as an array of bytes,
>> update the format interface code constants to match.
>>
>> Cc: Toshi Kani <toshi.kani@hpe.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/acpi/nfit.h |   12 +++++++-----
>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
>> index c75576b2d50e..92ea5d06c7fe 100644
>> --- a/drivers/acpi/nfit.h
>> +++ b/drivers/acpi/nfit.h
>> @@ -41,11 +41,13 @@ enum nfit_uuids {
>>       NFIT_UUID_MAX,
>>  };
>>
>> -enum nfit_fic {
>> -     NFIT_FIC_BYTE = 0x101, /* byte-addressable energy backed */
>> -     NFIT_FIC_BLK = 0x201, /* block-addressable non-energy backed */
>> -     NFIT_FIC_BYTEN = 0x301, /* byte-addressable non-energy backed */
>> -};
>> +/*
>> + * Region format interface codes are stored as an array of bytes in the
>> + * NFIT DIMM Control Region structure
>> + */
>> +#define NFIT_FIC_BYTE cpu_to_be16(0x101) /* byte-addressable energy */
>
> energy backed?

Yup, will fix.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
