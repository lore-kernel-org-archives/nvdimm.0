Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8307A3FC3
	for <nvdimm@lists.linux.dev>; Fri, 17 Sep 2021 18:11:06 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso7963038pjb.3
        for <nvdimm@lists.linux.dev>; Fri, 17 Sep 2021 11:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=plKVhChM36utSLCLS32DZliXbg/vzEA7+3GZg7gx4Wo=;
        b=KGn0n/DFCUHjwE0eX0pFG8bqY45Yg0J1uao7g/cLfioD8t8lR7/bvEp60AvRupqo5c
         eKWOeBHuD5+be4nOD0U9xp56/V5nAPXQDy1pmZNoad7YTc9JUJXbHOp8h4bLrLDtC4EF
         bsEj6luYpg+RFw/0CAsKnp9ylhKOSzPoqCsG7iwxFuUZhvBPyQcbPbtF8L1fAFQ5f+UL
         6PIyVQWlDYej+H2Ca1dKpU8nIgeoQ+Zj663H5d8W5s0whj3f/NFvK2Xlb4Is17v3G0IF
         F95w0YuWiF+6oNG5XqvwXFkbFd7B+/lwv9nwl/5UEuMgazrY8oOndypf8mXy3ucJ3YQE
         B2EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=plKVhChM36utSLCLS32DZliXbg/vzEA7+3GZg7gx4Wo=;
        b=7v6r4CBUqd4mmr/rlkShYT1s+Imtz3R/4rlCiSfnvyoUNeIW+QP8RQyXtGYjr2zGMO
         MsREnKVgXYkAhquek6g3hO4olpcQ2SKsH021dQ6vbiH7I45YTtvHDbUxssRAno1JOLxt
         sNsoxGFbRphToz+aqJ8pbuLEjWhQVcCHX9DaCvkrrOjI8V2x1z+Q4tBuuqixVjHmHn9U
         Fv4WKUwKwSEKpJEqSyZe86GVDqeVjjQspRGJn5n3snhpzR93cl/EqJCTBe6v7mX2xMTb
         KzH2AWRy4hH2Xe6xl8/7WGVeCOfUNfjoqFbIh9K3aVHVyaKWG5rffcksYZfLOq9LLnJL
         ItAw==
X-Gm-Message-State: AOAM530XY6xflA8R5UF3hZA/CHQYxkGVjtGphuRfmhpBT5Nviwyzatex
	AWmnLqi4dSqP7JXr9tFDNFH4rEarJGTpjyDiBEzZVw==
X-Google-Smtp-Source: ABdhPJx3bysc8u4oocwChFZuv8hGHdlD1a7lVDDllnf74UgzZuFH0cDiNQBZxlD3JwgF/JDwCPiR71nAIaLfkx0ZE20=
X-Received: by 2002:a17:90a:f18f:: with SMTP id bv15mr13533994pjb.93.1631902265896;
 Fri, 17 Sep 2021 11:11:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210831090459.2306727-1-vishal.l.verma@intel.com> <20210831090459.2306727-8-vishal.l.verma@intel.com>
In-Reply-To: <20210831090459.2306727-8-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Sep 2021 11:10:55 -0700
Message-ID: <CAPcyv4jYeu8y3t9Np495DVMyLt84jQy9EtQjdMDQ4fj91bnZgw@mail.gmail.com>
Subject: Re: [ndctl PATCH 7/7] daxctl: add systemd service and udev rule for auto-onlining
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 31, 2021 at 2:05 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Install a helper script that calls daxctl-reconfigure-device with the
> new 'check-config' option for a given device. This is meant to be called
> via a systemd service.
>
> Install a systemd service that calls the above wrapper script with a
> daxctl device passed in to it via the environment.
>
> Install a udev rule that is triggered for every daxctl device, and
> triggers the above oneshot systemd service.
>
> Together, these three things work such that upon boot, whenever a daxctl
> device is found, udev triggers a device-specific systemd service called,
> for example:
>
>   daxdev-reconfigure@-dev-dax0.0.service

I'm thinking the service would be called daxdev-add, because it is
servicing KOBJ_ADD events, or is the convention to name the service
after what it does vs what it services?

Also, I'm curious why would "dax0.0" be in the service name, shouldn't
this be scanning all dax devices and internally matching based on the
config file?

>
> This initiates a daxctl-reconfigure-device with a config lookup for the
> 'dax0.0' device. If the config has an '[auto-online <unique_id>]'
> section, it uses the information in that to set the operating mode of
> the device.
>
> If any device is in an unexpected status, 'journalctl' can be used to
> view the reconfiguration log for that device, for example:
>
>   journalctl --unit daxdev-reconfigure@-dev-dax0.0.service

