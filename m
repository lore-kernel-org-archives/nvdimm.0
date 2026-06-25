Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0663A1A9F87;
	Thu, 25 Jun 2026 18:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782412073; cv=none; b=G68LA2ZRyNeDiZocObsAgAsx8HM+2rVO9nmijFpCPSx/nEiQUIj20+8VHyxJPLMHx49gVnO/Jmag3DeyMklZ0kPT6K9s3i5SHeACapRDUL5XqNbX8HcDN69fDydDh+ehSmzy4SS09x7Gh797Uxz5Dewbu1LFiU6NYePwWdphnSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782412073; c=relaxed/simple;
	bh=uOdPRX3oza1b6QrDye/QNTSahAe9gj67JkrvckiJFUw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NaYH+hDjW+seU1W10PVPWC1yoXt2xdddY6PRgGqVp+USVYUsFw0TtETpYObnH0+OJcBl2WVbBmhuLaMZqZicrUWVXn2GVcfFBawOSbsB2xgfG+2zdq5bKTKvUiBx6g9NeslCAG7mEx/lN02ZLx+MqrDp9SKAwUEq7geEwYfl5gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBuQM0mL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBuQM0mL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B721F000E9;
	Thu, 25 Jun 2026 18:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782412071;
	bh=TcAGM1tSTqXo/WYqugfLXETNXMMn++oUzvlC0NlO8ZE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EBuQM0mLJEqgemZeSa4PMnXw/N5jZPsYHB/q7ZWV8erVDDDPly8lwA7jxMpaMYaVW
	 PhAzgYmPKUmrPZZBuAe9x/ieGhXtPT00gcD5WXsUGgkT2H87WJmhjUxMPHXpGjRfJO
	 mI5Y/Io22rxj3O47g0TL1rQvUh2np4IzXUktij/V2I6WxDw3gf0KbjEquYkv6OaUZ+
	 BtAVtCDqBrzD/AO0s69NFW7/njXxv6WuVup3tb8QZHvcAaQVI1PbE21Gq24/Iv0U+7
	 mpybB+WCqA9qrWNKFf/wYQ1yLzOkkSTBOmE0+ub8pDZYszoo+FwNtybJ8SxXq39tlb
	 CrcXDAIDPrmMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 23/31] dax/bus: Factor out dev dax resize logic
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-24-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-24-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:27:50 +0000
Message-Id: <20260625182751.64B721F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Integer overflow in __dev_dax_resize causes >2GB allocations to be=
 treated as errors, leaking DAX resources on 32-bit systems.
--

commit abac505d7b066ca0edac0e8d7df59c037cc29e89
Author: Ira Weiny <iweiny@kernel.org>

dax/bus: Factor out dev dax resize logic

This commit factors out the device dax resize logic to prepare for dynamic
capacity regions. It introduces a helper function that allocates ranges
using a specified parent resource, returning the successfully allocated siz=
e.

> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 95683dc8fcd0c..ffa6b303fc9bd 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
[ ... ]
> +static ssize_t dev_dax_resize_static(struct resource *parent,
> +				     struct dev_dax *dev_dax,
> +				     resource_size_t to_alloc)
>  {
>  	struct resource *res, *first;
>  	int rc;
> =20
> +	first =3D parent->child;
> +	if (!first) {
> +		rc =3D alloc_dev_dax_range(parent, dev_dax,
> +					   parent->start, to_alloc, NULL);
> +		if (rc)
> +			return rc;
> +		return to_alloc;
> +	}
> =20
>  	for (res =3D first; res; res =3D res->sibling) {
>  		struct resource *next =3D res->sibling;
> +		resource_size_t alloc;
> =20
>  		/* space at the beginning of the region */
> +		if (res =3D=3D first && res->start > parent->start) {
> +			alloc =3D min(res->start - parent->start, to_alloc);
> +			rc =3D alloc_dev_dax_range(parent, dev_dax,
> +						 parent->start, alloc, NULL);
> +			if (rc)
> +				return rc;
> +			return alloc;

[Severity: High]
On 32-bit systems where ssize_t is a 32-bit signed integer and
resource_size_t can be an unsigned 64-bit value, does returning a 2GB or
larger alloc size cause an integer overflow?

If alloc is >=3D 2GB, returning it as ssize_t could wrap to a negative numb=
er
or zero if truncated from a larger type.

[ ... ]
> +static ssize_t dev_dax_resize(struct dax_region *dax_region,
> +		struct dev_dax *dev_dax, resource_size_t size)
> +{
[ ... ]
> +retry:
> +	alloc =3D dev_dax_resize_static(&dax_region->res, dev_dax, to_alloc);
> +	if (alloc < 0)
> +		return alloc;

[Severity: High]
If a large allocation overflows into a negative ssize_t, wouldn't this call=
er
evaluate alloc < 0 as true and mistakenly treat the successful allocation as
an error?

Because the successfully mapped chunk was already added to dev_dax->ranges =
in
dev_dax_resize_static(), aborting the resize here without unwinding the new=
ly
allocated range seems like it would permanently leak the DAX space and leave
the region in an inconsistent state.

> +	if (alloc =3D=3D 0)
> +		return -ENOSPC;
>  	to_alloc -=3D alloc;
>  	if (to_alloc)
>  		goto retry;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D23
