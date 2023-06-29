Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BF512B89
	for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 16:06:07 +0000 (UTC)
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2b588fa06d3so2391701fa.1
        for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 09:06:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688054766; x=1690646766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ntbPBy9hL81QsIqvjwYhJyNuvTZOUVlNvwxpzjeFHfM=;
        b=cmMalPtRjnbEfTu2w4cVsQSimzq6dnnEQbqCUJzELE/k6X4cTaNskk0B9LSJfvZw+u
         oOeB1M+p88xgSiEiuC2tTlismfMDWkmr6ksSad+vjMDSx2rLnFhgTVsAlKVuk8ZiyLz+
         VSSf8nQDbSOo2C4J7hghDVD0uyJ9WnJmBNHNvr573CcO3OJsL/Xus2XfoTJGDuWgAZqD
         FCg+cEToDquWOprOEVbTAPtj0W14Qt7jNIB6wf0QKbwrLWZ8NNYBBYNc7A+wxxah/+RA
         2m1AvdGDwqtTbsCtr4v9WzFDObj1cqjJHbr8Hcb+Ky7MTGrDi/c2PWucO1MILD8T3++D
         PbNQ==
X-Gm-Message-State: ABy/qLaCCFNHiqEE6VFjH63AP4/AgEzaaafl9mXMdz08CTt09Fg3Jy+u
	Avi14DhnWQzLcgDCtBZ7JNTAj6D0+mkkQ1EkxEE=
X-Google-Smtp-Source: APBJJlEBeNzBQoTEpcMIau50F2Gui9AM3lBLb2enorCyrJ6R7CueEN1gDl0LhpN3gVgaDLrcFOBjIILOG0ucvKIjtRY=
X-Received: by 2002:a2e:9844:0:b0:2b6:a882:129c with SMTP id
 e4-20020a2e9844000000b002b6a882129cmr210688ljj.0.1688054765305; Thu, 29 Jun
 2023 09:06:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616165034.3630141-1-michal.wilczynski@intel.com> <20230616165034.3630141-6-michal.wilczynski@intel.com>
In-Reply-To: <20230616165034.3630141-6-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 29 Jun 2023 18:05:54 +0200
Message-ID: <CAJZ5v0i1-7p-V0nFHoNWHDXRZ-xvVwTXJKM387PTP1d4k7Wrdg@mail.gmail.com>
Subject: Re: [PATCH v5 05/10] acpi/battery: Move handler installing logic to driver
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
> While at it, fix lack of whitespaces in .remove() callback.
>
> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
>  drivers/acpi/battery.c | 30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index 9c67ed02d797..6337e7b1f6e1 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -1034,11 +1034,14 @@ static void acpi_battery_refresh(struct acpi_batt=
ery *battery)
>  }
>
>  /* Driver Interface */
> -static void acpi_battery_notify(struct acpi_device *device, u32 event)
> +static void acpi_battery_notify(acpi_handle handle, u32 event, void *dat=
a)
>  {
> -       struct acpi_battery *battery =3D acpi_driver_data(device);
> +       struct acpi_device *device =3D data;
> +       struct acpi_battery *battery;
>         struct power_supply *old;
>
> +       battery =3D acpi_driver_data(device);
> +
>         if (!battery)
>                 return;
>         old =3D battery->bat;
> @@ -1212,13 +1215,23 @@ static int acpi_battery_add(struct acpi_device *d=
evice)
>
>         device_init_wakeup(&device->dev, 1);
>
> -       return result;
> +       result =3D acpi_dev_install_notify_handler(device,
> +                                                ACPI_ALL_NOTIFY,
> +                                                acpi_battery_notify);
> +       if (result)
> +               goto fail_deinit_wakup_and_unregister;

You could call the label "fail_pm", for example, which would be more
concise and so slightly easier to follow, without any loss of clarity
AFAICS.

> +
> +       return 0;
>
> +fail_deinit_wakup_and_unregister:
> +       device_init_wakeup(&device->dev, 0);
> +       unregister_pm_notifier(&battery->pm_nb);
>  fail:
>         sysfs_remove_battery(battery);
>         mutex_destroy(&battery->lock);
>         mutex_destroy(&battery->sysfs_lock);
>         kfree(battery);
> +
>         return result;
>  }
>
> @@ -1228,10 +1241,17 @@ static void acpi_battery_remove(struct acpi_devic=
e *device)
>
>         if (!device || !acpi_driver_data(device))
>                 return;
> -       device_init_wakeup(&device->dev, 0);
> +
>         battery =3D acpi_driver_data(device);
> +
> +       acpi_dev_remove_notify_handler(device,
> +                                      ACPI_ALL_NOTIFY,
> +                                      acpi_battery_notify);
> +
> +       device_init_wakeup(&device->dev, 0);
>         unregister_pm_notifier(&battery->pm_nb);
>         sysfs_remove_battery(battery);
> +
>         mutex_destroy(&battery->lock);
>         mutex_destroy(&battery->sysfs_lock);
>         kfree(battery);
> @@ -1264,11 +1284,9 @@ static struct acpi_driver acpi_battery_driver =3D =
{
>         .name =3D "battery",
>         .class =3D ACPI_BATTERY_CLASS,
>         .ids =3D battery_device_ids,
> -       .flags =3D ACPI_DRIVER_ALL_NOTIFY_EVENTS,
>         .ops =3D {
>                 .add =3D acpi_battery_add,
>                 .remove =3D acpi_battery_remove,
> -               .notify =3D acpi_battery_notify,
>                 },
>         .drv.pm =3D &acpi_battery_pm,
>  };
> --
> 2.41.0
>
