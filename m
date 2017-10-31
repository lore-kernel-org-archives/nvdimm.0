Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A144B21CEB131
 for <linux-nvdimm@lists.01.org>; Tue, 31 Oct 2017 14:38:10 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id q4so673671oic.7
 for <linux-nvdimm@lists.01.org>; Tue, 31 Oct 2017 14:42:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171031212725.GA22678@anatevka.americas.hpqcorp.net>
References: <150939641796.4577.379718469071595984.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150939642870.4577.1202379190708311186.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171031212725.GA22678@anatevka.americas.hpqcorp.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 31 Oct 2017 14:42:01 -0700
Message-ID: <CAPcyv4j7pvto7AvbzcmpgiYXHHm69LnGyWduRKP8qou947qqXA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] acpi, nfit: add support for NVDIMM_FAMILY_INTEL
 v1.6 DSMs
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
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 31, 2017 at 2:27 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Mon, Oct 30, 2017 at 01:47:08PM -0700, Dan Williams wrote:
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
>>  drivers/acpi/nfit/nfit.h |   26 +++++++++++++++++++++++++-
>>  2 files changed, 65 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>> index 444832b372ec..1b2c613a9d8b 100644
>> --- a/drivers/acpi/nfit/core.c
>> +++ b/drivers/acpi/nfit/core.c
>> @@ -370,6 +370,32 @@ static union acpi_object *acpi_label_info(acpi_handle handle)
>>       return pkg_to_buf(buf.pointer);
>>  }
>>
>> +static u8 nfit_dsm_revid(unsigned family, unsigned func)
>> +{
>> +     static const u8 revid_table[NVDIMM_FAMILY_MAX][32] = {
>> +             [NVDIMM_FAMILY_INTEL] = {
>> +                     [NVDIMM_INTEL_GET_MODES] = 2,
>> +                     [NVDIMM_INTEL_GET_FWINFO] = 2,
>> +                     [NVDIMM_INTEL_START_FWUPDATE] = 2,
>> +                     [NVDIMM_INTEL_SEND_FWUPDATE] = 2,
>> +                     [NVDIMM_INTEL_FINISH_FWUPDATE] = 2,
>> +                     [NVDIMM_INTEL_QUERY_FWUPDATE] = 2,
>> +                     [NVDIMM_INTEL_SET_THRESHOLD] = 2,
>> +                     [NVDIMM_INTEL_INJECT_ERROR] = 2,
>> +             },
>> +     };
>> +     u8 id;
>> +
>> +     if (family > NVDIMM_FAMILY_MAX)
>> +             return 0;
>> +     if (func > 31)
>> +             return 0;
>> +     id = revid_table[family][func];
>> +     if (id == 0)
>> +             return 1; /* default */
>> +     return id;
>> +}
>> +
>
>
> Elsewhere we find NVDIMM_FAMILY_MAX == NVDIMM_FAMILY_MSFT.
> Code is off by 1 in the dimension the array revid_table.

Nice catch, will fix.

At least the compiler will complain if we use c99 style initialization
for that NVDIMM_FAMILY_MAX index (error: array index in initializer
exceeds array bounds).

> This approach only ever calls revision ID 1 of a function that
> was initially defined in revision ID 1 of a spec.
>
> Is it required that FW returns same data for a given function if
> called with different revision IDs?  I.e. could firmware implement
> a function N such that it returns different information if called
> with revision ID 2 versus being called with revision ID 1?
> E.g. a field that is reserved in revision 1 could have a definition
> in revision 2.  My reading of the ACPI spec is this is acceptable.

Yes, this can happen. However, for the kernel implementation it can
decide to move to rev-id2 at its leisure since ACPI mandates that
rev-id1 implementations stick around, and if the function number was
reserved in rev-id1 the kernel will already not support it.

>
> Not sure if this makes a difference w/ the Intel FW or not, but
> some of the structures returns were modified from the earlier
> spec.  I have concerns that this approach can be correctly
> extended to other vendors.
>
[..]
>> +#define NVDIMM_FAMILY_MAX NVDIMM_FAMILY_MSFT
>
>
> Suggest this be defined immediately after where NVDIMM_FAMILY_MSFT
> is defined.  That way if a new family is ever defined, its more obvious
> that NVDIMM_FAMILY_MAX needs to be redefined as well.

These are currently defined in the userspace api header and that value
is not relevant to userspace since the kernel is free to support more
families than NVDIMM_FAMILY_MAX would imply. Also, if we as an
industry continue to add NVDIMM families something is broken with the
standardization process.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
