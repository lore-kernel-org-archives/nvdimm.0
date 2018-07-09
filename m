Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 52198202E53F3
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jul 2018 15:52:55 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id s198-v6so39004458oih.11
 for <linux-nvdimm@lists.01.org>; Mon, 09 Jul 2018 15:52:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153082215300.61422.9908891437665310082.stgit@djiang5-desk3.ch.intel.com>
References: <153082172527.61422.13689320279597181069.stgit@djiang5-desk3.ch.intel.com>
 <153082215300.61422.9908891437665310082.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 9 Jul 2018 15:52:53 -0700
Message-ID: <CAPcyv4i8mb9vd3=yK67X=FxBV7raQieJC+eNJrp8gOK+sniTtw@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] nfit/libnvdimm: adding unlock of nvdimm support
 for Intel DIMMs
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
Cc: David Howells <dhowells@redhat.com>, "Schofield, Alison  <alison.schofield@intel.com>, keyrings@vger.kernel.org, Kees Cook" <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 5, 2018 at 1:22 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding support to allow query the security status of the Intel nvdimms and
> also unlock the dimm via the kernel key management APIs. The passphrase is
> expected to be pulled from userspace through keyutils. Moving the Intel
> related bits to its own source file as well.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/acpi/nfit/Makefile |    2 -
>  drivers/acpi/nfit/core.c   |   11 +++
>  drivers/acpi/nfit/intel.c  |  146 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/nfit/intel.h  |    2 +
>  drivers/nvdimm/dimm.c      |    7 ++
>  drivers/nvdimm/dimm_devs.c |  108 ++++++++++++++++++++++++++++++++-
>  drivers/nvdimm/nd-core.h   |    2 +
>  drivers/nvdimm/nd.h        |    2 +
>  include/linux/libnvdimm.h  |   23 +++++++
>  9 files changed, 299 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/acpi/nfit/intel.c
>
> diff --git a/drivers/acpi/nfit/Makefile b/drivers/acpi/nfit/Makefile
> index a407e769f103..8287005f9226 100644
> --- a/drivers/acpi/nfit/Makefile
> +++ b/drivers/acpi/nfit/Makefile
> @@ -1,3 +1,3 @@
>  obj-$(CONFIG_ACPI_NFIT) := nfit.o
> -nfit-y := core.o
> +nfit-y := core.o intel.o

See below, this needs to be

nfit-$(CONFIG_X86) += intel.o

>  nfit-$(CONFIG_X86_MCE) += mce.o
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index d474d53473fe..8304ad6fcea4 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1838,6 +1838,14 @@ static int acpi_nfit_get_dimm_id(struct acpi_nfit_control_region *dcr,
>                                 be32_to_cpu(dcr->serial_number));
>  }
>
> +static struct nvdimm_security_ops *acpi_nfit_get_security_ops(int family)
> +{
> +       if (family == NVDIMM_FAMILY_INTEL)
> +               return &intel_security_ops;
> +       else
> +               return NULL;
> +}
> +
>  static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>  {
>         struct nfit_mem *nfit_mem;
> @@ -1908,7 +1916,8 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>                 nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
>                                 acpi_nfit_dimm_attribute_groups,
>                                 flags, cmd_mask, flush ? flush->hint_count : 0,
> -                               nfit_mem->flush_wpq, nfit_mem->id);
> +                               nfit_mem->flush_wpq, nfit_mem->id,
> +                               acpi_nfit_get_security_ops(nfit_mem->family));
>                 if (!nvdimm)
>                         return -ENOMEM;
>
> diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
> new file mode 100644
> index 000000000000..c1140f6901da
> --- /dev/null
> +++ b/drivers/acpi/nfit/intel.c
> @@ -0,0 +1,146 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
> +/*
> + * Intel specific NFIT ops
> + */
> +#include <linux/libnvdimm.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/ndctl.h>
> +#include <linux/sysfs.h>
> +#include <linux/delay.h>
> +#include <linux/acpi.h>
> +#include <linux/io.h>
> +#include <linux/nd.h>
> +#include <asm/cacheflush.h>
> +#include <acpi/nfit.h>
> +#include "intel.h"
> +#include "nfit.h"
> +
> +static int intel_dimm_security_unlock(struct nvdimm_bus *nvdimm_bus,
> +               struct nvdimm *nvdimm, struct nvdimm_key_data *nkey)
> +{
> +       struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
> +       int cmd_rc, rc = 0;
> +       struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> +       struct {
> +               struct nd_cmd_pkg pkg;
> +               struct nd_intel_unlock_unit cmd;
> +       } nd_cmd = {
> +               .pkg = {
> +                       .nd_command = NVDIMM_INTEL_UNLOCK_UNIT,
> +                       .nd_family = NVDIMM_FAMILY_INTEL,
> +                       .nd_size_in = ND_INTEL_PASSPHRASE_SIZE,
> +                       .nd_size_out = ND_INTEL_STATUS_SIZE,
> +                       .nd_fw_size = ND_INTEL_STATUS_SIZE,
> +               },
> +               .cmd = {
> +                       .status = 0,
> +               },
> +       };
> +
> +       if (!test_bit(NVDIMM_INTEL_UNLOCK_UNIT, &nfit_mem->dsm_mask))
> +               return -ENOTTY;
> +
> +       memcpy(nd_cmd.cmd.passphrase, nkey->data, ND_INTEL_PASSPHRASE_SIZE);
> +       rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
> +                       sizeof(nd_cmd), &cmd_rc);
> +       if (rc < 0)
> +               goto out;
> +       if (cmd_rc < 0) {
> +               rc = cmd_rc;
> +               goto out;
> +       }
> +
> +       switch (nd_cmd.cmd.status) {
> +       case 0:
> +               break;
> +       case ND_INTEL_STATUS_INVALID_PASS:
> +               rc = -EINVAL;
> +               goto out;
> +       case ND_INTEL_STATUS_INVALID_STATE:
> +       default:
> +               rc = -ENXIO;
> +               goto out;
> +       }
> +
> +       /* DIMM unlocked, invalidate all CPU caches before we read it */
> +       wbinvd();

This needs to be run on all cpus, there's a helper for that
wbinvd_on_all_cpus().

However that is x86 specific, so this file needs a "depends on X86"
compilation dependency.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
