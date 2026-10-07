Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFEB1D5ADE;
	Wed,  7 Oct 2026 20:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791404977; cv=none; b=Vg2W+0SsTJtXseE9wH/OjeMOAQvkn1q1b4lxdz+TQTJUfh2CYholygVvhh0Q5nR8n9XnYHDYn2tT4Rl7jp5kXMw3ccfrqN9r8VbCcf2+/REJHt6mghO3QLjtNqIiC9Y0/4vm9knnU6neJW09YkuFpgjdXXRCP+bdNnyZQVNDpq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791404977; c=relaxed/simple;
	bh=WfBwoTBLBppt6L/PI59EVzTP7xa/9tt5uHSFGFdQQxA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BLfRgKQk0DqiT4tOayiijqZMNyrVWaWu7slX3EeVWCgEaaYVqeAViwRkCNYwgtRkcivxrUsnOzUBlAv/4d3b98Xg4Ri1J17AoKOW6k7m1dpz5qOPaYaUYlOFydwE7wp6QpTq3QTQHLbAw2voU0z3lRfCz+yLrwvIj14cXl5Uans=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ENMdOo5x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ENMdOo5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4495F1F000FF;
	Wed,  7 Oct 2026 20:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791404975;
	bh=Ak5g+Y6kdfUlTeUUSleeOagbz8cvMkqirnTwHKgsv+Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ENMdOo5xjNn1x/XeCTBo90/1eZ9vcVMwS6AwRjXt9gERJBu8M04wT4hkx6EatSKo5
	 /rNyXDiJBy0dI99LSwfXoR35U7xW3ZJZ7lktxoE3AT4erIY8jf6HYSb+miGLyvLIjl
	 gwkf3sAs3Ii5YEy6ZosOqTsNlGOuqGZVvOTvvCk5k8CtL/BrM1qi6oX2/pc4F4DceW
	 dK+aznyOeAps7EKrizZ/7zP3n4a+NSIiP1BvygoLOXjdXCNV0L+8OHkom24Btdjstq
	 YJSaZMGgcMFDRABBhKCJsfq6V0DD3zsPHsGvvD9hRw65blNidCnSB/P6RyodJRDaa4
	 LfhXAICgz+tKw==
Message-ID: <sashiko-outbox-163339@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v15 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20261007201828.952-3-anisa.su@samsung.com>
References: <20261007201828.952-1-anisa.su@samsung.com>
 <20261007201828.952-3-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 20:29:34 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] cxl: cxl_configure_dcd() falsely fails overlap check and double-co=
unts total DPA capacity
--

commit e491a6175f0241ed507a397807a28860fd54aadf
Author: Ira Weiny <iweiny@kernel.org>

cxl/mem: Read dynamic capacity configuration from the device

This commit implements Dynamic Capacity (DC) mailbox commands to read and
store DCD configuration information. It validates the first dynamic capacity
partition and configures it as dynamic ram, disabling DCD if the
configuration is invalid.

> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index b3419df586b9c..def26c490dfe4 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
[ ... ]
> @@ -643,6 +643,53 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, =
struct cxl_dpa_info *info)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_mem_dpa_fetch, "CXL");
> =20
> +int cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info =
*info)
> +{
[ ... ]
> +	if (dc_info.start < info->size) {
> +		dev_err(dev,
> +			"DC partition 0 base %#llx overlaps static capacity ending at %#llx\n=
",
> +			dc_info.start, info->size);
> +		return -EINVAL;
> +	}

[Severity: High]
Will this overlap check unconditionally fail for any valid DCD configuratio=
n?

Earlier in the execution flow, cxl_mem_dpa_fetch() initializes info->size to
the total DPA capacity (including both static and dynamic capacity):

    info->size =3D mds->total_bytes;

Since the DC partition is placed within this total space, dc_info.start will
always be strictly less than the total info->size. This appears to cause a
regression where cxl_pci_probe() silently disables DCD support.

[ ... ]
> +	if (check_add_overflow(info->size, dc_info.size, &total)) {
> +		dev_err(dev,
> +			"DC partition 0 size %#llx overflows DPA space ending at %#llx\n",
> +			dc_info.size, info->size);
> +		return -EINVAL;
> +	}
> +
> +	info->size =3D total;

[Severity: High]
If the above overlap check were bypassed, would this assignment double-count
the dynamic capacity size?

Since info->size already includes the dynamic capacity initialized from
cxl_mem_dpa_fetch(), adding dc_info.size again to the total could cause
cxl_dpa_setup() to allocate a dpa_res root resource larger than the physical
device limit.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007201828.952-=
1-anisa.su@samsung.com?part=3D2
