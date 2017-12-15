Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 579E422137D80
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 09:34:29 -0800 (PST)
Received: by mail-oi0-x243.google.com with SMTP id x20so6662938oix.12
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 09:39:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151260042014.3630.10551056737314097045.stgit@djiang5-desk3.ch.intel.com>
References: <151260039600.3630.12960859289293301854.stgit@djiang5-desk3.ch.intel.com>
 <151260042014.3630.10551056737314097045.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Dec 2017 09:39:09 -0800
Message-ID: <CAPcyv4hYN9Dx+wTZyxEp9NuzQMtLpev11-zGGDFCPHwLTM6i2Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ndctl: add firmware download support functions in
 libndctl
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

On Wed, Dec 6, 2017 at 2:47 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding the DSM commands from Intel DSM v1.6 to support firmware update
> sequence in the libndctl library as additional dimm_ops.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Some more type clarifications and api fixups to make sure this
approach/functionality can be reused for other DIMMs.

> ---
>
> v2:
> Sync'd return types per Dan's comment and removed __uN types.
>
>
>  0 files changed
>
> diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
> index 5e10fde..e3a12e7 100644
> --- a/ndctl/lib/Makefile.am
> +++ b/ndctl/lib/Makefile.am
> @@ -21,6 +21,7 @@ libndctl_la_SOURCES =\
>         hpe1.c \
>         msft.c \
>         ars.c \
> +       firmware.c \
>         libndctl.c
>
>  libndctl_la_LIBADD =\
> diff --git a/ndctl/lib/firmware.c b/ndctl/lib/firmware.c
> new file mode 100644
> index 0000000..3ec89b7
> --- /dev/null
> +++ b/ndctl/lib/firmware.c
> @@ -0,0 +1,128 @@
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
> + * Define the wrappers around the ndctl_dimm_ops for firmware update:
> + */
> +NDCTL_EXPORT struct ndctl_cmd *
> +ndctl_dimm_cmd_new_fw_get_info(struct ndctl_dimm *dimm)
> +{
> +       struct ndctl_dimm_ops *ops = dimm->ops;
> +
> +       if (ops && ops->new_fw_get_info)
> +               return ops->new_fw_get_info(dimm);
> +       else
> +               return NULL;
> +}
> +
> +NDCTL_EXPORT struct ndctl_cmd *
> +ndctl_dimm_cmd_new_fw_start_update(struct ndctl_dimm *dimm)
> +{
> +       struct ndctl_dimm_ops *ops = dimm->ops;
> +
> +       if (ops && ops->new_fw_start_update)
> +               return ops->new_fw_start_update(dimm);
> +       else
> +               return NULL;
> +}
> +
> +NDCTL_EXPORT struct ndctl_cmd *
> +ndctl_dimm_cmd_new_fw_send(struct ndctl_dimm *dimm, unsigned int chunk_size)
> +{
> +       struct ndctl_dimm_ops *ops = dimm->ops;
> +
> +       if (ops && ops->new_fw_send)
> +               return ops->new_fw_send(dimm, chunk_size);
> +       else
> +               return NULL;
> +}
> +
> +NDCTL_EXPORT struct ndctl_cmd *
> +ndctl_dimm_cmd_new_fw_finish(struct ndctl_dimm *dimm)
> +{
> +       struct ndctl_dimm_ops *ops = dimm->ops;
> +
> +       if (ops && ops->new_fw_finish)
> +               return ops->new_fw_finish(dimm);
> +       else
> +               return NULL;
> +}
> +
> +NDCTL_EXPORT struct ndctl_cmd *
> +ndctl_dimm_cmd_new_fw_finish_query(struct ndctl_dimm *dimm)
> +{
> +       struct ndctl_dimm_ops *ops = dimm->ops;
> +
> +       if (ops && ops->new_fw_finish_query)
> +               return ops->new_fw_finish_query(dimm);
> +       else
> +               return NULL;
> +}
> +
> +
> +#define firmware_cmd_op(op, rettype, defretvalue) \
> +NDCTL_EXPORT rettype ndctl_cmd_##op(struct ndctl_cmd *cmd) \
> +{ \
> +       if (cmd->dimm) { \
> +               struct ndctl_dimm_ops *ops = cmd->dimm->ops; \
> +               if (ops && ops->op) \
> +                       return ops->op(cmd); \
> +       } \
> +       return defretvalue; \
> +}
> +
> +firmware_cmd_op(fw_info_get_storage_size, unsigned int, 0)
> +firmware_cmd_op(fw_info_get_max_send_len, unsigned int, 0)
> +firmware_cmd_op(fw_info_get_query_interval, unsigned int, 0)
> +firmware_cmd_op(fw_info_get_max_query_time, unsigned int, 0)
> +firmware_cmd_op(fw_info_get_fis_version, unsigned int, 0)
> +firmware_cmd_op(fw_info_get_run_version, unsigned long, 0)
> +firmware_cmd_op(fw_info_get_updated_version, unsigned long, 0)
> +firmware_cmd_op(fw_info_get_update_cap, unsigned char, 0)
> +firmware_cmd_op(fw_start_get_context, unsigned int, 0)
> +firmware_cmd_op(fw_fquery_get_fw_rev, unsigned long, 0)

