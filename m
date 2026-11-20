Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198264;
	b=lzmE60AeXNWG8EPD/nrILE8Vu+7tVlRLIk4a7S2QOkgQmYrZAvAR4+f2XzyyopmjE2uo
	 O1DAi6UqsQivqGiW6UxKurIzONEV4hvOfuBg+apcB9xRLOqYuFy5aG/TIWWnWwH6ui6XO
	 dk6V2q6oLPqtG2GuodiWSNjfDjBj2KPIFS5aY6D/PB4S1gG9X1D/zuZGFoj+G6poeakp/
	 KUhgIOG4Ym8nESWR4JP709dXeIzv/hHb7acXdnv6X77j3WIfNimq7HdTm2p70jyQBJNNA
	 da8NTd59kBiDLFMtkn6TyhbQXmwwjzukS9VcwNggcV2VbfU60BUv2bBUZrvA1CrJsSQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198264;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=N4LUHMZ9Zq2StHJtUd5qOtvoSX+upmsion4LtPce8LQ=;
	b=GgUVdODfik0bntDwhWJ+iUos1sfRORJaGvWablOePuq/SAoMv3KOwj1OiMyVO8v7MYrs
	 8ph1ewHcsDY4ZrzePmWlfNe6Ss6axyCZOVVOcps9uMFAwCv9z3K7+go8aYGhfdpLvXQJI
	 rhH8YAEycBRMN3oUWCekSHLeHYA8yk6yMsObAVRDXIRri6np6OHVZ0qHbbiVmiRwdlCbH
	 gpx0PoZM9sx/gmJ1IInrsOSK9JJ4QyJv8c92azvHXIddcLagzv1RR9Z3V6TIokgVvNWSE
	 CYwMulZWXs7QTUKxUjuS2mzN+KDzsJu7tLvxqhEuVi7LnCA2zNmybCamvHbc8OghF0Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NK3q7emV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7846076C67;
	Fri, 20 Nov 2026 18:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NK3q7emV
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198264;
	b=k2/92vX07HrIW+S0URaAFdStkvHnitluAh0ydx/TLxefkGOBTjq5aCgfn9FT6WjZY63l
	 mFPomJWb4/u+ZFe91AXioU8MsWtNz2Ummso/E6EUoTs6K65+dsPM1SeZNxcXDd6iyk0LN
	 qP0RorSy+hLV3/3O73lYhuP3KK6txde6LqXfLa2Afmhw52CXcGEJASStLF7r9eZwMHz4l
	 3UV8gt2hyyXkwICiGiW2h+eRjVmrlsPqm1iy5pQa90Y20U8sjUUtM/kiUuMul+rh9DSjR
	 4zPhGYwLCe7QbYFF82+27PgMARfhxZoo3M6mPnoncEjn1V9t6o+k+tQ03F/t9dcN4fw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198264;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=N4LUHMZ9Zq2StHJtUd5qOtvoSX+upmsion4LtPce8LQ=;
	b=ZWrLhdoRxz6QVPz/RWIxtRUZXa7mjh5uavwQmWDvWdE50jotXGDhbU3p8smdiNVEZXvZ
	 kEtUfdLUWXrEl62OJTA96upXau8wutdwolSMwNqkN4CpKnLtF3v5e9EUd7MsvFa7McXGL
	 r5Cs3HUv9fqYKKLPnjWqXlMkVYHNwHL9zzcBzZn9KFTz1IzGPXM76Tx0YYdGgLsXsTpJg
	 YIQ7ClzkiVJlcO4F41hSCUB5mJxuBrBGL8qdCi11aa/rAW+Sm4iWMy6D7yOVWaRRd8cOQ
	 zqsCz+6L/5xg1mGyTgztKcuJ+uxihAKNNH6bk+2dgKlBCJvLxGE5WF2tXD7IfxXI1vQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 501181F01562;
	Fri, 20 Nov 2026 18:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198264;
	bh=N4LUHMZ9Zq2StHJtUd5qOtvoSX+upmsion4LtPce8LQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=NK3q7emVbUik3L6Koi3qFVUpX2MwbLejtymVXVSP+6DGks5CPyStrENGI09OwxWZq
	 zSNqW+cxqVfd4P/0ZaVYTOoRDtB/o4OkCuo2oG0JNcNfbopq7W+SDV76pZCm+ByX2H
	 mpcYK1hDU4vQdgBpEMXZCNobPf78Tg4HTmYWJCSf7y9/Ulk1hXwZ/Q1uunpg3uWdQN
	 go6IAT5N662I+k4F4ZhnXj7kIDRTOErJ6dvYzInI1mf/2XMq94C7Iu+JmGOLmJoH/h
	 ekLz8mX5549K5raMvsP8yo6/Egd6d49U2BHkydpE6CX6OBVcVnxFkUhFz3cki/lu1C
	 +crcMyjPzrnvQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 00C844B965;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:32 -0500
