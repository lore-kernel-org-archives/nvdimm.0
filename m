Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583B22CAE
	for <nvdimm@lists.linux.dev>; Tue,  7 Dec 2021 21:58:38 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id n26so681229pff.3
        for <nvdimm@lists.linux.dev>; Tue, 07 Dec 2021 13:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AN8fkQj3c8sF5it94tGphse77hNSbQrJvSxkKUkfmxc=;
        b=029MlLB1uvoy2JpQaIbS3ZxhztOJZ0HVduRzQlnFQgqaWeF4fXYyJynauRbCBrD9sj
         kpigDKx/61sxBJ1xTpifLjVpck0owcj4dFPzGvE7B4C9sXhnYoim1myiUNW5Pa11d5sI
         3jsIBgGkS3Gfd1oEeWTAbhYkobN3kMxOuyqnhfLXhhxRZlDi9aB51/YfZUf5PpxTVh+F
         PgCN2yXK9WJONaOs4yknd+OAA5IC2T2FY6BI7Y4fIRb4PZz3Oz3pAuyyKmUDQOSUY+ee
         SYFscmouZ+Jq+cRBgOkvKCT9UBiMiVtQwou7ooDGYh5oPPtnBTrDw9P30sL1Eo+bKOCQ
         AvdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AN8fkQj3c8sF5it94tGphse77hNSbQrJvSxkKUkfmxc=;
        b=tLs1UE7riag2awJkQZt682v7nkgWgR4NEiyphhMIRdsCw3JisX2wI5k3wkXRtVx3PQ
         9v6RAeKGgqGZ3K0Lj6Qb8c+K4lzVVHLU2NHGN1VWW+yr/ZAM98ku+G4FkH2p8AuMCGBy
         ax68VLotl+ZDnJAMNtFuvi4mFBzG/8eBhtr5hk7L8djLwvh5xwXHuucoTIv4i9TNKK0b
         7MZtGxDiVfO61j375Zd5SJgduWnjgNxpHYKvu5hk4QMjpnO3mG2NMsQHBPfW23LHRMM+
         RNcLRtM29kC2Cyst9u62El/zgUSOeY78a82QcuL1t1gKE2XboKoYw37BxUNLBSYJATYB
         rTtA==
X-Gm-Message-State: AOAM530cxrIu3vdZ2WSecb17ZU/WVLyo1dlz0V5FoX3PJwP0/pTE7LS+
	dYwqV07NxFcM20rsnzanrEQdLCPleErZ9137/ELGFQ==
X-Google-Smtp-Source: ABdhPJxD7zTx+HFtbQe/+suFVfX3tvU7EYYZt9o/7i3Gij8OiIFHpPorO/V46RW3Kb5xfxmZU1nUDBwdTvOxNeRTMuQ=
X-Received: by 2002:a63:658:: with SMTP id 85mr25861161pgg.437.1638914317626;
 Tue, 07 Dec 2021 13:58:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211206222830.2266018-1-vishal.l.verma@intel.com> <20211206222830.2266018-3-vishal.l.verma@intel.com>
In-Reply-To: <20211206222830.2266018-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Dec 2021 13:58:27 -0800
Message-ID: <CAPcyv4j8oAioQKd8rO9mqZ5hHXbMyrwmwvJh5prCTi+N=mULig@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 02/12] ndctl, util: add parse-configs helper
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 6, 2021 at 2:28 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> From: QI Fuli <qi.fuli@fujitsu.com>
>
> Add parse-config util to help ndctl commands parse ndctl global
> configuration files.

Can this add a bit more description / quick summary of how these APIs are used?

>
> Link: https://lore.kernel.org/r/20210824095106.104808-3-qi.fuli@fujitsu.com

This link is pointing to the original posting I would expect that this
gets deleted and replaced with the final Link: to the version of the
patch that eventually gets applied. I assume you just pulled the
patches down and this link get appended in the resend.

> Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Makefile.am          |  2 ++
>  util/parse-configs.h | 34 ++++++++++++++++++
>  util/parse-configs.c | 82 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 118 insertions(+)
>  create mode 100644 util/parse-configs.h
>  create mode 100644 util/parse-configs.c
>
> diff --git a/Makefile.am b/Makefile.am
> index 235c362..af55f0e 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -70,6 +70,8 @@ noinst_LIBRARIES += libutil.a
>  libutil_a_SOURCES = \
>         util/parse-options.c \
>         util/parse-options.h \
> +       util/parse-configs.c \
> +       util/parse-configs.h \
>         util/usage.c \
>         util/size.c \
>         util/main.c \
> diff --git a/util/parse-configs.h b/util/parse-configs.h
> new file mode 100644
> index 0000000..f70f58f
> --- /dev/null
> +++ b/util/parse-configs.h
> @@ -0,0 +1,34 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2021, FUJITSU LIMITED. ALL rights reserved.
> +
> +#include <stdbool.h>
> +#include <stdint.h>
> +#include <util/util.h>
> +
> +enum parse_conf_type {
> +       CONFIG_STRING,
> +       CONFIG_END,
> +       MONITOR_CALLBACK,
> +};
> +
> +struct config;
> +typedef int parse_conf_cb(const struct config *, const char *config_file);
> +
> +struct config {
> +       enum parse_conf_type type;
> +       const char *key;
> +       void *value;
> +       void *defval;
> +       parse_conf_cb *callback;
> +};
> +
> +#define check_vtype(v, type) ( BUILD_BUG_ON_ZERO(!__builtin_types_compatible_p(typeof(v), type)) + v )
> +
> +#define CONF_END() { .type = CONFIG_END }
> +#define CONF_STR(k,v,d) \
> +       { .type = CONFIG_STRING, .key = (k), .value = check_vtype(v, const char **), .defval = (d) }
> +#define CONF_MONITOR(k,f) \
> +       { .type = MONITOR_CALLBACK, .key = (k), .callback = (f)}
> +
> +int parse_configs_prefix(const char *__config_file, const char *prefix,
> +                               const struct config *configs);
> diff --git a/util/parse-configs.c b/util/parse-configs.c
> new file mode 100644
> index 0000000..44dcff4
> --- /dev/null
> +++ b/util/parse-configs.c
> @@ -0,0 +1,82 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2021, FUJITSU LIMITED. ALL rights reserved.
> +
> +#include <errno.h>
> +#include <util/parse-configs.h>
> +#include <util/strbuf.h>
> +#include <util/iniparser.h>
> +
> +static void set_str_val(const char **value, const char *val)
> +{
> +       struct strbuf buf = STRBUF_INIT;
> +       size_t len = *value ? strlen(*value) : 0;
> +
> +       if (!val)
> +               return;
> +
> +       if (len) {
> +               strbuf_add(&buf, *value, len);
> +               strbuf_addstr(&buf, " ");
> +       }
> +       strbuf_addstr(&buf, val);
> +       *value = strbuf_detach(&buf, NULL);
> +}
> +
> +static int parse_config_file(const char *config_file,
> +                       const struct config *configs)
> +{
> +       dictionary *dic;
> +
> +       dic = iniparser_load(config_file);
> +       if (!dic)
> +               return -errno;
> +
> +       for (; configs->type != CONFIG_END; configs++) {
> +               switch (configs->type) {
> +               case CONFIG_STRING:
> +                       set_str_val((const char **)configs->value,
> +                                       iniparser_getstring(dic,
> +                                       configs->key, configs->defval));
> +                       break;
> +               case MONITOR_CALLBACK:
> +               case CONFIG_END:
> +                       break;
> +               }
> +       }
> +
> +       iniparser_freedict(dic);
> +       return 0;
> +}
> +
> +int parse_configs_prefix(const char *__config_files, const char *prefix,
> +                               const struct config *configs)
> +{
> +       char *config_files, *save;
> +       const char *config_file;
> +       int rc;
> +
> +       config_files = strdup(__config_files);
> +       if (!config_files)
> +               return -ENOMEM;
> +
> +       for (config_file = strtok_r(config_files, " ", &save); config_file;
> +                               config_file = strtok_r(NULL, " ", &save)) {
> +
> +               if (strncmp(config_file, "./", 2) != 0)
> +                       fix_filename(prefix, &config_file);
> +
> +               if ((configs->type == MONITOR_CALLBACK) &&
> +                               (strcmp(config_file, configs->key) == 0))
> +                       rc = configs->callback(configs, configs->key);
> +               else
> +                       rc = parse_config_file(config_file, configs);
> +
> +               if (rc)
> +                       goto end;
> +       }
> +
> + end:
> +       free(config_files);
> +       return rc;
> +
> +}
> --
> 2.33.1
>
