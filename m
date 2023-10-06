Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6630F2AB36
	for <nvdimm@lists.linux.dev>; Fri,  6 Oct 2023 19:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-57be74614c0so127029eaf.1
        for <nvdimm@lists.linux.dev>; Fri, 06 Oct 2023 12:48:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696621688; x=1697226488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2qtrIYwt5+xezRUeXv6ZO7TiBtw+EXKB+lTOgWGj6zc=;
        b=Cb+xFlJtNWfFX35Bcvo9dw5z9Ay/2pa9xr/Zq0oywY3Q8XEbimEHP+gPcEANGBY05V
         zshAI7OG1gg/dyXiCMJPouIdPEV3T+TLJYyhieaB+bnfpIp+FY1JiitdOM8+kPx1QPOM
         YV6I4I+R4TLXCfKKl0ERzWJ5UsmwSJKiI9pg+vpNhmzG4kyqE3doSvRBJg7OKuPvrpr0
         lJE0dOK3BJWk77yafI8ggOUgFSNKnGu75jljSSraKbr4fNatni0PgVKTAJXgw6VozNGN
         9pTT+Nt6IglDaGeorEUg9mYCY6CHGh6OIXpkNFTCWgPFllf/1rOMHLHzm7ugQ7VdowY8
         7VvA==
X-Gm-Message-State: AOJu0YweA7Gjfc8r8r3lfLoi+xtbnyWtQ/ItRaiDAgwP8Uqh+i/zleeb
	MbvSW6d6vnttLetZ9batzW72CTt0tTgqv/X8+2yapRid
X-Google-Smtp-Source: AGHT+IEbHKyLXUN+VeQaWG8yOuLIjWf9zRSx8HK/NyYMqdeOBCTAZuxVI14uQ14DfqOzLaioiwUl95A/vx+uEm8kmaE=
X-Received: by 2002:a4a:b807:0:b0:57b:3b64:7ea5 with SMTP id
 g7-20020a4ab807000000b0057b3b647ea5mr8300446oop.1.1696621688430; Fri, 06 Oct
 2023 12:48:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231006173055.2938160-1-michal.wilczynski@intel.com> <20231006173055.2938160-4-michal.wilczynski@intel.com>
In-Reply-To: <20231006173055.2938160-4-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 6 Oct 2023 21:47:57 +0200
Message-ID: <CAJZ5v0jKJ6iw6Q=uYTf0at+ESkdCF0oWaXRmj7P5VLw+QppKPw@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] ACPI: AC: Replace acpi_driver with platform_driver
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
> AC driver uses struct acpi_driver incorrectly to register itself. This
> is wrong as the instances of the ACPI devices are not meant to
> be literal devices, they're supposed to describe ACPI entry of a
> particular device.
>
> Use platform_driver instead of acpi_driver. In relevant places call
> platform devices instances pdev to make a distinction with ACPI
> devices instances.
>
> Drop unnecessary casts from acpi_bus_generate_netlink_event() and
> acpi_notifier_call_chain().
>
> Add a blank line to distinguish pdev API vs local ACPI notify function.
>
> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
>  drivers/acpi/ac.c | 70 +++++++++++++++++++++++++----------------------
>  1 file changed, 37 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
> index f809f6889b4a..298defeb5301 100644
> --- a/drivers/acpi/ac.c
> +++ b/drivers/acpi/ac.c
> @@ -33,8 +33,9 @@ MODULE_AUTHOR("Paul Diefenbaugh");
>  MODULE_DESCRIPTION("ACPI AC Adapter Driver");
>  MODULE_LICENSE("GPL");
>
> -static int acpi_ac_add(struct acpi_device *device);
> -static void acpi_ac_remove(struct acpi_device *device);
> +static int acpi_ac_probe(struct platform_device *pdev);
> +static void acpi_ac_remove(struct platform_device *pdev);
> +
>  static void acpi_ac_notify(acpi_handle handle, u32 event, void *data);
>
>  static const struct acpi_device_id ac_device_ids[] =3D {
> @@ -51,21 +52,10 @@ static SIMPLE_DEV_PM_OPS(acpi_ac_pm, NULL, acpi_ac_re=
sume);
>  static int ac_sleep_before_get_state_ms;
>  static int ac_only;
>
> -static struct acpi_driver acpi_ac_driver =3D {
> -       .name =3D "ac",
> -       .class =3D ACPI_AC_CLASS,
> -       .ids =3D ac_device_ids,
> -       .ops =3D {
> -               .add =3D acpi_ac_add,
> -               .remove =3D acpi_ac_remove,
> -               },
> -       .drv.pm =3D &acpi_ac_pm,
> -};
> -
>  struct acpi_ac {
>         struct power_supply *charger;
>         struct power_supply_desc charger_desc;
> -       struct acpi_device *device;
> +       struct device *dev;

I'm not convinced about this change.

If I'm not mistaken, you only use the dev pointer above to get the
ACPI_COMPANION() of it, but the latter is already found in _probe(),
so it can be stored in struct acpi_ac for later use and then the dev
pointer in there will not be necessary any more.

That will save you a bunch of ACPI_HANDLE() evaluations and there's
nothing wrong with using ac->device->handle.  The patch will then
become almost trivial AFAICS and if you really need to get from ac to
the underlying platform device, a pointer to it can be added to struct
acpi_ac without removing the ACPI device pointer from it.

>         unsigned long long state;
>         struct notifier_block battery_nb;
>  };
