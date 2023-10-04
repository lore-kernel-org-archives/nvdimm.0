Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AE11BDCB
	for <nvdimm@lists.linux.dev>; Wed,  4 Oct 2023 19:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-57bc11c197aso23715eaf.1
        for <nvdimm@lists.linux.dev>; Wed, 04 Oct 2023 12:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696446569; x=1697051369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NIRRcUEkY2QwDUo2YxYjdPZlFGlVEIduNYlZzLi872Y=;
        b=Rk/JfuXgZI4uZpLqjNoI9M2+kxbi3SXcSueoDuN/ZWtbNbg7n6935kt2v/p+rprgpp
         rs8hw1/4Hc+rJD95xSmQBe8dRci9dh8AxtjK9eCZybIdtql+ZbbsLaUzeHLq0D72XVQc
         6JAMwj9uKE3hGYwgIW1zmrDq3H6VdRKvZ1Wf1pz5I90w8wdcKCUgsr0oLNKFTl9GgPbc
         NV27YSUbt0Tk+b3S3adsb9893qVTdr3a3LPp7PfbXmlhhCYeOAhkgQil6wZfdNAdekK4
         /62P6Xzn2YlaZJkFzslP3m2ANrT074VFrTCAJcWwc+mEPZh6yCyb3m3Kyy1IwKZSWqwZ
         GWdw==
X-Gm-Message-State: AOJu0Yxc2RTst3DzHLiQaixXbLNM4cbJ4gxgAntBR1QGd21XQ/MaehJ5
	bcL6YiSBqOwhkKfz6LCeHI4QKHZAP4k/bJLjbJA=
X-Google-Smtp-Source: AGHT+IEoiOp7mEVinpVKZsIBFCfod83bd7/eQFof7tFvi/KF10mIwMRAx6EP0sSZomQ/E9+6rGDV6xxCflMP4uLidoI=
X-Received: by 2002:a4a:d097:0:b0:57b:7e31:c12 with SMTP id
 i23-20020a4ad097000000b0057b7e310c12mr3211586oor.1.1696446569455; Wed, 04 Oct
 2023 12:09:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230925144842.586829-1-michal.wilczynski@intel.com> <20230925144842.586829-2-michal.wilczynski@intel.com>
In-Reply-To: <20230925144842.586829-2-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 4 Oct 2023 21:09:18 +0200
Message-ID: <CAJZ5v0jyjH48XZ6vytncodYhsS6ODYg2yaZBPfRWb_qm99FMuA@mail.gmail.com>
Subject: Re: [PATCH v1 1/9] ACPI: bus: Make notify wrappers more generic
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, rafael.j.wysocki@intel.com, 
	andriy.shevchenko@intel.com, lenb@kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, ira.weiny@intel.com, rui.zhang@intel.com, 
	Andy Shevchenko <andy.shevchenko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 25, 2023 at 6:31=E2=80=AFPM Michal Wilczynski
<michal.wilczynski@intel.com> wrote:
>
> acpi_dev_install_notify_handler() and acpi_dev_remove_notify_handler()
> are wrappers around ACPICA installers. They are meant to save some
> duplicated code from drivers. However as we're moving towards drivers
> operating on platform_device they become a bit inconvenient to use as
> inside the driver code we mostly want to use driver data of platform
> device instead of ACPI device.

That's fair enough, but ->

