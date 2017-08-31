Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5696421EB5280
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 21:30:04 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id k77so66751280oib.2
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 21:32:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170831102908.DA3B.E1E9C6FF@jp.fujitsu.com>
References: <20170831102101.DA2C.E1E9C6FF@jp.fujitsu.com>
 <20170831102908.DA3B.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 30 Aug 2017 21:32:13 -0700
Message-ID: <CAPcyv4g+CTp1Hr0RzBrF4xEOjMMqdHyu6NOq=DFwC+JRbt4u+A@mail.gmail.com>
Subject: Re: [ndctl PATCH 4/5] Make interfaces to use Translate SPA.
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Looks good in general...

Add "ndctl:" to the subject.

On Wed, Aug 30, 2017 at 6:29 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> This patch makes 2 new interfaces :
>   - Call translate SPA featture of ACPI 6.2.
>   - Find DIMM which SPA(System Physical Address) belongs to.
>
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> ---
>  ndctl/Makefile.am         |   1 +
>  ndctl/lib/Makefile.am     |   4 +-
>  ndctl/lib/libndctl-nfit.c | 147 ++++++++++++++++++++++++++++++++++++++++++++++

Rename this to ndctl/lib/nfit.c, I pushed out a large rename of other
files to drop the "libdctl-" prefix to the 'pending' branch on github.

>  ndctl/lib/libndctl-nfit.h |   5 ++
>  4 files changed, 156 insertions(+), 1 deletion(-)
>
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index d346c04..20d5f59 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -25,6 +25,7 @@ endif
>
>  ndctl_LDADD =\
>         lib/libndctl.la \
> +       lib/libndctl-nfit.la \

Let's just add these symbols to the existing libndctl.so rather than
add a new one.

