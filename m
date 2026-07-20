Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC574C9560
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576160; cv=none; b=tOfa0mXEWV/fQBfIhdhFEsANMxdggId9MdDJrsrq3SBkA2bEZLK1q4TT7g5tP4+cilkkTav5BTm23wxnIFsX4saYNWHrQrG0EzT79EKVAkAVrQkqfGhEtdwDVhJ6Oaek1p18LOqrj5hG4l8vVpLZOQiqGBFYZ8cZ8xbXFtwjM4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576160; c=relaxed/simple;
	bh=2i1wvyBksR/msTLbpyy04DkOkxRMBM4AkFK/rJ1LuiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvhY0aAqxOni3c8bI+eX024aA2wCEwTSptPR9FC0TQlE5eyPrF/X64Jf4Cv9ClscQ3UknQGaU8RnWrgg6jkGfQBo6PiMYsLiSXe04RfxQG8M2qc9okuaBNT3kHLsdyNYa4Ko7zEKjYcl2K+UWyDDAgQb+9/CYr4E/XrM4gzRaNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=H1rKQ/hE; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="H1rKQ/hE"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92ed19f4d60so369342985a.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576155; x=1785180955; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+NQTGhXcHOKD56hvRpu1GEGtUFet41BSGHJhkUlyGRA=;
        b=H1rKQ/hEY+fAIYljWPo0cqVLXq0Qo5XC3mPrlr7wIo/NNLOd34BAp++fbY8JiFlVvc
         fr8opFZgksGRwYkcwvniFpMTp9+dvB7HCSKkzBipAX43N17SdoNmc1M/35Fkgi54hOZt
         6Fvtcukl12YV+RpKoYoaoxBEkssIJd4TJWtM4Cm2mPlcUQ06L8ZpRkWJaSD2J/6mYf3u
         QwgpViVpYsXu0ZNC78zqrPnIQ/U8Y1CUCVmr0Ig6o4OMVxTDheazKoQUt1345gpU3MlG
         /tkYEds8e0fF50h6oAZtIrR6eiY1Qc0poyZcI+iG+cX5F6MzYcV02JpcNiwCmiK3RVI6
         h0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576155; x=1785180955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+NQTGhXcHOKD56hvRpu1GEGtUFet41BSGHJhkUlyGRA=;
        b=eouUOv4+676DUquX5jk4EENxD7179SeCj6gyUop2JRCmS7ClkloFAOgS+ylGTHrlfB
         5k6US022xd9esdfTEgQTa+X1q9u8MdCHrzagZt6s7vjMTecwg/dFG2/3JucooRDTJhla
         CoEZwV+wirutZucKHp+16S59lH9ELfrEK44ZP9HEVgQ53NHqNvfl9hZcZxEIiCpnOVC+
         IDBeqkTMqo4Q6m4A+RtoxFqvkM2S5ib94KiajRgBiADpx6uKGnt2hBNNpUyfBvC5eoaZ
         47ynvL0Krv0RHSejAsqihYqJdf1oNIgFXWbkApeNbsQv/gviMWDFVD03CNeeGLoVMnkn
         7xlw==
X-Forwarded-Encrypted: i=1; AHgh+RpwEwnfgc1Y14h2H0UC57rIG05seo24gB7BZEEK/j82qOX1F9POQl9l4DSD9ZDKTuee/DPfoUI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKc75PXxJ8v/VsVlb1qe/czPfTLRZPC6ygWZhensP8AZmLX87s
	VJYQWRs6YIZjiLP8PFMY41IAlTVwxy8seRNfjLGLZOFDBXZkRyjcpCMsKXnJ7bZYFcE=
X-Gm-Gg: AfdE7clwBYN3rmS+Jf5ynrIFwWBtO4GP2bGFYPabInvE5y0IWw8AVejNx07mWZPXdvq
	JqYykNtwBCvJF86JnYaV+WIAPWymMow1Cq+MeoqWe52/6Qan6usTZaFCxlQKwAXmN3Agt27ju7N
	/ribzLGiZWJ22fwVmj5rAGyrdUela8f4n923s5RraIgmQ6f/o5qoRxCvcVDbk/6uPPpQGVZWDz9
	sLEJtGWZ/0lbCwj71mAI8gmgRDjiIkUKrlMRv+xnBI7P/nXnwrLlSSkqkIvQUl4WmtbbYuaHp9c
	Utokp73bWUpAfhBnRn8hngXQ1EiJDGcua3nGzz1Nbhukt/LJEcY82oOW22cWzd121GZM1dyJyhJ
	uJlZVgzqOTKdmzBNTxy47g/2oUkc3DNRY9D8NUIrpsXKDFlivndGe7+mbwNE6Z+4n2yVYk+aAXG
	PFhWU1fqS3zXvsTQF0JEcYJEszFK9Z4JcvfpoTQRdGD1TEbqZnVq4SkuR7M0DuD2uRPoA52D0ax
	Q==
