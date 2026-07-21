Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B4938B133;
	Tue, 21 Jul 2026 18:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657895; cv=none; b=I4KRyTnwWjXBuvdH4Ds+LVvRhkthO68bAco36FC4BoSueC+CHfmtq+FGod4yBMT1YPqu9DNRKZXPAUQDpUHkz+d6ELHzgLGyQAElEPELYnpgXnW0JiLrNjAr96+7ediAk2hSSJi5HlYMy2hpMJyp2APk/cV6zsUA5NLFuCS+qy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657895; c=relaxed/simple;
	bh=4gzzbg/fU9CbV4STkwyy7dOquWPNue3Od/aOD81MjZw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XPjYXpweYhAR5hhvy4K1DQf9sY6WhJfyWa5byCRW9e8ZKGwidgY7pRyYmEg/ej71mViUhij+i8/Ej+b/VqHmVCQ9c6rhPRn7pCCp8f9mpnvCPIdo3srpCsMF2hlJcsH11+1shcOpFGTIoTyKEWqxTzHgVpY+zp3J5Vi4nwWBIYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZ+MJoa5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZ+MJoa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2431F000E9;
	Tue, 21 Jul 2026 18:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784657893;
	bh=kFHzSs480+7D89snZ7VkI1MHIHLkeyCx2v+qJH/8lNs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BZ+MJoa5VCCO5+hlzY8SwN21AUJdSz+xdPkC2wQs1HDjsjFbmup0fFtDHD1CNj6bp
	 gxB4T/dwqGrLCFB6B9c8zGsqkZCTEO8DMDxUFpnd6kpC2oDRMw0iJGaKYIjoV9FQF8
	 83KcgyV4KSA/x5ylDflD4Qv6tRJeYiH7QIKJIUpj0zN/youX/zXnsAk5P0kF/4Yw6h
	 q9XgSxKnJmgKMOhYZGGD/4HLPzMrnAeYvMpon/D/u1NTKAyJ36j/vXgMaRVhh4HIY7
	 tNmygJ9ZpjOzMTojkxIWxX40vNS7RllWJ2LvppJJdioDHC2dqRBGprziCw8VRPIiSG
	 JMmeMdWx7RRCw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 04/36] numa: introduce N_MEMORY_PRIVATE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, damon@lists.linux.dev, mkoutny@suse.com, hannes@cmpxchg.org, tj@kernel.org, kvm@vger.kernel.org, linux-cxl@vger.kernel.org
In-Reply-To: <20260720193431.3841992-5-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-5-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:18:13 +0000
Message-Id: <20260721181813.7B2431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Missing bounds validation on `nid` in `node_private_register()` =
and `node_private_unregister()` leads to out-of-bounds reads.
- [Medium] Lockless read of an `__rcu` pointer in `pgdat_is_private()` with=
out using `rcu_access_pointer()`.
--

--- Patch [4]: [PATCH v5 04/36] numa: introduce N_MEMORY_PRIVATE ---
commit 69b3cbf2395b52c525233c59376e585ae83c3f31
Author: Gregory Price <gourry@gourry.net>

numa: introduce N_MEMORY_PRIVATE

Some devices want to hotplug their memory onto a node, but not have it
exposed as "general purpose". This commit adds basic infrastructure for
N_MEMORY_PRIVATE nodes, intended for memory isolated from the page
allocator's normal and fallback zonelists.

> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 3da91929ad4e3..94cd51f51b7e8 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c

[ ... ]

> @@ -868,6 +869,116 @@ void register_memory_blocks_under_node_hotplug(int =
nid, unsigned long start_pfn,
>  			   (void *)&nid, register_mem_block_under_node_hotplug);
>  	return;
>  }
> +
> +static DEFINE_MUTEX(node_private_lock);
> +
> +/**
> + * node_private_register - Register a private node
> + * @nid: Node identifier

[ ... ]

> + */
> +int node_private_register(int nid, struct node_private *np)
> +{
> +	struct node_private *existing;
> +	pg_data_t *pgdat;
> +	int ret =3D 0;
> +
> +	if (!np || !node_possible(nid))
> +		return -EINVAL;

[Severity: Medium]
Could this lead to an out-of-bounds read if a driver passes an invalid nid
like NUMA_NO_NODE (-1)?=20

node_possible() and NODE_DATA() do not perform bounds checking internally.
Should we verify nid >=3D 0 && nid < MAX_NUMNODES before using it?

> +
> +	mutex_lock(&node_private_lock);
> +	mem_hotplug_begin();
> +
> +	/* N_MEMORY_PRIVATE and N_MEMORY are mutually exclusive */
> +	if (node_state(nid, N_MEMORY)) {
> +		ret =3D -EBUSY;
> +		goto out;
> +	}
> +
> +	pgdat =3D NODE_DATA(nid);

[ ... ]

> +/**
> + * node_private_unregister - Unregister a private node
> + * @nid: Node identifier

[ ... ]

> + */
> +int node_private_unregister(int nid)
> +{
> +	struct node_private *np;
> +	pg_data_t *pgdat;
> +
> +	if (!node_possible(nid))
> +		return 0;

[Severity: Medium]
Is it possible for a driver to pass NUMA_NO_NODE here as well, leading to
the same out-of-bounds read issue when node_possible() and NODE_DATA()
are evaluated?

> +
> +	mutex_lock(&node_private_lock);
> +	mem_hotplug_begin();
> +
> +	pgdat =3D NODE_DATA(nid);

[ ... ]

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 0507193b3ae34..9815e48c03b97 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h

[ ... ]

> @@ -1596,12 +1598,25 @@ typedef struct pglist_data {
>  	atomic_long_t		vm_stat[NR_VM_NODE_STAT_ITEMS];
>  #ifdef CONFIG_NUMA
>  	struct memory_tier __rcu *memtier;
> +	struct node_private __rcu *node_private;
>  #endif
>  #ifdef CONFIG_MEMORY_FAILURE
>  	struct memory_failure_stats mf_stats;
>  #endif
>  } pg_data_t;
> =20
> +#ifdef CONFIG_NUMA
> +static inline bool pgdat_is_private(pg_data_t *pgdat)
> +{
> +	return !!pgdat->node_private;

[Severity: Medium]
Does this lockless read of the __rcu pointer require rcu_access_pointer()?

Without it, sparse will likely complain about an __rcu address space
violation, and we might be missing the READ_ONCE() barrier that prevents
compiler load tearing.

> +}
> +#else
> +static inline bool pgdat_is_private(pg_data_t *pgdat)
> +{
> +	return false;
> +}
> +#endif

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D4
