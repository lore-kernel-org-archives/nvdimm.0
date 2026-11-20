Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198284;
	b=O6+koL9FVEe4JiNvjslFejYSXWmfmcBppOvGGEqHZ1LY2A0EAFitFUGzvkEWWG1Dl59I
	 0BRgLRp/u7m77Mgw83VdJVCbJ3IvhBKh7cek5PlYhh34bdVlICT/5dWK6nOjOj8+CHH5p
	 dR08dLML6vApYqfblb51lcVv01OwB5k7kEVH6qkjWb8tOqiFjaOntVOhbRNuIFv6cFsdA
	 upm00CPrVKZdjv1Jyr+C4AGacdSbVDCHd8YfvCIAUOpm33brINrLeq3XLyqzU3Tdzcl0i
	 DJTMNbDfITTZMqvNM2ZFx6WpUP9nkd0fo4TG5vuT2ibAjpYpeWw3lLusYGo9qh1KQYA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198284;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NfK181OzgqPxTC5JM5ioAgY5RzIkO1nLp/unSAccMvc=;
	b=FrXRflwvGFBed7dhvL8IEYkbOFfAGduaMXvaU2ZwpKmscQ8g0ZRat8wV8Gk4K1rYvyoA
	 U7UZeTLheiQKeSyIYBhVw7/EyKSD4vxnlIC7f94fM+nkRZlOnN8L4eI809wLf0cZH2Emn
	 dAGnhJRs1tXlhOrXDY+nWcSwmS15W2VmqpktSjlJGaaL9tEFF3AupwgGp3C3eWza2p7G6
	 Gm2TklADY7F9ep6bLh+lm7yU7/k6TeACoN7gPQKwj9+KrOzv+dwYZ8a7HOrRPehIhymaE
	 VV/6eG49lAQXFp0RUCYmJN1ryD5tqKlwXl6HyKBpimsPjn8M8oCgzTToEKfqbKd2FsA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6gFXHmX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B96E6078DE6;
	Fri, 20 Nov 2026 18:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6gFXHmX
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198284;
	b=i9PeCs0vYRaXk/Ac38vphUXzcBdujt78TTtGUWjpLa5pJqYc9r6Vc32XHPkJ0xSEQnlb
	 4YvmfISYNsKyd7wLDJ+3EugixxfoPqen/g81vxP5/TnYtW9H833zxgJp6yV7liA2hiYB3
	 kkt56nxxtwCObOMqa0BBVEFuSxUeBBql0DpBPkZgeG/qb7mmZqWdJrF4Xv0t2AvCwChtu
	 16tporS9pupzVPbh65pc7deYso9mJ0LWXmTyU5ei9kpa63SudZDgvJzrGdMIUMGTDG8Mz
	 s5cCv6SsxLC3fTbiCxM0S7rQEIc1U6iuQyb4hzuiA9THU1l/Q04vMG14K3VRsw6LGvw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198284;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NfK181OzgqPxTC5JM5ioAgY5RzIkO1nLp/unSAccMvc=;
	b=Qiw4EYXryg+/CmfbOSWIYpl1vZYDcw+/tRx0G8BXUO6Vm45I1s+oMVcS+bjf0TD/lVdc
	 BGxaIMLqorT/QzS7hXCZiCMq+a8OMQxZ954EdvLRVj/TQGkVwyCJGZll9ZchrJiDRVB66
	 ZKrYZIefdjT09MDbNqfG2m0TWkHdMK9w370HNXFLZbRPh07uTKhx1gcMxaTO3Wg1lf43V
	 x4xVaF8uWO+NcFPtChKiHL7TjBqcFcaPdCS+Jq3rzzEM2wO0Lej0ZYNiKSWaPFlgkbNw6
	 FOaeURnhIiP05zdObjQ9aRYlU3xcXOYrJiDRQuJQOjKpkTZnRAu265z7wcFEkHCpbsg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1628A1F000EF;
	Fri, 20 Nov 2026 18:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198284;
	bh=NfK181OzgqPxTC5JM5ioAgY5RzIkO1nLp/unSAccMvc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=B6gFXHmXZ2XEk/oI2d6JnbhOTi2FSVqSKYLaYdzLYLLbAIH6asVCOJxDOLaHwCIep
	 8lS4j0U0fewup/Q7AdTNd5VOz2D025I58vEmgAFJaI/mPTrTLwR8dPqDrZjSeSsIHv
	 At8Su9b7nbC1pQ2oqwQgXw7nEIPezjddw8aR+F0CBjTnMvf0htJxqcFIgZs7M1VKYx
	 zngNr3tGQ+h1iBoZ8snYLCDvyw0FnBou6FCa46TJ7+UFeYfQmB1NA/8z/p/r5lQaLd
	 gFUbtTIv772r5FtYz3/Z77VWBMz99OT1ozWVlI3d9x3K5Nw04I8IJrpdixds9lRBUC
	 zc3TTpLn7qVJA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 98BB24B998;
	Fri, 20 Nov 2026 18:09:23 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:45 -0500
