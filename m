Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 50CAE2194EB65
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 10:30:01 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id f22so97352335oib.2
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 10:30:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149218911796.3926.17292323458849061393.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149218909065.3926.1234846095650907678.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149218911796.3926.17292323458849061393.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 10:30:00 -0700
Message-ID: <CAPcyv4iKHVa0Ek-EkcsYHP6NUTowqdVY-jBkOjas0XS-Zm1n5g@mail.gmail.com>
Subject: Re: [PATCH 5/5] acpi,
 nfit: limit ->flush_probe() to initialization work
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 14, 2017 at 9:58 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> The nvdimm probe flushing mechanism gives userspace a sync point where
> it knows all asynchronous driver probe sequences have completed.
> However, it need not wait for other asynchronous actions, like
> on-demand address-range-scrub. Track the init work separately from other
> work in the workqueue, and only flush the former.
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit/core.c |   13 ++++++++++---
>  drivers/acpi/nfit/nfit.h |    1 +
>  2 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 06738df477db..17cac9d369e0 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -738,7 +738,7 @@ static void nfit_mem_init_bdw(struct acpi_nfit_desc *acpi_desc,
>         }
>  }
>
> -static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
> +static int __nfit_mem_init(struct acpi_nfit_desc *acpi_desc,
>                 struct acpi_nfit_system_address *spa)
>  {
>         struct nfit_mem *nfit_mem, *found;
> @@ -898,7 +898,7 @@ static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
>          * BDWs are optional.
>          */
>         list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
> -               rc = nfit_mem_dcr_init(acpi_desc, nfit_spa->spa);
> +               rc = __nfit_mem_init(acpi_desc, nfit_spa->spa);

Whoops, this function rename should have been folded into the previous patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
