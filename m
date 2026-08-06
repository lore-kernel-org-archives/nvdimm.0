Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141A43F076C
	for <nvdimm@lists.linux.dev>; Thu,  6 Aug 2026 08:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786004719; cv=none; b=p/cWssh1va6Por//rYUOnFMNUn3nSJQCBDkDP4ZUgZSJuVL/zkBFgcLBPhl59xTfG4pcSrJMn7KkNhvKlBVM3EhSw0urbb7d8PA89A39UstcwRPc85fGGiCMlbtqNYj6uWJn3rywdXnyRSPgD9YB74zENLGLJhchJnSL9/1DY+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786004719; c=relaxed/simple;
	bh=AuxpUL6xLeUPvp7JFNvkxOkrv6s/iFERNBvbv+WSVJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMAS4CCuHUAjU2yIs3DLXgF7+s6xQUZPVwRqVtDG/pTjReqqz0vkaFHzyhOoAohHGTMbV0gtbMmu82Htnue1qP3qrZClPOM0incMc/ILoZWrEkT3TKz+I2tZyxHPoJl/EO8G8T7p5nq6Wbp5niuY6a9zMK1KwZwuxafanaCxadw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-b2-6a74414ee24e
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
Subject: [PATCH 4/4] mm/mempolicy: enhance weighted interleave with package-aware locality
Date: Thu,  6 Aug 2026 17:09:35 +0900
Message-ID: <20260806080936.421-5-rakie.kim@sk.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsXC9ZZnoa6fY0mWwcNFnBZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4Mtb3v2QsuFFU0Xdz
	AlMD48ToLkZODgkBE4mX16czwthX33SydjFycLAJKEkc2xsDEhYRkJWY+vc8SxcjFwezwCJW
	iROfz4LVCAtESfz/LwBSwyKgKnHoy052EJtXwFhibc9kNoiRmhLrNt5iAbE5gcZ/v7MIzBYC
	qvnzaxtUvaDEyZlPwOLMAvISzVtnM4PskhD4yS7RvGoiE8QgSYmDK26wTGDkn4WkZxaSngWM
	TKsYhTLzynITM3NM9DIq8zIr9JLzczcxAiN1We2f6B2Mny4EH2IU4GBU4uG9YFycJcSaWFZc
	mXuIUYKDWUmEl/VgUZYQb0piZVVqUX58UWlOavEhRmkOFiVxXqNv5SlCAumJJanZqakFqUUw
	WSYOTqkGxq453pe+xS73a50vetIy7a3lv3f+KR/kJ11qCMh3YMxt2fRWoZ7lyZ1ZH37eLPYU
	eued8PXBzd5S60sxlimyN/f9ktPM0vvy0mFRW2taerrx5DtafZz7JDZFOPoFz83VD556QbQh
	03xl3f43aoedO9blFs7+dT53e7lwXUPYl2nNlY9EZ3MrKrEUZyQaajEXFScCAEQtYk7QAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsXCNUM9RtfXsSTL4PJ9U4s569ewWdx9fIHN
	YteNEItzU2azWZy42chmsfrmGkaL51t/MVr8vHuc3eL6rZWMFp+fvWa22P/0OYvFg6ZVTBbH
	t85jtzg89ySrxbpTh9gszs86xWJxedccNot7a/6zWrx57GbxrU/a4n6fg8XKH39YLQ5de85q
	cWT9diaLyZcWsFl0vLzPYnFrwjEmi9VrMix+b1vBZjH76D12BzmPnbPusnss2FTq0d12md1j
	8wotj8V7XjJ5bFrVyeax6dMkdo8TM36zeOx8aOnxYvNMRo/e5ndsHt9ue3gsfvGByWPq7HqP
	9Vuusnh83iQXIBDFZZOSmpNZllqkb5fAlbG+/yVjwY2iir6bE5gaGCdGdzFyckgImEhcfdPJ
	2sXIwcEmoCRxbG8MSFhEQFZi6t/zLF2MXBzMAotYJU58PgtWIywQJfH/vwBIDYuAqsShLzvZ
	QWxeAWOJtT2T2SBGakqs23iLBcTmBBr//c4iMFsIqObPr21Q9YISJ2c+AYszC8hLNG+dzTyB
	kWcWktQsJKkFjEyrGEUy88pyEzNzTPWKszMq8zIr9JLzczcxAuN0We2fiTsYv1x2P8QowMGo
	xMN7wbg4S4g1say4MvcQowQHs5IIL+vBoiwh3pTEyqrUovz4otKc1OJDjNIcLErivF7hqQlC
	AumJJanZqakFqUUwWSYOTqkGximFole3L7D0W+wy48dfljWXvi7Zsyn34qfAzt625deOlZid
	yNz+jGvGtQ26t/qvt3DXPF06O69s52wtro1f4iPeCMk9rtjiblcy4byk9Pqpvow7OZ1ZOz4K
	P0kyPqtRoGi/9sMxVmFxzTdS5dmvFJed3qgivfbph+cX08I6vsjqPLp4daoz92QlluKMREMt
	5qLiRAA2UOG3zwIAAA==
