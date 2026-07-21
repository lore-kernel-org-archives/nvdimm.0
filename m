Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C338546C4DD;
	Tue, 21 Jul 2026 18:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658391; cv=none; b=gNQzRg71B42sOmDVigUp8zXfIvzS8Eq//wrsGIfbgANtzhwyxloGxpWCV0IolFjStgSwhSMVmSooWCQjeJ+DWfDRds+H+HUM6nievO9biXcl22QDO0FMQVPqzPFdCsKQZRv6uCewuCA5Pm1gXltY4u5+43Wg7H4JaVysykowAwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658391; c=relaxed/simple;
	bh=ZHeyBToBC+c+eQlOLYupANbquE2rMCSpjOnAIcq6EvQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ik1khLUuiSzvoO55+NphVbyn/Pu2quVNI48kL7HPez94kS6A+aZ0XHEeLDpv84IT2WEj5fMa6Vuk1JNScGhZLQXweXY75iD/dYxbhATMXGYO/DfeEr6z7oKB6Ld4AYegItVmLG1e7dnTXN2POYYT5tNZVBvrSfotb2AKN6Rcyjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJHUnOS6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJHUnOS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A775C1F00A3E;
	Tue, 21 Jul 2026 18:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658389;
	bh=hUfXqG9fgfITmO6hktasNrklg0Nt9rxmU8oGzmLj8yg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bJHUnOS6C7nhoQhFR/k0H4EzuGy0/GRNp/LEFJ5ynxTZK/tUAhpIIKuQH6T4/+PDF
	 6TbjCwv+Ey57+SY+q0ECbrS5CODyXeRqBS9FYuO0fIusOUvCs50+wvvbvJFXBO/rWC
	 ZiK2548sgarj6jkkyVoMP3eyscAUeOjI+dGy1+8f8FSUYDZoU5e2L9OPVgFde035gu
	 Uw2hBCNoZcCWAlEnaFWV5g6xTtQ7GCMDBHZOOlE3B9z1CTxF8budIKO26z6SNzWNM1
	 yS8+VR55vbe8MS64bvP3VnsOVZqCxodul+ptJ6UDjYfKAh+qY6gbty8NGGaFBLvmPd
	 Cin0WTrlovBLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 03/36] mm/page_alloc: let the bulk and folio
 allocators carry alloc_flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: tj@kernel.org, linux-cxl@vger.kernel.org, mkoutny@suse.com, nvdimm@lists.linux.dev, damon@lists.linux.dev, hannes@cmpxchg.org, kvm@vger.kernel.org
In-Reply-To: <20260720193431.3841992-4-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-4-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:26:27 +0000
Message-Id: <20260721182628.A775C1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The newly added `alloc_flags` parameter is ignored during the bu=
lk allocation fastpath when calling `prep_new_page`.
--

--- Patch [3]: [PATCH v5 03/36] mm/page_alloc: let the bulk and folio alloc=
ators carry alloc_flags ---
commit 00718b17ea28c0a7382f9831d41a8a45df59e496
Author: Gregory Price <gourry@gourry.net>

mm/page_alloc: let the bulk and folio allocators carry alloc_flags

This commit threads the alloc_flags parameter through the bulk and folio
allocators to allow callers to select specific allocator behavior. It updat=
es
__alloc_pages_bulk_noprof and __folio_alloc_noprof to accept and pass these
flags internally.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c

[ ... ]

> @@ -5238,11 +5239,19 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, =
int preferred_nid,
>  	return nr_populated;
> =20
>  failed:
> -	page =3D __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, ALLOC_DE=
FAULT);
> +	page =3D __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, alloc_fl=
ags);
>  	if (page)
>  		page_array[nr_populated++] =3D page;
>  	goto out;
>  }

[Severity: Medium]
Will the fast path ignore the caller's new alloc_flags parameter?

In the slow path fallback above, the code correctly passes the new alloc_fl=
ags
parameter to __alloc_pages_noprof(). However, in the fast path batch
allocation loop just above this hunk, the pages are still initialized with a
hardcoded ALLOC_DEFAULT:

__alloc_pages_bulk_noprof() {
    ...
    while (nr_populated < nr_pages) {
        ...
        page =3D __rmqueue_pcplist(...);
        ...
        prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
        set_page_refcounted(page);
        page_array[nr_populated++] =3D page;
    }
}

If a caller passes custom alloc_flags to __alloc_pages_bulk_noprof(), it
appears the flags will be dropped by the fast path but honored by the slow
path, leading to inconsistent allocator behavior.

Should prep_new_page() in the fast path loop be updated to use the provided
alloc_flags instead of ALLOC_DEFAULT?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D3
