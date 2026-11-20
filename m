Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198280;
	b=5Ms/icO3u/iXnenJi9PxIltOqxhaSlZZ30y5ZUtrv32jQOFmE2eziwTpyniuRu7cogOv
	 2AIL9+goFpG/lsmNSY1hnfUqLoQ9OeEIjROpZGkvtYjM9r5mhQ3UI89kblOBb4O61ffs2
	 o30eazUPfXmMgK4q5FVlkIVkzfR6AgiwVDfugN4XbTYUcC5vTvFV0L1D1yK4qV1KD4stu
	 rxaQTFROP9Us5cDLHGpPlxFhnBldNqNLnFL0+Cac0XZ6jAtyj1sKqqFWxVhIvjIP8OYXA
	 HY/shhlsRZh25AlCf+Rd0IJHhCocgwVPS75674ANLifuRCJvz2uTlYBskJCjS4cKs0w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198280;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=imMR3p2duQqhNdG0Ig5xxDisuLnpgFn7S+h/c9cqvAo=;
	b=du2MWD0Dw742use+nlOEowWx2moDLnq2c+g65T04wiUDKHpE6NNFKEYrafjAr+QWIHdw
	 zT79Ed1sDvXJaQiyGufp14ZcwzYx0hc1Ih6mpgqDtWKM4rzDWO9gWnyB1OyqfUet9oRUf
	 pPOc2eoXsFIyVmXI9xGwcnY2L0Y6P/MKH4OXVipdw0b3BWxUwugau8+obx+4z69QddWlT
	 wzvpfZGAtvvsboFZ0YiVEO9vVx5rzJbYyVwYzWDedblOIgfp6VCzeKX0QCzpagRyHYvu4
	 n1Mo60+927r5Qh2Ph4rfuVgvkC38BRe14pvga8Km2CnMLjakJHpiHxjYU+MKqg4PPfw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BnD2RIMI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A146078DDD;
	Fri, 20 Nov 2026 18:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BnD2RIMI
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198280;
	b=Yf1aEbpkzikzIqVNDBbPCx2vIOb/n74lTRPUm9enAbAvryNRkbxofWlBn6TacQZc1g2w
	 DrI2T77dqmj+yK1n1EZm8VByLSBkjwvVEBrcaiqqflMPQrcCwh88eiFXffKRWigYJMAEx
	 EMu0IubBzjcFy2WRW3yDu7ZpBBITUuZh176CpzWFDPuTFR45meLEM8aYX3/9z8z+j2l+w
	 v8sfbwlRRPViiypN0HtI2o7gd2OzYB10a+nK10JtFGIlVX+YeYsrbfya4sEWEq3vqNrnV
	 BsCJtVhd6GFcrMMxb6OJHXkuA802dj4SeVAyii1DEYPNbYtWrW3/KA5GGhQD5gWlP7w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198280;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=imMR3p2duQqhNdG0Ig5xxDisuLnpgFn7S+h/c9cqvAo=;
	b=uGMBjDJuoL2XY+fr1QWAg4aMByVDnu3nr8ilySyFeErQ+Ge74vqbpPJAyyhcXsKWNqcc
	 Ky5jW8yYRuZqj2A2D2XEPx6gqlUOZMx+LeX0b431bid3RCmcoY9fkRXnkFbE3duhL+CJJ
	 JU2v7gPNkm4msRpzI/CGad/mDN77FgC4w/QX0Y33aTr4FXffJKbOZflPNQTEOOxm9TWpM
	 2wyH4SQ73Vb3G0gZwT+6/pdxhRe4L4+Zp8+IRK1Xc4gjuhP50I/8IvdYwEyPrdEk8wcSK
	 NPmgFF0/KhcrMbJtAnq4CR0m3myBJxJiIuxA+xtgSHu18FekO+QK8m9tVprPJiXlAVQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4D9B81F0156F;
	Fri, 20 Nov 2026 18:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198280;
	bh=imMR3p2duQqhNdG0Ig5xxDisuLnpgFn7S+h/c9cqvAo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=BnD2RIMI7V38GP4lrJkUPfKZ1qi3SXnHGsE1xZANnq3BbWl1waLaY4sWNxnzUvmMk
	 M+RSTkPDJ/kxtyccwGZBGDcMzmPHfcEFHeto1mfKNjC3NjKlnAvMTLRZadSSWK9RQY
	 T2/fdoC+oH25n8YBK9RgfTN+fu966iSfgN2PaDOl9SzY4YyIU01RZJVrYbGxxmS8l6
	 jxvAD/mLxYwwZn1kIU0n1AA8nzk2AbJ6MXLSO9FwWl5xGBecAwD5HhIiokBTXEkVJL
	 0HGTz8mGc370cPkJK+w8IGirmowsSOVcUV8c1l82fA23B5RhJlv6/niidUS9Rrf7LT
	 tzTCVQ4NnExeg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1AF6E4B988;
	Fri, 20 Nov 2026 18:09:23 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:41 -0500
