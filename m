Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198207;
	b=bNINwCLL4vJuk6uUe60vHp7qFhAUCh0S3qQwyKeo+gffuTqGJijZrd3WSwtEzGVW1cFc
	 bOCwOMuiCuHTWoK/sigKgTZius3eRNAYZb/0gLD+5Y50v2OHtrUIoAdvEnNbxPzzkPc8i
	 cnaXgSPPIGzkU+6c6W5BX8Cy6uEVERcE0uhcTBz4UXHo9gJn4r1mB5gBUMyrW9fJeSCjY
	 3SmHr/tTL+MqFyPJi4wEHigTRc/RuelpkIeX8fiA8zdg8E5+IGOyvTjjdPLgYQdd+7m0/
	 qsL9SWxO/UeTxuc8PZwiAjQ4zfddbeJp+BwZDPcRbG98JpPk/1oB5GZiesEhkk35f8A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198207;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=CKVNPICIuJeHboZhs5//ylGkrISPeWolkQPQ1hYsQP0=;
	b=BvyPaHYsNVF4wTzPQFaNU+OC94l0XoCXhH+a+C4qvYqys0XNQD4FcvplXL0FwMwqtB+q
	 GntcfiVvLbpqbkzTzWLcKY1OJLjpO4FmvwVjD+Ib9AeDG4HhzjidIlyqYxB8d2Jr1GGaW
	 MjawybaL3jpZeS5a8BQxz0OVw32r8a1sn6KGB0k67QFh45GVOBCshlPlEwrsW6zgQLd5Z
	 LCsfgOHTUG9sZ3d1EVxOS0sUcHrIeRhSS6IpRkpSohTZrr1NxvpB+FqLTGFiXonDFE8To
	 NKnHBiEXVz1sfs9xbNwllS2MsM/dsgbGyB5c9UDjA9MFbKwvnPvMBPwMisCuXqQonig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="cR/1sFjW";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598ED606B23A;
	Fri, 20 Nov 2026 18:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cR/1sFjW
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198206;
	b=PXFjBgJbPQ59KvbrHakjrZO/KVVv4kvBPmHZSDpFnCjCW1HwoG0w1QXY/LL+Zvk8ixgN
	 MU5qiMFHa6aAp7LIxUq9XmJCPkGHy37bfNA0vubcWnicho4mEYBUcticVGqTDX2p/J+l+
	 c9gikjU56IwXhFbdFo/JOV8xgtnkm7pV2n/0ZdXS21qaIhOliSFD9GjHqnZm6Dt8f0E48
	 BQyGsm1y2lqx7lVpFEnkbHnGx4Y0iukEplTKuzAmpHDueOLaroVO4Qrt7UjtYj7ng34UH
	 ma9TacAbdPENZbbd4B0vYHZ/ZPVLmQ1gxn/rV8kFKzenfvC48dd1+grOuHcuUaTMEfg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198206;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=CKVNPICIuJeHboZhs5//ylGkrISPeWolkQPQ1hYsQP0=;
	b=E43F0BiI/E+cHNjtkb5MjPjCvJMVS+bgjhtxTEXzqUNjbwA3NdTaPniYRb77ZbOp+eo4
	 BJdpBkzdzgkM7nlWwSYGPBGJOtztQrO4jee7Il8aKpn00KBlATuYsiV3nOJZOkxNJdrqZ
	 Zez0SEc7ofK0ueh9fGYf0y1evssy8ww+arvbOyp78Rt657XhzM/n01tIrv2y8aMRltXLi
	 IQevjGOg4HwQu7XGjvVoSnFIhejFF7CiWpj5H44SO7NBo+rGxg/Ji2pKxQKi7PBTNi9nT
	 3nWNVOnnLA2Hgf86PbSPNCAN+cB1T+yGW+/Boat7eS6cxZBJzfOyAfHKMpzuWwHp0OQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 88B6C1F00AD4;
	Fri, 20 Nov 2026 18:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198206;
	bh=CKVNPICIuJeHboZhs5//ylGkrISPeWolkQPQ1hYsQP0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=cR/1sFjW36AnBN3zX3d6d2DvEj0Mp9J99K3GB8Ws6owxduh/lPO45ilo3iPAa+CGh
	 fL0oVlroNF4EYIn5fx8Le2hz66d77tydI/BWzKIFEowZXDpV0HmlZYgM6ZlBjNicRE
	 KJnyRHWJlyNjgqhRmXm43TQCf31nNm4JgHzko46cAeZ0ZmBDwPWALZmaTBhVjrZCEb
	 1g/y4l46t7Ncl6T1c9nILoN09/Y4t4SiA7A7V6dzRgTFrwgoBLMMFvrP1Cp0/LB7pb
	 /aushC40WlmU5T+0JFJ2Lw/eJj5275amr6FrN1BqODixH1xTigpWI8pKU6Clbsr4Vu
	 oa8pC8sH8F5Sw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6A6794B8F1;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:03 -0500
