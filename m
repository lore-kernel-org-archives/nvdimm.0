Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A296C33E9
	for <nvdimm@lists.linux.dev>; Sat,  7 Oct 2023 10:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3ae473c0bd6so518942b6e.0
        for <nvdimm@lists.linux.dev>; Sat, 07 Oct 2023 03:41:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696675304; x=1697280104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yTW/418JZkwu1M4Lrtu4B4aaWXqu9uvEkO2zcTVWixQ=;
        b=gpySKrW6ZDZn6PMuV5mmGujlYBaW9/4lWyEoMbUESplcgiA+np+kU7Fc7PxDc3Lp1x
         qhifv1BX/izEs8R6x1VizSwOV6HN7mR43wF5CuyaOvbex+FklApaAN7qCNhfmED3uLI2
         EqwzOGSs++4y4nph/I0Y9LIk7OhVqiKDurpczLzuvx0Kb2Y4JFhxEAorfcz0JmFb5FU4
         fgGI01Cp4Vo4b25YWss18ceJ83d8Ui4CDfZYdjHkz4Wl8R4jcXELwGckF+vkI/Lg/fh2
         RBVtpettNH2pKcyfkBKYSieiQTmG5sdUGcV/Amp3L4SYu7Z724K548XSEhmkmpinwh9n
         zV1w==
X-Gm-Message-State: AOJu0YybsMScPYI8Q6r8yGWsTvYa9/0ZFlVas4Mv+iGQMaExw0U3ssSv
	S9K7OInQw1E1zNi4O39wFl7rGy7nTtzLZ0RrApU=
X-Google-Smtp-Source: AGHT+IElnJy2W5QsXitT56398qgWSwz4X/Hh6r4lGHpWl5jLtHpoo5Mgk4b1e57UGg9q95IQOyrUu8EPj/9KcGfgC3M=
X-Received: by 2002:a05:6808:21a6:b0:3ad:ae0d:f845 with SMTP id
 be38-20020a05680821a600b003adae0df845mr13923287oib.5.1696675304578; Sat, 07
 Oct 2023 03:41:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231006173055.2938160-1-michal.wilczynski@intel.com>
 <20231006173055.2938160-4-michal.wilczynski@intel.com> <CAJZ5v0jKJ6iw6Q=uYTf0at+ESkdCF0oWaXRmj7P5VLw+QppKPw@mail.gmail.com>
 <ZSEPGmCyhgSlMGRK@smile.fi.intel.com>
In-Reply-To: <ZSEPGmCyhgSlMGRK@smile.fi.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Sat, 7 Oct 2023 12:41:33 +0200
Message-ID: <CAJZ5v0gF0O_d1rjOtiNj5ryXv-PURv0NgiRWyQECZZFcaBEsPQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] ACPI: AC: Replace acpi_driver with platform_driver
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Michal Wilczynski <michal.wilczynski@intel.com>, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, rafael.j.wysocki@intel.com, lenb@kernel.org, 
	dan.j.williams@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 7, 2023 at 9:56=E2=80=AFAM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Fri, Oct 06, 2023 at 09:47:57PM +0200, Rafael J. Wysocki wrote:
> > On Fri, Oct 6, 2023 at 8:33=E2=80=AFPM Michal Wilczynski
> > <michal.wilczynski@intel.com> wrote:
>
> ...
>
> > >  struct acpi_ac {
> > >         struct power_supply *charger;
> > >         struct power_supply_desc charger_desc;
> > > -       struct acpi_device *device;
> > > +       struct device *dev;
> >
> > I'm not convinced about this change.
> >
> > If I'm not mistaken, you only use the dev pointer above to get the
> > ACPI_COMPANION() of it, but the latter is already found in _probe(),
> > so it can be stored in struct acpi_ac for later use and then the dev
> > pointer in there will not be necessary any more.
> >
> > That will save you a bunch of ACPI_HANDLE() evaluations and there's
> > nothing wrong with using ac->device->handle.  The patch will then
> > become almost trivial AFAICS and if you really need to get from ac to
> > the underlying platform device, a pointer to it can be added to struct
> > acpi_ac without removing the ACPI device pointer from it.
>
> The idea behind is to eliminate data duplication.

What data duplication exactly do you mean?

struct acpi_device *device is replaced with struct device *dev which
is the same size.  The latter is then used to obtain a struct
acpi_device pointer.  Why is it better to do this than to store the
struct acpi_device itself?
