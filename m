Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6EB3909A9;
	Tue, 21 Jul 2026 18:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658153; cv=none; b=AjOXVjPLX3v8dHTeN6ys5h9gNDSbjxwYm6wB+nGJ7KSmZbykOLEbKHcYcFpoKlizI/gQsescUR+H6ubI9n6T9sckEsULUSLA1Vo0hUZxm/q8WzzorsdW30W2tkegJGFO691gxTB9mzS2D3zNpoZsgGuL2LYMOfQods8T+erXmeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658153; c=relaxed/simple;
	bh=vXImQVwQKbXdhhvdQrg1yMH20L1l3ulCgYYHg5AlakM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Tal+l9juBZSbhJGtWePAk3F2dMhqw2TpekVlk/sWx/qXUs4heqGNNHZc3Iwc0HyVJ+k6Gc7du8SISt109fmpSSbTAPJcYOMfXt03mkkYk+E4/5R/zr38ahOimFD2iD9h8tzzCUVeKcNgXNExs7p1SjyAqz62OCNGwFgmH323meE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GdXAaghr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GdXAaghr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143F01F00A3A;
	Tue, 21 Jul 2026 18:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658152;
	bh=mOjETsSlqSQJd/o4fn73xSl/nbFPh4eP+aN+ldGyu/g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GdXAaghr5WNKO8ye0WFsJwK/SBONak0BzsR9veuJ+FjdLYgCo3KtmpsL7daMUJuOz
	 1gGuZm0G5c3A5y6tY7qtQunyagUhtufhGsp5YC6zWmBlispxTbO4CgNF7DYGdnsSVf
	 h5M9oIcwHOYmw6j46cG1xRNRaDakWScy8N7TNK1Ueb/07w4j79jztEYBj1nD2IjTwp
	 r9abWk8xXr9RYnS3abqyJvTopBSWT18Sx7R2o7eWk98LmV4OjxWZMS+3XTNPLNsdMC
	 Xt2gASRtLEG9frF3Aqp8x4W4PDrmkD/WePROCJXz0nkMNcRrQheX7nrh273DkmnXoj
	 zzuIpXVJKbSXQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 08/36] mm/mempolicy: skip private node folios when
 queueing for migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: tj@kernel.org, hannes@cmpxchg.org, nvdimm@lists.linux.dev, mkoutny@suse.com, damon@lists.linux.dev, kvm@vger.kernel.org, linux-cxl@vger.kernel.org
In-Reply-To: <20260720193431.3841992-9-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-9-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:22:31 +0000
Message-Id: <20260721182232.143F01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Blind conversion of PMD to folio in queue_folios_pmd() causes =
out-of-bounds dereference on raw PFN mappings.
- [High] queue_folios_pte_range() sets walk->action =3D ACTION_AGAIN when p=
te_offset_map_lock() returns NULL, leading to an infinite retry loop for mi=
gration entries.
--

--- Patch [8]: [PATCH v5 08/36] mm/mempolicy: skip private node folios when=
 queueing for migration ---
commit 0603242bf30dacf881c78a4de8f6d67872a88c83
Author: Gregory Price <gourry@gourry.net>
Subject: mm/mempolicy: skip private node folios when queueing for migration

Private nodes are already kept out of policy nodemasks (only N_MEMORY
nodes are allowed), but an mbind(MPOL_MF_MOVE) walk can still encounter a
private-node folio in the range.  Skip such folios so mempolicy-driven
migration never moves private-node memory.

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 5720f7f54d942..8e8763f6e5f5b 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
[ ... ]
> @@ -668,6 +669,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_wa=
lk *walk)
>  	}
>  	if (!queue_folio_required(folio, qp))
>  		return;
> +	if (folio_is_private_node(folio))
> +		return;
>  	if (!(qp->flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
>  	    !vma_migratable(walk->vma) ||
>  	    !migrate_folio_add(folio, qp->pagelist, qp->flags))

[Severity: Critical]
This is a pre-existing issue, but can this cause an out-of-bounds
dereference on raw PFN mappings?

Earlier in mm/mempolicy.c:queue_folios_pmd(), the code unconditionally
calls pmd_folio() and dereferences it:

	folio =3D pmd_folio(pmdval);
	if (is_huge_zero_folio(folio)) {

If an unprivileged user calls mbind(..., MPOL_MF_STRICT) on a memory
region mapped by a driver using raw PFNs via huge PMDs (e.g.,
vmf_insert_pfn_pmd() in a VM_PFNMAP VMA), pmd_trans_huge_lock() will
succeed. However, treating a raw PFN as a struct folio yields a bogus
pointer, leading to a kernel panic when accessed. Does this need a check
like pmd_special() to filter out raw PFN mappings?

> @@ -722,7 +725,7 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigne=
d long addr,
>  			continue;
>  		}
>  		folio =3D vm_normal_folio(vma, addr, ptent);
> -		if (!folio || folio_is_zone_device(folio))
> +		if (!folio || folio_is_private_managed(folio))
>  			continue;
>  		if (folio_test_large(folio) && max_nr !=3D 1)
>  			nr =3D folio_pte_batch(folio, pte, ptent, max_nr);

[Severity: High]
This is a pre-existing issue, but can this lead to an infinite retry loop?

Just above this section in mm/mempolicy.c:queue_folios_pte_range(), there
is:

	mapped_pte =3D pte =3D pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
	if (!pte) {
		walk->action =3D ACTION_AGAIN;
		return 0;
	}

Since pte_offset_map_lock() returns NULL non-transiently for migration
entries, setting walk->action =3D ACTION_AGAIN and returning 0 on this
failure instructs walk_pte_range() to retry the exact same PMD
indefinitely with no limit. Because this early return skips the
cond_resched() at the bottom of the function, it creates a tight CPU
livelock. Should this instead return 0 without setting ACTION_AGAIN to
gracefully skip the entry?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D8
