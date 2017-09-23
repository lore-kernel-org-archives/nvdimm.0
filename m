Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2361E21E43B49
 for <linux-nvdimm@lists.01.org>; Sat, 23 Sep 2017 10:19:48 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id f195so2288325oih.8
 for <linux-nvdimm@lists.01.org>; Sat, 23 Sep 2017 10:22:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3222756C8F7@g01jpexmbkw01>
References: <0DEDF3B159719A448A49EF0E7B11E3222756C8F7@g01jpexmbkw01>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Sep 2017 10:22:56 -0700
Message-ID: <CAPcyv4jE-G-JG=RZwjsCCuBu=0HOrdVjujCqynjCC9X9KjY1FA@mail.gmail.com>
Subject: Re: [RFC patch 2/4]ndctl: nvdimmd: notify/monitor the feathers of
 over threshold event
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
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 31, 2017 at 6:46 PM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
> Nvdimmd.c is the body file of nvdimm daemon. Currently, it writes a log which includes
> notified dimm's name and spare percentage.
>
> Sign-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
>
> ---
> nvdimmd/Makefile  | 10 +++++-
> nvdimmd/nvdimmd.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 106 insertions(+), 1 deletion(-)
> diff --git a/nvdimmd/Makefile b/nvdimmd/Makefile
> index a20a747..3908e5d 100644
> --- a/nvdimmd/Makefile
> +++ b/nvdimmd/Makefile
> @@ -1,7 +1,15 @@
>  CC             = gcc
> +LIBS           = -ludev -luuid -lkmod
> +OBJS           = ../ndctl/lib/.libs/libndctl.o ../daxctl/lib/.libs/libdaxctl.o ../util/.libs/sysfs.o ../util/.libs/log.o ../ndctl/lib/.libs/libndctl-smart.o
>  IDIR           = -I../ -I../ndctl
> +PROGRAM        = nvdimmd
>
> +all:           $(PROGRAM)
> +nvdimmd:       $(OBJS) nvdimmd.o libnvdimmd.o
> +                       $(CC) $(OBJS) nvdimmd.o libnvdimmd.o $(LIBS) $(IDIR) -o nvdimmd
>  libnvdimmd.o:  libnvdimmd.c
>                         $(CC) -o libnvdimmd.o $(IDIR) -c libnvdimmd.c
> +nvdimmd.o:     nvdimmd.c
> +                       $(CC) -o nvdimmd.o $(IDIR) -c nvdimmd.c
>  clean:
> -                       rm -rf *.o
> +                       rm -rf *.o $(PROGRAM)
> diff --git a/nvdimmd/nvdimmd.c b/nvdimmd/nvdimmd.c
> new file mode 100644
> index 0000000..cdf78c8
> --- /dev/null
> +++ b/nvdimmd/nvdimmd.c
> @@ -0,0 +1,97 @@
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
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <signal.h>
> +#include <sys/stat.h>
> +#include <syslog.h>
> +#include <ndctl/libndctl.h>
> +#include "libnvdimmd.h"
> +
> +int wait_threshold_notify()
> +{
> +       struct ndctl_ctx *ctx;
> +       int rc, maxfd, count_dimm;
> +       threshold_dimm *t_dimm;
> +
> +       rc = ndctl_new(&ctx);
> +       if (rc){
> +               syslog(LOG_ERR, "nvdimmd error: failed to instantiate context");
> +               goto out;
> +       }
> +
> +       t_dimm = calloc(NUM_MAX_DIMM, sizeof(threshold_dimm));

I think the DIMMs to monitor should be configurable, via a config
file, with the same filters that util_dimm_filter() recognizes which
also means we should allow limiting the set of DIMMs by parent bus as
well.

Another note is that we also want to monitor Region devices to capture
un-correctable error notifications and log messages about which
namespaces are impacted by that error.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
