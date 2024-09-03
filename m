Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABCD18CBEE
	for <nvdimm@lists.linux.dev>; Tue,  3 Sep 2024 19:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725391069; cv=none; b=WcHkeXJ3BWrBwOLUUeITmszgL68SHNWe3RCPiuJNykWSHyL4nkN9wWfRttKwWhwFNo0ezlQemM7mfmXzEACOu7yUdfEFwz6Gjyy0CSLaYIN1TzBfFV1AjnIBEYBkXuI/8dXazyHUJ8jiDNz5d2vJXHmkPeI1rLeIfH0VJJJ8Om8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725391069; c=relaxed/simple;
	bh=kNDVDagqIyJUR6yMgqE36mAL/l1EP0M2wYM/1b1fUJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UctO12GF6EUS0FKCjuWDaNE9LSJNaYGyFUfH8IYQN4Hgdz4f0GTrmhZq9FL+07lYyl0cpAKpriRuIhNqmErOPnuH/2+Dhf4l1FDZIgYUxQWQxbrRTr49E0Mr8jAMBLSfzvWWJzmD8es7WtzB08YcAiVCcYYnHR5bIGA0Hn+ocAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JONtaC0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JONtaC0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F06BC4CEC5
	for <nvdimm@lists.linux.dev>; Tue,  3 Sep 2024 19:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725391068;
	bh=kNDVDagqIyJUR6yMgqE36mAL/l1EP0M2wYM/1b1fUJo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JONtaC0javzhMrIEvm5G8wK6W0iGst58Gx/rUSTizbQ7zkGqhc92K9nmV9tJPn4+U
	 hg2AyzQimPGEN0mn4wZJI0UvpNLUpjJ9x/502u4xlw+dQgBIuV9LBDD1hOklfMWM97
	 iGMBgw4etPRYXjeYEPrEX2w3Y9/p3noB5KOKdzGqlk30uGx8CcRn++bvR/NeOTi089
	 t6fNGQ3swQFSM0PlLnPOROifXab8GBAsojJS2M+MjyAbj4glYYOgRRQ5r6MNp5ViQQ
	 Z0renG6uqgKXRoLiGHny8jeljttYhX0DiF+/CuFDfJpTUhsz5mcGx2HzwePIgwmDOh
	 1wQk0KlPUtlpg==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2f3f0bdbcd9so66977331fa.1
        for <nvdimm@lists.linux.dev>; Tue, 03 Sep 2024 12:17:47 -0700 (PDT)
X-Gm-Message-State: AOJu0YxdersHXmlQsHgxvNmCV5Q1HoMt5MhdIB8m5IWr1fU0Fh2S+ult
	7bdU9A+v6ZHCxvN2qP5g21ruQyZ3+DGogo0bpVoAL/HMSOy/y9TBbXEyzu1T9bqGPXU7Q4gXdfE
	P24qv2avzlPyx0wWASERJ+8B4Dg==
X-Google-Smtp-Source: AGHT+IGmrptwa9msLQUlQ1DEWIkWxsXnOS/2hU5mBSL42INWPkCCj9BFmS8VKk8qPYlR1d8v1BAIAPmETQG3Ch6X1Jo=
X-Received: by 2002:a2e:a7c1:0:b0:2ef:2ef5:ae98 with SMTP id
 38308e7fff4ca-2f651e11020mr772341fa.34.1725391066018; Tue, 03 Sep 2024
 12:17:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240731191312.1710417-26-robh@kernel.org>
In-Reply-To: <20240731191312.1710417-26-robh@kernel.org>
From: Rob Herring <robh@kernel.org>
Date: Tue, 3 Sep 2024 14:17:33 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKC5S_-vJjdYEsoFHAQiQvymVDE4_moy5g_p7YEfAmDLA@mail.gmail.com>
Message-ID: <CAL_JsqKC5S_-vJjdYEsoFHAQiQvymVDE4_moy5g_p7YEfAmDLA@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: Use of_property_present() and of_property_read_bool()
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	"Oliver O'Halloran" <oohall@gmail.com>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024 at 2:14=E2=80=AFPM Rob Herring (Arm) <robh@kernel.org>=
 wrote:
>
> Use of_property_present() and of_property_read_bool() to test
> property presence and read boolean properties rather than
> of_(find|get)_property(). This is part of a larger effort to remove
> callers of of_find_property() and similar functions.
> of_(find|get)_property() leak the DT struct property and data pointers
> which is a problem for dynamically allocated nodes which may be freed.
>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  drivers/nvdimm/of_pmem.c | 2 +-
>  drivers/nvmem/layouts.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Ping

> diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
> index 403384f25ce3..b4a1cf70e8b7 100644
> --- a/drivers/nvdimm/of_pmem.c
> +++ b/drivers/nvdimm/of_pmem.c
> @@ -47,7 +47,7 @@ static int of_pmem_region_probe(struct platform_device =
*pdev)
>         }
>         platform_set_drvdata(pdev, priv);
>
> -       is_volatile =3D !!of_find_property(np, "volatile", NULL);
> +       is_volatile =3D of_property_read_bool(np, "volatile");
>         dev_dbg(&pdev->dev, "Registering %s regions from %pOF\n",
>                         is_volatile ? "volatile" : "non-volatile",  np);
>
> diff --git a/drivers/nvmem/layouts.c b/drivers/nvmem/layouts.c
> index 77a4119efea8..65d39e19f6ec 100644
> --- a/drivers/nvmem/layouts.c
> +++ b/drivers/nvmem/layouts.c
> @@ -123,7 +123,7 @@ static int nvmem_layout_bus_populate(struct nvmem_dev=
ice *nvmem,
>         int ret;
>
>         /* Make sure it has a compatible property */
> -       if (!of_get_property(layout_dn, "compatible", NULL)) {
> +       if (!of_property_present(layout_dn, "compatible")) {
>                 pr_debug("%s() - skipping %pOF, no compatible prop\n",
>                          __func__, layout_dn);
>                 return 0;
> --
> 2.43.0
>
