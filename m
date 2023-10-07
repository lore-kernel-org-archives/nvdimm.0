Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB1EF9F4
	for <nvdimm@lists.linux.dev>; Sat,  7 Oct 2023 10:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3ae473c0bd6so519194b6e.0
        for <nvdimm@lists.linux.dev>; Sat, 07 Oct 2023 03:43:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696675399; x=1697280199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KI+7EOVOyPWCiOOc7dvfxOKmEPx6gMqHAT3wBewOPrU=;
        b=EUCyrQngrsH52CMNsEHKqeYcr0KALAKX+8Vl0RIxY//n+vm2rb+L4VRSdZicOsEQts
         0bUDgmQA8oB8PIiNjRwXoHKUwwSFDoA4Rwqyfut1c34OKhb0ND5oLaOM9kPdf9+hLv9P
         XnRhrf4KNB4Uj4/rfJ+ADraN5WQ4zupbQ2ztQlVPAeLtnLXSgVGffJ8d2xAbngjsiIwr
         kpRSdXCBGWG+y+TIudp1meRBVeFEfyXE6RbWJZQsvGdwA4x0i6uutn13hD8JEZ7UcBww
         7yJJuCxnhIL/Dk5idPjiSDLQn10KGZFoQ4PGV3rFTGo3s+INghRE3eDC/qi3+XqoqSVO
         AyZg==
X-Gm-Message-State: AOJu0YzAgspKiSADzP32inKedkYbTKHsstVCZKECrico3xcHclfmqCMD
	+CBrKcC4u4Kd0Mr/5BbnJVCRhNy5sw8WADHYqg8=
X-Google-Smtp-Source: AGHT+IF4LTmFQxadykDborHwetJ8pqWYYn9LbUePEy92IubMBSP9Q7MycDhRevGCicsDfB5lyYt5dAsDZjloWlQ3uz0=
X-Received: by 2002:a05:6820:390:b0:57c:6e35:251e with SMTP id
 r16-20020a056820039000b0057c6e35251emr10038284ooj.1.1696675399094; Sat, 07
 Oct 2023 03:43:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231006173055.2938160-1-michal.wilczynski@intel.com>
 <20231006173055.2938160-4-michal.wilczynski@intel.com> <CAJZ5v0jKJ6iw6Q=uYTf0at+ESkdCF0oWaXRmj7P5VLw+QppKPw@mail.gmail.com>
 <ZSEPGmCyhgSlMGRK@smile.fi.intel.com> <CAJZ5v0gF0O_d1rjOtiNj5ryXv-PURv0NgiRWyQECZZFcaBEsPQ@mail.gmail.com>
In-Reply-To: <CAJZ5v0gF0O_d1rjOtiNj5ryXv-PURv0NgiRWyQECZZFcaBEsPQ@mail.gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Sat, 7 Oct 2023 12:43:08 +0200
Message-ID: <CAJZ5v0iDhOFDX=k7xsC_=2jjerWmrP+Na-9PFM=YGA0V-hH2xw@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] ACPI: AC: Replace acpi_driver with platform_driver
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Michal Wilczynski <michal.wilczynski@intel.com>, linux-acpi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	rafael.j.wysocki@intel.com, lenb@kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 7, 2023 at 12:41=E2=80=AFPM Rafael J. Wysocki <rafael@kernel.or=
g> wrote:
>
> On Sat, Oct 7, 2023 at 9:56=E2=80=AFAM Andy Shevchenko
> <andriy.shevchenko@intel.com> wrote:
> >
> > On Fri, Oct 06, 2023 at 09:47:57PM +0200, Rafael J. Wysocki wrote:
> > > On Fri, Oct 6, 2023 at 8:33=E2=80=AFPM Michal Wilczynski
> > > <michal.wilczynski@intel.com> wrote:
> >
> > ...
> >
> > > >  struct acpi_ac {
> > > >         struct power_supply *charger;
> > > >         struct power_supply_desc charger_desc;
> > > > -       struct acpi_device *device;
> > > > +       struct device *dev;
> > >
> > > I'm not convinced about this change.
> > >
> > > If I'm not mistaken, you only use the dev pointer above to get the
> > > ACPI_COMPANION() of it, but the latter is already found in _probe(),
> > > so it can be stored in struct acpi_ac for later use and then the dev
> > > pointer in there will not be necessary any more.
> > >
> > > That will save you a bunch of ACPI_HANDLE() evaluations and there's
> > > nothing wrong with using ac->device->handle.  The patch will then
> > > become almost trivial AFAICS and if you really need to get from ac to
> > > the underlying platform device, a pointer to it can be added to struc=
t
> > > acpi_ac without removing the ACPI device pointer from it.
> >
> > The idea behind is to eliminate data duplication.
>
> What data duplication exactly do you mean?
>
> struct acpi_device *device is replaced with struct device *dev which
> is the same size.  The latter is then used to obtain a struct
> acpi_device pointer.  Why is it better to do this than to store the
> struct acpi_device itself?

This should be "store the struct acpi_device pointer itself", sorry.
