Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793834500;
	b=qCSZE0S9EwDzQBSL8SyekFbY84qK9W5/hILnOzJQ5jHlLp99VLjBsX3GXKUiuzQEUmJl
	 IanpQT78pn7A2ixu1p+eNmm0K/BQi1DwoqO9ylinugVh2Yc8a3zK2eVCt7cFn5GnO3a6N
	 tZS94nXXi/iaW9o5/4h454n+W87NpMafjqN/MpqHJA59gso8TfkqlcYGCgCnZyM+dRjs3
	 Qn3gosZdTa6cosQYQ8Nb9CnSPZ3N/JnwJwxwmhWetAquTG1bPx0E3H7aAPFkKJqhys7oO
	 0sB34mUNPd+l78fAFnG5zuhwKyUpCcTB0LI3N+md4NxTsyctrmBI0acR/HfHpc0cvGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793834500;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QFl2W1Z0ZutwztxTaREi/6UBQZDCfpjXpZyL6h4Em7E=;
	b=dMUPAf7lbuu+qRX2np8EySO/VbFOMdSS1cE94ziVqwxsv92M7+nEBUysN0sWARHzT3fx
	 1SpezCHRtCnCiZWO/Yrop75gQYDIdpwboJh6uNiIBJuo4rE4csq42cWASerIhjaWfh5tU
	 qoyLxRRAvRCFgZJbU+N4w2hY7mk4dgI0BeoYIK1Iaz+ZglZpTAHnzcA80lKJzP+HKGZcS
	 SOLO5oJEdZLt6tJC2DAfV1Sca4+WwYY7fT1pH7Q+bgGRKGyQGusuRxP1GEHkRjU9eefc6
	 VXX3UqShI9ja7gvd1N9U7uTPdRMXSxz1OQNdmr7Zoo3X2z4gz10IR13lBKrp/gfpWWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gtf9C2wr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72827606A31B;
	Wed,  4 Nov 2026 23:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gtf9C2wr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A541F000C1;
	Wed,  4 Nov 2026 23:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793834500;
	bh=QFl2W1Z0ZutwztxTaREi/6UBQZDCfpjXpZyL6h4Em7E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gtf9C2wrwE/d4r4qtNHVcmMpYLs4UVqi7pOgmosu8RiriFfZmZplbFm3LTxtTzSFK
	 0FDTodzZiZpP7v7SWuvQrxkE54CvsIyh+bpdOxVCrQUubKV/gKNm/h0TnTiuMQkOqB
	 3DPrYM4NuVJyDrllvNiUAb3YKexML3ewE89rdvpJvaBupZYdueyRSdLouBf/2GiCBC
	 g/ayt4Px00tLXn6GJFrnVMzX9ghHI/J3uIynjQtl7cV0yupxc2FnefqBnPMTVUS63d
	 5zfzvI8VkuW1iM3LghnrX4e0ZQkIs87wm21zdIF5hDVy/ocVYHBPUJzNZ/A0o08F1S
	 mDC8zCe7G3c7A==
Message-ID: <sashiko-outbox-198290@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 03/14] cxl/region: Add dynamic DAX region support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20261104230445.66625-4-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
 <20261104230445.66625-4-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 23:21:39 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] cxl/region: missing cxled_dcd_enabled() check in cxl_region_atta=
ch()
--

commit fbb76db124dfcb143d519163ab21665f41cdcfa6
Author: Ira Weiny <iweiny@kernel.org>

cxl/region: Add dynamic DAX region support

This commit introduces dynamic DAX region support for CXL dynamic capacity
devices (DCD), tracking shareable and read-only partition properties on
CXL_PARTMODE_DYNAMIC_RAM regions and creating DAX regions with
IORESOURCE_DAX_DCD and a zero-sized seed device.

> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index f4a9839c73d2e..fc9139ce358fe 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c

[ ... ]

