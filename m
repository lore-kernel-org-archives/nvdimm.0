Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B813D47BF;
	Thu,  6 Aug 2026 08:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786004572; cv=none; b=RzOhX7FTLX/KKT5MseemATadbmwYJ8+H9iXfyqu7ey8iktCBfLMaCCCwy3jV9WZtPnac63jq3NsuEBgxYHCOz/526hLZMze2NVLXqlkSj3OMsov/jE75JBwNE6PK+di+PimcpqkXDsAV3772Xn65+eMZhLsmPchuLCgCWU6b+fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786004572; c=relaxed/simple;
	bh=F8gracIOOK3YvYuu6cobwXngqeRdk9BtV4yx/vE9hQU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=te8nzbB+dOM75QqebQdJfU4ZyvJK9VcATkceaHs+L1Y6ePIzNBYA3VM8JcGgafz+gFjA9VQhUE7RZnKkHXUkM+zwUsOhnrpUQtzELSYx5Y0GuE+rb9WtOB0Z45hIkMDsNKygxftZ28mCeQxmjCjIQn8WLaS0aqnrmGqXJVNW4ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DvI+Q4Gw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DvI+Q4Gw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412451F000E9;
	Thu,  6 Aug 2026 08:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786004571;
	bh=+EKhRSg84Kcs8XU1yEB0d78aA2CoOYQqJAP+TrV/l9U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DvI+Q4Gw6AVveoHLX4IqGnjr4SLAiTd4KH2UeWtV5cqMr/AuZncRYC5J3coeTeBwQ
	 HcLz/ckQNCO2PTMWYF5nAihB40Ab4knH8kIl6igMGIjZDRy4KVxyfjwmi4m1375EIx
	 99AgGBj/9JqwzCl4aZhNvb1CRyV+9Is9PHsIlnysXg8PluTpFyWwNwqnWXs6JEUHIj
	 KFozv9F28Dhy4tfEBdovmITpDLGqk22tstYIJWDOwJP38W3VvYH+u8RZXqooH7RAqy
	 5BfxTPqUGKdpJjsn70QMNAYTSQCJd4yGZL/zc8l6VwXvNoPFbwfKbFr5f76V7NAJZR
	 5DNxYjF7H39Mg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] mm/memory-tiers: introduce package-aware topology
 management for NUMA nodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rakie Kim" <rakie.kim@sk.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260806080936.421-3-rakie.kim@sk.com>
References: <20260806080936.421-1-rakie.kim@sk.com>
 <20260806080936.421-3-rakie.kim@sk.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 08:22:50 +0000
Message-Id: <20260806082251.412451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 10 potential issue=
(s) to consider:
- [High] CPU nodes without local memory are completely excluded from the pa=
ckage topology.
- [High] Upgrading a provisional SLIT entry permanently unbinds and orphans=
 the node.
- [High] TOCTOU race in `bind_node_to_package` binds a newly upgraded node =
to the wrong package.
- [High] `unbind_node_to_package` clears the node from the wrong nodemask i=
f the node's state changed, permanently leaking the package.
- [High] `memory_package_lock` is acquired in a reclaim path while also bei=
ng held during a GFP_KERNEL allocation, causing a deadlock.
- [Medium] Initialization loop in memory_package_init() permanently leaks k=
objects and sysfs devices on failure.
- [Medium] Mixing goto-based error handling with scope-based guard() violat=
es strict cleanup guidelines.
- [Medium] Global topology symmetry state is not recalculated when a provis=
ional node is dropped.
- [Medium] The package notifier chain is exported but never invoked during =
node creation.
- [Medium] Exported API `mp_add_package_node_by_initiator` lacks bounds che=
cking on `nid`, causing an out-of-bounds array access.
--

--- Patch [2]: [PATCH 2/4] mm/memory-tiers: introduce package-aware topolog=
y management for NUMA nodes ---
commit 0e269cf99bac40f9c00f53199f76f3781bc439c6
Author: Rakie Kim <rakie.kim@sk.com>
Date:   Thu Aug 6 08:09:33 2026 +0000

    mm/memory-tiers: introduce package-aware topology management for NUMA n=
odes
   =20
    The NUMA distance model provides only relative latency values between n=
odes
    and has no notion of structural grouping. Memory policies based on dist=
ance
    alone therefore cannot tell which nodes are local to the same physical
    package and which belong to a different one, which limits how well they=
 can
    keep placement and migration within a package.
   =20
    Introduce a package-aware topology layer that groups NUMA nodes into a
    "memory package": a set of CPU nodes and their local memory-only nodes
    (such as CXL or HBM). A subsystem that owns a node registers a resolver=
 to
    supply its package, and a policy can query, for any node, the other nod=
