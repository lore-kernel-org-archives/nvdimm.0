Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198176;
	b=4dL8+dTWejH1mUTa7IThbqOb85sF6q1bTVhQ70dGplui2f2hnvfQVfH6lvbpSbjAT2Er
	 SG/cG+cfAYA/RpclCTFMhX54gmY8pvNtCSmRs+W60BGb2wrYIY+wXo6Fu1I6X+fpNIlVS
	 b7bSM1LBqMewcmLRYeqyBrfmG6H0hsRG4LC2CRNjPyJY3a1JZUpvnfLfEva1vwEHrewaO
	 UuCvfIHC/h1qhPDYq5jKIokTtlmZ9y9Cj5pfuogh0tL1uiFLMuN6ZlLzHI22MVSg2CXoI
	 2SxfoHVvO5I/FeKXSmzBRvpstOT8xnlDnGWD8R4ohsR2G48HF6i2AQ7mCtmAYdPC+1Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198176;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=HDhBzinWWamnegvT9ExdyfioDJiSgPrUC+Mo3CWLBjU=;
	b=BWCkgr478rj061l0dNYoashO4K69mL4d65GBgRaklphXZIRQPyLvOu0NkWfIfVnw0y9G
	 TnEf1AOI0eC3/sizpPNCv4Oi0XDquFIJ2KleHnCTpq9791Gm5NcZe7HoJpp24SX0DJbwx
	 HpWh5MAmIqCyS9tSeUxanvmTKmoTC+xyMfziJcDPsSU6aLaO3wiB5fwa7+yLDAsSTK1YT
	 5lyEGrQHmEtA+bLGpePnb4jWdYEYHBkO8kwQOjp6A43gxW9e9B9vWUlO3O9cM+Sy/Ncc5
	 6IzPaEOlhkOtm1fBsa2Q0fSb5/Oreh1eMTVXPp9cAmXP2+5B2V06uEiw2jBFXi6qS4w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nss9RHgS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A43F606A883;
	Fri, 20 Nov 2026 18:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nss9RHgS
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198176;
	b=u/AFiC68+xdVbrbQYrVI0U7/li9o8eap+AYhTBOklDAWrj2dzjqSrX1oLkH0OtPP9sIX
	 JIqPHIfXaaNyk0pFICQuUNQfk5yjOWU3Ae3nRiLMJhYBC1dPm95E12HaZzYDCtUzPngdc
	 zZ/uoWrdXeq2b54SL+netHOiDW0Ea0uhlH2VpI4K5D+wd4puZnDJaLL864qZLJ2wCLYIZ
	 iHjFmzwVR/W6YWQOBKVKFf+g5Ybfg7nGDIFBEJgH9QtSnFmgmOoPV2N0B9z+2PTKcG2JZ
	 Y4/JpqNYFtVRjDjiaa3PutFPAxc0A8Hj8tr/1OdyDATYFWqGraP93gya6r47QZdjFjg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198176;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=HDhBzinWWamnegvT9ExdyfioDJiSgPrUC+Mo3CWLBjU=;
	b=uknVBNPuaH1lNuJ+qymgbf6j091pOVmLUh1ZUvEgZqfRxXqIpdRQAoR2zULQxxMg2H42
	 OybFmmbrleDq+JDmdpWNvfkyCYj5WN8WlFQ/0qrIfoYSYKyPX9WWym5R3w2nAoAVK50SL
	 qKDSIJAwRHleu7cddSznpeAcotmYuE4WG/RBdSRb6W5hCqI4X1G9ztf+/bJX7ZgfBtxJC
	 r+MqGq54m6C0GZy8xdEmMouO8wWXiwqAIFPJ6+ru5Rqh0Irg5LxvvdlCdmCapxIoxGfZY
	 fCihR4qGFYJxhn2IxOfcOQhwCu5+d4GN9067ZQ9JGw8nSnekBU1KUO0Q/IhAatnkhOA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 84D261F000E6;
	Fri, 20 Nov 2026 18:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198176;
	bh=HDhBzinWWamnegvT9ExdyfioDJiSgPrUC+Mo3CWLBjU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Nss9RHgSjfsbp1BVPgl3vhR9LtXz/hFfjfq/vOL5tg1lfVFTKbR60soP7pTbBNqrg
	 DUwVAv+Z9qd08SjDdXYgxOei603OUwTGz8Tlpsf0dh2pZeDr4J4/RLataHzzz2eWLz
	 wykTLaeaohnyDsuDq8YDCDLCOOqSdHwOrFd5SJO0RvSWMy5xVIFjFYi4tKAIFBb+9y
	 n7LFEP43TaIVZh/Jphqbp+lTZeDPi8mlvTBR+aztsPlig6MX1yfISIUYroB2lVxzLu
	 hB2OezEu1f89y7O9pIIN+rb3E6FR1vGrK5he7R8l20CeejWCCEc2TxA+4VJjjapBCw
	 wmBBED8FILoXA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 433624B8C5;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:53 -0500
