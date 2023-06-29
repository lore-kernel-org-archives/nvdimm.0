Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0609F13AC8
	for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 16:15:06 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-94ea38c90ccso23392566b.1
        for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 09:15:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688055305; x=1690647305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2asz2ubuH2qetgbcysClqW7znNeW2vYR8Y5n9yx7dNQ=;
        b=Vh6/vFfWPy+r2PrdsQbAtTBZadShJKQkxzXtdoedCI1agJ/kEopKKUrS8C325J7R+h
         r0yt9AkWdyMnndyqV54ocFUFzt1Cb5vu7zcEUIWAoR5OqZtfNa/dQ4WOZBOXzSDS/hsE
         p4hCPeI8CBIkJnTEyuWQzIaUeRMyHrgk1kPicdGt2KDkjQvw+yHIP6r5w6HY196i/kLI
         /O3hqHUb6MhrxJsXLyMi1ODPCqRZPzcY2mlvLBaoyLMmtrXGHfBm10SZOHxmIOB1PE1O
         h/6me85oTkmoNi1Ud5AT0XvAEU0m4sluLEi9oI2baYDsTOmnkVDfeg+dAdfgyteMAM9a
         tyIw==
X-Gm-Message-State: AC+VfDy20wyuSnLsrZ7guAQWU15v3Kdk1Mp+o2H4yTYF9YbtREnvLSLO
	DDz2BO642pXtMKlIqo3THYpbyTqgrUaVRSlsQzE=
X-Google-Smtp-Source: ACHHUZ5/QdCY5R7J3odu7HQae4qVM960Ldl0f0ONcSdWCpVyCWdGZEis60/MfjC11Ncx1onHXrhUbkrTUeasMlq2sJM=
X-Received: by 2002:a17:906:518f:b0:974:ae1d:ad0b with SMTP id
 y15-20020a170906518f00b00974ae1dad0bmr13460817ejk.3.1688055304918; Thu, 29
 Jun 2023 09:15:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616165034.3630141-1-michal.wilczynski@intel.com> <20230616165034.3630141-9-michal.wilczynski@intel.com>
In-Reply-To: <20230616165034.3630141-9-michal.wilczynski@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 29 Jun 2023 18:14:53 +0200
Message-ID: <CAJZ5v0hPY=nermvRKiyqGg4R+jLW13B-MUr0exEuEnw33VUj7g@mail.gmail.com>
Subject: Re: [PATCH v5 08/10] acpi/nfit: Improve terminator line in acpi_nfit_ids
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, rafael@kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, lenb@kernel.org, dave.jiang@intel.com, 
	ira.weiny@intel.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16, 2023 at 6:51=E2=80=AFPM Michal Wilczynski
<michal.wilczynski@intel.com> wrote:
>
> Currently terminator line contains redunant characters.

Well, they are terminating the list properly AFAICS, so they aren't
redundant and the size of it before and after the change is actually
the same, isn't it?

> Remove them and also remove a comma at the end.

I suppose that this change is made for consistency with the other ACPI
code, so this would be the motivation to give in the changelog.

In any case, it doesn't seem to be related to the rest of the series.

> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
>  drivers/acpi/nfit/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index aff79cbc2190..95930e9d776c 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -3455,7 +3455,7 @@ EXPORT_SYMBOL_GPL(__acpi_nfit_notify);
>
>  static const struct acpi_device_id acpi_nfit_ids[] =3D {
>         { "ACPI0012", 0 },
> -       { "", 0 },
> +       {}
>  };
>  MODULE_DEVICE_TABLE(acpi, acpi_nfit_ids);
>
> --
> 2.41.0
>
