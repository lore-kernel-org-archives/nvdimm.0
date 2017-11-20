Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 44C762034C5F7
 for <linux-nvdimm@lists.01.org>; Mon, 20 Nov 2017 13:26:58 -0800 (PST)
Received: by mail-oi0-x244.google.com with SMTP id b189so7158248oia.5
 for <linux-nvdimm@lists.01.org>; Mon, 20 Nov 2017 13:31:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171114074704.3446-5-qi.fuli@jp.fujitsu.com>
References: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
 <20171114074704.3446-5-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 20 Nov 2017 13:31:11 -0800
Message-ID: <CAPcyv4g==MpHQ6uHqUvKAA5dMGJAnkodvttWWx4Btyp+j+=D9g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/7] ndctl: nvdimmd: add body file of nvdimm daemon
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
To: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 13, 2017 at 11:47 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> This patch adds the body file of nvdimm daemon and compiles nvdimmd
> with automake.
>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  Makefile.am         |   2 +-
>  configure.ac        |   1 +
>  nvdimmd/Makefile.am |  19 +++++++++
>  nvdimmd/nvdimmd.c   | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 133 insertions(+), 1 deletion(-)
>  create mode 100644 nvdimmd/Makefile.am
>  create mode 100644 nvdimmd/nvdimmd.c
>
> diff --git a/Makefile.am b/Makefile.am
> index b538b1f..ff91439 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -1,7 +1,7 @@
>  include Makefile.am.in
>
>  ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
> -SUBDIRS = . daxctl/lib ndctl/lib ndctl daxctl
> +SUBDIRS = . daxctl/lib ndctl/lib ndctl daxctl nvdimmd
>  if ENABLE_DOCS
>  SUBDIRS += Documentation/ndctl Documentation/daxctl
>  endif
> diff --git a/configure.ac b/configure.ac
> index 5b10381..3ce71e3 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -274,6 +274,7 @@ AC_CONFIG_FILES([
>          daxctl/lib/Makefile
>          ndctl/lib/Makefile
>          ndctl/Makefile
> +       nvdimmd/Makefile
>          daxctl/Makefile
>          test/Makefile
>          Documentation/ndctl/Makefile
> diff --git a/nvdimmd/Makefile.am b/nvdimmd/Makefile.am
> new file mode 100644
> index 0000000..9883edd
> --- /dev/null
> +++ b/nvdimmd/Makefile.am
> @@ -0,0 +1,19 @@
> +include $(top_srcdir)/Makefile.am.in
> +
> +bin_PROGRAMS = nvdimmd
> +
> +nvdimmd_SOURCES =\
> +               nvdimmd.c \
> +               libnvdimmd.c \
> +               util.c \
> +               ../util/log.c \
> +               ../util/json.c \
> +               ../ndctl/util/json-smart.c
> +
> +nvdimmd_LDADD = ../ndctl/lib/libndctl.la \
> +               ../daxctl/lib/libdaxctl.la \
> +               ../libutil.a \
> +               $(KMOD_LIBS) \
> +               $(JSON_LIBS) \
> +               $(UUID_LIBS) \
> +               $(UDEV_LIBS)
> diff --git a/nvdimmd/nvdimmd.c b/nvdimmd/nvdimmd.c
> new file mode 100644
> index 0000000..f451751
> --- /dev/null
> +++ b/nvdimmd/nvdimmd.c
> @@ -0,0 +1,112 @@
> +/*
> + * Copyright (c) 2017, FUJITSU LIMITED. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU Lesser General Public License,
> + * version 2.1, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT ANY
> + * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
> + * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for
> + * more details.
> + */
> +
> +/*
> + * Nvdimm daemon is used to monitor the features of over threshold events.
> + * It automatically searches and monitors all of the dimms which support smart
> + * threshold. When an over threshold event fires, it will write a notification
> + * into the system log.
> + */
> +
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <signal.h>
> +#include <sys/stat.h>
> +#include <syslog.h>
> +#include <errno.h>
> +#include <ndctl/lib/private.h>
> +#include "libnvdimmd.h"
> +
> +static int wait_threshold_notify(struct ndctl_ctx *ctx)
> +{
> +       int rc, maxfd, cnt_dimm;
> +       struct threshold_dimm *t_dimm;
> +
> +       t_dimm = calloc(NUM_MAX_DIMM, sizeof(struct threshold_dimm));
> +       if (!t_dimm) {
> +               err(ctx, "t_dimm memory not allocated");
> +               goto out;
> +       }
> +
> +       fd_set fds;
> +       FD_ZERO(&fds);
> +
> +       cnt_dimm = get_threshold_dimm(ctx, t_dimm, &fds, &maxfd);
> +       if (cnt_dimm == 0) {
> +               err(ctx, "no dimm supports over threshold notification\n");
> +               goto out;
> +       }
> +
> +       rc = select(maxfd + 1, NULL, NULL, &fds, NULL);
> +       if (rc < 1) {
> +               if (rc == 0)
> +                       err(ctx, "select unexpected timeout\n");
> +               else
> +                       err(ctx, "select %s\n", strerror(errno));
> +               goto out;
> +       }
> +
> +       log_notify(ctx, t_dimm, cnt_dimm, fds, rc);
> +
> +       free(t_dimm);
> +       return 0;
> +
> +out:
> +       return 1;
> +}
> +
> +static void nvdimmd_log_init(struct ndctl_ctx *ctx, int priority,
> +                               const char *owner, const char *log_env)
> +{
> +       log_init(&ctx->ctx, owner, log_env);
> +       ndctl_set_log_priority(ctx, priority);
> +       if (strcmp(nvdimmd_cf->logfile, "syslog") == 0)
> +               ndctl_set_log_fn(ctx, log_syslog);
> +       else
> +               ndctl_set_log_fn(ctx, log_file);
> +}
> +
> +int main(void)
> +{
> +       if (daemon(0, 0) != 0) {
> +               syslog(LOG_ERR, "nvdimmd error: daemon start failed\n");
> +               exit(EXIT_FAILURE);
> +       }
> +       struct ndctl_ctx *ctx;
> +       int rc, ret = 0;
> +       const char *conf_path = "/etc/nvdimmd/nvdimmd.conf";
> +
> +       syslog(LOG_INFO, "nvdimmd: started\n");
> +
> +       if (get_nvdimmd_conf(conf_path) != 0) {
> +               syslog(LOG_ERR, "nvdimmd.conf error \n");
> +               goto out;
> +       }
> +
> +       while (ret == 0) {
> +               rc = ndctl_new(&ctx);
> +               if (rc)
> +                       goto out;
> +
> +               nvdimmd_log_init(ctx, LOG_NOTICE, "nvdimmd", "NVDIMMD_LOG");
> +               ret = wait_threshold_notify(ctx);
> +               ndctl_unref(ctx);

We shouldn't need to setup and teardown the ndctl_ctx after each wake up.

In general I think we need to start with the end result of what data
and events do want to emit and have in the logs and then work
backwards from there. I think the first step is define a set of event
names and event record details.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
