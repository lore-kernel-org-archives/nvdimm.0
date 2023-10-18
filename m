Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6DC11C8C
	for <nvdimm@lists.linux.dev>; Wed, 18 Oct 2023 11:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6bc57401cb9so1589793a34.0
        for <nvdimm@lists.linux.dev>; Wed, 18 Oct 2023 04:17:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697627862; x=1698232662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2lDaOWpU3gP80StErKNHaaeq4NqieF2HqKjhl1efd+s=;
        b=kQLsMmhcE6SP0AImxJqQZXJE3NUMfMSSXKXk85zr748Tw6cfU+HqP44IxYBoCf/eV9
         NURuciVbgXhOhYrLahwYluMAhMXDTv7s4XG4boC0tLwslf4CPE9jQE0krVWkIW2qMgaC
         j4DycAOaESHmpwqSu5kcWF41yyak5W/ylNjKk2HovVx+nPDS8xQpErjbPVQuKu3W0PhL
         mc9V5/lIyBCQgvIdvGPHiIJ1HHS9/Ue64vS69pvZyLQI9lnB8ATP84FoR52Hc2D9xl9m
         mkAEjKHfjRKM1FJi1Ml6xOkr3OcS+zqBtXFAmr8IjLLEEFKdivTckjNDzKYm3FJE5tSJ
         0vcg==
X-Gm-Message-State: AOJu0Yx7423r1LU5T9FZHNekeglwCg+P64+tlsJikm3lej7GBT+Om8QZ
	hQpVNsB9BAfM/G9meiq13aId+Q+YJhCiSTLydGM=
X-Google-Smtp-Source: AGHT+IFBzvL59X17lCp+HOvRqrxJ1GAaPlm2t48L9i/AjyWSD9jvbUKaFNksxYScxFhEUM0pwyn7iIFXnr1zSQ9p4fI=
X-Received: by 2002:a4a:b304:0:b0:581:d5df:9cd2 with SMTP id
 m4-20020a4ab304000000b00581d5df9cd2mr4478820ooo.0.1697627862476; Wed, 18 Oct
 2023 04:17:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231012215903.2104652-1-visitorckw@gmail.com> <20231013122236.2127269-1-visitorckw@gmail.com>
In-Reply-To: <20231013122236.2127269-1-visitorckw@gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 18 Oct 2023 13:17:31 +0200
Message-ID: <CAJZ5v0gSB_ACBpK1nKu3sbA0HQ1xsk2mn3oc9AjpoFtge9Opdw@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI: NFIT: Optimize nfit_mem_cmp() for efficiency
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, 
	ira.weiny@intel.com, rafael@kernel.org, lenb@kernel.org, 
	nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 13, 2023 at 2:22=E2=80=AFPM Kuan-Wei Chiu <visitorckw@gmail.com=
> wrote:
>
> The original code used conditional branching in the nfit_mem_cmp
> function to compare two values and return -1, 1, or 0 based on the
> result. However, the list_sort comparison function only needs results
> <0, >0, or =3D0. This patch optimizes the code to make the comparison
> branchless, improving efficiency and reducing code size. This change
> reduces the number of comparison operations from 1-2 to a single
> subtraction operation, thereby saving the number of instructions.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> ---
> v1 -> v2:
> - Add explicit type cast in case the sizes of u32 and int differ.
>
>  drivers/acpi/nfit/core.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index f96bf32cd368..563a32eba888 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1138,11 +1138,7 @@ static int nfit_mem_cmp(void *priv, const struct l=
ist_head *_a,
>
>         handleA =3D __to_nfit_memdev(a)->device_handle;
>         handleB =3D __to_nfit_memdev(b)->device_handle;
> -       if (handleA < handleB)
> -               return -1;
> -       else if (handleA > handleB)
> -               return 1;
> -       return 0;
> +       return (int)handleA - (int)handleB;

Are you sure that you are not losing bits in these conversions?

>  }
>
>  static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
> --