Subject: [PATCH 12/60] mm/vmscan: restrict reclaim to common memory
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
Message-Id: <20261120-private_nodes_v6-v1-12-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=2825;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=FtLUhP0wFF5GfqO7k4obSm/pRyOe/gBL2Z3quyWtR6I=;
 b=zwlm1U/LcEdr9egylwJhEu7nOZaUODHcksIlsiJlCATY4Fbl78/BXLfyNjSKWv3UDT+qsBfSZ
 piPbYWcP1rrCCLgsKDDw4afKb7rTwG3CyQeRdlVm7Foh4LeK1/sZgiM
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Reclaim serves the ordinary allocation domain.

Restrict it to N_MEMORY_COMMON:
  - start kswapd only on common nodes, at boot or hotplug.
  - walk common nodes when MGLRU's debugfs interface iterates or
    validates nodes, using first_node_state() and next_node_state() in
    place of first_memory_node and next_memory_node.

Direct reclaim serves an allocation from its own zonelist, so it is left
alone.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory_hotplug.c |  3 ++-
 mm/vmscan.c         | 12 ++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1d3d1792074c..a599fcad65d3 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1222,7 +1222,8 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
 
-	kswapd_run(nid);
+	if (node_state(nid, N_MEMORY_COMMON))
+		kswapd_run(nid);
 	kcompactd_run(nid);
 
 	if (node_arg.nid >= 0)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bc7579d47f9b..5b53e0391d80 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5729,7 +5729,7 @@ static void *lru_gen_seq_start(struct seq_file *m, loff_t *pos)
 	do {
 		int nid;
 
-		for_each_node_state(nid, N_MEMORY) {
+		for_each_node_state(nid, N_MEMORY_COMMON) {
 			if (!nr_to_skip--)
 				return mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		}
@@ -5754,13 +5754,13 @@ static void *lru_gen_seq_next(struct seq_file *m, void *v, loff_t *pos)
 
 	++*pos;
 
-	nid = next_memory_node(nid);
+	nid = next_node_state(nid, N_MEMORY_COMMON);
 	if (nid == MAX_NUMNODES) {
 		memcg = mem_cgroup_iter(NULL, memcg, NULL);
 		if (!memcg)
 			return NULL;
 
-		nid = first_memory_node;
+		nid = first_node_state(N_MEMORY_COMMON);
 	}
 
 	return mem_cgroup_lruvec(memcg, NODE_DATA(nid));
@@ -5832,7 +5832,7 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
-	if (nid == first_memory_node) {
+	if (nid == first_node_state(N_MEMORY_COMMON)) {
 		const char *path = memcg ? m->private : "";
 
 #ifdef CONFIG_MEMCG
@@ -5935,7 +5935,7 @@ static int run_cmd(char cmd, u64 memcg_id, int nid, unsigned long seq,
 	int err = -EINVAL;
 	struct mem_cgroup *memcg = NULL;
 
-	if (nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY))
+	if (nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY_COMMON))
 		return -EINVAL;
 
 	if (!mem_cgroup_disabled()) {
@@ -7907,7 +7907,7 @@ static int __init kswapd_init(void)
 {
 	int nid;
 
-	for_each_node_state(nid, N_MEMORY)
+	for_each_node_state(nid, N_MEMORY_COMMON)
  		kswapd_run(nid);
 	register_sysctl_init("vm", vmscan_sysctl_table);
 	return 0;

-- 
2.56.1


