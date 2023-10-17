Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0B742C0F
	for <nvdimm@lists.linux.dev>; Tue, 17 Oct 2023 13:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-57b68555467so239154eaf.0
        for <nvdimm@lists.linux.dev>; Tue, 17 Oct 2023 06:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697550443; x=1698155243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TEEvUysii4uahaQ0m8FHMZlpWtYsFuaPhm1RtmqNb/I=;
        b=eYep7wGY3Ps5yZVUQ/cmr0lnQ/cXdNscIXeh+DPfnlbTpa55jNJJYSF2IveReIFBMV
         V1yKzSSmUQqm1qbqEEFmxO9b3xi6RGp6ECblnFPysVMzPRo2jAgGqWRzEYmAvZ0Ow3Lo
         AgfXcaJmf8ZavoqNnvnCWA5lcOFDyLGUh6BddEHfl+gOJDmFwDz4aVf+BHPlZXMirVJP
         HdA9HXf/CO/pq6+gkl6CLAC9/r+9MToM7Uz9KAvFbOfDKvotajDT+x3tMCi9I5kVo/uB
         bSoBrUvMMi0WE9MEeuesyfHQNQ5BacaUKkFAgNuPKIbUQqR3KRaPEMJoP6ippOJFMd5Y
         GUHg==
X-Gm-Message-State: AOJu0YzDHkgs+FYjErzZ2vy0jQyEVnCf1ZHmRUeLKDPg3HOGD5no3GNm
	aQiHL5SMsMo7VZlC+nC4A/Opodf0GxqFDXm2tE0=
X-Google-Smtp-Source: AGHT+IHvC9t7RwmoWiCH+fc45p2WvfI4yDWp6+zzWG0l3byPuExgnl0gPyDSD5VjVF615t/FRF8ap94jk1WhzAYvt00=
X-Received: by 2002:a4a:d898:0:b0:581:84e9:a7ad with SMTP id
 b24-20020a4ad898000000b0058184e9a7admr2203536oov.1.1697550443146; Tue, 17 Oct
 2023 06:47:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231011083334.3987477-1-michal.wilczynski@intel.com> <20231011083334.3987477-5-michal.wilczynski@intel.com>
In-Reply-To: <20231011083334.3987477-5-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 17 Oct 2023 15:47:12 +0200
Message-ID: <CAJZ5v0gD-wjDVO_YRZRjn99y-UOTg5i4=2iVNzLgOfYF4bqJvA@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] ACPI: AC: Rename ACPI device from device to adev
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, rafael@kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, lenb@kernel.org, dave.jiang@intel.com, 
	ira.weiny@intel.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 11, 2023 at 10:34=E2=80=AFAM Michal Wilczynski
<michal.wilczynski@intel.com> wrote:
>
> Since transformation from ACPI driver to platform driver there are two
> devices on which the driver operates - ACPI device and platform device.
> For the sake of reader this calls for the distinction in their naming,
> to avoid confusion. Rename device to adev, as corresponding
> platform device is called pdev.
>
> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
>  drivers/acpi/ac.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
> index 1dd4919be7ac..2618a7ccc11c 100644
> --- a/drivers/acpi/ac.c
> +++ b/drivers/acpi/ac.c
> @@ -121,11 +121,11 @@ static void acpi_ac_notify(acpi_handle handle, u32 =
event, void *data)
>  {
>         struct device *dev =3D data;
>         struct acpi_ac *ac =3D dev_get_drvdata(dev);
> -       struct acpi_device *device =3D ACPI_COMPANION(dev);
> +       struct acpi_device *adev =3D ACPI_COMPANION(dev);
>
>         switch (event) {
>         default:
> -               acpi_handle_debug(device->handle, "Unsupported event [0x%=
x]\n",
> +               acpi_handle_debug(adev->handle, "Unsupported event [0x%x]=
\n",
>                                   event);
>                 fallthrough;
>         case ACPI_AC_NOTIFY_STATUS:
> @@ -142,11 +142,11 @@ static void acpi_ac_notify(acpi_handle handle, u32 =
event, void *data)
>                         msleep(ac_sleep_before_get_state_ms);
>
>                 acpi_ac_get_state(ac);
> -               acpi_bus_generate_netlink_event(device->pnp.device_class,
> +               acpi_bus_generate_netlink_event(adev->pnp.device_class,
>                                                 dev_name(dev),
>                                                 event,
>                                                 ac->state);
> -               acpi_notifier_call_chain(device, event, ac->state);
> +               acpi_notifier_call_chain(adev, event, ac->state);
>                 kobject_uevent(&ac->charger->dev.kobj, KOBJ_CHANGE);
>         }
>  }
> @@ -205,7 +205,7 @@ static const struct dmi_system_id ac_dmi_table[]  __i=
nitconst =3D {
>
>  static int acpi_ac_probe(struct platform_device *pdev)
>  {
> -       struct acpi_device *device =3D ACPI_COMPANION(&pdev->dev);
> +       struct acpi_device *adev =3D ACPI_COMPANION(&pdev->dev);
>         struct power_supply_config psy_cfg =3D {};
>         struct acpi_ac *ac;
>         int result;
> @@ -214,9 +214,9 @@ static int acpi_ac_probe(struct platform_device *pdev=
)
>         if (!ac)
>                 return -ENOMEM;
>
> -       ac->device =3D device;
> -       strcpy(acpi_device_name(device), ACPI_AC_DEVICE_NAME);
> -       strcpy(acpi_device_class(device), ACPI_AC_CLASS);
> +       ac->device =3D adev;
> +       strcpy(acpi_device_name(adev), ACPI_AC_DEVICE_NAME);
> +       strcpy(acpi_device_class(adev), ACPI_AC_CLASS);
>
>         platform_set_drvdata(pdev, ac);
>
> @@ -226,7 +226,7 @@ static int acpi_ac_probe(struct platform_device *pdev=
)
>
>         psy_cfg.drv_data =3D ac;
>
> -       ac->charger_desc.name =3D acpi_device_bid(device);
> +       ac->charger_desc.name =3D acpi_device_bid(adev);
>         ac->charger_desc.type =3D POWER_SUPPLY_TYPE_MAINS;
>         ac->charger_desc.properties =3D ac_props;
>         ac->charger_desc.num_properties =3D ARRAY_SIZE(ac_props);
> @@ -238,13 +238,13 @@ static int acpi_ac_probe(struct platform_device *pd=
ev)
>                 goto err_release_ac;
>         }
>
> -       pr_info("%s [%s] (%s-line)\n", acpi_device_name(device),
> -               acpi_device_bid(device), str_on_off(ac->state));
> +       pr_info("%s [%s] (%s-line)\n", acpi_device_name(adev),
> +               acpi_device_bid(adev), str_on_off(ac->state));
>
>         ac->battery_nb.notifier_call =3D acpi_ac_battery_notify;
>         register_acpi_notifier(&ac->battery_nb);
>
> -       result =3D acpi_dev_install_notify_handler(device, ACPI_ALL_NOTIF=
Y,
> +       result =3D acpi_dev_install_notify_handler(adev, ACPI_ALL_NOTIFY,
>                                                  acpi_ac_notify, &pdev->d=
ev);
>         if (result)
>                 goto err_unregister;
> --

Rebased on top of current linux-next and applied as 6.7 material, thanks!
