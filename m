Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1F52C9E
	for <nvdimm@lists.linux.dev>; Wed,  8 Dec 2021 00:20:06 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id 71so556271pgb.4
        for <nvdimm@lists.linux.dev>; Tue, 07 Dec 2021 16:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nj65UunLGFB4k7kNIttBK0yOAHK63DwadR61dBdackY=;
        b=drqENM+PfK2NIRejBrv5qwZd2bANEn3OP989KqWHVF2iSSSCQaBK9+oj72FWbh0aOJ
         x5e9yBtMbvCWAQ/xv4Im05jvN1phYVAvJsTcMvxVliUYAyQXQjPuQv2xA5rItvJE09ch
         zTvcA7bDR/p+pUIwi32kDAl9SuohX6bHpOsdRqS7eZs4KQ3r7DJM7Yypi9JHAw7/Y0hy
         nhGO7cEwaacu76tPdmyvXvCy1pLfafAkjh7NiqKqJ90pCFqzhwYk48tvaBFc87qUDXzG
         VHXhUEDcJ5U0lymq3Pu6Zv5KFqa2J4Np9B/edCwqwUSA9knXF+rF3I5w6dorppv12usz
         VZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nj65UunLGFB4k7kNIttBK0yOAHK63DwadR61dBdackY=;
        b=6tn6o3xKaU8K/8UtqGGHyhgz9iadsimpr6av2IGbbl1gIn2w8ANNjbHzk+wB/4HtsE
         4rWgMFLLzIXYt7cSPxQT8spcvU5DasPjv2JpyWUYw34MXDENxWbeQhFRYlGiaa+yHhp1
         PU16ZOcdSYL930iE/b9nGUSlDmSvnnX4zSdZP0LBVz7nI55Fs1DkTPWw/xCeKpXPuwFO
         36sTcwcE8xctYmSnt82HbWM0uMaTC/MC0TjZ5PO7rlS092Gxt1npaYBc/LQdjl5ZnMO7
         Mj9Q+iZPRreWsZBAePhg6RriP3PX43BchrduS6hmALd+02IqgAOR2WJc3j85qgMquEZ5
         gwHg==
X-Gm-Message-State: AOAM5322vKXsncSGbKYqwKof5GvMmALiLV6qE2OGrR725kgafvTxC/aV
	3mlDtyEKT+H/BoWiGtnITUJb3WkXFiRQ7I66dyqHOw==
X-Google-Smtp-Source: ABdhPJwRBlJeWv8iAcutugZhImFliz/g42rwSQjH9YPxFshvMCGNNJ1Z8y9lFv0oD1QO7JeB7jH5PSb5qUSUI9Z2k1E=
X-Received: by 2002:a63:5357:: with SMTP id t23mr26320193pgl.40.1638922805643;
 Tue, 07 Dec 2021 16:20:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
 <20211206222830.2266018-4-vishal.l.verma@intel.com> <CAPcyv4gafiH1RmV=4BK6xk=D-nq78hDMMi3PQx8=p4es88aXFQ@mail.gmail.com>
 <1df02eee61a50fa9693c27bc8645e34360240f4f.camel@intel.com>
In-Reply-To: <1df02eee61a50fa9693c27bc8645e34360240f4f.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Dec 2021 16:19:55 -0800
Message-ID: <CAPcyv4hJCAN1P0_fzuDZeyfnGXrR9qtdWA40POhT9N+7Bsxm1A@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 03/12] ndctl: make ndctl support configuration files
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 7, 2021 at 4:05 PM Verma, Vishal L <vishal.l.verma@intel.com> wrote:
>
> On Tue, 2021-12-07 at 14:51 -0800, Dan Williams wrote:
> > On Mon, Dec 6, 2021 at 2:28 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
> > >
> > > From: QI Fuli <qi.fuli@fujitsu.com>
> > >
> > > Add ndctl_configs to ndctl_ctx for supporting ndctl global configuration
> > > files. All files with .conf suffix under {sysconfdir}/ndctl can be
> >
> > I expect this should be named a ".d" directory to match expectations
> > of when a directory supports multiple config-file snippets. Either
> > "{sysconfdir}/ndctl/ndctl.d", "{sysconfdir}/ndctl/conf.d",
> > ""{sysconfdir}/ndctl.d"  would be ok with me. "{sysconfdir}/ndctl" is
> > still needed for the security keys.
>
> ".d" sounds good - I prefer "{sysconfdir}/ndctl.d" or even something
> like "{sysconfdir}/ndctl.conf.d" to make it explicit that this is for
> config files.

Sure, that works too. I note that modprobe.d is full of ".conf" files,
but I see no harm in including ".conf" in the directory name. Since
yum.repos.d is full of ".repo" files as a counter example in the
naming scheme.

[..]
> >
> > I expect this to happen by default in ndctl_new().
> >
> > In fact, ndctl_new() might want to grow a config path argument to
> > override the default.
>
> Happening by default in ndctl_new sounds good.
> However since ndctl_new() is an exported API, we can't just add a new
> argument to it, can we?

Oh, yeah, it would need to be a new ndctl_new(). No worries we can
cross that bridge later.

> Do we expect callers to want custom paths,
> outside of what a distro may set via NDCTL_CONF_DIR during build?

I was thinking it would be like mdadm where you can override the
location of the configuration file(s) on the command line. We can
always add that later, no need for feature creep right now.