X-CFilter-Loop: Reflected

Weighted interleave places pages on nodes in proportion to per-node weights
derived from each node's bandwidth. Within one package the weight given to
a node matches the bandwidth a task sees from it; across packages it does
not. The weights are set once from device bandwidth and applied the same
way wherever the task runs, but memory reached over the interconnect to
another package is slower than the same memory reached locally, so a node
in another package is given a weight higher than the bandwidth it can
deliver to the task. Flat weighted interleave then steers allocations onto
the interconnect even when local capacity exists, degrading effective
bandwidth.

          node0             node1
        +-------+         +-------+
        | CPU 0 |---------| CPU 1 |
        +-------+         +-------+
        | DRAM0 |         | DRAM1 |
        +---+---+         +---+---+
            |                 |
        +---+---+         +---+---+
        | CXL 0 |         | CXL 1 |
        +-------+         +-------+
          node2             node3

The numbers below are illustrative single-stream bandwidths (GB/s). Local
DRAM sustains 300 and local CXL 150; any path that crosses to another
package, over the interconnect, is capped at 100, so a node in another
package delivers 100 whether it is DRAM or CXL. Local CXL (150) is still
faster than any node in another package (100). The effective bandwidth each
CPU sees is:

              node0  node1  node2  node3
from CPU 0:    300    100    150    100
from CPU 1:    100    300    100    150

Since a single per-node weight cannot encode the interconnect penalty,
a reasonable set of global weights is taken from local device bandwidth
(local DRAM : local CXL = 300 : 150 = 2 : 1): node0=2 node1=2 node2=1
node3=1.

              node0  node1  node2  node3
global:         2      2      1      1   (same wherever the task runs)

A task on CPU 0 gives node1 - remote DRAM, effective 100 - the same weight
2 as its own local node0 at 300. Worse, node1 is weighted above node2, the
task's local CXL at effective 150, even though node2 is the faster of the
two. The flat weights rank a slower interconnect-bound node above a faster
local one, which is exactly backwards.

Make weighted interleave package-aware. When enabled, node selection is
restricted to the nodes of the task's current package, intersected with the
policy nodemask: the task's pages are spread by weight across the package's
nodes, and nodes outside the package are not part of the selection.

The only mask-level fallback is the empty-intersection case - if the policy
nodemask excludes every node of the current package, selection falls back
to the package spanned by the policy's own nodes, so a misconfiguration
never yields an empty candidate set. There is no spill to a remote package
as a placement preference.

Availability is still preferred over containment at allocation time: the
resolved mask constrains node selection only, and the page allocator is
invoked without a package nodemask, so when the selected node is exhausted
the allocation is served from another node - exactly as plain weighted
interleave already behaves - rather than forcing reclaim on the local
package.

