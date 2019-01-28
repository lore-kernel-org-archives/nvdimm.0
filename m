Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E237F210FBEE9
 for <linux-nvdimm@lists.01.org>; Mon, 28 Jan 2019 13:01:33 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id i20so15982391otl.0
 for <linux-nvdimm@lists.01.org>; Mon, 28 Jan 2019 13:01:33 -0800 (PST)
MIME-Version: 1.0
References: <PU1P153MB0169DF967C5BAAC8334FCC42BF990@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169DF967C5BAAC8334FCC42BF990@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 28 Jan 2019 13:01:19 -0800
Message-ID: <CAPcyv4gnpn9VBHBoSFn_2sAdvfD85wRffvfYfuurwMxXYSBAZQ@mail.gmail.com>
Subject: Re: [PATCH] nfit: add Hyper-V NVDIMM DSM command set to white list
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
To: Dexuan Cui <decui@microsoft.com>
Cc: Josh Poulson <jopoulso@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Haiyang Zhang <haiyangz@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Stephen Hemminger <sthemmin@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dexuan,

Looks good. Just one update request and a note below...

On Wed, Jan 23, 2019 at 12:51 PM Dexuan Cui <decui@microsoft.com> wrote:
>
>
> Add the Hyper-V _DSM command set to the white list of NVDIMM command
> sets.
>
> This command set is documented at http://www.uefi.org/RFIC_LIST
> (see the link to "Virtual NVDIMM 0x1901" on the page).
>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>
> I'm going to change the user-space utility "ndctl" to support Hyper-V Virtual NVDIMM.
> This kernel patch is required first.
>
>  drivers/acpi/nfit/core.c   | 5 ++++-
>  drivers/acpi/nfit/nfit.h   | 6 +++++-
>  include/uapi/linux/ndctl.h | 1 +
>  3 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 011d3db19c80..fb48cb17a519 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1840,7 +1840,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>         dev_set_drvdata(&adev_dimm->dev, nfit_mem);
>
>         /*
> -        * Until standardization materializes we need to consider 4
> +        * Until standardization materializes we need to consider 5
>          * different command sets.  Note, that checking for function0 (bit0)
>          * tells us if any commands are reachable through this GUID.
>          */

This comment is stale. This "HYPERV" family is the first example of
the "right" way to define a new NVDIMM command set. Lets update it to
mention the process and considerations for submitting new command sets
to UEFI (http://www.uefi.org/RFIC_LIST). The fact that there's now a
defined process is a step forward from when this comment was initially
written. Also, the fact that the process encourages "adopt" vs
"supersede" addresses the main concern about vendor-specific
command-set proliferation.

> @@ -1865,6 +1865,8 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>                         dsm_mask &= ~(1 << 8);
>         } else if (nfit_mem->family == NVDIMM_FAMILY_MSFT) {
>                 dsm_mask = 0xffffffff;
> +       } else if (nfit_mem->family == NVDIMM_FAMILY_HYPERV) {
> +               dsm_mask = 0x1f;

Just a note that starting with commit 5e9e38d0db1d "acpi/nfit: Block
function zero DSMs", bit0 in this mask will be cleared to ensure that
only the kernel has the ability to probe for supported DSM functions.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
