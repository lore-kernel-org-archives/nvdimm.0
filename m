Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A714C224D1
	for <nvdimm@lists.linux.dev>; Fri, 13 Oct 2023 17:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-57b68555467so60108eaf.0
        for <nvdimm@lists.linux.dev>; Fri, 13 Oct 2023 10:35:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697218513; x=1697823313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xVZ2KoSdWfm9vU181b1VE9CrcI7d4A9Y2SwYBj4ZNFQ=;
        b=Mfrix7F3VGXWYxKGAz0xAw39/ubTsMEMVTXFLGlFeVK8k6aLxy5aKRrrGbgrSAGuWD
         8ycQwhdOtI+LF6PPQEjAJaGiUQ66R7Ix7lFbUgYReekz46Coh2AtHfyWCTJSR2Rh5UzS
         IvG1UepYvtrVT2VSu8to5jJHY7MWsvEiIhTkl8vEc/sYtNrBonnHCufSExC4odoUazFP
         NFE9u6PGxWWqEMU+62kW13p6dHR224KqnPNPi1+EEiyORxV/6DtGB6UjV/JdHzj/1gSi
         UhKWzQsKQMAf5f3Hspy1uUEvup9ovw8cHabejY9GOTIHH8q11dP0FAHUEz2kjFcvWyA8
         asyg==
X-Gm-Message-State: AOJu0YxObPH5tXs+yXpNGiAajobfiNkVfUDfMGWQu3MpCsulWE3lzRrW
	4V9BLqZL8uX6VFe/fxSP5W/RmHo/9+vp9n+arGfaEbMo
X-Google-Smtp-Source: AGHT+IH3xv7V34FMwvzR1bbYcbgAU7fSJdrqQFOkjnTGDH1njPe4OVrx7RRPKcLGBYtI8xJr/hXYh1u8+rf4M0xUFRs=
X-Received: by 2002:a4a:d9d1:0:b0:581:84e9:a7ad with SMTP id
 l17-20020a4ad9d1000000b0058184e9a7admr1895451oou.1.1697218513548; Fri, 13 Oct
 2023 10:35:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231011083334.3987477-1-michal.wilczynski@intel.com> <20231011083334.3987477-3-michal.wilczynski@intel.com>
In-Reply-To: <20231011083334.3987477-3-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 13 Oct 2023 19:35:02 +0200
Message-ID: <CAJZ5v0h-NCAst+pQre2kVeidE7t4N5PM2UU46LbYPsdmKDRAoQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] ACPI: AC: Use string_choices API instead of
 ternary operator
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, rafael@kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, lenb@kernel.org, dave.jiang@intel.com, 
	ira.weiny@intel.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, Andy Shevchenko <andy.shevchenko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 11, 2023 at 10:34=E2=80=AFAM Michal Wilczynski
<michal.wilczynski@intel.com> wrote:
>
> Use modern string_choices API instead of manually determining the
> output using ternary operator.
>
> Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
>  drivers/acpi/ac.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
> index 83d45c681121..f809f6889b4a 100644
> --- a/drivers/acpi/ac.c
> +++ b/drivers/acpi/ac.c
> @@ -17,6 +17,7 @@
>  #include <linux/delay.h>
>  #include <linux/platform_device.h>
>  #include <linux/power_supply.h>
> +#include <linux/string_choices.h>
>  #include <linux/acpi.h>
>  #include <acpi/battery.h>
>
> @@ -243,8 +244,8 @@ static int acpi_ac_add(struct acpi_device *device)
>                 goto err_release_ac;
>         }
>
> -       pr_info("%s [%s] (%s)\n", acpi_device_name(device),
> -               acpi_device_bid(device), ac->state ? "on-line" : "off-lin=
e");
> +       pr_info("%s [%s] (%s-line)\n", acpi_device_name(device),
> +               acpi_device_bid(device), str_on_off(ac->state));
>
>         ac->battery_nb.notifier_call =3D acpi_ac_battery_notify;
>         register_acpi_notifier(&ac->battery_nb);
> --

Applied as 6.7 material, thanks!
