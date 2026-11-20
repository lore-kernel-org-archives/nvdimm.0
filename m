Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198182;
	b=PTaMBg7lk2bsbn3JoCyeYNjCF0f4CrojTarxQsn6p4kVH32OSI+2VARZEeveBmK78S16
	 nyeLObpORwyCxvjPACMUMmHcOPN2idvTJesmcOwDpay+KincODsZceCRLTiSPvqs67YXM
	 eHpf9QiJyK/oDkoGnli+oF0Lb5yFZ8zy/Cefu0SB10lNbVkc0X64kzIJ8yYyVVnCaIdIz
	 tINJQ34whTXN75ExWMEBiad9acrVykbKD9jrpCTfWHCD+kvE5iimc88jgrB+FKfBNvfQw
	 fiyH4Y8pmMdhwtW6FnLR1rjabZAKCgYaP4rdQCD1XkR6F+mOsv975ozBVVJ7b+UUIVQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198182;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=mk7QPfVqMmmgAD3R4zQbgdyE1K197Nq20BW8Qt7Ivvg=;
	b=Y6bD7JRLNJA+Kudf8kU554FX5Uxkol4WJT/M3tf+3gu2m0MuStP53cDFHTV0pnFXV0O1
	 eZn3c1K0N8m3o1FFmOlAcEw4GZ4sl4X+Xyv+j+yFGgUDmwYE3R63dDFLQcJRoe5Lt6aL2
	 9/5iU/2OkoMWW1Y0TvV8FGdNGvejglwVPJyFKS23S3iVAxid0cyIJYN0dH7qRdXZUBwDC
	 dpTpLFo/vpkwiAP/Lk+VAuLqLOrwIxiK05gRSe+fLCPZ5zPpxGozvpmA8gootByKdHWnX
	 tTzlpeyxLeIgN4KaDbw0CUVAzRvOWUBCBg5z7w6Lue/dhZj+AJIzOJNFcsGEnvFIiwQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FMVPJv12;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F14360A2608;
	Fri, 20 Nov 2026 18:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FMVPJv12
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198181;
	b=uUUJqCjtmXAp9/IFF88psZnsmflq+3NZNlpKW81bPKiuDLypAnQIT7cXWObAIMcThpwS
	 awQtPxPNLZf0sdWh0WlFd0I5QAyHtGZ/cEwf6D+8+w56Txd0g4fGO3esnayk/mk6/cUpw
	 VIjqZZstBL9MNskv3/4csQDGTWorXQ/j6l6P+9G9BAjONHKBXrcI/eqY/Nn7V2V2I/Xjo
	 8ihg6OxhM8Q15420tnGj8MuH9ONW+D4+PfvqhknBpCnBogAv03pXR5R6IRFwtYJA27JJT
	 pisvCzAdoulpiIRw/ra3KAnWT/qgLQ6Vq06rEHXQrztVySAdoyF46mHmV69HKaEBIrQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198181;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=mk7QPfVqMmmgAD3R4zQbgdyE1K197Nq20BW8Qt7Ivvg=;
	b=TChntSfwppAA1Q4H7SXWVFPrxAzrdSUHWNh+TwiB2moPuBvFT455SnGFeAm1CnYy0anj
	 /hqjVUCytqUQyF4LdIe1sBGoFzZb3I8ZCSjDp3zenTlOZq5+m+lzkqPkRdelppDQfsgsm
	 2En0tgLC6lPlLvLZyuAAZFysRCAe6rIzf76uFeoxivzjbl1JmJinYl9Yl281G5Od0wSSR
	 QNdTQy5wORjsiYdotCn0wecbwxiwwG4CQDOx+vyYBwKIRL0Du5E0t4zGROMrVUZHzC+gw
	 rAoT1w4ws1Yih9d6wngrUKJtq7xxwm9NyersePxE2HPwzrMuQ9PTOzREf3LrwiN27yg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7CD0C1F00ADF;
	Fri, 20 Nov 2026 18:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198181;
	bh=mk7QPfVqMmmgAD3R4zQbgdyE1K197Nq20BW8Qt7Ivvg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=FMVPJv12LpvxORmAU9nCISXamyLF/S2XclVJx6minKID8wd/z0OSgxBvlHRJDc8Qs
	 85cTeDAOIlmbhggv/KKxmU/sVKiac31P+U0IK2Af7TYLWuywLCNTuIefp4WRIOvuy5
	 a8mM6Gj+hK10gniN2wb/M0lHwxXd5MOYa3KCI1PgsnVocD5EQfdKM+C5cfM9hjT25P
	 aNcPqmCcpyAR+z0O//HUIGX/VJRvDU82eFyRkc6Sy8tih0nkn5Pn5I9J3Ddy3GiliA
	 pkHsrFQNLo0uubTot5Byu4YUnYgP8Td1skHfawqpz3LpVKAOHCXcPYioGtOHwDFQUF
	 whQmEV17bqeQQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9A5DF4B8D5;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:56 -0500
