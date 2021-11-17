Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7230A2C80
	for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 23:43:35 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so3954153pjb.5
        for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 15:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7fin2Zkd+BX8yWa1ggBLhBW7o1+/eSCCNfrA4iGT9+k=;
        b=mWvSh+pgXfT9zwqdAD9s5Kw/TlrxbaXOcmLR1gqi1o4mLQ9p74L55YgnDW7O4LviY3
         w0+T+lUe1t9j1ZEgRW2yibHictZAhfLUB3Y7Z/NAt8IrBIZnt6Fz2CHSpqXvIvzet7eM
         0EDoeqkdwkYEDxUOZt/6UeA4RUyexTbNWpF9nl6j+RT+K9yB4CSmYV+WEppn0iZYSLt/
         eObomUbP7QrZAp8437qvjEf9XYilMTpZBKLIlgEZ+WRsmrIH41WhRnTYIIAJ3VoL/i2J
         hT1wIp/q39TCeQ4k+194z3Z6jU0UKpHe3PNrulkJR8x2ySacV6ie7QCOc7Cc8WNRLsm/
         Kykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7fin2Zkd+BX8yWa1ggBLhBW7o1+/eSCCNfrA4iGT9+k=;
        b=ZfoOuj1tR/2EVrnqaahw4o1IVTv0GY5dq0R2CCCA3I85mmcJLfqCxd2nr+EAiS1DaM
         VZjXSySeKLHtBxUSA7NhGmru/mMAOcaKw45KghaVXodfFnz1rrlDO90EdI/gY+2Kj5ky
         XDOmxolfmsgaUN3P71Gc1hK+NOnMgUhuXIXWp+je+aDO2/D5I3UPOlBgduHrikYryVXY
         hdOkrd3+sSAsmZZfg9iwcnjEkn4jtsowDaniZsWiZszm82UntGx2CKquofdZMMJiq542
         4siyBADrqVFzGbdzOgODge6DpJeE4Ty98B8xsmTo7N4O3lzkW64cPP6sqrxgI02GUobT
         yy1A==
X-Gm-Message-State: AOAM530cBdg/hLVE+te/8WJ1YoOVI0aRFm9xNE7BM1lMDU4UYMRCaUAK
	hDMhvrerNNukJMuZ4C5X1NSGgiWTacfGBPT/a+zclA==
X-Google-Smtp-Source: ABdhPJw1uRYYah6onZUGUiaCqKf1cioFYOmYyTJ4+JW6RbtJvwgzJMtO9fy8TV2wzv+/n9O+KcU0EasktkpSptcQ0mM=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr4556495pjb.93.1637192614784;
 Wed, 17 Nov 2021 15:43:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
 <20210831090459.2306727-8-vishal.l.verma@intel.com> <CAPcyv4jYeu8y3t9Np495DVMyLt84jQy9EtQjdMDQ4fj91bnZgw@mail.gmail.com>
 <1efbd44270e7494dbe927ac6cf3273e63225ea36.camel@intel.com>
