Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198259;
	b=hz2KN1e1HU7XtFuliHWXOy5T9aFJ6Oaa3N6mrdsom+1oTz0TguzVbl/k8dV7bi3wHW2X
	 sgauYyQbwNq3Q+NA7ZjjSk+rwoUagZVdBKS5IshaXARmsrFDca0EvbmtsqrFM+UO7iWOe
	 r5RgF52eL54RfDN39iZrenWwuugqi1YXQbcrvn2BxvDfTS7hQuhjcVjcKXZUQe1gXSZ0K
	 LhYYqrSuNBJcsKkPo/1goW0g8gXt0GBCB2mF0YYaYO0DIc5NCtdTZ4xFlKAcyv8xQmn+Q
	 Z3PYY3KrQGXM+5mGcnkijEMpyhl7v9/ERiHwhGSTctFjid8Nbqr+Dnw47HFY7vdcYcQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198259;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=2pyhlHcAWcyHdhLLEt+5fKnMWs23Mnhr4T3LRfpUnXY=;
	b=k/q8xCMKZDOer+rwngjq2MHMaA5ybu+H+9fHuwuJIpUrkLZl6dGPRqutCPvXOLqnjt/l
	 kKLB0xAulagV1lItdDkh73CflAAvZzTTAarxn0SmLqkuALhO338tqTxzzJlyFZDHFrvGW
	 GsezJqgrEo3weJwp4xQxsHTOr5Dc/X6gX1gHQ1Zn/k87XQnlSx7VufWY7vdvM5lWLbhry
	 4wdiLO+6DZj0UV0qEKAwL08OTYtuBlK2FvM90j6l+JowcxQOHmntLty0F3itac96Xwm7p
	 bi7qXvGGjob0DQTRoFsu4jHoXWJbAAKPnnrj7pUD6ncE/FxCFaL46Pv2yvW116/6mdA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DKRikqjp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E570607634A;
	Fri, 20 Nov 2026 18:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DKRikqjp
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198258;
	b=pI6Ji73H2iArxOOKCvr/PNcCu57Pbb6hw6yHBJ0wBRdwuAyaHijWJu2vyHH7RGRbjIoO
	 wBOZfEeEB7OInc3WhdM2GH+qcrD/2dQghgUpE7/4U0SZJQoODUWcKD7IT3QpMvcd5BsIH
	 vtyt2XMfpqOdOcPX0X77tvLp98BBSg9/w5Jx+DNHUvUYpjg7QV/WHnS7/0r3ExQA5hxvZ
	 vG5YWVZ4Z/c5OMysQaPFUTvcT28QT0LoKy6mMoGD68iZVGyY6K9EO7uIKCulbWFDmpkvO
	 jI8b6H98TuXzh1npkN9FAUNKlG5goeBIUt/qeJIon9UA5WMMRw7V4010WRMT3qZqpzQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198258;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=2pyhlHcAWcyHdhLLEt+5fKnMWs23Mnhr4T3LRfpUnXY=;
	b=cTov5n1eweWw5sXaxWSrp33Q0OSOOjgVcoGYHf3FDPrUfX/LX7zWrWBwiLAIpFeBNH/X
	 WZKnmg9Gq47UnP4qu7HRzUfzioCbMu9PF/9WeOq29s9ys/U248MpKoAjNh8hTX7bPgbnq
	 wMqdkLwGtr21kB7Ol8ud9xqRRgOzAQRtot+ViY0XMtUd9Oy0zCvWsrLn4lLCbkeUT9oUg
	 SacyYGhrDz6ZTs8vbrYnGu2JM34E0fI4HDvUXl5nN2AHjWI4alaPaj4IBoFebk9RGl1bx
	 0VW7rKhvZWwceU2wni57yz4uY9291LZbYDDD+HnlPueZDHByzhueR7bby1Sj/mNmr+Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1E7061F01825;
	Fri, 20 Nov 2026 18:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198258;
	bh=2pyhlHcAWcyHdhLLEt+5fKnMWs23Mnhr4T3LRfpUnXY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=DKRikqjp8Dqe+AUzB6iz3/MV/MiW+KKIAz5bv4FQtT7WqfihsF0tnqmeGmwQLdRUs
	 kR87nlYvVlf+AuK3K3GeFRttOnkhTprDrZhFrGZPfx3aje8x04pJ1jMvjmdLokXM1a
	 ebrb8Z0A+FcLOKwkdNTAAUXFxU3m+DqAWoDjrH+/mxhhDxAxAGILiFko7N0K5sTAu4
	 Atn4xU2sm9CGHqIj6+g4UailPdrJksTN1m3sZwf4v/YEtr6cqongGk83+UMZ/HDLGO
	 VO8xkQ5ZCQxpznVF6Ex2AmdSe+nVtivrg1abp69SHBcCOdwF7vqnSOXGKAfrvVZiTp
	 GyIhksGplaTLg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 967594B979;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:37 -0500
