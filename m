Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BB946D088;
	Tue, 21 Jul 2026 18:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658930; cv=none; b=ip33gYVlNnWp1gR9I3BFCzO1/sVvz8WQq78hYVqZv1QMR+7I5A23KC3x5Dh+Jv6l6/2dwAS+io7hMzw/PQUsKmZzULh1w6igHImzptfhy4m+LjJuK3iqJiI3mDVnbkxpU3OOqLxo0o3J/+ksxcjx7dYptSSAj6MM5b7Gb6yA1Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658930; c=relaxed/simple;
	bh=IBEs+RhA5Aj/vLpMvyGKxJ3MChwoGXgdCvxiuLZE1xc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P5VCCf/GVJSbOIV4Omna+0xCNNR3xWjh9NXkt/gYWP99anTll/L31SKUGRNSn0e6YDaGD9qb+0bleiKtcfVy443Wgr+O6PlXSFff0wgSGvWJJ6P6z2K6Zajv5WiqdfjQBJHUC4LLdiMiTKsKWH0xw9iD6B6KzfsvzpQMdy/+Q24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRoM7KzK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRoM7KzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B9C1F00A3A;
	Tue, 21 Jul 2026 18:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658929;
	bh=jQt2sF5zW/sGYaBa8eStkJAVH5ZRp9TfqcHjfBWYYj8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GRoM7KzKCgLAfR7klf9mnoqRMb7qpQbOGyXrJdcjLD3AcejXohiz+vOMjCMzoPgHp
	 2xbdzK1p54HhrxL1wlAZEvB/XzdU/T4dIWRtiQ1gnXBgvNni/yMPyPDLtXDrHkbLYJ
	 NKawm1x8FkLUdK43jGsUEAYH7Z8OC+IaAXWbMsB9I2eJAhwRlyJIxVPAIU5g9Kzw/V
	 vsgVsP4ruEyOJRiLABM5wTrpqOcugXVmSDtiVBDTPT6sf3GvjlRr67nA+rS/QtrtAY
	 s4kuA9gQx3n2kkRicEu/Tjbske/G8fX4u1JkIpNcP55XeariBUUFNO5jEQxM4FP+fd
	 cpfqWKIUz2Qfw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 17/36] mm/vmscan: disallow reclaim of private node
 memory
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: damon@lists.linux.dev, tj@kernel.org, hannes@cmpxchg.org, linux-cxl@vger.kernel.org, mkoutny@suse.com, nvdimm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260720193431.3841992-18-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-18-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:35:27 +0000
Message-Id: <20260721183528.B4B9C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Soft-limit reclaim bypasses the new private node filter, allowing =
eviction on private nodes.
--

--- Patch [17]: [PATCH v5 17/36] mm/vmscan: disallow reclaim of private nod=
e memory ---
commit 9fc4bff86adde3091fee2924952f9af9700e6308
Author: Gregory Price <gourry@gourry.net>

mm/vmscan: disallow reclaim of private node memory

This commit attempts to prevent reclaim on private nodes by adding a filter
to shrink_node().

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e26c6931f5fde..86b2334c23b98 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6141,6 +6141,13 @@ static void shrink_node(pg_data_t *pgdat, struct s=
can_control *sc)
>  	struct lruvec *target_lruvec;
>  	bool reclaimable =3D false;
> =20
> +	/*
> +	 * Private nodes do not support reclaim by default, filtering here
> +	 * captures all normal reclaim paths that may attempt eviction.
> +	 */
> +	if (node_is_private(pgdat->node_id))
> +		return;
> +

[Severity: High]
Does this filter successfully capture all normal reclaim paths?

When the system uses memcg v1 and a cgroup exceeds its soft limit, global
direct reclaim in shrink_zones() or kswapd in balance_pgdat() will invoke
memcg1_soft_limit_reclaim(). This bypasses shrink_node() entirely:

mm/vmscan.c:shrink_zones() {
    ...
    nr_soft_reclaimed =3D memcg1_soft_limit_reclaim(zone->zone_pgdat,
                                                  sc->order, sc->gfp_mask,
                                                  &nr_soft_scanned);
    ...
}

This leads to mem_cgroup_shrink_node() directly calling shrink_lruvec()
without checking if the node is private:

mm/vmscan.c:mem_cgroup_shrink_node() {
    ...
    shrink_lruvec(lruvec, &sc);
    ...
}

Will this allow unintended eviction on private nodes during soft limit recl=
aim?

>  	if ((lru_gen_enabled() || lru_gen_switching()) && root_reclaim(sc)) {
>  		memset(&sc->nr, 0, sizeof(sc->nr));
>  		lru_gen_shrink_node(pgdat, sc);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D17
