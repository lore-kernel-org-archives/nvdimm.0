Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 046F621EA15B0
 for <linux-nvdimm@lists.01.org>; Fri,  6 Oct 2017 11:48:50 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id c77so29052251oig.0
 for <linux-nvdimm@lists.01.org>; Fri, 06 Oct 2017 11:52:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171006015340.29722-2-vishal.l.verma@intel.com>
References: <20171006015340.29722-1-vishal.l.verma@intel.com>
 <20171006015340.29722-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Oct 2017 11:52:13 -0700
Message-ID: <CAPcyv4i=sNRwWHbDh0fgSEixn1G0R5UwgCa8HBfNuWyDyC7s8w@mail.gmail.com>
Subject: Re: [PATCH 1/4] libnvdimm: move poison list functions to a new
 'badrange' file
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 5, 2017 at 6:53 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> From: Dave Jiang <dave.jiang@intel.com>
>
> From: Dave Jiang <dave.jiang@intel.com>
>
> nfit_test needs to use the poison list manipulation code as well. Make
> it more generic and in the process rename poison to badrange, and move
> all the related helpers to a new file.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> [vishal: add a missed include in bus.c for the new badrange functions]
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/acpi/nfit/core.c  |   2 +-
>  drivers/acpi/nfit/mce.c   |   2 +-
>  drivers/nvdimm/Makefile   |   1 +
>  drivers/nvdimm/badrange.c | 294 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/bus.c      |  24 ++--
>  drivers/nvdimm/core.c     | 260 +---------------------------------------
>  drivers/nvdimm/nd-core.h  |   3 +-
>  drivers/nvdimm/nd.h       |   6 -
>  include/linux/libnvdimm.h |  21 +++-
>  9 files changed, 331 insertions(+), 282 deletions(-)
>  create mode 100644 drivers/nvdimm/badrange.c
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index a3ecd5e..4b157f8 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -2240,7 +2240,7 @@ static int ars_status_process_records(struct acpi_nfit_desc *acpi_desc,
>                 if (ars_status->out_length
>                                 < 44 + sizeof(struct nd_ars_record) * (i + 1))
>                         break;
> -               rc = nvdimm_bus_add_poison(nvdimm_bus,
> +               rc = nvdimm_bus_add_badrange(nvdimm_bus,
>                                 ars_status->records[i].err_address,
>                                 ars_status->records[i].length);
>                 if (rc)
> diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
> index feeb95d..b929214 100644
> --- a/drivers/acpi/nfit/mce.c
> +++ b/drivers/acpi/nfit/mce.c
> @@ -67,7 +67,7 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
>                         continue;
>
>                 /* If this fails due to an -ENOMEM, there is little we can do */
> -               nvdimm_bus_add_poison(acpi_desc->nvdimm_bus,
> +               nvdimm_bus_add_badrange(acpi_desc->nvdimm_bus,
>                                 ALIGN(mce->addr, L1_CACHE_BYTES),
>                                 L1_CACHE_BYTES);
>                 nvdimm_region_notify(nfit_spa->nd_region,
> diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
> index 909554c..ca6d325 100644
> --- a/drivers/nvdimm/Makefile
> +++ b/drivers/nvdimm/Makefile
> @@ -20,6 +20,7 @@ libnvdimm-y += region_devs.o
>  libnvdimm-y += region.o
>  libnvdimm-y += namespace_devs.o
>  libnvdimm-y += label.o
> +libnvdimm-y += badrange.o
>  libnvdimm-$(CONFIG_ND_CLAIM) += claim.o
>  libnvdimm-$(CONFIG_BTT) += btt_devs.o
>  libnvdimm-$(CONFIG_NVDIMM_PFN) += pfn_devs.o
> diff --git a/drivers/nvdimm/badrange.c b/drivers/nvdimm/badrange.c
> new file mode 100644
> index 0000000..6ad782f
> --- /dev/null
> +++ b/drivers/nvdimm/badrange.c
> @@ -0,0 +1,294 @@
> +/*
> + * Copyright(c) 2017 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +#include <linux/libnvdimm.h>
> +#include <linux/badblocks.h>
> +#include <linux/export.h>
> +#include <linux/module.h>
> +#include <linux/blkdev.h>
> +#include <linux/device.h>
> +#include <linux/ctype.h>
> +#include <linux/ndctl.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include "nd-core.h"
> +#include "nd.h"
> +
> +void badrange_init(struct badrange *badrange)
> +{
> +       INIT_LIST_HEAD(&badrange->list);
> +       spin_lock_init(&badrange->lock);
> +}
> +EXPORT_SYMBOL_GPL(badrange_init);
> +
> +static void append_badrange_entry(struct badrange *badrange,
> +               struct badrange_entry *be, u64 addr, u64 length)
> +{
> +       lockdep_assert_held(&badrange->lock);
> +       be->start = addr;
> +       be->length = length;
> +       list_add_tail(&be->list, &badrange->list);
> +}

Small nit, can we rename the instance variable from 'be' to 'bre'?
'be' triggers all my 'big endian' neurons to fire. Other than that,
looks good.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