The 64-bit ones should be using "unsigned long long" as the return value.

> +
> +#define firmware_cmd_set_op(op, intype) \
> +NDCTL_EXPORT int ndctl_cmd_##op(struct ndctl_cmd *cmd, intype val) \
> +{ \
> +       if (cmd->dimm) { \
> +               struct ndctl_dimm_ops *ops = cmd->dimm->ops; \
> +               if (ops && ops->op) \
> +                       return ops->op(cmd, val); \
> +       } \
> +       return -ENXIO; \
> +}
> +
> +firmware_cmd_set_op(fw_send_set_context, unsigned int)
> +firmware_cmd_set_op(fw_send_set_offset, unsigned int)
> +firmware_cmd_set_op(fw_send_set_length, unsigned int)
> +firmware_cmd_set_op(fw_finish_set_ctrl_flags, unsigned char)
> +firmware_cmd_set_op(fw_finish_set_context, unsigned int)
> +firmware_cmd_set_op(fw_fquery_set_context, unsigned int)
> +
> +NDCTL_EXPORT int
> +ndctl_cmd_fw_send_set_data(struct ndctl_cmd *cmd, void *buf, size_t len)
> +{
> +       if (cmd->dimm) {
> +               struct ndctl_dimm_ops *ops = cmd->dimm->ops;
> +               if (ops && ops->fw_send_set_data)
> +                       return ops->fw_send_set_data(cmd, buf, len);
> +       }
> +       return -ENXIO;
> +}
> +
> diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
> index b85a682..3ac4d3b 100644
> --- a/ndctl/lib/intel.c
> +++ b/ndctl/lib/intel.c
> @@ -288,6 +288,11 @@ static const char *intel_cmd_desc(int fn)
>         static const char *descs[] = {
>                 [ND_INTEL_SMART] = "smart",
>                 [ND_INTEL_SMART_THRESHOLD] = "smart_thresh",
> +               [ND_INTEL_FW_GET_INFO] = "firmware_get_info",
> +               [ND_INTEL_FW_START_UPDATE] = "firmware_start_update",
> +               [ND_INTEL_FW_SEND_DATA] = "firmware_send_data",
> +               [ND_INTEL_FW_FINISH_UPDATE] = "firmware_finish_update",
> +               [ND_INTEL_FW_FINISH_STATUS_QUERY] = "firmware_finish_query",
>                 [ND_INTEL_SMART_SET_THRESHOLD] = "smart_set_thresh",
>         };
>         const char *desc = descs[fn];
> @@ -299,6 +304,238 @@ static const char *intel_cmd_desc(int fn)
>         return desc;
>  }
>
> +static struct ndctl_cmd *intel_dimm_cmd_new_fw_get_info(struct ndctl_dimm *dimm)
> +{
> +       struct ndctl_cmd *cmd;
> +
> +       BUILD_ASSERT(sizeof(struct nd_intel_fw_info) == 44);
> +
> +       cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_GET_INFO,
> +                       0, sizeof(cmd->intel->info));
> +       if (!cmd)
> +               return NULL;
> +
> +       cmd->firmware_status = &cmd->intel->info.status;
> +       return cmd;
> +}
> +
> +static int intel_fw_get_info_valid(struct ndctl_cmd *cmd)
> +{
> +       struct nd_pkg_intel *pkg = cmd->intel;
> +
> +       if (cmd->type != ND_CMD_CALL || cmd->status != 1
> +                       || pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
> +                       || pkg->gen.nd_command != ND_INTEL_FW_GET_INFO)
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +#define intel_fw_info_get_field32(cmd, field) \
> +static unsigned int intel_cmd_fw_info_get_##field( \
> +                       struct ndctl_cmd *cmd) \
> +{ \
> +       if (intel_fw_get_info_valid(cmd) < 0) \
> +               return -EINVAL; \
> +       return cmd->intel->info.field; \

This should be returning UINT_MAX in the error case.

> +}
> +
> +#define intel_fw_info_get_field64(cmd, field) \
> +static unsigned long intel_cmd_fw_info_get_##field( \

