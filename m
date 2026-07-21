Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC64446A60E;
	Tue, 21 Jul 2026 19:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662135; cv=none; b=nZ9ystnkRnbUl9Qn/8tIy1q2iubFFqraHnGA+Ha8g7g+msKWgkwpDrMFBfATR8GnRtWjrldJ5CINy47+WzfKOCezMChjyfFXcppks1JaX9lTod82GOOcqWV5VtSWjPA5V0h6lVDqOLISYtIZonzwKuPuv3fv2ZHroCNrVvDSH7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662135; c=relaxed/simple;
	bh=QMCq+RKo4bHlm+lamDI+rvjYnjmBN94nFPwGsjgKs8c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K95n402Mkn0NuWoyAFtNte4cDk+p+J5sbG3BAbU9QtueBHEGBEmHOAHKzOMMTAbzBxA5fw1QEJw1XC8Bu7WhsXzYM3xO4hCogkB2SZ6pIrftOV7n6VKkl3x0bfiz4+7PIahiTzxGapd8B/pkLpUqlaijEd/Ou8uvMwnmWUz7NfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=An4ltFKU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="An4ltFKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255791F00A3A;
	Tue, 21 Jul 2026 19:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784662133;
	bh=KYmMWCnj3j2QdehaNmGJ/JiFnPpCq9HhnEz6R1mUG3k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=An4ltFKUlgKObGuBoFvVE6viQT/G5Q1n3TR615McHUn23uo+GKVsIw/PqdCzlzKJ/
	 F2XyVwnCIF71SI50hIEe0yn0AE89vHYayB4u19GN8osrMO787iHmA6eVzM5Bu631uz
	 mrT/aDpj2fYPTmHBisOWr92FfbIJWpyqBb+V6gw4RCN6lFp19NzOtliexE3m6NS4w6
	 6INhIkdx0Gcqim3qilUYL2jSvglY9PUGhxlRgY/ogcIRBmzwlzXBZww82LOLvWCflz
	 x38DHhdBW9K/Luyv0IAK+OXMU6NDECWApjzxShynqg/0fSl0c+HYoeEpG3K9AyHJeL
	 xm+rX35sybbXQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 22/36] mm/mempolicy: add MPOL_F_PRIVATE and zonelist
 selection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: damon@lists.linux.dev, hannes@cmpxchg.org, kvm@vger.kernel.org, tj@kernel.org, mkoutny@suse.com, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260720193431.3841992-23-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-23-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 19:28:52 +0000
Message-Id: <20260721192853.255791F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] Private nodes are permanently lost from MPOL_F_STATIC_NODES polici=
es during memory offlining/rebinding.
- [High] Mempolicies targeting private nodes will silently fail to allocate=
 from them due to cpuset restrictions.
- [Medium] Non-atomic clearing of MPOL_F_PRIVATE in pol->flags causes a dat=
a race with lockless page allocators.

Pre-existing issues:
- [High] Lockless and unprotected access to pol->nodes in alloc_pages_bulk_=
interleave can lead to a divide-by-zero crash.
- [High] Unconditional GFP_KERNEL allocation in alloc_pages_bulk_weighted_i=
nterleave violates caller's GFP constraints.
--

--- Patch [22]: [PATCH v5 22/36] mm/mempolicy: add MPOL_F_PRIVATE and zonel=
ist selection ---
commit 11224b898bbcf008cfe6641a6cd14bd637edb1d1
Author: Gregory Price <gourry@gourry.net>

mm/mempolicy: add MPOL_F_PRIVATE and zonelist selection

This patch adds MPOL_F_PRIVATE to mempolicy flags to identify policies
containing private nodes, allowing private node memory to be reachable.
It also plumbs zonelist selection into the mempolicy allocator interfaces
using the alloc_flags mechanism.

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 2b76c57a460c9..90110e9761122 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c

[ ... ]

> @@ -505,22 +509,33 @@ static void mpol_rebind_default(struct mempolicy *p=
ol, const nodemask_t *nodes)
> =20
>  static void mpol_rebind_nodemask(struct mempolicy *pol, const nodemask_t=
 *nodes)
