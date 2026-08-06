Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2333E009B
	for <nvdimm@lists.linux.dev>; Thu,  6 Aug 2026 08:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786004716; cv=none; b=VLzKNVIZP4l2fCnhIHmHEvkaaPuwON4BavSMHy3xduiR0TRJ0QBBm+bTPiCQWSHS4z2A5PKw95xBHPRypiYsu3LuTH2HZ1SBysDhiUSnf5RmF8zVMF1WfVHufGP4ey0TjJ4Vn+/bKEDw1/hV+NC5clmtikMXE6wdBONMHrsFBE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786004716; c=relaxed/simple;
	bh=pfk82g/J7NCtRDtZZ1249d5Q370rTH3tZXsBltyno/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaBhaS9dW75KLHvWa9uaM/OKgyPADZ9KILERT4YEPmhN+QdOwuR7Fr8YEKhlBJRlHnoCGLeHJFnyAszL1I9Q7b2WwbAeF815bxV35aMaPwzWG8F/nNtL2badtSU0DE/XBpkj5AFt5uFPbfTHsqRdL0bfhOluT/BnzKcgdMWuoAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-a1-6a74414c113a
From: Rakie Kim <rakie.kim@sk.com>
To: akpm@linux-foundation.org
Cc: gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rakie.kim@sk.com
Subject: [PATCH 2/4] mm/memory-tiers: introduce package-aware topology management for NUMA nodes
Date: Thu,  6 Aug 2026 17:09:33 +0900
Message-ID: <20260806080936.421-3-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260806080936.421-1-rakie.kim@sk.com>
References: <20260806080936.421-1-rakie.kim@sk.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02RW0hTcRzH+5+dm8PpcQ46KioMelDSLlr8gxCDihP4oOhTGjn00I5uU87U
	VBQ1ScwbXiF1LFHK25g1W6Z2c5jayBxJ5jSdssRJuUDF1LRyiuDbh+/t9/AjBeJ3qC/JqTJY
	XiVTSHEhKlx1bw2JupKRcnanTwI1PTocztktOByYjoNj1iIcdlt1AC4bdwDcnhsl4NeZTgDf
	Li2jcOFeFwJHjVoC6s0mHE40mVE4OaDB4bzuHwZ/2q/DzSo/aKuKhJ1buxgc7ulDYN3nFhyW
	rthQOFM9gsBunRw2v58nIn2Y/qY5gmkxZDLlJZME09sRzLS9WkEYQ9cDnDGs1RLM2MM/KNO/
	eIlx9DYCprLYiTMNzQVMz/MvKLNuCIj2uCm8nMwquCyWPxORKJS32Zfx9PttSHa9vQYpBLpf
	oAy4kTQVTmtstcgRrw7/wMoASeKUlB55neCSJZQ/3bA3gZYBISmgWjF6bH0ccxneVCJtHl/B
	XYxSp+iiWcuBLqLCaL2lljjcDKL1z2ZQF7vt7//+1nrA4v3M7s4L4jDvRX9o/H6gC6hAutjY
	LHAdo6ltgq7o1mOHQz70UMc0Wg08m451mo51WgDSBcScKksp4xThofIcFZcdmpSmNID9vz7J
	341/CdYssSZAkUDqLrKEqVPEmCxLnaM0AZoUSCUibIhPEYuSZTm5LJ92m89UsGoT8CNR6UnR
	+c27yWLqjiyDTWXZdJY/chHSzbcQnLCx3gn1VRNUXWWJ037Ld+pNhaNzwxqDWx0I18BtRQdY
	vDxB0FLe1fCJ/NNcdoFv4gbkU/tyE2KfXhMFaltnK2cfOx/dSLKbNBf894x/49sHo+eKtX4l
	HjEtyvIMiTJk8eMnz3mfi4MOOi9OO9g+ueA0U6XRUzZ7RNRGjRRVy2XnggW8WvYf40aRjNMC
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02ReUiTYQDGe79rn8PB1xr4oWW1CEvILK1eQcSC6qWkLAqjhBz6ofOY7kyF
	yoMktcQT1K0wB+ExlWZqHmEt84rlyqy8Lc0paomm5hHmQeB/D7/fw/PPQ+PCRsKelspUnEIm
	CRdTfIKf6+R/yOekKtQ1dZqEugoDBfuHLRSs+3oFvs/WUrC1O56Cpd0GAK1VSwAu9rfw4Jee
	YgBnRydw2PjDSsChhBIMtlQ95sE3j9pIWN5uomBHfjsBO+t0FBwwrJJwcvgMnE9zgINp3rD4
	zwoJTZ+tJGyqqMFg1scCCt4fHyRgT3ozBksNIXC5uoiC2rcDPG9HVJvfz0MFRjVKTerkocoi
	Z6RvGMeQsSSZQsaZTB5qzV0mUO03DzRWmQfQw8SfFJrvRUg/No2hHO1dVPG8i0CzRkdf5jrf
	M4gLl2o4xWGvAH6IfthKRd3TY9HZwxlYHDD8AinAhmYZd3aqaYJMATRNMWK2+aX/OhYxu9ic
	vx1ECuDTOFNIsq2zZnJd7GAC2HbzOLWeCWY/G99r2eACxo0tt2TyNjcPsuXPeoj1bLO2v9BX
	uJGFa52VpWreZn8725Y3ssFxZjebWKXF04Ft/haVv0UVAKwEiKQyTYREGn7MRRkWEiOTRrsE
	RkYYwdqtT2+vZLwAvzvPmgBDA7GtwOKmDBWSEo0yJsIEWBoXiwTka0WoUBAkiYnlFJE3Fepw
	TmkCDjQhthOc8+MChEywRMWFcVwUp/hvMdrGPg6kXFp0scH33dBlmT+oz5tiV8um6h9ognVd
	Xe6T8rm5BPzyk9ChbaumUV//V324XdnCTnQx8EKzZPC4f03Dte/qesPMiPC0b6zccmqPT9K7
	ZPOnpZUD0xdUbX5WkdqvSpOruZPotNBe7JWe6elx1Fkud+p1NV/de6JZesshK0IlExPKEMkR
	Z1yhlPwD4XMaDtICAAA=
