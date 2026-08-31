Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A263A5422
	for <nvdimm@lists.linux.dev>; Mon, 31 Aug 2026 04:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788151510; cv=none; b=kT+uSzQCul3Zd2azDMBhXgIB1YhWg/FP3iK6BEWtjopgTvJpThOLsFRS0Cbm9XW91h2SVe2++vdYxYeB8eEuv/9eQas6WZ2yFgUXRQW0ejyiBXZSv2jOiZLTb7GyDeqU6epdKln5yP9gxnmk5lkwTILYJWuwYWOWuep8ihBdSN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788151510; c=relaxed/simple;
	bh=oaLFWpTj/gOpqhv5InuGbi8CPPPXX2EBh2XxEiUmR9E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=U8vSnsAeXUdxIakzea031mabfpq1FTK7QfYKVTJaxwc7XCeGarsaxNta0lFf1ykCSBr8D1o7GD26ep+k7mb/Z9wQRbp8nt4yzs1ufrlFUMKZDvx5f2AIAGEwE7LnL0dLCD7Y03TjbY7EdcexHAxNy1ELH/RJjs2GZxJ7EsH2dCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmVQdcd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmVQdcd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520351F000E9;
	Mon, 31 Aug 2026 04:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788151508;
	bh=VbrB1/KDIkScb4FG8bNdK3AaQSdd/mbqM8ATsyztXh0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hmVQdcd5vWvqVWEPh2JmnqT5n378ifqS+zDEFxOF8M36yRhcl5KECFkBYpD7U8nsl
	 6FXfwOdkFbUhCbqrx/JJZM8rIGCjbYB3mF0upFly4qTtU1a+z9x3+zCD3/5hTzWh0T
	 1KAoTBXvBdtJaky7WiblDJhg7rv1tQOmLlvNGbycJlsLfcdThCV5Jo3G6iF8V8He2Q
	 jW4URcBkTh19qrD/hCoqM7m/yEPXlU393aMsE2E+c1AEOrNj/R2xjhz6owQnVIr2RU
	 RzBJKEfNQ/LbElKwNrSUCUeizISwf0p2xxo1xCMTWoGknTSGeLszn/7QYKo6yf5YDg
	 +oQBaohfS/oUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] nvdimm/pmem: Release gendisk on probe failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hemanth Selam" <hemanth.selam@gmail.com>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260831043459.1298059-1-hemanth.selam@gmail.com>
References: <20260831043459.1298059-1-hemanth.selam@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 04:45:07 +0000
Message-Id: <20260831044508.520351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] NULL pointer dereference in sysfs attributes (write_cache) when al=
loc_dax() fails with -EOPNOTSUPP
--

commit b72cbfedec624805721d1461cccfb6dbba985b5b
Author: Hemanth Selam <hemanth.selam@gmail.com>

nvdimm/pmem: Release gendisk on probe failure

This commit fixes a memory leak in the pmem namespace probe by ensuring
the gendisk is properly released through the common cleanup path if
devm_init_badblocks() fails.

> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 30a51c365ce8b..648fc7d660639 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -563,8 +563,10 @@ static int pmem_attach_disk(struct device *dev,
>  	nvdimm_namespace_disk_name(ndns, disk->disk_name);
>  	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
>  			/ 512);
> -	if (devm_init_badblocks(dev, &pmem->bb))
> -		return -ENOMEM;
> +	if (devm_init_badblocks(dev, &pmem->bb)) {
> +		rc =3D -ENOMEM;
> +		goto out;
> +	}
>  	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
>  	disk->bb =3D &pmem->bb;

[Severity: High]
This isn't a bug introduced by this patch, but I wanted to ask about the er=
ror
handling for alloc_dax() just below this code.

In pmem_attach_disk(), if alloc_dax() fails with -EOPNOTSUPP, the code
gracefully falls back and leaves pmem->dax_dev as NULL:

	dax_dev =3D alloc_dax(pmem, &pmem_dax_ops);
	if (IS_ERR(dax_dev)) {
		rc =3D PTR_ERR(dax_dev);
		if (rc !=3D -EOPNOTSUPP)
			goto out;
	} else {
		...
	}
	rc =3D device_add_disk(dev, disk, pmem_attribute_groups);

However, the write_cache sysfs attribute remains unconditionally visible as=
 long
as CONFIG_ARCH_HAS_PMEM_API is enabled.

If a user reads this attribute, write_cache_show() will pass the NULL
pmem->dax_dev to dax_write_cache_enabled():

static ssize_t write_cache_show(struct device *dev,
		struct device_attribute *attr, char *buf)
{
	struct pmem_device *pmem =3D dev_to_disk(dev)->private_data;

	return sprintf(buf, "%d\n", !!dax_write_cache_enabled(pmem->dax_dev));
}

Similarly, write_cache_store() passes it to dax_write_cache():

static ssize_t write_cache_store(struct device *dev,
		struct device_attribute *attr, const char *buf, size_t len)
{
	...
	dax_write_cache(pmem->dax_dev, write_cache);
	return len;
}

Since dax_write_cache_enabled() (in drivers/dax/super.c) and dax_write_cach=
e()
blindly dereference the pointer, won't this cause a NULL pointer dereference
leading to a kernel panic if the attribute is accessed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831043459.1298=
059-1-hemanth.selam@gmail.com?part=3D1
