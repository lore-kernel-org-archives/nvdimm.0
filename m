Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7D41FF1DA
	for <nvdimm@lists.linux.dev>; Wed, 14 Oct 2026 02:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791944470; cv=none; b=WSnZXxhf5GJmRwWpWWnM6EnxWxHBffwgXOku23Z6bZEybEpYEPPyFCVhz413pP36FnKM6KUQtmAfQoV8jIzCulPpiAWMIg0ZOcftwQ7KquDOlnet722UjMNjyBQ7dzg7J2zCOEwwQ2jOnGWLPBj/t9DqoPngmm+hnR2IR8ZpThk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791944470; c=relaxed/simple;
	bh=b3dyevacl/cbCp0uCWiC6GHkpQpmGiBcssV4giNKLj4=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=NswYOL2VekJew2p+PeEceRsoJCDaaRvvsb8NbM4zTxIJ0gop4i+uxm/uEy1H0dW4yCJ14fmXYGcZo1N2S4KQndVET9ZITRrcXnfioLW2jhRyx2PuulplBByBjO5WkuNBwNNaL2VXRhzVsPEOZ7I74zfJj+G0sr95rimiTPNVI7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VkNsYBhz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VkNsYBhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2681F000FF;
	Wed, 14 Oct 2026 02:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791944468;
	bh=vfwTErDtGqbEWnYiaXYBDva3rTKZjeDHF7LUsBXF7Vo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=VkNsYBhznSKZe+c7iMGJzHTmGf0Kj3hykGtagL+eICcsT8yL1BZ+NAalaU+npM6tJ
	 4rWDm+gn8XUgRbLZFPqw7XYqOQUw8w6TL7oFqN/fochtQuMPkJGGyXmwhozJUWEwo4
	 gOTlV0LuFJ0Q8L9lzTnP7wTFT87YRa5kSuyuUL1aDY+SU4FV2vJ71Hk02XpVG997sP
	 Gt2XFyiMmfCALt2Nely3oWoHFptFPANunIDw78YY8k243j88hc+7kCEBfGya5kmm9h
	 HWz+uQf9hV8MjqskojBUgKNGZG/dMS+mBT+EiiLCcsh1/jDxyY2GO5eivDwz2E6Zqt
	 5CkWLfjce5w/g==
Message-ID: <sashiko-outbox-170688@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] drivers: nvdimm: validate dataoffset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shyam Saini" <shyamsaini@linux.microsoft.com>, nvdimm@lists.linux.dev
In-Reply-To: <20261014020430.295282-1-shyamsaini@linux.microsoft.com>
References: <20261014020430.295282-1-shyamsaini@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 02:21:08 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] nvdimm: false rejection of valid PMEM namespaces due to hardcoded =
MAX_STRUCT_PAGE_SIZE
- [High] nvdimm: offset validation ignores memremap_compat_align()
--

commit eb5279626b7f080ae471e489ece4609d9d792c1b
Author: Shyam Saini <shyamsaini@linux.microsoft.com>

drivers: nvdimm: validate dataoffset

This commit adds a dataoffset validation to prevent probing failures caused
by stale superblocks after a cold reboot where DRAM is not zeroed. It checks
for a mismatch between the preserved superblock dataoffset and the resource=
's
dataoffset, rejecting mismatched ones.

> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 8fa9c16aba7ea..667115ce88e40 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
[ ... ]
> @@ -577,6 +577,12 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const cha=
r *sig)
>  	nsio =3D to_nd_namespace_io(&ndns->dev);
>  	res =3D &nsio->res;
>  	res_size =3D resource_size(res);
> +	res_start =3D res->start;
> +	npfns =3D PHYS_PFN(res_size - SZ_8K);
> +	offset_res =3D ALIGN(res_start + SZ_8K + (MAX_STRUCT_PAGE_SIZE * npfns)=
, align) - res_start;
> +	if ((mode =3D=3D PFN_MODE_PMEM) && offset_res !=3D offset)
> +		return -ENODEV;
> +

[Severity: High]
Does this code falsely reject valid PMEM namespaces that were created with a
custom struct page size or on architectures with a larger alignment?

The offset_res calculation hardcodes MAX_STRUCT_PAGE_SIZE instead of using
the superblock's recorded page_struct_size.

If the namespace was initialized with a larger struct page size (for exampl=
e,
with KMSAN where sizeof(struct page) > 64), offset_res will be calculated as
smaller than the actual stored offset.

Additionally, the original offset calculation during namespace creation in
nd_pfn_init() uses max(nd_pfn->align, memremap_compat_align()):

drivers/nvdimm/pfn_devs.c:nd_pfn_init() {
    ...
    align =3D max(nd_pfn->align, memremap_compat_align());
    ...
}

Because the recalculation here uses only 'align' without considering
memremap_compat_align(), could it cause a mismatch on architectures where
memremap_compat_align() is larger than nd_pfn->align (like PowerPC with 64K
pages, where memremap_compat_align() is 16MB)?

Will this mismatch check incorrectly evaluate to true for these valid PMEM
namespaces and fail to probe them?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014020430.2952=
82-1-shyamsaini@linux.microsoft.com?part=3D1
