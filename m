Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 679A22095B07E
 for <linux-nvdimm@lists.01.org>; Mon,  9 Oct 2017 09:24:16 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id h200so13683176oib.4
 for <linux-nvdimm@lists.01.org>; Mon, 09 Oct 2017 09:27:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171006015405.29908-6-vishal.l.verma@intel.com>
References: <20171006015405.29908-1-vishal.l.verma@intel.com>
 <20171006015405.29908-6-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 9 Oct 2017 09:27:41 -0700
Message-ID: <CAPcyv4gheaE9hsn2iSfvziZsDtt0gnCH50Xq4=jt+0tqGwd_gw@mail.gmail.com>
Subject: Re: [ndctl PATCH 5/8] ndctl: add an inject-error command
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

On Thu, Oct 5, 2017 at 6:54 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Add an inject-error command to ndctl. This uses the error injection DSMs
> in ACPI6.2 to provide a generic error injection and management
> interface. Once can inject errors, and view as well as clear injected
> errors using these commands.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/ndctl/Makefile.am            |   1 +
>  Documentation/ndctl/ndctl-inject-error.txt | 108 +++++
>  Documentation/ndctl/ndctl.txt              |   1 +
>  builtin.h                                  |   1 +
>  contrib/ndctl                              |   5 +-
>  ndctl/Makefile.am                          |   3 +-
>  ndctl/inject-error.c                       | 745 +++++++++++++++++++++++++++++
>  ndctl/libndctl-nfit.h                      |   8 +
>  ndctl/ndctl.c                              |   1 +
>  util/json.c                                |  26 +
>  util/json.h                                |   3 +
>  util/size.h                                |   1 +
>  12 files changed, 901 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/ndctl/ndctl-inject-error.txt
>  create mode 100644 ndctl/inject-error.c
>
> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> index 229d908..615baf0 100644
> --- a/Documentation/ndctl/Makefile.am
> +++ b/Documentation/ndctl/Makefile.am
> @@ -30,6 +30,7 @@ man1_MANS = \
>         ndctl-create-namespace.1 \
>         ndctl-destroy-namespace.1 \
>         ndctl-check-namespace.1 \
> +       ndctl-inject-error.1 \
>         ndctl-list.1
>
>  CLEANFILES = $(man1_MANS)
> diff --git a/Documentation/ndctl/ndctl-inject-error.txt b/Documentation/ndctl/ndctl-inject-error.txt
> new file mode 100644
> index 0000000..bd9e197
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-inject-error.txt
> @@ -0,0 +1,108 @@
> +ndctl-inject-error(1)
> +=====================
> +
> +NAME
> +----
> +ndctl-inject-error - inject media errors at a namespace offset
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl inject-error' <namespace> [<options>]
> +
> +include::namespace-description.txt[]
> +
> +ndctl-inject-error can be used to ask the platform to simulate media errors
> +in the nvdimm address space to aid debugging and development of features
> +related to error handling.
> +
> +WARNING: These commands are DANGEROUS and can cause data loss. They are
> +only provided for testing and debugging purposes.
> +
> +EXAMPLES
> +--------
> +
> +Inject errors in namespace0.0 at sector 12 for a 2 sectors (i.e. 12, 13)
> +[verse]
> +ndctl inject-error --sector=12 --count=2 namespace0.0
> +
> +Check status of injected errors on namespace0.0
> +[verse]
> +ndctl inject-error --status namespacce0.0
> +
> +Clear the injected errors at sector 12 for 2 sectors on namespace0.0
> +[verse]
> +ndctl inject-error --clear --sector=12 --count=2 namespacce0.0
> +
> +OPTIONS
> +-------
> +-S::
> +--sector=::
> +       Namespace sector offset in 512 byte sized sectors where the error is
> +       to be injected.

Let's use the term "block" instead of "sector" since the --media-error
json in ndctl list reports bad 'blocks' and the kernel interfaces use
'block'.

> +
> +       NOTE: The offset is interpreted in different ways based on the "mode"
> +       of the namespace. For "raw" mode, the offset is the base namespace
> +       offset. For "memory" mode (i.e. a "pfn" namespace), the offset is
> +       relative to the user-visible part of the namespace, and the offset
> +       introduced by the kernel's metadata will be accounted for. For a
> +       "sector" mode namespace (i.e. a "BTT" namespace), the offset is
> +       relative to the base namespace, as the BTT translation details are
> +       internal to the kernel, and can't be accounted for while injecting
> +       errors.
> +
> +-c::
> +--count=::
> +       Number of sectors to inject as errors. This is also in terms of fixed,
> +       512 byte sectors.
> +
> +-d::
> +--clear::

