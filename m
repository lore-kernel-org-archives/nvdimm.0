Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x233.google.com (mail-ob0-x233.google.com
 [IPv6:2607:f8b0:4003:c01::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B84211A1E93
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 17:04:25 -0700 (PDT)
Received: by mail-ob0-x233.google.com with SMTP id bg3so63520554obb.1
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 17:04:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461974599.11211.6.camel@kernel.org>
References: <5723EFEE.9060200@hpe.com>
	<1461974599.11211.6.camel@kernel.org>
Date: Fri, 29 Apr 2016 17:04:24 -0700
Message-ID: <CAPcyv4hK2m+6HTHCWkgLEanTwwa9jQ2a+jrbx3UrtrMAs1LrAg@mail.gmail.com>
Subject: Re: acpi_nfit_query_poison() broken on non-ARS systems
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
To: Vishal Verma <vishal@kernel.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 29, 2016 at 5:03 PM, Vishal Verma <vishal@kernel.org> wrote:
> On Fri, 2016-04-29 at 19:36 -0400, Linda Knippers wrote:
>
> [snip]
>>
>> > static int acpi_nfit_query_poison(struct acpi_nfit_desc *acpi_desc,
>> >                 struct nfit_spa *nfit_spa)
>> > {
>> >         struct acpi_nfit_system_address *spa = nfit_spa->spa;
>> >         int rc;
>> >
>> >         if (!nfit_spa->max_ars) {
>> On a platform that doesn't support ARS, max_ars will always be zero
>> so you'll keep executing this code when it seems like you're trying
>> to avoid that.
>>
>> >
>> >                 struct nd_cmd_ars_cap ars_cap;
>> >
>> >                 memset(&ars_cap, 0, sizeof(ars_cap));
>> >                 rc = ars_get_cap(acpi_desc, &ars_cap, nfit_spa);
>> >                 if (rc < 0)
>> >                         return rc;
>> The call succeeds so this return isn't taken, but then the code
>> assumes
>> everything is good.  It should check ars_cap.status so see if the
>> function
>> is supported or if there was an error and return something
>> appropriate.
>> In previous version of the code, that's what acpi_nfit_find_poison()
>> did.
>> Instead, this function continues, using data that's not right and
>> making
>> more calls that also aren't supported.
>
> Good point - I think we should add a check here and make sure ARS is
> supported using the status field. I can work on a patch. Thanks for the
> report!

...but we do, or are supposed to, fail on any non-zero status:

                /* Command failed */
                if (ars_cap->status & 0xffff)
                        return -EIO;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