Return unsigned long long.

> +                       struct ndctl_cmd *cmd) \
> +{ \
> +       if (intel_fw_get_info_valid(cmd) < 0) \
> +               return -EINVAL; \
> +       return cmd->intel->info.field; \
> +}

Return ULLONG_MAX in the error case.

> +
> +static unsigned char intel_cmd_fw_info_get_update_cap(struct ndctl_cmd *cmd)

just make this unsigned int

> +{
> +       if (intel_fw_get_info_valid(cmd) < 0)
> +               return -EINVAL;

UINT_MAX

> +       return cmd->intel->info.update_cap;
> +}
> +
> +intel_fw_info_get_field32(cmd, storage_size)
> +intel_fw_info_get_field32(cmd, max_send_len)
> +intel_fw_info_get_field32(cmd, query_interval)
> +intel_fw_info_get_field32(cmd, max_query_time);
> +intel_fw_info_get_field32(cmd, fis_version);
> +intel_fw_info_get_field64(cmd, run_version);
> +intel_fw_info_get_field64(cmd, updated_version);
> +
> +static struct ndctl_cmd *intel_dimm_cmd_new_fw_start(struct ndctl_dimm *dimm)
> +{
> +       struct ndctl_cmd *cmd;
> +
> +       BUILD_ASSERT(sizeof(struct nd_intel_fw_start) == 8);
> +
> +       cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_START_UPDATE,
> +                       sizeof(cmd->intel->start) - 4, 4);
> +       if (!cmd)
> +               return NULL;
> +
> +       cmd->firmware_status = &cmd->intel->start.status;
> +       return cmd;
> +}
> +
> +static int intel_fw_start_valid(struct ndctl_cmd *cmd)
> +{
> +       struct nd_pkg_intel *pkg = cmd->intel;
> +
> +       if (cmd->type != ND_CMD_CALL || cmd->status != 1
> +                       || pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
> +                       || pkg->gen.nd_command != ND_INTEL_FW_START_UPDATE)
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static unsigned int intel_cmd_fw_start_get_context(struct ndctl_cmd *cmd)
> +{
> +       if (intel_fw_start_valid(cmd) < 0)
> +               return -EINVAL;

UINT_MAX

> +       return cmd->intel->start.context;
> +}
> +
> +static struct ndctl_cmd *intel_dimm_cmd_new_fw_send(struct ndctl_dimm *dimm,
> +               unsigned int chunk_size)
> +{
> +       struct ndctl_cmd *cmd;
> +
> +       BUILD_ASSERT(sizeof(struct nd_intel_fw_send_data) == 12);
> +
> +       cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_SEND_DATA,
> +               sizeof(cmd->intel->send) + chunk_size, 4);
> +       if (!cmd)
> +               return NULL;
> +
> +       /* the last dword is reserved for status */
> +       cmd->firmware_status =
> +               (unsigned int *)(&cmd->intel->send.data[0] + chunk_size);
> +       return cmd;
> +}
> +
> +static int intel_fw_send_valid(struct ndctl_cmd *cmd)
> +{
> +       struct nd_pkg_intel *pkg = cmd->intel;
> +
> +       if (cmd->type != ND_CMD_CALL || cmd->status != 1
> +                       || pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
> +                       || pkg->gen.nd_command != ND_INTEL_FW_SEND_DATA)
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +#define intel_fw_send_set_field(field) \
> +static int intel_cmd_fw_send_set_##field(struct ndctl_cmd *cmd, unsigned int val) \
> +{ \
> +       if (intel_fw_send_valid(cmd) < 0) \
> +               return -EINVAL; \
> +       cmd->intel->send.field = val; \
> +       return 0; \
> +}
> +
> +intel_fw_send_set_field(context)
> +intel_fw_send_set_field(offset)
> +intel_fw_send_set_field(length)
> +
> +static int
> +intel_cmd_fw_send_set_data(struct ndctl_cmd *cmd, void *buf, size_t len)
> +{
> +       if (intel_fw_send_valid(cmd) < 0)
> +               return -EINVAL;
> +
> +       memcpy(cmd->intel->send.data, buf, len);
> +       return 0;
> +}
> +
> +static struct ndctl_cmd *intel_dimm_cmd_new_fw_finish(struct ndctl_dimm *dimm)
> +{
> +       struct ndctl_cmd *cmd;
> +
> +       BUILD_ASSERT(sizeof(struct nd_intel_fw_finish_update) == 12);
> +
> +       cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_FINISH_UPDATE,
> +                       sizeof(cmd->intel->finish) - 4, 4);
> +       if (!cmd)
> +               return NULL;
> +
> +       cmd->firmware_status = &cmd->intel->finish.status;
> +       return cmd;
> +}
> +
> +static int intel_fw_finish_valid(struct ndctl_cmd *cmd)
> +{
> +       struct nd_pkg_intel *pkg = cmd->intel;
> +
> +       if (cmd->type != ND_CMD_CALL || cmd->status != 1
> +                       || pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
> +                       || pkg->gen.nd_command != ND_INTEL_FW_FINISH_UPDATE)
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static int
> +intel_cmd_fw_finish_set_ctrl_flags(struct ndctl_cmd *cmd, unsigned char ctrl)
> +{
> +       if (intel_fw_finish_valid(cmd) < 0)
> +               return -EINVAL;
> +       cmd->intel->finish.ctrl_flags = ctrl;
> +       return 0;
> +}
> +
> +static int
> +intel_cmd_fw_finish_set_context(struct ndctl_cmd *cmd, unsigned int context)
> +{
> +       if (intel_fw_finish_valid(cmd) < 0)
> +               return -EINVAL;
> +       cmd->intel->finish.context = context;
> +       return 0;
> +}
> +
> +static struct ndctl_cmd *
> +intel_dimm_cmd_new_fw_finish_query(struct ndctl_dimm *dimm)
> +{
> +       struct ndctl_cmd *cmd;
> +
> +       BUILD_ASSERT(sizeof(struct nd_intel_fw_finish_update) == 12);
> +
> +       cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_FINISH_UPDATE,
> +                       4, sizeof(cmd->intel->fquery) - 4);
> +       if (!cmd)
> +               return NULL;
> +
> +       cmd->firmware_status = &cmd->intel->finish.status;
> +       return cmd;
> +
> +}
> +
> +static int intel_fw_fquery_valid(struct ndctl_cmd *cmd)
> +{
> +       struct nd_pkg_intel *pkg = cmd->intel;
> +
> +       if (cmd->type != ND_CMD_CALL || cmd->status != 1
> +                       || pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
> +                       || pkg->gen.nd_command != ND_INTEL_FW_FINISH_UPDATE)
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static int
> +intel_cmd_fw_fquery_set_context(struct ndctl_cmd *cmd, unsigned int context)
> +{
> +       if (intel_fw_fquery_valid(cmd) < 0)
> +               return -EINVAL;
> +       cmd->intel->fquery.context = context;
> +       return 0;
> +}
> +
> +static unsigned long intel_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd)

