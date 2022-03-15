Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911AD23CC
	for <nvdimm@lists.linux.dev>; Tue, 15 Mar 2022 17:19:27 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id o6-20020a17090a9f8600b001c6562049d9so24244pjp.3
        for <nvdimm@lists.linux.dev>; Tue, 15 Mar 2022 10:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2/NbvozXgzELSJbiLwxeEgDceY55yt5YGuDnXHyt8IY=;
        b=gyjW2yLMeGxlNQMcQi+FfWeQeqq9v7kw/hKE3kXBEMAPZs+Q66KfhdnkTV0hrxApgX
         ewsGANR8gQvwFUORwxt6JzYJjAlXe+xg9JeMEvHcfXED5O7pxMRViNMyD858t5RYeL8t
         pbiB9yxU/ot1868qxfFOTIfbziC97fWjn08sWuMW44RYKyCoD4E/OlWmqW0azdv3jJ8z
         j0D4aSJCB7maf/IVIBzVWYwowShfybXZ/rneO1UBYNuasKlMsBPrO4LEG/p0+wkI/xKw
         vUo1/SxceB9uuraMH7nXfizir+KOPWY7MmjrJ1+4vilg1DsANvmI62A8wPMfPJWd+bdb
         +UHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2/NbvozXgzELSJbiLwxeEgDceY55yt5YGuDnXHyt8IY=;
        b=w5zy9AP8A0B9ETdbkHBkytOFsHgYy+gOzTywcAxP53EPszaSiw557GOAUnDTh2GLsV
         iMit7aiFyf3+jQFzfr9k/ZjPK+Rey9Mmd4f2BDcRmwewfGx95DnQLQRwSJtbTWLCvwZo
         boA1JSAji9XGVM/8geOESxIWu6xSK4cd5T2ou9je92Olesl5N9F86nfD6zz8CPZScfHf
         H3DY8Gz33C4JzIZbXi7pyZjSafleI2UhTXDyr3tK68vm6onxGPn4bJRS/YSNVXx0A9kN
         6vhfvF9ZLNg7HNShQvs9eXgUDu/OzY9bbXT+pygmCP733zWlMexFdmcGHSriinoo8L4f
         DSXA==
X-Gm-Message-State: AOAM531+KImByyCz57JWTQYywvMCh9fbdXnzqtFPzSh/1OG/csYLnCa1
	vnBWU9OX2UBRge/1WScBGXZO4Gsrlgee9IMehvlTvQ==
X-Google-Smtp-Source: ABdhPJwWwyLOyIIhmYYkkvDoUgb8xcknhcVoev+ZIjufq9gbjewmFBfvwHYoUOMFRxFWeoSxcUm6cKXI08MYXvJxaAg=
X-Received: by 2002:a17:902:d511:b0:153:a664:bb3b with SMTP id
 b17-20020a170902d51100b00153a664bb3bmr2519056plg.147.1647364766940; Tue, 15
 Mar 2022 10:19:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220315060426.140201-1-aneesh.kumar@linux.ibm.com>
 <874k3zd27b.fsf@vajain21.in.ibm.com> <87v8wfcyht.fsf@linux.ibm.com> <87zglrb1tu.fsf@vajain21.in.ibm.com>