es
    that belong to the same package.

> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> index 54851d8a195b0..5932df315604a 100644
> --- a/mm/memory-tiers.c
> +++ b/mm/memory-tiers.c

[ ... ]

> +static void mp_snapshot_rebuild(void)
> +{
> +	struct mp_snapshot *new, *old;
> +	struct memory_package *mp;
> +	int nr =3D 0, i =3D 0, nid;
> +
> +	lockdep_assert_held(&memory_package_lock);
> +
> +	list_for_each_entry(mp, &memory_packages, list)
> +		nr++;
> +
> +	new =3D kvzalloc(struct_size(new, pkg, nr), GFP_KERNEL);

[Severity: High]
Could this allocation trigger a deadlock?

The memory_package_lock is held here during a GFP_KERNEL allocation, which
can trigger direct reclaim. However, the same lock is acquired in
__mp_get_preferred_nodemask() during memory demotion, which runs in reclaim
context.=20

If direct reclaim attempts to acquire the already held lock, will it
cause a self-deadlock?

> +	if (!new)
> +		return;

[ ... ]

> +static int bind_node_to_package(int nid)
> +{
> +	int package_id, pkg_id;
> +	struct memory_package *mp;
> +	nodemask_t nodes, cpu, mem;
> +
> +	mutex_lock(&memory_package_lock);
> +	if (!mpns[nid]) {
> +		mutex_unlock(&memory_package_lock);
> +		return -EINVAL;
> +	}
> +	package_id =3D mpns[nid]->package_id;
> +	mutex_unlock(&memory_package_lock);
> +
> +	mp =3D find_create_memory_package(package_id);
> +	if (IS_ERR(mp))
> +		return PTR_ERR(mp);
> +
> +	mutex_lock(&memory_package_lock);
> +	if (!mpns[nid]) {
> +		mutex_unlock(&memory_package_lock);
> +		return -ENOENT;
> +	}
> +	mpns[nid]->package =3D mp;

[Severity: High]
Is there a race condition when the lock is dropped and reacquired?

If a concurrent driver probe calls mp_add_package_node_by_initiator() while
the lock is dropped, it might destroy the old mpns[nid] and create a new one
with a different package_id.

When the lock is reacquired, mpns[nid] is not NULL, but could we end up
binding the new node (which wants the new package ID) to the old package=20
struct that we just fetched?

> +	node_set(mpns[nid]->nid, mp->nodes);

[ ... ]

> +static void unbind_node_to_package(struct memory_package *mp, int nid)
> +{
> +	lockdep_assert_held(&memory_package_lock);
> +
> +	node_clear(nid, mp->nodes);
> +	if (node_state(nid, N_CPU))
> +		node_clear(nid, mp->cpu_nodes);
> +	else
> +		node_clear(nid, mp->memory_only_nodes);

[Severity: High]
Does this clear the node from the correct nodemask if its state changed?

If a memory-only node was initially added to mp->memory_only_nodes, but CPUs
were later hot-added to it, node_state(nid, N_CPU) will now evaluate to tru=
e.

During a subsequent hot-remove, this will clear the bit from mp->cpu_nodes
instead of mp->memory_only_nodes, leaving the bit permanently set and
potentially leaking the kobject.

> +
> +	if (mpns[nid])
> +		list_del(&mpns[nid]->package_entry);
> +
> +	update_package_preferred(mp);
> +}
> +
> +static struct memory_package_node *create_package_node(int nid, int init=
iator_nid)
> +{
> +	int cpu_nid, package_id;
> +	int source_flags;
> +	struct memory_package_node *mpn;
> +
> +	if (node_state(nid, N_CPU)) {
> +		cpu_nid =3D nid;
> +		source_flags =3D MPN_SRC_CPU;
> +	} else {
> +		if (initiator_nid >=3D 0) {
> +			cpu_nid =3D initiator_nid;
> +			source_flags =3D MPN_SRC_INITIATOR;
> +		} else {
> +			/*
> +			 * No driver-supplied initiator: fall back to the
> +			 * nearest CPU node (via SLIT/numa_distance).
> +			 */
> +			cpu_nid =3D numa_nearest_node(nid, N_CPU);
> +			source_flags =3D MPN_SRC_SLIT;
> +		}
> +	}

[Severity: Medium]
Are we missing a call to the exported package notifier chain here?

The register_mp_package_notifier() and mp_probe_package_id() APIs are
provided so subsystems can supply package hints, but mp_probe_package_id()
is never called in the node creation flow.

If a node is created without an explicit initiator, shouldn't we invoke the
notifier before falling back directly to numa_nearest_node()?

> +
> +	package_id =3D mp_node_to_package_id(cpu_nid);

[ ... ]

> +static int find_package_node(int nid, int initiator_nid)
> +{
> +	struct memory_package *unreg_mp =3D NULL;
> +	int ret =3D nid;
> +
> +	mutex_lock(&memory_package_lock);
> +	if (!mpns[nid]) {

[Severity: Medium]
Is it safe to index the mpns array with nid here?

The nid is passed directly from mp_add_package_node_by_initiator(), which
is an exported API. If a driver processes malformed or malicious firmware
tables, could an unvalidated nid cause an out-of-bounds array access?

> +		ret =3D NUMA_NO_NODE;
> +	} else if (mpns[nid]->source_flags =3D=3D MPN_SRC_SLIT && initiator_nid=
 >=3D 0) {
> +		/*
> +		 * SLIT-derived entries are provisional; if a driver later
> +		 * provides an explicit initiator, drop the provisional
> +		 * entry and rebuild with the stronger hint.
> +		 */
> +		unreg_mp =3D __destroy_package_node(nid);
> +		ret =3D NUMA_NO_NODE;
> +	}
> +	mutex_unlock(&memory_package_lock);
> +
> +	if (unreg_mp)
> +		device_unregister(&unreg_mp->dev);
> +
> +	return ret;
> +}

[Severity: Medium]
Should we recalculate the global topology symmetry state here?

When an existing provisional SLIT-derived node is dropped to make way for an
explicit driver initiator, __destroy_package_node() modifies the package no=
de
counts. However, validate_topology_symmetry() is not called before returnin=
g.

Will the system's symmetry verdict remain stale until another completely
unrelated hotplug event triggers a recalculation?

[ ... ]

> +int mp_add_package_node_by_initiator(int nid, int initiator_nid)
> +{
> +	int ret;
> +
> +	ret =3D find_create_package_node(nid, initiator_nid);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(mp_add_package_node_by_initiator);

[Severity: High]
Does upgrading a provisional SLIT entry permanently drop it from the topolo=
gy?

If a driver calls this function to supply an initiator for a node that was
already initialized at boot, find_create_package_node() destroys the old en=
try=20
and creates a new mpns[nid].

However, we simply return 0 here without calling bind_node_to_package().
Since the node is already online, no hotplug event will fire to bind it,=20
potentially leaving mpn->package as NULL and orphaning the node.

[ ... ]

> +static int __mp_get_preferred_nodemask(int nid, enum mp_nodes_type node_=
type,
> +				    nodemask_t *out)
> +{
> +	int ret =3D 0;
> +
> +	/* No hot-path callers: the mutex is fine here. */
> +	guard(mutex)(&memory_package_lock);
> +
> +	if (!out) {
> +		ret =3D -EINVAL;
> +		goto out;
> +	}

[Severity: Medium]
Does this mix goto-based error handling with scope-based guard() blocks?

The kernel's cleanup subsystem guidelines in include/linux/cleanup.h
explicitly forbid mixing goto jumps with guard() cleanup declarations in
the same function, as it can create unsafe ownership semantics.

[ ... ]

> +static int __init memory_package_init(void)
> +{
> +	int ret =3D 0, nid;
> +
> +	for_each_online_node(nid) {
> +		if (!node_state(nid, N_MEMORY))
> +			continue;

[Severity: High]
Are CPU nodes without local memory completely excluded from the topology?

If a CPU node evaluates to false for N_MEMORY, it will be skipped entirely.
This would cause update_package_preferred() to find an empty CPU mask for
memory-only nodes in that package, potentially breaking memory promotion by
leaving a memory-only node to set itself as its preferred promotion target.

> +
> +		ret =3D create_node_with_package(nid);
> +		if (ret)
> +			goto out;

[Severity: Medium]
Does this leak prior successfully initialized nodes on failure?

If an allocation or registration fails inside create_node_with_package(),
the code jumps directly to out.

Without a centralized rollback loop to individually clean up the
successfully established memory_package devices and kobjects, will this
result in a permanent unrecoverable memory leak?

> +	}
> +
> +	hotplug_node_notifier(mp_hotplug_callback, MEMTIER_HOTPLUG_PRI);
> +
> +	validate_topology_symmetry();
> +
> +out:
> +	return ret;
> +}
> +late_initcall(memory_package_init);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806080936.421-=
1-rakie.kim@sk.com?part=3D2
