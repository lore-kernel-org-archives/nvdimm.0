Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x230.google.com (mail-ot0-x230.google.com
 [IPv6:2607:f8b0:4003:c0f::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6441321967BCC
 for <linux-nvdimm@lists.01.org>; Wed,  7 Jun 2017 12:08:31 -0700 (PDT)
Received: by mail-ot0-x230.google.com with SMTP id a2so12101546oth.2
 for <linux-nvdimm@lists.01.org>; Wed, 07 Jun 2017 12:09:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170607184947.18733-1-toshi.kani@hpe.com>
References: <20170607184947.18733-1-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Jun 2017 12:09:38 -0700
Message-ID: <CAPcyv4i7bLU17QEmdUBQrtWP3AZxPRyKK0NN105XrTj8K3nAAQ@mail.gmail.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 7, 2017 at 11:49 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> ACPI 6.2 defines a new ACPI notification value to NVDIMM Root Device
> in Table 5-169.
>
>  0x81 Unconsumed Uncorrectable Memory Error Detected
>       Used to pro-actively notify OSPM of uncorrectable memory errors
>       detected (for example a memory scrubbing engine that continuously
>       scans the NVDIMMs memory). This is an optional notification. Only
>       locations that were mapped in to SPA by the platform will generate
>       a notification.
>
> Add support of this notification value by initiating an ARS scan. This
> will find new error locations and add their badblocks information.
>
> Link: http://www.uefi.org/sites/default/files/resources/ACPI_6_2.pdf
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/acpi/nfit/core.c |   28 ++++++++++++++++++++++------
>  drivers/acpi/nfit/nfit.h |    1 +
>  2 files changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 656acb5..cc22778 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -2967,7 +2967,7 @@ static int acpi_nfit_remove(struct acpi_device *adev)
>         return 0;
>  }
>
> -void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
> +static void acpi_nfit_update_notify(struct device *dev, acpi_handle handle)
>  {
>         struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
>         struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
> @@ -2975,11 +2975,6 @@ void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
>         acpi_status status;
>         int ret;
>
> -       dev_dbg(dev, "%s: event: %d\n", __func__, event);
> -
> -       if (event != NFIT_NOTIFY_UPDATE)
> -               return;
> -
>         if (!dev->driver) {
>                 /* dev->driver may be null if we're being removed */
>                 dev_dbg(dev, "%s: no driver found for dev\n", __func__);
> @@ -3016,6 +3011,27 @@ void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
>                 dev_err(dev, "Invalid _FIT\n");
>         kfree(buf.pointer);
>  }
> +
> +static void acpi_nfit_uc_error_notify(struct device *dev, acpi_handle handle)
> +{
> +       struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
> +
> +       acpi_nfit_ars_rescan(acpi_desc);

I wonder if we should gate re-scanning with a similar:

    if (acpi_desc->scrub_mode == HW_ERROR_SCRUB_ON)

...check that we do in the mce notification case? Maybe not since we
don't get an indication of where the error is without a rescan.
However, at a minimum I think we need support for the new Start ARS
flag ("If set to 1 the firmware shall return data from a previous
scrub, if any, without starting a new scrub") and use that for this
case.

Another thing that seems to be missing in both this and the mce case
is a notification to userspace that something changed. We have calls
to sysfs_notify_dirent() to notify scrub completion events and DIMM
health status change events, I think we need a similar notifier
mechanism for new un-correctable errors.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
