Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6975240DB40;
	Thu,  6 Aug 2026 08:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786005178; cv=none; b=bHBQCjaj2A1Dml8N8I+Hqa1JcqmdlF5rDECDTzFrpI1aQdzLuhY+LomlfX70dxmqa6Z8ZKZOWfBLCYFUg8cfElUxgoiqe7PNB/OhddSV1FhPJjyGAHc9epufB0JAlwZzO2rUAL/GASNVOzQTgwNma7z7IZFtpbi6Cgq58eF5pkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786005178; c=relaxed/simple;
	bh=wmJlW07JoXao1llO9slzyHXcYu0Y2sC7U9JgJDkYp30=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QEuoE9wRSLlAzv1MzLe4Tv4Cw2V3qGEuPVL7F2mRhrqdA3eL+F/ntkGuzIHV9R2GHR6V8yRkZFOfyyr7XA/7BzTVVuYR2CZf5liGJo0IZfXGltgbTUtNlJYIFGTZUbhBXS0+cYwB8J3WwDLZYz7iVStmfYY+9I6YcdlQMvp+N5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hxv94Scn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hxv94Scn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E39E1F00A3A;
	Thu,  6 Aug 2026 08:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786005171;
	bh=tfPwmKoWMMPQ+bHXkB6AuAEe3r9iGF29F3fSwX2Xbm8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hxv94ScnpffqwtMGGWMN34A5et28eO2Kz1+fct8TTzPSYfvvtDz+iOVOWai1E0977
	 cwDr/B4CBqvfEmAnDRReGkooyVJHDPUr9/bUzSZZy1TNBDvzZ1BeU5FWBW8Dza6ivd
	 nuyf3PbS0Q8LwpmzHvpVomom+fS27KXRvVbgG4lvs9Ew2Dds+/aHKCbQcJPonRK81t
	 OzvRlPkMK/dO1x4InHa1VMlsMbqKRxBWkkFqzpYLvkuIQ8PDqPVHb87LbU4u/WA8iX
	 n0IImZyujSqxD1qL+1wy7QKt9KD4XqDDWAvG5Rl9OCg9Zf2EiLyykT6EFjATksrd6v
	 0N+QrX7dkgXVQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] mm/memory-tiers: register CXL nodes to memory
 packages via initiator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rakie Kim" <rakie.kim@sk.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260806080936.421-4-rakie.kim@sk.com>
References: <20260806080936.421-1-rakie.kim@sk.com>
 <20260806080936.421-4-rakie.kim@sk.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 08:32:50 +0000
Message-Id: <20260806083251.4E39E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] `cxl_region_find_nearest_node()` incorrectly uses `p->nr_targets` =
as an upper bound and assumes a dense array, causing a NULL pointer derefer=
ence when accessing sparse targets.
- [High] The package notifier callback `cxl_region_add_package_node` access=
es region parameters and targets without holding the required `cxl_rwsem.re=
gion` lock, allowing race conditions with concurrent region teardown.

Pre-existing issues:
- [High] Preexisting loops iterating over `p->targets` up to `p->nr_targets=
` fail to check for `NULL` pointers, leading to potential crashes when the =
array is sparse.
--

--- Patch [3]: [PATCH 3/4] mm/memory-tiers: register CXL nodes to memory pa=
ckages via initiator ---
commit dff9dccb7111817b944d1f03a5ff003c16d488a5
Author: Rakie Kim <rakie.kim@sk.com>

mm/memory-tiers: register CXL nodes to memory packages via initiator

A CXL memory node comes online without an explicit package association, and
plain NUMA distance does not convey which physical package it belongs to.
Without that association a CXL node cannot be grouped with the CPUs that
front it.

Register a package notifier per CXL region. When the region's memory node
comes online, the notifier resolves an initiator CPU node - the NUMA node
of the first memdev backing the region - and binds the memory node to that
initiator's package. This gives the topology layer the CPU-side association
that plain NUMA distance does not carry.

> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index e50dc716d4e82..af66e2e06c624 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2673,6 +2673,55 @@ static int cxl_region_calculate_adistance(struct n=
otifier_block *nb,
>  	return NOTIFY_STOP;
>  }
> =20
> +/*
> + * Find a NUMA node to act as the initiator for this region: scan the
> + * region's endpoint targets and return the first one that resolves to a
> + * valid NUMA node.
> + */
> +static int cxl_region_find_nearest_node(struct cxl_region *cxlr)
> +{
> +	struct cxl_region_params *p =3D &cxlr->params;
> +	struct cxl_endpoint_decoder *cxled =3D NULL;
> +	struct cxl_memdev *cxlmd =3D NULL;
> +	int i, numa_node;
> +
> +	for (i =3D 0; i < p->nr_targets; i++) {
> +		cxled =3D p->targets[i];
> +		cxlmd =3D cxled_to_memdev(cxled);

[Severity: High]
Does this code handle sparse target arrays correctly?

If __cxl_decoder_detach() clears elements in p->targets[] and decrements
p->nr_targets when a target is detached, the array can become sparse.
When iterating using p->nr_targets as an upper bound, could p->targets[i]
be NULL for detached targets?

Passing a NULL cxled to cxled_to_memdev() will immediately dereference
cxled->cxld.dev.parent, potentially causing a kernel panic.

[Severity: High]
This isn't a bug introduced by this patch, but the same missing NULL check
appears to be a pre-existing issue in other functions iterating p->targets.

For example, in cxl_dpa_to_hpa():

drivers/cxl/core/region.c:cxl_dpa_to_hpa() {
    ...
    for (int i =3D 0; i < p->nr_targets; i++) {
        if (cxlmd =3D=3D cxled_to_memdev(p->targets[i])) {
    ...
}

And in region_offset_to_dpa_result():

drivers/cxl/core/region.c:region_offset_to_dpa_result() {
    ...
    for (int i =3D 0; i < p->nr_targets; i++) {
        cxled =3D p->targets[i];
        if (cxled->pos !=3D pos)
    ...
}

Should these loops also check if p->targets[i] is NULL before dereferencing=
 it?

> +		numa_node =3D dev_to_node(&cxlmd->dev);
> +		if (numa_node !=3D NUMA_NO_NODE)
> +			return numa_node;
> +	}
> +	return NUMA_NO_NODE;
> +}
> +
> +/*
> + * Package notifier callback: when a new memory node is onlined via dax
> + * kmem, bind the node this CXL region backs to its memory package, using
> + * the nearest region target as the initiator. Notifications for other
> + * nodes are ignored.
> + */
> +static int cxl_region_add_package_node(struct notifier_block *nb,
> +				       unsigned long dax_nid, void *data)
> +{
> +	int region_nid, nearest_nid, ret;
> +	struct cxl_region *cxlr =3D container_of(nb, struct cxl_region, package=
_notifier);
> +
> +	region_nid =3D phys_to_target_node(cxlr->params.res->start);
> +	if (region_nid !=3D dax_nid)
> +		return NOTIFY_DONE;
> +
> +	nearest_nid =3D cxl_region_find_nearest_node(cxlr);

[Severity: High]
Does this callback need to hold the cxl_rwsem.region lock when accessing
shared region parameters?

This notifier can be called asynchronously when a DAX kmem node is probed.
It accesses cxlr->params.res->start and p->targets without holding the
topology lock.

Concurrently, cxl_decoder_detach() could modify p->targets, or teardown
logic could free p->res under the cxl_rwsem.region write lock. Could this
race condition result in a use-after-free or NULL pointer dereference?

> +	if (nearest_nid =3D=3D NUMA_NO_NODE)
> +		return NOTIFY_DONE;
> +
> +	ret =3D mp_add_package_node_by_initiator(dax_nid, nearest_nid);
> +	if (ret)
> +		return NOTIFY_DONE;
> +
> +	return NOTIFY_OK;
> +}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806080936.421-=
1-rakie.kim@sk.com?part=3D3
