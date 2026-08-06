Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6E03E717A;
	Thu,  6 Aug 2026 08:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786004938; cv=none; b=XDdcBJbDuwx19D7dgzm11qRaQa8Lmb/6WApmvYJTEOx7u6kOFmE9mLC16eaM2QfSFcc7dTZAwVazHjqb8xsee+9/O5IBjofg/yvVxE2L/xGz37bkk5h8BH5yjo6sCjgDxJ8xeF9sBRZv7+uNfoEtBC0uj+fqdqhiggM/eroaLl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786004938; c=relaxed/simple;
	bh=1oPuFXZFfpMb56zKnqp7rfRn5MUmPR/E1uCDbP3bugI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ad5tbX6VCfeZT3hwUbL6dPa5xrhgRAD1xGYIkR9gk11zS8s2ELRSlAQeEZRemQLlAca4UQCUcD+N/pytC/fhTBXzo48y+QOTstimayln2pT7ZYZ1cZ1Cne5uTRf7Q18Sce8BjacdSRlx0FkPXSkq3uzBs7Xq41rbeFAovq/DXaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Az5IUPSj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Az5IUPSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD441F000E9;
	Thu,  6 Aug 2026 08:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786004936;
	bh=ZsYv+4cj5mKOkcO7MJ39AFoWuRywmA+nK6ZEabG5gHE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Az5IUPSjcDZdrLa3aksp0tGAgge3TLAvvPbiYZWkfSBGwDDvLmhS5wINudae/ozlD
	 +lh/5/Q2K/8JwcSwE3bhmwoshKR072m6fzpEzW43qHjqzWf3tIdPsJM26vhzw0WZK/
	 OoMK0fbHhnuAoy+Btjr6EYvqBnIsfrVjLZxaPq5wdwsOhep7sg8nABsOu9wMHgQeQE
	 RQrAagCcTUgDyCDCBmfqJSy8ukc62zkSkRd9cNELJNc2ZyZSZVmvFZTQpJVPo/t59R
	 W8EOEr2djrfATxbKMBauxI9j+kr7rfYMrNNiDccdNhli7wYGKCa+S1oiye8dSxUfy9
	 3p0NoISH+Pqag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] mm/mempolicy: enhance weighted interleave with
 package-aware locality
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rakie Kim" <rakie.kim@sk.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260806080936.421-5-rakie.kim@sk.com>
References: <20260806080936.421-1-rakie.kim@sk.com>
 <20260806080936.421-5-rakie.kim@sk.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 08:28:56 +0000
Message-Id: <20260806082856.9BD441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Package-aware weighted interleave silently degrades to flat mode o=
n memoryless CPU nodes because they are not registered in the package topol=
ogy.
- [Medium] Unstabilized TOCTOU access of `policy->nodes` in `policy_resolve=
_package_nodes()` can cause torn reads and inconsistent node intersection i=
f the policy is concurrently modified.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the function `al=
loc_pages_bulk_weighted_interleave` unconditionally uses `GFP_KERNEL` for a=
 `kzalloc` call, which can cause a sleep-in-atomic bug if invoked with a no=
n-blocking `gfp` mask.
--

--- Patch [4]: [PATCH 4/4] mm/mempolicy: enhance weighted interleave with p=
ackage-aware locality ---
commit 9bf854e133ba0fbe547595b9d47a304b6f619169
Author: Rakie Kim <rakie.kim@sk.com>

mm/mempolicy: enhance weighted interleave with package-aware locality

This commit introduces a package-aware mode for weighted interleave, aiming
to prioritize local nodes within the same package over remote nodes to
preserve bandwidth. The mode is opt-in via sysfs and restricts allocations
to the NUMA nodes of the task's current package.

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 19417b0afc30b..66bccb9a0a191 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c

[ ... ]

> @@ -2138,17 +2146,97 @@ bool apply_policy_zone(struct mempolicy *policy, =
enum zone_type zone)
>  	return zone >=3D dynamic_policy_zone;
>  }
> =20
> +/**
> + * policy_resolve_package_nodes - Restrict policy nodes to the current p=
ackage
[ ... ]
> + */
> +static int policy_resolve_package_nodes(struct mempolicy *policy, nodema=
sk_t *mask)
> +{
> +	nodemask_t package_mask;
> +	int node, ret;
> +
> +	if (!policy || !mask)
> +		return -EINVAL;
> +
> +	nodes_clear(*mask);
> +
> +	node =3D numa_node_id();
> +	ret =3D mp_get_package_nodes(node, &package_mask);

[Severity: High]
Will mp_get_package_nodes() fail and return an error for memoryless CPU
nodes?

Since memoryless CPU nodes are excluded from being registered into memory
packages by memory_package_init() because they lack N_MEMORY, it appears
this lookup will fail. Does this cause the package-aware interleave feature
to silently degrade and fall back to the unconstrained flat mode when a task
executes on a CPU node with no local memory (such as a compute die accessing
separate CXL memory)?

> +	if (ret)
> +		return ret;
> +
> +	nodes_and(*mask, package_mask, policy->nodes);

[Severity: Medium]
Is it safe to directly read policy->nodes multiple times here without first
stabilizing it into a local copy?

If policy->nodes is concurrently modified (for example, via sys_mbind() on a
shared VMA policy), a modification occurring between this first nodes_and()
check and the fallback first_node() or nodes_and() calls below might cause
the logic to observe mixed states.

Could this result in an inconsistent node intersection or an incorrect
fallback node being selected?

> +	if (!nodes_empty(*mask))
> +		return 0;
> +
> +	/*
> +	 * The user's nodemask excludes every node of the current package;
> +	 * fall back to the package spanned by the user's own first node.
> +	 */
> +	node =3D first_node(policy->nodes);
> +	ret =3D mp_get_package_nodes(node, &package_mask);
> +	if (ret)
> +		return ret;
> +
> +	nodes_and(*mask, package_mask, policy->nodes);
> +	if (nodes_empty(*mask))
> +		return -ENOENT;
> +
> +	return 0;
> +}

[ ... ]

> @@ -2695,7 +2807,7 @@ static unsigned long alloc_pages_bulk_weighted_inte=
rleave(gfp_t gfp,
>  	/* read the nodes onto the stack, retry if done during rebind */
>  	do {
>  		cpuset_mems_cookie =3D read_mems_allowed_begin();
> -		nnodes =3D read_once_policy_nodemask(pol, &nodes);
> +		nnodes =3D read_once_policy_package_nodemask(pol, &nodes);
>  	} while (read_mems_allowed_retry(cpuset_mems_cookie));
> =20
>  	/* if the nodemask has become invalid, we cannot do anything */

[Severity: High]
This isn't a bug introduced by this patch, but does this function safely
handle atomic allocations?

Further down in alloc_pages_bulk_weighted_interleave(), the weights array
is allocated unconditionally with GFP_KERNEL:

    weights =3D kzalloc(nr_node_ids, GFP_KERNEL);
    if (!weights)
            return total_allocated;

If alloc_pages_bulk() is called from an atomic context with a non-blocking
mask like GFP_ATOMIC or GFP_NOWAIT, will ignoring the passed gfp argument a=
nd
using GFP_KERNEL here cause a 'scheduling while atomic' panic or deadlock?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806080936.421-=
1-rakie.kim@sk.com?part=3D4