The resolved mask is by construction a subset of the policy nodemask, which
mempolicy already restricts to the task's cpuset; package mode can only
narrow that set, never widen it, so cpusets and the task nodemask remain
authoritative.

              node0  node1  node2  node3
from CPU 0:     2      0      1      0
from CPU 1:     0      2      0      1

Tasks on CPU 0 place pages on DRAM0(2) and CXL0(1) at 2:1, which matches
their effective bandwidth of 300:150; tasks on CPU 1 place on DRAM1(2) and
CXL1(1) the same way. This aligns allocation with per-package bandwidth,
preserves NUMA locality, and keeps interleave traffic off the saturable
cross-socket interconnect.

The behavior is opt-in and off by default. A sysfs toggle at
/sys/kernel/mm/mempolicy/weighted_interleave/package_mode turns it on or
off at runtime; reading it reports the current setting.

Enabling is refused on a topology that is not symmetric (see
/sys/devices/system/package/), and if the topology stops being symmetric
while the mode is on - for example after node hotplug - weighted interleave
transparently degrades to its flat behavior while the configured value is
preserved and takes effect again once the topology is symmetric.

The following are the results with package-aware weighted interleave
applied:

System Configuration:
- Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)

1) Throughput (System Bandwidth)
   - DRAM Only: 966 GB/s
   - Weighted Interleave: 903 GB/s (7% decrease compared to DRAM Only)
   - Package-Aware Weighted Interleave: 1329 GB/s (1.33 TB/s)
     (38% increase compared to DRAM Only,
      47% increase compared to Weighted Interleave)

2) Loaded Latency (Under High Bandwidth)
   - DRAM Only: 544 ns
   - Weighted Interleave: 545 ns
   - Package-Aware Weighted Interleave: 436 ns
     (20% reduction compared to both)

Signed-off-by: Rakie Kim <rakie.kim@sk.com>
---
 ...fs-kernel-mm-mempolicy-weighted-interleave |  17 ++
 mm/mempolicy.c                                | 159 +++++++++++++++++-
 2 files changed, 172 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave b/Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
index 649c0e9b895c..d2ccba171c5e 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
@@ -52,3 +52,20 @@ Description:	Auto-weighting configuration interface
 
 		Writing a new weight to a node directly via the nodeN interface
 		will also automatically switch the system to manual mode.
+
+What:		/sys/kernel/mm/mempolicy/weighted_interleave/package_mode
+Date:		August 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Package-aware weighted interleave toggle
+
+		'true' restricts weighted interleave node selection to the
+		NUMA nodes of the package (CPU socket) the allocating task
+		is running on. 'false' (the default) uses the existing
+		weighted interleave behavior.
+
+		Enabling is rejected with -EINVAL while the package topology
+		is not symmetric.
+
+		Writing any true value string (e.g. Y or 1) enables the
+		restriction, any false value string (e.g. N or 0) disables
+		it. All other strings return -EINVAL.
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 19417b0afc30..66bccb9a0a19 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -117,6 +117,7 @@
 #include <asm/tlb.h>
 #include <linux/uaccess.h>
 #include <linux/memory.h>
+#include <linux/memory-tiers.h>
 
 #include "internal.h"
 
@@ -167,6 +168,8 @@ static unsigned int *node_bw_table;
  */
 static DEFINE_MUTEX(wi_state_lock);
 
+static bool package_mode_enabled;
+
 static u8 get_il_weight(int node)
 {
 	struct weighted_interleave_state *state;
@@ -180,6 +183,11 @@ static u8 get_il_weight(int node)
 	return weight;
 }
 
