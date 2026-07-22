Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A4C3DDAED
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 04:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784694664; cv=none; b=MHPZccKHLlaDYTtRf1sAlVybAxXzduV6mHjATBf3uiTtWYlfTo74Q74JZyHS+Xs7MRRcvGAhB4GFuNMjdbcb8GRU9oNU6A3+U5Nch3vrHFUWdCb3CjSqKeCNQ0LTMCWkHusfrU6ZxR9IjkuDOUO/kz+BLXO27pVHLRAoiIgxac0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784694664; c=relaxed/simple;
	bh=eZtF/M9ExBZjLGxvEBoUK/Jtm2wFtF/avdeo0vdCzGs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qo4JvAAvzxCPQG7+rPdfjst1GXUiKL7koedE4ZEp6WEOyMsIPdRtUCiIXuoQjZnhhbbHs5My8TNHZsOLNQABNlRBEzVq32nLyWmGuu4/vADck0/7iw3hRsbYaHLE9f4qyhwuba0/gIciT8nfyriSKlXoGlestBI/3AGd5hwpLx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IRNKDglc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IRNKDglc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB53B1F000E9;
	Wed, 22 Jul 2026 04:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784694662;
	bh=3ey4ni/Vlevu6MLjiCbJyMceOygOQKC5GOPKsvmW2Bg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IRNKDglc97q+d1XSMZ0D9sli79YHB3gqZgtjS5gdFC9AJWKF4S8C3/5FCCVUgtH8W
	 JCgzN2bpLiRNV2rH0h3eLtW8whnCCOOWfGySO7PXuMe3TO2EEpM5EbHXk4Qe+JsSAn
	 miqiMlgdkNQPmcT3K6qdVqT0POc4etoA/xVFHjouurXXIcQqsCTnhPu5DNU9mQhe/e
	 TdsCU8vZAySgrp5xGgwFhexmZRS9mbWmuDkUz8+IQFF4x75gmcyMEIdVr/qGM5Iqem
	 nNlbso8Qs1weuK5Y1BxVJ/Uqo8bZuIGqpju1zSDNg58jvVQPLcTXHdhctVJ5eYCN3L
	 jBCDYsZwkaH3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ACPI: NFIT: validate subtable extents before parsing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260722041701.21078-1-pengpeng@iscas.ac.cn>
References: <20260722041701.21078-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 04:31:02 +0000
Message-Id: <20260722043102.AB53B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Rejecting the capability table if `highest_capability > 31` fails =
the entire NFIT driver probe, breaking forward compatibility.

Pre-existing issues:
- [High] Missing bounds check in `sizeof_dcr` leads to potential out-of-bou=
nds read when parsing the Control Region subtable.
- [High] `sizeof_spa` incorrectly assumes that the SPA length is determined=
 by the `LOCATION_COOKIE_VALID` flag, rejecting valid ACPI 6.4+ System Phys=
ical Address tables.
--

--- Patch [1]: [PATCH] ACPI: NFIT: validate subtable extents before parsing=
 ---
commit d7436f5d72f81006ac23c35fc1e7248c7a9fe254
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

ACPI: NFIT: validate subtable extents before parsing

add_table() reads an NFIT subtable header after checking only that the
cursor is before the end of the table. It then advances by the advertised
subtable length without proving that either the header or the full
subtable is present. This patch validates the fixed header and advertised
length before dispatch, and ensures variable arrays fit their subtables.

> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index cb771d9cadb2a..711ab639cb147 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -705,6 +705,10 @@ int nfit_spa_type(struct acpi_nfit_system_address *s=
pa)
> =20
>  static size_t sizeof_spa(struct acpi_nfit_system_address *spa)
>  {
> +	if (spa->header.length <
> +	    offsetof(struct acpi_nfit_system_address, reserved))
> +		return 0;
> +
>  	if (spa->flags & ACPI_NFIT_LOCATION_COOKIE_VALID)
>  		return sizeof(*spa);
>  	return sizeof(*spa) - 8;
>  }

[Severity: High]
This is a pre-existing issue, but does this logic risk rejecting valid
ACPI 6.4+ System Physical Address tables?

If a compliant ACPI 6.4 firmware presents a 64-byte SPA table with the
LOCATION_COOKIE_VALID flag unset, sizeof_spa() will assume the length
should be 56.

In add_spa() in drivers/acpi/nfit/core.c, the exact length equality check
will then fail:

add_spa() {
    ...
    if (spa->header.length !=3D sizeof_spa(spa))
        return false;
    ...
}

Will this bubble up as ERR_PTR(-ENOMEM) and abort the entire driver probe
on compliant platforms?

[Severity: High]
This is also a pre-existing issue, but while we're adding bounds checks,
does sizeof_dcr() in drivers/acpi/nfit/core.c have a similar missing check
that could lead to an out-of-bounds read?

When an ACPI table provides a DCR subtable with header.length exactly enough
to include the windows field (e.g., 32) and windows > 0, sizeof_dcr() calcu=
lates
the required size as 80 bytes:

sizeof_dcr() {
    ...
    if (dcr->windows)
        return sizeof(*dcr);
    ...
}

add_table() only verifies that 32 bytes remain in the mapped ACPI table. The
memcpy() in add_dcr() then reads 80 bytes:

add_dcr() {
    ...
    memcpy(nfit_dcr->dcr, dcr, sizeof_dcr(dcr));
    ...
}

Could this extend 48 bytes past the end of the subtable, potentially reading
unmapped memory and causing a kernel panic?

[ ... ]

> @@ -951,7 +969,16 @@ static bool add_platform_cap(struct acpi_nfit_desc *=
acpi_desc,
>  	struct device *dev =3D acpi_desc->dev;
>  	u32 mask;
> =20
> -	mask =3D (1 << (pcap->highest_capability + 1)) - 1;
> +	if (pcap->header.length < sizeof(*pcap))
> +		return false;
> +	if (pcap->highest_capability > 31)
> +		return false;

[Severity: High]
Does returning false here break forward compatibility with future ACPI
firmware?

If a future firmware revision sets highest_capability > 31 to indicate supp=
ort
for new features, this check will return false.

Since add_table() handles this by returning ERR_PTR(-ENOMEM):

add_table() {
    ...
    case ACPI_NFIT_TYPE_CAPABILITIES:
        if (!add_platform_cap(acpi_desc, table))
            return err;
    ...
}

Would this cause the entire NFIT driver probe to fail, rather than just
gracefully capping or ignoring the unknown capability bits?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722041701.2107=
8-1-pengpeng@iscas.ac.cn?part=3D1
