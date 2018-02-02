Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 67C222237A4D5
 for <linux-nvdimm@lists.01.org>; Fri,  2 Feb 2018 12:25:31 -0800 (PST)
Received: by mail-ot0-x241.google.com with SMTP id a7so18607065otk.9
 for <linux-nvdimm@lists.01.org>; Fri, 02 Feb 2018 12:31:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180202210036.3153-1-toshi.kani@hpe.com>
References: <20180202210036.3153-1-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Feb 2018 12:31:08 -0800
Message-ID: <CAPcyv4jPNxSKxb-kzaw8njhDHGUs7DOPASS_GBXbPGOFP4RN=g@mail.gmail.com>
Subject: Re: [PATCH] acpi, nfit: fix register dimm error handling
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 2, 2018 at 1:00 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> A NULL pointer reference kernel bug was observed when
> acpi_nfit_add_dimm() called in acpi_nfit_register_dimms()
> failed. This error path does not set nfit_mem->nvdimm, but
> the 2nd list_for_each_entry() loop in the function assumes
> it's always set. Add a check to nfit_mem->nvdimm.
>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> ---
>  drivers/acpi/nfit/core.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index abeb4df4f22e..b28ce440a06f 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1867,6 +1867,9 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>                 struct kernfs_node *nfit_kernfs;
>
>                 nvdimm = nfit_mem->nvdimm;
> +               if (!nvdimm)
> +                       continue;
> +
>                 nfit_kernfs = sysfs_get_dirent(nvdimm_kobj(nvdimm)->sd, "nfit");
>                 if (nfit_kernfs)
>                         nfit_mem->flags_attr = sysfs_get_dirent(nfit_kernfs,

Yes, I assume this also needs:

Cc: <stable@vger.kernel.org>
Fixes: ba9c8dd3c222 ("acpi, nfit: add dimm device notification support")
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
