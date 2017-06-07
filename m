Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x230.google.com (mail-ot0-x230.google.com
 [IPv6:2607:f8b0:4003:c0f::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 773F921959CD3
 for <linux-nvdimm@lists.01.org>; Wed,  7 Jun 2017 14:05:24 -0700 (PDT)
Received: by mail-ot0-x230.google.com with SMTP id k4so13656853otd.0
 for <linux-nvdimm@lists.01.org>; Wed, 07 Jun 2017 14:06:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1496869051.9288.1.camel@hpe.com>
References: <20170607184947.18733-1-toshi.kani@hpe.com>
 <CAPcyv4i7bLU17QEmdUBQrtWP3AZxPRyKK0NN105XrTj8K3nAAQ@mail.gmail.com>
 <1496869051.9288.1.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Jun 2017 14:06:31 -0700
Message-ID: <CAPcyv4hwhRc6+JW8m3zVn_tKz__wE9BHOfpjy69RS6OwiqV-PA@mail.gmail.com>
Subject: Re: [PATCH] Add support of NVDIMM memory error notification in ACPI
 6.2
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 7, 2017 at 1:57 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Wed, 2017-06-07 at 12:09 -0700, Dan Williams wrote:
>> On Wed, Jun 7, 2017 at 11:49 AM, Toshi Kani <toshi.kani@hpe.com>
>> wrote:
>  :
>> > +
>> > +static void acpi_nfit_uc_error_notify(struct device *dev,
>> > acpi_handle handle)
>> > +{
>> > +       struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
>> > +
>> > +       acpi_nfit_ars_rescan(acpi_desc);
>>
>> I wonder if we should gate re-scanning with a similar:
>>
>>     if (acpi_desc->scrub_mode == HW_ERROR_SCRUB_ON)
>>
>> ...check that we do in the mce notification case? Maybe not since we
>> don't get an indication of where the error is without a rescan.
>
> I think this mce case is different since the MCE handler already knows
> where the new poison location is and can update badblocks information
> for it.  Starting ARS is an optional precaution.
>
>> However, at a minimum I think we need support for the new Start ARS
>> flag ("If set to 1 the firmware shall return data from a previous
>> scrub, if any, without starting a new scrub") and use that for this
>> case.
>
> That's an interesting idea.  But I wonder how users know if it is OK to
> set this flag as it relies on BIOS implementation that is not described
> in ACPI...

Ugh, you're right. We might need a revision-id=2 version of Start ARS
so software knows that the BIOS is aware of the new flag.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