Subject: [PATCH 50/60] mm: add N_MEMORY_MEMPOLICY node state
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
Message-Id: <20261120-private_nodes_v6-v1-50-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=4477;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=POrrod7a8qe5/RJcpG1x1W6f1yuN7ZdnOW2+WhH0FXE=;
 b=aTDMy5aQgR/eu/TnyoctRRRg14g5CIETIw3u4dDaQdYVGncbixZ+T0SNCnrlFn6DFrsn4+Zg1
 q8XW52q1jYMDuHrNhBZsCfARwTf3Qz3aNp9IhHdIxv9ybHyAJ3U5en6
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Add N_MEMORY_MEMPOLICY as an internal state for the nodes that memory
policy interfaces and explicit migration may target, and
NODE_MEMORY_FEAT_MEMPOLICY for memory providers to select it.

Userspace placement lets ordinary processes use the node like any other
memory. That assumes the node is reclaimed and compacted, so the feature
requires both.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 Documentation/mm/physical_memory.rst |  3 +++
 include/linux/nodemask.h             | 11 +++++++++--
 mm/page_alloc.c                      |  4 ++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index 1bafe8c085a3..75752c3a5694 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -190,6 +190,8 @@ The following states are internal and not exported through sysfs:
 ``N_MEMORY_RECLAIM``
   The kernel reclaims the node on its own initiative (kswapd, memcg and
   explicit reclaim).
+``N_MEMORY_MEMPOLICY``
+  Memory-policy interfaces and explicit migration may target the node.
 
 For each node that has a property described above, the bit corresponding to the
 node ID in the ``node_states[<property>]`` bitmask is set.
@@ -205,6 +207,7 @@ For example, for node 2 with normal memory and CPUs, bit 2 will be set in ::
   node_states[N_CPU]
   node_states[N_MEMORY_COMPACTION]
   node_states[N_MEMORY_RECLAIM]
+  node_states[N_MEMORY_MEMPOLICY]
 
 For various operations possible with nodemasks please refer to
 ``include/linux/nodemask.h``.
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index be5edbee2b22..c7a1800d9171 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -414,6 +414,7 @@ enum node_states {
 	/* Internal states, not exported through sysfs */
 	N_MEMORY_COMPACTION,	/* mm compaction may operate on the node */
 	N_MEMORY_RECLAIM,	/* mm reclaim may operate on the node */
+	N_MEMORY_MEMPOLICY,	/* memory policy may target the node */
 	NR_NODE_STATES
 };
 
@@ -552,14 +553,17 @@ static __always_inline int node_random(const nodemask_t *maskp)
 #define NODE_MEMORY_FEAT_COMMON		BIT(0) /* add to fallback zonelist */
 #define NODE_MEMORY_FEAT_COMPACTION	BIT(1) /* mm compaction */
 #define NODE_MEMORY_FEAT_RECLAIM	BIT(2) /* mm reclaim */
+#define NODE_MEMORY_FEAT_MEMPOLICY	BIT(3) /* userspace NUMA controls */
 #define NODE_MEMORY_FEAT_ALL		(NODE_MEMORY_FEAT_COMMON | \
 					 NODE_MEMORY_FEAT_COMPACTION | \
-					 NODE_MEMORY_FEAT_RECLAIM)
+					 NODE_MEMORY_FEAT_RECLAIM | \
+					 NODE_MEMORY_FEAT_MEMPOLICY)
 
 /*
  * Common memory carries every feature. Private memory needs NUMA: node 0
  * holds all memory without it. Reclaim leaves high-order requests to
- * compaction, so it requires compaction.
+ * compaction, so it requires compaction. Userspace placement assumes the
+ * node is reclaimed and compacted like any other memory.
  */
 static inline bool node_memory_features_valid(unsigned long features)
 {
@@ -570,6 +574,9 @@ static inline bool node_memory_features_valid(unsigned long features)
 	if ((features & NODE_MEMORY_FEAT_RECLAIM) &&
 	    !(features & NODE_MEMORY_FEAT_COMPACTION))
 		return false;
+	if ((features & NODE_MEMORY_FEAT_MEMPOLICY) &&
+	    !(features & NODE_MEMORY_FEAT_RECLAIM))
+		return false;
 	return IS_ENABLED(CONFIG_NUMA);
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cc70e1b45322..eff9c3d8251f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -206,6 +206,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 	[N_MEMORY_COMMON] = { { [0] = 1UL } },
 	[N_MEMORY_COMPACTION] = { { [0] = 1UL } },
 	[N_MEMORY_RECLAIM] = { { [0] = 1UL } },
+	[N_MEMORY_MEMPOLICY] = { { [0] = 1UL } },
 	[N_CPU] = { { [0] = 1UL } },
 #endif	/* NUMA */
 };
@@ -224,10 +225,13 @@ void __meminit node_set_memory_state(int nid, unsigned long features)
 		node_set_state(nid, N_MEMORY_COMPACTION);
 	if (features & NODE_MEMORY_FEAT_RECLAIM)
 		node_set_state(nid, N_MEMORY_RECLAIM);
+	if (features & NODE_MEMORY_FEAT_MEMPOLICY)
+		node_set_state(nid, N_MEMORY_MEMPOLICY);
 }
 
 void __meminit node_clear_memory_state(int nid)
 {
+	node_clear_state(nid, N_MEMORY_MEMPOLICY);
 	node_clear_state(nid, N_MEMORY_RECLAIM);
 	node_clear_state(nid, N_MEMORY_COMPACTION);
 	node_clear_state(nid, N_MEMORY_PRIVATE);

-- 
2.56.1