How about "--uninject"?

> +       This option will ask the platform to clear any injected errors for the
> +       specified sector offset, and count.
> +
> +       WARNING: This will not clear the kernel's internal "badrange" and
> +       "badblock" tracking - those can only be cleared by doing a write to

badrange is a kernel internal implementation detail. So we can just
say "This will not clear the kernel's internal bad block tracking"

> +       the affected locations. Hence use the --clear option only if you know
> +       exactly what you are doing. For normal usage, injected errors should
> +       only be cleared by doing writes. Do not expect have the original data
> +       intact after injecting an error, and clearing it using --clear - it
> +       will be lost, as the only "real" way to clear the error location is
> +       to write to it or zero it (truncate/hole-punch).
> +
> +-t::
> +--status::

"--query"?

> +       This option will retrieve the status of injected errors. Note that
> +       this will not retrieve all known/latent errors (i.e. non injected
> +       ones), and is NOT equivalent to performing an Address Range Scrub.
> +
> +-N::
> +--no-notify::
> +       This option is only valid when injecting errors. By default, the error
> +       inject command and will ask platform firmware to trigger a notification
> +       in the kernel, asking it to update its state of known errors.
> +       With this option, the error will still be injected, the kernel will not
> +       get a notification, and the error will appear as a latent media error
> +       when the location is accessed. If the platform firmware does not
> +       support this feature, this will have no effect.
> +
> +-v::
> +--verbose::
> +       Emit debug messages for the error injection process
> +
> +include::human-option.txt[]
> +
> +-r::
> +--region=::
> +include::xable-region-options.txt[]
> +
> +COPYRIGHT
> +---------
> +Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
> +version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
> +you are free to change and redistribute it.  There is NO WARRANTY, to
> +the extent permitted by law.
> +
> +SEE ALSO
> +--------
> +linkndctl:ndctl-list[1],
> diff --git a/Documentation/ndctl/ndctl.txt b/Documentation/ndctl/ndctl.txt
> index b02f613..b2e2ab9 100644
> --- a/Documentation/ndctl/ndctl.txt
> +++ b/Documentation/ndctl/ndctl.txt
> @@ -50,6 +50,7 @@ linkndctl:ndctl-enable-namespace[1],
>  linkndctl:ndctl-disable-namespace[1],
>  linkndctl:ndctl-zero-labels[1],
>  linkndctl:ndctl-read-labels[1],
> +linkndctl:ndctl-inject-error[1],
>  linkndctl:ndctl-list[1],
>  https://www.kernel.org/doc/Documentation/nvdimm/nvdimm.txt[LIBNVDIMM
>  Overview],
> diff --git a/builtin.h b/builtin.h
> index 5c8b611..5e1b7ef 100644
> --- a/builtin.h
> +++ b/builtin.h
> @@ -35,6 +35,7 @@ int cmd_read_labels(int argc, const char **argv, void *ctx);
>  int cmd_write_labels(int argc, const char **argv, void *ctx);
>  int cmd_init_labels(int argc, const char **argv, void *ctx);
>  int cmd_check_labels(int argc, const char **argv, void *ctx);
> +int cmd_inject_error(int argc, const char **argv, void *ctx);
>  int cmd_list(int argc, const char **argv, void *ctx);
>  #ifdef ENABLE_TEST
>  int cmd_test(int argc, const char **argv, void *ctx);
> diff --git a/contrib/ndctl b/contrib/ndctl
> index c7d1b67..8745fb5 100755
> --- a/contrib/ndctl
> +++ b/contrib/ndctl
> @@ -91,7 +91,7 @@ __ndctlcomp()
>
>         COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
>         for cword in "${COMPREPLY[@]}"; do
> -               if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align) ]]; then
> +               if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align|--sector|--count) ]]; then
>                         COMPREPLY[$i]="${cword}="
>                 else
>                         COMPREPLY[$i]="${cword} "
> @@ -257,6 +257,9 @@ __ndctl_comp_non_option_args()
>         zero-labels)
>                 opts="$(__ndctl_get_dimms -i) all"
>                 ;;
> +       inject-error)
> +               opts="$(__ndctl_get_ns -i)"
> +               ;;
>         *)
>                 return
>                 ;;
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index d346c04..a0cf500 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -11,7 +11,8 @@ ndctl_SOURCES = ndctl.c \
>                  ../util/log.c \
>                 list.c \
>                 test.c \
> -               ../util/json.c
> +               ../util/json.c \
> +               inject-error.c
>
>  if ENABLE_SMART
>  ndctl_SOURCES += util/json-smart.c
> diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
> new file mode 100644
> index 0000000..a6bcc1b
> --- /dev/null
> +++ b/ndctl/inject-error.c
> @@ -0,0 +1,745 @@
> +/*
> + * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +#include <stdio.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <setjmp.h>
> +#include <limits.h>
> +#include <unistd.h>
> +#include <stdint.h>
> +#include <libkmod.h>
> +#include <stdbool.h>
> +#include <linux/fs.h>
> +#include <sys/wait.h>
> +#include <sys/stat.h>
> +#include <sys/mman.h>
> +#include <sys/types.h>
> +#include <sys/ioctl.h>
> +#include <linux/fiemap.h>
> +
> +#include <util/log.h>
> +#include <util/size.h>
> +#include <util/json.h>
> +#include <util/sysfs.h>
> +#include <json-c/json.h>
> +#include <util/filter.h>
> +#include <ndctl/libndctl.h>
> +#include <ccan/list/list.h>
> +#include <util/parse-options.h>
> +#include <ndctl/libndctl-nfit.h>
> +#include <ccan/array_size/array_size.h>
> +#include <ccan/short_types/short_types.h>
> +#ifdef HAVE_NDCTL_H
> +#include <linux/ndctl.h>
> +#else
> +#include <ndctl.h>
> +#endif
> +
> +#include "private.h"
> +#include <builtin.h>
> +#include <test.h>
> +
> +static bool verbose;
> +static struct parameters {
> +       const char *bus;
> +       const char *region;
> +       const char *namespace;
> +       const char *sector;
> +       const char *count;
> +       bool clear;
> +       bool status;
> +       bool notify;
> +       bool human;
> +} param;
> +
> +static struct inject_ctx {
> +       u64 sector;
> +       u64 count;
> +       u64 off_bytes;
> +       u64 len_bytes;
> +       u64 options;
> +       unsigned int op_mask;
> +       unsigned long flags;
> +       struct list_head bb_list;
> +} ictx;
> +
> +#define BASE_OPTIONS() \
> +OPT_STRING('b', "bus", &param.bus, "bus-id", \
> +       "limit namespace to a bus with an id or provider of <bus-id>"), \
> +OPT_STRING('r', "region", &param.region, "region-id", \
> +       "limit namespace to a region with an id or name of <region-id>"), \
> +OPT_BOOLEAN('v', "verbose", &verbose, "emit extra debug messages to stderr")
> +
> +#define INJECT_OPTIONS() \
> +OPT_STRING('S', "sector", &param.sector, "namespace sector offset", \
> +       "specify the sector at which to inject the error"), \
> +OPT_STRING('c', "count", &param.count, "count", \
> +       "specify the number of sectors of errors to inject"), \
> +OPT_BOOLEAN('d', "clear", &param.clear, \
> +       "send the ARS error inject clear DSM"), \
> +OPT_BOOLEAN('t', "status", &param.status, "get error injection status"), \
> +OPT_BOOLEAN('N', "no-notify", &param.notify, "firmware should not notify OS"), \
> +OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats ")
> +
> +static const struct option inject_options[] = {
> +       BASE_OPTIONS(),
> +       INJECT_OPTIONS(),
> +       OPT_END(),
> +};
> +
> +enum {
> +       OP_INJECT = 0,
> +       OP_CLEAR,
> +       OP_STATUS,
> +};
> +
> +struct bb {
> +       u64 sector;
> +       u64 count;
> +       struct list_node list;
> +};
> +
> +static int inject_init(void)
> +{
> +       if (!param.clear && !param.status) {
> +               ictx.op_mask |= 1 << OP_INJECT;
> +               ictx.options |= 1 << ND_ARS_ERR_INJ_OPT_NOTIFY;
> +               if (param.notify)
> +                       ictx.options &= ~(1 << ND_ARS_ERR_INJ_OPT_NOTIFY);
> +       }
> +       if (param.clear) {
> +               if (param.status) {
> +                       error("status is invalid with clear or inject\n");
> +                       return -EINVAL;
> +               }
> +               ictx.op_mask |= 1 << OP_CLEAR;
> +       }
> +       if (param.status) {
> +               if (param.sector || param.count) {
> +                       error("status is invalid with clear or inject\n");
> +                       return -EINVAL;
> +               }
> +               ictx.op_mask |= 1 << OP_STATUS;
> +       }
> +
> +       if (ictx.op_mask == 0) {
> +               error("Unable to determine operation\n");
> +               return -EINVAL;
> +       }
> +       ictx.op_mask &= (
> +               (1 << OP_INJECT) |
> +               (1 << OP_CLEAR) |
> +               (1 << OP_STATUS));
> +
> +       if (param.sector) {
> +               ictx.sector = parse_size64(param.sector);
> +               if (ictx.sector == ULLONG_MAX) {
> +                       error("Invalid sector: %s\n", param.sector);
> +                       return -EINVAL;
> +               }
> +               ictx.off_bytes = ictx.sector * 512;
> +       }
> +       if (param.count) {
> +               ictx.count = parse_size64(param.count);
> +               if (ictx.count == ULLONG_MAX) {
> +                       error("Invalid count: %s\n", param.count);
> +                       return -EINVAL;
> +               }
> +               ictx.len_bytes = ictx.count * 512;
> +       }
> +
> +       /* For inject or clear, an sector and count are required */
> +       if (ictx.op_mask & ((1 << OP_INJECT) | (1 << OP_CLEAR))) {
> +               if (!param.sector || !param.count) {
> +                       error("sector and count required for inject/clear\n");
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       if (param.human)
> +               ictx.flags |= UTIL_JSON_HUMAN;
> +
> +       list_head_init(&ictx.bb_list);
> +
> +       return 0;
> +}
> +
> +static int bus_has_ars_inject(struct ndctl_bus *bus)
> +{
> +       if (!ndctl_bus_has_nfit(bus))
> +               return 0;
> +
> +       if (ndctl_bus_is_nfit_cmd_supported(bus, NFIT_CMD_ARS_INJECT_SET) &&
> +               ndctl_bus_is_nfit_cmd_supported(bus, NFIT_CMD_ARS_INJECT_GET) &&
> +               ndctl_bus_is_nfit_cmd_supported(bus, NFIT_CMD_ARS_INJECT_CLEAR))
> +               return 1;
> +       else
> +               return 0;

This bus specific detail knowledge should be hidden in libndctl. I.e.
I want it to be the case that if another bus type with error injection
capabilities appeared tomorrow it could be enabled for error injection
just by updated the library. If a new bus requires changes to
"ndctl/inject-error.c" then the abstraction is broken.


> +}
> +
> +static struct ndctl_cmd *ndctl_bus_cmd_new_err_inj(struct ndctl_bus *bus)
> +{
> +       struct nd_cmd_ars_err_inj *err_inj;
> +       size_t size, cmd_length;
> +       struct nd_cmd_pkg *pkg;
> +       struct ndctl_cmd *cmd;
> +
> +       cmd_length = sizeof(struct nd_cmd_ars_err_inj);
> +       size = sizeof(*cmd) + sizeof(*pkg) + cmd_length;
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
> +       pkg->nd_command = NFIT_CMD_ARS_INJECT_SET;
> +       pkg->nd_size_in = (2 * sizeof(u64)) + sizeof(u32);
> +       pkg->nd_size_out = cmd_length;
> +       pkg->nd_fw_size = cmd_length;
> +       err_inj = (struct nd_cmd_ars_err_inj *)&pkg->nd_payload[0];
> +       cmd->firmware_status = &err_inj->status;
> +
> +       return cmd;
> +}
> +
> +static struct ndctl_cmd *ndctl_bus_cmd_new_err_inj_clr(struct ndctl_bus *bus)
> +{
> +       struct nd_cmd_ars_err_inj_clr *err_inj_clr;
> +       size_t size, cmd_length;
> +       struct nd_cmd_pkg *pkg;
> +       struct ndctl_cmd *cmd;
> +
> +       cmd_length = sizeof(struct nd_cmd_ars_err_inj_clr);
> +       size = sizeof(*cmd) + sizeof(*pkg) + cmd_length;
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
> +       pkg->nd_command = NFIT_CMD_ARS_INJECT_CLEAR;
> +       pkg->nd_size_in = 2 * sizeof(u64);
> +       pkg->nd_size_out = cmd_length;
> +       pkg->nd_fw_size = cmd_length;
> +       err_inj_clr = (struct nd_cmd_ars_err_inj_clr *)&pkg->nd_payload[0];
> +       cmd->firmware_status = &err_inj_clr->status;
> +
> +       return cmd;
> +}
> +
> +static struct ndctl_cmd *ndctl_bus_cmd_new_err_inj_stat(struct ndctl_bus *bus,
> +       u32 buf_size)
> +{
> +       struct nd_cmd_ars_err_inj_stat *err_inj_stat;
> +       size_t size, cmd_length;
> +       struct nd_cmd_pkg *pkg;
> +       struct ndctl_cmd *cmd;
> +
> +
> +       cmd_length = sizeof(struct nd_cmd_ars_err_inj_stat);
> +       size = sizeof(*cmd) + sizeof(*pkg) + cmd_length + buf_size;
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
> +       pkg->nd_command = NFIT_CMD_ARS_INJECT_GET;
> +       pkg->nd_size_in = cmd_length;
> +       pkg->nd_size_out = cmd_length + buf_size;
> +       pkg->nd_fw_size = cmd_length + buf_size;
> +       err_inj_stat = (struct nd_cmd_ars_err_inj_stat *)&pkg->nd_payload[0];
> +       cmd->firmware_status = &err_inj_stat->status;
> +
> +       return cmd;
> +}
> +
> +static void translate_status(u32 status)
> +{
> +       if (status == ND_ARS_ERR_INJ_STATUS_NOT_SUPP)
> +               fprintf(stderr,
> +                       "error: error injection is not supported\n");
> +       if (status == ND_ARS_ERR_INJ_STATUS_INVALID_PARAM)
> +               fprintf(stderr, "error: invalid parameters\n");
> +}
> +
> +static int ndctl_bus_nfit_err_inj(struct ndctl_bus *bus, u64 offset,
> +       u64 length, u32 options)
> +{
> +       struct nd_cmd_ars_err_inj *err_inj;
> +       struct nd_cmd_pkg *pkg;
> +       struct ndctl_cmd *cmd;
> +       int rc;
> +
> +       if (!bus)
> +               return -EINVAL;
> +
> +       cmd = ndctl_bus_cmd_new_err_inj(bus);
> +       if (!cmd)
> +               return -ENOMEM;
> +
> +       pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
> +       err_inj = (struct nd_cmd_ars_err_inj *)&pkg->nd_payload[0];
> +       err_inj->err_inj_spa_range_base = offset;
> +       err_inj->err_inj_spa_range_length = length;
> +       err_inj->err_inj_options = options;
> +
> +       rc = ndctl_cmd_submit(cmd);
> +       if (rc) {
> +               fprintf(stderr, "Error submitting command: %d\n", rc);
> +               goto out;
> +       }
> +       translate_status(err_inj->status);
> +
> + out:
> +       ndctl_cmd_unref(cmd);
> +       return rc;
> +}
> +
> +static int ndctl_bus_nfit_err_inj_clr(struct ndctl_bus *bus, u64 offset,
> +       u64 length)
> +{
> +       struct nd_cmd_ars_err_inj_clr *err_inj_clr;
> +       struct nd_cmd_pkg *pkg;
> +       struct ndctl_cmd *cmd;
> +       int rc;
> +
> +       if (!bus)
> +               return -EINVAL;
> +
> +       cmd = ndctl_bus_cmd_new_err_inj_clr(bus);
> +       if (!cmd)
> +               return -ENOMEM;
> +
> +       pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
> +       err_inj_clr = (struct nd_cmd_ars_err_inj_clr *)&pkg->nd_payload[0];
> +       err_inj_clr->err_inj_clr_spa_range_base = offset;
> +       err_inj_clr->err_inj_clr_spa_range_length = length;
> +
> +       rc = ndctl_cmd_submit(cmd);
> +       if (rc) {
> +               fprintf(stderr, "Error submitting command: %d\n", rc);
> +               goto out;
> +       }
> +       translate_status(err_inj_clr->status);
> +       printf("Warning: Clearing injected errors here clears them in the\n");
> +       printf("badrange list in nfit_test, but the kernel won't 'forget'\n");
> +       printf("any entries it has found in a scrub until they are cleared\n");
> +       printf("through the normal process of writing the affected blocks\n\n");
> + out:
> +       ndctl_cmd_unref(cmd);
> +       return rc;
> +}
> +

All these command helpers belong in the library with fronting wrapper
calls that don't reference "nfit". For example we have
ndctl_bus_get_dimm_by_physical_address() fronting
ndctl_bus_nfit_translate_spa().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
