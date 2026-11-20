Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198259;
	b=VodSNF8P97riCwDKI/MDxYPFjjd54YiGXM7hlEdgclGImbFNg9xrAmjpIT1rzGOpHJzV
	 qAiBPizSDhRZs5AUPLX1VN6icFNUPQYfoAk9GYTQANJmlz6HdjPbBGyr3663l/k2Pyqs7
	 En1kAtpa159OiBgSqHaNZ7vw/AztMAZ0YVmZI0pU1JBXWs+oZkahCZ8om/I+CR7Z0bHRD
	 1HzU88kIX/CVnguGaDxdLAlNggumB+bMiYzzjo2NOgkwtWDcLGVUU/DhhedNljcKKXGS6
	 OBKG462fJXpmKp6YetjdQbUY3GocrkEOlJpHWReh257tg1oNsui/NFz42LFqK9azDmg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198259;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=X7OURSsmBiNAAKz0czFdC+E/6wbPVxqwq73TmOo8fvs=;
	b=QrN3fIzr/xticzbQeT0uVVf5FOmb+rvmTGidST6jJcln2UX8zNnd9qO95+fEP/ME1JR2
	 H4NLKNquvTg30nmowMs/dkldQ4Jn1rW7kvOOnpDlVNGlcm/CtuFtxVLoS/vHJBrJ9UfwC
	 b9+NSDd9033CaymGBxkZGt80oWMWO/tOlpa/Ax8/tO5EJHMqqC3Jl5y4H3pN6I398Wtar
	 +dRjbwrNLIou1BdSx+s1EGX1C0FY1wbsTfFl5aBQ8vWTnrfgBhngCldz3twR99aJNNtqA
	 WBpZrvS8JCse7Ae92yV5zBpYIGTgKISqoD1Qs6dhdYT8FVpqiX9J4NIGO4qZrWXKeTQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e7ZOw7PY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2E56076376;
	Fri, 20 Nov 2026 18:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e7ZOw7PY
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198259;
	b=NwAlmF9pACrVCD4aHvFPGK9DS7jIAl8ekQRMNwUNhqq5x+CQeX7+RsGvqFQnQ+MgnTyk
	 Aygr4MMqADNYB+UiTE91OR+Q8Znuzj97tybHvYCdsKqtI7Vs7JdXpGFUbOakDw5YyW1NT
	 KS0vjWZ/5QkA81mHnDpDQRLH7EFkIg3wOQ5EUjsPda29ODqs2QyMJEdZdBvaUT2cJSh7C
	 fY+KRN27J88anhcROKT4icC5Q3a9Vwly/mWAWR1B0u/La9A98ZyJ+G4r0YvG+yjEVdR1T
	 SGXUHEeXUoqe9o4ZVcpEuuKALhjCWmWPbQeT42PPLjmTbFx8cqO8rFvcoJWwfgS2YAQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198259;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=X7OURSsmBiNAAKz0czFdC+E/6wbPVxqwq73TmOo8fvs=;
	b=QXIKlvrRDxczHLB4LeytQbJiSpBVfcGnYALKsca8ZZyCb/dn8CfRi31M5kH1NLUs8GQB
	 0w2rU1ai3ZT9RqW5TnAt44gFvBkuayx7gGnAcLRFqkEEv23gN2vFwcoadNei5Syb6K8ZY
	 UPuoav3zJ2z/ZSgjW+DFWgMFZiR25Kxm4gxcDKAVmVv2QDKPYUH4XPdS53BDD00hHH3Gi
	 aTB4b8F8fZNmr8MC0fYBY1hn31XX6yIefi4RAvMCnLpgIPF2FForTStn9Xc+cUWk9Xehx
	 0UPjn79kv3P8D+dlenlk8O0q5mAAT+vqE2Gcsh6UicQ51U5k5uXzbL1Szp7pEX/821Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8090A1F000E6;
	Fri, 20 Nov 2026 18:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198259;
	bh=X7OURSsmBiNAAKz0czFdC+E/6wbPVxqwq73TmOo8fvs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=e7ZOw7PYGCrROb8p+s8vsG92XEZ5rvBlh7ZFVv7vsfZdrS2/0bFgcA5l8mHdrFSxe
	 yV4qm1anZ35/Q1tIoHFkFPLlbvZhywkdBD0TeIL5gWdFQ9zMP7iOVRXuf1/MBsD7xZ
	 B8LJVj8ifJY4hggI7rXaSi4/rYkbPfYDv/cd320ulwnewHUjuMRxQn9e9UY3rZeb74
	 gPbznMiP65LzE4CA6dOSKoXrP202wa8cS6briP4Y59YeIfZg8Bc1FIOtYTFOFhv3uy
	 DPlkKvZy1P4l7uhFhKo63zZoQNWmhXbb7BIkw7mUbQp2IFhxh/OcSIdwZYaiAiTBeM
	 fujGHFh9Cig/A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5D47E4B971;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:35 -0500
Subject: [PATCH 44/60] mm: add N_MEMORY_COMPACTION node state
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-44-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=5165;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=g7ydIdopU0v+cqoPiLJmqWYEIQ70E6DWexCPxxD4cU0=;
 b=Ddw1phUFx8GRbqgTFY+sDiYn8K+6nhCoWRNObiJW/+7XlTHPwI01iZM9GC51adS8pYYGCvW+Y
 J4qL4HCpvf6CbWfMf+rMSh6u7SUxavjyPEy7loBIXocrA9zjhLa1w2G
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Add N_MEMORY_COMPACTION for the nodes compaction may operate on, and
NODE_MEMORY_FEAT_COMPACTION for memory providers to select it.

