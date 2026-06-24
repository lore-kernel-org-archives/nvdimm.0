Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1873B7B7B;
	Wed, 24 Jun 2026 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313748; cv=none; b=qdpo0XpzJtZw4iPifEAdl2ZpJc8f/xpsgebqUbIQ4WtAY/5DXG9zukwPw/OS9wnmv/dR1+MKqYijI/yZEJOKSBxkYjH0BaqJ8mQs7QGikGO24ayNuX8phLqSvBxgOhWqT15wnORfCGG9TcMOddIyRk8EVBWImmIuAeoe2hOQBWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313748; c=relaxed/simple;
	bh=AmqBUzS5AJQHbmeWLL3HjMha4YogvAdiydNNhl8cN4k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BbPvByzlMM3sHfzqPjtR1YPnxs1aFpI3nnQ0+RYj7q8vERBh3zE7vZD3kXPz2HWwg9jZVUAcPWArlMuenqsduLjfWgOk6GzkzX1xcVLzqpURz1Ah/NDKQiDyKwHvadziHfC8Xm40vvipfz6YMztH+Pp2dGXE9FPv00EihiYSHLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TbXTlIJB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TbXTlIJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0CA1F00A3A;
	Wed, 24 Jun 2026 15:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313747;
	bh=4m44JF5Be8v2FBzfVV9P3S4GzimvhdBPxiF5QQNEd2c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TbXTlIJBK/92WSz0u2zqRJ9Jvqgt4BcziIKki22NScQcorNlFfQrBmX/mftrwyQVR
	 If2dO+SynNpP76gcACdUTJV/xYbBhgQKYean/Pne4KRNNtQTkyHB1ABByEwWMj3cud
	 6MYqH80KSgEuJhohOIeU5ryLVfh4+58I6vGbsJgnsldh3FG2WDLOWiIkL9Nk6tsVA5
	 IGFrozjTq0UMcYs4YD84Dzrj1dXHOs8+ADtDG+euyk0OtKQYJu2incFvtku0mkh4RV
	 jR1F45QwM5atPsdxq8Bv7qRrLyyLXuaF87MTcEo+6UJX/MIB+exWC9fbfSExG7Eq/+
	 St0/vtRKWJGHQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 7/9] dax/kmem: extract hotplug/hotremove helper
 functions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260624145744.3532049-8-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-8-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 15:09:06 +0000
Message-Id: <20260624150907.4A0CA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] dax_kmem_do_hotplug() unconditionally attempts to hotplug memory f=
or all ranges without verifying successful resource reservation, leading to=
 a permanent memory leak and potential use-after-free.
--

commit 5d9cdda5cefdb148a54897a713788ec98f55e42a
Author: Gregory Price <gourry@gourry.net>

    dax/kmem: extract hotplug/hotremove helper functions
   =20
    Refactor kmem _probe() _remove() by extracting init, cleanup, hotplug,
    and hot-remove logic into separate helper functions:

> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 0a184c0878ddf..a45e50def5371 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
[ ... ]
> @@ -63,14 +63,195 @@ static void kmem_put_memory_types(void)
>  	mt_put_memory_types(&kmem_memory_types);
>  }
> =20
> +/**
> + * dax_kmem_do_hotplug - hotplug memory for dax kmem device
> + * @dev_dax: the dev_dax instance
> + * @data: the dax_kmem_data structure with resource tracking
> + *
> + * Hotplugs all ranges in the dev_dax region as system memory.
> + *
> + * Returns the number of successfully mapped ranges, or negative error.
> + */
> +static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
> +			       struct dax_kmem_data *data,
> +			       int online_type)
> +{
> +	struct device *dev =3D &dev_dax->dev;
> +	int i, rc, onlined =3D 0;
> +	mhp_t mhp_flags;
> +
> +	for (i =3D 0; i < dev_dax->nr_range; i++) {
> +		struct range range;
> +
> +		rc =3D dax_kmem_range(dev_dax, i, &range);
> +		if (rc)
> +			continue;
> +
> +		mhp_flags =3D MHP_NID_IS_MGID;
> +		if (dev_dax->memmap_on_memory)
> +			mhp_flags |=3D MHP_MEMMAP_ON_MEMORY;
> +
> +		/*
> +		 * Ensure that future kexec'd kernels will not treat
> +		 * this as RAM automatically.
> +		 */
> +		rc =3D __add_memory_driver_managed(data->mgid, range.start,
> +				range_len(&range), kmem_name, mhp_flags,
> +				online_type);

[Severity: High]
Does this unconditionally add memory even for ranges that failed to reserve
resources?

If dax_kmem_init_resources() succeeds on the first range but fails on a
subsequent range, it leaves data->res[i] =3D NULL and continues because
mapped > 0.

Then dax_kmem_do_hotplug() iterates over all ranges again and unconditional=
ly
calls __add_memory_driver_managed() for the range that failed reservation.

If memory addition succeeds, the memory is brought online without an I/O
resource reservation. Later, during device removal, dax_kmem_do_hotremove()
skips ranges where !data->res[i], which permanently leaks the online memory.
When the backing device is physically removed, any access to this memory
could cause a crash.

Should there be an if (!data->res[i]) continue; check here to ensure we only
hotplug memory for successfully reserved regions?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624145744.3532=
049-1-gourry@gourry.net?part=3D7