>  {
> -	nodemask_t tmp;
> +	nodemask_t tmp, priv;
> +
> +	/* preserve online private nodes to re-add later */
> +	nodes_and(priv, pol->nodes, node_states[N_MEMORY_PRIVATE]);

[Severity: High]
Does this evaluate private nodes against pol->nodes instead of=20
pol->w.user_nodemask?

If a private node targeted by an MPOL_F_STATIC_NODES policy goes offline,=20
it is removed from pol->nodes. When the node comes back online and=20
mpol_rebind_nodemask() runs, attempting to restore private nodes from=20
pol->nodes will find it empty.=20

Could this result in permanent loss of private nodes from static policies?

>  	if (pol->flags & MPOL_F_STATIC_NODES)
>  		nodes_and(tmp, pol->w.user_nodemask, *nodes);

[ ... ]

> -	if (nodes_empty(tmp))
> +	/* private nodes are identity-mapped during remap, drop them here */
> +	nodes_and(tmp, tmp, node_states[N_MEMORY]);
> +	if (nodes_empty(tmp) && nodes_empty(priv))
>  		tmp =3D *nodes;
> =20
> -	pol->nodes =3D tmp;
> +	/* If any online private nodes remain, add them back */
> +	nodes_or(pol->nodes, tmp, priv);
> +	/* If no online private nodes remain, strip the private flag */
> +	if (nodes_empty(priv))
> +		pol->flags &=3D ~MPOL_F_PRIVATE;

[Severity: Medium]
Does clearing MPOL_F_PRIVATE non-atomically create a data race with lockles=
s=20
page allocators?

When mpol_alloc_flags() concurrently reads (pol->flags & MPOL_F_PRIVATE)=20
locklessly in the page allocator fastpath, could this result in torn reads=
=20
and trigger KCSAN warnings?

>  }

[ ... ]

> @@ -2488,7 +2513,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, uns=
igned int order,
>  		}
>  	}
> =20
> -	page =3D __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, ALLOC_D=
EFAULT);
> +	page =3D __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, aflags);

[Severity: High]
For MPOL_BIND policies, will cpuset_nodemask_valid_mems_allowed() return=20
false because private nodes are excluded from cpuset.mems, setting nodemask=
=20
to NULL?

When a NULL nodemask is passed to the allocator, the fastpath defaults to=20
cpuset_current_mems_allowed with ALLOC_CPUSET. Since private nodes are=20
absent from the cpuset, won't __cpuset_zone_allowed() skip the private=20
nodes regardless of ALLOC_ZONELIST_PRIVATE?

Will mempolicies targeting private nodes silently fail to allocate from the=
m=20
and fall back to standard nodes?

>  	if (unlikely(pol->mode =3D=3D MPOL_INTERLEAVE ||

[ ... ]

> @@ -2597,6 +2622,7 @@ static unsigned long alloc_pages_bulk_interleave(gf=
p_t gfp,
>  		struct mempolicy *pol, unsigned long nr_pages,
>  		struct page **page_array)
>  {
> +	unsigned int aflags =3D mpol_alloc_flags(pol);
>  	int nodes;
>  	unsigned long nr_pages_per_node;

[Severity: High]
This isn't a bug introduced by this patch, but is it safe to read pol->node=
s=20
locklessly in alloc_pages_bulk_interleave()?

alloc_pages_bulk_interleave() reads the nodemask word-by-word via=20
nodes_weight(pol->nodes) further down in this function.
Concurrently, mpol_rebind_nodemask() mutates pol->nodes word-by-word via=20
nodes_or(pol->nodes, tmp, priv).

On systems with >64 nodes, could a torn read result in a weight of 0,=20
causing a divide-by-zero panic when calculating=20
nr_pages_per_node =3D nr_pages / nodes?

[ ... ]

> @@ -2632,6 +2658,7 @@ static unsigned long alloc_pages_bulk_weighted_inte=
rleave(gfp_t gfp,
>  		struct mempolicy *pol, unsigned long nr_pages,
>  		struct page **page_array)
>  {
> +	unsigned int aflags =3D mpol_alloc_flags(pol);
>  	struct weighted_interleave_state *state;
>  	struct task_struct *me =3D current;

[Severity: High]
This is a pre-existing issue, but does alloc_pages_bulk_weighted_interleave=
()=20
violate the caller's GFP constraints?

This function can be called via alloc_pages_bulk_mempolicy_noprof() from=20
vmalloc with restrictive flags like GFP_NOFS or GFP_NOIO. However, it=20
allocates its weights array unconditionally using=20
kzalloc(nr_node_ids, GFP_KERNEL) later in the function.

Could this strip the __GFP_FS or __GFP_IO protection and allow the=20
allocation to recurse into the filesystem or block layer, potentially=20
causing a deadlock?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D22
