Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C6842F704;
	Tue, 21 Jul 2026 20:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665736; cv=none; b=tkKtbvewC3U3EPcDGh19br4huI9I7mWqUeKPIbeT0G8R9SgkwEYZee0zvFBfncEFgczydcg48gcJxC25KilgwJHWlbno+r4f5dRju7L0kbqjUuqwyP/Cyv4GRKzKmGJXkGkvghKfWtwXGG/7S9/5mSzNeo8X1StKl8L4uGgmljY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665736; c=relaxed/simple;
	bh=YHho5LlJGQVo+8pB+OyR6QEo0vUqR2WYj80MaKXzbaU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S1j3IY4TbCqd9qm0sP0+pIcOneOE5bJkqnfBrkG3O+kow1x+6Q8iOU3+opCUCE22U2SPSGzs6suAMrO1C6qdhJqbqKbgevlbSaD/RlkIOPEiCGiOKHUiGc71SQ2qtTvddRv/Nb2m9hjAu0iEKQT1Xm7lHcZoP+wp49L0KzYS6Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8xS3r5M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8xS3r5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B1B1F00A3D;
	Tue, 21 Jul 2026 20:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784665734;
	bh=VuOe60LLVCEf4MDMtsz8IB8VScn7NDQ2LBDOiqFW//A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C8xS3r5MttzuBCKdIZu5qeJ3ALNGvMHfcjpjHQ6FlwWFP89aJjRomj7EIavPNjY4S
	 FHeQY7kyHSElqEFI+Gzr5sUCd8DCZIXG1vuzGlnHuu4Pt+AYHUmzOxC/BdiHAvS1fo
	 IehR9bRIbtUH5SJBbe/J/hvzRVUlcqGw4vlrNKgvHC28oJrZNWrxV6dLOyO6T3NQl2
	 65R0cO8Dbp7zOX2QTeY8MQ3f3LN5c3nL+p9RVAbFmCIP0Cji+v+GF6Q+VE3kDJ0aS7
	 hwtTzIVeHw7M6xennUwri/wGtPlyHkFM358bQpQs2qyr4XlUmli3ga3FyIPRDzdJWK
	 eM4WMRSy0HxOw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 29/36] mm: add NODE_PRIVATE_CAP_DEMOTION for
 private-node tiering demotion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: damon@lists.linux.dev, mkoutny@suse.com, kvm@vger.kernel.org, tj@kernel.org, nvdimm@lists.linux.dev, hannes@cmpxchg.org, linux-cxl@vger.kernel.org
In-Reply-To: <20260720193431.3841992-30-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-30-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 20:28:53 +0000
Message-Id: <20260721202854.48B1B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Concurrent, unprotected access to the global `tierable_nodes` no=
demask can result in a torn read.
--

--- Patch [29]: [PATCH v5 29/36] mm: add NODE_PRIVATE_CAP_DEMOTION for priv=
ate-node tiering demotion ---
commit e4de60011eb318a533982e5d4b896e77cc0ad141
Author: Gregory Price <gourry@gourry.net>

mm: add NODE_PRIVATE_CAP_DEMOTION for private-node tiering demotion

This commit introduces NODE_PRIVATE_CAP_DEMOTION, allowing private memory
nodes to be included in the tiering and demotion hierarchy. By opting into
this capability, memory-tiers will include the private node in demotion
paths, allowing page reclaim to target it.

> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> index 25e121851b586..c673080d153e4 100644
> --- a/mm/memory-tiers.c
> +++ b/mm/memory-tiers.c
> @@ -317,6 +318,21 @@ void node_get_allowed_targets(pg_data_t *pgdat, node=
mask_t *targets)
>  	rcu_read_unlock();
>  }
> =20
> +/* Tiering set: N_MEMORY | (N_MEMORY_PRIVATE w/ CAP_DEMOTION) */
> +static nodemask_t tierable_nodes;
> +
> +static void update_tierable_nodes(void)
> +{
> +	int node;
> +
> +	lockdep_assert_held_once(&memory_tier_lock);
> +
> +	tierable_nodes =3D node_states[N_MEMORY];
> +	for_each_node_state(node, N_MEMORY_PRIVATE)
> +		if (node_allows_demotion(node))
> +			node_set(node, tierable_nodes);
> +}
> +

[ ... ]

> @@ -330,7 +346,7 @@ void node_get_allowed_targets(pg_data_t *pgdat, nodem=
ask_t *targets)
>  int next_demotion_node(int node, const nodemask_t *allowed_mask)
>  {
>  	struct demotion_nodes *nd;
> -	nodemask_t mask;
> +	nodemask_t mask, tierable;
> =20
>  	if (!node_demotion)
>  		return NUMA_NO_NODE;

[ ... ]

> @@ -370,7 +386,8 @@ int next_demotion_node(int node, const nodemask_t *al=
lowed_mask)
>  	 * closest demotion target.
>  	 */
>  	nodes_complement(mask, *allowed_mask);
> -	return find_next_best_node_in(node, &mask, &node_states[N_MEMORY]);
> +	tierable =3D tierable_nodes;

[Severity: Medium]
Could this lockless copy result in a torn read of the tierable_nodes nodema=
sk?

In update_tierable_nodes(), the global tierable_nodes mask is updated via a
non-atomic struct assignment and iterative node_set() modifications. Here in
next_demotion_node(), the mask is copied locklessly to the stack during the
reclaim hotpath.

Since nodemask_t can be up to 128 bytes depending on MAX_NUMNODES, concurre=
nt
updates from memory hotplug could cause next_demotion_node() to see a
partially updated mask. This could cause page reclaim to transiently skip v=
alid
private nodes or behave suboptimally during demotion.

> +	return find_next_best_node_in(node, &mask, &tierable);
>  }
> =20
>  static void disable_all_demotion_targets(void)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D29
