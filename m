Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEFA2E8B64;
	Fri, 31 Jul 2026 09:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785488483; cv=none; b=Dd1q7RhqxF+6JYBfm4K5cG7KcuLm3QeJQadUOD8QDv1clq76cwDhvfUwWI+zedKld/IblxgE9fh+jqI/veU3Udoo3brju+b7uLdBvlzVdkV1wg4rKLA+3pq/JnDk3IbKeQoYdr8qqPNo5p8fxs9ykNNPnRGg9HPJU38GQxrZODw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785488483; c=relaxed/simple;
	bh=X7hVp6Ts+bKSVNpjQF5tdUv0bWX9IxJIaK8ulS7XZE8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qjbW/MGH5O+MOLs11nQN8OFOTCFqOYeNJ0T1PSYQO9jj4KTN1OwPgU+OWuybEx9ciwVxG4HBWrFOMDoC2RhXUzXKGk5kZONu18dNDpEIaXT1ACXbYD859tcuutPsbAQAhaFU5mTEA2JlIawDH2QC5CMf8EJlz0T6fxGkcKqgPhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSjde40l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSjde40l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E07D1F00A3A;
	Fri, 31 Jul 2026 09:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785488482;
	bh=JMpd4N6eXdkz5ZSUtXPjBX45iCldNA54oF3VOhkSp/E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XSjde40ll15WXzkwGaQoaS68035TnaA5jgwLqEOABmif/PMFClG8d02bLqX7b1tme
	 XFbBrZDQKpuIGp5Z+h3GBoSmrfg/knJc6ukKm1x7fdpm/Zz8C+Tnrbg6B94fNZIqo7
	 InpPaU4kY7K0rxEkmeTN/9MRPEzqVyQDI5S5ZVplAAKM8uc3/LhbFMOavboe6cJSmX
	 kFmfYb42naTu2Lrtwtqwp6l9I3w7RLF3IgllVjIRMt9F7QpJgnTNe90+i9JlcbRI44
	 8jwV9H126QykoRd5KVql2tyavJyL8ZYZoIVFTNnu+ZJgT8llNkpQKXAibQQRw9FSOj
	 06/SvWXk936uA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 7/8] cxl/core: Return endpoint decoder information
 from region search
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260731084901.1512819-8-anisa.su@samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-8-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 09:01:21 +0000
Message-Id: <20260731090122.1E07D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `cxled` out-parameter is left uninitialized on early return =
paths in `cxl_dpa_to_region` and its inline stub, creating a vulnerability =
for uninitialized variable usage.
--

--- Patch [7]: [PATCH v12 7/8] cxl/core: Return endpoint decoder informatio=
n from region search ---
commit c2b37a56d99a44aee4d4340c7154d9180c620839
Author: Ira Weiny <iweiny@kernel.org>

cxl/core: Return endpoint decoder information from region search

This commit updates cxl_dpa_to_region() to return the endpoint decoder
found during the region search via a new out-parameter. This information
is needed for dynamic capacity extent processing to calculate HPA offsets.

> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 07555ae638594..e4bd220faa92c 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
[ ... ]
> @@ -61,7 +62,8 @@ static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxl=
r,
>  	return ULLONG_MAX;
>  }
>  static inline
> -struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64=
 dpa)
> +struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64=
 dpa,
> +				     struct cxl_endpoint_decoder **cxled)
>  {
>  	return NULL;
>  }

[Severity: Medium]
If a future caller passes an uninitialized pointer variable for cxled, will
this static inline stub leave it uninitialized?

Could we set "*cxled =3D NULL" here when cxled is provided, to prevent call=
ers
from evaluating stack garbage on return?

> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 1e211542b6b64..ec5e5b7090cf2 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
[ ... ]
> @@ -3045,11 +3046,13 @@ static int __cxl_dpa_to_region(struct device *dev=
, void *arg)
>  			dev_name(dev));
> =20
>  	ctx->cxlr =3D cxlr;
> +	ctx->cxled =3D cxled;
> =20
>  	return 1;
>  }
> =20
> -struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64=
 dpa)
> +struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64=
 dpa,
> +				     struct cxl_endpoint_decoder **cxled)
>  {
>  	struct cxl_dpa_to_region_context ctx;
>  	struct cxl_port *port =3D cxlmd->endpoint;

[Severity: Medium]
Similar to the inline stub above, cxl_dpa_to_region() has an early return
path right after these variable declarations:

    if (!cxlmd->dev.driver)
        return NULL;

If a caller doesn't pre-initialize their cxled variable and hits this early
return, won't cxled remain uninitialized?

While current callers in this patch pass NULL, a future caller expecting
cxled to be populated might evaluate uninitialized stack memory. Should this
early return also initialize *cxled to NULL if cxled is provided?

> @@ -3063,6 +3066,9 @@ struct cxl_region *cxl_dpa_to_region(const struct c=
xl_memdev *cxlmd, u64 dpa)
>  	if (cxl_num_decoders_committed(port))
>  		device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);
> =20
> +	if (cxled)
> +		*cxled =3D ctx.cxled;
> +
>  	return ctx.cxlr;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731084901.1512=
819-1-anisa.su@samsung.com?part=3D7
