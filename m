Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739081ED23
	for <nvdimm@lists.linux.dev>; Thu, 13 Jul 2023 15:21:49 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-98e1fc9d130so25506166b.0
        for <nvdimm@lists.linux.dev>; Thu, 13 Jul 2023 08:21:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689261707; x=1691853707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PTGT1Ug3FquYRrJnkoPEsCW46sTDvUy1j7X26gKlfoU=;
        b=cUjYZUzT94b9h2wBTfJ+ER3PqN81kMzjIMa6S6KHCYFiMpsbq4+iYjpo+T4bqqpZ+l
         2WI1weIWyBps1dteROwrqJYCReCe6R7XvPkJDo9W/h9NKsT0yUKp7Mw31EzgYxcDwqCP
         vN0m5mdokgLkoVgzeCQWWCLtb+xGNQik5VZOyZahxOnN4FCGmJ24gvylEFBriEMdaoSU
         Qd9oM2/mBCzSvPwneMbYQJDb0YBR5U5efhkSAHDe/PHfuAX+0eCzGweXdBrJZnuLyltr
         XJsej+s3oPn4G6IzORGoxT85Cut1KqNSiRV8lqvoiBcXH/kL5iAWch15eCyG3WdsNuKd
         WeFg==
X-Gm-Message-State: ABy/qLaUmoJ63xIq51Da1LRjYx6IrftnIeWu/aW86FlMqW96EmTORG0e
	n8/p7jv5TbWp3uNqXFHLwSIwb4CMHi+Zxpk+Wzc=
X-Google-Smtp-Source: APBJJlFb9KXGI0y8sSeu+2CMZbP9koLthLQiycvsdK6ENDZF6BZzXHwTqH7ra72NJA489+u8PclGU40HHEfJfA0ccMA=
X-Received: by 2002:a17:906:51db:b0:994:1808:a353 with SMTP id
 v27-20020a17090651db00b009941808a353mr1662084ejk.6.1689261707365; Thu, 13 Jul
 2023 08:21:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230703080252.2899090-1-michal.wilczynski@intel.com> <20230703080252.2899090-8-michal.wilczynski@intel.com>
In-Reply-To: <20230703080252.2899090-8-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 13 Jul 2023 17:21:36 +0200
Message-ID: <CAJZ5v0hxr1h3HVq-Q5QRos3J7mDVNv0rYEZ0O1x5dfxfYeuD+Q@mail.gmail.com>
Subject: Re: [PATCH v7 7/9] acpi/nfit: Move handler installing logic to driver
To: Michal Wilczynski <michal.wilczynski@intel.com>, dan.j.williams@intel.com
Cc: linux-acpi@vger.kernel.org, rafael@kernel.org, vishal.l.verma@intel.com, 
	lenb@kernel.org, dave.jiang@intel.com, ira.weiny@intel.com, 
	rui.zhang@intel.com, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 3, 2023 at 10:03=E2=80=AFAM Michal Wilczynski
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
> Call acpi_dev_remove_notify_handler() at the beginning of
> acpi_nfit_shutdown(). Change arguments passed to the notify function to
> match with what's required by acpi_dev_install_notify_handler(). Remove
> .notify callback initialization in acpi_driver.
>
> Introduce a new devm action acpi_nfit_remove_notify_handler.
>
> Move acpi_nfit_notify() upwards in the file, so it can be used inside
> acpi_nfit_add() and acpi_nfit_remove_notify_handler().

Dan, any objections?

> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
>  drivers/acpi/nfit/core.c | 41 +++++++++++++++++++++++++++++++---------
>  1 file changed, 32 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 07204d482968..124e928647d3 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -3282,6 +3282,24 @@ static void acpi_nfit_put_table(void *table)
>         acpi_put_table(table);
>  }
>
> +static void acpi_nfit_notify(acpi_handle handle, u32 event, void *data)
> +{
> +       struct acpi_device *adev =3D data;
> +
> +       device_lock(&adev->dev);
> +       __acpi_nfit_notify(&adev->dev, handle, event);
> +       device_unlock(&adev->dev);
> +}
> +
> +static void acpi_nfit_remove_notify_handler(void *data)
> +{
> +       struct acpi_device *adev =3D data;
> +
> +       acpi_dev_remove_notify_handler(adev,
> +                                      ACPI_DEVICE_NOTIFY,
> +                                      acpi_nfit_notify);
> +}
> +
>  void acpi_nfit_shutdown(void *data)
>  {
>         struct acpi_nfit_desc *acpi_desc =3D data;
> @@ -3368,7 +3386,20 @@ static int acpi_nfit_add(struct acpi_device *adev)
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
> +       rc =3D acpi_dev_install_notify_handler(adev,
> +                                            ACPI_DEVICE_NOTIFY,
> +                                            acpi_nfit_notify);
> +       if (rc)
> +               return rc;
> +
> +       return devm_add_action_or_reset(dev,
> +                                       acpi_nfit_remove_notify_handler,
> +                                       adev);
>  }
>
>  static void acpi_nfit_remove(struct acpi_device *adev)
> @@ -3446,13 +3477,6 @@ void __acpi_nfit_notify(struct device *dev, acpi_h=
andle handle, u32 event)
>  }
>  EXPORT_SYMBOL_GPL(__acpi_nfit_notify);
>
> -static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
> -{
> -       device_lock(&adev->dev);
> -       __acpi_nfit_notify(&adev->dev, adev->handle, event);
> -       device_unlock(&adev->dev);
> -}
> -
>  static const struct acpi_device_id acpi_nfit_ids[] =3D {
>         { "ACPI0012", 0 },
>         { "", 0 },
> @@ -3465,7 +3489,6 @@ static struct acpi_driver acpi_nfit_driver =3D {
>         .ops =3D {
>                 .add =3D acpi_nfit_add,
>                 .remove =3D acpi_nfit_remove,
> -               .notify =3D acpi_nfit_notify,
>         },
>  };
>
> --
