Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7B0202194D387
 for <linux-nvdimm@lists.01.org>; Wed, 23 Jan 2019 09:45:58 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id y1so2477295oie.12
 for <linux-nvdimm@lists.01.org>; Wed, 23 Jan 2019 09:45:58 -0800 (PST)
MIME-Version: 1.0
References: <154777861562.42557.12388414625709189905.stgit@djiang5-desk3.ch.intel.com>
 <154777911312.42557.15688834797714631330.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154777911312.42557.15688834797714631330.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Jan 2019 09:45:45 -0800
Message-ID: <CAPcyv4hgA+uht-BeDdeom-sw3q2ihnXsx8p6csk41fRPeDXwRQ@mail.gmail.com>
Subject: Re: [PATCH v9 02/13] ndctl: add command for ndctl to receive the key
 encryption key (master)
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 17, 2019 at 6:38 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Add command that allows the user to provide the master encryption key name
> to be installed in the key material directory where ndctl can refer to
> for later security operations.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/Makefile.am                   |    3
>  Documentation/ndctl/ndctl-install-encrypt-key.txt |   31 +++++
>  configure.ac                                      |    3
>  ndctl/Makefile.am                                 |    4 -
>  ndctl/builtin.h                                   |    1
>  ndctl/kek.c                                       |  133 +++++++++++++++++++++
>  ndctl/lib/libndctl.c                              |   31 +++++
>  ndctl/lib/libndctl.sym                            |    1
>  ndctl/lib/private.h                               |    1
>  ndctl/libndctl.h                                  |    1
>  ndctl/ndctl.c                                     |    1
>  11 files changed, 208 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/ndctl/ndctl-install-encrypt-key.txt
>  create mode 100644 ndctl/kek.c
>
> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> index a30b139b..7cb7bd6b 100644
> --- a/Documentation/ndctl/Makefile.am
> +++ b/Documentation/ndctl/Makefile.am
> @@ -47,7 +47,8 @@ man1_MANS = \
>         ndctl-inject-smart.1 \
>         ndctl-update-firmware.1 \
>         ndctl-list.1 \
> -       ndctl-monitor.1
> +       ndctl-monitor.1 \
> +       ndctl-install-encrypt-key.1
>
>  CLEANFILES = $(man1_MANS)
>
> diff --git a/Documentation/ndctl/ndctl-install-encrypt-key.txt b/Documentation/ndctl/ndctl-install-encrypt-key.txt
> new file mode 100644
> index 00000000..d00463e3
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-install-encrypt-key.txt
> @@ -0,0 +1,31 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +ndctl-install-encrypt-key(1)
> +============================
> +
> +NAME
> +----
> +ndctl-install-encrypt-key - store encryption key name for nvdimm bus
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl install-encrypt-key <ndbus0> [<ndbus1>..<ndbusN>] [-k <master encryption key] [<options>]
> +
> +Take the provided master encryption key handle and store it in a file that
> +A file would be created for the designated bus provider.
> +i.e. /etc/ndctl/keys/nfit_test.0.kek
> +The command only succeeds on bus(es) that contain nvdimms with security support.
> +
> +OPTIONS
> +-------
> +-k::
> +--kek=::
> +       Key encryption key (master key) handle. The key handle has the format
> +       of <key type>:<key name>. i.e. trusted:nvdimm-master.
> +
> +-v::
> +--verbose::
> +       Turn on debug output
> +
> +include::../copyright.txt[]
> diff --git a/configure.ac b/configure.ac
> index a02a2d80..61e91e0a 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -159,6 +159,9 @@ ndctl_monitorconf=monitor.conf
>  AC_SUBST([ndctl_monitorconfdir])
>  AC_SUBST([ndctl_monitorconf])
>
> +ndctl_keysdir=${sysconfdir}/ndctl/keys
> +AC_SUBST([ndctl_keysdir])
> +
>  my_CFLAGS="\
>  -Wall \
>  -Wchar-subscripts \
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index 97de1814..e412dbf7 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -8,6 +8,7 @@ config.h: Makefile.am
>         $(AM_V_GEN) echo "/* Autogenerated by ndctl/Makefile.am */" >$@
>         $(AM_V_GEN) echo '#define NDCTL_CONF_FILE \
>                 "$(ndctl_monitorconfdir)/$(ndctl_monitorconf)"' >>$@
> +       $(AM_V_GEN) echo '#define NDCTL_KEYS_DIR  "$(ndctl_keysdir)"' >>$@
>
>  ndctl_SOURCES = ndctl.c \
>                 bus.c \
> @@ -23,7 +24,8 @@ ndctl_SOURCES = ndctl.c \
>                 util/json-firmware.c \
>                 inject-error.c \
>                 inject-smart.c \
> -               monitor.c
> +               monitor.c \
> +               kek.c
>
>  if ENABLE_DESTRUCTIVE
>  ndctl_SOURCES += ../test/blk_namespaces.c \
> diff --git a/ndctl/builtin.h b/ndctl/builtin.h
> index 17300df0..4af34f04 100644
> --- a/ndctl/builtin.h
> +++ b/ndctl/builtin.h
> @@ -32,4 +32,5 @@ int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx);
>  #endif
>  int cmd_update_firmware(int argc, const char **argv, struct ndctl_ctx *ctx);
>  int cmd_inject_smart(int argc, const char **argv, struct ndctl_ctx *ctx);
> +int cmd_install_kek(int argc, const char **argv, struct ndctl_ctx *ctx);
>  #endif /* _NDCTL_BUILTIN_H_ */
> diff --git a/ndctl/kek.c b/ndctl/kek.c
> new file mode 100644
> index 00000000..1cb1555e
> --- /dev/null
> +++ b/ndctl/kek.c
> @@ -0,0 +1,133 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2019 Intel Corporation. All rights reserved. */
> +
> +#include <stdio.h>
> +#include <errno.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <limits.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <dirent.h>
> +#include <fcntl.h>
> +#include <util/json.h>
> +#include <util/filter.h>
> +#include <util/log.h>
> +#include <json-c/json.h>
> +#include <ndctl/config.h>
> +#include <ndctl/libndctl.h>
> +#include <util/parse-options.h>
> +#include <ccan/array_size/array_size.h>
> +
> +#include <ndctl.h>
> +
> +static struct parameters {
> +       const char *kek;
> +       bool verbose;
> +} param;
> +
> +static int store_kek(const char *provider, const char *kek)
> +{
> +       char path[PATH_MAX];
> +       FILE *fp;
> +       ssize_t rc, wrote = 0;
> +       int size = strlen(kek);
> +
> +       rc = sprintf(path, "%s/%s.kek", NDCTL_KEYS_DIR, provider);
> +       if (rc < 0) {
> +               perror("sprintf kek path failed");
> +               return rc;
> +       }
> +
> +       fp = fopen(path, "w+");
> +       if (!fp) {
> +               fprintf(stderr, "Opening file %s failed: %s\n",
> +                               path, strerror(errno));
> +               return -errno;
> +       }
> +
> +       do {
> +               rc = fwrite(kek + wrote, 1, size - wrote, fp);
> +               if (rc < 0) {
> +                       fprintf(stderr, "writing file %s failed: %s\n",
> +                                       path, strerror(errno));
> +                       fclose(fp);
> +                       return -errno;
> +               }
> +               wrote += rc;
> +       } while (wrote != size);
> +
> +       fclose(fp);
> +       printf("key handle %s installed to %s\n", kek, path);
> +       return 0;

So the format of this file is just name it by the bus provider and
store the flat key name inside? That would seem to make supporting a
key per-dimm more complicated in the future.

It would be nice to steal the git config file handling since it could
do something like this:

[ key "<description>" ]
    bus = <provider>
    dimm = <dimm unique-id>
    file = <path to key data>

Where multiple keys can be recorded by unique descriptions and the
properties can be used as a match spec to scope that key to a set of
DIMMs. For example a system-wide master key

[ key "system-master" ]
    bus = all
    file = key.blob

...and the following would identify a kek for a single dimm.

[ key "dimm0" ]
    dimm = "8680-57341200"
    file = key.blob

...the roadblock of course being how easy (or not easy) it is to steal
the config file capabilities from git.

Too complicated? Other ideas?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