Subject: [PATCH 54/60] mm/migrate: route explicit NUMA migration to private
 nodes
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
Message-Id: <20261120-private_nodes_v6-v1-54-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198154; l=4872;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=LdBmn7sW2WZfOe8jPXvczezaQql167iyE39pQOO8QgY=;
 b=sTml8+HqIUvMTacUxZiUfSUZimAOAY9MiHZ9lsqd24xS7lWLntm08ZOzq3xfS7DqVpEkNzuQu
 aE+pXSWkZHlDCm/IGuzhatOFii5433SjI7oHHeyyJr2YhuHNaROFriH
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

move_pages(2) and migrate_pages(2) allocate the destination folio by
node id with __GFP_THISNODE. A private node is not on its own
__GFP_THISNODE (ZONELIST_NOFALLBACK) zonelist, so the allocation never
lands on it.

When the destination is a private node in N_MEMORY_MEMPOLICY, select the
node's private zonelist and a single-node mask in the syscall path, and
pass them to alloc_migration_target() via migration_target_control.

move_pages(2) now accepts such a destination rather than only common
memory, and still refuses other private nodes with -ENODEV, so
do_move_pages_to_node() only needs to check N_MEMORY_PRIVATE.
migrate_pages(2) keeps such nodes in its destination mask, and drops
other private nodes as it drops nodes outside the caller's cpuset.

The other users of alloc_migration_target() are unchanged.

HugeTLB folios still cannot move to a private node, since private nodes
hold no HugeTLB pages.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/internal.h  |  1 +
 mm/mempolicy.c | 19 +++++++++++++++----
 mm/migrate.c   | 13 ++++++++++++-
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index c83c100a5253..646efc2eacd1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1309,6 +1309,7 @@ struct migration_target_control {
 	int nid;		/* preferred node id */
 	nodemask_t *nmask;
 	gfp_t gfp_mask;
+	unsigned int alloc_flags;	/* ALLOC_ZONELIST_PRIVATE or 0 */
 	enum migrate_reason reason;
 };
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cb5419cb7ee8..a7cbb05ac86c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1340,7 +1340,7 @@ static bool migrate_folio_add(struct folio *folio, struct list_head *foliolist,
 static long migrate_to_node(struct mm_struct *mm, int source, int dest,
 			    int flags)
 {
-	nodemask_t nmask;
+	nodemask_t nmask, dest_mask;
 	struct vm_area_struct *vma;
 	LIST_HEAD(pagelist);
 	long nr_failed;
@@ -1351,6 +1351,14 @@ static long migrate_to_node(struct mm_struct *mm, int source, int dest,
 		.reason = MR_SYSCALL,
 	};
 
+	/* Private placement is reachable only through the private zonelist. */
+	if (node_state(dest, N_MEMORY_MEMPOLICY) &&
+	    node_state(dest, N_MEMORY_PRIVATE)) {
+		init_nodemask_of_node(&dest_mask, dest);
+		mtc.nmask = &dest_mask;
+		mtc.alloc_flags = ALLOC_ZONELIST_PRIVATE;
+	}
+
 	nodes_clear(nmask);
 	node_set(source, nmask);
 
@@ -1951,7 +1959,7 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	struct mm_struct *mm = NULL;
 	struct task_struct *task;
 	nodemask_t task_nodes;
-	int err;
+	int err, nid;
 	nodemask_t *old;
 	nodemask_t *new;
 	NODEMASK_SCRATCH(scratch);
@@ -2001,8 +2009,11 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	}
 
 	task_nodes = cpuset_mems_allowed(current);
-	/* Private memory is not a migration destination. */
-	nodes_andnot(task_nodes, task_nodes, node_states[N_MEMORY_PRIVATE]);
+	/* Private nodes are destinations only if they permit userspace placement. */
+	for_each_node_state(nid, N_MEMORY_PRIVATE) {
+		if (!node_state(nid, N_MEMORY_MEMPOLICY))
+			node_clear(nid, task_nodes);
+	}
 	if (!nodes_and(*new, *new, task_nodes))
 		goto out_put;
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 6791834f14fe..eda961d43df0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2250,6 +2250,9 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
+	if (mtc->alloc_flags)
+		return __folio_alloc_flags(gfp_mask, order, nid, mtc->nmask,
+					   mtc->alloc_flags);
 	return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
 }
 
@@ -2267,6 +2270,7 @@ static int store_status(int __user *status, int start, int value, int nr)
 
 static int do_move_pages_to_node(struct list_head *pagelist, int node)
 {
+	nodemask_t nmask;
 	int err;
 	struct migration_target_control mtc = {
 		.nid = node,
@@ -2274,6 +2278,13 @@ static int do_move_pages_to_node(struct list_head *pagelist, int node)
 		.reason = MR_SYSCALL,
 	};
 
+	/* A private node is reachable only through its private zonelist. */
+	if (node_state(node, N_MEMORY_PRIVATE)) {
+		init_nodemask_of_node(&nmask, node);
+		mtc.nmask = &nmask;
+		mtc.alloc_flags = ALLOC_ZONELIST_PRIVATE;
+	}
+
 	err = migrate_pages(pagelist, alloc_migration_target, NULL,
 		(unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NULL);
 	if (err)
@@ -2411,7 +2422,7 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 		err = -ENODEV;
 		if (node < 0 || node >= MAX_NUMNODES)
 			goto out_flush;
-		if (!node_state(node, N_MEMORY_COMMON))
+		if (!node_state(node, N_MEMORY_MEMPOLICY))
 			goto out_flush;
 
 		err = -EACCES;

-- 
2.56.1


