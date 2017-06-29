Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x236.google.com (mail-yb0-x236.google.com
 [IPv6:2607:f8b0:4002:c09::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7963E2095A6BB
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 14:14:45 -0700 (PDT)
Received: by mail-yb0-x236.google.com with SMTP id b81so32790385yba.2
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 14:16:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4dfd04a55324c2bdb6c9e8e65adf3cd8c0f324c9.1498754314.git.jerry.hoemann@hpe.com>
References: <cover.1498754314.git.jerry.hoemann@hpe.com>
 <4dfd04a55324c2bdb6c9e8e65adf3cd8c0f324c9.1498754314.git.jerry.hoemann@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 14:16:17 -0700
Message-ID: <CAPcyv4jDNB4+Z-T6L3hBErjp+N00pRWU3Axv0L_F+ahLr4LEpQ@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] acpi, nfit: override mask
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
To: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 29, 2017 at 9:56 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> Have module parameter override_dsm_mask override the dsm_mask for
> root calls like it does for non-root dsm calls.
>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---
>  drivers/acpi/nfit/core.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 7d2f1a0..87acaf2 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1627,6 +1627,7 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
>         struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
>         const u8 *uuid = to_nfit_uuid(NFIT_DEV_BUS);
>         struct acpi_device *adev;
> +       unsigned long dsm_mask;
>         int i;
>
>         nd_desc->cmd_mask = acpi_desc->bus_cmd_force_en;
> @@ -1638,7 +1639,11 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
>                 if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
>                         set_bit(i, &nd_desc->cmd_mask);
>         set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
> -       for (i = 0; i < ND_CMD_CALL; i++)
> +
> +       dsm_mask = 0x3bf;
> +       if (override_dsm_mask)
> +               dsm_mask = override_dsm_mask;
> +       for_each_set_bit(i, &dsm_mask, BITS_PER_LONG)
>                 if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
>                         set_bit(i, &nd_desc->bus_dsm_mask);
>  }

I don't think we need this patch. 'override_dsm_mask' is there to make
it easier for vendor-specific DSM testing and debug for DIMM-level
DSMs. The root bus is not vendor specific and the command set is not
evolving at the same rate we are seeing change at DIMM-level DSMs.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