In-Reply-To: <87zglrb1tu.fsf@vajain21.in.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Mar 2022 10:19:15 -0700
Message-ID: <CAPcyv4gZAK5fgGGyeQTiM_6=1rFGNciHjnOJZExqecre7Dbobw@mail.gmail.com>
Subject: Re: [PATCH] util/parse: Fix build error on ubuntu
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Vishal L Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 15, 2022 at 9:47 AM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>
> "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
>
> > Vaibhav Jain <vaibhav@linux.ibm.com> writes:
> >
> >> Second hunk of this diff seems to be a revert of [1]  which might
> >> break the ndctl build on Arch Linux.
> >>
> >> AFAIS for Centos/Fedora/RHEL etc the iniparser.h file is present in the
> >> default include path('/usr/include') as a softlink to
> >> '/usr/include/iniparser/iniparser.h' . Ubuntu/Debian seems to an
> >> exception where path '/usr/include/iniparser.h' is not present.
> >>
> >> I guess thats primarily due to no 'make install' target available in
> >> iniparser makefiles [1] that fixes a single include patch. This may have led
> >> to differences across distros where to place these header files.
> >>
> >> I would suggest changing to this in meson.build to atleast catch if the
> >> iniparser.h is not present at the expected path during meson setup:
> >>
> >>     iniparser = cc.find_library('iniparser', required : true, has_headers: 'iniparser.h')
> >>
> >> [1] addc5fd8511('Fix iniparser.h include')
> >> [2] https://github.com/ndevilla/iniparser/blob/master/Makefile
> >
> >
> > We can do this.
> >
> > diff --git a/config.h.meson b/config.h.meson
> > index 2852f1e9cd8b..b070df96cf4a 100644
> > --- a/config.h.meson
> > +++ b/config.h.meson
> > @@ -82,6 +82,9 @@
> >  /* Define to 1 if you have the <unistd.h> header file. */
> >  #mesondefine HAVE_UNISTD_H
> >
> > +/* Define to 1 if you have the <iniparser/iniparser.h> header file. */
> > +#mesondefine HAVE_INIPARSER_INCLUDE_H
> > +
> >  /* Define to 1 if using libuuid */
> >  #mesondefine HAVE_UUID
> >
> > diff --git a/meson.build b/meson.build
> > index 42e11aa25cba..893f70c22270 100644
> > --- a/meson.build
> > +++ b/meson.build
> > @@ -176,6 +176,7 @@ check_headers = [
> >    ['HAVE_SYS_STAT_H', 'sys/stat.h'],
> >    ['HAVE_SYS_TYPES_H', 'sys/types.h'],
> >    ['HAVE_UNISTD_H', 'unistd.h'],
> > +  ['HAVE_INIPARSER_INCLUDE_H', 'iniparser/iniparser.h'],
> >  ]
> >
> >  foreach h : check_headers
> > diff --git a/util/parse-configs.c b/util/parse-configs.c
> > index c834a07011e5..8bdc9d18cbf3 100644
> > --- a/util/parse-configs.c
> > +++ b/util/parse-configs.c
> > @@ -4,7 +4,11 @@
> >  #include <dirent.h>
> >  #include <errno.h>
> >  #include <fcntl.h>
> > +#ifdef HAVE_INIPARSER_INCLUDE_H
> > +#include <iniparser/iniparser.h>
> > +#else
> >  #include <iniparser.h>
> > +#endif
> >  #include <sys/stat.h>
> >  #include <util/parse-configs.h>
> >  #include <util/strbuf.h>
>
> Agree, above patch can fix this issue. Though I really wanted to avoid
> trickling changes to the parse-configs.c since the real problem is with
> non consistent location for iniparser.h header across distros.
>
> I gave it some thought and came up with this patch to meson.build that can
> pick up appropriate '/usr/include' or '/usr/include/iniparser' directory
> as include path to the compiler.
>
> Also since there seems to be no standard location for this header file
> I have included a meson build option named 'iniparser-includedir' that
> can point to the dir where 'iniparser.h' can be found.
>
> diff --git a/meson.build b/meson.build
> index 42e11aa25cba..8c347e64ca2d 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -158,9 +158,27 @@ endif
>
>  cc = meson.get_compiler('c')
>
> -# keyutils and iniparser lack pkgconfig
> +# keyutils lack pkgconfig
>  keyutils = cc.find_library('keyutils', required : get_option('keyutils'))
> -iniparser = cc.find_library('iniparser', required : true)
> +
> +# iniparser lacks pkgconfig and its header files are either at '/usr/include' or '/usr/include/iniparser'
> +# First use the path provided by user via meson configure -Diniparser-includedir=<somepath>
> +# if thats not provided than try searching for 'iniparser.h' in default system include path
> +# and if that not found than as a last resort try looking at '/usr/include/iniparser'
> +
> +if get_option('iniparser-includedir') == ''

Approach looks good, but I think I would change this to be relative to
includedir as in:

iniparserdir = get_option(iniparserdir)
iniparser = cc.find_library('iniparser', required : false, has_headers
: 'iniparser.h', dirs : includedir / iniparserdir)
if not iniparser.found()
    initparserdir = 'iniparser'
    iniparser = cc.find_library('iniparser', required : true,
has_headers : 'iniparser.h', dirs : includedir / iniparserdir)
endif
iniparser = declare_dependency(include_directories : includedir /
iniparserdir, dependencies:iniparser)

...just in case someone has already overridden @prefix and / or @includedir.
