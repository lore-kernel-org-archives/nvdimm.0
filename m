Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD1F20E0
	for <nvdimm@lists.linux.dev>; Sun, 22 Oct 2023 10:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1e9c28f8193so715745fac.1
        for <nvdimm@lists.linux.dev>; Sun, 22 Oct 2023 03:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697972005; x=1698576805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gfYc3oyXjD26uJSjhhKNLi/S0Ywtcen6nLz0AHIHCTk=;
        b=kWHZ5zSyjNWcAq0Zy4aMosc+XDTWulQVFD6Rp9LGkwtrQZ/lUaAARRk+Sh9h7ZXnZ6
         GVau4mitpBx0kLtbKxkD61rhXplHtY5OdjYMr5PcuB9hKoqOeaLTl3ATESSzab3aOlBY
         nOTqzJ2AcR7NJr/aH3Bc1jNzJjGzVu4tvZlNx6URTlbT7zBv1yMUvp3lyhByRZQbr+s/
         cRmjRkOZu85GqaWs2lb7LNdHQJHweyyrYYFuh5F7Lq+NmJVYfz1UT9hlcHPebXOAs60Z
         0zc1plKXs6IUDLwL+C1yC2WmB5p0JGRbGlczWoJtPAImNRQd4Ax3ELFMV1SynGjkBY/w
         RXJQ==
X-Gm-Message-State: AOJu0YxBdjACpLluUFxcPPGYMU4JQddVkLow9Q2uGxu6vjsHSHn7vU1H
	6CheM1rSd8xgLsjVt/FMcjpvpVLmuLh0jSgdMJw=
X-Google-Smtp-Source: AGHT+IE5RXtXxjmh42dzyiNfUTMBz+d9mDkBuS9KV5pGOqunuJIGgE+tpclPHGNBtfKVkVuqZBCn7lHUUNiyaJEi1fI=
X-Received: by 2002:a05:6870:9e47:b0:1e1:e6ee:94b6 with SMTP id
 pt7-20020a0568709e4700b001e1e6ee94b6mr8440632oab.4.1697972004824; Sun, 22 Oct
 2023 03:53:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1697720481-150095-1-git-send-email-chenxiang66@hisilicon.com>
 <CAJZ5v0j0A4637V5OEtjP-HMGhH80T=1kPjO_QXbgbBSZHvJY=w@mail.gmail.com> <6532e292ae459_21a972945@iweiny-mobl.notmuch>
In-Reply-To: <6532e292ae459_21a972945@iweiny-mobl.notmuch>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Sun, 22 Oct 2023 12:53:12 +0200
Message-ID: <CAJZ5v0hU0Sm2Z7oAshfUqL_k5+-iytr1e4T0us2G3YW48NobiQ@mail.gmail.com>
Subject: Re: [PATCH] Install Notify() handler before getting NFIT table
To: Ira Weiny <ira.weiny@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, chenxiang <chenxiang66@hisilicon.com>, 
	"Williams, Dan J" <dan.j.williams@intel.com>, 
	"Wilczynski, Michal" <michal.wilczynski@intel.com>, "linuxarm@huawei.com" <linuxarm@huawei.com>, 
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 20, 2023 at 10:27=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wr=
ote:
>
> Rafael J. Wysocki wrote:
> > On Thu, Oct 19, 2023 at 2:57=E2=80=AFPM chenxiang <chenxiang66@hisilico=
n.com> wrote:
> > >
> > > From: Xiang Chen <chenxiang66@hisilicon.com>
> > >
> > > If there is no NFIT at startup, it will return 0 immediately in funct=
ion
> > > acpi_nfit_add() and will not install Notify() handler. If hotplugging
> > > a nvdimm device later, it will not be identified as there is no Notif=
y()
> > > handler.
> >
> > Yes, this is a change in behavior that shouldn't have been made.
> >
> > > So move handler installing before getting NFI table in function
> > > acpi_nfit_add() to avoid above issue.
> >
> > And the fix is correct if I'm not mistaken.
> >
> > I can still queue it up for 6.6 if that's fine with everyone.  Dan?
>
> That is fine with me.  Vishal, Dave Jiang, and I are wrangling the nvdimm
> tree these days.  I've prepared 6.7 already so I'll ignore this.

Applied now (with some minor edits in the subject and changelog).

Thanks!

> > > Fixes: dcca12ab62a2 ("ACPI: NFIT: Install Notify() handler directly")
> > > Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> > > ---
> > >  drivers/acpi/nfit/core.c | 22 +++++++++++-----------
> > >  1 file changed, 11 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> > > index 3826f49..9923855 100644
> > > --- a/drivers/acpi/nfit/core.c
> > > +++ b/drivers/acpi/nfit/core.c
> > > @@ -3339,6 +3339,16 @@ static int acpi_nfit_add(struct acpi_device *a=
dev)
> > >         acpi_size sz;
> > >         int rc =3D 0;
> > >
> > > +       rc =3D acpi_dev_install_notify_handler(adev, ACPI_DEVICE_NOTI=
FY,
> > > +                                            acpi_nfit_notify, adev);
> > > +       if (rc)
> > > +               return rc;
> > > +
> > > +       rc =3D devm_add_action_or_reset(dev, acpi_nfit_remove_notify_=
handler,
> > > +                                       adev);
> > > +       if (rc)
> > > +               return rc;
> > > +
> > >         status =3D acpi_get_table(ACPI_SIG_NFIT, 0, &tbl);
> > >         if (ACPI_FAILURE(status)) {
> > >                 /* The NVDIMM root device allows OS to trigger enumer=
ation of
> > > @@ -3386,17 +3396,7 @@ static int acpi_nfit_add(struct acpi_device *a=
dev)
> > >         if (rc)
> > >                 return rc;
> > >
> > > -       rc =3D devm_add_action_or_reset(dev, acpi_nfit_shutdown, acpi=
_desc);
> > > -       if (rc)
> > > -               return rc;
> > > -
> > > -       rc =3D acpi_dev_install_notify_handler(adev, ACPI_DEVICE_NOTI=
FY,
> > > -                                            acpi_nfit_notify, adev);
> > > -       if (rc)
> > > -               return rc;
> > > -
> > > -       return devm_add_action_or_reset(dev, acpi_nfit_remove_notify_=
handler,
> > > -                                       adev);
> > > +       return devm_add_action_or_reset(dev, acpi_nfit_shutdown, acpi=
_desc);
> > >  }
> > >
> > >  static void acpi_nfit_update_notify(struct device *dev, acpi_handle =
handle)
> > > --
> >
>
>
