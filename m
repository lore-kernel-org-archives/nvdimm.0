Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBF62F6931;
	Tue, 21 Jul 2026 20:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664141; cv=none; b=iqKuuwc2Cr6tytHlA8ig8vk1xyK7zS4kLsr+v/8LHYz7YvlFjA5MlqJ9H2yTTJ/yMETq7BiQbYTEBQGKkW6Osf2W4ciuPv7Ym6HHpXE4SBxjtrrl9LjF1MCwSCc58aSch3GipaNnJElZEULKuebZxoDsUo+k1MpJumBgYnHnOU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664141; c=relaxed/simple;
	bh=Vb+SQs/GMg3Bov7dC1+d/Z0H6DbHmGBWoSYMyCX+uc8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kM9hhjLn5KRfZmhg2yijbOSQPYKl6Pg0bt6Ark3J0VL0HRaQPlHrHyGDCT380SW52USXpVymR4iBmKCnJzjQFCiwJpfVHt3EByRaUbGuBLq6MWzalxQbfcvskgy2PGQqYvXWsdmbXFywNR2H8qLvw7Pd/0QBauixBQcbVk0D2b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YgC9cV3+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YgC9cV3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E331F000E9;
	Tue, 21 Jul 2026 20:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784664140;
	bh=FEbuZNk0KqWNneeoXyOwhICPQLgmGsAWF/KvC1bn/D0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YgC9cV3+2eMjfKyokmz9P18r3LhgW+hyAUza0Y0zttNaIia+xBESo2xDwgQoGjWjW
	 sG77j7P707rjVsyawz3OqtMsrEMwxI9kpVsgHwOiRqziaVpa4geWKkqv4DSU7El7xq
	 qhkTFnh+sMrrhApvOvJdqp7moVwk/J9/pCttc7ZcDvg7SNzhy+vBUwx0Nlg5EMjfpl
	 9uDWpfkmMZaZkjpISw+OLQtzT4WFxlGn+dzaD1lRZnl1OTpmdjYy6KW9o2AVIimk+t
	 HJk0oJn2E0lGFz1KeTxbMbUBeD79fbsYa3hbJZO6orP5Ho+PyfLMExEqNZyFXpmzy4
	 p1uNwz5Rbvk/Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 26/36] mm: add NODE_PRIVATE_CAP_RECLAIM for opted-in
 private node reclaim
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: kvm@vger.kernel.org, tj@kernel.org, mkoutny@suse.com, damon@lists.linux.dev, hannes@cmpxchg.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260720193431.3841992-27-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-27-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 20:02:19 +0000
Message-Id: <20260721200220.05E331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] calculate_totalreserve_pages() unconditionally skips private nod=
es, failing to account for their watermarks in totalreserve_pages.
- [Medium] Incorrect zone watermark calculation for private nodes allowing =
reclaim.
--

--- Patch [26]: [PATCH v5 26/36] mm: add NODE_PRIVATE_CAP_RECLAIM for opted=
-in private node reclaim ---
commit 29ab758bf14800171bcfa7488632ce55ed680b45
Author: Gregory Price <gourry@gourry.net>
Subject: mm: add NODE_PRIVATE_CAP_RECLAIM for opted-in private node reclaim

This commit introduces NODE_PRIVATE_CAP_RECLAIM to allow private memory
nodes to opt into reclaim processes. It replaces various node_is_private()
checks with node_allows_reclaim() across the memory management subsystem.
Private nodes that opt in will now have normal watermarks calculated for
them.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2b08bea2379a9..2667a4564b7ac 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6667,7 +6667,7 @@ static void __setup_per_zone_wmarks(void)
>  		u64 tmp;
> =20
>  		spin_lock_irqsave(&zone->lock, flags);
> -		if (node_is_private(zone_to_nid(zone))) {
> +		if (!node_allows_reclaim(zone_to_nid(zone))) {
>  			zone->_watermark[WMARK_MIN] =3D 0;
>  			zone->_watermark[WMARK_LOW] =3D 0;
>  			zone->_watermark[WMARK_HIGH] =3D 0;

[Severity: Medium]
Will this lead to an incorrect watermark calculation for private nodes that
allow reclaim?

Earlier in __setup_per_zone_wmarks(), lowmem_pages is calculated by
explicitly excluding private memory:

	for_each_zone(zone) {
		if (!is_highmem(zone) && zone_idx(zone) !=3D ZONE_MOVABLE &&
		    !node_is_private(zone_to_nid(zone)))
			lowmem_pages +=3D zone_managed_pages(zone);
	}

Because lowmem_pages excludes private memory, when we calculate WMARK_MIN
for a private node later in this function using:

		tmp =3D (u64)pages_min * zone_managed_pages(zone);
		tmp =3D div64_ul(tmp, lowmem_pages);

does this mean the private node will reserve a disproportionately high
percentage of its memory if the system has a small amount of normal memory
and a large private node?


[Severity: Medium]
Also, does this miss updating the totalreserve_pages counter?

At the end of __setup_per_zone_wmarks(), we call
calculate_totalreserve_pages(). However, that function unconditionally
skips all private nodes:

	for_each_online_pgdat(pgdat) {
		/* private nodes have zero watermarks */
		if (node_is_private(pgdat->node_id))
			continue;

If a private node has CAP_RECLAIM and non-zero watermarks, does skipping it
here cause totalreserve_pages to remain artificially low?

This might cause node_dirtyable_memory() and global_dirtyable_memory() to
overestimate available memory, which could inflate dirty limits and
writeback thresholds.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D26
