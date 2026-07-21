Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56502476052;
	Tue, 21 Jul 2026 20:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664823; cv=none; b=jpFggcsiE8EcI6QcWkVfDtPAvsZpqRXmCS/Y6yLJUMOqVDmesBxdrq87DptbTCm8ym6DQ2UDHp/O7FVkLO5x50BorIxSfZIX4TlcM/oNmljWWNsNzgQNKbGyJLue0Pn70+UPEnjQroQgcXioojLumtErvU/7dK6iEdlhwX8Bh18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664823; c=relaxed/simple;
	bh=L67csVT9DNo2+wN8y/WnBLcyuXQYa9Hre6hJ700S4VY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M5thy4eH+c+kaiG+3P75YoadLP0FizqJd3SMq/ItIsxLr0e7ZlLu1UAb4fEPguMJQZzGvS1YNDGFp1x3eDptJLynUS75PxjuJZMmRI6U2SFpETbHgZ4xp5i8gA4YoMB0kWa4DRpolpvCr0dPCzCT81jS6cCV06MSUvMK2vhUJ2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7LxlcqK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7LxlcqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93A81F000E9;
	Tue, 21 Jul 2026 20:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784664822;
	bh=VEwCSxJ0LjKZog3q73v8Hk7ZAjqu4ZZq2bYbwdBRXPI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b7LxlcqK0Xe1uUfusUIhKoQ4kLp0JXjm2bvUHOdTBcJNCqEijmMhMMt+1XL6Kh2Zm
	 Pn3I0kSqvUysxX2cmQhRKclsCAHYzf7+FclLWyHr+JoXMK+CPXFDvvnDpv6/+anZMZ
	 UBCIYpm1AYQaxI16l4yZTo6JSAiWOEanRntLEItkEmOeU36+w1brbM2n1Kz7QSQbLG
	 jk3fiMw5LrbIoF5BFgiueYZiTjR3Ug+OODcDjjxz/6azE76pYdZErU/WhtTVzihbLL
	 ERJmqSFowkRP467w2sdB8QZOTevvsn6weIrz4xGH3LlqBnmr8ybzIUssizcqArj4iy
	 Bbuzgyw8lKs1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 27/36] mm: add NODE_PRIVATE_CAP_USER_NUMA for
 userland numa controls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, damon@lists.linux.dev, linux-cxl@vger.kernel.org, tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org, kvm@vger.kernel.org
In-Reply-To: <20260720193431.3841992-28-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-28-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 20:13:41 +0000
Message-Id: <20260721201341.A93A81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Medium] Relative node indices are incorrectly treated as absolute node I=
Ds for private node checking in mpol_set_nodemask.
- [Medium] Hugetlb folio migration to private nodes unconditionally fails b=
ecause the hugetlb allocator ignores ALLOC_ZONELIST_PRIVATE.

Pre-existing issues:
- [High] Returning ACTION_AGAIN on pte_offset_map_lock() failure causes an =
infinite loop in the page table walker.
--

--- Patch [27]: [PATCH v5 27/36] mm: add NODE_PRIVATE_CAP_USER_NUMA for use=
rland numa controls ---
commit 90c010ac54e1befaa9a30ca8c81fdac4b3524857
Author: Gregory Price <gourry@gourry.net>

mm: add NODE_PRIVATE_CAP_USER_NUMA for userland numa controls

This commit provides a mechanism to opt private nodes into userland numa
management. It adds node_allows_user_numa() to encapsulate whether a node
supports userland NUMA controls and modifies the memory policy and migration
interfaces to support these nodes.

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index a3ffb09897489..fe42a510590a2 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -434,13 +434,14 @@ static int mpol_set_nodemask(struct mempolicy *pol,
> =20
>  	/*
>  	 * Private nodes are not in cpuset.mems, so they're always stripped.
> -	 * Driver-allocated policies will already have MPOL_F_PRIVATE set,
> -	 * if that's the case, add back in the requested set of private nodes.
> +	 * Driver-allocated policies (MPOL_F_PRIVATE) and CAP_USER_NUMA private
> +	 * nodes should be added back into the nodemask.
>  	 */
>  	for_each_node_mask(nid, *nodes) {
>  		if (!node_is_private(nid))
>  			continue;
> -		if (pol->flags & MPOL_F_PRIVATE)
> +		if ((pol->flags & MPOL_F_PRIVATE) ||
> +		    node_allows_user_numa(nid))
>  			node_set(nid, nsc->mask2);
>  	}

[Severity: Medium]
When MPOL_F_RELATIVE_NODES is set, the *nodes mask contains relative indice=
s=20
instead of absolute node IDs. Does this loop incorrectly evaluate those=20
relative indices as absolute node IDs when calling node_is_private(nid)?

If the relative index happens to match an absolute private node ID, it appe=
ars
that node could be erroneously added to the final policy mask.

[ ... ]

> @@ -752,7 +753,8 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigne=
d long addr,
>  			continue;
>  		}
>  		folio =3D vm_normal_folio(vma, addr, ptent);
> -		if (!folio || folio_is_private_managed(folio))
> +		if (!folio || folio_is_zone_device(folio) ||
> +		    !node_allows_user_numa(folio_nid(folio)))
>  			continue;
>  		if (folio_test_large(folio) && max_nr !=3D 1)
>  			nr =3D folio_pte_batch(folio, pte, ptent, max_nr);

[Severity: High]
This is a pre-existing issue, but earlier in queue_folios_pte_range() we
return ACTION_AGAIN if pte_offset_map_lock() fails:

queue_folios_pte_range()
    ...
    mapped_pte =3D pte =3D pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
    if (!pte) {
        walk->action =3D ACTION_AGAIN;
        return 0;
    }

Does setting ACTION_AGAIN cause an infinite retry loop in the pagewalker=20
when pte_offset_map_lock() fails non-transiently, such as when encountering
migration entries?

> diff --git a/mm/migrate.c b/mm/migrate.c
> index d20674c07b947..b548d79352a38 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2231,7 +2231,8 @@ struct folio *alloc_migration_target(struct folio *=
src, unsigned long private)
>  	if (is_highmem_idx(zidx) || zidx =3D=3D ZONE_MOVABLE)
>  		gfp_mask |=3D __GFP_HIGHMEM;
> =20
> -	return __folio_alloc(gfp_mask, order, nid, mtc->nmask, ALLOC_DEFAULT);
> +	return __folio_alloc(gfp_mask, order, nid, mtc->nmask,
> +			     mtc->alloc_flags);
>  }

[Severity: Medium]
This correctly updates the standard folio allocation to use mtc->alloc_flag=
s,
but earlier in alloc_migration_target(), the hugetlb allocation path does
not pass this flag:

    if (folio_test_hugetlb(src)) {
        ...
        return alloc_hugetlb_folio_nodemask(h, nid, mtc->nmask, gfp_mask,
                                            htlb_allow_alloc_fallback(mtc->=
reason));
    }

Will hugetlb migration to private nodes fail unconditionally because it mis=
ses
the ALLOC_ZONELIST_PRIVATE flag needed by the hugetlb allocator?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D27
