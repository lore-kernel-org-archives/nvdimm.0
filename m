Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB4C4908C2
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 15:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786635724; cv=none; b=Oen181ORZ2GFfihfTQz6JQ6Mc+11RlLti/e76WPjAhbkwkxEAaRdQau68EMLDRs0YJ7j5tF7aCXLR55C1qEoqW7+JSMrSg+36MmEaWdA8mU1gB3s/koIsU1Mw1RZBobjtOrjRisT7K/Q5dR4VfOwBfQ7krWFaUG1q8G2gT+8Ono=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786635724; c=relaxed/simple;
	bh=7MO1V7t0Z1u0AVSs0Mr0g08qmWsrApOnvdOS5LQRmEk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=i3y2ww/dEAR0y1GjdtBMRI7oKxCzTMY2JBbYrsvRXHNG2zkge4Lt/R+e9Txlpo9PSHPNzg1Y8N4kk3jlSqSLYC+oN3yGw+qb+EzdXH6ColIPSJ9sn7d3rIKnpWwxgCf4j25ubWtE2m7Q/iHx0C9EP0/xKTi5A60tKfHJpUwrL8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UUY8JBKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UUY8JBKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5271F000E9;
	Thu, 13 Aug 2026 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786635715;
	bh=Yu2C6O92me+YWwZC7kILto9HaOKDElJifyMD6bs46Jk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UUY8JBKdCqMrtSL8D5GLfJ2eVUqetZMPYyXcSfmsk/XqqSf3TOOo/AXHuCiqB8xOt
	 wwCRYAr8eLxEQ7DIR6XDaq/cv9vYRjr2oMqff5wdRrRbiWq+wrY+Dk2SY66JxMjbdz
	 q8XHP+7kyHVaPkA6602wLLVLgApdRKvWtc96BcYXETht0fiTiCZyR4GjPSLWQKHDv8
	 ysh6MrwJB8gYF8Byu9ke7dXzhddgjMfk2n06ZivrmZGgSwZAfJiXKEL8E7+dLmib7c
	 cuuSr5mjzkQFCLRTUThXhvlHyK8QIiBzUOtx5jG9sVrFsW+AdrQZlrAA3q/KKBBT3L
	 VGg13ii3UWf3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/5] ACPI: NFIT: validate subtable extents before
 dispatch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260813151111.18434-1-pengpeng@iscas.ac.cn>
References: <20260813150948.17239-1-pengpeng@iscas.ac.cn>
 <20260813151111.18434-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 15:41:54 +0000
Message-Id: <20260813154155.4C5271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

Pre-existing issues:
- [High] sizeof_spa() accesses spa->flags before validating the subtable le=
ngth, causing an out-of-bounds read.
- [High] add_platform_cap() reads capability fields without verifying the s=
ubtable length, causing an out-of-bounds read.
- [High] Early termination in acpi_nfit_init() leaves internal device lists=
 stranded on the stack, corrupting the device state and leaking resources.
- [High] sizeof_idt() calculates a size that can exceed the verified subtab=
le length, causing an out-of-bounds read in add_idt().
- [High] sizeof_dcr() can return a size exceeding the verified subtable len=
gth when dcr->windows is set, causing an out-of-bounds read.
- [Medium] Bitwise shift operation in add_platform_cap() can cause undefine=
d behavior if highest_capability >=3D 31.
--

--- Patch [1]: [PATCH v2 1/5] ACPI: NFIT: validate subtable extents before =
dispatch ---
commit 7124d3c49e2df0b214c3037c798664d5e4c0f3d3
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

ACPI: NFIT: validate subtable extents before dispatch

This commit strengthens NFIT table parsing by requiring a complete header a=
nd=20
validating that the advertised subtable length fits within the remaining by=
tes
in the NFIT before dispatching it.

> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -963,14 +963,18 @@ static void *add_table(struct acpi_nfit_desc *acpi_=
desc,
>  	struct device *dev =3D acpi_desc->dev;
>  	struct acpi_nfit_header *hdr;
>  	void *err =3D ERR_PTR(-ENOMEM);
> +	size_t table_len;
> =20
>  	if (table >=3D end)
>  		return NULL;
> +	table_len =3D end - table;
> +	if (table_len < sizeof(*hdr))
> +		return NULL;
> =20

[Severity: High]
This isn't a bug introduced by this patch, but returning NULL here can cause
device state corruption during runtime updates.

If add_table() returns NULL early while parsing an ACPI update in
acpi_nfit_init(), the function jumps to out_unlock:

drivers/acpi/nfit/core.c:acpi_nfit_init() {
    ...
    goto out_unlock;
    ...
}

At that point, it exits without restoring nodes from the stack list prev ba=
ck
to acpi_desc, which permanently empties the device's operational lists.

Does acpi_nfit_init() need to be updated to handle this early return safely?

>  	hdr =3D table;
> -	if (!hdr->length) {
> -		dev_warn(dev, "found a zero length table '%d' parsing nfit\n",
> -			hdr->type);
> +	if (hdr->length < sizeof(*hdr) || hdr->length > table_len) {
> +		dev_warn(dev, "invalid table length %u for type %u parsing nfit\n",
> +			 hdr->length, hdr->type);
>  		return NULL;
>  	}

[Severity: High]
This is a pre-existing issue, but while we are strengthening generic table
length checks here, does sizeof_spa() also need bounds checking?

If a malformed table provides a System Physical Address (SPA) subtable with=
 a
length of 4 or 5, add_table() will accept it because hdr->length >=3D 4. Ho=
wever,
sizeof_spa() in drivers/acpi/nfit/core.c reads spa->flags before verifying =
the
subtable length is at least 8 bytes:

drivers/acpi/nfit/core.c:sizeof_spa() {
    if (spa->flags & ACPI_NFIT_LOCATION_COOKIE_VALID)
        ...
}

Can this lead to an out-of-bounds read if the table length is too small?

[Severity: High]
This is a pre-existing issue, but does add_platform_cap() similarly need
length validation?

A capabilities subtable might pass the generic length check here, but
add_platform_cap() in drivers/acpi/nfit/core.c reads capabilities without
verifying the subtable length is at least 16 bytes:

drivers/acpi/nfit/core.c:add_platform_cap() {
    mask =3D (1 << (pcap->highest_capability + 1)) - 1;
    acpi_desc->platform_cap =3D pcap->capabilities & mask;
}

Could this result in an out-of-bounds read?

[Severity: Medium]
This is also a pre-existing issue, but in the same code snippet above, if
highest_capability is 31 or greater, would the bitwise shift:

drivers/acpi/nfit/core.c:add_platform_cap() {
    mask =3D (1 << (pcap->highest_capability + 1)) - 1;
}

invoke undefined behavior by shifting a 32-bit signed integer by 32 or more?

[Severity: High]
This is a pre-existing issue, but does sizeof_idt() also need length bounds
checking to prevent out-of-bounds reads?

If a malformed table has a small hdr->length but a large line_count,
sizeof_idt() in drivers/acpi/nfit/core.c calculates a required size ignoring
hdr->length:

drivers/acpi/nfit/core.c:sizeof_idt() {
    return sizeof(*idt) + sizeof(u32) * idt->line_count;
}

Then add_idt() passes this unvalidated size to memcpy:

drivers/acpi/nfit/core.c:add_idt() {
    memcpy(nfit_idt->idt, idt, sizeof_idt(idt));
}

Could this copy past the mapped ACPI table boundary?

[Severity: High]
This is a pre-existing issue, but could sizeof_dcr() return a size exceeding
the verified subtable length?

If dcr->windows is set, sizeof_dcr() in drivers/acpi/nfit/core.c blindly
returns 80 bytes:

drivers/acpi/nfit/core.c:sizeof_dcr() {
    if (dcr->windows)
        return sizeof(*dcr);
}

Then add_dcr() copies the memory:

drivers/acpi/nfit/core.c:add_dcr() {
    memcpy(nfit_dcr->dcr, dcr, sizeof_dcr(dcr));
}

If the firmware provided less than 80 bytes for the control region table, d=
oes
this cause an out-of-bounds read?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260813150948.1723=
9-1-pengpeng@iscas.ac.cn?part=3D1
