Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D1D48A8D1
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 15:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786635360; cv=none; b=HszNDy8gbrbLhH4B7Fr9jcOj+FGvBCIJhDDAP7KBW89/vUyxzEgQLT09Vz9pXT7CtSlNwgOHcd8kKdF5W3Qa0X8iw8Xr4kyB2oq/JekakJqZOtFii1ENMp0JD63332XHSrt3axjhX/rBdH75JsR+jVzWI0ObtnMqtHrJltX+FBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786635360; c=relaxed/simple;
	bh=MSj/mUP2F7oRRUDO0d40wuIudKfe9mQ1UnEDa5ZV5BE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gXDMvMkj1bJwda9VMkiyb3A14lOXAl7D2n5qd6wkif1zDQwuN6zypsdNnepAscc4Nw/GmgIDyvTN13pJRplOM96tfTBRp6cwbScJuWrIgbAweh60mZ8zMpWpF38Q01Mtrxx1ilpQzB6mATJ96javDjdiNdk9ojYwjDEzCZ61ehI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZNCmnfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZNCmnfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A44A1F000E9;
	Thu, 13 Aug 2026 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786635350;
	bh=BrO9NprgChBjFigw17eSPW1NSeS7qvF00GNGRRN3uUE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iZNCmnfozoGAZ+Jr3nDBeP5Ui3CP1l5BSWZ2xufYKYtZznxzatVTLffzZoq4Ej9sd
	 wyfEKECjxZORV/NdB1VKEiol74LNp8nBwDUIEIb173zuva0I7mZo9zKlNJT4tO3Zrg
	 iv7yYWoUthBg4CiSa2m0Ag5w2trgzZcvGUq5LptYpphKNX7AfQKStOu3ogFe3UKQBK
	 HExrKXYlB6k0jxyIgvgj0Zn4hlqvifuFctSAk8bvLuUG+D2oY9w4wi/MQo6oSQMi3P
	 OYCfeh3ufOXH+7EG02JYT+D3REFxgrGSoMZmoPCx/AdLeuUUjmR43aM+1UUUG2q5eP
	 fVjLX6MIYp+Aw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/5] ACPI: NFIT: accept SPA structures with an unused
 location cookie
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260813151340.20276-1-pengpeng@iscas.ac.cn>
References: <20260813150948.17239-1-pengpeng@iscas.ac.cn>
 <20260813151340.20276-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 15:35:49 +0000
Message-Id: <20260813153550.4A44A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] If `acpi_nfit_init()` encounters an error during table parsing (e.=
g., memory allocation failure) or detects unsupported deletions, it returns=
 without restoring the remaining elements left in the stack-allocated `prev=
` lists. This corrupts the driver's active state by permanently losing trac=
king of those elements.
- [High] Pre-existing out-of-bounds reads in `add_dcr`, `add_flush`, and `a=
dd_idt` due to missing `header.length` validation against computed sizes.
--

--- Patch [2]: [PATCH v2 2/5] ACPI: NFIT: accept SPA structures with an unu=
sed location cookie ---
commit 1d01437bf3a7475500c2f72bf23fa46edef22d6c
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

ACPI: NFIT: accept SPA structures with an unused location cookie
   =20
ACPI 6.4 extended the System Physical Address Range Structure from 56
to 64 bytes by appending an eight-byte location cookie. The cookie-valid
flag describes whether that field contains usable data; it does not
select the structure length.

> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 4428adb6a1ab6..f68edfe649528 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -705,9 +705,20 @@ int nfit_spa_type(struct acpi_nfit_system_address *s=
pa)
> =20
>  static size_t sizeof_spa(struct acpi_nfit_system_address *spa)
>  {
> +	size_t legacy_size =3D offsetof(struct acpi_nfit_system_address,
> +				      location_cookie);
> +	size_t size =3D spa->header.length;
> +
> +	if (size =3D=3D sizeof(*spa))
> +		return size;
> +
> +	if (size !=3D legacy_size)
> +		return 0;
> +
>  	if (spa->flags & ACPI_NFIT_LOCATION_COOKIE_VALID)
> -		return sizeof(*spa);
> -	return sizeof(*spa) - 8;
> +		return 0;
> +
> +	return size;
>  }

[Severity: High]
This is a pre-existing issue, but since you are fixing the length logic for
SPA structures here, does similar code in sizeof_idt() and sizeof_flush() n=
eed
bounds checking against the header length?

In drivers/acpi/nfit/core.c:sizeof_idt():

static size_t sizeof_idt(struct acpi_nfit_interleave *idt)
{
	if (idt->header.length < sizeof(*idt))
		return 0;
	return sizeof(*idt) + sizeof(u32) * idt->line_count;
}

Can this lead to an out-of-bounds read if a malformed ACPI table provides an
idt->line_count that makes the computed size larger than idt->header.length?

The add_idt() function uses this unvalidated computed size directly for
memcpy() and memcmp() on the ACPI buffer. Similar logic is present in
sizeof_flush() and add_flush() with flush->hint_count.

[ ... ]

> @@ -716,23 +727,26 @@ static bool add_spa(struct acpi_nfit_desc *acpi_des=
c,
>  {
>  	struct device *dev =3D acpi_desc->dev;
>  	struct nfit_spa *nfit_spa;
> +	size_t size =3D sizeof_spa(spa);
> =20
> -	if (spa->header.length !=3D sizeof_spa(spa))
> +	if (!size)
>  		return false;

[Severity: High]
This isn't a bug introduced by this patch, but looking at acpi_nfit_init()
which manages the prev list passed into these add_*() functions, is there a
state corruption and memory leak on the error path?

If a hotplug event removes regions and acpi_nfit_check_deletions() fails, it
returns -ENXIO and jumps to out_unlock:

	rc =3D acpi_nfit_check_deletions(acpi_desc, &prev);
	if (rc)
		goto out_unlock;
    ...
 out_unlock:
	mutex_unlock(&acpi_desc->init_mutex);
	return rc;

Since prev is allocated on the stack in acpi_nfit_init(), does jumping to
out_unlock without splicing the remaining un-matched entries back onto the
acpi_desc lists permanently lose track of those items?=20

It appears this would drop them from the driver's tracking lists while leav=
ing
their list node pointers dangling to a destroyed stack frame.

>  	list_for_each_entry(nfit_spa, &prev->spas, list) {
> -		if (memcmp(nfit_spa->spa, spa, sizeof_spa(spa)) =3D=3D 0) {
> +		if (sizeof_spa(nfit_spa->spa) !=3D size)
> +			continue;
> +
> +		if (memcmp(nfit_spa->spa, spa, size) =3D=3D 0) {
>  			list_move_tail(&nfit_spa->list, &acpi_desc->spas);
>  			return true;
>  		}
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260813150948.1723=
9-1-pengpeng@iscas.ac.cn?part=3D2
