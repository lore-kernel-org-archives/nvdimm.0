Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6A31021F3B3F2
 for <linux-nvdimm@lists.01.org>; Mon, 30 Oct 2017 10:39:40 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id h200so23435531oib.4
 for <linux-nvdimm@lists.01.org>; Mon, 30 Oct 2017 10:43:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ef91b61-3a09-ca16-b19d-11facc83279d@intel.com>
References: <150930654766.21067.7295669798909000270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150930655869.21067.17370712774978208604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <3ef91b61-3a09-ca16-b19d-11facc83279d@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 30 Oct 2017 10:43:30 -0700
Message-ID: <CAPcyv4jpFHmSxM8t-Js72mb=sG=idKrRWS82uzv=ATMagGV8JA@mail.gmail.com>
Subject: Re: [PATCH 2/2] acpi,
 nfit: add support for NVDIMM_FAMILY_INTEL v1.6 DSMs
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 30, 2017 at 10:37 AM, Dave Jiang <dave.jiang@intel.com> wrote:
>
>
> On 10/29/2017 12:49 PM, Dan Williams wrote:
>> Per v1.6 of the NVDIMM_FAMILY_INTEL command set [1] some of the new
>> commands require rev-id 2. In addition to enabling ND_CMD_CALL for these
>> new function numbers, add a lookup table for revision-ids by family
>> and function number.
>>
>> [1]: http://pmem.io/documents/NVDIMM_DSM_Interface-V1.6.pdf
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/acpi/nfit/core.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
>>  drivers/acpi/nfit/nfit.h |   19 ++++++++++++++++++-
>>  2 files changed, 58 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>> index e0059949700d..bef305080de3 100644
>> --- a/drivers/acpi/nfit/core.c
>> +++ b/drivers/acpi/nfit/core.c
[..]
>> @@ -1650,7 +1683,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>>       if (override_dsm_mask && !disable_vendor_specific)
>>               dsm_mask = override_dsm_mask;
>>       else if (nfit_mem->family == NVDIMM_FAMILY_INTEL) {
>> -             dsm_mask = 0x3fe;
>> +             dsm_mask = 0x7fbfe;
>
> Can this be changed to a define of ND_CMD bits or together instead of
> magic number?
>

Sure, especially since we have defines for all those numbers now... I
wouldn't want to do this for the other vendor command sets
unless/until it was clear that the kernel needed them for other
reasons, like rev-id determination.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
