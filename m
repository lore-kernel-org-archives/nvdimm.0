Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B8A7921CF1D1E
 for <linux-nvdimm@lists.01.org>; Wed, 14 Feb 2018 12:28:55 -0800 (PST)
Received: by mail-oi0-x243.google.com with SMTP id 23so5417251oip.12
 for <linux-nvdimm@lists.01.org>; Wed, 14 Feb 2018 12:34:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151260081283.5641.2560511933614024819.stgit@djiang5-desk3.ch.intel.com>
References: <151260081283.5641.2560511933614024819.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Feb 2018 12:34:45 -0800
Message-ID: <CAPcyv4ikNu9ytP51fTXcSfAp33pj0L07MRP7QOhGCuPpgLHBpg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ndctl: add support to enable latch system shutdown
 status
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 6, 2017 at 2:53 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding the Enable Latch System Shutdown Status (Function Index 10) for
> DSM v1.6 spec.

Whoops, this got missed for ndctl-v59, some small comments so we can
get this moving for v60.

>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/lib/Makefile.am  |    1 +
>  ndctl/lib/intel.c      |   38 ++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/intel.h      |    7 +++++++
>  ndctl/lib/libndctl.sym |    2 ++
>  ndctl/lib/lss.c        |   43 +++++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/private.h    |    2 ++
>  6 files changed, 93 insertions(+)
>  create mode 100644 ndctl/lib/lss.c
>
> diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
> index e3a12e7..c1ea371 100644
> --- a/ndctl/lib/Makefile.am
> +++ b/ndctl/lib/Makefile.am
> @@ -22,6 +22,7 @@ libndctl_la_SOURCES =\
>         msft.c \
>         ars.c \
>         firmware.c \
> +       lss.c \

I don't think LSS deserves its own file. Let's just add this routines
to ndctl/lib/smart.c.

>         libndctl.c
>
>  libndctl_la_LIBADD =\
> diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
> index 6d26a6c..10a0881 100644
> --- a/ndctl/lib/intel.c
> +++ b/ndctl/lib/intel.c
> @@ -547,6 +547,42 @@ static unsigned long intel_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd)
>         return cmd->intel->fquery.updated_fw_rev;
>  }
>
> +static struct ndctl_cmd *
> +intel_dimm_cmd_new_lss_enable(struct ndctl_dimm *dimm)
> +{
> +       struct ndctl_cmd *cmd;
> +
> +       BUILD_ASSERT(sizeof(struct nd_intel_lss) == 5);
> +
> +       cmd = alloc_intel_cmd(dimm, ND_INTEL_ENABLE_LSS_STATUS, 1, 4);
> +       if (!cmd)
> +               return NULL;
> +
> +       cmd->firmware_status = &cmd->intel->lss.status;
> +       return cmd;
> +}
> +
> +static int intel_lss_set_valid(struct ndctl_cmd *cmd)
> +{
> +       struct nd_pkg_intel *pkg = cmd->intel;
> +
> +       if (cmd->type != ND_CMD_CALL || cmd->status != 1
> +                       || pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
> +                       || pkg->gen.nd_command != ND_INTEL_ENABLE_LSS_STATUS)
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static int
> +intel_cmd_lss_set_enable(struct ndctl_cmd *cmd, unsigned char enable)
> +{
> +       if (intel_lss_set_valid(cmd) < 0)
> +               return -EINVAL;
> +       cmd->intel->lss.enable = enable;
> +       return 0;
> +}
> +
> +
>  struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
>         .cmd_desc = intel_cmd_desc,
>         .new_smart = intel_dimm_cmd_new_smart,
> @@ -601,4 +637,6 @@ struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
>         .new_fw_finish_query = intel_dimm_cmd_new_fw_finish_query,
>         .fw_fquery_set_context = intel_cmd_fw_fquery_set_context,
>         .fw_fquery_get_fw_rev = intel_cmd_fw_fquery_get_fw_rev,
> +       .new_lss_enable = intel_dimm_cmd_new_lss_enable,
> +       .lss_set_enable = intel_cmd_lss_set_enable,
>  };
> diff --git a/ndctl/lib/intel.h b/ndctl/lib/intel.h
> index 080e37b..92bed53 100644
> --- a/ndctl/lib/intel.h
> +++ b/ndctl/lib/intel.h
> @@ -6,6 +6,7 @@
>  #define ND_INTEL_SMART 1
>  #define ND_INTEL_SMART_THRESHOLD 2
>
> +#define ND_INTEL_ENABLE_LSS_STATUS 10
>  #define ND_INTEL_FW_GET_INFO 12
>  #define ND_INTEL_FW_START_UPDATE 13
>  #define ND_INTEL_FW_SEND_DATA 14
> @@ -118,6 +119,11 @@ struct nd_intel_fw_finish_query {
>         __u64 updated_fw_rev;
>  } __attribute__((packed));
>
> +struct nd_intel_lss {
> +       __u8 enable;
> +       __u32 status;
> +} __attribute__((packed));
> +
>  struct nd_pkg_intel {
>         struct nd_cmd_pkg gen;
>         union {
> @@ -129,6 +135,7 @@ struct nd_pkg_intel {
>                 struct nd_intel_fw_send_data send;
>                 struct nd_intel_fw_finish_update finish;
>                 struct nd_intel_fw_finish_query fquery;
> +               struct nd_intel_lss lss;
>         };
>  };
>  #endif /* __INTEL_H__ */
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index 2e248ab..65673ad 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -344,4 +344,6 @@ global:
>         ndctl_cmd_fw_finish_set_ctrl_flags;
>         ndctl_cmd_fw_finish_set_context;
>         ndctl_cmd_fw_fquery_set_context;
> +       ndctl_dimm_cmd_new_lss_enable;
> +       ndctl_cmd_lss_set_enable;
>  } LIBNDCTL_13;
> diff --git a/ndctl/lib/lss.c b/ndctl/lib/lss.c
> new file mode 100644
> index 0000000..fbeeec5
> --- /dev/null
> +++ b/ndctl/lib/lss.c
> @@ -0,0 +1,43 @@
> +/*
> + * Copyright (c) 2017, Intel Corporation.
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
> +#include <limits.h>
> +#include <util/log.h>
> +#include <ndctl/libndctl.h>
> +#include "private.h"
> +
> +/*
> + * Define the wrappers around the ndctl_dimm_ops for LSS DSM
> + */
> +NDCTL_EXPORT struct ndctl_cmd *
> +ndctl_dimm_cmd_new_lss_enable(struct ndctl_dimm *dimm)
> +{
> +       struct ndctl_dimm_ops *ops = dimm->ops;
> +
> +       if (ops && ops->new_lss_enable)
> +               return ops->new_lss_enable(dimm);
> +       else
> +               return NULL;
> +}

The "LSS" acronym is Intel specific. Let's use a neutral name for
this. I propose _ack_shutdown_count() to go along with the
_{get,set}_shutdown count namespace.

> +
> +NDCTL_EXPORT int
> +ndctl_cmd_lss_set_enable(struct ndctl_cmd *cmd, unsigned char enable)
> +{
> +       if (cmd->dimm) {
> +               struct ndctl_dimm_ops *ops = cmd->dimm->ops;
> +
> +               if (ops && ops->lss_set_enable)
> +                       return ops->lss_set_enable(cmd, enable);
> +       }
> +       return -ENXIO;
> +}

Do we need this routine? Is there a use case for sending 0? In fact
the spec says, "All other values are reserved.", so I assume that
means sending 0 is invalid.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
