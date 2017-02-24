Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 71B348215F
 for <linux-nvdimm@lists.01.org>; Thu, 23 Feb 2017 17:14:24 -0800 (PST)
Received: by mail-oi0-x22d.google.com with SMTP id s205so4151719oif.3
 for <linux-nvdimm@lists.01.org>; Thu, 23 Feb 2017 17:14:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170222224724.7696-3-vishal.l.verma@intel.com>
References: <20170222224724.7696-1-vishal.l.verma@intel.com>
 <20170222224724.7696-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 23 Feb 2017 17:14:23 -0800
Message-ID: <CAPcyv4gd=kvFOD8W+C8Wn7jj3ECXswun91_ryu5Dgf8h44yUkg@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 2/3] ndctl: add a BTT check utility
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

Hi Vishal, some more comments on the supporting infrastructure from me.

I'm otherwise waiting for the thumbs up from Jeff on if this meets
expectations, but this is looking good.

On Wed, Feb 22, 2017 at 2:47 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Add the check-namespace command to ndctl. This will check the BTT
> metadata layout for the given namespace, and if requested, correct any
> errors found. Not all metadata corruption is detectable or fixable.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Linda Knippers <linda.knippers@hpe.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/Makefile.am               |   1 +
>  Documentation/ndctl-check-namespace.txt |  64 +++
>  Documentation/ndctl.txt                 |   1 +
>  Makefile.am                             |   4 +-
>  builtin.h                               |   1 +
>  ccan/bitmap/LICENSE                     |   1 +
>  ccan/bitmap/bitmap.c                    | 125 +++++
>  ccan/bitmap/bitmap.h                    | 243 +++++++++

Lets split out the new bitmap code into a separate preparation patch.


>  contrib/ndctl                           |   3 +
>  licenses/LGPL-2.1                       | 508 +++++++++++++++++
>  ndctl.spec.in                           |   5 +-
>  ndctl/Makefile.am                       |   1 +
>  ndctl/builtin-check.c                   | 938 ++++++++++++++++++++++++++++++++
>  ndctl/builtin-xaction-namespace.c       |  66 ++-
>  ndctl/check.h                           | 123 +++++
>  ndctl/ndctl.c                           |   1 +
>  util/usage.c                            |  15 +
>  util/util.h                             |   9 +
>  18 files changed, 2105 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/ndctl-check-namespace.txt
>  create mode 120000 ccan/bitmap/LICENSE
>  create mode 100644 ccan/bitmap/bitmap.c
>  create mode 100644 ccan/bitmap/bitmap.h
>  create mode 100644 licenses/LGPL-2.1
>  create mode 100644 ndctl/builtin-check.c
>  create mode 100644 ndctl/check.h
>
> diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
> index 6daeb56..eea11e0 100644
> --- a/Documentation/Makefile.am
> +++ b/Documentation/Makefile.am
> @@ -12,6 +12,7 @@ man1_MANS = \
>         ndctl-disable-namespace.1 \
>         ndctl-create-namespace.1 \
>         ndctl-destroy-namespace.1 \
> +       ndctl-check-namespace.1 \
>         ndctl-list.1 \
>         daxctl-list.1
>
> diff --git a/Documentation/ndctl-check-namespace.txt b/Documentation/ndctl-check-namespace.txt
> new file mode 100644
> index 0000000..88f6086
> --- /dev/null
> +++ b/Documentation/ndctl-check-namespace.txt
> @@ -0,0 +1,64 @@
> +ndctl-check-namespace(1)
> +=========================
> +
> +NAME
> +----
> +ndctl-check-namespace - check namespace metadata consistency
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl check-namespace' [<options>]

Shouldn't this match {en,dis}able-namespace with a <namespace> parameter, i.e.:

'ndctl check-namespace' <namespace> [<options>]


> +
> +DESCRIPTION
> +-----------
> +
> +A namespace in the 'sector' mode will have metadata on it to describe
> +the kernel BTT (Block Translation Table). The check-namespace command
> +can be used to check the consistency of this metadata, and optionally,
> +also attempt to repair it, if it has enough information to do so.
> +
> +The namespace being checked has to be disabled before initiating a
> +check on it as a precautionary measure. The --force option can override
> +this.
> +
> +EXAMPLES
> +--------
> +
> +Check a namespace (only report errors)
> +[verse]
> +ndctl disable-namespace namespace0.0

I'd rather not get people in the mode of blindly disabling namespaces,
because "ndctl disable-namespace" doesn't check if there is a mounted
filesystem on the namespace before disabling.

Instead they should be using "--force" and have the command catch
cases where the namespace is hosting a mounted filesystem.

That said, I wouldn't say no to unifying all paths that disable
namespaces to perform the same checking as done by
namespace_destroy().


