Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7759134AF
	for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 15:58:13 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-98dfd15aae1so24990366b.0
        for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 08:58:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688054292; x=1690646292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/qetn1nrmN6G9CR9gXQ9Em61uIidpmKRRe6NZOrRfh0=;
        b=bPPi7RURDv909cWZd8PNbQf2zpmTlEqN1QRCKiyO1gzWLFWHYstAnALniAfO54cbBd
         SnzlevVK4V5CIFnCbbLyrWgMT2dk/aFCT4K32EvqAXMdMSjcA+fe1S07LI5p8WI9YukN
         cflWw40rFxOLKRT4YqhiygC+4B5kPO2qoEvHI0zNrl2Sb4IwE74hkgId7Pu3kuEeiUMD
         XPDu2wuL0I9GTM5wq0hlMwRREqEou9TjFG6kYyiOgob73xSUioyIsobU+SSJdwWoC1TN
         6mfkOKTmD/XKsxRgxTBnRxzRVpykO5VrOz6nMxEwTaRsVgpeTqxjL4c5Jl2qecw496fY
         G55Q==
X-Gm-Message-State: AC+VfDyQyJlaEGm7iuer5ko9zT6ijpYXJUS0oUI7JrQPuOoHJCjHuk9T
	/eNZZUvWM7HKnxVUFWEf73dgT39vbNknttnjXqA=
X-Google-Smtp-Source: ACHHUZ7+pEVSf5OQUS/L9yOGMCIw+NnHEsH8WFpD3o92yk1tDC27bL5HKJgEqqmZ2HElw6dwaudN/vgTvTilF1g5RzA=
X-Received: by 2002:a17:906:6493:b0:987:6960:36c5 with SMTP id
 e19-20020a170906649300b00987696036c5mr27088527ejm.6.1688054291833; Thu, 29
 Jun 2023 08:58:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616165034.3630141-1-michal.wilczynski@intel.com> <20230616165034.3630141-5-michal.wilczynski@intel.com>
In-Reply-To: <20230616165034.3630141-5-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 29 Jun 2023 17:58:00 +0200
Message-ID: <CAJZ5v0hZ-2Ee0DCcgzHJrOikRTOJuCbEbQj24xui_-vmbd+47Q@mail.gmail.com>
Subject: Re: [PATCH v5 04/10] acpi/video: Move handler installing logic to driver
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
>  drivers/acpi/acpi_video.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
> index 62f4364e4460..60b7013d0009 100644
> --- a/drivers/acpi/acpi_video.c
> +++ b/drivers/acpi/acpi_video.c
> @@ -77,7 +77,7 @@ static DEFINE_MUTEX(video_list_lock);
>  static LIST_HEAD(video_bus_head);
>  static int acpi_video_bus_add(struct acpi_device *device);
>  static void acpi_video_bus_remove(struct acpi_device *device);
> -static void acpi_video_bus_notify(struct acpi_device *device, u32 event)=
;
> +static void acpi_video_bus_notify(acpi_handle handle, u32 event, void *d=
ata);
>
>  /*
>   * Indices in the _BCL method response: the first two items are special,
> @@ -104,7 +104,6 @@ static struct acpi_driver acpi_video_bus =3D {
>         .ops =3D {
>                 .add =3D acpi_video_bus_add,
>                 .remove =3D acpi_video_bus_remove,
> -               .notify =3D acpi_video_bus_notify,
>                 },
>  };
>
> @@ -1527,12 +1526,15 @@ static int acpi_video_bus_stop_devices(struct acp=
i_video_bus *video)
>                                   acpi_osi_is_win8() ? 0 : 1);
>  }
>
> -static void acpi_video_bus_notify(struct acpi_device *device, u32 event)
> +static void acpi_video_bus_notify(acpi_handle handle, u32 event, void *d=
ata)
>  {
> -       struct acpi_video_bus *video =3D acpi_driver_data(device);
> +       struct acpi_device *device =3D data;
> +       struct acpi_video_bus *video;
>         struct input_dev *input;
>         int keycode =3D 0;
>
> +       video =3D acpi_driver_data(device);
> +
>         if (!video || !video->input)
>                 return;
>
> @@ -2053,8 +2055,20 @@ static int acpi_video_bus_add(struct acpi_device *=
device)
>
>         acpi_video_bus_add_notify_handler(video);
>
> +       error =3D acpi_dev_install_notify_handler(device,
> +                                               ACPI_DEVICE_NOTIFY,
> +                                               acpi_video_bus_notify);
> +       if (error)
> +               goto err_remove_and_unregister_video;

This label name is a bit too long and the second half of it doesn't
really add any value IMV.  err_remove would be sufficient.

> +
>         return 0;
>
> +err_remove_and_unregister_video:
> +       mutex_lock(&video_list_lock);
> +       list_del(&video->entry);
> +       mutex_unlock(&video_list_lock);
> +       acpi_video_bus_remove_notify_handler(video);
> +       acpi_video_bus_unregister_backlight(video);
>  err_put_video:
>         acpi_video_bus_put_devices(video);
>         kfree(video->attached_array);
> @@ -2075,6 +2089,10 @@ static void acpi_video_bus_remove(struct acpi_devi=
ce *device)
>
>         video =3D acpi_driver_data(device);
>
> +       acpi_dev_remove_notify_handler(device,
> +                                      ACPI_DEVICE_NOTIFY,
> +                                      acpi_video_bus_notify);
> +
>         mutex_lock(&video_list_lock);
>         list_del(&video->entry);
>         mutex_unlock(&video_list_lock);
> --
> 2.41.0
>
