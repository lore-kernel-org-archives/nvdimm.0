Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8137309F09;
	Thu, 25 Jun 2026 18:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411164; cv=none; b=hBldGOiBGtHd5fPLv4eWCHE3wJqRYPHNIBf2ovRZzsfwwQ4ZiO2EFVqpkrH/J2AMNUDygGKaBiuW/vmQj8tkz/J5DfqaByhZ93v3u+F7AcIVag0SI2MxOITrY9BlvBRLBVApfkgn9CPp9K0f3uj/tJtA8jmwqSGp30Dx15Xy8h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411164; c=relaxed/simple;
	bh=U6b62cFNIsGzEFbN80WEixeQ+8XlxtlKDv3WbHkDIa0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mdsXR7kDW1zD8JC9Wi1BXQ2X2mhFtiEhkvOIRFXaON8jIDT+RiCT5EMUOUz+Y1FdpASIGJw2bvceLsWiUcmddbabCl6b3IpUA+EVFkhzIAr20jZJ4nGCpKFEoJVxr7UL7G3qexfP40lQCc3JRU/n7nm59oVm0hR1voizDMzpUUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UcaC+/10; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UcaC+/10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F581F000E9;
	Thu, 25 Jun 2026 18:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411163;
	bh=3/JB8MwUd47sy49dG6LAaZbwGzDUAMlqjEbBcWaLrG4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UcaC+/10T6F5PFB+Fr0KakO7Zlmf0kbpcyP8KZDGVC9/2zRCtrhad/HQZ2Ayi8vNi
	 V6C7+PeihpNRN8OKPng1reCzwvg6gPtmqkyJSG/61hfZM2A7A+V1n6ekJ+3hp4Mnzi
	 dvjOw8HPFVzSNPhKKykRiFU8L0BSbwYZtcSe5oEvoScu7umZY59VgfV5yMN6Pa1BPB
	 o0cZBOk8bpWGJFCjFC94KAqFd7hSxL6Y5SQYt8SNhxIB4RP7IXWe5qpoIfUASXo9V6
	 FWurjCGi7VgVCh4rCEz6Zz1MiUYNNgf/7xcxhIlfsS+eP2SvCkK8G3/J2/14kKaj65
	 kc5IR4x9XxXVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 05/31] cxl/mem: Expose dynamic ram 1 partition in
 sysfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-6-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-6-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:12:42 +0000
Message-Id: <20260625181243.77F581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Empty sysfs directory created for absent dynamic RAM partitions.
--

commit 839299dd9514d54314e661cd789de765da08d4f4
Author: Ira Weiny <iweiny@kernel.org>

cxl/mem: Expose dynamic ram 1 partition in sysfs

This commit exposes the details of the first dynamic ram partition via
sysfs so user space can properly configure CXL regions.

> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c

[ ... ]

> @@ -519,6 +551,29 @@ static struct attribute_group cxl_memdev_pmem_attrib=
ute_group =3D {
>  	.is_visible =3D cxl_pmem_visible,
>  };
> =20
> +static umode_t cxl_dynamic_ram_1_visible(struct kobject *kobj, struct at=
tribute *a, int n)
> +{
> +	struct device *dev =3D kobj_to_dev(kobj);
> +	struct cxl_memdev *cxlmd =3D to_cxl_memdev(dev);
> +	struct cxl_dpa_perf *perf =3D part_perf(cxlmd->cxlds, CXL_PARTMODE_DYNA=
MIC_RAM_1);
> +
> +	if (a =3D=3D &dev_attr_dynamic_ram_1_qos_class.attr &&
> +	    (!perf || perf->qos_class =3D=3D CXL_QOS_CLASS_INVALID))
> +		return 0;
> +
> +	if (a =3D=3D &dev_attr_dynamic_ram_1_size.attr &&
> +	    (!cxl_part_size(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_1)))
> +		return 0;

[Severity: Low]
Should cxl_dynamic_ram_1_visible() return SYSFS_GROUP_INVISIBLE here when t=
he
dynamic RAM partition is absent?

Since cxl_memdev_dynamic_ram_1_attribute_group is a named group
(.name =3D "dynamic_ram_1"), returning 0 hides the individual attributes but
still creates the group directory.

Won't this result in a permanently empty "dynamic_ram_1" directory in sysfs=
 if
the size is 0, rather than suppressing the directory entirely?

> +
> +	return a->mode;
> +}
> +
> +static struct attribute_group cxl_memdev_dynamic_ram_1_attribute_group =
=3D {
> +	.name =3D "dynamic_ram_1",
> +	.attrs =3D cxl_memdev_dynamic_ram_1_attributes,
> +	.is_visible =3D cxl_dynamic_ram_1_visible,
> +};

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D5