Subject: [PATCH 02/60] mm: publish and clear node memory states via helpers
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
Message-Id: <20261120-private_nodes_v6-v1-2-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=3460;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=bHuUN4m1rYdeHd2n9uTV5bvIEOwz0W65sMVI4gQRCFE=;
 b=5PaC3uuW3KE0lNJmW+SARs1O0zlNg2YD6FwQIBFs9Daq6H1QsV7mc6KO2+wYEThTdvpSt7rTR
 V6KaOerJChvCGaLx48xIa9FWmn4rD0/KaqOmHyfps7bojLi6JOB8mrX
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

N_MEMORY is set in free_area_init() and online_pages(), and cleared in
offline_pages().

Centralize those updates in node_set/clear_memory_state(), so states
that subdivide N_MEMORY can be published together with it.

Behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/internal.h       |  3 +++
 mm/memory_hotplug.c |  4 ++--
 mm/mm_init.c        |  8 ++++----
 mm/page_alloc.c     | 10 ++++++++++
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index de4593b3e3b6..c102e0f498bf 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -62,6 +62,9 @@ void lru_add_drain_cpu_zone(struct zone *zone);
 void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
 
+void node_set_memory_state(int nid);
+void node_clear_memory_state(int nid);
+
 /* mm/vmscan.c */
 unsigned long zone_reclaimable_pages(struct zone *zone);
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e5024f934932..e5cb770e4b09 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1197,7 +1197,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
 	if (node_arg.nid >= 0)
-		node_set_state(nid, N_MEMORY);
+		node_set_memory_state(nid);
 	/*
 	 * Check whether we are adding normal memory to the node for the first
 	 * time.
@@ -2165,7 +2165,7 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	 * list. Otherwise this node would still appear in the fallback lists.
 	 */
 	if (node_arg.nid >= 0)
-		node_clear_state(node, N_MEMORY);
+		node_clear_memory_state(node);
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		build_all_zonelists(NULL);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index a9d848c92678..46fe9a274a7a 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1763,11 +1763,13 @@ static void __init free_area_init_node(int nid)
 	lru_gen_init_pgdat(pgdat);
 }
 
-/* Any regular or high memory on that node? */
+/* Publish the memory states of a node that has present pages. */
 static void __init check_for_memory(pg_data_t *pgdat)
 {
 	enum zone_type zone_type;
 
+	node_set_memory_state(pgdat->node_id);
+
 	for (zone_type = 0; zone_type <= ZONE_MOVABLE - 1; zone_type++) {
 		struct zone *zone = &pgdat->node_zones[zone_type];
 		if (populated_zone(zone)) {
@@ -1924,10 +1926,8 @@ static void __init free_area_init(void)
 		 *memory-less node. The pgdat will get fully initialized by
 		 *hotadd_init_pgdat() when memory is hotplugged into this node.
 		 */
-		if (pgdat->node_present_pages) {
-			node_set_state(nid, N_MEMORY);
+		if (pgdat->node_present_pages)
 			check_for_memory(pgdat);
-		}
 	}
 
 	calc_nr_kernel_pages();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index aa1ed599c7c6..88d507f93b1a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -208,6 +208,16 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 };
 EXPORT_SYMBOL(node_states);
 
+void __meminit node_set_memory_state(int nid)
+{
+	node_set_state(nid, N_MEMORY);
+}
+
+void __meminit node_clear_memory_state(int nid)
+{
+	node_clear_state(nid, N_MEMORY);
+}
+
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE

-- 
2.56.1


