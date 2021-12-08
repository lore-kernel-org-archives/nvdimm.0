Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89FD2C80
	for <nvdimm@lists.linux.dev>; Wed,  8 Dec 2021 16:01:13 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so4637562pjb.5
        for <nvdimm@lists.linux.dev>; Wed, 08 Dec 2021 08:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=87yT/jw6yNvdoUoXlpP3yYuTs2rploZUKb2uEqU+xwk=;
        b=XmMy+a9h2wP23NlYggYhuUs6BAG1sjpO0fP4JTeMoAHLY2P63Xzov5ccdUzsiidaDS
         HbJXLU3vx7vdSVR+WU2MWTTqlYtbGbS1lI2U3oP3gZfLUWTxps/EXxIevp5MGbbRvT5L
         Z/Ci3TI5xrYnriOfuxBKQU70n6ZNbUswxAr2efSXBA5650pZqyvwKB4OVoR/eblaNj90
         a/FK6+T3p0sU7liCBFNLiSemJcQVLUetr35pZ7QJaLFUoaGan/DZWjH/emTD9FIFtNVY
         JK4HgmmEkdijniW4S+0NcH6M39i4jPw5tOtUfO1ae+JJt2EcdZJWVjkRNu6yvD7yuvyv
         mdaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=87yT/jw6yNvdoUoXlpP3yYuTs2rploZUKb2uEqU+xwk=;
        b=27ewxRqUkFBVeQ4NUTxdBw+vQy+gWchavs1oFH6kQffUsSZCWVU3sLQeeKTUIQqDMD
         wKH1uxzknlTBbl/N2AX6+DALgrHUrVux78GltxsKbXdwORnd/Kt9CCDUEsrmIpux6jSR
         dxBaMWNkE8cshH1QzCvAUeE8ovzMpzdRL7PEgu2oA8czYm+TwFdQk6/7hOhs0XPrDEMZ
         C8w31aiR2YPv1BBAJvbV6vP6beApfzR2dNE26DSqcNO1ZFmk9wqrSbFbOjSLbjexrMyU
         Q1wQ4oM5zIAANTNmIjY/iORVLqznUrlqM8aU9DzMvSJmPc1dAwSez1lBKYcydmyW72lA
         /yiQ==
X-Gm-Message-State: AOAM530avRUE/4lc6EwU0cIaZ2sz6IrWOy/a5s8OA9CTsLPQ03GL7gQF
	0kfBaWtKSNRELgQy4mkFPkGJahRu6RkwVKiaLtYk/Q==
X-Google-Smtp-Source: ABdhPJw2xEhva6oqYAqESWiFZP3U0AogW+yXW9YJyXvJyw8Ek0ZJFYCIm7ZSLNyGhbMgIJsmrjRDIMtYWKM9TvuoO4I=
X-Received: by 2002:a17:902:6acb:b0:142:76c3:d35f with SMTP id
 i11-20020a1709026acb00b0014276c3d35fmr60526685plt.89.1638979272714; Wed, 08
 Dec 2021 08:01:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211206222830.2266018-1-vishal.l.verma@intel.com> <20211206222830.2266018-5-vishal.l.verma@intel.com>