X-CFilter-Loop: Reflected

The NUMA distance model provides only relative latency values between nodes
and has no notion of structural grouping. Memory policies based on distance
alone therefore cannot tell which nodes are local to the same physical
package and which belong to a different one, which limits how well they can
keep placement and migration within a package.

Introduce a package-aware topology layer that groups NUMA nodes into a
"memory package": a set of CPU nodes and their local memory-only nodes
(such as CXL or HBM). A subsystem that owns a node registers a resolver to
supply its package, and a policy can query, for any node, the other nodes
that belong to the same package.

The grouping is built from the information firmware already provides, as
nodes come online. A CPU node is placed in the package named by its
firmware physical package id. A memory-only node is placed by an initiator
CPU node when a driver supplies one, or otherwise by its nearest CPU node
under the SLIT distance table; a SLIT-derived entry is provisional and is
upgraded once a driver supplies an initiator. This makes the package
association explicit so that policies can consume it, and the mapping can
be revisited as firmware interfaces expose better information.

A single package may hold more than one CPU node or more than one
memory-only node, so the model does not assume a one-to-one package to node
or package to CXL device relationship.

The current package topology is exposed read-only under
/sys/devices/system/package/packageN/: package_nodes (all NUMA nodes in the
package), package_cpu_nodes (CPU nodes), package_mem_only_nodes
(memory-only nodes), physical_package_id (physical package id).

The interface is read-only by design: it reports the topology the kernel
derived but does not let user space override it. A machine whose firmware
describes the topology incorrectly should be fixed in firmware rather than
papered over through sysfs.

Topology is also validated for the symmetric shape that package-aware
placement relies on - every package having the same number of CPU and
memory-only nodes, at least two packages, and at least two nodes per
package. The verdict is recomputed at boot and on node hotplug and is
published for policies to consult.

On any topology that does not meet these conditions the verdict is simply
false, so a consumer degrades to its original, non-package-aware behavior
instead of acting on a grouping that does not describe the machine.

Signed-off-by: Rakie Kim <rakie.kim@sk.com>
---
 .../ABI/testing/sysfs-devices-system-package  |   35 +
 include/linux/memory-tiers.h                  |  113 ++
 mm/memory-tiers.c                             | 1009 +++++++++++++++++
 3 files changed, 1157 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-system-package

diff --git a/Documentation/ABI/testing/sysfs-devices-system-package b/Documentation/ABI/testing/sysfs-devices-system-package
new file mode 100644
index 000000000000..6500f9e5ff19
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-system-package
@@ -0,0 +1,35 @@
+What:		/sys/devices/system/package/
+Date:		August 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Memory package topology
+
+		A "memory package" groups the NUMA nodes associated with one
+		physical CPU package (socket): the nodes that have CPUs and
+		the nodes that only have memory (e.g. CXL or HBM).
+
+		All attributes are read-only; the topology cannot be
+		overridden from user space.
+
+What:		/sys/devices/system/package/packageN/package_nodes
+Date:		August 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	All NUMA nodes in this package, in nodelist format
+		(e.g. "0,2").
+
+What:		/sys/devices/system/package/packageN/package_cpu_nodes
+Date:		August 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	The nodes that have CPUs in this package, in nodelist
+		format.
+
+What:		/sys/devices/system/package/packageN/package_mem_only_nodes
+Date:		August 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	The nodes that only have memory (e.g. CXL/HBM) in this
+		package, in nodelist format.
+
+What:		/sys/devices/system/package/packageN/physical_package_id
+Date:		August 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	The physical package id this group corresponds to, as
+		reported by CPU topology.
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7999c58629ee..f8778c43429f 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -52,10 +52,25 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
 struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
+
+int register_mp_package_notifier(struct notifier_block *notifier);
+void unregister_mp_package_notifier(struct notifier_block *notifier);
+int mp_probe_package_id(int nid);
+int mp_add_package_node_by_initiator(int nid, int initiator_nid);
+int mp_add_package_node(int nid);
+int mp_get_package_nodes(int nid, nodemask_t *out);
+int mp_get_package_cpu_nodes(int nid, nodemask_t *out);
+int mp_get_package_memory_only_nodes(int nid, nodemask_t *out);
+bool mp_is_topology_symmetric(void);
 #ifdef CONFIG_NUMA_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
 bool node_is_toptier(int node);
