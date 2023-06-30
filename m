Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2F1101D7
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 09:42:08 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-98de322d11fso46924966b.1
        for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 02:42:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688118127; x=1690710127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jZpg7j29IcHevI8isRdjcHQ2oRleGwDUzQEzfJdoDFY=;
        b=hMdjn+GkzR2XforclHMfaxJJPRCq+rQATam5TuVluZ1PjUVyXsoWaTDPVgQ6JdVyDx
         lvHYMsJXJ/tEce8Nams7XQCaPrBnGJKRZ8x/RWxsD195iX7rIgZEgPEIitq5EXJK4QdH
         L+kmCblPqs0UoqFRujNfWe0S5q7eAZw4FmadklWdj0TNsgG0vM+ra9Zuw03e49gOyn1M
         iZLUGG/TsnqwqcJbXxn0ziQZkDSLhj7kvsPcCVMrILugAY0nEgHDoiwoeGeNCo0MWJ3Y
         AZjusyXt2RCttS6xGnFp7wo1YHmQlSRMcFPpdNj7Ps2Rmerfdy+lCSsfi/EaCx5LOwGC
         3wmg==
X-Gm-Message-State: ABy/qLa6CTgdD3vkNgjnpM6q8BhwbyFDay2M1PjFHyqqwJvGGhyRQKCH
	ciymRzd24Z/J/1VZ56pDpZQOd3jruaFIzFUoO8Q=
X-Google-Smtp-Source: APBJJlEXmTXglnxuJIbSAEFuDI2+6cXTmvC5sVmuqo7iRowBLSGO8SvISOeYEiE7ZKu52nF0x+BIrKoePPzvTvF1+mg=
X-Received: by 2002:a17:906:29ce:b0:987:115d:ba05 with SMTP id
 y14-20020a17090629ce00b00987115dba05mr1523902eje.3.1688118126723; Fri, 30 Jun
 2023 02:42:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616165034.3630141-1-michal.wilczynski@intel.com>
 <20230616165034.3630141-4-michal.wilczynski@intel.com> <CAJZ5v0ippMo1Haa-YFszyWZNgUE_pPUtkFngQWjUyjJe4tm94g@mail.gmail.com>
 <ff596664-1062-92ff-a1fe-3b644925aeae@intel.com>
In-Reply-To: <ff596664-1062-92ff-a1fe-3b644925aeae@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 30 Jun 2023 11:41:55 +0200
Message-ID: <CAJZ5v0gj5Pf_Ut0v+gTd34ubpGOs7okitFEXV3eFJxPPHYFrgw@mail.gmail.com>
Subject: Re: [PATCH v5 03/10] acpi/ac: Move handler installing logic to driver
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, linux-acpi@vger.kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, lenb@kernel.org, dave.jiang@intel.com, 
	ira.weiny@intel.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 30, 2023 at 11:39=E2=80=AFAM Wilczynski, Michal
<michal.wilczynski@intel.com> wrote:
>
>
>
> On 6/29/2023 5:55 PM, Rafael J. Wysocki wrote:
> > On Fri, Jun 16, 2023 at 6:51=E2=80=AFPM Michal Wilczynski
> > <michal.wilczynski@intel.com> wrote:
> >> Currently logic for installing notifications from ACPI devices is
> >> implemented using notify callback in struct acpi_driver. Preparations
> >> are being made to replace acpi_driver with more generic struct
> >> platform_driver, which doesn't contain notify callback. Furthermore
> >> as of now handlers are being called indirectly through
> >> acpi_notify_device(), which decreases performance.
> >>
> >> Call acpi_dev_install_notify_handler() at the end of .add() callback.
> >> Call acpi_dev_remove_notify_handler() at the beginning of .remove()
> >> callback. Change arguments passed to the notify function to match with
> >> what's required by acpi_install_notify_handler(). Remove .notify
> >> callback initialization in acpi_driver.
> >>
> >> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> >> ---
> >>  drivers/acpi/ac.c | 33 ++++++++++++++++++++++++---------
> >>  1 file changed, 24 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
> >> index 1ace70b831cd..207ee3c85bad 100644
> >> --- a/drivers/acpi/ac.c
> >> +++ b/drivers/acpi/ac.c
> >> @@ -34,7 +34,7 @@ MODULE_LICENSE("GPL");
> >>
> >>  static int acpi_ac_add(struct acpi_device *device);
> >>  static void acpi_ac_remove(struct acpi_device *device);
> >> -static void acpi_ac_notify(struct acpi_device *device, u32 event);
> >> +static void acpi_ac_notify(acpi_handle handle, u32 event, void *data)=
;
> >>
> >>  static const struct acpi_device_id ac_device_ids[] =3D {
> >>         {"ACPI0003", 0},
> >> @@ -54,11 +54,9 @@ static struct acpi_driver acpi_ac_driver =3D {
> >>         .name =3D "ac",
> >>         .class =3D ACPI_AC_CLASS,
> >>         .ids =3D ac_device_ids,
> >> -       .flags =3D ACPI_DRIVER_ALL_NOTIFY_EVENTS,
> >>         .ops =3D {
> >>                 .add =3D acpi_ac_add,
> >>                 .remove =3D acpi_ac_remove,
> >> -               .notify =3D acpi_ac_notify,
> >>                 },
> >>         .drv.pm =3D &acpi_ac_pm,
> >>  };
> >> @@ -128,9 +126,12 @@ static enum power_supply_property ac_props[] =3D =
{
> >>  };
> >>
> >>  /* Driver Model */
> >> -static void acpi_ac_notify(struct acpi_device *device, u32 event)
> >> +static void acpi_ac_notify(acpi_handle handle, u32 event, void *data)
> >>  {
> >> -       struct acpi_ac *ac =3D acpi_driver_data(device);
> > This line doesn't need to be changed.  Just add the device variable
> > definition above it.
> >
> > And the same pattern is present in the other patches in the series.
>
> I like the Reverse Christmas Tree, but sure will change that

I do too, but in the cases when it costs 3 extra lines of code I'd
rather have something simpler.
