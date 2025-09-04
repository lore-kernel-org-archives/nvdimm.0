Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913B0246790
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 15:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999594; cv=none; b=A7EcWT2dVvassrd+5/Sq9eVrCV6+JL828qYHzhxvnhu6LRsYU1thS4zWdoMRoUKVITUujXbWVVki+zfjlD6lL5n4fXNJKh7EHfFqJbkjK8J+DYm5LcLTTN2QDnS5o1hNtD9QfR8XmcwV/4GxOQnND87WAcUAGgs7/Rg0yc23zQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999594; c=relaxed/simple;
	bh=wC8KtLroHY6HeVoIP1n4WQrJA2JwWtEVxeQPQFEVy+0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KPmbeDPeFBUw59SjAKd39K0Ga2DcIIJik6cnhH1u2TVs3OsqmBK7MGeXec3KTFbZx5eiGanxdcJv/I6J0ocB9tYVupkc0Vhag+aWRvEoFFKc9B+MiG+IHLo4DKcsx7PXVcfd44zO9z6keIbzeQZjcguAs+GeKoHL2kN5Yzu6cHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uiwiCbT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uiwiCbT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8D6C4CEF0
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 15:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756999594;
	bh=wC8KtLroHY6HeVoIP1n4WQrJA2JwWtEVxeQPQFEVy+0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uiwiCbT7tDybnc6JCMNGYmd8VyWCfkuJquOpTvAeOpIsBWTnk6LcevRXhcoXDbsWY
	 gTE+Lp+9U1hNeUVN/gKjwXG/Ob7slHdfCUGwgZ3MC4cWBrae/1wXVS1GGF0Qki4gBB
	 IhmbiFoh4MyaXev/bmCiBE0NzqZkR2iU0BXMYdyXDI5JBH1/adah7O0ycyFgDgbl21
	 BPzLwR65vCbaH2uzPOC2O9POqEJEn/KNXX81MqDsbjpgA8GwQAIFK/7FJn3YU6cFFw
	 +yDipSY0zxYNJYo2Q1dVc9nVneE2w/zH+iz0yr9rwRE9JMdqEv8Po7MBaWymVr6xQK
	 YuWooFSTssOJg==
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7459d088020so632084a34.3
        for <nvdimm@lists.linux.dev>; Thu, 04 Sep 2025 08:26:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXGccjDMFV8gKktFkxm4i3gZjYKtwtDJ0VsW2Uv+S/KlDQze8qklrQ+jU763yhoPmG9LCDBtoU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4ifh3vqwo75HJGOK4BhKyuQo/R+8XoVOjDO+sWhbuR//uUxMX
	G2CcN4c4+hKeYk6egx4a9GUXmM8lbnq8gKohjVCzU7XUlKznaJmIin5vZ4YWtanr40YpqpGnw7C
	EXikmmgHWk72gaZhdTwYjAWboyvUDwAc=
X-Google-Smtp-Source: AGHT+IH4TIuaj3rlH6hzohb9REICq+MfcRyQItpmQuOhi7hkIA0OW9a770eUyjGII+FElzkYd84asozifkcr7K4oXOc=
X-Received: by 2002:a05:6808:1a16:b0:438:33fd:3193 with SMTP id
 5614622812f47-43833fd4474mr2227125b6e.24.1756999593478; Thu, 04 Sep 2025
 08:26:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250902114518.2625680-1-colin.i.king@gmail.com>
In-Reply-To: <20250902114518.2625680-1-colin.i.king@gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 4 Sep 2025 17:26:21 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0je-10aKyA0zeDZbqTXzjxNb7yTfsWkt_-a-7uwqYdmcA@mail.gmail.com>
X-Gm-Features: Ac12FXysfBvBxpPrwhnHfQCMCaA6rmhjAG40wp_mam7L4JRE-FKaDYponTHdN1c
Message-ID: <CAJZ5v0je-10aKyA0zeDZbqTXzjxNb7yTfsWkt_-a-7uwqYdmcA@mail.gmail.com>
Subject: Re: [PATCH][next] ACPI: NFIT: Fix incorrect ndr_desc being reportedin
 dev_err message
To: Colin Ian King <colin.i.king@gmail.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Len Brown <lenb@kernel.org>, Jia He <justin.he@arm.com>, nvdimm@lists.linux.dev, 
	linux-acpi@vger.kernel.org, kernel-janitors@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 2, 2025 at 1:46=E2=80=AFPM Colin Ian King <colin.i.king@gmail.c=
om> wrote:
>
> There appears to be a cut-n-paste error with the incorrect field
> ndr_desc->numa_node being reported for the target node. Fix this by
> using ndr_desc->target_node instead.
>
> Fixes: f060db99374e ("ACPI: NFIT: Use fallback node id when numa info in =
NFIT table is incorrect")
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/acpi/nfit/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index ae035b93da08..3eb56b77cb6d 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -2637,7 +2637,7 @@ static int acpi_nfit_register_region(struct acpi_nf=
it_desc *acpi_desc,
>         if (ndr_desc->target_node =3D=3D NUMA_NO_NODE) {
>                 ndr_desc->target_node =3D phys_to_target_node(spa->addres=
s);
>                 dev_info(acpi_desc->dev, "changing target node from %d to=
 %d for nfit region [%pa-%pa]",
> -                       NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &r=
es.end);
> +                       NUMA_NO_NODE, ndr_desc->target_node, &res.start, =
&res.end);
>         }
>
>         /*
> --

Dan, Dave, are you guys going to take this one, or should I take care of it=
?
