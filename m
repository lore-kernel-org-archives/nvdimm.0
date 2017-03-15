Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x233.google.com (mail-ot0-x233.google.com
 [IPv6:2607:f8b0:4003:c0f::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8DCAF803D5
 for <linux-nvdimm@lists.01.org>; Wed, 15 Mar 2017 00:09:59 -0700 (PDT)
Received: by mail-ot0-x233.google.com with SMTP id 19so9115156oti.0
 for <linux-nvdimm@lists.01.org>; Wed, 15 Mar 2017 00:09:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <148892081379.46486.4526071392091548993.stgit@djiang5-desk3.ch.intel.com>
References: <148892068983.46486.5008198419806159468.stgit@djiang5-desk3.ch.intel.com>
 <148892081379.46486.4526071392091548993.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 Mar 2017 00:09:58 -0700
Message-ID: <CAPcyv4hYZFtM3zdxJkGu2nNSsQAZxXjAgy-NXd4BP=iT38_o9w@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] acpi_nfit, libnvdimm: Add support for clear poison
 list and bad blocks
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 7, 2017 at 1:06 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Providing mechanism to clear poison list via the ndctl ND_CMD_CLEAR_ERROR
> call. We will update the poison list and also the badblocks at region level
> if the region is in dax mode or in pmem mode and not active.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/acpi/nfit/core.c         |   63 ++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/nfit/nfit.h         |    2 +
>  drivers/nvdimm/bus.c             |   55 +++++++++++++++++++++++++++++----
>  drivers/nvdimm/core.c            |   17 ++++++++--
>  drivers/nvdimm/region.c          |    9 +++++
>  include/linux/libnvdimm.h        |    6 +++-
>  tools/testing/nvdimm/test/nfit.c |   23 ++++++++------
>  7 files changed, 154 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index e7b05df..97bc2bf 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -94,6 +94,63 @@ static struct acpi_device *to_acpi_dev(struct acpi_nfit_desc *acpi_desc)
>         return to_acpi_device(acpi_desc->dev);
>  }
>
> +int acpi_nfit_forget_poison(struct nvdimm_bus_descriptor *nd_desc,
> +               unsigned int cmd, void *buf)
> +{
> +       struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
> +       struct nvdimm_bus *nvdimm_bus = acpi_desc->nvdimm_bus;
> +       struct nfit_spa *nfit_spa;
> +       struct nd_cmd_clear_error *clear_err = buf;
> +       int found_match = 0;
> +
> +       if ((cmd != ND_CMD_CLEAR_ERROR) || !nvdimm_bus || !clear_err->cleared)
> +               return 0;

I think we need to move part of this check out to the caller because
you don't have enough information here to differentiate bus commands
from dimm commands. That "cmd != ND_CMD_CLEAR_ERROR" check fails if
the command is ND_CMD_GET_CONFIG_SIZE on a DIMM device.

[..]
> @@ -353,6 +410,12 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>         }
>
>         xlat_rc = xlat_status(nvdimm, buf, cmd, fw_status);
> +       if (xlat_rc >= 0) {

I think we should make this:

    if (nvdimm == NULL && cmd == ND_CMD_CLEAR_ERROR && xlat_rc >= 0)

> +               xlat_rc = acpi_nfit_forget_poison(nd_desc, cmd, buf);

We shouldn't be messing with the status return for the clear error
command that needs to go unmodified back to the caller.

> +               if (xlat_rc)
> +                       dev_err(dev, "%s:%s %s unable to forget poison\n",
> +                                       __func__, dimm_name, cmd_name);

I think this can just be ignored. The acpi_nfit_forget_poison()
routine should just be marked void since the only error it knows how
to return was "no error was found to clear". That's only worth a debug
statement not an error return.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
