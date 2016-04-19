Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x22c.google.com (mail-ob0-x22c.google.com
 [IPv6:2607:f8b0:4003:c01::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 11E9C1A2097
 for <linux-nvdimm@lists.01.org>; Mon, 18 Apr 2016 20:03:15 -0700 (PDT)
Received: by mail-ob0-x22c.google.com with SMTP id bg3so1771935obb.1
 for <linux-nvdimm@lists.01.org>; Mon, 18 Apr 2016 20:03:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f94e58ce44103ee3990e611ddb4e63269e278de3.1460936121.git.jerry.hoemann@hpe.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <f94e58ce44103ee3990e611ddb4e63269e278de3.1460936121.git.jerry.hoemann@hpe.com>
Date: Mon, 18 Apr 2016 20:03:14 -0700
Message-ID: <CAPcyv4hgAqdUV8mB1mr-B1mcHTjTYLtdRdRLXYmZjWx=1f7YDg@mail.gmail.com>
Subject: Re: [RFC v9 4/5] nvdimm: Add concept of cmd mask
From: Dan Williams <dan.j.williams@intel.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Apr 17, 2016 at 4:38 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> DSMs have a mask of commands implemented on the DSM.
>
> The current IOCTL interface exported for the NVDIMM DSM maps directly
> onto the underlying DSM.
>
> With the addition of the pass thru mechanism, the IOCTL doesn't map
> directly onto the underlying DSM functions as the Pass thru isn't itself
> a DSM function and some DSM can use only the pass thru.
>
> These changes separate out the concept of a command mask that applies
> to function that are supported by the IOCTL and a dsm mask that apply
> to the underlying firmware.
>
> There is one noticiable exception, the cmd_mask == the dsm_mask
> for root functions.
>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---
>  drivers/acpi/nfit.c        | 26 ++++++++++++++++++++++----
>  drivers/acpi/nfit.h        |  1 +
>  drivers/nvdimm/bus.c       | 10 ++++------
>  drivers/nvdimm/dimm_devs.c | 12 ++++++------
>  drivers/nvdimm/nd-core.h   |  2 +-
>  include/linux/libnvdimm.h  |  2 +-
>  6 files changed, 35 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index e3ff10b..fc3e7d9 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -60,6 +60,7 @@ struct cmd_family_tbl {
>         enum nfit_uuids key_uuid;       /* Internal handle              */
>         int             key_type;       /* Exported handle              */
>         int             rev;            /* _DSM rev                     */
> +       int             does_ioctls;    /* Family supports all commands? */
>  };
>
>  /*
> @@ -68,9 +69,9 @@ struct cmd_family_tbl {
>  #define ND_MAX_CMD     20
>
>  struct cmd_family_tbl nfit_cmd_family_tbl[] = {
> -       { NFIT_DEV_DIMM,        ND_TYPE_DIMM_INTEL1,    1},
> -       { NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,    1},
> -       { NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,    1},
> +       { NFIT_DEV_DIMM,        ND_TYPE_DIMM_INTEL1,    1, 1},
> +       { NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,    1, 0},
> +       { NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,    1, 0},

Lets replace does_ioctl with a mask of the valid function numbers see below...

>         { -1, -1, -1},
>  };
>
> @@ -996,6 +997,19 @@ static int determine_uuid(acpi_handle handle, struct cmd_family_tbl *tbl,
>         return 0;
>  }
>
> +static int determine_cmd_mask(struct cmd_family_tbl *tbl, u8 const *cmd_uuid)
> +{
> +       int i;
> +
> +       for (i = 0;  tbl[i].key_uuid >= 0 ; i++) {
> +               const u8 *uuid = to_nfit_uuid(tbl[i].key_uuid);
> +
> +               if (memcmp(uuid, cmd_uuid, 16) == 0)
> +                       return tbl[i].does_ioctls;
> +       }
> +       return 0;
> +}
> +
>
>  static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>                 struct nfit_mem *nfit_mem, u32 device_handle)
> @@ -1027,6 +1041,10 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>                 if (acpi_check_dsm(adev_dimm->handle, uuid, 1, 1ULL << i))
>                         set_bit(i, &nfit_mem->dsm_mask);

Now that there is no longer a 1:1 relationship with the commands the
kernel knows and the DSM functions reported via acpi_check_dsm(), I
want the kernel to mask off unknown function numbers in dsm_mask.  At
a minimum we should be doing input validation on the publicly
documented commands.

> +       nfit_mem->cmd_mask = (1 << ND_CMD_CALL);
> +       if (determine_cmd_mask(nfit_cmd_family_tbl, uuid))
> +               nfit_mem->cmd_mask |= nfit_mem->dsm_mask;
> +

For now just have an open coded if ND_TYPE_DIMM_INTEL1 cmd_mask ==
dsm_mask.  Later I do want to have a translation routine to convert
something like ND_TYPE_DIMM_N_HPE1 Function 2 (Get SMART) output into
the ND_CMD_SMART format.  Its ridiculous that we have two commands
that do slightly different things.


The "ndctl list --dimms --health" utility doesn't want to care about
vendor specific differences.  However given that ND_TYPE_DIMM_N_HPE1
Function 2 output appears to be a super set of ND_CMD_SMART, I might
deprecate ND_CMD_SMART and develop a new common SMART output format
and have translation of the Intel data into that common superset
format.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