Is this another 64-bit field? If so, should be unsigned long long

> +{
> +       if (intel_fw_start_valid(cmd) < 0)
> +               return -EINVAL;

...and ULLONG_MAX if it's 64-bit

> +       return cmd->intel->fquery.updated_fw_rev;
> +}
> +
>  struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
>         .cmd_desc = intel_cmd_desc,
>         .new_smart = intel_dimm_cmd_new_smart,
> @@ -331,4 +568,26 @@ struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
>         .smart_threshold_set_ctrl_temperature
>                 = intel_cmd_smart_threshold_set_ctrl_temperature,
>         .smart_threshold_set_spares = intel_cmd_smart_threshold_set_spares,
> +       .new_fw_get_info = intel_dimm_cmd_new_fw_get_info,
> +       .fw_info_get_storage_size = intel_cmd_fw_info_get_storage_size,
> +       .fw_info_get_max_send_len = intel_cmd_fw_info_get_max_send_len,
> +       .fw_info_get_query_interval = intel_cmd_fw_info_get_query_interval,
> +       .fw_info_get_max_query_time = intel_cmd_fw_info_get_max_query_time,
> +       .fw_info_get_update_cap = intel_cmd_fw_info_get_update_cap,
> +       .fw_info_get_fis_version = intel_cmd_fw_info_get_fis_version,
> +       .fw_info_get_run_version = intel_cmd_fw_info_get_run_version,
> +       .fw_info_get_updated_version = intel_cmd_fw_info_get_updated_version,
> +       .new_fw_start_update = intel_dimm_cmd_new_fw_start,
> +       .fw_start_get_context = intel_cmd_fw_start_get_context,
> +       .new_fw_send = intel_dimm_cmd_new_fw_send,
> +       .fw_send_set_context = intel_cmd_fw_send_set_context,
> +       .fw_send_set_offset = intel_cmd_fw_send_set_offset,
> +       .fw_send_set_length = intel_cmd_fw_send_set_length,
> +       .fw_send_set_data = intel_cmd_fw_send_set_data,
> +       .new_fw_finish = intel_dimm_cmd_new_fw_finish,
> +       .fw_finish_set_ctrl_flags = intel_cmd_fw_finish_set_ctrl_flags,
> +       .fw_finish_set_context = intel_cmd_fw_finish_set_context,
> +       .new_fw_finish_query = intel_dimm_cmd_new_fw_finish_query,
> +       .fw_fquery_set_context = intel_cmd_fw_fquery_set_context,
> +       .fw_fquery_get_fw_rev = intel_cmd_fw_fquery_get_fw_rev,
>  };
> diff --git a/ndctl/lib/intel.h b/ndctl/lib/intel.h
> index 9e63985..080e37b 100644
> --- a/ndctl/lib/intel.h
> +++ b/ndctl/lib/intel.h
> @@ -5,6 +5,12 @@
>  #define __INTEL_H__
>  #define ND_INTEL_SMART 1
>  #define ND_INTEL_SMART_THRESHOLD 2
> +
> +#define ND_INTEL_FW_GET_INFO 12
> +#define ND_INTEL_FW_START_UPDATE 13
> +#define ND_INTEL_FW_SEND_DATA 14
> +#define ND_INTEL_FW_FINISH_UPDATE 15
> +#define ND_INTEL_FW_FINISH_STATUS_QUERY 16
>  #define ND_INTEL_SMART_SET_THRESHOLD 17
>
>  #define ND_INTEL_SMART_HEALTH_VALID             (1 << 0)
> @@ -71,12 +77,58 @@ struct nd_intel_smart_set_threshold {
>         __u32 status;
>  } __attribute__((packed));
>
> +struct nd_intel_fw_info {
> +       __u32 status;
> +       __u32 storage_size;
> +       __u32 max_send_len;
> +       __u32 query_interval;
> +       __u32 max_query_time;
> +       __u8 update_cap;
> +       __u8 reserved[3];
> +       __u32 fis_version;
> +       __u64 run_version;
> +       __u64 updated_version;
> +} __attribute__((packed));
> +
> +struct nd_intel_fw_start {
> +       __u32 status;
> +       __u32 context;
> +} __attribute__((packed));
> +
> +/* this one has the output first because the variable input data size */
> +struct nd_intel_fw_send_data {
> +       __u32 context;
> +       __u32 offset;
> +       __u32 length;
> +       __u8 data[0];
> +/* reserving last 4 bytes as status */
> +/*     __u32 status; */
> +} __attribute__((packed));
> +
> +struct nd_intel_fw_finish_update {
> +       __u8 ctrl_flags;
> +       __u8 reserved[3];
> +       __u32 context;
> +       __u32 status;
> +} __attribute__((packed));
> +
> +struct nd_intel_fw_finish_query {
> +       __u32 context;
> +       __u32 status;
> +       __u64 updated_fw_rev;
> +} __attribute__((packed));
> +
>  struct nd_pkg_intel {
>         struct nd_cmd_pkg gen;
>         union {
>                 struct nd_intel_smart smart;
>                 struct nd_intel_smart_threshold thresh;
>                 struct nd_intel_smart_set_threshold set_thresh;
> +               struct nd_intel_fw_info info;
> +               struct nd_intel_fw_start start;
> +               struct nd_intel_fw_send_data send;
> +               struct nd_intel_fw_finish_update finish;
> +               struct nd_intel_fw_finish_query fquery;
>         };
>  };
>  #endif /* __INTEL_H__ */
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index 2ace942..2e248ab 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -322,4 +322,26 @@ global:
>         ndctl_cmd_smart_threshold_set_ctrl_temperature;
>         ndctl_cmd_smart_threshold_set_spares;
>         ndctl_decode_smart_temperature;
> +       ndctl_dimm_cmd_new_fw_get_info;
> +       ndctl_dimm_cmd_new_fw_start_update;
> +       ndctl_dimm_cmd_new_fw_send;
> +       ndctl_dimm_cmd_new_fw_finish;
> +       ndctl_dimm_cmd_new_fw_finish_query;
> +       ndctl_cmd_fw_info_get_storage_size;
> +       ndctl_cmd_fw_info_get_max_send_len;
> +       ndctl_cmd_fw_info_get_query_interval;
> +       ndctl_cmd_fw_info_get_max_query_time;
> +       ndctl_cmd_fw_info_get_run_version;
> +       ndctl_cmd_fw_info_get_fis_version;
> +       ndctl_cmd_fw_info_get_updated_version;
> +       ndctl_cmd_fw_info_get_update_cap;
> +       ndctl_cmd_fw_start_get_context;
> +       ndctl_cmd_fw_fquery_get_fw_rev;
> +       ndctl_cmd_fw_send_set_context;
> +       ndctl_cmd_fw_send_set_offset;
> +       ndctl_cmd_fw_send_set_length;
> +       ndctl_cmd_fw_send_set_data;
> +       ndctl_cmd_fw_finish_set_ctrl_flags;
> +       ndctl_cmd_fw_finish_set_context;
> +       ndctl_cmd_fw_fquery_set_context;
>  } LIBNDCTL_13;
> diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
> index 6726097..20f9e6e 100644
> --- a/ndctl/lib/private.h
> +++ b/ndctl/lib/private.h
> @@ -303,6 +303,28 @@ struct ndctl_dimm_ops {
>         int (*smart_threshold_set_media_temperature)(struct ndctl_cmd *, unsigned int);
>         int (*smart_threshold_set_ctrl_temperature)(struct ndctl_cmd *, unsigned int);
>         int (*smart_threshold_set_spares)(struct ndctl_cmd *, unsigned int);
> +       struct ndctl_cmd *(*new_fw_get_info)(struct ndctl_dimm *);
> +       unsigned int (*fw_info_get_storage_size)(struct ndctl_cmd *);
> +       unsigned int (*fw_info_get_max_send_len)(struct ndctl_cmd *);
> +       unsigned int (*fw_info_get_query_interval)(struct ndctl_cmd *);
> +       unsigned int (*fw_info_get_max_query_time)(struct ndctl_cmd *);
> +       unsigned char (*fw_info_get_update_cap)(struct ndctl_cmd *);
> +       unsigned int (*fw_info_get_fis_version)(struct ndctl_cmd *);
> +       unsigned long (*fw_info_get_run_version)(struct ndctl_cmd *);
> +       unsigned long (*fw_info_get_updated_version)(struct ndctl_cmd *);
> +       struct ndctl_cmd *(*new_fw_start_update)(struct ndctl_dimm *);
> +       unsigned int (*fw_start_get_context)(struct ndctl_cmd *);
> +       struct ndctl_cmd *(*new_fw_send)(struct ndctl_dimm *, unsigned int chunk_size);
> +       int (*fw_send_set_context)(struct ndctl_cmd *, unsigned int context);
> +       int (*fw_send_set_offset)(struct ndctl_cmd *, unsigned int offset);
> +       int (*fw_send_set_length)(struct ndctl_cmd *, unsigned int len);
> +       int (*fw_send_set_data)(struct ndctl_cmd *, void *buf, size_t len);
> +       struct ndctl_cmd *(*new_fw_finish)(struct ndctl_dimm *);
> +       int (*fw_finish_set_ctrl_flags)(struct ndctl_cmd *, unsigned char flags);
> +       int (*fw_finish_set_context)(struct ndctl_cmd *, unsigned int context);
> +       struct ndctl_cmd *(*new_fw_finish_query)(struct ndctl_dimm *);
> +       int (*fw_fquery_set_context)(struct ndctl_cmd *, unsigned int context);
> +       unsigned long (*fw_fquery_get_fw_rev)(struct ndctl_cmd *);
>  };
>
>  struct ndctl_dimm_ops * const intel_dimm_ops;
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index e9da20e..64a4e99 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -15,6 +15,7 @@
>
>  #include <stdbool.h>
>  #include <stdarg.h>
> +#include <stdint.h>
>  #include <unistd.h>
>  #include <errno.h>
>
> @@ -581,6 +582,31 @@ int ndctl_dax_delete(struct ndctl_dax *dax);
>  int ndctl_dax_is_configured(struct ndctl_dax *dax);
>  struct daxctl_region *ndctl_dax_get_daxctl_region(struct ndctl_dax *dax);
>
> +struct ndctl_cmd *ndctl_dimm_cmd_new_fw_get_info(struct ndctl_dimm *dimm);
> +struct ndctl_cmd *ndctl_dimm_cmd_new_fw_start_update(struct ndctl_dimm *dimm);
> +struct ndctl_cmd *ndctl_dimm_cmd_new_fw_send(struct ndctl_dimm *dimm,
> +               unsigned int chunk_size);
> +struct ndctl_cmd *ndctl_dimm_cmd_new_fw_finish(struct ndctl_dimm *dimm);
> +struct ndctl_cmd *ndctl_dimm_cmd_new_fw_finish_query(struct ndctl_dimm *dimm);
> +unsigned int ndctl_cmd_fw_info_get_storage_size(struct ndctl_cmd *cmd);
> +unsigned int ndctl_cmd_fw_info_get_max_send_len(struct ndctl_cmd *cmd);
> +unsigned int ndctl_cmd_fw_info_get_query_interval(struct ndctl_cmd *cmd);
> +unsigned int ndctl_cmd_fw_info_get_max_query_time(struct ndctl_cmd *cmd);
> +unsigned char ndctl_cmd_fw_info_get_update_cap(struct ndctl_cmd *cmd);

