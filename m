Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0635D3FC9
	for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 22:54:38 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id bg1so4853443plb.13
        for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 15:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+qhTwHNWzI1qz81105Sp4ZLAYylBlQEASLUkiy3lW5o=;
        b=HNE1GkM9DjFxZBcAwfYisCz+qpqPDKM4a8o/zvqkSxZy42z7f1GPp3qu73GW2XPQ4A
         n9VbBKmHoh5pLtjyfFJ71PAEeYXKqjbCdVOeBXm+QVcznOP+UMlPPqFpYOcDMStkOO/h
         84IbzJYXKQs2ueFWYIEpUKbuOn+TAsb+Ac4fK6f6FL13/2B4sJPlw/4+lXKAkOtASYRA
         E/nFWISmMsZKkP4qpKStLuWCRNkjqY/NAOqnLhAXM40vd34zP21+6eeVo8tNa5Xxd/La
         h5pExLjy0vCGPaelve59EscqFAxlRQJW9L3bd+V5D9MCglYKez9lgAiApZTHMc5ra+SO
         hN7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+qhTwHNWzI1qz81105Sp4ZLAYylBlQEASLUkiy3lW5o=;
        b=V2accYY8fGV7XZBB3UmtiWFw3BGdDh1lHHmsvtZEgHKLVF45SWySrRgH5DSgO42302
         IgiDbejAun2BkBhOZlwWb1whDUHgdOAKqIbbfToIuKJTLbhcANeC90FV00GaSax60p6j
         ozgSnfHHfGryNONz6qvig/WSNNUVcsMgL4QivjAUhpeyo3oxEV5dH0FKtpDHdyX3wkO/
         wPEcbe0BZ08SZ786RLAN0pGoWqGKfVHQPWE7QZwT8d3OcjH/dn8cMRNXOhCzQ+87nL37
         eKgudOSK72px5se/c10MJTnRjA30CmpIKUP+FAlDckjONmQ2Pwrnv8nO7qg5/4da2q1K
         8Jeg==
X-Gm-Message-State: AOAM533PKQ+PWWIsQd4ukhJj+076WoLQF/hQnq4FONyY9Buw3wMIZ1f3
	rQ7SomEMAO95wvIfHT60gfZPCySz8QMtHsHcxgFWwL89OoM=
X-Google-Smtp-Source: ABdhPJz5+GEh75idCWfwp1nkduPn8SPDA79QtrOAsArCl8ll4v/SdI6a2ixtL2xDyCALSVG2Aw3iia4GQs5YRrNG3N0=
X-Received: by 2002:a17:902:bd8d:b0:13a:8c8:a2b2 with SMTP id
 q13-20020a170902bd8d00b0013a08c8a2b2mr6771809pls.89.1631832878449; Thu, 16
 Sep 2021 15:54:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210831090459.2306727-1-vishal.l.verma@intel.com> <20210831090459.2306727-4-vishal.l.verma@intel.com>
