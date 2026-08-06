Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDFB3EE1F2;
	Thu,  6 Aug 2026 08:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786004546; cv=none; b=KEmZhSvMHMic653FV9uwEi99fLskyCCV3ACdB2gLC20hKPGfM8cB0YHschLgDVG9eCW6aBfaXGT4u4DZYfXxcrpmH6u8jWq2QkaV/N7ln2ZUqGvf7097bxPrqgOpe6rL5R9jowoC9WS2j5tKtuPPlbkNUze8RRSMz01HKZvk8lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786004546; c=relaxed/simple;
	bh=+T7ts7jj8J7TJqgn05MYlwG0vLHgiIi6KRYzwr7P3+0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rYHnasvIzXApK9O7vHhXw/dq1J85y1EfJwG5ka5On1VdC9q1D/p4Smoqg6ZRqA1/r5r3v+Hsd8mc6/ikmk/SiKHfq+2lQZVa+YmHotjZwGnRVCLd/1FLsbDoBj4wfmg4GEPSxkkYtt6bjpQPjuXNp7J5CSRoqnkwMTY//lfmjhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LTo8cf7X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LTo8cf7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAC71F00A3A;
	Thu,  6 Aug 2026 08:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786004544;
	bh=IwfKdcVth4r33t+a87qPJjep6NtBPmiLOIduzqAySrg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LTo8cf7XGwnkX3pjcWKKWtf+LqBR0y+HbhXhKDt5+77OEDuAsXu1J82jOntLfWa75
	 cF/f+XiNP+ysu+mScgPkwzG0DhBOWp2rPAzKQNeemTlmgsA1jninwm2YbZ8JYDyw3O
	 jcO+G2Dr9e3+lgQ1+ZESPKgcP03IX4PpPLQTfSxrvnt5LHb2yLThCgFDnVWFigL4P0
	 PpuHPbIqsI42gFzgnkw3uJNmLKX/iP7BWDDZ/ozMzKLYWXe9hsAY74WDF6YvxEnyjH
	 rudLwponeactKNC0CAYhDlV3mxjJPkEFj2mYxuKyiRDGCTaaSvj7vAAGRegDrqlHkr
	 gGOP2yBzEMDhQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/4] mm/numa: introduce nearest_nodes_nodemask()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rakie Kim" <rakie.kim@sk.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260806080936.421-2-rakie.kim@sk.com>
References: <20260806080936.421-1-rakie.kim@sk.com>
 <20260806080936.421-2-rakie.kim@sk.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 08:22:24 +0000
Message-Id: <20260806082224.AFAC71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The function fails silently if the input and output nodemasks al=
ias, wiping the input.
- [Low] The non-NUMA fallback implementation incorrectly reports an empty m=
ask for valid inputs.
--

--- Patch [1]: [PATCH 1/4] mm/numa: introduce nearest_nodes_nodemask() ---
commit 5ec50dc5c5bbc33fbae64a16296aa9f2dc086600
Author: Rakie Kim <rakie.kim@sk.com>

mm/numa: introduce nearest_nodes_nodemask()

This commit introduces nearest_nodes_nodemask(), a helper function that
finds all candidate nodes in a given nodemask located at the minimum
distance from a source node. It updates an output nodemask with the complete
set of nearest nodes, returning 0 on success.

> diff --git a/include/linux/numa.h b/include/linux/numa.h
> index e6baaf6051bcf..4f2a0c344122a 100644
> --- a/include/linux/numa.h
> +++ b/include/linux/numa.h
[ ... ]
> @@ -54,6 +56,15 @@ static inline int nearest_node_nodemask(int node, node=
mask_t *mask)
>  	return NUMA_NO_NODE;
>  }
> =20
> +static inline int nearest_nodes_nodemask(int node, const nodemask_t *mas=
k,
> +					 nodemask_t *out)
> +{
> +	if (!out)
> +		return -EINVAL;
> +	nodes_clear(*out);

[Severity: Low]
On systems with CONFIG_NUMA disabled, there is only a single implicit node
(Node 0). If a caller passes an input mask containing Node 0, that node is
trivially the nearest.

Should this fallback stub preserve the valid node from the input mask
instead of unconditionally clearing the output mask and falsely reporting no
nearest nodes?

> +	return 0;
> +}
> +
>  static inline int memory_add_physaddr_to_nid(u64 start)
>  {
>  	return 0;
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 4e4421b22b59f..19417b0afc30b 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
[ ... ]
> +int nearest_nodes_nodemask(int node, const nodemask_t *mask, nodemask_t =
*out)
> +{
> +	int dist, n, min_dist =3D INT_MAX;
> +
> +	if (!out)
> +		return -EINVAL;
> +
> +	nodes_clear(*out);

[Severity: Medium]
What happens if a caller attempts to filter a nodemask in-place by passing
the same pointer for both the input and output masks?

In-place filtering is a common pattern in the kernel (for example, with
nodes_and()), but if nearest_nodes_nodemask(node, &my_mask, &my_mask) is
called, this initial nodes_clear(*out) will wipe out the input mask before
the loop even begins iterating.

> +
> +	for_each_node_mask(n, *mask) {
> +		dist =3D node_distance(node, n);
> +
> +		if (dist < min_dist) {
> +			min_dist =3D dist;
> +			nodes_clear(*out);

[Severity: Medium]
Similarly, if the input and output pointers alias, clearing the output mask
dynamically here destroys the remaining iteration state for the for_each
loop.

Could this be avoided by using a temporary nodemask on the stack,
and copying it to *out at the end of the function?

> +			node_set(n, *out);
> +		} else if (dist =3D=3D min_dist) {
> +			node_set(n, *out);
> +		}
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nearest_nodes_nodemask);
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806080936.421-=
1-rakie.kim@sk.com?part=3D1
