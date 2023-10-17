Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E06D747B
	for <nvdimm@lists.linux.dev>; Tue, 17 Oct 2023 14:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-57be74614c0so242748eaf.1
        for <nvdimm@lists.linux.dev>; Tue, 17 Oct 2023 07:06:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697551614; x=1698156414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e/q+wuZASo6Z0fTJ2g1A4X/m+vDSravRUT5sPcdQHlI=;
        b=haih9/LTxYyzaVieP07zEb2e1b+4Js3G920Wq0h6LAtsAfNIgKYDheNhZRuTn1+bmt
         b3K87ISVuAaHJZyIVtVF6lfVs0Wsd50Hxgd88zo6GmwX08bPpxWUGgBglSST5fY7Qd9V
         vLLIZgX48h/jqsi7iCsh+NE5di2hgqBbQ1fmHB1RYuHKX0PoAdKIgvVUVxl+BFGE/km4
         KFoO3n1GjOJA/Ml0cm+J//XwbevV3yTozOMO+6g3EAdRX3PGizMN/6lp7IkWlj5TzaF+
         3wEopZ1i/SDyn+AqzS+TN8DJiu7xJq4W+/+HfQaQuT/KfOcpRxHul0PYxH1gJjOEOTG6
         TQeA==
X-Gm-Message-State: AOJu0YyplG3PaIIjVltYo36iKNolnLwy4BWSSMTrNg+5wPEoi7OlhyW7
	X2jyOc77ptq/kv8l+4J3E3HTl1txyb1m8N6ETBQ=
X-Google-Smtp-Source: AGHT+IFd96eE/x88+yG5zSGJ+AiwCCf74V15p7hd79kQ8n5jO9c89RDSq0OCq/k/XaacLWnWy5bit6ABH63kQ0g4IT4=
X-Received: by 2002:a4a:d898:0:b0:581:84e9:a7ad with SMTP id
 b24-20020a4ad898000000b0058184e9a7admr2267424oov.1.1697551614004; Tue, 17 Oct
 2023 07:06:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231006173055.2938160-1-michal.wilczynski@intel.com> <20231006173055.2938160-6-michal.wilczynski@intel.com>
In-Reply-To: <20231006173055.2938160-6-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 17 Oct 2023 16:06:43 +0200
Message-ID: <CAJZ5v0h=gcEcnnWiRdLVgZgEYFg3-U=odGFPS_6odFW2+4_=YQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] ACPI: NFIT: Replace acpi_driver with platform_driver
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, rafael.j.wysocki@intel.com, 
	andriy.shevchenko@intel.com, lenb@kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 6, 2023 at 8:33=E2=80=AFPM Michal Wilczynski