Subject: [PATCH 41/60] mm/page_alloc: relax a private request whose node
 becomes ineligible
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
Message-Id: <20261120-private_nodes_v6-v1-41-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=6951;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=C2lGBLJod3NcaBo85CjVEXWAAO0FPHUICJ5RG9BwKOc=;
 b=JDY7uV4eikBnxv6llFVY6VolS/1VlCkSAEYghL17DozTh0aYg9lRJWAk67Fn72xJYpFmyychC
 sazxiFhhQ+HCfqTJqkOEcFduj64EA2V+c1bfaDbrQNVpad7gQAyoF6H
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

A private request allocates only from its node's private zonelist. If
the cpuset revokes the node, or memory hotplug removes it, the request
has nowhere left to allocate, and a faulting task retries forever.

An ordinary bind policy does not hit this. A cpuset change rebinds it,
and check_retry_cpuset() drops a nodemask that no longer intersects the
cpuset. A private binding is never rebound, and dropping its nodemask
does not help, since the private zonelist still holds only its node.

Add relax_private_alloc() as the last of the slowpath retry checks.
When no node in a private request's zonelist is in its nodemask and
allowed by the cpuset, it drops ALLOC_ZONELIST_PRIVATE and the nodemask
and switches to the common zonelist of the preferred node, which
alloc_context now records. It runs after check_retry_cpuset() and
check_retry_zonelist(), so a concurrent update retries with the original
constraints instead.

A node counts in any zone type, so a GFP zone restriction or an
exhausted node never relaxes a request. A __GFP_THISNODE private request
is never relaxed. check_retry_cpuset() leaves a private request's
nodemask alone.

The alloc_context comment now lists nodemask and alloc_flags among the
fields the slowpath may change.

Without private nodes, the slowpath retry checks are unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 mm/page_alloc.h |  7 ++++---
 2 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a219057931c3..63cc8729c41a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4078,6 +4078,35 @@ __alloc_pages_cpuset_fallback(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
+/* A request on the private zonelist. */
+static bool alloc_is_private(const struct alloc_context *ac)
+{
+	return ac->alloc_flags & ALLOC_ZONELIST_PRIVATE;
+}
+
+/*
+ * Whether a private request can still allocate: some node in its zonelist is
+ * in its nodemask and allowed by the cpuset. Any zone type counts, so neither a
+ * GFP zone restriction nor an exhausted node makes the request unsatisfiable.
+ */
+static bool alloc_private_reachable(gfp_t gfp, const struct alloc_context *ac)
+{
+	struct zoneref *z;
+	struct zone *zone;
+
+	/* A strict local private request keeps its allocation domain. */
+	if (gfp & __GFP_THISNODE)
+		return true;
+
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, MAX_NR_ZONES - 1,
+					ac->nodemask) {
+		if (!cpusets_enabled() ||
+		    node_isset(zone_to_nid(zone), cpuset_current_mems_allowed))
+			return true;
+	}
+	return false;
+}
+
 static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	const struct alloc_context *ac, unsigned long *did_some_progress)