Common memory carries every feature, so a mask with
NODE_MEMORY_FEAT_COMMON must now include compaction.

The state is internal and has no sysfs file. Internal states follow
N_GENERIC_INITIATOR, so check sysfs coverage only for the states up to
it.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 Documentation/mm/physical_memory.rst |  7 +++++++
 drivers/base/node.c                  |  5 +++--
 include/linux/nodemask.h             | 20 ++++++++++++++++----
 mm/page_alloc.c                      |  4 ++++
 4 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index ddba7c890418..5d0a69f6c23c 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -182,6 +182,12 @@ nodes with particular properties as defined by ``enum node_states``:
 ``N_GENERIC_INITIATOR``
   The node has one or more Generic Initiators
 
+The following states are internal and not exported through sysfs:
+
+``N_MEMORY_COMPACTION``
+  The kernel compacts the node on its own initiative (kcompactd, proactive
+  and explicit compaction).
+
 For each node that has a property described above, the bit corresponding to the
 node ID in the ``node_states[<property>]`` bitmask is set.
 
@@ -194,6 +200,7 @@ For example, for node 2 with normal memory and CPUs, bit 2 will be set in ::
   node_states[N_MEMORY]
   node_states[N_MEMORY_COMMON]
   node_states[N_CPU]
+  node_states[N_MEMORY_COMPACTION]
 
 For various operations possible with nodemasks please refer to
 ``include/linux/nodemask.h``.
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 56a1741a6a45..19f93cda90be 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -1000,8 +1000,9 @@ void __init node_dev_init(void)
 {
 	int ret, i;
 
- 	BUILD_BUG_ON(ARRAY_SIZE(node_state_attr) != NR_NODE_STATES);
- 	BUILD_BUG_ON(ARRAY_SIZE(node_state_attrs)-1 != NR_NODE_STATES);
+	/* Node states after N_GENERIC_INITIATOR have no sysfs file. */
+	BUILD_BUG_ON(ARRAY_SIZE(node_state_attr) != N_GENERIC_INITIATOR + 1);
+	BUILD_BUG_ON(ARRAY_SIZE(node_state_attrs)-1 != N_GENERIC_INITIATOR + 1);
 
 	ret = subsys_system_register(&node_subsys, cpu_root_attr_groups);
 	if (ret)
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 02908ef23a62..2757acffff2b 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -411,6 +411,8 @@ enum node_states {
 	N_MEMORY_PRIVATE,	/* memory outside the common pool */
 	N_CPU,		/* The node has one or more cpus */
 	N_GENERIC_INITIATOR,	/* The node has one or more Generic Initiators */
+	/* Internal states, not exported through sysfs */
+	N_MEMORY_COMPACTION,	/* mm compaction may operate on the node */
 	NR_NODE_STATES
 };
 
@@ -542,16 +544,26 @@ static __always_inline int node_random(const nodemask_t *maskp)
 #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
 #define for_each_node_with_cpus(node)	for_each_node_state(node, N_CPU)
 
-/* Private nodes omit NODE_MEMORY_FEAT_COMMON. */
+/*
+ * Private nodes omit NODE_MEMORY_FEAT_COMMON. Their providers opt into
+ * individual MM services with the remaining bits.
+ */
 #define NODE_MEMORY_FEAT_COMMON		BIT(0) /* add to fallback zonelist */
-#define NODE_MEMORY_FEAT_ALL		NODE_MEMORY_FEAT_COMMON
+#define NODE_MEMORY_FEAT_COMPACTION	BIT(1) /* mm compaction */
+#define NODE_MEMORY_FEAT_ALL		(NODE_MEMORY_FEAT_COMMON | \
+					 NODE_MEMORY_FEAT_COMPACTION)
 
-/* Private memory needs NUMA: node 0 holds all memory without it. */
+/*
+ * Common memory carries every feature. Private memory needs NUMA: node 0
+ * holds all memory without it.
+ */
 static inline bool node_memory_features_valid(unsigned long features)
 {
 	if (features & ~NODE_MEMORY_FEAT_ALL)
 		return false;
-	return IS_ENABLED(CONFIG_NUMA) || (features & NODE_MEMORY_FEAT_COMMON);
+	if (features & NODE_MEMORY_FEAT_COMMON)
+		return features == NODE_MEMORY_FEAT_ALL;
+	return IS_ENABLED(CONFIG_NUMA);
 }
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b7339bc634d5..335ce73e645e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -204,6 +204,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 #endif
 	[N_MEMORY] = { { [0] = 1UL } },
 	[N_MEMORY_COMMON] = { { [0] = 1UL } },
+	[N_MEMORY_COMPACTION] = { { [0] = 1UL } },
 	[N_CPU] = { { [0] = 1UL } },
 #endif	/* NUMA */
 };
@@ -218,10 +219,13 @@ void __meminit node_set_memory_state(int nid, unsigned long features)
 		node_set_state(nid, N_MEMORY_COMMON);
 	else
 		node_set_state(nid, N_MEMORY_PRIVATE);
+	if (features & NODE_MEMORY_FEAT_COMPACTION)
+		node_set_state(nid, N_MEMORY_COMPACTION);
 }
 
 void __meminit node_clear_memory_state(int nid)
 {
+	node_clear_state(nid, N_MEMORY_COMPACTION);
 	node_clear_state(nid, N_MEMORY_PRIVATE);
 	node_clear_state(nid, N_MEMORY_COMMON);
 	node_clear_state(nid, N_MEMORY);

-- 
2.56.1