<michal.wilczynski@intel.com> wrote:
>
> NFIT driver uses struct acpi_driver incorrectly to register itself.
> This is wrong as the instances of the ACPI devices are not meant
> to be literal devices, they're supposed to describe ACPI entry of a
> particular device.
>
> Use platform_driver instead of acpi_driver. In relevant places call
> platform devices instances pdev to make a distinction with ACPI
> devices instances.
>
> NFIT driver uses devm_*() family of functions extensively. This change
> has no impact on correct functioning of the whole devm_*() family of
> functions, since the lifecycle of the device stays the same. It is still
> being created during the enumeration, and destroyed on platform device
> removal.
>
> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
>  drivers/acpi/nfit/core.c | 34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 942b84d94078..fb0bc16fa186 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -15,6 +15,7 @@
>  #include <linux/sort.h>
>  #include <linux/io.h>
>  #include <linux/nd.h>
> +#include <linux/platform_device.h>
>  #include <asm/cacheflush.h>
>  #include <acpi/nfit.h>
>  #include "intel.h"
> @@ -98,7 +99,7 @@ static struct acpi_device *to_acpi_dev(struct acpi_nfit=
_desc *acpi_desc)
>                         || strcmp(nd_desc->provider_name, "ACPI.NFIT") !=
=3D 0)
>                 return NULL;
>
> -       return to_acpi_device(acpi_desc->dev);
> +       return ACPI_COMPANION(acpi_desc->dev);
>  }
>
>  static int xlat_bus_status(void *buf, unsigned int cmd, u32 status)
> @@ -3284,11 +3285,11 @@ static void acpi_nfit_put_table(void *table)
>
>  static void acpi_nfit_notify(acpi_handle handle, u32 event, void *data)
>  {
> -       struct acpi_device *adev =3D data;
> +       struct device *dev =3D data;
>
> -       device_lock(&adev->dev);
> -       __acpi_nfit_notify(&adev->dev, handle, event);
> -       device_unlock(&adev->dev);
> +       device_lock(dev);
> +       __acpi_nfit_notify(dev, handle, event);
> +       device_unlock(dev);

Careful here.

The ACPI device locking is changed to platform device locking without
a word of explanation in the changelog.

Do you actually know what the role of the locking around
__acpi_nfit_notify() is and whether or not it can be replaced with
platform device locking safely?

>  }
>
>  static void acpi_nfit_remove_notify_handler(void *data)
> @@ -3329,11 +3330,12 @@ void acpi_nfit_shutdown(void *data)
>  }
>  EXPORT_SYMBOL_GPL(acpi_nfit_shutdown);
>
> -static int acpi_nfit_add(struct acpi_device *adev)
> +static int acpi_nfit_probe(struct platform_device *pdev)
>  {
>         struct acpi_buffer buf =3D { ACPI_ALLOCATE_BUFFER, NULL };
>         struct acpi_nfit_desc *acpi_desc;
> -       struct device *dev =3D &adev->dev;
> +       struct device *dev =3D &pdev->dev;
> +       struct acpi_device *adev =3D ACPI_COMPANION(dev);
>         struct acpi_table_header *tbl;
>         acpi_status status =3D AE_OK;
>         acpi_size sz;
> @@ -3360,7 +3362,7 @@ static int acpi_nfit_add(struct acpi_device *adev)
>         acpi_desc =3D devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
>         if (!acpi_desc)
>                 return -ENOMEM;
> -       acpi_nfit_desc_init(acpi_desc, &adev->dev);
> +       acpi_nfit_desc_init(acpi_desc, dev);

You seem to think that replacing adev->dev with pdev->dev everywhere
in this driver will work,

Have you verified that in any way?  If so, then how?

>
>         /* Save the acpi header for exporting the revision via sysfs */
>         acpi_desc->acpi_header =3D *tbl;
> @@ -3391,7 +3393,7 @@ static int acpi_nfit_add(struct acpi_device *adev)
>                 return rc;
>
>         rc =3D acpi_dev_install_notify_handler(adev, ACPI_DEVICE_NOTIFY,
> -                                            acpi_nfit_notify, adev);
> +                                            acpi_nfit_notify, dev);
>         if (rc)
>                 return rc;
>
> @@ -3475,11 +3477,11 @@ static const struct acpi_device_id acpi_nfit_ids[=
] =3D {
>  };
>  MODULE_DEVICE_TABLE(acpi, acpi_nfit_ids);
>
> -static struct acpi_driver acpi_nfit_driver =3D {
> -       .name =3D KBUILD_MODNAME,
> -       .ids =3D acpi_nfit_ids,
> -       .ops =3D {
> -               .add =3D acpi_nfit_add,
> +static struct platform_driver acpi_nfit_driver =3D {
> +       .probe =3D acpi_nfit_probe,
> +       .driver =3D {
> +               .name =3D KBUILD_MODNAME,
> +               .acpi_match_table =3D acpi_nfit_ids,
>         },
>  };
>
> @@ -3517,7 +3519,7 @@ static __init int nfit_init(void)
>                 return -ENOMEM;
>
>         nfit_mce_register();
> -       ret =3D acpi_bus_register_driver(&acpi_nfit_driver);
> +       ret =3D platform_driver_register(&acpi_nfit_driver);
>         if (ret) {
>                 nfit_mce_unregister();
>                 destroy_workqueue(nfit_wq);
> @@ -3530,7 +3532,7 @@ static __init int nfit_init(void)
>  static __exit void nfit_exit(void)
>  {
>         nfit_mce_unregister();
> -       acpi_bus_unregister_driver(&acpi_nfit_driver);
> +       platform_driver_unregister(&acpi_nfit_driver);
>         destroy_workqueue(nfit_wq);
>         WARN_ON(!list_empty(&acpi_descs));
>  }
> --
