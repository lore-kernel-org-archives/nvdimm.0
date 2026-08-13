Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDD948D897
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 15:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786635541; cv=none; b=lAcYfb7VhfvDAbWK7vjT2P9WvMCibpIbBkBeUBF3yxgJYukZQy+XUUShxTff+PztUoiPc1WvMfkOe4sEHlCFoP9qkpiVgvyDFR/zhalGby1AeBlnHQXLLXZKSfVKXA2nc637tdXEN3KhAkdT+rgkiHNNWLGwjcjD2Zz6LH0umD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786635541; c=relaxed/simple;
	bh=4bdKgSVyS9Rv+Y5OyBcnFCzibF0uAKQxUNxzTx2dkyM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZrDu/EPexK7ZoSbzus19n7dBkd8PCyPMeXbKBUQ5VUqY0Da/F6jtyoQOZQsf2CEjseEStfzNcq91gJmY3fMshkeX1Vt3BY+QqjltBHKeGGg98B2HFO7Cd2+idJ24BWK+k8dih1wVOnXff/m8wHyCzj7KL/NQEMwrKOTa++lVj9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LiGHQS6W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LiGHQS6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE331F000E9;
	Thu, 13 Aug 2026 15:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786635533;
	bh=rkvsdFqOoR2Sdk/XIfdiEsWuorY75/pqRdHnzWgbWq0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LiGHQS6WnzWz9vIQV3X4110mffcRFEaq0Y3s5Il5KgATrutomAqKjnbq6cXG3VLc3
	 ku8h0SQzEB3/dnNhK0sO6g30Vu4jvKv1GeLfv0J9ak7PSv2R34CFgXaQUGUVMo3++5
	 lG6tJxPZrhnNDrKzrqYjQcfzfBLBHdJTGonrnBULwaVUwjEEdlBHjLBAfnU/IvsMTC
	 8BUWTLVQGSAjDdaRaJjlAoW8MjGeGfHaKfMCFwnQnocepnFWxg/HSBxNDNksIK6W2K
	 /Okgx5/KQqNJxb0VW0qawxIjgVEXQ7No0zHXtkFMXVMAQ6Y6JcltndrW81IHRoxR4f
	 Qt3Hhv32D6jlQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/5] ACPI: NFIT: validate interleave and flush array
 extents
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260813151612.21777-1-pengpeng@iscas.ac.cn>
References: <20260813150948.17239-1-pengpeng@iscas.ac.cn>
 <20260813151612.21777-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 15:38:52 +0000
Message-Id: <20260813153853.8BE331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Out-of-bounds read in add_dcr() due to unchecked sizeof_dcr() calc=
ulation.
- [High] Out-of-bounds read in add_platform_cap() due to insufficient subta=
ble length validation.
- [High] ACPI notify handlers leak when DIMM registration fails, leading to=
 Use-After-Free.
- [High] Time-Of-Check to Time-Of-Use (TOCTOU) Heap Buffer Overflow in add_=
idt() and add_flush().
--

--- Patch [3]: [PATCH v2 3/5] ACPI: NFIT: validate interleave and flush arr=
ay extents ---
commit 5f0d0836358fb697d133a3d8f0839ed8e9b8fd8d
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

ACPI: NFIT: validate interleave and flush array extents

Interleave and flush subtables carry a fixed header followed by arrays
whose element counts come from firmware. sizeof_idt() and sizeof_flush()
derive the copy size from those counts but do not require the result to
fit in the subtable's advertised length.

> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index f68edfe649528..bf4ddc56494e3 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -882,9 +882,16 @@ static bool add_bdw(struct acpi_nfit_desc *acpi_desc,
> =20
>  static size_t sizeof_idt(struct acpi_nfit_interleave *idt)
>  {
> +	size_t size;
> +
>  	if (idt->header.length < sizeof(*idt))
>  		return 0;
> -	return sizeof(*idt) + sizeof(u32) * idt->line_count;
> +
> +	size =3D struct_size(idt, line_offset, idt->line_count);
> +	if (size > idt->header.length)
> +		return 0;
> +
> +	return size;
>  }

[Severity: High]
This is a pre-existing issue, but does fetching the size fields directly fr=
om
mapped memory here and in sizeof_flush() create a time-of-check to time-of-=
use
race condition?

Looking at add_idt(), the size is evaluated twice:

static bool add_idt(struct acpi_nfit_desc *acpi_desc, ...)
{
	...
	nfit_idt =3D devm_kzalloc(dev, sizeof(*nfit_idt) + sizeof_idt(idt),
			GFP_KERNEL);
	...
	memcpy(nfit_idt->idt, idt, sizeof_idt(idt));
	...
}

If firmware or a hypervisor alters line_count concurrently between the
allocation and the memcpy, could this lead to a heap buffer overflow?

[ ... ]

> =20
>  static size_t sizeof_flush(struct acpi_nfit_flush_address *flush)
>  {
> +	size_t size;
> +
>  	if (flush->header.length < sizeof(*flush))
>  		return 0;
> -	return struct_size(flush, hint_address, flush->hint_count);
> +
> +	size =3D struct_size(flush, hint_address, flush->hint_count);
> +	if (size > flush->header.length)
> +		return 0;
> +
> +	return size;
>  }

[Severity: High]
This isn't a bug introduced by this patch, but while we are improving bounds
checking, could sizeof_dcr() also read out of bounds?

If a control region subtable has a short length but dcr->windows is non-zer=
o,
sizeof_dcr() returns the full size:

static size_t sizeof_dcr(struct acpi_nfit_control_region *dcr)
{
	...
	if (dcr->windows)
		return sizeof(*dcr);
	...
}

Will this cause memcmp() to read out of bounds in add_dcr() when the derived
size is not validated against the actual subtable length?

[Severity: High]
This is a pre-existing issue, but does add_platform_cap() similarly lack le=
ngth
validation?

When add_table() processes ACPI_NFIT_TYPE_CAPABILITIES, it unconditionally
dispatches the function:

	case ACPI_NFIT_TYPE_CAPABILITIES:
		if (!add_platform_cap(acpi_desc, table))
			return err;
		break;

If the table length is short (e.g., 4 bytes), could the dereferences in
add_platform_cap() cause an out-of-bounds read?

static bool add_platform_cap(struct acpi_nfit_desc *acpi_desc,
		struct acpi_nfit_capabilities *pcap)
{
	...
	mask =3D (1 << (pcap->highest_capability + 1)) - 1;
	acpi_desc->platform_cap =3D pcap->capabilities & mask;
	...
}

[Severity: High]
This isn't a bug introduced by this patch, but does acpi_nfit_register_dimm=
s()
leak notify handlers on failure?

During dimm registration, if memory allocation fails for nvdimm, the functi=
on
returns early:

static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
{
	...
		nvdimm =3D __nvdimm_create(...);
		if (!nvdimm)
			return -ENOMEM;
	...
	return devm_add_action_or_reset(acpi_desc->dev, shutdown_dimm_notify,
			acpi_desc);
}

Since shutdown_dimm_notify is only queued for cleanup at the very end of the
function, do we leave dangling notify handlers registered if the loop aborts
early?

Could a subsequent event then trigger a use-after-free on the freed nfit_mem
structures?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260813150948.1723=
9-1-pengpeng@iscas.ac.cn?part=3D3
