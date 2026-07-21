Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BE847127D;
	Tue, 21 Jul 2026 18:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658839; cv=none; b=oEirIUfg5Betcy9hVqrUmn21Pg4OtgAHdG8XF3P06yEvcINMl6Symxa5i2/e7q/KpBMwxC3CLFJ7v57mAmO/KmAPzG9p6MrbeR6DgkOCOz3AURSqx31ntRbBFbGoqEBTiiYPThQALoZdrODUVyN0WoOZ415YVmGrmJvQ/F3tib4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658839; c=relaxed/simple;
	bh=FMXRLIXGMqnnN6P3/gBOigAyt0GFXi7ugiSdAGU2FcY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mYYOJagqDrkRvXhv4wo0x3hf5KmL6ObpNMXgX3Fvp5IzSItqlHRH0C9DTyRr3kepFHVQ6JOTc154XQtQJTsYQIMRyU+Nrd/cOXeh2EJWCeiEOBnZXzhSZpfnic7U42Diy4EqyIGAUxfEuo5xwFSqpSmojevi70XBRjhx/sJ5bCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/+DUqXC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/+DUqXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6FF1F000E9;
	Tue, 21 Jul 2026 18:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658837;
	bh=mMUVoTN4YNssIZpwjsrCHxzKSSUTn4cmMLrXraUoFSs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f/+DUqXCGzQhS83ps3zn7gYz41rOZPlkH2hPRoPlUwklplAoNvKH+xrtZ0qBHCcID
	 abygfJSZZsQXxHHs11fZe8Z0JBpigMxYLzNMpOT72ji2QDrHfNbBoZ9RW8bO49XNFv
	 QMLDol/az2b0meRJe6RhMUhiVkUa5xveYAOOUVODmDXRDr41DDcvVsegpSlmUe3hnF
	 qhmn9aUcRDCqirfdNQPyZz8xBcvBTUZXorunGK5Lw3cMFaOj3/s8tOstxiAnAGDKl0
	 BukzztLzJzJ5SvfXwDHjQxo4RyWrbnS1E8VmlYwSHVOrZ3t6y9oVcqlbBtXDWrVclt
	 wBPEslzpqaprw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 20/36] mm/memcontrol: account private-node memory in
 per-node stats
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: tj@kernel.org, linux-cxl@vger.kernel.org, damon@lists.linux.dev, hannes@cmpxchg.org, mkoutny@suse.com, nvdimm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260720193431.3841992-21-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-21-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:33:57 +0000
Message-Id: <20260721183357.6D6FF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The patch updates `mem_cgroup_css_rstat_flush` to include `N_MEM=
ORY_PRIVATE` nodes, but misses `flush_nmi_stats()` which still strictly ite=
rates over `N_MEMORY`, leaking NMI slab stats on private nodes.
- [Medium] `hugetlb_cgroup_read_numa_stat()` in the hugetlb cgroup controll=
er skips `N_MEMORY_PRIVATE` nodes, leading to hidden node memory and incorr=
ect hierarchical totals.
--

--- Patch [20]: [PATCH v5 20/36] mm/memcontrol: account private-node memory=
 in per-node stats ---
commit 923e253e1d279f965b728ad3baafd46c0f7044eb
Author: Gregory Price <gourry@gourry.net>

mm/memcontrol: account private-node memory in per-node stats

Private nodes folios are charged like any other - the node's per-cpu
lruvec counters are increment even for N_MEMORY_PRIVATE.

[ ... ]

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f0dde52dc9e0e..4d79e238bc57d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4496,6 +4496,7 @@ static void mem_cgroup_css_rstat_flush(struct cgrou=
p_subsys_state *css, int cpu)
>  	struct mem_cgroup *parent =3D parent_mem_cgroup(memcg);
>  	struct memcg_vmstats_percpu *statc;
>  	struct aggregate_control ac;
> +	nodemask_t reportable;
>  	int nid;
> =20
>  	flush_nmi_stats(memcg, parent);

[Severity: Medium]
Will this still leak NMI slab stats on private nodes?

flush_nmi_stats() still strictly iterates over N_MEMORY instead of including
N_MEMORY_PRIVATE.

If a slab allocation occurs in NMI context on an N_MEMORY_PRIVATE node, the
node-local atomic counter is incremented, but it appears flush_nmi_stats()
will fail to drain it because it only iterates over N_MEMORY.

[ ... ]

[Severity: Medium]
Does mm/hugetlb_cgroup.c:hugetlb_cgroup_read_numa_stat() also need to be
updated to include N_MEMORY_PRIVATE?

It currently only covers N_MEMORY when calculating and printing per-node
hierarchical usage:

	for_each_node_state(nid, N_MEMORY) {
		usage =3D 0;
		...

If hugetlb memory is allocated on an N_MEMORY_PRIVATE node and charged to a
cgroup, reading the cgroup's NUMA stat file would skip accumulating or
displaying this node's usage.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D20