> @@ -2080,6 +2087,20 @@ static int cxl_region_attach(struct cxl_region *cx=
lr,
>  		return -EINVAL;
>  	}
> =20
> +	/* A DC region's flavor is fixed; every member partition must match */
> +	if (cxlr->mode =3D=3D CXL_PARTMODE_DYNAMIC_RAM) {
> +		struct cxl_dpa_partition *part =3D &cxlds->part[cxled->part];
> +
> +		if (part->shareable !=3D cxlr->shareable ||
> +		    part->read_only !=3D cxlr->read_only) {
> +			dev_dbg(&cxlr->dev, "%s: partition is %s, region is %s\n",
> +				dev_name(&cxled->cxld.dev),
> +				cxl_dc_mode_name(part->shareable, part->read_only),
> +				cxl_dc_mode_name(cxlr->shareable, cxlr->read_only));
> +			return -EINVAL;
> +		}
> +	}
> +
>  	/* all full of members, or interleave config not established? */
>  	if (p->state > CXL_CONFIG_INTERLEAVE_ACTIVE) {
>  		dev_dbg(&cxlr->dev, "region already active\n");
> @@ -2411,6 +2432,7 @@ static size_t store_targetN(struct cxl_region *cxlr=
, const char *buf, int pos,
>  	if (sysfs_streq(buf, "\n"))
>  		rc =3D detach_target(cxlr, pos);
>  	else {
> +		struct cxl_endpoint_decoder *cxled;
>  		struct device *dev;
> =20
>  		dev =3D bus_find_device_by_name(&cxl_bus_type, NULL, buf);
> @@ -2422,8 +2444,14 @@ static size_t store_targetN(struct cxl_region *cxl=
r, const char *buf, int pos,
>  			goto out;
>  		}
> =20
> -		rc =3D attach_target(cxlr, to_cxl_endpoint_decoder(dev), pos,
> -				   TASK_INTERRUPTIBLE);
> +		cxled =3D to_cxl_endpoint_decoder(dev);
> +		if (cxlr->mode =3D=3D CXL_PARTMODE_DYNAMIC_RAM &&
> +		    !cxled_dcd_enabled(cxled)) {
> +			dev_dbg(dev, "DCD not enabled\n");
> +			rc =3D -ENXIO;
> +			goto out;
> +		}
> +		rc =3D attach_target(cxlr, cxled, pos, TASK_INTERRUPTIBLE);
>  out:
>  		put_device(dev);
>  	}

[Severity: Medium]
Should the cxled_dcd_enabled(cxled) check live inside the
cxlr->mode =3D=3D CXL_PARTMODE_DYNAMIC_RAM block in cxl_region_attach() ins=
tead of
store_targetN()?

In the auto-discovery path, cxl_add_to_region() looks up an existing region
before calling construct_region():

drivers/cxl/core/region.c:cxl_add_to_region() {
	...
	struct cxl_region *cxlr __free(put_cxl_region) =3D
		cxl_find_region_by_range(cxlrd, &ctx.hpa_range);
	if (!cxlr)
		cxlr =3D construct_region(cxlrd, &ctx);

	rc =3D PTR_ERR_OR_ZERO(cxlr);
	if (rc)
		return rc;

	attach_target(cxlr, cxled, -1, TASK_UNINTERRUPTIBLE);
	...
}

When cxl_find_region_by_range() returns an existing region, construct_regio=
n()
is skipped and cxl_add_to_region() calls
attach_target() -> __attach_target() -> cxl_region_attach() directly.

For example, if an auto-discovered DC region has its endpoint detached (whe=
re
__cxl_decoder_detach() lowers p->state to CXL_CONFIG_INTERLEAVE_ACTIVE while
leaving cxlr registered under cxlrd) and DCD is not enabled when the endpoi=
nt
port rebinds, or if a second endpoint with DCD disabled matches a region
created by an earlier endpoint during multi-way auto-discovery,
cxl_add_to_region() will find the existing cxlr and attach and commit cxled
without checking cxled_dcd_enabled(cxled).

Checking !cxled_dcd_enabled(cxled) in cxl_region_attach() (alongside
construct_region()) would cover all target attachment paths under
cxl_rwsem.region and cxl_rwsem.dpa and avoid duplicating the check in
store_targetN().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104230445.6662=
5-1-anisa.su@samsung.com?part=3D3
