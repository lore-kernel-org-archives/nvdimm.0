Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CCE7A
	for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 01:45:16 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id e6so11564193pgn.2
        for <nvdimm@lists.linux.dev>; Mon, 21 Mar 2022 18:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QIf4Hy84dx7L6X4BNNjvqyd7qQS9lH8gSrCqndVgulg=;
        b=c1eIS7vo7uHJkChkDX9E8UuibyJlcPj9ny6akRAfhecft5A4sQAAvRT6NWdrwAyYS1
         dhaWlwDJJ1cJQ9ZRJHl9EjacUiDF5EHf3CHkOAqMuf0zU49JchE3kIj49+xSipYMpZiR
         HImhOI6SXmdIbf5Eor+xzxKwjeQIQjsWyx8OU4AT+mnrMtNSqd3W8TbEmgIo7Y1ycTlD
         rVRjOa0tpXALsViv1QgoVdGtel5P6mOpCoBMe6neh7LZthVINVhnDwPsTLrKPRqvH1Ba
         hTfFX+3SOKUYmcJb74di86aoahq+yHYqmpEMYLfZnR7rPa1oD6FVpe5eB6p5JxtXIWju
         iwxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QIf4Hy84dx7L6X4BNNjvqyd7qQS9lH8gSrCqndVgulg=;
        b=NPT1btDe4a1hJmC8EZJ7SoCLo+NsEGq/Zj41iiosJqsdO3Ly33keDK40geTUu2SaFP
         GDaQDrj27PGeJ0xI6FaocEk6WTpg+ZUrSIKuqVS0+15yrzBCBLn/b+okA37ND76i/6HR
         +BCLCYpnmkt+usXTvwuA7ijd8yjIm8lHyncj4hhP0c2+V8kHQ4w04AgZwWN6MASWwpkC
         8Hx917SSFRz2WDNNImDm568+kfvMw/4ZKlSCMibtE8+2TXIsU8dmnFIjZKoyAS/Bze9g
         GNu3GoQLGjvzbOGLI94Lzjn4/lZHfXP78tx3m3qTGK4In0qHoe/098aWMM/oS5IsvP7X
         dUsw==
X-Gm-Message-State: AOAM5325vL+BE8Lrawq7s8rge4dxgoK/hiMpgIWN2Uuq5c6/XK/F2/Zv
	vba2Ps/dSCRNfvD7ok9ku7R+cxwXW3ZT6Xcnov06Ew==
X-Google-Smtp-Source: ABdhPJzVR8hSV4LYUKgF5NX85hxfFWmgAFFzJsBeUycAZHnf4kgiNP9olDkABVHU+za3VoOGb088WtmKxpJ0jIdi06E=
X-Received: by 2002:a63:5c53:0:b0:381:309e:e72c with SMTP id
 n19-20020a635c53000000b00381309ee72cmr20646280pgm.40.1647913516040; Mon, 21
 Mar 2022 18:45:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220318114133.113627-1-kjain@linux.ibm.com> <20220318114133.113627-2-kjain@linux.ibm.com>
 <CAPcyv4iqpTn89WLOW1XjFXGZEYG_MmPg+VQbcDJ9ygJ4Jaybtw@mail.gmail.com>
In-Reply-To: <CAPcyv4iqpTn89WLOW1XjFXGZEYG_MmPg+VQbcDJ9ygJ4Jaybtw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 21 Mar 2022 18:45:08 -0700
Message-ID: <CAPcyv4iNy-RqKgwc61c+hL9g1zAE_tL5r_mqUQwCiKTzevjoDA@mail.gmail.com>
Subject: Re: [PATCH 2/2] powerpc/papr_scm: Fix build failure when
 CONFIG_PERF_EVENTS is not set
To: Kajol Jain <kjain@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux-Next Mailing List <linux-next@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Santosh Sivaraj <santosh@fossix.org>, maddy@linux.ibm.com, 
	rnsastry@linux.ibm.com, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
	atrajeev@linux.vnet.ibm.com, Vaibhav Jain <vaibhav@linux.ibm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 21, 2022 at 2:39 PM Dan Williams <dan.j.williams@intel.com> wro=
te:
>
> On Fri, Mar 18, 2022 at 4:42 AM Kajol Jain <kjain@linux.ibm.com> wrote:
> >
> > The following build failure occures when CONFIG_PERF_EVENTS is not set
> > as generic pmu functions are not visible in that scenario.
> >
> > arch/powerpc/platforms/pseries/papr_scm.c:372:35: error: =E2=80=98struc=
t perf_event=E2=80=99 has no member named =E2=80=98attr=E2=80=99
> >          p->nvdimm_events_map[event->attr.config],
> >                                    ^~
> > In file included from ./include/linux/list.h:5,
> >                  from ./include/linux/kobject.h:19,
> >                  from ./include/linux/of.h:17,
> >                  from arch/powerpc/platforms/pseries/papr_scm.c:5:
> > arch/powerpc/platforms/pseries/papr_scm.c: In function =E2=80=98papr_sc=
m_pmu_event_init=E2=80=99:
> > arch/powerpc/platforms/pseries/papr_scm.c:389:49: error: =E2=80=98struc=
t perf_event=E2=80=99 has no member named =E2=80=98pmu=E2=80=99
> >   struct nvdimm_pmu *nd_pmu =3D to_nvdimm_pmu(event->pmu);
> >                                                  ^~
> > ./include/linux/container_of.h:18:26: note: in definition of macro =E2=
=80=98container_of=E2=80=99
> >   void *__mptr =3D (void *)(ptr);     \
> >                           ^~~
> > arch/powerpc/platforms/pseries/papr_scm.c:389:30: note: in expansion of=
 macro =E2=80=98to_nvdimm_pmu=E2=80=99
> >   struct nvdimm_pmu *nd_pmu =3D to_nvdimm_pmu(event->pmu);
> >                               ^~~~~~~~~~~~~
> > In file included from ./include/linux/bits.h:22,
> >                  from ./include/linux/bitops.h:6,
> >                  from ./include/linux/of.h:15,
> >                  from arch/powerpc/platforms/pseries/papr_scm.c:5:
> >
> > Fix the build issue by adding check for CONFIG_PERF_EVENTS config optio=
n
> > and disabling the papr_scm perf interface support incase this config
> > is not set
> >
> > Fixes: 4c08d4bbc089 ("powerpc/papr_scm: Add perf interface support") (C=
ommit id
> > based on linux-next tree)
> > Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
> > ---
> >  arch/powerpc/platforms/pseries/papr_scm.c | 15 +++++++++++++++
>
> This is a bit messier than I would have liked mainly because it dumps
> a bunch of ifdefery into a C file contrary to coding style, "Wherever
> possible, don't use preprocessor conditionals (#if, #ifdef) in .c
> files". I would expect this all to move to an organization like:
>
> arch/powerpc/platforms/pseries/papr_scm/main.c
> arch/powerpc/platforms/pseries/papr_scm/perf.c
>
> ...and a new config symbol like:
>
> config PAPR_SCM_PERF
>        depends on PAPR_SCM && PERF_EVENTS
>        def_bool y
>
> ...with wrappers in header files to make everything compile away
> without any need for main.c to carry an ifdef.
>
> Can you turn a patch like that in the next couple days? Otherwise, I
> think if Linus saw me sending a late breaking compile fix that threw
> coding style out the window he'd have cause to just drop the pull
> request entirely.

Also, please base it on the current state of the libnvdimm-for-next
branch as -next includes some of the SMART health changes leading to
at least one conflict.
