Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198229;
	b=xSFLxJqQVA5daXvZ9+F9CKkbvCyy2BhWf3Av0WfqPyoq2kb1JqUseMJ5N0FWIX+bADzG
	 iYn0nm1j9Jw8dhp4pCqR0RhZ0/0IjuLgwM+DlPoMuEwozacncn4di636DHL9mwFv/p6n2
	 DizUU6ygPmM5ElzT0UoVW55GCdJj/4ADSj2JSyKft34T5MNY1hoWB8lmUbY8pSAwkR2z+
	 uK1sweMnDpJkw1fFXsTH9I6EqQJoR8sAsvcd8+2DJLhaJYQccO+aP0ygaUDx6zprbEUL+
	 ocjRHD8iPG5PGsVolqIPrdfZT1P81m7ARI1mBTgVcwpZtp/MKlJ6rTi8OoPjv+041/w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198229;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=h5CrkAO7T3P4r+Yv8Uixoo1Sg+wKyzQuc9jCr1lsfYI=;
	b=UUkZScWAlgeV5ZxKGg3V2JnvlWce9SBRCS0K1FR/R4QlBVt6+2K7UuSCp1Fe8ookkhL6
	 YUvLgQpypHMHIDBxKiAeeodSm6Gm1riJ/13GUHe0FiaMrw14LwxHE3ra47dsF8/FQ5ebj
	 uNXmTjxqOvJnzPI7HppEUvZ6LgkGgDOS9cTNFiK4wvK75L0iexBRIP/OKIjeJ/h7ooVSR
	 tIEsEGUcYOjfiyEq1IgV9ux6pQD47z8GeyTapN9TcBCMuX6SaQ8SiGk6fjr9QG84i3tHK
	 eFvVzG+nlorgK0+Tr5pIKTeo15EgD8KZqjThFE1nIlX8uuVXn8taqcY0urz28Tst37g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PEMQ5p97;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DBD6070705;
	Fri, 20 Nov 2026 18:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PEMQ5p97
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198229;
	b=fL3698cph9B5PR1DuRjx1FKm7OKlKp1p7TB2WZGUCtJ2Ah9iU9VhRVHfvcLz0cfo73pR
	 7Kd5IchaLvGo5mBFSpvnmoiExAaDJ3cImwP4cIRhGRZJqMJoAK0O1e6LlNRfonap77C76
	 nIXAQNxKsJdbJiiiogMfpubwvKaTZPakLr9OZM25XwKRwoRtbiQozqQZZPHYbO8h+w9yG
	 6c8k3OO8+Dfla966K3jl1f6Jo/zEToT/LeX7HCPrVnTrPgzNswT1y914So1PWezOzqvga
	 qvWzs8cNSypy6RtJuywW8n3Va5pMU/Ys+AnReDbUPR3MnJS2RZ7dkexwcZ8smQ3V8Lw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198229;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=h5CrkAO7T3P4r+Yv8Uixoo1Sg+wKyzQuc9jCr1lsfYI=;
	b=vJ06JvfW846PVGJzY2hXOxlPjOgBmTZGG3M2X0UrBWGk51MWseAMfJIihWOvha0feXgI
	 56OPeK6DayRyRiN09OSijXsaWGFsbuhNxYKf5ui6b2Lj8SsbL3iGhx4sQ8zNKvSAdlg2N
	 f7+zn0dZzbLp5UUWw/wZc5hEvyHQz9DN51r9IVsem1LDBbCdQh1d70iY686S+rw6FF4uN
	 kR33a7t0UpHlhYDnau8L273Bqgj25T/k4maxjgZ96QJ3uH2Fcl/MoLzhMvEu3FPS9Xqve
	 JDTTV0Fo0/8CSE0/2nhhvT1yc8zkjuT37HVzdXAfovPqCnBWQuSQ0b14pkB53Xh+OkA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 18B381F00ADE;
	Fri, 20 Nov 2026 18:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198228;
	bh=h5CrkAO7T3P4r+Yv8Uixoo1Sg+wKyzQuc9jCr1lsfYI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=PEMQ5p97f9te06mMZb7I9Toy80Us+kqNrrikAtCFbhggxQvoYi4k2XTBBnWdot76o
	 CreiKHYvms7Jg/EXakvVs0x/nqccsWywPZVd5NMtneGAU9OdA936gKXXHa6KEYdzdC
	 jzrplmrJL5tPf+wdJIkS4k7wC+AZrH3EvDrG0nDubKikJ2kEZBSh3UcgOTxGto6Yix
	 F1d4GhCLXuTuDz8BL+IBakh8iKzhw2JLFqTlLPEvS0wrbIbVe4/rksf8Cm95wS9fyp
	 dV3itcIMbS7b27CLzOPplZmSdT7Kgp8n9yM/uXrUMGmk6blk4gExUbE17gmO94QPmM
	 ERXxq6wHRXFVg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6165E4B931;
	Fri, 20 Nov 2026 18:09:20 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:19 -0500