X-Received: by 2002:a05:620a:288a:b0:915:29cd:306c with SMTP id af79cd13be357-930a5f1a98fmr1940964285a.9.1784576154411;
        Mon, 20 Jul 2026 12:35:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:54 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 29/36] mm: add NODE_PRIVATE_CAP_DEMOTION for private-node tiering demotion
Date: Mon, 20 Jul 2026 15:34:23 -0400
Message-ID: <20260720193431.3841992-30-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A private node is invisible to the tiering/demotion hierarchy by default:
memory-tiers.c never includes it, so reclaim never demotes onto it.

Add NODE_PRIVATE_CAP_DEMOTION to opt a private node into demotion.

When set, memory-tiers adds the node to the demotion set and reclaim's
demote path may target it (allocating from the private zonelist).

Demotion is driven by reclaim, so CAP_DEMOTION requires CAP_RECLAIM.
Otherwise the node can either fill up and drive odd system-wide OOM
behavior, or demotion doesn't work (nothing can demote from the node).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/node.c          |  5 +++++
 include/linux/node_private.h | 30 +++++++++++++++++++++++++++++
 mm/memory-tiers.c            | 37 +++++++++++++++++++++++++++---------
 mm/vmscan.c                  |  4 ++++
 4 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 94cd51f51b7e8..3d61ca1b805dc 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -896,6 +896,11 @@ int node_private_register(int nid, struct node_private *np)
 	if (!np || !node_possible(nid))
 		return -EINVAL;
 
+	/* Demotion is driven by reclaim, so it requires reclaim. */
+	if ((np->caps & NODE_PRIVATE_CAP_DEMOTION) &&
+	    !(np->caps & NODE_PRIVATE_CAP_RECLAIM))
+		return -EINVAL;
+
 	mutex_lock(&node_private_lock);
 	mem_hotplug_begin();
 
diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 7b617b1fa9c28..87b03444b2c97 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -15,6 +15,7 @@ struct page;
 #define NODE_PRIVATE_CAP_RECLAIM	(1UL << 0)	/* allow mm reclaim */
 #define NODE_PRIVATE_CAP_USER_NUMA	(1UL << 1)	/* allow mempolicy */
 #define NODE_PRIVATE_CAP_HOTUNPLUG	(1UL << 2)	/* allow hot-unplug */
+#define NODE_PRIVATE_CAP_DEMOTION	(1UL << 3)	/* allow tiering demotion */
 
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
@@ -118,6 +119,30 @@ static inline bool node_allows_hotunplug(int nid)
 	return ret;
 }
 
+/**
+ * node_allows_demotion - may kernel tiering demote to this node?
+ * @nid: the node to test
+ *
+ * Governs whether a private node participates in the demotion hierarchy.
+ * Demotion accumulates pages on the node, so CAP_DEMOTION requires CAP_RECLAIM
+ * (enforced at registration) as a safety valve.
+ *
+ * return: true for normal nodes and private nodes opted into CAP_DEMOTION.
+ */
+static inline bool node_allows_demotion(int nid)
+{
+	struct node_private *np;
+	bool ret;
+
+	if (!node_state(nid, N_MEMORY_PRIVATE))
+		return true;
+	rcu_read_lock();
+	np = rcu_dereference(NODE_DATA(nid)->node_private);
+	ret = np && (np->caps & NODE_PRIVATE_CAP_DEMOTION);
+	rcu_read_unlock();
+	return ret;
+}
+
 #else /* !CONFIG_NUMA */
 
 static inline bool folio_is_private_node(struct folio *folio)
@@ -150,6 +175,11 @@ static inline bool node_allows_hotunplug(int nid)
 	return true;
 }
 
+static inline bool node_allows_demotion(int nid)
+{
+	return true;
+}
+
 #endif /* CONFIG_NUMA */
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 25e121851b586..c673080d153e4 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -7,6 +7,7 @@
 #include <linux/memory-tiers.h>
 #include <linux/notifier.h>
 #include <linux/sched/sysctl.h>
+#include <linux/node_private.h>
 
 #include "internal.h"
 
@@ -317,6 +318,21 @@ void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
 	rcu_read_unlock();
 }
 
