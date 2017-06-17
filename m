Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22b.google.com (mail-ot0-x22b.google.com
 [IPv6:2607:f8b0:4003:c0f::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CAFC521A07A94
 for <linux-nvdimm@lists.01.org>; Fri, 16 Jun 2017 17:08:46 -0700 (PDT)
Received: by mail-ot0-x22b.google.com with SMTP id u13so25641517otd.2
 for <linux-nvdimm@lists.01.org>; Fri, 16 Jun 2017 17:10:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DF4PR84MB01051FBBC0ADDFF41A9534F282C60@DF4PR84MB0105.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170608183658.24731-1-toshi.kani@hpe.com>
 <20170608183658.24731-3-toshi.kani@hpe.com>
 <CAPcyv4j8vjw9arcNyHrszDNbX5xWzBOtTB5cS81rY9H_tJzhug@mail.gmail.com>
 <DF4PR84MB01051FBBC0ADDFF41A9534F282C60@DF4PR84MB0105.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Jun 2017 17:10:03 -0700
Message-ID: <CAPcyv4h4bkkrb0_6C0DiNGb0=LYFxqm0QhN15BsS4uyO+mNcpw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] acpi/nfit: Issue Start ARS to retrieve existing
 records
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 16, 2017 at 5:01 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
>> > --- a/drivers/acpi/nfit/core.c
>> > +++ b/drivers/acpi/nfit/core.c
>> > @@ -1031,7 +1031,7 @@ static ssize_t scrub_store(struct device *dev,
>> >         if (nd_desc) {
>> >                 struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
>> >
>> > -               rc = acpi_nfit_ars_rescan(acpi_desc);
>> > +               rc = acpi_nfit_ars_rescan(acpi_desc, 0);
>> >         }
>> >         device_unlock(dev);
>> >         if (rc)
>> > @@ -2057,6 +2057,10 @@ static int ars_start(struct acpi_nfit_desc
>> *acpi_desc, struct nfit_spa *nfit_spa
>> >                 ars_start.type = ND_ARS_VOLATILE;
>> >         else
>> >                 return -ENOTTY;
>> > +       if (nfit_spa->ars_prev_data) {
>> > +               ars_start.flags |= ND_ARS_RETURN_PREV_DATA;
>> > +               nfit_spa->ars_prev_data = 0;
>> > +       }
>>
>> I'd rather you plumb a new 'flags' parameter all the way through from
>> acpi_nfit_ars_rescan() to ars_start() rather than carrying this as a
>> property of nfit_spa.
>
> Yes, I wanted to carry 'flags' all the way, but since acpi_nfit_ars_rescan()
> calls acpi_nfit_scrub() via acpi_desc->work, all info needs to be marshalled
> into struct acpi_nfit_desc.  Using nfit_spa allows a request to be carried as
> per-spa basis...

Ah ok, but I still think it does not belong to a spa. This is control
/ context information for the workqueue and that belongs with
acpi_nfit_desc. It think it's fine if all spas get re-scrubbed with
the "prev_data" flag in the the notification case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