Subject: [PATCH 46/60] mm: add N_MEMORY_RECLAIM node state
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
Message-Id: <20261120-private_nodes_v6-v1-46-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=4233;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=2Cu3isS44jPims+WvemrkSJ075FaNv3x27ntceES1eU=;
 b=rCEvV4Vxm5Bay12IKWxYIL/HB0z/8bt8JJw96EnOqDCYmA4Tr8glUa/20lHdJNAS53zrMeueF
 ad3F6711g+iAlRzLli3ssnKMTwH2aKtumPIHc/RU0a8x0zX/R0r+MAC
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Add N_MEMORY_RECLAIM as an internal state for the nodes page reclaim
may operate on, and NODE_MEMORY_FEAT_RECLAIM for memory providers to
select it.

Reclaim frees order-0 pages and leaves high-order requests to
compaction, so a private node that permits reclaim must permit
compaction too.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 Documentation/mm/physical_memory.rst |  4 ++++
 include/linux/nodemask.h             | 11 +++++++++--
 mm/page_alloc.c                      |  4 ++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index 5d0a69f6c23c..1bafe8c085a3 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -187,6 +187,9 @@ The following states are internal and not exported through sysfs:
 ``N_MEMORY_COMPACTION``
   The kernel compacts the node on its own initiative (kcompactd, proactive
   and explicit compaction).
+``N_MEMORY_RECLAIM``
+  The kernel reclaims the node on its own initiative (kswapd, memcg and
+  explicit reclaim).
 
 For each node that has a property described above, the bit corresponding to the
 node ID in the ``node_states[<property>]`` bitmask is set.
@@ -201,6 +204,7 @@ For example, for node 2 with normal memory and CPUs, bit 2 will be set in ::
   node_states[N_MEMORY_COMMON]
   node_states[N_CPU]
   node_states[N_MEMORY_COMPACTION]
+  node_states[N_MEMORY_RECLAIM]
 
 For various operations possible with nodemasks please refer to
 ``include/linux/nodemask.h``.
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 2757acffff2b..be5edbee2b22 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -413,6 +413,7 @@ enum node_states {
 	N_GENERIC_INITIATOR,	/* The node has one or more Generic Initiators */
 	/* Internal states, not exported through sysfs */
 	N_MEMORY_COMPACTION,	/* mm compaction may operate on the node */
+	N_MEMORY_RECLAIM,	/* mm reclaim may operate on the node */
 	NR_NODE_STATES
 };
 
@@ -550,12 +551,15 @@ static __always_inline int node_random(const nodemask_t *maskp)
  */
 #define NODE_MEMORY_FEAT_COMMON		BIT(0) /* add to fallback zonelist */
 #define NODE_MEMORY_FEAT_COMPACTION	BIT(1) /* mm compaction */
+#define NODE_MEMORY_FEAT_RECLAIM	BIT(2) /* mm reclaim */
 #define NODE_MEMORY_FEAT_ALL		(NODE_MEMORY_FEAT_COMMON | \
-					 NODE_MEMORY_FEAT_COMPACTION)
+					 NODE_MEMORY_FEAT_COMPACTION | \
+					 NODE_MEMORY_FEAT_RECLAIM)
 
 /*
  * Common memory carries every feature. Private memory needs NUMA: node 0
- * holds all memory without it.
+ * holds all memory without it. Reclaim leaves high-order requests to
+ * compaction, so it requires compaction.
  */
 static inline bool node_memory_features_valid(unsigned long features)
 {
@@ -563,6 +567,9 @@ static inline bool node_memory_features_valid(unsigned long features)
 		return false;
 	if (features & NODE_MEMORY_FEAT_COMMON)
 		return features == NODE_MEMORY_FEAT_ALL;
+	if ((features & NODE_MEMORY_FEAT_RECLAIM) &&
+	    !(features & NODE_MEMORY_FEAT_COMPACTION))
+		return false;
 	return IS_ENABLED(CONFIG_NUMA);
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 335ce73e645e..864da908a59b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -205,6 +205,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 	[N_MEMORY] = { { [0] = 1UL } },
 	[N_MEMORY_COMMON] = { { [0] = 1UL } },
 	[N_MEMORY_COMPACTION] = { { [0] = 1UL } },
+	[N_MEMORY_RECLAIM] = { { [0] = 1UL } },
 	[N_CPU] = { { [0] = 1UL } },
 #endif	/* NUMA */
 };
@@ -221,10 +222,13 @@ void __meminit node_set_memory_state(int nid, unsigned long features)
 		node_set_state(nid, N_MEMORY_PRIVATE);
 	if (features & NODE_MEMORY_FEAT_COMPACTION)
 		node_set_state(nid, N_MEMORY_COMPACTION);
+	if (features & NODE_MEMORY_FEAT_RECLAIM)
+		node_set_state(nid, N_MEMORY_RECLAIM);
 }
 
 void __meminit node_clear_memory_state(int nid)
 {
+	node_clear_state(nid, N_MEMORY_RECLAIM);
 	node_clear_state(nid, N_MEMORY_COMPACTION);
 	node_clear_state(nid, N_MEMORY_PRIVATE);
 	node_clear_state(nid, N_MEMORY_COMMON);

-- 
2.56.1