> Make notify handlers installer wrappers more generic, while still
> saving some code that would be duplicated otherwise.
>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
>
> Notes:
>     So one solution could be to just replace acpi_device with
>     platform_device as an argument in those functions. However I don't
>     believe this is a correct solution, as it is very often the case that
>     drivers declare their own private structures which gets allocated dur=
ing
>     the .probe() callback, and become the heart of the driver. When drive=
rs
>     do that it makes much more sense to just pass the private structure
>     to the notify handler instead of forcing user to dance with the
>     platform_device or acpi_device.
>
>  drivers/acpi/ac.c         |  6 +++---
>  drivers/acpi/acpi_video.c |  6 +++---
>  drivers/acpi/battery.c    |  6 +++---
>  drivers/acpi/bus.c        | 14 ++++++--------
>  drivers/acpi/hed.c        |  6 +++---
>  drivers/acpi/nfit/core.c  |  6 +++---
>  drivers/acpi/thermal.c    |  6 +++---
>  include/acpi/acpi_bus.h   |  9 ++++-----
>  8 files changed, 28 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
> index 225dc6818751..0b245f9f7ec8 100644
> --- a/drivers/acpi/ac.c
> +++ b/drivers/acpi/ac.c
> @@ -256,8 +256,8 @@ static int acpi_ac_add(struct acpi_device *device)
>         ac->battery_nb.notifier_call =3D acpi_ac_battery_notify;
>         register_acpi_notifier(&ac->battery_nb);
>
> -       result =3D acpi_dev_install_notify_handler(device, ACPI_ALL_NOTIF=
Y,
> -                                                acpi_ac_notify);
> +       result =3D acpi_dev_install_notify_handler(device->handle, ACPI_A=
LL_NOTIFY,
> +                                                acpi_ac_notify, device);
>         if (result)
>                 goto err_unregister;
>
> @@ -306,7 +306,7 @@ static void acpi_ac_remove(struct acpi_device *device=
)
>
>         ac =3D acpi_driver_data(device);
>
> -       acpi_dev_remove_notify_handler(device, ACPI_ALL_NOTIFY,
> +       acpi_dev_remove_notify_handler(device->handle, ACPI_ALL_NOTIFY,
>                                        acpi_ac_notify);
>         power_supply_unregister(ac->charger);
>         unregister_acpi_notifier(&ac->battery_nb);
> diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
> index 948e31f7ce6e..025c17890127 100644
> --- a/drivers/acpi/acpi_video.c
> +++ b/drivers/acpi/acpi_video.c
> @@ -2059,8 +2059,8 @@ static int acpi_video_bus_add(struct acpi_device *d=
evice)
>
>         acpi_video_bus_add_notify_handler(video);
>
> -       error =3D acpi_dev_install_notify_handler(device, ACPI_DEVICE_NOT=
IFY,
> -                                               acpi_video_bus_notify);
> +       error =3D acpi_dev_install_notify_handler(device->handle, ACPI_DE=
VICE_NOTIFY,
> +                                               acpi_video_bus_notify, de=
vice);
>         if (error)
>                 goto err_remove;
>
> @@ -2092,7 +2092,7 @@ static void acpi_video_bus_remove(struct acpi_devic=
e *device)
>
>         video =3D acpi_driver_data(device);
>
> -       acpi_dev_remove_notify_handler(device, ACPI_DEVICE_NOTIFY,
> +       acpi_dev_remove_notify_handler(device->handle, ACPI_DEVICE_NOTIFY=
,
>                                        acpi_video_bus_notify);
>
>         mutex_lock(&video_list_lock);
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index 969bf81e8d54..45dae32a8646 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -1213,8 +1213,8 @@ static int acpi_battery_add(struct acpi_device *dev=
ice)
>
>         device_init_wakeup(&device->dev, 1);
>
> -       result =3D acpi_dev_install_notify_handler(device, ACPI_ALL_NOTIF=
Y,
> -                                                acpi_battery_notify);
> +       result =3D acpi_dev_install_notify_handler(device->handle, ACPI_A=
LL_NOTIFY,
> +                                                acpi_battery_notify, dev=
ice);
>         if (result)
>                 goto fail_pm;
>
> @@ -1241,7 +1241,7 @@ static void acpi_battery_remove(struct acpi_device =
*device)
>
>         battery =3D acpi_driver_data(device);
>
> -       acpi_dev_remove_notify_handler(device, ACPI_ALL_NOTIFY,
> +       acpi_dev_remove_notify_handler(device->handle, ACPI_ALL_NOTIFY,
>                                        acpi_battery_notify);
>
>         device_init_wakeup(&device->dev, 0);
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index f41dda2d3493..479fe888d629 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -554,14 +554,13 @@ static void acpi_device_remove_notify_handler(struc=
t acpi_device *device,
>         acpi_os_wait_events_complete();
>  }
>
> -int acpi_dev_install_notify_handler(struct acpi_device *adev,
> -                                   u32 handler_type,
> -                                   acpi_notify_handler handler)
> +int acpi_dev_install_notify_handler(acpi_handle handle, u32 handler_type=
,
> +                                   acpi_notify_handler handler, void *co=
ntext)
>  {
>         acpi_status status;
>
> -       status =3D acpi_install_notify_handler(adev->handle, handler_type=
,
> -                                            handler, adev);
> +       status =3D acpi_install_notify_handler(handle, handler_type,
> +                                            handler, context);

The wrapper now takes exactly the same arguments as the wrapped
function, so what exactly is the point of having it?  The return value
type?

>         if (ACPI_FAILURE(status))
>                 return -ENODEV;
>
> @@ -569,11 +568,10 @@ int acpi_dev_install_notify_handler(struct acpi_dev=
ice *adev,
>  }
>  EXPORT_SYMBOL_GPL(acpi_dev_install_notify_handler);
>
> -void acpi_dev_remove_notify_handler(struct acpi_device *adev,
> -                                   u32 handler_type,
> +void acpi_dev_remove_notify_handler(acpi_handle handle, u32 handler_type=
,
>                                     acpi_notify_handler handler)
>  {
> -       acpi_remove_notify_handler(adev->handle, handler_type, handler);
> +       acpi_remove_notify_handler(handle, handler_type, handler);
>         acpi_os_wait_events_complete();

Here at least there is the extra workqueues synchronization point.

That said, why exactly is it better to use acpi_handle instead of a
struct acpi_device pointer?

Realistically, in a platform driver you'll need the latter to obtain
the former anyway.