There will be a log per-device, or only if there is a service per
device? My assumption was that this service is firing off for all
devices so you would need to filter the log by the device-name if you
know it... or maybe I'm misunderstanding how this udev service works.

>
> Update the RPM spec file to include the newly added files to the RPM
> build.
>
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  configure.ac                       |  9 ++++++++-
>  daxctl/90-daxctl-device.rules      |  1 +
>  daxctl/Makefile.am                 | 10 ++++++++++
>  daxctl/daxdev-auto-reconfigure.sh  |  3 +++
>  daxctl/daxdev-reconfigure@.service |  8 ++++++++
>  ndctl.spec.in                      |  3 +++
>  6 files changed, 33 insertions(+), 1 deletion(-)
>  create mode 100644 daxctl/90-daxctl-device.rules
>  create mode 100755 daxctl/daxdev-auto-reconfigure.sh
>  create mode 100644 daxctl/daxdev-reconfigure@.service
>
> diff --git a/configure.ac b/configure.ac
> index 9e1c6db..df6ab10 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -160,7 +160,7 @@ AC_CHECK_FUNCS([ \
>
>  AC_ARG_WITH([systemd],
>         AS_HELP_STRING([--with-systemd],
> -               [Enable systemd functionality (monitor). @<:@default=yes@:>@]),
> +               [Enable systemd functionality. @<:@default=yes@:>@]),
>         [], [with_systemd=yes])
>
>  if test "x$with_systemd" = "xyes"; then
> @@ -183,6 +183,13 @@ daxctl_modprobe_data=daxctl.conf
>  AC_SUBST([daxctl_modprobe_datadir])
>  AC_SUBST([daxctl_modprobe_data])
>
> +AC_ARG_WITH(udevrulesdir,
> +    [AS_HELP_STRING([--with-udevrulesdir=DIR], [udev rules.d directory])],
> +    [UDEVRULESDIR="$withval"],
> +    [UDEVRULESDIR='${prefix}/lib/udev/rules.d']
> +)
> +AC_SUBST(UDEVRULESDIR)
> +
>  AC_ARG_WITH([keyutils],
>             AS_HELP_STRING([--with-keyutils],
>                         [Enable keyutils functionality (security).  @<:@default=yes@:>@]), [], [with_keyutils=yes])
> diff --git a/daxctl/90-daxctl-device.rules b/daxctl/90-daxctl-device.rules
> new file mode 100644
> index 0000000..ee0670f
> --- /dev/null
> +++ b/daxctl/90-daxctl-device.rules
> @@ -0,0 +1 @@
> +ACTION=="add", SUBSYSTEM=="dax", TAG+="systemd", ENV{SYSTEMD_WANTS}="daxdev-reconfigure@$env{DEVNAME}.service"
> diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
> index f30c485..d53bdcf 100644
> --- a/daxctl/Makefile.am
> +++ b/daxctl/Makefile.am
> @@ -28,3 +28,13 @@ daxctl_LDADD =\
>         $(UUID_LIBS) \
>         $(KMOD_LIBS) \
>         $(JSON_LIBS)
> +
> +bin_SCRIPTS = daxdev-auto-reconfigure.sh
> +CLEANFILES = $(bin_SCRIPTS)
> +
> +udevrulesdir = $(UDEVRULESDIR)
> +udevrules_DATA = 90-daxctl-device.rules
> +
> +if ENABLE_SYSTEMD_UNITS
> +systemd_unit_DATA = daxdev-reconfigure@.service
> +endif
> diff --git a/daxctl/daxdev-auto-reconfigure.sh b/daxctl/daxdev-auto-reconfigure.sh
> new file mode 100755
> index 0000000..f6da43f
> --- /dev/null
> +++ b/daxctl/daxdev-auto-reconfigure.sh
> @@ -0,0 +1,3 @@
> +#!/bin/bash
> +
> +daxctl reconfigure-device --check-config "${1##*/}"
> diff --git a/daxctl/daxdev-reconfigure@.service b/daxctl/daxdev-reconfigure@.service
> new file mode 100644
> index 0000000..451fef1
> --- /dev/null
> +++ b/daxctl/daxdev-reconfigure@.service
> @@ -0,0 +1,8 @@
> +[Unit]
> +Description=Automatic daxctl device reconfiguration
> +Documentation=man:daxctl-reconfigure-device(1)
> +
> +[Service]
> +Type=forking
> +GuessMainPID=false
> +ExecStart=/bin/sh -c "exec daxdev-auto-reconfigure.sh %I"

Why is the daxdev-auto-reconfigure.sh indirection needed? Can this not be:

ExecStart=daxctl reconfigure-device -C %I

...if the format of %l is the issue I think it would be good for
reconfigure-device to be tolerant of this format.
