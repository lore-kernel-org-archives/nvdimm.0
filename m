Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x233.google.com (mail-qt0-x233.google.com
 [IPv6:2607:f8b0:400d:c0d::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1EA0D21A02936
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 15:04:38 -0700 (PDT)
Received: by mail-qt0-x233.google.com with SMTP id u12so39418537qth.0
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 15:05:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170608183658.24731-3-toshi.kani@hpe.com>
References: <20170608183658.24731-1-toshi.kani@hpe.com>
 <20170608183658.24731-3-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Jun 2017 15:05:28 -0700
Message-ID: <CAPcyv4j8vjw9arcNyHrszDNbX5xWzBOtTB5cS81rY9H_tJzhug@mail.gmail.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Thanks for this. I think it's going in the right direction, but one
comment below.

On Thu, Jun 8, 2017 at 11:36 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> ACPI 6.2 defines in section 9.20.7.2 that the OSPM may call a Start
> ARS with Flags Bit [1] set upon receiving the 0x81 notification.
>
>   Upon receiving the notification, the OSPM may decide to issue
>   a Start ARS with Flags Bit [1] set to prepare for the retrieval
>   of existing records and issue the Query ARS Status function to
>   retrieve the records.
>
> Add support to call a Start ARS from acpi_nfit_uc_error_notify()
> with ND_ARS_RETURN_PREV_DATA set when HW_ERROR_SCRUB_ON is not set.
>
> Link: http://www.uefi.org/sites/default/files/resources/ACPI_6_2.pdf
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Linda Knippers <linda.knippers@hpe.com>
> ---
>  drivers/acpi/nfit/core.c   |   14 +++++++++++---
>  drivers/acpi/nfit/mce.c    |    2 +-
>  drivers/acpi/nfit/nfit.h   |    3 ++-
>  include/uapi/linux/ndctl.h |    1 +
>  4 files changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index cc22778..d820d72 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1031,7 +1031,7 @@ static ssize_t scrub_store(struct device *dev,
>         if (nd_desc) {
>                 struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
>
> -               rc = acpi_nfit_ars_rescan(acpi_desc);
> +               rc = acpi_nfit_ars_rescan(acpi_desc, 0);
>         }
>         device_unlock(dev);
>         if (rc)
> @@ -2057,6 +2057,10 @@ static int ars_start(struct acpi_nfit_desc *acpi_desc, struct nfit_spa *nfit_spa
>                 ars_start.type = ND_ARS_VOLATILE;
>         else
>                 return -ENOTTY;
> +       if (nfit_spa->ars_prev_data) {
> +               ars_start.flags |= ND_ARS_RETURN_PREV_DATA;
> +               nfit_spa->ars_prev_data = 0;
> +       }

I'd rather you plumb a new 'flags' parameter all the way through from
acpi_nfit_ars_rescan() to ars_start() rather than carrying this as a
property of nfit_spa.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