In-Reply-To: <20211206222830.2266018-5-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Dec 2021 08:00:00 -0800
Message-ID: <CAPcyv4gikDtczX9-HoM6bELdChRe=MLgoY1ApCvtEfQr4jra-g@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 04/12] ndctl, config: add the default ndctl
 configuration file
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 6, 2021 at 2:28 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> From: QI Fuli <qi.fuli@fujitsu.com>
>
> Install ndctl/ndctl.conf as the default ndctl configuration file.
>
> Link: https://lore.kernel.org/r/20210824095106.104808-5-qi.fuli@fujitsu.com
> Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Couple small fixups, otherwise:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> ---
>  configure.ac      |  2 ++
>  ndctl/Makefile.am |  4 +++-
>  ndctl/ndctl.conf  | 56 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 61 insertions(+), 1 deletion(-)
>  create mode 100644 ndctl/ndctl.conf
>
> diff --git a/configure.ac b/configure.ac
> index 42a66e1..9e1c6db 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -172,8 +172,10 @@ AC_SUBST([systemd_unitdir])
>  AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
>
>  ndctl_confdir=${sysconfdir}/ndctl
> +ndctl_conf=ndctl.conf
>  ndctl_monitorconf=monitor.conf
>  AC_SUBST([ndctl_confdir])
> +AC_SUBST([ndctl_conf])
>  AC_SUBST([ndctl_monitorconf])
>
>  daxctl_modprobe_datadir=${datadir}/daxctl
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index 1caa031..fceb3ab 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -43,7 +43,7 @@ keys_configdir = $(ndctl_keysdir)
>  keys_config_DATA = $(ndctl_keysreadme)
>  endif
>
> -EXTRA_DIST += keys.readme monitor.conf ndctl-monitor.service
> +EXTRA_DIST += keys.readme monitor.conf ndctl-monitor.service ndctl.conf
>
>  if ENABLE_DESTRUCTIVE
>  ndctl_SOURCES += ../test/blk_namespaces.c \
> @@ -74,6 +74,8 @@ ndctl_SOURCES += ../test/libndctl.c \
>                  test.c
>  endif
>
> +ndctl_configdir = $(ndctl_confdir)
> +ndctl_config_DATA = $(ndctl_conf)
>  monitor_configdir = $(ndctl_confdir)
>  monitor_config_DATA = $(ndctl_monitorconf)
>
> diff --git a/ndctl/ndctl.conf b/ndctl/ndctl.conf
> new file mode 100644
> index 0000000..04d322d
> --- /dev/null
> +++ b/ndctl/ndctl.conf
> @@ -0,0 +1,56 @@
> +# This is the default ndctl configuration file. It contains the
> +# configuration directives that give ndctl instructions.
> +# Ndctl supports multiple configuration files. All files with the
> +# .conf suffix under {sysconfdir}/ndctl can be regarded as ndctl

Looks good, just the fixup to rename this to {sysconfdir}/ndctl.conf.d

...does the install process replace {sysconfdir} with /etc?

Meson makes file substitutions based on config fairly painless, so
this could wait to be fixed until after that conversion. Another
future item would be to get "man ndctl.conf" to give an overview of
ndctl configuration options.

> +# configuration files.
> +
> +# In this file, lines starting with a hash (#) are comments.
> +# The configurations should be in a [section] and follow <key> = <value>
> +# style. Multiple space-separated values are allowed, but except the
> +# following characters: : ? / \ % " ' $ & ! * { } [ ] ( ) = < > @
> +
> +[core]
> +# The values in [core] section work for all ndctl sub commands.
> +# dimm = all
> +# bus = all
> +# region = all
> +# namespace = all
> +
> +[monitor]
> +# The values in [monitor] section work for ndctl monitor.
> +# You can change the configuration of ndctl monitor by editing this
> +# file or use [--config-file=<file>] option to override this one.
> +# The changed value will work after restart ndctl monitor service.
> +
> +# The objects to monitor are filtered via dimm's name by setting key "dimm".
> +# If this value is different from the value of [--dimm=<value>] option,
> +# both of the values will work.
> +# dimm = all
> +
> +# The objects to monitor are filtered via its parent bus by setting key "bus".
> +# If this value is different from the value of [--bus=<value>] option,
> +# both of the values will work.
> +# bus = all
> +
> +# The objects to monitor are filtered via region by setting key "region".
> +# If this value is different from the value of [--region=<value>] option,
> +# both of the values will work.
> +# region = all
> +
> +# The objects to monitor are filtered via namespace by setting key "namespace".
> +# If this value is different from the value of [--namespace=<value>] option,
> +# both of the values will work.
> +# namespace = all
> +
> +# The DIMM events to monitor are filtered via event type by setting key
> +# "dimm-event". If this value is different from the value of
> +# [--dimm-event=<value>] option, both of the values will work.
> +# dimm-event = all
> +
> +# Users can choose to output the notifications to syslog (log=syslog),
> +# to standard output (log=standard) or to write into a special file (log=<file>)
> +# by setting key "log". If this value is in conflict with the value of
> +# [--log=<value>] option, this value will be ignored.
> +# Note: Setting value to "standard" or relative path for <file> will not work
> +# when running moniotr as a daemon.

s/moniotr/monitor/

> +# log = /var/log/ndctl/monitor.log
> --
> 2.33.1
>
