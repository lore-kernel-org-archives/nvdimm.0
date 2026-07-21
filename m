Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380F33019A9;
	Tue, 21 Jul 2026 18:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658606; cv=none; b=c4HCRZp2IUYwQLuXx6ujQZl+a4gttb8TTNF9TfGccb6GO4wKZ9nWH3HUhBVLh+/FquoNm+8nY0iPabhwVTqG4ydO6KK0YH8fMO3hX/Px2US4ag7r8X3+t5/IST7cNwKMmY/opX2t4Zpr7+cCkn/x01qEXCOoU30xQyyds1oRsVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658606; c=relaxed/simple;
	bh=Cs/nrAfn1hCcVeBTwBdr81YGJBgOjfLu6LcoQ8LkN/Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=j4esqJLLq1GMcTPfzivTaB71YA9LAPqvOAdzB00/WmtVO9C+8QpMwswV2nHRrmENOcHXFUItxpmPpJnK4LIs0nUqkaeG2S9fXqOiUMpRnpgunZAVORSHnRz1QNlmy7ysEmNe2BY4hcp1U6E9dqT/e6i0RGcrmMxU4fFSjkQ6OYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+2llysW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+2llysW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A19F1F00A3A;
	Tue, 21 Jul 2026 18:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658605;
	bh=z/slgfKwuG09aX7aTGpFd5K7O7Kdfc/J2Zd/OgMjIms=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X+2llysWCkfj+v2wBofv84JrRNFWVgo4N/FoEgGGG3tcmdbDDAyVEVpYQ7qegASbl
	 oxzdrJks/FBigqH+NtVGWh7wEAxRQNToVXOs/nv2bLc1m/4oRRjaVGFmx40A/Lkj4S
	 iPPbVEw6dZQGMJsiY6WkNVVy+O+7iGBz2Pt7XyM4BCBRNZqAJgzDIn45PWxoE4wJPg
	 Nis1EJYwcWiHPx8yiI09ixd9E8S/rGn0Bu6dCi4lTGZTfEQoA2PhXwEi+8CyNRnb1j
	 5jsY8bi7RCIxRYSSbTDGOyaMH1UIZeOHnBuwO2sjHVo7jf+mCytABWEWftXEZ4Ywfu
	 ZLvViLSHMFrPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 19/36] proc: include N_MEMORY_PRIVATE nodes in
 numa_maps output
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: kvm@vger.kernel.org, hannes@cmpxchg.org, nvdimm@lists.linux.dev, mkoutny@suse.com, linux-cxl@vger.kernel.org, damon@lists.linux.dev, tj@kernel.org
In-Reply-To: <20260720193431.3841992-20-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-20-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:30:04 +0000
Message-Id: <20260721183004.9A19F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Using ACTION_AGAIN when pte_offset_map_lock() fails can create an =
infinite loop.
--

--- Patch [19]: [PATCH v5 19/36] proc: include N_MEMORY_PRIVATE nodes in nu=
ma_maps output ---
commit 744e7cd9225bc94011608ebdc2dbdb49cbdf8476
Author: Gregory Price <gourry@gourry.net>

proc: include N_MEMORY_PRIVATE nodes in numa_maps output

numa_maps collects per-node page counts in the page-table walkers
and emits them in show_numa_map.  All three filtered by N_MEMORY,
so pages on N_MEMORY_PRIVATE nodes were never gathered/printed.

Accept N_MEMORY_PRIVATE pages in both walkers and emit private nodes
in show_numa_map, so private-node mappings are visible in numa_maps.

> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 817e3e0f91943..e116cd5f157b9 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
[ ... ]
> @@ -3414,7 +3415,8 @@ static struct page *can_gather_numa_stats_pmd(pmd_t=
 pmd,
>  		return NULL;
> =20
>  	nid =3D page_to_nid(page);
> -	if (!node_isset(nid, node_states[N_MEMORY]))
> +	if (!node_isset(nid, node_states[N_MEMORY]) &&
> +	    !node_isset(nid, node_states[N_MEMORY_PRIVATE]))
>  		return NULL;
> =20
>  	return page;

[Severity: High]
This is a pre-existing issue, but can the error handling in gather_pte_stat=
s()
lead to an infinite loop?

When reading from procfs memory mapping files (like numa_maps),
pte_offset_map_lock() can fail non-transiently for a PMD migration entry and
return NULL:

fs/proc/task_mmu.c:gather_pte_stats() {
	...
	orig_pte =3D pte =3D pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
	if (!pte) {
		walk->action =3D ACTION_AGAIN;
		return 0;
	}
	...
}

Because this sets walk->action =3D ACTION_AGAIN, wouldn't the walk_pmd_rang=
e()
core unconditionally retry the same PMD entry indefinitely without making
forward progress?

The same pattern also appears to exist in smaps_pte_range(),
clear_refs_pte_range(), pagemap_pmd_range(), and pagemap_scan_pmd_entry().

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D19