> +ndctl check-namespace namespace0.0
> +
> +Check a namespace, and perform repairs if possible
> +[verse]
> +ndctl disable-namespace namespace0.0
> +ndctl check-namespace --repair namespace0.0
> +
> +OPTIONS
> +-------
> +-R::
> +--repair::
> +       Perform metadata repairs if possible. Without this option,
> +       the raw namespace contents will not be touched.
> +
> +-f::
> +--force::
> +       Unless this option is specified, a check-namespace operation
> +       will fail if the namespace is presently active. Specifying
> +       --force causes the namespace to be disabled before checking.
> +
> +-v::
> +--verbose::
> +       Emit debug messages for the namespace check process.
> +
> +-r::
> +--region=::
> +include::xable-region-options.txt[]
> +
> +SEE ALSO
> +--------
> +linkndctl:ndctl-disable-namespace[1],
> +linkndctl:ndctl-enable-namespace[1],
> +http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
> +Specification]
> diff --git a/Documentation/ndctl.txt b/Documentation/ndctl.txt
> index 883a59c..c26cc2f 100644
> --- a/Documentation/ndctl.txt
> +++ b/Documentation/ndctl.txt
> @@ -34,6 +34,7 @@ SEE ALSO
>  --------
>  linkndctl:ndctl-create-namespace[1],
>  linkndctl:ndctl-destroy-namespace[1],
> +linkndctl:ndctl-check-namespace[1],
>  linkndctl:ndctl-enable-region[1],
>  linkndctl:ndctl-disable-region[1],
>  linkndctl:ndctl-enable-dimm[1],
> diff --git a/Makefile.am b/Makefile.am
> index 5453b2a..26c7309 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -56,7 +56,9 @@ libccan_a_SOURCES = \
>         ccan/array_size/array_size.h \
>         ccan/minmax/minmax.h \
>         ccan/short_types/short_types.h \
> -       ccan/endian/endian.h
> +       ccan/endian/endian.h \
> +       ccan/bitmap/bitmap.h \
> +       ccan/bitmap/bitmap.c
>

Move to the new bitmap patch.


>  noinst_LIBRARIES += libutil.a
>  libutil_a_SOURCES = \
> diff --git a/builtin.h b/builtin.h
> index 9b66196..200bd8e 100644
> --- a/builtin.h
> +++ b/builtin.h
> @@ -13,6 +13,7 @@ int cmd_enable_namespace(int argc, const char **argv, void *ctx);
>  int cmd_create_namespace(int argc, const char **argv, void *ctx);
>  int cmd_destroy_namespace(int argc, const char **argv, void *ctx);
>  int cmd_disable_namespace(int argc, const char **argv, void *ctx);
> +int cmd_check_namespace(int argc, const char **argv, void *ctx);
>  int cmd_enable_region(int argc, const char **argv, void *ctx);
>  int cmd_disable_region(int argc, const char **argv, void *ctx);
>  int cmd_enable_dimm(int argc, const char **argv, void *ctx);
> diff --git a/ccan/bitmap/LICENSE b/ccan/bitmap/LICENSE
> new file mode 120000
> index 0000000..dc314ec


[..] snip ccan/bitmap

> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index b481762..57a3d90 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -112,7 +112,7 @@ make check
>
>  %files
>  %defattr(-,root,root)
> -%license util/COPYING licenses/BSD-MIT licenses/CC0
> +%license util/COPYING licenses/BSD-MIT licenses/CC0 licenses/LGPL-2.1
>  %{_bindir}/ndctl
>  %{_mandir}/man1/ndctl*
>  %{bashcompdir}/
> @@ -151,6 +151,9 @@ make check
>
>
>  %changelog
> +* Tue Feb 21 2017 Vishal Verma <vishal.l.verma@intel.com> - 57-1
> +- Add licenses/LGPL-2.1 for ccan/bitmap in the ndctl utility
> +
>  * Fri May 27 2016 Dan Williams <dan.j.williams@intel.com> - 53-1
>  - add daxctl-libs + daxctl-devel packages
>  - add bash completion

You can drop this hunk, this changelog is vestigial. The real
rpm-spec-file changelog gets updated when it is checked into the
upstream distribution's package source control.


> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index c563e94..f9158d9 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -5,6 +5,7 @@ bin_PROGRAMS = ndctl
>  ndctl_SOURCES = ndctl.c \
>                 builtin-create-nfit.c \
>                 builtin-xaction-namespace.c \
> +               builtin-check.c \
>                 builtin-xable-region.c \
>                 builtin-dimm.c \
>                  ../util/log.c \
> diff --git a/ndctl/builtin-check.c b/ndctl/builtin-check.c
> new file mode 100644
> index 0000000..ff7e8c1
> --- /dev/null
> +++ b/ndctl/builtin-check.c
> @@ -0,0 +1,938 @@
> +/*
> + * Copyright(c) 2015-2016 Intel Corporation. All rights reserved.
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
> +#include <stdint.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <limits.h>
> +#include <stdbool.h>
> +#include <sys/mman.h>
> +#include <uuid/uuid.h>
> +#include <sys/types.h>
> +#include <util/json.h>
> +#include <util/size.h>
> +#include <util/util.h>
> +#include <util/fletcher.h>
> +#include <ndctl/libndctl.h>
> +#include <ccan/bitmap/bitmap.h>
> +#include <ccan/endian/endian.h>
> +#include <ccan/minmax/minmax.h>
> +#include <ccan/array_size/array_size.h>
> +#include <ccan/short_types/short_types.h>
> +#include "check.h"
> +
> +#ifdef HAVE_NDCTL_H
> +#include <linux/ndctl.h>
> +#else
> +#include <ndctl.h>
> +#endif
> +
> +static int repair_msg(void)
> +{
> +       inform("  Run with --repair to make the changes");
> +       return 0;

So there's 2 logging infrastructures in ndctl. There's util/log.c
that's used by the library, and some helper routines that print the
usage messages when commands fail. I think for verbose logging you'll
want to use util/log.c since it has better support for different log
levels.

See how util/log.c is used in ndctl/builtin-dimm.c. It does require
passing a log context around, but I can see that being useful for
adding a -vv (extra verbose) option someday.

> +}
> +
> +/**
> + * btt_read_info - read an info block from a given offset
> + * @bttc:      the main btt_chk structure for this btt
> + * @btt_sb:    struct btt_sb where the info block will be copied into
> + * @offset:    offset in the raw namespace to read the info block from
> + *
> + * The initial 4K offset will get added in by this routine. This will
> + * also use 'pread' to read the info block, and not mmap+loads as this
> + * is used before the mappings are set up.

Maybe we can move this offset into an attribute of the struct btt_chk
context. I know the btt's created by libpmem have a zero offset, and
we might want that flexibility if we ever add support for checking an
image file of a namespace. I'm also thinking of a future dump/restore
capability.


[..] snip
> +int namespace_check(struct ndctl_region *region, struct ndctl_namespace *ndns,
> +               struct check_opts *opts)
> +{
> +       const char *devname = ndctl_namespace_get_devname(ndns);
> +       int raw_mode, rc, disabled_flag = 0, open_flags;
> +       struct btt_chk *bttc;
> +       struct btt_sb *btt_sb;
> +       char path[50];
> +
> +       printf("checking %s\n", devname);
> +       if (util_namespace_active(ndns)) {
> +               if (opts->force) {
> +                       rc = ndctl_namespace_disable_invalidate(ndns);

No, we don't want to blindly disable the namespace here. If there is a
mounted filesystem then not even --force should override that.

See the sequence in namespace_destroy() and perhaps refactor it so
both namespace destroy and namespace_check() use the same semantics
for handling "--force".


[..] snip
>         { "enable-dimm", cmd_enable_dimm },
> diff --git a/util/usage.c b/util/usage.c
> index 9e0da8a..3c4a0f3 100644
> --- a/util/usage.c
> +++ b/util/usage.c
> @@ -40,12 +40,18 @@ static void warn_builtin(const char *warn, va_list params)
>         report(" Warning: ", warn, params);
>  }
>
> +static void info_builtin(const char *info, va_list params)
> +{
> +       report(" Info: ", info, params);
> +}
> +
>  /* If we are in a dlopen()ed .so write to a global variable would segfault
>   * (ugh), so keep things static. */
>  static void (*usage_routine)(const char *err) NORETURN = usage_builtin;
>  static void (*die_routine)(const char *err, va_list params) NORETURN = die_builtin;
>  static void (*error_routine)(const char *err, va_list params) = error_builtin;
>  static void (*warn_routine)(const char *err, va_list params) = warn_builtin;
> +static void (*info_routine)(const char *err, va_list params) = info_builtin;
>
>  void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN)
>  {
> @@ -84,3 +90,12 @@ void warning(const char *warn, ...)
>         warn_routine(warn, params);
>         va_end(params);
>  }
> +
> +void inform(const char *info, ...)
> +{
> +       va_list params;
> +
> +       va_start(params, info);
> +       info_routine(info, params);
> +       va_end(params);
> +}

As mentioned before, switch to using a log_ctx and the info() helper
for LOG_INFO and dbg() for LOG_DEBUG level messages.


> diff --git a/util/util.h b/util/util.h
> index e0e5f26..5680033 100644
> --- a/util/util.h
> +++ b/util/util.h
> @@ -23,6 +23,13 @@
>
>  #define alloc_nr(x) (((x)+16)*3/2)
>
> +#define rounddown(x, y) (                              \
> +{                                                      \
> +       typeof(x) __x = (x);                            \
> +       __x - (__x % (y));                              \
> +}                                                      \
> +)
> +
>  /*
>   * Realloc the buffer pointed at by variable 'x' so that it can hold
>   * at least 'nr' entries; the number of entries currently allocated
> @@ -44,6 +51,7 @@
>  #define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
>
>  #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
> +#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))

Do we need two of these? Can you just use BUILD_BUG_ON_ZERO()?


[..] snip
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