Subject: [PATCH 28/60] mm: select memory features per node
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
Message-Id: <20261120-private_nodes_v6-v1-28-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=5275;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=9jUUwkC009YYM3M0mBtUlaNrodM1BEI0oddfspLz38Q=;
 b=5b31/KbUha2vmTFlmfGTvBU6RaiMU83nXseyWRCHS71c1Cr/i7oXIqQHzSTf3Q6kBHMj+p+V+
 CK3q0HN/ldxA/gpmxCF2drBz2uSDsxWLaQZ+5aY3hV5E9HSjJvI/Gfl
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Whether a node's memory is common or private is a property of the
memory, so record it per node.

Add a per-node memory feature mask (pgdat->memory_features) with a
single bit for common memory. Node states are published from the node's
features at boot and when memory is onlined. A node without the common
bit joins N_MEMORY_PRIVATE.

Ordinary System RAM carries every feature. Without NUMA, node 0 holds
all memory, so a mask without common memory is invalid.

Every node keeps the default mask, so all memory remains common.

Suggested-by: Dan J Williams <djbw@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mmzone.h   |  1 +
 include/linux/nodemask.h | 12 ++++++++++++
 mm/internal.h            |  2 +-
 mm/memory_hotplug.c      |  2 +-
 mm/mm_init.c             |  7 ++++++-
 mm/page_alloc.c          |  9 +++++++--
 6 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6a2ad0cff795..d6c1a43c0bc8 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1612,6 +1612,7 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+	unsigned long memory_features;	/* NODE_MEMORY_FEAT_* mask */
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 5a9722d57701..02908ef23a62 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -542,6 +542,18 @@ static __always_inline int node_random(const nodemask_t *maskp)
 #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
 #define for_each_node_with_cpus(node)	for_each_node_state(node, N_CPU)
 
+/* Private nodes omit NODE_MEMORY_FEAT_COMMON. */
+#define NODE_MEMORY_FEAT_COMMON		BIT(0) /* add to fallback zonelist */
+#define NODE_MEMORY_FEAT_ALL		NODE_MEMORY_FEAT_COMMON
+
+/* Private memory needs NUMA: node 0 holds all memory without it. */
+static inline bool node_memory_features_valid(unsigned long features)
+{
+	if (features & ~NODE_MEMORY_FEAT_ALL)
+		return false;
+	return IS_ENABLED(CONFIG_NUMA) || (features & NODE_MEMORY_FEAT_COMMON);
+}
+
 /*
  * For nodemask scratch area.
  * NODEMASK_ALLOC(type, name) allocates an object with a specified type and
diff --git a/mm/internal.h b/mm/internal.h
index cd0562f0b68f..e89dd1153662 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -62,7 +62,7 @@ void lru_add_drain_cpu_zone(struct zone *zone);
 void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
 
-void node_set_memory_state(int nid);
+void node_set_memory_state(int nid, unsigned long features);
 void node_clear_memory_state(int nid);
 
 /*
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6b6873cfbc5a..b4d94021d46e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1197,7 +1197,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
 	if (node_arg.nid >= 0)
-		node_set_memory_state(nid);
+		node_set_memory_state(nid, NODE_DATA(nid)->memory_features);
 	/*
 	 * Check whether we are adding normal memory to the node for the first
 	 * time.
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f21b3dbcc92a..99a45fd04ac5 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1585,6 +1585,9 @@ int __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 	pgdat->node_start_pfn = 0;
 	pgdat->node_present_pages = 0;
 
+	/* memory is common unless marked private */
+	pgdat->memory_features = NODE_MEMORY_FEAT_ALL;
+
 	/*
 	 * Hot-unplug can leave per-cpu vmstat deltas unfolded (folders skip
 	 * offline nodes) - reconcile this at online. Foreign access to counters
@@ -1743,6 +1746,8 @@ static void __init free_area_init_node(int nid)
 
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = start_pfn;
+	/* memory is common unless marked private */
+	pgdat->memory_features = NODE_MEMORY_FEAT_ALL;
 
 	if (start_pfn != end_pfn) {
 		pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
@@ -1768,7 +1773,7 @@ static void __init check_for_memory(pg_data_t *pgdat)
 {
 	enum zone_type zone_type;
 
-	node_set_memory_state(pgdat->node_id);
+	node_set_memory_state(pgdat->node_id, pgdat->memory_features);
 
 	for (zone_type = 0; zone_type <= ZONE_MOVABLE - 1; zone_type++) {
 		struct zone *zone = &pgdat->node_zones[zone_type];
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 50336eb58edf..3a7c12fec906 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -209,10 +209,15 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 };
 EXPORT_SYMBOL(node_states);
 
-void __meminit node_set_memory_state(int nid)
+void __meminit node_set_memory_state(int nid, unsigned long features)
 {
+	WARN_ON_ONCE(!node_memory_features_valid(features));
+
 	node_set_state(nid, N_MEMORY);
-	node_set_state(nid, N_MEMORY_COMMON);
+	if (features & NODE_MEMORY_FEAT_COMMON)
+		node_set_state(nid, N_MEMORY_COMMON);
+	else
+		node_set_state(nid, N_MEMORY_PRIVATE);
 }
 
 void __meminit node_clear_memory_state(int nid)

-- 
2.56.1


