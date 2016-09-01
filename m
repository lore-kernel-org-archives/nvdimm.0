Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E3871A1E74
 for <linux-nvdimm@lists.01.org>; Thu,  1 Sep 2016 12:46:23 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id c15so132269037oig.0
 for <linux-nvdimm@lists.01.org>; Thu, 01 Sep 2016 12:46:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <147198926249.3136.6163137762013359047.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147198925154.3136.14739108342311837939.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147198926249.3136.6163137762013359047.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 1 Sep 2016 12:46:21 -0700
Message-ID: <CAPcyv4ikttQ2zjo9QZ4bSW5inX4z9cKvpL8JfMr0ugQfwFB3Jg@mail.gmail.com>
Subject: Re: [PATCH 2/3] acpi, nfit: add dimm device notification support
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 23, 2016 at 2:54 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Per "ACPI 6.1 Section 9.20.3" NVDIMM devices, children of the ACPI0012
> NVDIMM Root device, can receive health event notifications.
>
> Given that these devices are precluded from registering a notification
> handler via acpi_driver.acpi_device_ops (due to no _HID), we use
> acpi_install_notify_handler() directly.  The registered handler,
> acpi_nvdimm_notify(), triggers a poll(2) event on the nmemX/nfit/flags
> sysfs attribute when a health event notification is received.
>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit/core.c   |   83 ++++++++++++++++++++++++++++++++++++++++++--
>  drivers/acpi/nfit/nfit.h   |    5 +++
>  drivers/nvdimm/dimm_devs.c |    6 +++
>  include/linux/libnvdimm.h  |    1 +
>  4 files changed, 91 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 8120e8218f93..65f155db4283 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
[..]
> @@ -2400,6 +2464,7 @@ static int acpi_nfit_desc_init_scrub_attr(struct acpi_nfit_desc *acpi_desc)
>
>  static void acpi_nfit_destruct(void *data)
>  {
> +       struct nfit_mem *nfit_mem;
>         struct acpi_nfit_desc *acpi_desc = data;
>         struct device *bus_dev = to_nvdimm_bus_dev(acpi_desc->nvdimm_bus);
>
> @@ -2415,6 +2480,16 @@ static void acpi_nfit_destruct(void *data)
>          * either submit or see ->cancel set.
>          */
>         device_lock(bus_dev);
> +       /*
> +        * Clear out the nfit_mem->flags_attr and shut down dimm event
> +        * notifications.
> +        */
> +       list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
> +               sysfs_put(nfit_mem->flags_attr);
> +               nfit_mem->flags_attr = NULL;

We need to check if flags_attr is NULL here in the case when the DIMM
failed to initialize.  I believe the crash I am hitting is fixed by
Toshi's patch https://patchwork.kernel.org/patch/9284427/, but I'll
still fix this up for other cases.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