@@ -4753,8 +4782,10 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 	 * from MPOL_BIND mempolicy (whose documented semantics is to be ignored
 	 * when it does not intersect with the cpuset restrictions) or the
 	 * caller can deal with a violated nodemask.
+	 *
+	 * relax_private_alloc() handles a private request instead.
 	 */
-	if (cpusets_enabled() && ac->nodemask &&
+	if (cpusets_enabled() && ac->nodemask && !alloc_is_private(ac) &&
 			!cpuset_nodemask_valid_mems_allowed(ac->nodemask)) {
 		ac->nodemask = NULL;
 		return true;
@@ -4773,6 +4804,23 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 	return false;
 }
 
+/*
+ * Relax a private request that can no longer allocate, because the cpuset
+ * revoked its node or memory hotplug removed it. Drop the nodemask and allocate
+ * from the common zonelist of the preferred node. Called after
+ * check_retry_cpuset() and check_retry_zonelist() found no concurrent update.
+ */
+static bool relax_private_alloc(gfp_t gfp, struct alloc_context *ac)
+{
+	if (!alloc_is_private(ac) || alloc_private_reachable(gfp, ac))
+		return false;
+
+	ac->nodemask = NULL;
+	ac->alloc_flags &= ~ALLOC_ZONELIST_PRIVATE;
+	ac->zonelist = node_zonelist(ac->preferred_nid, gfp);
+	return true;
+}
+
 static void check_alloc_stall_warn(gfp_t gfp_mask, const nodemask_t *nodemask,
 				unsigned int order, unsigned long alloc_start_time)
 {
@@ -5060,7 +5108,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * unless it can execute just once.
 	 */
 	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
-	    check_retry_zonelist(zonelist_iter_cookie))
+	    check_retry_zonelist(zonelist_iter_cookie) ||
+	    relax_private_alloc(gfp_mask, ac))
 		goto restart;
 
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
@@ -5095,7 +5144,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * a unnecessary OOM kill.
 	 */
 	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
-	    check_retry_zonelist(zonelist_iter_cookie))
+	    check_retry_zonelist(zonelist_iter_cookie) ||
+	    relax_private_alloc(gfp_mask, ac))
 		goto restart;
 
 	/* Reclaim has failed us, start killing things */
@@ -5121,7 +5171,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * a unnecessary OOM kill.
 	 */
 	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
-	    check_retry_zonelist(zonelist_iter_cookie))
+	    check_retry_zonelist(zonelist_iter_cookie) ||
+	    relax_private_alloc(gfp_mask, ac))
 		goto restart;
 
 	/*
@@ -5172,6 +5223,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		unsigned int *alloc_flags)
 {
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
+	ac->preferred_nid = preferred_nid;
 	ac->zonelist = select_zonelist(preferred_nid, gfp_mask, *alloc_flags);
 	ac->nodemask = nodemask;
 	ac->migratetype = gfp_migratetype(gfp_mask);
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index c0a0e6abe4cd..3dd73ce641b5 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -73,11 +73,11 @@
  * between functions involved in allocations, including the alloc_pages*
  * family of functions.
  *
- * nodemask, migratetype and highest_zoneidx are initialized only once in
+ * migratetype, preferred_nid and highest_zoneidx are initialized only once in
  * __alloc_pages() and then never change.
  *
- * zonelist, preferred_zone and highest_zoneidx are set first in
- * __alloc_pages() for the fast path, and might be later changed
+ * zonelist, nodemask, preferred_zone, highest_zoneidx and alloc_flags are set
+ * first in __alloc_pages() for the fast path, and might be later changed
  * in __alloc_pages_slowpath(). All other functions pass the whole structure
  * by a const pointer.
  */
@@ -85,6 +85,7 @@ struct alloc_context {
 	struct zonelist *zonelist;
 	const nodemask_t *nodemask;
 	struct zoneref *preferred_zoneref;
+	int preferred_nid;
 	int migratetype;
 
 	/*

-- 
2.56.1


