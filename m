Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E1E3B9DB6;
	Wed, 24 Jun 2026 15:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313935; cv=none; b=JJ/dZ4Jtb8FlY8tRnkVHwyg06aQMdYSk04w3zEj2sBSzv7HGCPtT1qnubJ5ZPp+h3LcfmwrRxUYdMQrKmTZPnkX1E/TPQ2rMPXKf0zrhjiMzyBc57Kiv0K1MKEU88NPJLWUcxDlx3iSrqhM0Ym2VvV3xezJgM0EBmi3bg0tCSoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313935; c=relaxed/simple;
	bh=160c3KK2Vfa3JNRCU1L7UDH/XggHixByBGCW2YkwBN8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p13o6LV52iYW/hn+GBtwbFMaIHdXhbk6pKaBjXHM4ffunUZuH/8ZTSl2tU2B8HoC/u7g4hLjndLVv08i2mB8/9SFSyW/os55PBJc0Y+Qv7jKfajtbmB90yNqc3ijHGnpRajls4kISA2+kjAQVa9bJGjht/5TX+XAFOO8hXT7pcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EOJyUw6q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EOJyUw6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974611F000E9;
	Wed, 24 Jun 2026 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313934;
	bh=ZK3V/yHIKgj63dV8u4eDtUi3hVpdOk9eTQuPMa0qJ2E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EOJyUw6q3A0Cw+W6TYqwHvrHF+OVeK6UhOSqWDItxbrAeNmIY19NTC/1jSScea8i9
	 BcEXRC3eKOIQyR0JNF3hWNtLYzI+eOcZWoyUXTBQ9NqDyB3/rcGf99M/8Ph5eyFMxi
	 mwP9E+RccgBpMBb3OaoWZ2rUY7czYAFBFFBrRvKkP8RWv5K9ikSG0ggwqF5ShKkoEo
	 577sZCONkNNWFR1wCULPM1AfZ5RLb7naFhY8gaQFf3/xcf6W09txi7/GcNOyPkn6lw
	 k5R++4vPg0BsIiWcjrDXKLP2/SfAhIOxiyEnutEcJ2XrI0UF47MiJk/78IZDlYD2iC
	 hSOS0rt54Htsg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 6/9] dax: plumb hotplug online_type through dax
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260624145744.3532049-7-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-7-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 15:12:14 +0000
Message-Id: <20260624151214.974611F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Assigning DAX_ONLINE_DEFAULT (-1) to enum mmop triggers UBSan ou=
t-of-bounds violation.
--

commit e0320ba16dade8553731440e4c066c6a7c836047
Author: Gregory Price <gourry@gourry.net>

dax: plumb hotplug online_type through dax
   =20
There is no way for drivers leveraging dax_kmem to plumb through a
preferred auto-online policy - the system default policy is forced.
Add 'enum mmop' field to DAX device creation path to allow drivers
to specify an auto-online policy when using the kmem driver.

> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index 5909171a4428b..f3c9dae5de6ba 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -16,6 +17,13 @@ struct dax_region;
>  #define IORESOURCE_DAX_STATIC BIT(0)
>  #define IORESOURCE_DAX_KMEM BIT(1)
> =20
> +/*
> + * online_type sentinel: the device was created without an explicit onli=
ne
> + * policy, so the system default is resolved when the kmem driver binds,
> + * (not at device-creation time, which would freeze a stale policy).
> + */
> +#define DAX_ONLINE_DEFAULT	(-1)
> +
>  struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  		struct range *range, int target_node, unsigned int align,
>  		unsigned long flags);
> @@ -26,6 +34,7 @@ struct dev_dax_data {
>  	resource_size_t size;
>  	int id;
>  	bool memmap_on_memory;
> +	enum mmop online_type;

[Severity: Medium]
Can this declaration cause an out-of-bounds UBSan violation when assigned
DAX_ONLINE_DEFAULT? DAX_ONLINE_DEFAULT is defined as -1, but enum mmop only
has a valid range from 0 to 3.

>  };

[ ... ]

> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 81e4af49e39c1..ccd77965fe3ed 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -95,6 +98,7 @@ struct dev_dax {
>  	struct device dev;
>  	struct dev_pagemap *pgmap;
>  	bool memmap_on_memory;
> +	enum mmop online_type;

[Severity: Medium]
Does this struct member also need to be an int instead of enum mmop to safe=
ly
store the -1 sentinel value?

>  	int nr_range;
>  	struct dev_dax_range *ranges;
>  };

[ ... ]

> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 592171ec10f49..0a184c0878ddf 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -132,6 +133,11 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_da=
x)
>  		goto err_reg_mgid;
>  	data->mgid =3D rc;
> =20
> +	/* Resolve system default at bind time in case it changed */
> +	online_type =3D dev_dax->online_type;

[Severity: Medium]
Could loading dev_dax->online_type here when it is set to -1 trigger a UBSan
out-of-bounds violation during probe?=20

> +	if (online_type =3D=3D DAX_ONLINE_DEFAULT)
> +		online_type =3D mhp_get_default_online_type();
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624145744.3532=
049-1-gourry@gourry.net?part=3D6