Subject: [PATCH 05/60] mm/mempolicy: keep interleave and tmpfs mount
 policies on common memory
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
Message-Id: <20261120-private_nodes_v6-v1-5-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=4176;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=9bmcZ7R/82zTxF1Qtk/yGZ6mpKBsveqW+bL1srzM0FI=;
 b=rzt6Q/QHsAoNZY/tZYjwurSoHivRuidMYKiNejInoFdn5cQoQErCHIyU+a6IoDegA4QyBS/88
 XEWmHXW061WASp1v7pEQJTOmJKF7N9mx07G1qUrotuxRGHzVHQJXqtS
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Use N_MEMORY_COMMON for boot mempolicy calculations and their per-node
sysfs entries (weighted interleave weights).

Restrict the node set mpol_set_nodemask() applies to set_mempolicy()
and mbind() masks to N_MEMORY_COMMON nodes.

A tmpfs mpol= nodelist must name only N_MEMORY_COMMON nodes, and an
interleave policy without a nodelist defaults to them.

Later when an N_MEMORY node is omitted from the N_MEMORY_COMMON set,
they will be stripped from mempolicy nodemasks as they're not eligible
(similar to memoryless nodes today).

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6f800fb961ae..806577e1d48b 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -213,10 +213,10 @@ static void reduce_interleave_weights(unsigned int *bw, u8 *new_iw)
 	int nid;
 
 	/*
-	 * N_MEMORY can change while wi_state_lock is held. Remember the
-	 * nodes contributing to sum_bw so all passes use the same set.
+	 * N_MEMORY_COMMON can change while wi_state_lock is held. Remember
+	 * the nodes contributing to sum_bw so all passes use the same set.
 	 */
-	for_each_node_state(nid, N_MEMORY) {
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		node_set(nid, nodes);
 		sum_bw += bw[nid];
 	}
@@ -439,9 +439,9 @@ static int mpol_set_nodemask(struct mempolicy *pol,
 	if (!pol || pol->mode == MPOL_LOCAL)
 		return 0;
 
-	/* Check N_MEMORY */
+	/* Check N_MEMORY_COMMON */
 	nodes_and(nsc->mask1,
-		  cpuset_current_mems_allowed, node_states[N_MEMORY]);
+		  cpuset_current_mems_allowed, node_states[N_MEMORY_COMMON]);
 
 	VM_BUG_ON(!nodes);
 
@@ -2104,7 +2104,7 @@ bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
 	 * if policy->nodes has movable memory only,
 	 * we apply policy when gfp_zone(gfp) = ZONE_MOVABLE only.
 	 *
-	 * policy->nodes is intersect with node_states[N_MEMORY].
+	 * policy->nodes is intersect with node_states[N_MEMORY_COMMON].
 	 * so if the following test fails, it implies
 	 * policy->nodes has movable memory only.
 	 */
@@ -3398,11 +3398,11 @@ void __init numa_policy_init(void)
 
 	/*
 	 * Set interleaving policy for system init. Interleaving is only
-	 * enabled across suitably sized nodes (default is >= 16MB), or
-	 * fall back to the largest node if they're all smaller.
+	 * enabled across suitably sized common memory nodes (default is
+	 * >= 16MB), or fall back to the largest node if they're all smaller.
 	 */
 	nodes_clear(interleave_nodes);
-	for_each_node_state(nid, N_MEMORY) {
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		unsigned long total_pages = node_present_pages(nid);
 
 		/* Preserve the largest node */
@@ -3474,7 +3474,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol)
 		*nodelist++ = '\0';
 		if (nodelist_parse(nodelist, nodes))
 			goto out;
-		if (!nodes_subset(nodes, node_states[N_MEMORY]))
+		if (!nodes_subset(nodes, node_states[N_MEMORY_COMMON]))
 			goto out;
 	} else
 		nodes_clear(nodes);
@@ -3506,7 +3506,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol)
 		 * Default to online nodes with memory if no nodelist
 		 */
 		if (!nodelist)
-			nodes = node_states[N_MEMORY];
+			nodes = node_states[N_MEMORY_COMMON];
 		break;
 	case MPOL_LOCAL:
 		/*
@@ -3901,6 +3901,9 @@ static int wi_node_notifier(struct notifier_block *nb,
 
 	switch (action) {
 	case NODE_ADDED_FIRST_MEMORY:
+		/* Weighted interleave spans only common memory. */
+		if (!node_state(nid, N_MEMORY_COMMON))
+			break;
 		err = sysfs_wi_node_add(nid);
 		if (err)
 			pr_err("failed to add sysfs for node%d during hotplug: %d\n",
@@ -3932,10 +3935,7 @@ static int __init add_weighted_interleave_group(struct kobject *mempolicy_kobj)
 	if (err)
 		goto err_put_kobj;
 
-	for_each_online_node(nid) {
-		if (!node_state(nid, N_MEMORY))
-			continue;
-
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		err = sysfs_wi_node_add(nid);
 		if (err) {
 			pr_err("failed to add sysfs for node%d during init: %d\n",

-- 
2.56.1