+
+int mp_next_demotion_nodemask(int nid, nodemask_t *out);
+int mp_next_demotion_node(int nid);
+int mp_next_promotion_nodemask(int nid, nodemask_t *out);
+int mp_next_promotion_node(int nid);
 #else
 static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
 {
@@ -71,6 +86,30 @@ static inline bool node_is_toptier(int node)
 {
 	return true;
 }
+
+static inline int mp_next_demotion_nodemask(int nid, nodemask_t *out)
+{
+	if (out)
+		nodes_clear(*out);
+	return -ENOENT;
+}
+
+static inline int mp_next_demotion_node(int nid)
+{
+	return NUMA_NO_NODE;
+}
+
+static inline int mp_next_promotion_nodemask(int nid, nodemask_t *out)
+{
+	if (out)
+		nodes_clear(*out);
+	return -ENOENT;
+}
+
+static inline int mp_next_promotion_node(int nid)
+{
+	return NUMA_NO_NODE;
+}
 #endif
 
 #else
@@ -151,5 +190,79 @@ static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 static inline void mt_put_memory_types(struct list_head *memory_types)
 {
 }
+
+static inline int register_mp_package_notifier(struct notifier_block *notifier)
+{
+	return 0;
+}
+
+static inline void unregister_mp_package_notifier(struct notifier_block *notifier)
+{
+}
+
+static inline int mp_probe_package_id(int nid)
+{
+	return NOTIFY_DONE;
+}
+
+static inline int mp_add_package_node_by_initiator(int nid, int initiator_nid)
+{
+	return 0;
+}
+
+static inline int mp_add_package_node(int nid)
+{
+	return 0;
+}
+
+static inline int mp_get_package_nodes(int nid, nodemask_t *out)
+{
+	if (out)
+		nodes_clear(*out);
+	return -ENOENT;
+}
+
+static inline int mp_get_package_cpu_nodes(int nid, nodemask_t *out)
+{
+	if (out)
+		nodes_clear(*out);
+	return -ENOENT;
+}
+
+static inline int mp_get_package_memory_only_nodes(int nid, nodemask_t *out)
+{
+	if (out)
+		nodes_clear(*out);
+	return -ENOENT;
+}
+
+static inline bool mp_is_topology_symmetric(void)
+{
+	return false;
+}
+
+static inline int mp_next_demotion_nodemask(int nid, nodemask_t *out)
+{
+	if (out)
+		nodes_clear(*out);
+	return -ENOENT;
+}
+
+static inline int mp_next_demotion_node(int nid)
+{
+	return NUMA_NO_NODE;
+}
+
+static inline int mp_next_promotion_nodemask(int nid, nodemask_t *out)
+{
+	if (out)
+		nodes_clear(*out);
+	return -ENOENT;
+}
+
+static inline int mp_next_promotion_node(int nid)
+{
+	return NUMA_NO_NODE;
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b..5932df315604 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/cleanup.h>
 #include <linux/slab.h>
 #include <linux/lockdep.h>
 #include <linux/sysfs.h>
@@ -51,6 +52,11 @@ static const struct bus_type memory_tier_subsys = {
 	.dev_name = "memory_tier",
 };
 
+static const struct bus_type package_subsys = {
+	.name = "package",
+	.dev_name = "package",
+};
+
 #ifdef CONFIG_NUMA_BALANCING
 /**
  * folio_use_access_time - check if a folio reuses cpupid for page access time
@@ -1007,3 +1013,1006 @@ static int __init numa_init_sysfs(void)
 subsys_initcall(numa_init_sysfs);
 #endif /* CONFIG_SYSFS */
 #endif
+
+/**
+ * enum mp_nodes_type - Selector for which subset of a package to return
+ * @MP_NODES_ALL:       All NUMA nodes that belong to the package.
+ * @MP_NODES_CPU:       Only CPU nodes in the package.
+ * @MP_NODES_MEM_ONLY:  Only memory-only nodes (e.g. CXL/HBM) in the package.
+ *
+ * Used internally to choose which nodemask to expose for a given package.
+ */
+enum mp_nodes_type {
+	MP_NODES_ALL,
+	MP_NODES_CPU,
+	MP_NODES_MEM_ONLY
+};
+
+/**
+ * struct memory_package - Per-physical-package container
+ * @package_id:          Physical package id (from topology).
+ * @nodes:               Nodemask of all member nodes in this package.
+ * @cpu_nodes:           Nodemask of CPU nodes in this package.
+ * @memory_only_nodes:   Nodemask of memory-only nodes in this package.
+ * @cpu_list:            List head of CPU-type members.
+ * @memory_only_list:    List head of memory-only members.
+ * @list:                Linkage on the global @memory_packages list.
+ * @dev:                 sysfs device for this package.
+ *
+ * A memory_package groups NUMA nodes that share the same physical CPU package.
+ * The masks are used to implement package-local placement/demotion/promotion.
+ */
+struct memory_package {
+	int package_id;
+	nodemask_t nodes;
+	nodemask_t cpu_nodes;
+	nodemask_t memory_only_nodes;
+	struct list_head cpu_list;
+	struct list_head memory_only_list;
+	struct list_head list;
+	struct device dev;
+};
+
+/**
+ * enum mpn_source_flags - Source used to resolve a node's package membership
+ * @MPN_SRC_UNKNOWN:     Unknown/unspecified.
+ * @MPN_SRC_CPU:         Directly resolved from a CPU node (1:1).
+ * @MPN_SRC_INITIATOR:   Resolved via an initiator CPU node provided by a driver.
+ * @MPN_SRC_SLIT:        Resolved via SLIT/nearest-node.
+ *
+ * These flags are informational; they describe how a given node was bound to
+ * its package and help with policy decisions later.
+ */
+enum mpn_source_flags {
+	MPN_SRC_UNKNOWN		= 0,
+	MPN_SRC_CPU		= BIT(1),
+	MPN_SRC_INITIATOR	= BIT(2),
+	MPN_SRC_SLIT		= BIT(3)
+};
+
+/**
+ * struct memory_package_node - Per-node membership and preferences
+ * @nid:              NUMA node id for this entry.
+ * @initiator_nid:    CPU nid that served as the initiator when resolving @nid.
+ * @package_id:       Resolved package id that @nid belongs to.
+ * @source_flags:     One of &enum mpn_source_flags describing the resolution.
+ * @preferred:        Opposite-type nearest candidates inside the same package.
+ * @package:          Pointer to the owning &struct memory_package (NULL until bound).
+ * @package_entry:    Linkage on the owning package's type list.
+ *
+ * Each NUMA node that participates in package-aware policy gets a wrapper entry
+ * that caches package membership and the precomputed set of preferred targets.
+ */
+struct memory_package_node {
+	int nid;
+	int initiator_nid;
+	int package_id;
+	int source_flags;
+	nodemask_t preferred;
+	struct memory_package *package;
+	struct list_head package_entry;
+};
+
+#define node_is_memory_only(_nid) \
+	(node_state((_nid), N_MEMORY) && !node_state((_nid), N_CPU))
+
+static BLOCKING_NOTIFIER_HEAD(mp_package_algorithms);
+
+static LIST_HEAD(memory_packages);
+static struct memory_package_node *mpns[MAX_NUMNODES];
+static DEFINE_MUTEX(memory_package_lock);
+
+/*
+ * RCU snapshot of the package topology. The allocation path reads it
+ * often, so it is published for lockless reads instead of locking on
+ * every access.
+ */
+struct mp_snapshot {
+	struct rcu_head rcu;
+	int nr_packages;
+	int pkg_of[MAX_NUMNODES];
+	struct {
+		nodemask_t nodes;
+		nodemask_t cpu_nodes;
+		nodemask_t memory_only_nodes;
+	} pkg[];
+};
+
+static struct mp_snapshot __rcu *mp_snapshot;
+
+/**
+ * register_mp_package_notifier - Register a package resolution algorithm
+ * @notifier: Notifier called with the nid to resolve (see mp_probe_package_id()).
+ *
+ * Drivers (e.g., CXL region/decoder code) register here to supply a package
+ * hint for newly appearing nodes. The notifier is invoked during nid->package
+ * resolution.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int register_mp_package_notifier(struct notifier_block *notifier)
+{
+	return blocking_notifier_chain_register(&mp_package_algorithms, notifier);
+}
+EXPORT_SYMBOL_GPL(register_mp_package_notifier);
+
+/**
+ * unregister_mp_package_notifier - Unregister a package resolution algorithm
+ * @notifier: Notifier previously registered with register_mp_package_notifier().
+ */
+void unregister_mp_package_notifier(struct notifier_block *notifier)
+{
+	blocking_notifier_chain_unregister(&mp_package_algorithms, notifier);
+}
+EXPORT_SYMBOL_GPL(unregister_mp_package_notifier);
+
+/**
+ * mp_probe_package_id - Invoke registered notifiers to resolve a node's package
+ * @nid: NUMA node id to resolve.
+ *
+ * Calls the blocking notifier chain to let subsystems provide an initiator or
+ * package id for @nid.
+ *
+ * Return: Notifier return code (>=0 typically); negative errno on failure.
+ */
+int mp_probe_package_id(int nid)
+{
+	return blocking_notifier_call_chain(&mp_package_algorithms, nid, NULL);
+}
+EXPORT_SYMBOL_GPL(mp_probe_package_id);
+
+static int mp_node_to_package_id(int nid)
+{
+	int package_id;
+	unsigned int first_cpu;
+	const struct cpumask *cpu_mask;
+
+	if (nid < 0 || nid >= MAX_NUMNODES)
+		return -EINVAL;
+
+	if (!node_state(nid, N_CPU))
+		return -EINVAL;
+
+	cpu_mask = cpumask_of_node(nid);
+	if (cpumask_empty(cpu_mask))
+		return -EINVAL;
+
+	first_cpu = cpumask_first(cpu_mask);
+	if (first_cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	package_id = topology_physical_package_id(first_cpu);
+	if (package_id < 0)
+		return -EINVAL;
+
+	return package_id;
+}
+
+static void update_package_preferred(struct memory_package *mp)
+{
+	struct memory_package_node *mpn;
+
+	lockdep_assert_held(&memory_package_lock);
+
+	/*
+	 * For each CPU node, compute its preferred set as the nearest
+	 * memory-only node(s) within the same package. If the package has
+	 * no memory-only nodes, fall back to a self-reference so callers
+	 * never see an empty preferred set.
+	 */
+	list_for_each_entry(mpn, &mp->cpu_list, package_entry) {
+		nodes_clear(mpn->preferred);
+		if (!nodes_empty(mp->memory_only_nodes))
+			nearest_nodes_nodemask(mpn->nid, &mp->memory_only_nodes,
+					       &mpn->preferred);
+		else
+			node_set(mpn->nid, mpn->preferred);
+	}
+
+	/*
+	 * Symmetrically, for each memory-only node, compute its preferred set
+	 * as the nearest CPU node(s) within the same package. If the package
+	 * has no CPU nodes, fall back to a self-reference.
+	 */
+	list_for_each_entry(mpn, &mp->memory_only_list, package_entry) {
+		nodes_clear(mpn->preferred);
+		if (!nodes_empty(mp->cpu_nodes))
+			nearest_nodes_nodemask(mpn->nid, &mp->cpu_nodes,
+					       &mpn->preferred);
+		else
+			node_set(mpn->nid, mpn->preferred);
+	}
+}
+
+static inline bool memory_package_is_empty(struct memory_package *mp)
+{
+	lockdep_assert_held(&memory_package_lock);
+
+	return (nodes_empty(mp->cpu_nodes) && nodes_empty(mp->memory_only_nodes));
+}
+
+static inline bool package_node_is_valid(int nid)
+{
+	if (!mpns[nid])
+		return false;
+
+	if (nodes_empty(mpns[nid]->preferred) || (mpns[nid]->package == NULL))
+		return false;
+
+	return true;
+}
+
+static const struct attribute_group *memory_package_groups[];
+
+/* Freed when the last reference to the package's sysfs device is dropped. */
+static void memory_package_release(struct device *dev)
+{
+	struct memory_package *mp = container_of(dev, struct memory_package, dev);
+
+	kfree(mp);
+}
+
+static struct memory_package *create_memory_package(int package_id)
+{
+	struct memory_package *mempackage;
+	int ret;
+
+	mempackage = kzalloc_obj(*mempackage);
+	if (!mempackage)
+		return ERR_PTR(-ENOMEM);
+
+	mempackage->package_id = package_id;
+	mempackage->nodes = NODE_MASK_NONE;
+	mempackage->cpu_nodes = NODE_MASK_NONE;
+	mempackage->memory_only_nodes = NODE_MASK_NONE;
+	INIT_LIST_HEAD(&mempackage->cpu_list);
+	INIT_LIST_HEAD(&mempackage->memory_only_list);
+	INIT_LIST_HEAD(&mempackage->list);
+	device_initialize(&mempackage->dev);
+	mempackage->dev.release = memory_package_release;
+	dev_set_drvdata(&mempackage->dev, mempackage);
+	mempackage->dev.bus = &package_subsys;
+	mempackage->dev.groups = memory_package_groups;
+	ret = dev_set_name(&mempackage->dev, "package%d", package_id);
+	if (ret) {
+		put_device(&mempackage->dev);
+		return ERR_PTR(ret);
+	}
+
+	return mempackage;
+}
+
+static struct memory_package *find_create_memory_package(int package_id)
+{
+	struct memory_package *mempackage, *existing;
+	int ret;
+
+	mutex_lock(&memory_package_lock);
+	list_for_each_entry(mempackage, &memory_packages, list) {
+		if (mempackage->package_id == package_id) {
+			mutex_unlock(&memory_package_lock);
+			return mempackage;
+		}
+	}
+	mutex_unlock(&memory_package_lock);
+
+	mempackage = create_memory_package(package_id);
+	if (IS_ERR(mempackage))
+		return mempackage;
+
+	mutex_lock(&memory_package_lock);
+	list_for_each_entry(existing, &memory_packages, list) {
+		if (existing->package_id == package_id) {
+			mutex_unlock(&memory_package_lock);
+			put_device(&mempackage->dev);
+			return existing;
+		}
+	}
+	list_add(&mempackage->list, &memory_packages);
+	mutex_unlock(&memory_package_lock);
+
+	ret = device_add(&mempackage->dev);
+	if (ret) {
+		mutex_lock(&memory_package_lock);
+		list_del(&mempackage->list);
+		mutex_unlock(&memory_package_lock);
+		put_device(&mempackage->dev);
+		return ERR_PTR(ret);
+	}
+
+	return mempackage;
+}
+
+static void mp_snapshot_rebuild(void)
+{
+	struct mp_snapshot *new, *old;
+	struct memory_package *mp;
+	int nr = 0, i = 0, nid;
+
+	lockdep_assert_held(&memory_package_lock);
+
+	list_for_each_entry(mp, &memory_packages, list)
+		nr++;
+
+	new = kvzalloc(struct_size(new, pkg, nr), GFP_KERNEL);
+	if (!new)
+		return;
+
+	memset(new->pkg_of, 0xff, sizeof(new->pkg_of));
+
+	list_for_each_entry(mp, &memory_packages, list) {
+		new->pkg[i].nodes = mp->nodes;
+		new->pkg[i].cpu_nodes = mp->cpu_nodes;
+		new->pkg[i].memory_only_nodes = mp->memory_only_nodes;
+		for_each_node_mask(nid, mp->nodes)
+			new->pkg_of[nid] = i;
+		i++;
+	}
+	new->nr_packages = nr;
+
+	old = rcu_replace_pointer(mp_snapshot, new,
+				  lockdep_is_held(&memory_package_lock));
+	if (old)
+		kvfree_rcu(old, rcu);
+}
+
+static int bind_node_to_package(int nid)
+{
+	int package_id, pkg_id;
+	struct memory_package *mp;
+	nodemask_t nodes, cpu, mem;
+
+	mutex_lock(&memory_package_lock);
+	if (!mpns[nid]) {
+		mutex_unlock(&memory_package_lock);
+		return -EINVAL;
+	}
+	package_id = mpns[nid]->package_id;
+	mutex_unlock(&memory_package_lock);
+
+	mp = find_create_memory_package(package_id);
+	if (IS_ERR(mp))
+		return PTR_ERR(mp);
+
+	mutex_lock(&memory_package_lock);
+	if (!mpns[nid]) {
+		mutex_unlock(&memory_package_lock);
+		return -ENOENT;
+	}
+	mpns[nid]->package = mp;
+	node_set(mpns[nid]->nid, mp->nodes);
+	if (node_is_memory_only(mpns[nid]->nid)) {
+		node_set(mpns[nid]->nid, mp->memory_only_nodes);
+		list_add(&mpns[nid]->package_entry, &mp->memory_only_list);
+	} else {
+		node_set(mpns[nid]->nid, mp->cpu_nodes);
+		list_add(&mpns[nid]->package_entry, &mp->cpu_list);
+	}
+	update_package_preferred(mp);
+	mp_snapshot_rebuild();
+	pkg_id = mp->package_id;
+	nodes = mp->nodes;
+	cpu = mp->cpu_nodes;
+	mem = mp->memory_only_nodes;
+	mutex_unlock(&memory_package_lock);
+
+	pr_info("memory_package %d: nodes=%*pbl cpu=%*pbl memory_only=%*pbl\n",
+		pkg_id, nodemask_pr_args(&nodes),
+		nodemask_pr_args(&cpu), nodemask_pr_args(&mem));
+
+	return 0;
+}
+
+static void unbind_node_to_package(struct memory_package *mp, int nid)
+{
+	lockdep_assert_held(&memory_package_lock);
+
+	node_clear(nid, mp->nodes);
+	if (node_state(nid, N_CPU))
+		node_clear(nid, mp->cpu_nodes);
+	else
+		node_clear(nid, mp->memory_only_nodes);
+
+	if (mpns[nid])
+		list_del(&mpns[nid]->package_entry);
+
+	update_package_preferred(mp);
+}
+
+static struct memory_package_node *create_package_node(int nid, int initiator_nid)
+{
+	int cpu_nid, package_id;
+	int source_flags;
+	struct memory_package_node *mpn;
+
+	if (node_state(nid, N_CPU)) {
+		cpu_nid = nid;
+		source_flags = MPN_SRC_CPU;
+	} else {
+		if (initiator_nid >= 0) {
+			cpu_nid = initiator_nid;
+			source_flags = MPN_SRC_INITIATOR;
+		} else {
+			/*
+			 * No driver-supplied initiator: fall back to the
+			 * nearest CPU node (via SLIT/numa_distance).
+			 */
+			cpu_nid = numa_nearest_node(nid, N_CPU);
+			source_flags = MPN_SRC_SLIT;
+		}
+	}
+
+	package_id = mp_node_to_package_id(cpu_nid);
+	if (package_id < 0)
+		return ERR_PTR(-EINVAL);
+
+	mpn = kzalloc_obj(*mpn);
+	if (!mpn)
+		return ERR_PTR(-ENOMEM);
+
+	mpn->nid = nid;
+	mpn->initiator_nid = cpu_nid;
+	mpn->package_id = package_id;
+	mpn->source_flags = source_flags;
+	mpn->preferred = NODE_MASK_NONE;
+	mpn->package = NULL;
+	INIT_LIST_HEAD(&mpn->package_entry);
+
+	return mpn;
+}
+
+/*
+ * Topology symmetry status
+ * Indicates whether all packages have identical node structure
+ * (same number of CPU nodes and memory-only nodes).
+ */
+static bool topology_symmetric;
+
+static void validate_topology_symmetry(void);
+
+static struct memory_package *__destroy_package_node(int nid)
+{
+	struct memory_package_node *mpn;
+	struct memory_package *mp, *unreg_mp = NULL;
+
+	lockdep_assert_held(&memory_package_lock);
+
+	mpn = mpns[nid];
+	if (!mpn)
+		return NULL;
+
+	mp = mpn->package;
+	if (mp) {
+		unbind_node_to_package(mp, nid);
+		mpn->package = NULL;
+
+		if (memory_package_is_empty(mp)) {
+			list_del(&mp->list);
+			unreg_mp = mp;
+		}
+	}
+
+	mpns[nid] = NULL;
+	kfree(mpn);
+	mp_snapshot_rebuild();
+
+	return unreg_mp;
+}
+
+static void destroy_package_node(int nid)
+{
+	struct memory_package *unreg_mp;
+
+	mutex_lock(&memory_package_lock);
+	unreg_mp = __destroy_package_node(nid);
+	mutex_unlock(&memory_package_lock);
+
+	if (unreg_mp)
+		device_unregister(&unreg_mp->dev);
+
+	validate_topology_symmetry();
+}
+
+static int find_package_node(int nid, int initiator_nid)
+{
+	struct memory_package *unreg_mp = NULL;
+	int ret = nid;
+
+	mutex_lock(&memory_package_lock);
+	if (!mpns[nid]) {
+		ret = NUMA_NO_NODE;
+	} else if (mpns[nid]->source_flags == MPN_SRC_SLIT && initiator_nid >= 0) {
+		/*
+		 * SLIT-derived entries are provisional; if a driver later
+		 * provides an explicit initiator, drop the provisional
+		 * entry and rebuild with the stronger hint.
+		 */
+		unreg_mp = __destroy_package_node(nid);
+		ret = NUMA_NO_NODE;
+	}
+	mutex_unlock(&memory_package_lock);
+
+	if (unreg_mp)
+		device_unregister(&unreg_mp->dev);
+
+	return ret;
+}
+
+static int find_create_package_node(int nid, int initiator_nid)
+{
+	int mpn_nid;
+	struct memory_package_node *mpn;
+
+	mpn_nid = find_package_node(nid, initiator_nid);
+	if (mpn_nid != NUMA_NO_NODE)
+		return mpn_nid;
+
+	mpn = create_package_node(nid, initiator_nid);
+	if (IS_ERR(mpn))
+		return PTR_ERR(mpn);
+
+	guard(mutex)(&memory_package_lock);
+	if (mpns[nid]) {
+		kfree(mpn);
+		return nid;
+	}
+	mpns[nid] = mpn;
+
+	return nid;
+}
+
+static int create_node_with_package(int nid)
+{
+	int ret;
+
+	ret = find_create_package_node(nid, NUMA_NO_NODE);
+	if (ret < 0)
+		return ret;
+
+	ret = bind_node_to_package(nid);
+	if (ret)
+		return ret;
+
+	validate_topology_symmetry();
+	return 0;
+}
+
+/**
+ * mp_add_package_node_by_initiator - Add a node with an initiator
+ * @nid:            Target NUMA node to add.
+ * @initiator_nid:  CPU nid used to resolve @nid's package (>=0).
+ *
+ * Ensures that a &struct memory_package_node exists for @nid and that its
+ * package_id is determined using @initiator_nid when provided. Binding to the
+ * package is not performed here.
+ *
+ * Return: 0 on success; negative errno on failure.
+ */
+int mp_add_package_node_by_initiator(int nid, int initiator_nid)
+{
+	int ret;
+
+	ret = find_create_package_node(nid, initiator_nid);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mp_add_package_node_by_initiator);
+
+/**
+ * mp_add_package_node - Add a node, resolving package automatically
+ * @nid: Target NUMA node to add.
+ *
+ * Wrapper over mp_add_package_node_by_initiator() that requests automatic
+ * initiator resolution (e.g., nearest CPU).
+ *
+ * Return: 0 on success; negative errno on failure.
+ */
+int mp_add_package_node(int nid)
+{
+	return mp_add_package_node_by_initiator(nid, NUMA_NO_NODE);
+}
+EXPORT_SYMBOL_GPL(mp_add_package_node);
+
+static int __mp_get_package_nodemask(int nid, enum mp_nodes_type node_type,
+				     nodemask_t *out)
+{
+	struct mp_snapshot *snap;
+	int pkg;
+
+	if (!out)
+		return -EINVAL;
+
+	nodes_clear(*out);
+
+	if (nid < 0 || nid >= MAX_NUMNODES)
+		return -EINVAL;
+
+	guard(rcu)();
+
+	snap = rcu_dereference(mp_snapshot);
+	if (!snap)
+		return -ENOENT;
+
+	pkg = snap->pkg_of[nid];
+	if (pkg < 0)
+		return -ENOENT;
+
+	switch (node_type) {
+	case MP_NODES_ALL:
+		nodes_copy(*out, snap->pkg[pkg].nodes);
+		break;
+	case MP_NODES_CPU:
+		nodes_copy(*out, snap->pkg[pkg].cpu_nodes);
+		break;
+	case MP_NODES_MEM_ONLY:
+		nodes_copy(*out, snap->pkg[pkg].memory_only_nodes);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_NUMA_MIGRATION
+static int __mp_get_preferred_nodemask(int nid, enum mp_nodes_type node_type,
+				    nodemask_t *out)
+{
+	int ret = 0;
+
+	/* No hot-path callers: the mutex is fine here. */
+	guard(mutex)(&memory_package_lock);
+
+	if (!out) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	nodes_clear(*out);
+
+	if (nid < 0 || nid >= MAX_NUMNODES) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (node_type == MP_NODES_CPU) {
+		if (node_is_memory_only(nid)) {
+			ret = -EINVAL;
+			goto out;
+		}
+	} else if (node_type == MP_NODES_MEM_ONLY) {
+		if (!node_is_memory_only(nid)) {
+			ret = -EINVAL;
+			goto out;
+		}
+	} else {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!package_node_is_valid(nid)) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	nodes_copy(*out, mpns[nid]->preferred);
+
+out:
+	return ret;
+}
+
+/**
+ * mp_next_demotion_nodemask - Demotion candidates within a package
+ * @nid: CPU node from which memory would be demoted.
+ * @out: Output nodemask of nearest memory-only targets in the same package.
+ *
+ * Return: 0 on success; negative errno if @nid is invalid or not initialized.
+ */
+int mp_next_demotion_nodemask(int nid, nodemask_t *out)
+{
+	return __mp_get_preferred_nodemask(nid, MP_NODES_CPU, out);
+}
+EXPORT_SYMBOL_GPL(mp_next_demotion_nodemask);
+
+/**
+ * mp_next_demotion_node - Pick one demotion target
+ * @nid: CPU node from which memory would be demoted.
+ *
+ * Picks one target (random among the nearest) from mp_next_demotion_nodemask().
+ *
+ * Return: target nid on success, or NUMA_NO_NODE if no candidate is available.
+ */
+int mp_next_demotion_node(int nid)
+{
+	int target_nid;
+	nodemask_t target_nodemask;
+
+	if (mp_next_demotion_nodemask(nid, &target_nodemask))
+		return NUMA_NO_NODE;
+	if (nodes_empty(target_nodemask))
+		return NUMA_NO_NODE;
+
+	target_nid = node_random(&target_nodemask);
+
+	return target_nid;
+}
+EXPORT_SYMBOL_GPL(mp_next_demotion_node);
+
+/**
+ * mp_next_promotion_nodemask - Promotion candidates within a package
+ * @nid: Memory-only node towards which promotion seeks CPU locality.
+ * @out: Output nodemask of nearest CPU targets in the same package.
+ *
+ * Return: 0 on success; negative errno if @nid is invalid or not initialized.
+ */
+int mp_next_promotion_nodemask(int nid, nodemask_t *out)
+{
+	return __mp_get_preferred_nodemask(nid, MP_NODES_MEM_ONLY, out);
+}
+EXPORT_SYMBOL_GPL(mp_next_promotion_nodemask);
+
+/**
+ * mp_next_promotion_node - Pick one promotion target
+ * @nid: Memory-only node to be promoted towards CPUs.
+ *
+ * Picks one target (random among the nearest) from mp_next_promotion_nodemask().
+ *
+ * Return: target nid on success, or NUMA_NO_NODE if no candidate is available.
+ */
+int mp_next_promotion_node(int nid)
+{
+	int target_nid;
+	nodemask_t target_nodemask;
+
+	if (mp_next_promotion_nodemask(nid, &target_nodemask))
+		return NUMA_NO_NODE;
+	if (nodes_empty(target_nodemask))
+		return NUMA_NO_NODE;
+
+	target_nid = node_random(&target_nodemask);
+
+	return target_nid;
+}
+EXPORT_SYMBOL_GPL(mp_next_promotion_node);
+#endif /* CONFIG_NUMA_MIGRATION */
+
+/**
+ * mp_get_package_nodes - Return all members of @nid's package
+ * @nid: Any NUMA node in the package.
+ * @out: Output nodemask to receive all members.
+ *
+ * Return: 0 on success; negative errno if @nid is invalid or not initialized.
+ */
+int mp_get_package_nodes(int nid, nodemask_t *out)
+{
+	return __mp_get_package_nodemask(nid, MP_NODES_ALL, out);
+}
+EXPORT_SYMBOL_GPL(mp_get_package_nodes);
+
+/**
+ * mp_get_package_cpu_nodes - Return CPU members of @nid's package
+ * @nid: Any NUMA node in the package.
+ * @out: Output nodemask to receive CPU members.
+ *
+ * Return: 0 on success; negative errno if @nid is invalid or not initialized.
+ */
+int mp_get_package_cpu_nodes(int nid, nodemask_t *out)
+{
+	return __mp_get_package_nodemask(nid, MP_NODES_CPU, out);
+}
+EXPORT_SYMBOL_GPL(mp_get_package_cpu_nodes);
+
+/**
+ * mp_get_package_memory_only_nodes - Return memory-only members of @nid's package
+ * @nid: Any NUMA node in the package.
+ * @out: Output nodemask to receive memory-only members.
+ *
+ * Return: 0 on success; negative errno if @nid is invalid or not initialized.
+ */
+int mp_get_package_memory_only_nodes(int nid, nodemask_t *out)
+{
+	return __mp_get_package_nodemask(nid, MP_NODES_MEM_ONLY, out);
+}
+EXPORT_SYMBOL_GPL(mp_get_package_memory_only_nodes);
+
+static int __meminit mp_hotplug_callback(struct notifier_block *nb,
+		unsigned long action, void *_arg)
+{
+	int nid;
+	struct node_notify *nn = _arg;
+
+	nid = nn->nid;
+	if (nid < 0)
+		return notifier_from_errno(0);
+
+	switch (action) {
+	case NODE_REMOVED_LAST_MEMORY:
+		destroy_package_node(nid);
+		break;
+
+	case NODE_ADDED_FIRST_MEMORY:
+		create_node_with_package(nid);
+		break;
+
+	default:
+		break;
+	}
+
+	return notifier_from_errno(0);
+}
+
+/*
+ * sysfs interface for memory_package topology
+ * Read-only attributes:
+ *   - package_nodes:       All NUMA nodes in this package (node mask)
+ *   - package_cpu_nodes:   CPU nodes in this package (node mask)
+ *   - package_mem_only_nodes: Memory-only nodes in this package (node mask)
+ *   - physical_package_id: Physical package ID
+ */
+
+static ssize_t package_nodes_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct memory_package *mp = dev_get_drvdata(dev);
+
+	guard(mutex)(&memory_package_lock);
+	return sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&mp->nodes));
+}
+static DEVICE_ATTR_RO(package_nodes);
+
+static ssize_t package_cpu_nodes_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct memory_package *mp = dev_get_drvdata(dev);
+
+	guard(mutex)(&memory_package_lock);
+	return sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&mp->cpu_nodes));
+}
+static DEVICE_ATTR_RO(package_cpu_nodes);
+
+static ssize_t package_mem_only_nodes_show(struct device *dev,
+					   struct device_attribute *attr, char *buf)
+{
+	struct memory_package *mp = dev_get_drvdata(dev);
+
+	guard(mutex)(&memory_package_lock);
+	return sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&mp->memory_only_nodes));
+}
+static DEVICE_ATTR_RO(package_mem_only_nodes);
+
+static ssize_t physical_package_id_show(struct device *dev,
+					struct device_attribute *attr, char *buf)
+{
+	struct memory_package *mp = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n", mp->package_id);
+}
+static DEVICE_ATTR_RO(physical_package_id);
+
+static struct attribute *memory_package_attrs[] = {
+	&dev_attr_package_nodes.attr,
+	&dev_attr_package_cpu_nodes.attr,
+	&dev_attr_package_mem_only_nodes.attr,
+	&dev_attr_physical_package_id.attr,
+	NULL,
+};
+
+static const struct attribute_group memory_package_group = {
+	.attrs = memory_package_attrs,
+};
+
+static const struct attribute_group *memory_package_groups[] = {
+	&memory_package_group,
+	NULL,
+};
+
+static int __init memory_package_sysfs_init(void)
+{
+	int ret;
+
+	ret = subsys_system_register(&package_subsys, NULL);
+	if (ret) {
+		pr_err("memory_package subsys_system_register failed: %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+core_initcall(memory_package_sysfs_init);
+
+/**
+ * mp_is_topology_symmetric - Check if all packages have identical node structure
+ *
+ * Returns true if all memory packages have the same number of CPU nodes
+ * and memory-only nodes, indicating a symmetric topology.
+ *
+ * The topology_symmetric variable is protected by memory_package_lock for
+ * writes (in validate_topology_symmetry).
+ */
+bool mp_is_topology_symmetric(void)
+{
+	return READ_ONCE(topology_symmetric);
+}
+EXPORT_SYMBOL_GPL(mp_is_topology_symmetric);
+
+/* Walk the package list and compare node counts; the caller holds the lock. */
+static bool __check_topology_symmetry(void)
+{
+	struct memory_package *mp;
+	int ref_cpu_node_count = 0, ref_memory_only_node_count = 0;
+	int package_count = 0;
+
+	lockdep_assert_held(&memory_package_lock);
+
+	list_for_each_entry(mp, &memory_packages, list) {
+		int cpu_node_count = nodes_weight(mp->cpu_nodes);
+		int memory_only_node_count = nodes_weight(mp->memory_only_nodes);
+		int total_node_count = cpu_node_count + memory_only_node_count;
+
+		package_count++;
+
+		/* Each package must have at least 2 nodes */
+		if (total_node_count < 2)
+			return false;
+
+		if (package_count == 1) {
+			ref_cpu_node_count = cpu_node_count;
+			ref_memory_only_node_count = memory_only_node_count;
+		} else if (cpu_node_count != ref_cpu_node_count ||
+			   memory_only_node_count != ref_memory_only_node_count) {
+			return false;
+		}
+	}
+
+	if (package_count < 2)
+		return false;
+
+	return true;
+}
+
+/**
+ * validate_topology_symmetry - Validate topology for package-aware features
+ *
+ * Validates topology symmetry by checking all memory packages have identical
+ * node structure. Updates the global topology_symmetric variable.
+ *
+ * Topology is valid only when all conditions are met:
+ * 1. At least 2 packages exist (multi-package system)
+ * 2. All packages have identical cpu_node and memory_only_node counts
+ * 3. Each package has at least 2 total nodes (cpu_node + memory_only_node >= 2)
+ *
+ * Valid configurations per package:
+ * - 1 cpu_node + 1 memory_only_node = 2 nodes (valid)
+ * - 2 cpu_nodes + 0 memory_only_node = 2 nodes (valid)
+ * - 0 cpu_node + 2 memory_only_nodes = 2 nodes (valid)
+ * - 1 cpu_node + 0 memory_only_node = 1 node (invalid - single node package)
+ */
+static void validate_topology_symmetry(void)
+{
+	guard(mutex)(&memory_package_lock);
+
+	WRITE_ONCE(topology_symmetric, __check_topology_symmetry());
+}
+
+static int __init memory_package_init(void)
+{
+	int ret = 0, nid;
+
+	for_each_online_node(nid) {
+		if (!node_state(nid, N_MEMORY))
+			continue;
+
+		ret = create_node_with_package(nid);
+		if (ret)
+			goto out;
+	}
+
+	hotplug_node_notifier(mp_hotplug_callback, MEMTIER_HOTPLUG_PRI);
+
+	validate_topology_symmetry();
+
+out:
+	return ret;
+}
+late_initcall(memory_package_init);
-- 
2.25.1

