Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F9A48550D
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 15:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786635203; cv=none; b=rNzymj9CbGlYAykB0nSFOqHbvGZAT5coxU/02MPZUyPEwCT5HWG7r04t8qwxkB5au6ukttOZasE1EESbOmCVJkkKbBfpkvpB+60aT9K9JYOXh6q5om0Rh3ap1PgtMtI3G7tSY85f9cBrKlx6+K0IJdiMSUTuOAmeNk+ZtrAydoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786635203; c=relaxed/simple;
	bh=luKL1VhcogGIwjJM7/W9cpfJB7D9yEipC54Sl/hf9iU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ThYj0Ig4DwpfoeAj7Z6GmmyTIvWc+GJ0AXF7D+AdsE23rmWz/9CtMXGRY5ca2xJTX+jSZhEnppDGtyBz3ABv5gbVYpSItLRns7wh+I2aABHkTvXC7fWffhdUebOXXBdP3llH1FMYyqSg+TUpqe9zQUmzJfR1N3OwCnPeN5whs+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CEMBUb0f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEMBUb0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71F51F000E9;
	Thu, 13 Aug 2026 15:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786635202;
	bh=WsmhTakhmRQl84qYKh82bo/zIE5dl5JZ/rkETpqctks=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CEMBUb0f8DntqC3gm3/m6+/t+fJTKWM3MRQs1KzVerM8EUDC7yxz4zh0NOjPA+Ut2
	 gdw/Szw4469a/IL5XJ1S9LR5AnDC8RM5aw6jWozMg3mE/S7/VlzyaRepxBMSCyrNGT
	 sHUAcxE+s38MTZOfX3X0aHIRHb2V7EgNRI+ririSo94jPh0mzuCixcVRYOWEiVMjiX
	 28Iit7IFilDdB1amVtltCij6d40+nx0BWjbbPOjOs5SpukDho26fBL0aCy/SYURGqg
	 8YUpXI3qcj0IurSmEqWGueA+T9p0ZTdiNLwiVxty+F960/GhfmMmiTfASck/3GA1PN
	 dKWjE24PjJCCA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/5] ACPI: NFIT: bound the platform capability mask
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260813152037.25828-1-pengpeng@iscas.ac.cn>
References: <20260813150948.17239-1-pengpeng@iscas.ac.cn>
 <20260813152037.25828-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 15:33:21 +0000
Message-Id: <20260813153321.D71F51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `acpi_nfit_init` function fails to restore list elements on er=
ror paths, leading to memory leaks and complete state corruption for existi=
ng NVDIMM devices during hot-updates.
--

--- Patch [5]: [PATCH v2 5/5] ACPI: NFIT: bound the platform capability mas=
k ---
commit bbbfd46d3c5bf4ec32e49479ec84620dc0f64973
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

ACPI: NFIT: bound the platform capability mask

The platform capability subtable parser reads highest_capability and
capabilities without first requiring the fixed structure to be present.
This commit adds checks to prevent out-of-bounds reads and undefined shifts.

> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 84c70f1941c57..7638d4dc8c6da 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -987,7 +987,14 @@ static bool add_platform_cap(struct acpi_nfit_desc *=
acpi_desc,
>  	struct device *dev =3D acpi_desc->dev;
>  	u32 mask;
> =20
> -	mask =3D (1 << (pcap->highest_capability + 1)) - 1;
> +	if (pcap->header.length < sizeof(*pcap))
> +		return false;

[Severity: High]
This is a pre-existing issue, but does adding this new early return expose
a state corruption bug during hot-updates?

In acpi_nfit_init(), existing NFIT resources are moved to a local stack
variable before parsing:

acpi_nfit_init() {
        ...
        list_cut_position(&prev.spas, &acpi_desc->spas,
                          acpi_desc->spas.prev);
        ...

If the newly added capability length check fails, it appears the table
parsing aborts:

        if (IS_ERR(data)) {
                dev_dbg(dev, "nfit table parsing error: %ld\n", PTR_ERR(dat=
a));
                rc =3D PTR_ERR(data);
                goto out_unlock;
        }

Which jumps directly to the exit label:

out_unlock:
        mutex_unlock(&acpi_desc->init_mutex);
        return rc;
}

Since the elements in the local prev lists are never restored to
acpi_desc on this error path, do these devm-managed items become permanently
leaked with dangling list pointers when prev goes out of scope?

> +
> +	if (pcap->highest_capability >=3D 31)
> +		mask =3D U32_MAX;
> +	else
> +		mask =3D (1U << (pcap->highest_capability + 1)) - 1;
> +
>  	acpi_desc->platform_cap =3D pcap->capabilities & mask;
>  	dev_dbg(dev, "cap: %#x\n", acpi_desc->platform_cap);
>  	return true;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260813150948.1723=
9-1-pengpeng@iscas.ac.cn?part=3D5
