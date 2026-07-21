Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BBD46EC6A;
	Tue, 21 Jul 2026 18:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657903; cv=none; b=PQZI27BppA/Fb5+X9RSrcnU6gUds/9guVnF5DP4N68mUXm46aGB6iz28P95gmt74XFdO0uGmfeXWRXaIT21iWqIX1dGQxuPY4VdpV2vkuajYpY5EzgIexeNy0akTK0GLRe4UzUpdq+IC+WNV055D/Yq/309xNUZUYa7C4PtuUrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657903; c=relaxed/simple;
	bh=OpxkXqzOzw2NZxwQr5QzIuvD1a0cg0T2Wc/dcslcHLQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Bp3xkqZnPYWLFJJUMQXOLAJchFe0Iqhvh19wlJSCasbHe7K8i6iiwNcyWZ0ejhJiPfoPHpvSybbnzbPkTP7JFhzgU7BJF7MbgWGaGZeoFUVmXnyE42ERNZAJLec5tQssenMiEvx/ScF8XjzlTyoxD3fMw4edVzYhItV7O0qt12w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7YiKutG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7YiKutG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D411F000E9;
	Tue, 21 Jul 2026 18:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784657901;
	bh=qGcuozlBczXTfHMatUJ0WNv/7IHY075oZuuMRPrWZxw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V7YiKutGKxlugM9kfou50W6IbeOf+8l9gF4qDjxSGSWVDAFyAOkMmQvx8op9O/ZQu
	 CmJ/k/l6GQdh92Q+eCHFX0cD8X4I2r96ztthAsfHzqmJxVLPbR/OhgzWDKcmgVUnbn
	 iDqUqXqh7/GtoguyRrK9MK/HqbSfGRJ/GssMi7StnXBfRbO6/pl3WqbBFSQvvbEvrd
	 aRPBWrmrP3+TImv4Nii2iWBIeYDVHyl+1MQm49MzG9PaZCjf3tnzYu8eau5QMOy0bZ
	 X1OO5DL9gUeH6eM8+k0Icg1Yam9bn8MJNUVbAE+jkgD6pmUYdOlYZhXreE6vEJ5bPf
	 G6Ugg7V1T7iRQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 14/36] mm/damon: skip private node memory in DAMON
 migration and pageout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, hannes@cmpxchg.org, damon@lists.linux.dev, kvm@vger.kernel.org, tj@kernel.org, mkoutny@suse.com, linux-cxl@vger.kernel.org
In-Reply-To: <20260720193431.3841992-15-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-15-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:18:20 +0000
Message-Id: <20260721181821.45D411F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Inconsistent placement of the `folio_is_private_node()` check ca=
uses incorrect `sz_filter_passed` accounting and unnecessary filter side-ef=
fects in `damon_pa_migrate()` compared to `damon_pa_pageout()`.
--

--- Patch [14]: [PATCH v5 14/36] mm/damon: skip private node memory in DAMO=
N migration and pageout ---
commit eb373ee8a3d83be1e35d66f74d2720ee3b1c26fa
Author: Gregory Price <gourry@gourry.net>
mm/damon: skip private node memory in DAMON migration and pageout

This commit updates DAMON's physical address operations to skip private-node
folios during both migration and pageout reclaim paths.

> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index e4f98d67461f5..c741a94319750 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -250,6 +251,10 @@ static unsigned long damon_pa_pageout(struct damon_r=
egion *r,
>  			continue;
>  		}
> =20
> +		/* private node memory is not reclaimable by default */
> +		if (folio_is_private_node(folio))
> +			goto put_folio;
> +
>  		if (damos_pa_filter_out(s, folio))
>  			goto put_folio;
>  		else

[ ... ]

> @@ -344,6 +349,10 @@ static unsigned long damon_pa_migrate(struct damon_r=
egion *r,
>  		else
>  			*sz_filter_passed +=3D folio_size(folio) / addr_unit;
> =20
> +		/* private nodes do not support migration by default */
> +		if (folio_is_private_node(folio))
> +			goto put_folio;
> +

[Severity: Medium]
Does placing this check after the filter evaluation cause incorrect DAMON
statistics?

Because the check happens here rather than before the filter evaluation, it
appears unmigratable private node folios will be erroneously counted in
sz_filter_passed. This might also trigger unnecessary filter logic evaluati=
ons
before we ultimately skip the folio.

Could we move this up before damos_pa_filter_out() in damon_pa_migrate() so
it matches the logic flow used earlier in damon_pa_pageout()?

>  		if (!folio_isolate_lru(folio))
>  			goto put_folio;
>  		list_add(&folio->lru, &folio_list);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D14
