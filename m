Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793834253;
	b=G312WyeIeorx9ewupm1f4wngfytzqcQdLqVikdgBYaEMUocaYKI34FF4WC/o8K8AcpH1
	 ykQkEOn+LoVTVcrEWVqgV5DydOA9jBsxgIUyXIBY3QNj2oLjj9AZ719ry6mt6syWXNb6S
	 de1v0Vnbbxls4dmecxA6cwmefh3gneR/7Ftw+AMZFRfQ2wZUibbAQB3nOajgUpjLe1Kll
	 2wON1inpjHOBmXHA3XNV/9+6zXCHe3gwpeACHKIQ6+JVo/4AlcmpPIxwnm48ts0iLU00d
	 KnMHmVsodCAsjUkOYC8D0Ywg2MVdjC7z0PU+gozKKJ7D4KaURhw7fNOikbm6GlJGXMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793834253;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3qw+3BuVIl6+qVxhTIIwTjP4c+L/02Ut/aNZ80aD9VQ=;
	b=I/lypyChrmgMWfmr62I/FfGq7qDBlUEJuHL4vTZKO81DCaXCWiyDbTUPJHVe1OZ3CuX/
	 FnOufmUBfeUITm1Illa4fHTOdJ5uhH5YnOLjqn8XMvmoPo4h+/4qMJCO4wtTK7SY1TjaL
	 mVp7hPkD3MVlzkLxmWqG9lLL1800z2pQM/yo4eVbTdPUyF1t4NBziLWXrGaclWdF7JepA
	 PZRWNSHHvq3uxnhWL1KJ/rRxjVJPk8gpyPQnv+8OVl/UnYCwOpS2HgwZGcfqddx5GnU+k
	 r8EFlkN6/Ml8hsiEaxVJuR5Y8T010/FNk0VxSgO0awQGqbJQX29Pe6rLco5GlS+gh5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MHEL8hdj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC201606A31B;
	Wed,  4 Nov 2026 23:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MHEL8hdj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC0B1F000C1;
	Wed,  4 Nov 2026 23:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793834252;
	bh=3qw+3BuVIl6+qVxhTIIwTjP4c+L/02Ut/aNZ80aD9VQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MHEL8hdjMjaEGtfwUesTbliqfbzatFiD8InqVfRbYJSGCAUulOR21SlF+wEWFxjil
	 5u+62VhynMfJ4PWs7wxLwoKLXSRUi4/G0LyQoJxkomwJgCl5oTizu+Oi2krWJ/Xly5
	 m8CbR/J+HRIMVO2/i6jy12cCfb1+/teIxOLPFygbEoW/2NQj1ikBmzmIO9OETtBliL
	 C6WiPx7qbn67Rd+tOCcmjnUCRu7fMEHupdjjleNIVh+exxga4DKJT0piwe9hoqxsO5
	 Tn/fjafTlhQhrNh/gbWxbTi9csYcdGNXiL/dpRDEGV+BvkESzZJ84QebH1ZJWMQgJM
	 AGaB9NfBdbaVg==
Message-ID: <sashiko-outbox-198287@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 10/14] cxl/extent: Enforce cross-region tag
 uniqueness
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20261104230445.66625-11-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
 <20261104230445.66625-11-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 23:17:31 +0000
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
- [High] cxl/extent: same-chain tag group can span multiple regions in cxlr=
_add_extent()
--

commit dccf3410f0df24895d72657ec87c46291cc4a6bc
Author: Anisa Su <anisa.su887@gmail.com>

cxl/extent: Enforce cross-region tag uniqueness

This commit adds a host-wide registry of live non-null tag groups protected
by cxl_tag_lock to enforce tag UUID uniqueness across regions and memdevs.
During group validation, cxl_tag_already_committed() rejects groups whose t=
ag
UUID is already registered with -EEXIST.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index a1d3e04a1e1b4..0fa501f5800c9 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1640,6 +1640,22 @@ static int cxl_validate_group(struct cxl_memdev_st=
ate *mds, const uuid_t *tag,
>  	struct device *dev =3D mds->cxlds.dev;
>  	struct cxl_extent_list_node *pos;
> =20
> +	/*
> +	 * Cross-More-chain uniqueness.  A non-null tag seen in this group must
> +	 * not already correspond to a committed tag group anywhere on this
> +	 * host.  More=3D0 was supposed to close that allocation, and tag uuids
> +	 * must be unique across all regions and memdevs (the orchestrator owns
> +	 * assignment per spec).  Either constraint failing =E2=80=94 same chain
> +	 * redelivered, or two distinct allocations colliding on the same uuid =
=E2=80=94
> +	 * is a firmware/orchestrator bug; reject the whole group.
> +	 */
> +	if (cxl_tag_already_committed(tag)) {
> +		dev_warn_ratelimited(dev,
> +				     "Tag %pUb: dropping group, tag already committed (firmware/orch=
estrator bug)\n",
> +				     tag);
> +		return -EEXIST;
> +	}

[Severity: High]
Can a single More-chain still create a tag group that spans multiple region=
s?

A single DC partition on a memdev can be decoded by multiple endpoint
decoders attached to different regions (for example cxlr_dax0 and cxlr_dax1)
by selecting the same DC partition mode via cxl_dpa_set_part() and allocati=
ng
disjoint DPA ranges from the partition resource via cxl_dpa_alloc().

If a DCD Add Capacity More-chain arrives with two extents sharing the same
non-null tag UUID whose DPAs fall into cxled0 (in cxlr_dax0) and cxled1 (in
cxlr_dax1) on that same DC partition:

1. In cxl_add_pending(), extract_tag_group() groups both extents together.

2. In cxl_validate_group(), cxl_tag_already_committed(tag) returns false
because the group has not been allocated or registered in cxl_tag_groups ye=
t,
and cxl_check_group_partition() returns 0 because both extents resolve to t=
he
same struct cxl_dpa_partition.

3. In cxl_realize_group() -> cxl_add_extent() -> cxlr_add_extent(), the fir=
st
extent allocates the tag group on cxlr_dax0 and registers the UUID, while t=
he
second extent resolves to cxlr_dax1 and dc_extent_build() computes
dc_extent->hpa_range relative to cxlr_dax1->hpa_range.start.

4. When cxlr_add_extent() is called for the second extent, it only checks
uuid_equal() and does not check whether (*group)->cxlr_dax matches cxlr_dax:

drivers/cxl/core/extent.c:cxlr_add_extent() {
	if (*group && !uuid_equal(&(*group)->uuid, &dc_extent->uuid)) {
		kfree(dc_extent);
		return -EINVAL;
	}

	if (!*group) {
		dev_dbg(&cxlr_dax->dev, "Alloc new tag group\n");
		*group =3D alloc_tag_group(cxlr_dax, &dc_extent->uuid);
		...
	} else {
		dev_dbg(&cxlr_dax->dev, "Append dc_extent to tag group\n");
	}
}

As a result, online_tag_group() inserts the second extent into
cxlr_dax0->dc_extents with an HPA offset computed from cxlr_dax1, and only
pins and registers dc_tag_group_teardown on cxlr_dax0->dev. If cxlr_dax1 and
cxled1 are later torn down while cxlr_dax0 remains active, the second
dc_extent is not torn down and retains a dangling dc_extent->cxled pointer.

Should cxlr_add_extent() (or cxl_validate_group()) also verify that all
extents in the group resolve to the same cxlr_dax region?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104230445.6662=
5-1-anisa.su@samsung.com?part=3D10