+/* Tiering set: N_MEMORY | (N_MEMORY_PRIVATE w/ CAP_DEMOTION) */
+static nodemask_t tierable_nodes;
+
+static void update_tierable_nodes(void)
+{
+	int node;
+
+	lockdep_assert_held_once(&memory_tier_lock);
+
+	tierable_nodes = node_states[N_MEMORY];
+	for_each_node_state(node, N_MEMORY_PRIVATE)
+		if (node_allows_demotion(node))
+			node_set(node, tierable_nodes);
+}
+
 /**
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
@@ -330,7 +346,7 @@ void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
 int next_demotion_node(int node, const nodemask_t *allowed_mask)
 {
 	struct demotion_nodes *nd;
-	nodemask_t mask;
+	nodemask_t mask, tierable;
 
 	if (!node_demotion)
 		return NUMA_NO_NODE;
@@ -370,7 +386,8 @@ int next_demotion_node(int node, const nodemask_t *allowed_mask)
 	 * closest demotion target.
 	 */
 	nodes_complement(mask, *allowed_mask);
-	return find_next_best_node_in(node, &mask, &node_states[N_MEMORY]);
+	tierable = tierable_nodes;
+	return find_next_best_node_in(node, &mask, &tierable);
 }
 
 static void disable_all_demotion_targets(void)
@@ -378,7 +395,7 @@ static void disable_all_demotion_targets(void)
 	struct memory_tier *memtier;
 	int node;
 
-	for_each_node_state(node, N_MEMORY) {
+	for_each_node_mask(node, tierable_nodes) {
 		node_demotion[node].preferred = NODE_MASK_NONE;
 		/*
 		 * We are holding memory_tier_lock, it is safe
@@ -401,7 +418,7 @@ static void dump_demotion_targets(void)
 {
 	int node;
 
-	for_each_node_state(node, N_MEMORY) {
+	for_each_node_mask(node, tierable_nodes) {
 		struct memory_tier *memtier = __node_get_memory_tier(node);
 		nodemask_t preferred = node_demotion[node].preferred;
 
@@ -435,9 +452,10 @@ static void establish_demotion_targets(void)
 	if (!node_demotion)
 		return;
 
+	update_tierable_nodes();
 	disable_all_demotion_targets();
 
-	for_each_node_state(node, N_MEMORY) {
+	for_each_node_mask(node, tierable_nodes) {
 		best_distance = -1;
 		nd = &node_demotion[node];
 
@@ -455,7 +473,7 @@ static void establish_demotion_targets(void)
 		 * nodelist to skip list so that we find the best node from the
 		 * memtier nodelist.
 		 */
-		nodes_andnot(tier_nodes, node_states[N_MEMORY], tier_nodes);
+		nodes_andnot(tier_nodes, tierable_nodes, tier_nodes);
 
 		/*
 		 * Find all the nodes in the memory tier node list of same best distance.
@@ -464,7 +482,7 @@ static void establish_demotion_targets(void)
 		 */
 		do {
 			target = find_next_best_node_in(node, &tier_nodes,
-							&node_states[N_MEMORY]);
+							&tierable_nodes);
 			if (target == NUMA_NO_NODE)
 				break;
 
@@ -503,7 +521,7 @@ static void establish_demotion_targets(void)
 	 * allocation to a set of nodes that is closer the above selected
 	 * preferred node.
 	 */
-	lower_tier = node_states[N_MEMORY];
+	lower_tier = tierable_nodes;
 	list_for_each_entry(memtier, &memory_tiers, list) {
 		/*
 		 * Keep removing current tier from lower_tier nodes,
@@ -550,7 +568,8 @@ static struct memory_tier *set_node_memory_tier(int node)
 
 	lockdep_assert_held_once(&memory_tier_lock);
 
-	if (!node_state(node, N_MEMORY))
+	/* Include N_MEMORY and N_MEMORY_PRIVATE with CAP_DEMOTION */
+	if (!node_state(node, N_MEMORY) && !node_allows_demotion(node))
 		return ERR_PTR(-EINVAL);
 
 	mt_calc_adistance(node, &adist);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f1722693ac2db..b617f7cd1e716 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -963,6 +963,10 @@ static struct folio *alloc_demote_folio(struct folio *src,
 
 	mtc = (struct migration_target_control *)private;
 
+	if (mtc->nmask &&
+	    nodes_intersects(*mtc->nmask, node_states[N_MEMORY_PRIVATE]))
+		mtc->alloc_flags = ALLOC_ZONELIST_PRIVATE;
+
 	/*
 	 * make sure we allocate from the target node first also trying to
 	 * demote or reclaim pages from the target node via kswapd if we are
-- 
2.53.0-Meta

