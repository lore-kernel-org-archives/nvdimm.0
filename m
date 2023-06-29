Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE0B12B89
	for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 15:56:03 +0000 (UTC)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-98502b12fd4so21601266b.1
        for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 08:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688054162; x=1690646162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NanhwP3ZvzSNrv3gc9fvxwRqCsfI8QWgmtWgVz7PxTU=;
        b=KXze9yrvsVFW76iv0+KFLbo8LQQrQsd5ic25Hk55dPkb63z71PXxnhu2h5VfrhbAUm
         E79Ku1ODLXS68+A8GAjhlvcxmBdrbc10AMpb1FtXNKoYdLf9VTBmLhOPCe6ARDEyKAtI
         Qi7Y6GXDvHmXUASyrBcYIddsJPeJMbY0qlzZiV8p/eUj6tjDxtxRY3IxYeX+iqq73Zj4
         TI6m4HtZjCwDPMoXrzEhAHkT3U2GmuHB5zVjW/Nv8hcq9VbSKQNpsB/luP76yzUESce8
         YyK0uoVk1ST+Xu3LAbDFTjlDxbHqOhn019k0rVE+A1eNuDzJa6+lMuh+ycZPKJh2j9FX
         GBDw==
X-Gm-Message-State: AC+VfDxrvX+BZ70hK0fM0cDDqmJuEq5C2/rY+CdHRVqa6WZTRypm+w3S
	mXolv2pbzTcu22iIqlf/5X+bGHgZ2CgBavkYv9o=
X-Google-Smtp-Source: ACHHUZ6JS90WyEgMYObZ9p9DRC2xaF5Mo3SHtPTnXmhMUmPa+3yMH2tHtxa/bayz2xhkDknvPVpKxFBXvXNpMQ8USYc=
X-Received: by 2002:a17:906:7496:b0:988:815c:ba09 with SMTP id
 e22-20020a170906749600b00988815cba09mr2452887ejl.4.1688054161659; Thu, 29 Jun
 2023 08:56:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616165034.3630141-1-michal.wilczynski@intel.com> <20230616165034.3630141-4-michal.wilczynski@intel.com>
In-Reply-To: <20230616165034.3630141-4-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 29 Jun 2023 17:55:50 +0200
Message-ID: <CAJZ5v0ippMo1Haa-YFszyWZNgUE_pPUtkFngQWjUyjJe4tm94g@mail.gmail.com>
Subject: Re: [PATCH v5 03/10] acpi/ac: Move handler installing logic to driver
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, rafael@kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, lenb@kernel.org, dave.jiang@intel.com, 
	ira.weiny@intel.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16, 2023 at 6:51=E2=80=AFPM Michal Wilczynski
<michal.wilczynski@intel.com> wrote:
>
> Currently logic for installing notifications from ACPI devices is
> implemented using notify callback in struct acpi_driver. Preparations
> are being made to replace acpi_driver with more generic struct
> platform_driver, which doesn't contain notify callback. Furthermore
> as of now handlers are being called indirectly through
> acpi_notify_device(), which decreases performance.
>
> Call acpi_dev_install_notify_handler() at the end of .add() callback.
> Call acpi_dev_remove_notify_handler() at the beginning of .remove()
> callback. Change arguments passed to the notify function to match with
> what's required by acpi_install_notify_handler(). Remove .notify
> callback initialization in acpi_driver.
>
> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
>  drivers/acpi/ac.c | 33 ++++++++++++++++++++++++---------
>  1 file changed, 24 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
> index 1ace70b831cd..207ee3c85bad 100644
> --- a/drivers/acpi/ac.c
> +++ b/drivers/acpi/ac.c
> @@ -34,7 +34,7 @@ MODULE_LICENSE("GPL");
>
>  static int acpi_ac_add(struct acpi_device *device);
>  static void acpi_ac_remove(struct acpi_device *device);
> -static void acpi_ac_notify(struct acpi_device *device, u32 event);
> +static void acpi_ac_notify(acpi_handle handle, u32 event, void *data);
>
>  static const struct acpi_device_id ac_device_ids[] =3D {
>         {"ACPI0003", 0},
> @@ -54,11 +54,9 @@ static struct acpi_driver acpi_ac_driver =3D {
>         .name =3D "ac",
>         .class =3D ACPI_AC_CLASS,
>         .ids =3D ac_device_ids,
> -       .flags =3D ACPI_DRIVER_ALL_NOTIFY_EVENTS,
>         .ops =3D {
>                 .add =3D acpi_ac_add,
>                 .remove =3D acpi_ac_remove,
> -               .notify =3D acpi_ac_notify,
>                 },
>         .drv.pm =3D &acpi_ac_pm,
>  };
> @@ -128,9 +126,12 @@ static enum power_supply_property ac_props[] =3D {
>  };
>
>  /* Driver Model */
> -static void acpi_ac_notify(struct acpi_device *device, u32 event)
> +static void acpi_ac_notify(acpi_handle handle, u32 event, void *data)
>  {
> -       struct acpi_ac *ac =3D acpi_driver_data(device);

This line doesn't need to be changed.  Just add the device variable
definition above it.

And the same pattern is present in the other patches in the series.

> +       struct acpi_device *device =3D data;
> +       struct acpi_ac *ac;
> +
> +       ac =3D acpi_driver_data(device);
>
>         if (!ac)
>                 return;
