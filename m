Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134D929CA
	for <nvdimm@lists.linux.dev>; Wed,  8 Dec 2021 16:01:37 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so4638528pjb.5
        for <nvdimm@lists.linux.dev>; Wed, 08 Dec 2021 08:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jgfzLk1Aj0K+lAAQK/5g17X42GwOjOcMGfjVdRZmhB8=;
        b=hk9Qxvt1sF11Hcn9XA97OZJSNRTa5+7k6AO9Fc2jYTV55u+BahrIwGm/fII83k8hRu
         UWBejUR+3mQ9NhKegyGVVI+qDcslYDsgHpoavLuhi7AorGYP8rXvb93BChsxjzmAkpVg
         T28pS+XgCpigolnDHVK/dfGNmEuyOww+zVhhaNiKMLFgS4tWbap+ck3lPc1zMY+T0PkB
         mVWaspUISsiJTETVLIFGh3W2bHkJCuBh6vCcrPAygKcOEoAl1YLgdg5RXu0+clZhKDTl
         SdWGt7lR0JZPQ/Tirv6jLff6cbOZxsWkg2UjxpZEgHpMZ/UcbsEnSPwP2QLVHsknT7fR
         fpeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jgfzLk1Aj0K+lAAQK/5g17X42GwOjOcMGfjVdRZmhB8=;
        b=GIF8SBD0jtlFM187Q+w2S1dz+wEf2cavxwvIbTGnkLskwF7Ms9eik4+QgUhdl4JKAS
         FNcgiujQHZmPFCUbeTAeU9JCtUylGIiSOj2uGeUN8UU9k0a2ln6nKdMTLZ5O0iwHikXV
         HSnHfm2YyY61p5YklyWWAozLN2xpEH9krlGHxo7Q2Fn49Nterxaj4BSNj2Tzy/9kWHgI
         RVPhHOj239RBz3mDpKuBPWy+A59VpUyrqY7zACTCdGMc0EaxJXtq1URzWRntq6mIMCmq
         6DHuRBruEpiCuM2zTlmm2kEJ61sbGRfMualew+zsIIszjalCA4yovb9gtw/U+vMbOAmy
         wk1Q==
X-Gm-Message-State: AOAM531pJyDB6LbDD+ehMB/WLVRl9715RycKxgPmu9fsCOJjnqLoq5uJ
	T87TjzO9XNxjmHFMmm4Skog6/gmAuY7yDpmfQy47TQ==
X-Google-Smtp-Source: ABdhPJyDBWmW/p/zczrjSP/LVdNxukGKpdTzOVb1qLZv8jnGpJtA4oyKbhuNOyd+a7FAy+aNaz1QSkOepgkTmRaz5xw=
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr8263428pjb.220.1638979296300;
 Wed, 08 Dec 2021 08:01:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211206222830.2266018-1-vishal.l.verma@intel.com> <20211206222830.2266018-6-vishal.l.verma@intel.com>