+static bool wi_package_mode_enabled(void)
+{
+	return READ_ONCE(package_mode_enabled) && mp_is_topology_symmetric();
+}
+
 /*
  * Convert bandwidth values into weighted interleave weights.
  * Call with wi_state_lock.
@@ -2138,17 +2146,97 @@ bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
 	return zone >= dynamic_policy_zone;
 }
 
+/**
+ * policy_resolve_package_nodes - Restrict policy nodes to the current package
+ * @policy: Target mempolicy whose user-selected nodes are in @policy->nodes.
+ * @mask:   Output nodemask. On success, contains policy->nodes limited to
+ *          the package that should be used for the allocation.
+ *
+ * This helper combines two constraints to decide where within a package
+ * memory may be allocated:
+ *
+ *   1) The caller's package: derived via mp_get_package_nodes(numa_node_id()).
+ *   2) The user's preselected set @policy->nodes (cpusets/mempolicy).
+ *
+ * The function obtains the nodemask of the current CPU's package and
+ * intersects it with @policy->nodes. If the intersection is empty (e.g. the
+ * user excluded every node of the current package), it falls back to the
+ * node in @policy->nodes, derives that node's package, and intersects
+ * again. If the fallback also yields an empty set, @mask stays empty and a
+ * non-zero error is returned.
+ *
+ * Examples (packages: P0={CPU:0, MEM:2}, P1={CPU:1, MEM:3}):
+ *   - policy->nodes = {0,1,2,3}
+ *       on P0: mask = {0,2}; on P1: mask = {1,3}.
+ *   - policy->nodes = {0,1,3}
+ *       on P0: mask = {0}      (only node 0 from P0 is allowed).
+ *   - policy->nodes = {1,2,3}
+ *       on P0: mask = {2}      (only node 2 from P0 is allowed).
+ *   - policy->nodes = {1,3}
+ *       on P0: current package (P0) & policy = NULL -> fallback to policy=1,
+ *               package(1)=P1, mask = {1,3}. (User effectively opted out of P0.)
+ *
+ * If the selected node is low on memory, the allocation may use another node.
+ *
+ * Return:
+ *   0 on success with @mask set as above;
+ *   -EINVAL if @policy/@mask is NULL;
+ *   -ENOENT if even the fallback intersection is empty;
+ *   Propagated error from mp_get_package_nodes() on failure.
+ */
+static int policy_resolve_package_nodes(struct mempolicy *policy, nodemask_t *mask)
+{
+	nodemask_t package_mask;
+	int node, ret;
+
+	if (!policy || !mask)
+		return -EINVAL;
+
+	nodes_clear(*mask);
+
+	node = numa_node_id();
+	ret = mp_get_package_nodes(node, &package_mask);
+	if (ret)
+		return ret;
+
+	nodes_and(*mask, package_mask, policy->nodes);
+	if (!nodes_empty(*mask))
+		return 0;
+
+	/*
+	 * The user's nodemask excludes every node of the current package;
+	 * fall back to the package spanned by the user's own first node.
+	 */
+	node = first_node(policy->nodes);
+	ret = mp_get_package_nodes(node, &package_mask);
+	if (ret)
+		return ret;
+
+	nodes_and(*mask, package_mask, policy->nodes);
+	if (nodes_empty(*mask))
+		return -ENOENT;
+
+	return 0;
+}
+
 static unsigned int weighted_interleave_nodes(struct mempolicy *policy)
 {
 	unsigned int node;
 	unsigned int cpuset_mems_cookie;
+	nodemask_t mask;
 
 retry:
 	/* to prevent miscount use tsk->mems_allowed_seq to detect rebind */
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	node = current->il_prev;
-	if (!current->il_weight || !node_isset(node, policy->nodes)) {
-		node = next_node_in(node, policy->nodes);
+
+	/* Package mode off or unresolved: fall back to the full policy nodemask. */
+	if (!wi_package_mode_enabled() ||
+	    policy_resolve_package_nodes(policy, &mask))
+		mask = policy->nodes;
+
+	if (!current->il_weight || !node_isset(node, mask)) {
+		node = next_node_in(node, mask);
 		if (read_mems_allowed_retry(cpuset_mems_cookie))
 			goto retry;
 		if (node == MAX_NUMNODES)
@@ -2241,6 +2329,30 @@ static unsigned int read_once_policy_nodemask(struct mempolicy *pol,
 	return nodes_weight(*mask);
 }
 
+/*
+ * Package-aware counterpart of read_once_policy_nodemask(): resolve the
+ * current package's nodes intersected with the policy, falling back to the
+ * full policy nodemask when package mode is off or resolution fails.
+ */
+static unsigned int read_once_policy_package_nodemask(struct mempolicy *pol,
+						      nodemask_t *mask)
+{
+	nodemask_t package_mask;
+
+	barrier();
+	if (!wi_package_mode_enabled()) {
+		memcpy(mask, &pol->nodes, sizeof(nodemask_t));
+		return nodes_weight(*mask);
+	}
+	if (policy_resolve_package_nodes(pol, &package_mask))
+		memcpy(mask, &pol->nodes, sizeof(nodemask_t));
+	else
+		memcpy(mask, &package_mask, sizeof(nodemask_t));
+	barrier();
+
+	return nodes_weight(*mask);
+}
+
 static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 {
 	struct weighted_interleave_state *state;
@@ -2251,7 +2363,7 @@ static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 	u8 weight;
 	int nid = 0;
 
-	nr_nodes = read_once_policy_nodemask(pol, &nodemask);
+	nr_nodes = read_once_policy_package_nodemask(pol, &nodemask);
 	if (!nr_nodes)
 		return numa_node_id();
 
@@ -2695,7 +2807,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	/* read the nodes onto the stack, retry if done during rebind */
 	do {
 		cpuset_mems_cookie = read_mems_allowed_begin();
-		nnodes = read_once_policy_nodemask(pol, &nodes);
+		nnodes = read_once_policy_package_nodemask(pol, &nodes);
 	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 
 	/* if the nodemask has become invalid, we cannot do anything */
@@ -3835,7 +3947,42 @@ static struct kobj_attribute wi_auto_attr = {
 	.store = weighted_interleave_auto_store,
 };
 
+static ssize_t package_mode_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%s\n", str_true_false(READ_ONCE(package_mode_enabled)));
+}
+
+static ssize_t package_mode_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	bool input;
+	int err;
+
+	err = kstrtobool(buf, &input);
+	if (err)
+		return err;
+
+	/*
+	 * Disable package-aware weighted interleave on non-symmetric topologies.
+	 * Non-symmetric topology (e.g., asymmetric CXL memory attachment) can
+	 * cause performance degradation if package-aware allocation is used.
+	 * Reject enable request if topology is not symmetric.
+	 */
+	if (input && !mp_is_topology_symmetric()) {
+		pr_warn("package_mode cannot be enabled on non-symmetric topology\n");
+		return -EINVAL;
+	}
+
+	WRITE_ONCE(package_mode_enabled, input);
+	return count;
+}
+
+static struct kobj_attribute wi_package_mode_attr =
+	__ATTR(package_mode, 0664, package_mode_show, package_mode_store);
+
 static void wi_cleanup(void) {
+	sysfs_remove_file(&wi_group->wi_kobj, &wi_package_mode_attr.attr);
 	sysfs_remove_file(&wi_group->wi_kobj, &wi_auto_attr.attr);
 	sysfs_wi_node_delete_all();
 	wi_state_free();
@@ -3941,6 +4088,10 @@ static int __init add_weighted_interleave_group(struct kobject *mempolicy_kobj)
 	if (err)
 		goto err_put_kobj;
 
+	err = sysfs_create_file(&wi_group->wi_kobj, &wi_package_mode_attr.attr);
+	if (err)
+		goto err_cleanup_kobj;
+
 	for_each_online_node(nid) {
 		if (!node_state(nid, N_MEMORY))
 			continue;
-- 
2.25.1

