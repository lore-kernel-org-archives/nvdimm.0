Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB44038910F;
	Tue, 21 Jul 2026 18:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658999; cv=none; b=KjKj3YL5hTxFPf3svHI9lqtmKcS8kHbJlFsOi9YQML4r5SyDN2lIc/L3ElKlRlLpUFghj8+mt2kjNHStdShCqLm2RDYsgAvUbsflJ2MyKhOE2spGJq26tQEhi+B+Cl9J0yHSBssW97NQB8+FVTYxWoVqLtDUzrDMnKCOnY2p/3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658999; c=relaxed/simple;
	bh=YXMza/EmZuTTK/gvmrxgWv2V2x5keDs8ct6egV2VIPc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TL13O20C8xGywuwKjUiCMdG6o9Fwvho7DNAnFv3SyzIVRqLWapkxGp5DIqkIbB666WO/uSnMpHACUHxrcK3t2v41EdgVh0cVW028wM1gcMlmrINAC8ZcLchauLDTQq5dE89rBim7a68npI+6wk19TJnZl8fczz2uWicx+SYZInY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEQf2yuW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEQf2yuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200901F00A3A;
	Tue, 21 Jul 2026 18:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658998;
	bh=g/EKxLRn1RNI6mC5/dfd1RUl/MEC5S6QwBGORwxGQhw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dEQf2yuWPFamG/6aAVapy6JRReGuVfPQWGhIsVNtX+RPXLRbJB1Cvhn3jCZDtTJlx
	 v0NLxCFAxAb/41lx67CQiSq9+mX+Ye3EcGmvv4H2HHX+v0DMLEWda5m0NJtzL23OOr
	 CBiNCw3zzwq2PhFVAuiminh7lwH2gxvaglTPwfGER0upfbfo430SwQ7/tki5+zV0cu
	 oVPoB5j7bLkm45hUmL3EXWZA3FtxzZoCw1dKxgGVS4On//mCFvUVLyVHbIcZt06bNh
	 s4v9tvs4vIRqHA5rVDWIE0JfhXTPgJko4upaoj4uGpnhRBuUi9/YX8WXBxL6Brm5e6
	 CH0YRaKRUGiTw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 24/36] mm/mempolicy: add in-kernel MPOL_BIND
 interfaces for drivers/services
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, kvm@vger.kernel.org, hannes@cmpxchg.org, linux-cxl@vger.kernel.org, tj@kernel.org, damon@lists.linux.dev, mkoutny@suse.com
In-Reply-To: <20260720193431.3841992-25-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-25-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:36:37 +0000
Message-Id: <20260721183638.200901F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] `mpol_bind_node()` and `mpol_private_bind()` fail to validate `nid=
` against bounds, leading to stack buffer overflows and out-of-bounds reads.
- [Medium] `__mpol_bind_node()` calls `mpol_set_nodemask()` without holding=
 `task_lock(current)` or `mmap_lock`, causing a data race and potential tor=
n read.
- [Medium] `mpol_bind_node()` unconditionally rejects private node bindings=
, breaking the documented API contract.
--

--- Patch [24]: [PATCH v5 24/36] mm/mempolicy: add in-kernel MPOL_BIND inte=
rfaces for drivers/services ---
commit 056427d8f98ec56375b0a715f69798d4dfde2ec3
Author: Gregory Price <gourry@gourry.net>

mm/mempolicy: add in-kernel MPOL_BIND interfaces for drivers/services