In-Reply-To: <1efbd44270e7494dbe927ac6cf3273e63225ea36.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Nov 2021 15:43:21 -0800
Message-ID: <CAPcyv4hmSUfXXbY2+kkKJGBRrXhaS14ifhinVjo3U7f+A3Mhww@mail.gmail.com>
Subject: Re: [ndctl PATCH 7/7] daxctl: add systemd service and udev rule for auto-onlining
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 17, 2021 at 3:29 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Fri, 2021-09-17 at 11:10 -0700, Dan Williams wrote:
> > On Tue, Aug 31, 2021 at 2:05 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
> > >
> > > Install a helper script that calls daxctl-reconfigure-device with the
> > > new 'check-config' option for a given device. This is meant to be called
> > > via a systemd service.
> > >
> > > Install a systemd service that calls the above wrapper script with a
> > > daxctl device passed in to it via the environment.
> > >
> > > Install a udev rule that is triggered for every daxctl device, and
> > > triggers the above oneshot systemd service.
> > >
> > > Together, these three things work such that upon boot, whenever a daxctl
> > > device is found, udev triggers a device-specific systemd service called,
> > > for example:
> > >
> > >   daxdev-reconfigure@-dev-dax0.0.service
> >
> > I'm thinking the service would be called daxdev-add, because it is
> > servicing KOBJ_ADD events, or is the convention to name the service
> > after what it does vs what it services?
> >
> > Also, I'm curious why would "dax0.0" be in the service name, shouldn't
> > this be scanning all dax devices and internally matching based on the
> > config file?
> >
> > >
> > > This initiates a daxctl-reconfigure-device with a config lookup for the
> > > 'dax0.0' device. If the config has an '[auto-online <unique_id>]'
> > > section, it uses the information in that to set the operating mode of
> > > the device.
> > >
> > > If any device is in an unexpected status, 'journalctl' can be used to
> > > view the reconfiguration log for that device, for example:
> > >
> > >   journalctl --unit daxdev-reconfigure@-dev-dax0.0.service
> >
> > There will be a log per-device, or only if there is a service per
> > device? My assumption was that this service is firing off for all
> > devices so you would need to filter the log by the device-name if you
> > know it... or maybe I'm misunderstanding how this udev service works.
> >
> > >
> > > Update the RPM spec file to include the newly added files to the RPM
> > > build.
> > >
> > > Cc: QI Fuli <qi.fuli@fujitsu.com>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > ---
> > >  configure.ac                       |  9 ++++++++-
> > >  daxctl/90-daxctl-device.rules      |  1 +
> > >  daxctl/Makefile.am                 | 10 ++++++++++
> > >  daxctl/daxdev-auto-reconfigure.sh  |  3 +++
> > >  daxctl/daxdev-reconfigure@.service |  8 ++++++++
> > >  ndctl.spec.in                      |  3 +++
> > >  6 files changed, 33 insertions(+), 1 deletion(-)
> > >  create mode 100644 daxctl/90-daxctl-device.rules
> > >  create mode 100755 daxctl/daxdev-auto-reconfigure.sh
> > >  create mode 100644 daxctl/daxdev-reconfigure@.service
> > >
> > > diff --git a/configure.ac b/configure.ac
> > > index 9e1c6db..df6ab10 100644
> > > --- a/configure.ac
> > > +++ b/configure.ac
> > > @@ -160,7 +160,7 @@ AC_CHECK_FUNCS([ \
> > >
> > >  AC_ARG_WITH([systemd],
> > >         AS_HELP_STRING([--with-systemd],
> > > -               [Enable systemd functionality (monitor). @<:@default=yes@:>@]),
> > > +               [Enable systemd functionality. @<:@default=yes@:>@]),
> > >         [], [with_systemd=yes])
> > >
> > >  if test "x$with_systemd" = "xyes"; then
> > > @@ -183,6 +183,13 @@ daxctl_modprobe_data=daxctl.conf
> > >  AC_SUBST([daxctl_modprobe_datadir])
> > >  AC_SUBST([daxctl_modprobe_data])
> > >
> > > +AC_ARG_WITH(udevrulesdir,
> > > +    [AS_HELP_STRING([--with-udevrulesdir=DIR], [udev rules.d directory])],
> > > +    [UDEVRULESDIR="$withval"],
> > > +    [UDEVRULESDIR='${prefix}/lib/udev/rules.d']
> > > +)
> > > +AC_SUBST(UDEVRULESDIR)
> > > +
> > >  AC_ARG_WITH([keyutils],
> > >             AS_HELP_STRING([--with-keyutils],
> > >                         [Enable keyutils functionality (security).  @<:@default=yes@:>@]), [], [with_keyutils=yes])
> > > diff --git a/daxctl/90-daxctl-device.rules b/daxctl/90-daxctl-device.rules
> > > new file mode 100644
> > > index 0000000..ee0670f
> > > --- /dev/null
> > > +++ b/daxctl/90-daxctl-device.rules
> > > @@ -0,0 +1 @@
> > > +ACTION=="add", SUBSYSTEM=="dax", TAG+="systemd", ENV{SYSTEMD_WANTS}="daxdev-reconfigure@$env{DEVNAME}.service"
> > > diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
> > > index f30c485..d53bdcf 100644
> > > --- a/daxctl/Makefile.am
> > > +++ b/daxctl/Makefile.am
> > > @@ -28,3 +28,13 @@ daxctl_LDADD =\
> > >         $(UUID_LIBS) \
> > >         $(KMOD_LIBS) \
> > >         $(JSON_LIBS)
> > > +
> > > +bin_SCRIPTS = daxdev-auto-reconfigure.sh
> > > +CLEANFILES = $(bin_SCRIPTS)
> > > +
> > > +udevrulesdir = $(UDEVRULESDIR)
> > > +udevrules_DATA = 90-daxctl-device.rules
> > > +
> > > +if ENABLE_SYSTEMD_UNITS
> > > +systemd_unit_DATA = daxdev-reconfigure@.service
> > > +endif
> > > diff --git a/daxctl/daxdev-auto-reconfigure.sh b/daxctl/daxdev-auto-reconfigure.sh
> > > new file mode 100755
> > > index 0000000..f6da43f
> > > --- /dev/null
> > > +++ b/daxctl/daxdev-auto-reconfigure.sh
> > > @@ -0,0 +1,3 @@
> > > +#!/bin/bash
> > > +
> > > +daxctl reconfigure-device --check-config "${1##*/}"
> > > diff --git a/daxctl/daxdev-reconfigure@.service b/daxctl/daxdev-reconfigure@.service
> > > new file mode 100644
> > > index 0000000..451fef1
> > > --- /dev/null
> > > +++ b/daxctl/daxdev-reconfigure@.service
> > > @@ -0,0 +1,8 @@
> > > +[Unit]
> > > +Description=Automatic daxctl device reconfiguration
> > > +Documentation=man:daxctl-reconfigure-device(1)
> > > +
> > > +[Service]
> > > +Type=forking
> > > +GuessMainPID=false
> > > +ExecStart=/bin/sh -c "exec daxdev-auto-reconfigure.sh %I"
> >
> > Why is the daxdev-auto-reconfigure.sh indirection needed? Can this not be:
> >
> > ExecStart=daxctl reconfigure-device -C %I
> >
> > ...if the format of %l is the issue I think it would be good for
> > reconfigure-device to be tolerant of this format.
>
> Yeah it was the format of %I. I forget exactly what it was, I think it
> contains maybe a full /dev/daxX.Y path? Since in the wrapper script I'm
> clipping away everything upto the first '/'. Should we make
> reconfigure-device understand /dev/daxX.Y?

Yeah, I think it follows the principle of least surprise if:

daxctl reconfigure-device /dev/daxX.Y

...and:

daxctl reconfigure-device daxX.Y

...behave the same.
