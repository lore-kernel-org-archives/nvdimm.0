Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C17121A1DFA
 for <linux-nvdimm@lists.01.org>; Sun, 24 Jul 2016 07:55:54 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id w18so222222445oiw.3
 for <linux-nvdimm@lists.01.org>; Sun, 24 Jul 2016 07:55:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <146933800343.26196.11707211474975930425.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146933799257.26196.10157809349693736359.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146933800343.26196.11707211474975930425.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 24 Jul 2016 07:55:53 -0700
Message-ID: <CAPcyv4g=x52KnuSxgmAEt0NDqvTYntm=eqW_FJD67K1CyCge0g@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] nfit, libnvdimm: allow an ARS scrub to be
 triggered on demand
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

On Sat, Jul 23, 2016 at 10:26 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> From: Vishal Verma <vishal.l.verma@intel.com>
>
> Normally, an ARS (Address Range Scrub) only happens at
> boot/initialization time. There can however arise situations where a
> bus-wide rescan is needed - notably, in the case of discovering a latent
> media error, we should do a full rescan to figure out what other sectors
> are bad, and thus potentially avoid triggering an mce on them in the
> future. Also provide a sysfs trigger to start a bus-wide scrub.
>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit.c       |  167 +++++++++++++++++++++++++++++++++++++++++++--
>  drivers/acpi/nfit.h       |    4 +
>  drivers/nvdimm/core.c     |    7 ++
>  include/linux/libnvdimm.h |    1
>  4 files changed, 171 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index be7c2fde16e7..2eaa03dc185a 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
[..]
> @@ -2308,17 +2423,30 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
>         const void *end;
>         int rc;
>
> +       acpi_nfit_init_dsms(acpi_desc);
> +
>         if (!acpi_desc->nvdimm_bus) {
> +               acpi_nfit_init_dsms(acpi_desc);
> +
>                 acpi_desc->nvdimm_bus = nvdimm_bus_register(dev,
>                                 &acpi_desc->nd_desc);
>                 if (!acpi_desc->nvdimm_bus)
>                         return -ENOMEM;
> +
>                 rc = devm_add_action_or_reset(dev, acpi_nfit_destruct,
>                                 acpi_desc);
>                 if (rc)
>                         return rc;
> +
> +               rc = acpi_nfit_desc_init_scrub_attr(acpi_desc);
> +               if (rc)
> +                       return rc;
>         }
>
> +       rc = acpi_nfit_desc_init_scrub_attr(acpi_desc);
> +       if (rc)
> +               return rc;
> +

Whoops, rebase error.  I was moving acpi_nfit_init_dsms() and
acpi_nfit_desc_init_scrub_attr() to only run at the initial call to
acpi_nfit_init().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
