Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22c.google.com (mail-yw0-x22c.google.com
 [IPv6:2607:f8b0:4002:c05::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6EA5021B02B93
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 20:53:49 -0700 (PDT)
Received: by mail-yw0-x22c.google.com with SMTP id a12so7642267ywh.3
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 20:55:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <293ee143dcabb386ca06b384a384171c256a2ecc.1498810220.git.jerry.hoemann@hpe.com>
References: <cover.1498810220.git.jerry.hoemann@hpe.com>
 <293ee143dcabb386ca06b384a384171c256a2ecc.1498810220.git.jerry.hoemann@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Jun 2017 20:55:22 -0700
Message-ID: <CAPcyv4gcpmmr9LdX3DBtdX_ncwoBmCdC7yVPpGdO6EP7N9NOKw@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] libnvdimm, acpi, nfit: Add bus level dsm mask for
 pass thru.
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

On Fri, Jun 30, 2017 at 9:09 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> Add a bus level dsm_mask to nvdimm_bus_descriptor to allow the passthru
> calling mechanism to specify a different mask from the cmd_mask.
>
> Populate bus_dsm_mask and use it to filter dsm calls that user can
> make through the pass thru interface.
>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---
>  drivers/acpi/nfit/core.c  | 8 ++++++++
>  include/linux/libnvdimm.h | 1 +
>  2 files changed, 9 insertions(+)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index b46fca2..5e4c137 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -253,6 +253,8 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>                 cmd_name = nvdimm_bus_cmd_name(cmd);
>                 cmd_mask = nd_desc->cmd_mask;
>                 dsm_mask = cmd_mask;
> +               if (cmd == ND_CMD_CALL)
> +                       dsm_mask = nd_desc->bus_dsm_mask;
>                 desc = nd_cmd_bus_desc(cmd);
>                 uuid = to_nfit_uuid(NFIT_DEV_BUS);
>                 handle = adev->handle;
> @@ -1613,6 +1615,7 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
>         struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
>         const u8 *uuid = to_nfit_uuid(NFIT_DEV_BUS);
>         struct acpi_device *adev;
> +       unsigned long dsm_mask;
>         int i;
>
>         nd_desc->cmd_mask = acpi_desc->bus_cmd_force_en;
> @@ -1624,6 +1627,11 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
>                 if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
>                         set_bit(i, &nd_desc->cmd_mask);
>         set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
> +
> +       dsm_mask = 0x3bf;

I went ahead and fixed this up to use dsm_mask defined like this:

+       dsm_mask =
+               (1 << ND_CMD_ARS_CAP) |
+               (1 << ND_CMD_ARS_START) |
+               (1 << ND_CMD_ARS_STATUS) |
+               (1 << ND_CMD_CLEAR_ERROR) |
+               (1 << NFIT_CMD_TRANSLATE_SPA) |
+               (1 << NFIT_CMD_ARS_INJECT_SET) |
+               (1 << NFIT_CMD_ARS_INJECT_CLEAR) |
+               (1 << NFIT_CMD_ARS_INJECT_GET);

This drops function number 0 which userspace has no need to call.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
