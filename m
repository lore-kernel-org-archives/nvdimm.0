Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC4713AC2
	for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 16:18:14 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-991f9148334so25016766b.1
        for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 09:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688055493; x=1690647493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eKddrYb9Xcx4IoLqdTI5tk2rwMAekQcgu+s3gWevaEw=;
        b=LkrlOSnHAJ5oqlJfj4TijvfJgTOo954OhXM8goEnh1kcZGIwU7bTU/rKK+PW8bnpuh
         ABeWNwvDOfIe5r8b6rjURBNAxxvltBqvu40OHBPoUg1ZkkWvIgFEW+YI3gKzPpvYOeAk
         6rCEopUeqV+drQmodmKaXylaaqd02EYYidjOJnBjfV6+ILglRHFpuYs/WDxUguY+7MAO
         ti75s5yzNcPE+1ur/m7ZsFpi+E/C0tYORVfzW/Vn0TU02ipJqepstZ9objlOP4LuEtsJ
         yQOhv5nf1jkfzqAmOulhGb7r3MrmTPyR3wHBR6vYBgreZt31rY/YVrNuvSdqTVI0uBit
         ursg==
X-Gm-Message-State: AC+VfDyuOb/DUs+tmVIVuZ0IQzryZzzVxeXZtycW33s5i8GmREliONU4
	/xbIGV/MSrgwjilvysZyi2ITj0ycdUlYkUKtK58=
X-Google-Smtp-Source: ACHHUZ7k8Ks89MOBgWSXswK1HxhhFvMe9nfbQWVunQafLyVDNv7RaVKtwd8bkxTgNnzA6i5b6d/Dmbk3eD5wOPYod2M=
X-Received: by 2002:a17:906:73dd:b0:989:1ed3:d00b with SMTP id
 n29-20020a17090673dd00b009891ed3d00bmr21389315ejl.4.1688055492790; Thu, 29
 Jun 2023 09:18:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616165034.3630141-1-michal.wilczynski@intel.com> <20230616165034.3630141-10-michal.wilczynski@intel.com>
In-Reply-To: <20230616165034.3630141-10-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 29 Jun 2023 18:18:01 +0200
Message-ID: <CAJZ5v0gcokw72q5uX-3pbBEZtJdCaWHN1vat8yPNQ3SXMgeD4g@mail.gmail.com>
Subject: Re: [PATCH v5 09/10] acpi/nfit: Move handler installing logic to driver
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
>  drivers/acpi/nfit/core.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 95930e9d776c..a281bdfee8a0 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -3312,11 +3312,13 @@ void acpi_nfit_shutdown(void *data)
>  }
>  EXPORT_SYMBOL_GPL(acpi_nfit_shutdown);
>
> -static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
> +static void acpi_nfit_notify(acpi_handle handle, u32 event, void *data)
>  {
> -       device_lock(&adev->dev);
> -       __acpi_nfit_notify(&adev->dev, adev->handle, event);
> -       device_unlock(&adev->dev);

It's totally not necessary to rename the ACPI device variable here.

Just add

struct acpi_device *adev =3D data;

to this function.

> +       struct acpi_device *device =3D data;
> +
> +       device_lock(&device->dev);
> +       __acpi_nfit_notify(&device->dev, handle, event);
> +       device_unlock(&device->dev);
>  }
>
>  static int acpi_nfit_add(struct acpi_device *adev)
> @@ -3375,12 +3377,23 @@ static int acpi_nfit_add(struct acpi_device *adev=
)
>
>         if (rc)
>                 return rc;
> -       return devm_add_action_or_reset(dev, acpi_nfit_shutdown, acpi_des=
c);
> +
> +       rc =3D devm_add_action_or_reset(dev, acpi_nfit_shutdown, acpi_des=
c);
> +       if (rc)
> +               return rc;
> +
> +       return acpi_dev_install_notify_handler(adev,
> +                                              ACPI_DEVICE_NOTIFY,
> +                                              acpi_nfit_notify);
>  }
>
>  static void acpi_nfit_remove(struct acpi_device *adev)
>  {
>         /* see acpi_nfit_unregister */
> +
> +       acpi_dev_remove_notify_handler(adev,
> +                                      ACPI_DEVICE_NOTIFY,
> +                                      acpi_nfit_notify);
>  }
>
>  static void acpi_nfit_update_notify(struct device *dev, acpi_handle hand=
le)
> @@ -3465,7 +3478,6 @@ static struct acpi_driver acpi_nfit_driver =3D {
>         .ops =3D {
>                 .add =3D acpi_nfit_add,
>                 .remove =3D acpi_nfit_remove,
> -               .notify =3D acpi_nfit_notify,
>         },
>  };
>
> --