>         ../daxctl/lib/libdaxctl.la \
>         ../libutil.a \
>         $(UUID_LIBS) \
> diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
> index 7a446be..cfa54ae 100644
> --- a/ndctl/lib/Makefile.am
> +++ b/ndctl/lib/Makefile.am
> @@ -8,7 +8,7 @@ BUILT_SOURCES = ../libndctl.h
>         $(SED_PROCESS)
>
>  pkginclude_HEADERS = ../libndctl.h
> -lib_LTLIBRARIES = libndctl.la
> +lib_LTLIBRARIES = libndctl.la libndctl-nfit.la
>
>  libndctl_la_SOURCES =\
>         libndctl.h \
> @@ -35,6 +35,8 @@ libndctl_la_SOURCES += libndctl-hpe1.c
>  libndctl_la_SOURCES += libndctl-msft.c
>  endif
>
> +libndctl_nfit_la_SOURCES = libndctl-nfit.c
> +
>  EXTRA_DIST += libndctl.sym
>
>  libndctl_la_LDFLAGS = $(AM_LDFLAGS) \
> diff --git a/ndctl/lib/libndctl-nfit.c b/ndctl/lib/libndctl-nfit.c
> new file mode 100644
> index 0000000..455815d
> --- /dev/null
> +++ b/ndctl/lib/libndctl-nfit.c
> @@ -0,0 +1,147 @@
> +/*
> + * Copyright (c) 2017, FUJITSU LIMITED. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU Lesser General Public License,
> + * version 2.1, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT ANY
> + * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
> + * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
> + * more details.
> + */
> +#include <stdlib.h>
> +#include <ndctl/libndctl.h>
> +#include "libndctl-private.h"
> +#include "libndctl-nfit.h"
> +
> +static int bus_has_translate_spa(struct ndctl_bus *bus)
> +{
> +       if (!ndctl_bus_has_nfit(bus))
> +               return 0;
> +
> +       return ndctl_bus_is_passthru_cmd_supported(bus, NFIT_CMD_TRANSLATE_SPA);
> +}
> +
> +static struct ndctl_cmd *ndctl_bus_cmd_new_translate_spa(struct ndctl_bus *bus)
> +{
> +       struct ndctl_cmd *cmd;
> +       struct nd_cmd_pkg *pkg;
> +       struct nd_cmd_translate_spa *translate_spa;
> +       size_t size, spa_length;
> +
> +       spa_length = sizeof(struct nd_cmd_translate_spa)
> +               + sizeof(struct nd_nvdimm_device);
> +       size = sizeof(*cmd) + sizeof(*pkg) + spa_length;
> +       cmd = calloc(1, size);
> +       if (!cmd)
> +               return NULL;
> +
> +       cmd->bus = bus;
> +       ndctl_cmd_ref(cmd);
> +       cmd->type = ND_CMD_CALL;
> +       cmd->size = size;
> +       cmd->status = 1;
> +       pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
> +       pkg->nd_command = NFIT_CMD_TRANSLATE_SPA;
> +       pkg->nd_size_in = sizeof(unsigned long long);
> +       pkg->nd_size_out = spa_length;
> +       pkg->nd_fw_size = spa_length;
> +       translate_spa = (struct nd_cmd_translate_spa *)&pkg->nd_payload[0];
> +       cmd->firmware_status = &translate_spa->status;
> +       translate_spa->translate_length = spa_length;
> +
> +       return cmd;
> +}
> +
> +static int ndctl_bus_cmd_get_translate_spa(struct ndctl_cmd *cmd,
> +                                       unsigned int *handle, unsigned long long *dpa)
> +{
> +       struct nd_cmd_pkg *pkg;
> +       struct nd_cmd_translate_spa *translate_spa;
> +
> +       pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
> +       translate_spa = (struct nd_cmd_translate_spa *)&pkg->nd_payload[0];
> +
> +       if (translate_spa->status == ND_TRANSLATE_SPA_STATUS_INVALID_SPA)
> +               return -EINVAL;
> +
> +       /*
> +        * XXX: Currently NVDIMM mirroring is not supported.
> +        * Even if ACPI returned plural dimms due to mirroring,
> +        * this function returns just the first dimm.
> +        */
> +
> +       *handle = translate_spa->devices[0].nfit_device_handle;
> +       *dpa = translate_spa->devices[0].dpa;
> +
> +       return 0;
> +}
> +
> +static int is_valid_spa(struct ndctl_bus *bus, unsigned long long spa)
> +{
> +       struct ndctl_region *region;
> +       unsigned long long region_start, region_end;
> +
> +       ndctl_region_foreach(bus, region) {
> +               region_start = ndctl_region_get_resource(region);
> +               region_end = region_start + ndctl_region_get_size(region);
> +               if (region_start <= spa && spa < region_end)
> +                       return 1;
> +       }
> +
> +       return 0;
> +}
> +
> +NDCTL_EXPORT int ndctl_bus_cmd_translate_spa(struct ndctl_bus *bus,
> +       unsigned long long addr, unsigned int *handle, unsigned long long *dpa)
> +{
> +
> +       struct ndctl_cmd *cmd;
> +       struct nd_cmd_pkg *pkg;
> +       struct nd_cmd_translate_spa *translate_spa;
> +       int rc;
> +
> +       if (!bus || !handle || !dpa)
> +               return -EINVAL;
> +
> +       if (!bus_has_translate_spa(bus))
> +               return -ENOTTY;
> +
> +       if (!is_valid_spa(bus, addr))
> +               return -EINVAL;
> +
> +       cmd = ndctl_bus_cmd_new_translate_spa(bus);
> +       if (!cmd)
> +               return -ENOMEM;
> +
> +       pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
> +       translate_spa = (struct nd_cmd_translate_spa *)&pkg->nd_payload[0];
> +       translate_spa->spa = addr;
> +
> +       rc = ndctl_cmd_submit(cmd);
> +       if (rc) {
> +               ndctl_cmd_unref(cmd);
> +               return rc;
> +       }
> +
> +       rc = ndctl_bus_cmd_get_translate_spa(cmd, handle, dpa);
> +       ndctl_cmd_unref(cmd);
> +
> +       return rc;
> +}
> +
> +NDCTL_EXPORT struct ndctl_dimm *ndctl_dimm_get_by_spa(struct ndctl_bus *bus,
> +               unsigned long long spa)
> +{
> +       int rc;
> +       unsigned int handle;
> +       unsigned long long dpa;
> +
> +       /* ndctl_bus_cmd_translate_spa() has sanity check */
> +       rc = ndctl_bus_cmd_translate_spa(bus, spa, &handle, &dpa);
> +       if (rc)
> +               return NULL;
> +
> +       return ndctl_dimm_get_by_handle(bus, handle);
> +}

Let's move this out of nfit.c and make it generic in libndctl.c

    ndctl_dimm_get_by_physical_address()

...where the common case of a single DIMM can be handled without
calling any DSMs. But if it is an interleave-set we can check for
ndctl_bus_has_nfit() before trying to call the nfit specific
ndctl_bus_nfit_cmd_translate_spa().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
