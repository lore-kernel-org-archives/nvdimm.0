Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898A510781
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 09:45:50 +0000 (UTC)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-98de322d11fso47002066b.1
        for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 02:45:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688118348; x=1690710348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Vw8jMWNOm82RPNOF2hjNaDBARTFH1+TBodiiRe6jac=;
        b=eglbb9CmpVU1QJcluYneEKwKH6/4Fsy7QYdp43YKQWxvyMZXQzwCY0Sfogh0I+NAAw
         yZ138+SeHIA9njIL/v8brL5JaTrYFEJN2shnPiyB2aon2mt9ghAFE4UFf1Ih9JLq+d3W
         QMIgqNph+KPjsRe8jzYZsOsyz7uJw0h8qtF6nwhjIadGNwhWsaLU95EOlbwMLgdCMwsR
         11+Z8E/3IMA7NeMdk144xUgW+P8v6NqTJlPQ+aiEYu/hS+h6AcQvlfo3MnMCjneQfCdp
         rUAhTAN76nzSTFeFbJIqxu6rvqKz0FlECY1+SNGPlLfC4GOEJ8u9YuEEN/eUcH3Oy/45
         H28g==
X-Gm-Message-State: ABy/qLYt/Ey9LAt1LF0KcNJMc4SKSQLicnQB21WSs+iwNekT111MX5Yf
	2v1jXJamWVlS53+96BOsTcH/rU5Zb96eIxoj9GI=
X-Google-Smtp-Source: APBJJlEGmpAmEljK1mrMe58BsdmDqPNaakW6BsCreX0ihf6RbLR0X6656Z/A97c7B1QNWPH652dexyylEL9xVKx14bw=
X-Received: by 2002:a17:906:199b:b0:976:50a4:ac40 with SMTP id
 g27-20020a170906199b00b0097650a4ac40mr1491509ejd.0.1688118348393; Fri, 30 Jun
 2023 02:45:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616165034.3630141-1-michal.wilczynski@intel.com>
 <20230616165034.3630141-4-michal.wilczynski@intel.com> <CAJZ5v0ippMo1Haa-YFszyWZNgUE_pPUtkFngQWjUyjJe4tm94g@mail.gmail.com>
 <ff596664-1062-92ff-a1fe-3b644925aeae@intel.com> <CAJZ5v0gj5Pf_Ut0v+gTd34ubpGOs7okitFEXV3eFJxPPHYFrgw@mail.gmail.com>
In-Reply-To: <CAJZ5v0gj5Pf_Ut0v+gTd34ubpGOs7okitFEXV3eFJxPPHYFrgw@mail.gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 30 Jun 2023 11:45:37 +0200
Message-ID: <CAJZ5v0hNaL6Y0AGmpC2bJ0X3Fxd0qAkJnY1nzoYQWGopQSmG0A@mail.gmail.com>
Subject: Re: [PATCH v5 03/10] acpi/ac: Move handler installing logic to driver
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, linux-acpi@vger.kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, lenb@kernel.org, dave.jiang@intel.com, 
	ira.weiny@intel.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 30, 2023 at 11:41=E2=80=AFAM Rafael J. Wysocki <rafael@kernel.o=
rg> wrote:
>
> On Fri, Jun 30, 2023 at 11:39=E2=80=AFAM Wilczynski, Michal
> <michal.wilczynski@intel.com> wrote:
> >
> >
> >
> > On 6/29/2023 5:55 PM, Rafael J. Wysocki wrote:
> > > On Fri, Jun 16, 2023 at 6:51=E2=80=AFPM Michal Wilczynski
> > > <michal.wilczynski@intel.com> wrote:
> > >> Currently logic for installing notifications from ACPI devices is
> > >> implemented using notify callback in struct acpi_driver. Preparation=
s
> > >> are being made to replace acpi_driver with more generic struct
> > >> platform_driver, which doesn't contain notify callback. Furthermore
> > >> as of now handlers are being called indirectly through
> > >> acpi_notify_device(), which decreases performance.
> > >>
> > >> Call acpi_dev_install_notify_handler() at the end of .add() callback=
.
> > >> Call acpi_dev_remove_notify_handler() at the beginning of .remove()
> > >> callback. Change arguments passed to the notify function to match wi=
th
> > >> what's required by acpi_install_notify_handler(). Remove .notify
> > >> callback initialization in acpi_driver.
> > >>
> > >> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > >> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> > >> ---
> > >>  drivers/acpi/ac.c | 33 ++++++++++++++++++++++++---------
> > >>  1 file changed, 24 insertions(+), 9 deletions(-)
> > >>
> > >> diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
> > >> index 1ace70b831cd..207ee3c85bad 100644
> > >> --- a/drivers/acpi/ac.c
> > >> +++ b/drivers/acpi/ac.c
> > >> @@ -34,7 +34,7 @@ MODULE_LICENSE("GPL");
> > >>
> > >>  static int acpi_ac_add(struct acpi_device *device);
> > >>  static void acpi_ac_remove(struct acpi_device *device);
> > >> -static void acpi_ac_notify(struct acpi_device *device, u32 event);
> > >> +static void acpi_ac_notify(acpi_handle handle, u32 event, void *dat=
a);
> > >>
> > >>  static const struct acpi_device_id ac_device_ids[] =3D {
> > >>         {"ACPI0003", 0},
> > >> @@ -54,11 +54,9 @@ static struct acpi_driver acpi_ac_driver =3D {
> > >>         .name =3D "ac",
> > >>         .class =3D ACPI_AC_CLASS,
> > >>         .ids =3D ac_device_ids,
> > >> -       .flags =3D ACPI_DRIVER_ALL_NOTIFY_EVENTS,
> > >>         .ops =3D {
> > >>                 .add =3D acpi_ac_add,
> > >>                 .remove =3D acpi_ac_remove,
> > >> -               .notify =3D acpi_ac_notify,
> > >>                 },
> > >>         .drv.pm =3D &acpi_ac_pm,
> > >>  };
> > >> @@ -128,9 +126,12 @@ static enum power_supply_property ac_props[] =
=3D {
> > >>  };
> > >>
> > >>  /* Driver Model */
> > >> -static void acpi_ac_notify(struct acpi_device *device, u32 event)
> > >> +static void acpi_ac_notify(acpi_handle handle, u32 event, void *dat=
a)
> > >>  {
> > >> -       struct acpi_ac *ac =3D acpi_driver_data(device);
> > > This line doesn't need to be changed.  Just add the device variable
> > > definition above it.
> > >
> > > And the same pattern is present in the other patches in the series.
> >
> > I like the Reverse Christmas Tree, but sure will change that
>
> I do too, but in the cases when it costs 3 extra lines of code I'd
> rather have something simpler.

Besides, moving code around is not strictly related to the functional
changes made by the patch and it kind of hides those changes.  It is
better to move code around in a separate patch if you really want to
do that.