This patch adds and exports interfaces to enable modules to build MPOL_BIND
mempolicies pinned to a private NUMA node. It exports mpol_bind_node() and
mpol_private_bind() for module use, widens the __mpol_put() export, and
adjusts mpol_set_nodemask() to handle MPOL_F_PRIVATE flags.

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index e83c2c7a94c1d..a3ffb09897489 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -432,6 +432,18 @@ static int mpol_set_nodemask(struct mempolicy *pol,
>  	else
>  		pol->w.cpuset_mems_allowed =3D cpuset_current_mems_allowed;
> =20
> +	/*
> +	 * Private nodes are not in cpuset.mems, so they're always stripped.
> +	 * Driver-allocated policies will already have MPOL_F_PRIVATE set,
> +	 * if that's the case, add back in the requested set of private nodes.
> +	 */
> +	for_each_node_mask(nid, *nodes) {
> +		if (!node_is_private(nid))
> +			continue;
> +		if (pol->flags & MPOL_F_PRIVATE)
> +			node_set(nid, nsc->mask2);
> +	}

[Severity: Medium]
The commit message mentions that N_MEMORY_PRIVATE node bindings are honored
if the node has CAP_USER_NUMA. Does this implementation actually perform th=
at
capability check?

It looks like this only checks for MPOL_F_PRIVATE. If mpol_bind_node() calls
__mpol_bind_node() with flags=3D0, wouldn't the private node be stripped
unconditionally, causing the nodemask to become empty and returning -EINVAL?

[ ... ]

> +static struct mempolicy *__mpol_bind_node(int nid, unsigned short flags)
> +{
> +	struct mempolicy *pol;
> +	nodemask_t nodes;
> +	int err;
> +
> +	NODEMASK_SCRATCH(scratch);
> +
> +	if (!scratch)
> +		return ERR_PTR(-ENOMEM);
> +
> +	nodes_clear(nodes);
> +	node_set(nid, nodes);

[Severity: High]
Should nid be validated against MAX_NUMNODES before being used?

If an invalid or unsanitized node ID like NUMA_NO_NODE (-1) or a value
greater than MAX_NUMNODES is passed from a module, could node_set()
perform an out-of-bounds write on the stack-allocated nodemask_t?

> +
> +	pol =3D mpol_new(MPOL_BIND, flags, &nodes);
> +	if (IS_ERR(pol)) {
> +		NODEMASK_SCRATCH_FREE(scratch);
> +		return pol;
> +	}
> +
> +	err =3D mpol_set_nodemask(pol, &nodes, scratch);

[Severity: Medium]
Does this call to mpol_set_nodemask() need to hold task_lock(current) or
mmap_lock?

mpol_set_nodemask() reads cpuset_current_mems_allowed (current->mems_allowe=
d).
Without locking, couldn't this race with concurrent cpuset updates and resu=
lt
in a torn read or corrupted mempolicy nodemask?

> +	NODEMASK_SCRATCH_FREE(scratch);
> +	if (err) {
> +		mpol_put(pol);
> +		return ERR_PTR(err);
> +	}
> +	return pol;
> +}
> +
> +/**
> + * mpol_private_bind - build an MPOL_BIND policy pinned to a private node
> + * @nid: an N_MEMORY_PRIVATE node
> + *
> + * Returns a refcounted mempolicy that binds allocations to @nid with the
> + * private-placement intent (MPOL_F_PRIVATE).  This binds to @nid regard=
less
> + * of the node's CAP_USER_NUMA, providing a privileged way for node-owne=
rs
> + * to bind driver/service owned VMAs to the node.
> + *
> + * Like any MPOL_BIND it is relaxable: an unsatisfiable request falls ba=
ck
> + * rather than failing.
> + *
> + * Must be called while @nid is N_MEMORY_PRIVATE.
> + *
> + * The caller owns the reference and frees it with mpol_put().
> + *
> + * Return: the policy, or an ERR_PTR on failure.
> + */
> +struct mempolicy *mpol_private_bind(int nid)
> +{
> +	if (!node_is_private(nid))

[Severity: High]
Similar to the issue in __mpol_bind_node(), if an invalid nid is passed in,
could node_is_private() read out of bounds?

> +		return ERR_PTR(-EINVAL);
> +	return __mpol_bind_node(nid, MPOL_F_PRIVATE);
> +}
> +EXPORT_SYMBOL_FOR_MODULES(mpol_private_bind, "kmem");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D24