In-Reply-To: <20211206222830.2266018-6-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Dec 2021 08:00:00 -0800
Message-ID: <CAPcyv4iKrxGkj=yL7=YpcDjyYnsJA8J3Wzx9Q04zzjmw=hks6g@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 05/12] ndctl, monitor: refator monitor for
 supporting multiple config files
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 6, 2021 at 2:28 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> From: QI Fuli <qi.fuli@fujitsu.com>
>
> Refactor ndctl monitor by using parse-configs helper to support multiple
> configuration files.
>
> Link: https://lore.kernel.org/r/20210824095106.104808-6-qi.fuli@fujitsu.com
> Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Look ok to me, perhaps a global s/configs/config_path/, but otherwise:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> ---
>  Documentation/ndctl/ndctl-monitor.txt |  8 +--
>  ndctl/monitor.c                       | 73 ++++++++++++++-------------
>  Documentation/ndctl/Makefile.am       |  2 +-
>  3 files changed, 44 insertions(+), 39 deletions(-)
>
> diff --git a/Documentation/ndctl/ndctl-monitor.txt b/Documentation/ndctl/ndctl-monitor.txt
> index dbc9070..8c8c35b 100644
> --- a/Documentation/ndctl/ndctl-monitor.txt
> +++ b/Documentation/ndctl/ndctl-monitor.txt
> @@ -21,8 +21,8 @@ objects and dumping the json format notifications to syslog, standard
>  output or a logfile.
>
>  The objects to monitor and smart events to notify can be selected by
> -setting options and/or the configuration file at
> -{ndctl_monitorconfdir}/{ndctl_monitorconf}
> +setting options and/or configuration files with .conf suffix under
> +{ndctl_confdir}
>
>  Both, the values in configuration file and in options will work. If
>  there is a conflict, the values in options will override the values in
> @@ -81,8 +81,8 @@ will not work if "--daemon" is specified.
>
>  -c::
>  --config-file=::
> -       Provide the config file to use. This overrides the default config
> -       typically found in {ndctl_monitorconfdir}
> +       Provide the config file(s) to use. This overrides the default config
> +       typically found in {ndctl_confdir}
>
>  --daemon::
>         Run a monitor as a daemon.
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index ca36179..6bf3160 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -10,6 +10,7 @@
>  #include <util/filter.h>
>  #include <util/util.h>
>  #include <util/parse-options.h>
> +#include <util/parse-configs.h>
>  #include <util/strbuf.h>
>  #include <ndctl/config.h>
>  #include <ndctl/ndctl.h>
> @@ -28,7 +29,7 @@
>
>  static struct monitor {
>         const char *log;
> -       const char *config_file;
> +       const char *configs;
>         const char *dimm_event;
>         FILE *log_file;
>         bool daemon;
> @@ -463,7 +464,7 @@ out:
>         return rc;
>  }
>
> -static void parse_config(const char **arg, char *key, char *val, char *ident)
> +static void set_monitor_conf(const char **arg, char *key, char *val, char *ident)
>  {
>         struct strbuf value = STRBUF_INIT;
>         size_t arg_len = *arg ? strlen(*arg) : 0;
> @@ -479,39 +480,25 @@ static void parse_config(const char **arg, char *key, char *val, char *ident)
>         *arg = strbuf_detach(&value, NULL);
>  }
>
> -static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
> -               struct util_filter_params *_param)
> +static int parse_monitor_config(const struct config *configs,
> +                                       const char *config_file)
>  {
>         FILE *f;
>         size_t len = 0;
>         int line = 0, rc = 0;
> -       char *buf = NULL, *seek, *value, *config_file;
> -
> -       if (_monitor->config_file)
> -               config_file = strdup(_monitor->config_file);
> -       else
> -               config_file = strdup(NDCTL_CONF_FILE);
> -       if (!config_file) {
> -               fail("strdup default config file failed\n");
> -               rc = -ENOMEM;
> -               goto out;
> -       }
> +       char *buf = NULL, *seek, *value;
>
>         buf = malloc(BUF_SIZE);
>         if (!buf) {
>                 fail("malloc read config-file buf error\n");
> -               rc = -ENOMEM;
> -               goto out;
> +               return -ENOMEM;
>         }
>         seek = buf;
>
>         f = fopen(config_file, "r");
>         if (!f) {
> -               if (_monitor->config_file) {
> -                       err(&monitor, "config-file: %s cannot be opened\n",
> -                               config_file);
> -                       rc = -errno;
> -               }
> +               err(&monitor, "%s cannot be opened\n", config_file);
> +               rc = -errno;
>                 goto out;
>         }
>
> @@ -554,19 +541,18 @@ static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
>                 if (len == 0)
>                         continue;
>
> -               parse_config(&_param->bus, "bus", value, seek);
> -               parse_config(&_param->dimm, "dimm", value, seek);
> -               parse_config(&_param->region, "region", value, seek);
> -               parse_config(&_param->namespace, "namespace", value, seek);
> -               parse_config(&_monitor->dimm_event, "dimm-event", value, seek);
> +               set_monitor_conf(&param.bus, "bus", value, seek);
> +               set_monitor_conf(&param.dimm, "dimm", value, seek);
> +               set_monitor_conf(&param.region, "region", value, seek);
> +               set_monitor_conf(&param.namespace, "namespace", value, seek);
> +               set_monitor_conf(&monitor.dimm_event, "dimm-event", value, seek);
>
> -               if (!_monitor->log)
> -                       parse_config(&_monitor->log, "log", value, seek);
> +               if (!monitor.log)
> +                       set_monitor_conf(&monitor.log, "log", value, seek);
>         }
>         fclose(f);
>  out:
>         free(buf);
> -       free(config_file);
>         return rc;
>  }
>
> @@ -585,8 +571,8 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
>                 OPT_FILENAME('l', "log", &monitor.log,
>                                 "<file> | syslog | standard",
>                                 "where to output the monitor's notification"),
> -               OPT_FILENAME('c', "config-file", &monitor.config_file,
> -                               "config-file", "override the default config"),
> +               OPT_STRING('c', "config-file", &monitor.configs,
> +                               "config-file", "override default configs"),
>                 OPT_BOOLEAN('\0', "daemon", &monitor.daemon,
>                                 "run ndctl monitor as a daemon"),
>                 OPT_BOOLEAN('u', "human", &monitor.human,
> @@ -601,7 +587,20 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
>                 "ndctl monitor [<options>]",
>                 NULL
>         };
> -       const char *prefix = "./";
> +       const struct config configs[] = {
> +               CONF_MONITOR(NDCTL_CONF_FILE, parse_monitor_config),
> +               CONF_STR("core:bus", &param.bus, NULL),
> +               CONF_STR("core:region", &param.region, NULL),
> +               CONF_STR("core:dimm", &param.dimm, NULL),
> +               CONF_STR("core:namespace", &param.namespace, NULL),
> +               CONF_STR("monitor:bus", &param.bus, NULL),
> +               CONF_STR("monitor:region", &param.region, NULL),
> +               CONF_STR("monitor:dimm", &param.dimm, NULL),
> +               CONF_STR("monitor:namespace", &param.namespace, NULL),
> +               CONF_STR("monitor:dimm-event", &monitor.dimm_event, NULL),
> +               CONF_END(),
> +       };
> +       const char *prefix = "./", *ndctl_configs;
>         struct util_filter_ctx fctx = { 0 };
>         struct monitor_filter_arg mfa = { 0 };
>         int i, rc;
> @@ -621,7 +620,13 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
>         else
>                 monitor.ctx.log_priority = LOG_INFO;
>
> -       rc = read_config_file(ctx, &monitor, &param);
> +       ndctl_configs = ndctl_get_configs_dir(ctx);
> +       if (monitor.configs)
> +               rc = parse_configs_prefix(monitor.configs, prefix, configs);
> +       else if (ndctl_configs)
> +               rc = parse_configs_prefix(ndctl_configs, prefix, configs);
> +       else
> +               rc = 0;
>         if (rc)
>                 goto out;
>
> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> index f0d5b21..37855cc 100644
> --- a/Documentation/ndctl/Makefile.am
> +++ b/Documentation/ndctl/Makefile.am
> @@ -59,7 +59,7 @@ CLEANFILES = $(man1_MANS)
>  .ONESHELL:
>  attrs.adoc: $(srcdir)/Makefile.am
>         $(AM_V_GEN) cat <<- EOF >$@
> -               :ndctl_monitorconfdir: $(ndctl_monitorconfdir)
> +               :ndctl_confdir: $(ndctl_confdir)
>                 :ndctl_monitorconf: $(ndctl_monitorconf)
>                 :ndctl_keysdir: $(ndctl_keysdir)
>                 EOF
> --
> 2.33.1
>
