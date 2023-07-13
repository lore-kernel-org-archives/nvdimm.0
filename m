Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE9F1ED23
	for <nvdimm@lists.linux.dev>; Thu, 13 Jul 2023 15:23:59 +0000 (UTC)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-98dfd15aae1so21042866b.0
        for <nvdimm@lists.linux.dev>; Thu, 13 Jul 2023 08:23:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689261838; x=1689866638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VrE6LY2wmxVu6SrdiDWyyjLd4AHotqYK1QoQuBvkj3M=;
        b=AgMPdocd3LQ2gUiVsA/3Lj4VyKsZHrlogM9Birx/9/69h4DDYj4DpnFiNU3ejLlCXp
         e5LRI523e/XHojl7lOZ1+fAzmGJt1Vzjs/qU+g++cfc9S/IOpJqXuHSf1fwA4T63lQvB
         t7yLLbv398/94EMuhNC6emdTzVTyNley1vn0IddPXiN8HASaMShIfvWZRuSFaGeYxdjG
         EYU/OKyYlVZLf+CEH7y7tbjldOT7An3FsaA8ctqTkJEpcVfhbqO4b6z+SJwyxL1xVmGY
         zVTgSHSVRVt4jTDIVV/fmzYSHFTojE1giP/G5GEgUKyshUzFwcPj5JLrZnBRPYobfheS
         GoJw==
X-Gm-Message-State: ABy/qLYXzoFJmJRNMvTOBj6/wKq7cqD/CoXvHIVPWu2rmT0orj4JfR63
	4Iy+9DVpXP2Q7zu279H9ICpabQ4pWdIHUIPa8a4=
X-Google-Smtp-Source: APBJJlGi3f9rnzgFLBm8Q9r1GpDwzKwioXzayy1WG2P4eJ1Q49QD9da5U9DpCLrgyjqsUkso5pyRyPPd+sB1bbq+/pM=
X-Received: by 2002:a17:906:74dc:b0:994:1808:176b with SMTP id
 z28-20020a17090674dc00b009941808176bmr1254391ejl.6.1689261838133; Thu, 13 Jul
 2023 08:23:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230703080252.2899090-1-michal.wilczynski@intel.com> <20230703080252.2899090-9-michal.wilczynski@intel.com>
In-Reply-To: <20230703080252.2899090-9-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 13 Jul 2023 17:23:47 +0200
Message-ID: <CAJZ5v0jDOOhcTcYnDrkWbto1f_XJRs4Yd3huQcRJhhCoBGVcQA@mail.gmail.com>
Subject: Re: [PATCH v7 8/9] acpi/nfit: Remove unnecessary .remove callback
To: Michal Wilczynski <michal.wilczynski@intel.com>, dan.j.williams@intel.com
Cc: linux-acpi@vger.kernel.org, rafael@kernel.org, vishal.l.verma@intel.com, 
	lenb@kernel.org, dave.jiang@intel.com, ira.weiny@intel.com, 
	rui.zhang@intel.com, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 3, 2023 at 10:03=E2=80=AFAM Michal Wilczynski
<michal.wilczynski@intel.com> wrote:
>
> Nfit driver doesn't use .remove() callback and provide an empty function
> as it's .remove() callback. Remove empty acpi_nfit_remove() and
> initialization of callback.
>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>

This one is not strictly related to the rest of the series, but it
does depend on the previous one, so assuming that the previous one is
not objectionable, I suppose I can take them both.  Dan?

> ---
>  drivers/acpi/nfit/core.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 124e928647d3..16bf17a3d6ff 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -3402,11 +3402,6 @@ static int acpi_nfit_add(struct acpi_device *adev)
>                                         adev);
>  }
>
> -static void acpi_nfit_remove(struct acpi_device *adev)
> -{
> -       /* see acpi_nfit_unregister */
> -}
> -
>  static void acpi_nfit_update_notify(struct device *dev, acpi_handle hand=
le)
>  {
>         struct acpi_nfit_desc *acpi_desc =3D dev_get_drvdata(dev);
> @@ -3488,7 +3483,6 @@ static struct acpi_driver acpi_nfit_driver =3D {
>         .ids =3D acpi_nfit_ids,
>         .ops =3D {
>                 .add =3D acpi_nfit_add,
> -               .remove =3D acpi_nfit_remove,
>         },
>  };
>
> --
> 2.41.0
>