The update cap is a field that has a binary representation for the
Intel case, I don't think this is the api want at the generic level.
Lets drop this one.

> +unsigned int ndctl_cmd_fw_info_get_fis_version(struct ndctl_cmd *cmd);

This one is Intel specific and shouldn't be in the public interface.

> +unsigned long ndctl_cmd_fw_info_get_run_version(struct ndctl_cmd *cmd);
> +unsigned long ndctl_cmd_fw_info_get_updated_version(struct ndctl_cmd *cmd);
> +unsigned char ndctl_cmd_fw_info_get_update_cap(struct ndctl_cmd *cmd);

Duplicate?

> +unsigned int ndctl_cmd_fw_start_get_context(struct ndctl_cmd *cmd);
> +unsigned long ndctl_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd);
> +int ndctl_cmd_fw_send_set_context(struct ndctl_cmd *cmd, unsigned int context);
> +int ndctl_cmd_fw_send_set_offset(struct ndctl_cmd *cmd, unsigned int offset);
> +int ndctl_cmd_fw_send_set_length(struct ndctl_cmd *cmd, unsigned int len);
> +int ndctl_cmd_fw_send_set_data(struct ndctl_cmd *cmd, void *buf, size_t len);
> +int ndctl_cmd_fw_finish_set_ctrl_flags(struct ndctl_cmd *cmd, unsigned char flags);

I think we need explicit 'finish" and "abort" apis since other DIMMs
may not use flags for this and certainly not the same binary
definition of the flags.

> +int ndctl_cmd_fw_finish_set_context(struct ndctl_cmd *cmd, unsigned int context);
> +int ndctl_cmd_fw_fquery_set_context(struct ndctl_cmd *cmd, unsigned int context);
> +
>  #ifdef __cplusplus
>  } /* extern "C" */
>  #endif
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
