Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9A83C4B81;
	Tue, 21 Jul 2026 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658633; cv=none; b=gD+L6Qb3AzxroBL56XesTxLw5IvRHxv5XF59nE/JuRScJhvD5l01JlNSmjI8t001CNlVpkeh6sCkALU/JXmS/bjIOXtjawyMmJPVV4TV/zWzKpihqN/meKfzpeziqKacPLQB7mddVQwsmeCfr2LQEc7bxtZdQKQNSpswzZ+HEEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658633; c=relaxed/simple;
	bh=8Ulxh4MGMeUat4vhsWN5QilQEOcc3iXUmwuU17eEVkw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lhEYrxR+hDzW39D4AGNHB9eJ3ghpjQwFe7VEL8vqbVPHCjfeBoVB9arkEHVtZt3bdSnrTcqB4akotZrzLrWpOPTf8VSDpV4UVgngNoe0HsQKaWfgl1jUSxUyOppUgDX3O+q8wn69uciMDaW3lmQHoO6VK3mx8qVPx7et+Zabu/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OgRv30Ww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OgRv30Ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCC31F00A3D;
	Tue, 21 Jul 2026 18:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658631;
	bh=+ZDkD8aLZgWtnJP4QW4kRiUUVNkybipRerj3Yw2aIKU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OgRv30WwKU588EJs6wnM0orBFyW3lRHpSSf8Q4n2KfEwy5d8GrG4nSc19xL1yjxRb
	 6cU7aD+uCGbG0BKkcKRZzGS/XxKcs8Kl0d/0cvUEZJc8R6O66DLTaJ8NfZu6ydRwqc
	 3h1iMLlaAcb+hUVmVxK0oCMMWNbkhVRP6gnPyyz9w6OHkZO5Th3dhI6CmWOe4SQnfE
	 PxLWqKF8yYWyiBLocO0ETF6qPOWfNgH/XK/jMDVh1iMNoAe/oSeBGI7CZ+qu656S0Z
	 j4wayDnAP8V3uKmxOVprQ4rXoG4knPVz05wyW9liuRXB+EIBqnrvd80m7ucdhPeiyc
	 R/cybAFjtB7HA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 10/36] mm/madvise: disallow madvise operations on
 private node folios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: damon@lists.linux.dev, linux-cxl@vger.kernel.org, kvm@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, nvdimm@lists.linux.dev
In-Reply-To: <20260720193431.3841992-11-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-11-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:30:30 +0000
Message-Id: <20260721183031.4FCC31F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] madvise_cold_or_pageout_pte_range() calls folio_get() before block=
ing on folio_lock() when attempting to split a large PMD-mapped folio, viol=
ating the required lock-before-refcount ordering for large folio splits.
--

--- Patch [10]: [PATCH v5 10/36] mm/madvise: disallow madvise operations on=
 private node folios ---
commit 76f9465747c7c18f9f36e91d7a628706fb9905f9
Author: Gregory Price <gourry@gourry.net>

mm/madvise: disallow madvise operations on private node folios
   =20
Use the same filter locations as zone_device, plus additional filters
for huge pages to avoid madvise operations on private node memory.

[ ... ]
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 07a21ca31bad4..29f35a23919a0 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
[ ... ]
> @@ -395,6 +396,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *p=
md,
> =20
>  		folio =3D pmd_folio(orig_pmd);
> =20
> +		if (folio_is_private_node(folio))
> +			goto huge_unlock;
> +
>  		/* Do not interfere with other mappings of this folio */
>  		if (folio_maybe_mapped_shared(folio))
>  			goto huge_unlock;

[Severity: High]
This is a pre-existing issue, but does the sequence just below this block
in madvise_cold_or_pageout_pte_range() cause split_folio() to fail under
contention?

A few lines down, the code attempts to split a PMD-mapped large folio:

    folio_get(folio);
    spin_unlock(ptl);
    folio_lock(folio);
    err =3D split_folio(folio);

When multiple tasks concurrently attempt to split the same folio, taking
the reference before blocking on the lock inflates the refcount. This
causes split_folio() to spuriously return -EAGAIN because the expected
refcount does not match.

Could we trylock the folio before raising the reference count here,
similar to how it is handled in madvise_free_huge_pmd() in huge_memory.c?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D10