In-Reply-To: <20210831090459.2306727-4-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Sep 2021 15:54:27 -0700
Message-ID: <CAPcyv4jbFk94mjXES+3v2FaHhoxKnxfjziyPEbWQLcw683OVwg@mail.gmail.com>
Subject: Re: [ndctl PATCH 3/7] util/parse-config: refactor filter_conf_files
 into util/
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 31, 2021 at 2:05 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Move filter_conf() into util/parse-configs.c as filter_conf_files() so
> that it can be reused by the config parser in daxctl.
>
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/lib/libndctl.c   | 19 ++-----------------
>  util/parse-configs.h   |  4 ++++
>  util/parse-configs.c   | 16 ++++++++++++++++
>  daxctl/lib/Makefile.am |  2 ++
>  ndctl/lib/Makefile.am  |  2 ++
>  5 files changed, 26 insertions(+), 17 deletions(-)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index db2e38b..a01ac80 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -25,6 +25,7 @@
>  #include <util/size.h>
>  #include <util/sysfs.h>
>  #include <util/strbuf.h>
> +#include <util/parse-configs.h>
>  #include <ndctl/libndctl.h>
>  #include <ndctl/namespace.h>
>  #include <daxctl/libdaxctl.h>
> @@ -266,22 +267,6 @@ NDCTL_EXPORT void ndctl_set_userdata(struct ndctl_ctx *ctx, void *userdata)
>         ctx->userdata = userdata;
>  }
>
> -static int filter_conf(const struct dirent *dir)
> -{
> -       if (!dir)
> -               return 0;
> -
> -       if (dir->d_type == DT_REG) {
> -               const char *ext = strrchr(dir->d_name, '.');
> -               if ((!ext) || (ext == dir->d_name))
> -                       return 0;
> -               if (strcmp(ext, ".conf") == 0)
> -                       return 1;
> -       }
> -
> -       return 0;
> -}
> -
>  NDCTL_EXPORT void ndctl_set_configs(struct ndctl_ctx **ctx, char *conf_dir)
>  {
>         struct dirent **namelist;
> @@ -291,7 +276,7 @@ NDCTL_EXPORT void ndctl_set_configs(struct ndctl_ctx **ctx, char *conf_dir)
>         if ((!ctx) || (!conf_dir))
>                 return;
>
> -       rc = scandir(conf_dir, &namelist, filter_conf, alphasort);
> +       rc = scandir(conf_dir, &namelist, filter_conf_files, alphasort);
>         if (rc == -1) {
>                 perror("scandir");
>                 return;
> diff --git a/util/parse-configs.h b/util/parse-configs.h
> index f70f58f..491aebb 100644
> --- a/util/parse-configs.h
> +++ b/util/parse-configs.h
> @@ -1,8 +1,10 @@
>  // SPDX-License-Identifier: GPL-2.0
>  // Copyright (C) 2021, FUJITSU LIMITED. ALL rights reserved.
>
> +#include <dirent.h>
>  #include <stdbool.h>
>  #include <stdint.h>
> +#include <string.h>
>  #include <util/util.h>
>
>  enum parse_conf_type {
> @@ -11,6 +13,8 @@ enum parse_conf_type {
>         MONITOR_CALLBACK,
>  };
>
> +int filter_conf_files(const struct dirent *dir);
> +
>  struct config;
>  typedef int parse_conf_cb(const struct config *, const char *config_file);
>
> diff --git a/util/parse-configs.c b/util/parse-configs.c
> index 44dcff4..72c4913 100644
> --- a/util/parse-configs.c
> +++ b/util/parse-configs.c
> @@ -6,6 +6,22 @@
>  #include <util/strbuf.h>
>  #include <util/iniparser.h>
>
> +int filter_conf_files(const struct dirent *dir)
> +{
> +       if (!dir)
> +               return 0;
> +
> +       if (dir->d_type == DT_REG) {
> +               const char *ext = strrchr(dir->d_name, '.');

Darn, I guess clang-format does not know how to do line-break after
declarations, but... line break after declarations please. Otherwise
it looks good.

> +               if ((!ext) || (ext == dir->d_name))
> +                       return 0;
> +               if (strcmp(ext, ".conf") == 0)
> +                       return 1;
> +       }
> +
> +       return 0;
> +}
> +
>  static void set_str_val(const char **value, const char *val)
>  {
>         struct strbuf buf = STRBUF_INIT;
> diff --git a/daxctl/lib/Makefile.am b/daxctl/lib/Makefile.am
> index 25efd83..db2351e 100644
> --- a/daxctl/lib/Makefile.am
> +++ b/daxctl/lib/Makefile.am
> @@ -15,6 +15,8 @@ libdaxctl_la_SOURCES =\
>         ../../util/sysfs.h \
>         ../../util/log.c \
>         ../../util/log.h \
> +       ../../util/parse-configs.h \
> +       ../../util/parse-configs.c \
>         libdaxctl.c
>
>  libdaxctl_la_LIBADD =\
> diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
> index f741c44..8020eb4 100644
> --- a/ndctl/lib/Makefile.am
> +++ b/ndctl/lib/Makefile.am
> @@ -19,6 +19,8 @@ libndctl_la_SOURCES =\
>         ../../util/wrapper.c \
>         ../../util/usage.c \
>         ../../util/fletcher.h \
> +       ../../util/parse-configs.h \
> +       ../../util/parse-configs.c \
>         dimm.c \
>         inject.c \
>         nfit.c \
> --
> 2.31.1
>
