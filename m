Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x22a.google.com (mail-yb0-x22a.google.com
 [IPv6:2607:f8b0:4002:c09::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2149121CB74AF
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 14:24:54 -0700 (PDT)
Received: by mail-yb0-x22a.google.com with SMTP id s9so23110925ybe.3
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 14:26:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170617082218.8955-1-toshi.kani@hpe.com>
References: <20170617082218.8955-1-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jun 2017 14:26:24 -0700
Message-ID: <CAPcyv4i_cCPsurej1YDVgocTiuxzT0uKFYSg1Hzn40GQc0PJvQ@mail.gmail.com>
Subject: Re: [PATCH v3] acpi/nfit: Issue Start ARS to retrieve existing records
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

On Sat, Jun 17, 2017 at 1:22 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
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
> v3 (2/2): Add flags info to acpi_nfit_desc (Dan Williams)
> ---
>  drivers/acpi/nfit/core.c   |   11 ++++++++---
>  drivers/acpi/nfit/mce.c    |    2 +-
>  drivers/acpi/nfit/nfit.h   |    3 ++-
>  include/uapi/linux/ndctl.h |    1 +
>  4 files changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index cc22778..7e08ee0 100644
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
> @@ -2051,6 +2051,7 @@ static int ars_start(struct acpi_nfit_desc *acpi_desc, struct nfit_spa *nfit_spa
>         memset(&ars_start, 0, sizeof(ars_start));
>         ars_start.address = spa->address;
>         ars_start.length = spa->length;
> +       ars_start.flags = acpi_desc->ars_start_flags;

Hmm don't we also need a statement like this in ars_continue()?

>         if (nfit_spa_type(spa) == NFIT_SPA_PM)
>                 ars_start.type = ND_ARS_PERSISTENT;
>         else if (nfit_spa_type(spa) == NFIT_SPA_VOLATILE)
> @@ -2613,6 +2614,7 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
>                                 return rc;
>                 }
>
> +       acpi_desc->ars_start_flags = 0;

...and I would think the ND_ARS_RETURN_PREV_DATA context would only be
valid for the duration of the current scrub, so we should clear the
flags at the end of acpi_nfit_scrub().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
