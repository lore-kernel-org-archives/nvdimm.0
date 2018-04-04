Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3142C224A9EBF
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 10:08:27 -0700 (PDT)
Received: by mail-ot0-x243.google.com with SMTP id 23-v6so24152061otj.0
 for <linux-nvdimm@lists.01.org>; Wed, 04 Apr 2018 10:08:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1522859143.2693.296.camel@hpe.com>
References: <152273076087.38372.4803377088477706610.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152273078779.38372.13062348829183334140.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1522859143.2693.296.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 4 Apr 2018 10:08:26 -0700
Message-ID: <CAPcyv4iKKDWnVoDJ8j=kF7gpcp+APkxBu9VW=5SShCRLYaa6tw@mail.gmail.com>
Subject: Re: [PATCH 5/6] nfit, address-range-scrub: rework and simplify ARS
 state machine
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
To: "Kani, Toshi" <toshi.kani@hpe.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 4, 2018 at 9:26 AM, Kani, Toshi <toshi.kani@hpe.com> wrote:
> On Mon, 2018-04-02 at 21:46 -0700, Dan Williams wrote:
>  :
>> +static int init_ars(struct acpi_nfit_desc *acpi_desc, struct nfit_spa *nfit_spa,
>> +int query_rc)
>>  {
>> -struct acpi_nfit_system_address *spa = nfit_spa->spa;
>> -unsigned int overflow_retry = scrub_overflow_abort;
>> -u64 init_ars_start = 0, init_ars_len = 0;
>> -struct device *dev = acpi_desc->dev;
>> -unsigned int tmo = scrub_timeout;
>>  int rc;
>>
>> -if (!test_bit(ARS_REQ, &nfit_spa->ars_state) || !nfit_spa->nd_region)
>> -return;
>> +switch (query_rc) {
>> +case 0:
>> +/* ARS is idle, lets look for critical known errors... */
>> +break;
>> +case -EBUSY:
>> +/*
>> + * ARS is already running, some agent thought it was ok
>> + * to busy ARS before handing off to the nfit driver.
>> + */
>> +clear_bit(ARS_SHORT, &nfit_spa->ars_state);
>> +rc = query_rc;
>> +goto out;
>> +case -ENOSPC:
>> +/* ARS continuation needed... */
>> +clear_bit(ARS_SHORT, &nfit_spa->ars_state);
>> +rc = query_rc;
>> +goto out;
>> +default:
>> +rc = query_rc;
>> +goto out;
>> +}
>>
>> +WARN_ON_ONCE(!test_bit(ARS_SHORT, &nfit_spa->ars_state));
>
> I am hitting this WARN_ON_ONCE.  I think there is an issue in the code
> flow that ars_complete() clears ARS_SHORT before init_ars().
>
>   acpi_nfit_scrub
>     acpi_nfit_query_poison
>       ars_status_process_records
>          ars_complete
>     init_ars

Yes, I think we are inadvertently double completing operations. I have
a new version that adds an ARS_DONE flag to make sure we are only
completing ARS once.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
