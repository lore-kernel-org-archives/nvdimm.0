Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198185;
	b=Q8vycmeUjyTJH2gbIhK5n0xTkZv+FyX+XpsRQ+ROBgpDlqUtrxgwfuCsaG41ca1IEhLP
	 eEunytUyboUmTYSar9RwSP7sQPw82Fz4Jk76Mw2mA4nQfzaRNr/dlJ+eUCMFzSpN9Pk1d
	 htDwKyyJq3Ny71t1Kvuito3MkDYv+HqyhwbkdkVHMvN1Mebies2Wuu/YfqneXppBQy6yp
	 B4Z8/+nEaGEaBsCdu4tyqYDMZF7io8544CD5G9lte3UL+r4LyRByYingw7JD/Nk8dFdIf
	 jPG2PqmeWrm2Ltjso6iHDkSf4szEhIN+hokEv9mw8wUQdnXKWERxtHvdRaNzdreYOug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198185;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=zjE3RPeHs8dyfLzrDcCaKSay9Q5D+YG1hmYrydQv15g=;
	b=A+QW7YcEokBXHXsYSybN3Ap9XHuoegMEN1NX1SBqj3/0jilWh5yA0Qu2Nd3fLisdd3yi
	 G/IVmcCEKbwCkpbd8ffNLP+SigBJa7k3RMiWgE2F9TTM2qEdrI91nXFOtGSr0SXvA3opD
	 dde6NbcuxH71fC6pwpP8weH/IZe4gQDLy8MTRlIL2IJjzKNY23IEgQfLLDQhdIgVPX1dz
	 AMF4ap9fZ6iS4j0MtZ14MMtr/y+saIg4xkZJhUM3TxF1Eoqy2WSyV8b+g28ufoP+dHDzB
	 9II10CvGyiyzeQakwgLTgWQiG+MX6VmtGDqEiLdqWKpJ9Rgv+HtIX2zzd85VgEhsbBA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GRAIa4Ol;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E17460A2638;
	Fri, 20 Nov 2026 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GRAIa4Ol
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198184;
	b=jK3LkGVFA2RmXXX0J/DPifTlZhIqARmBhfMC+h07BjCf07TQcbjPVlOxD5nB93EDJk5d
	 0NN4doSNK4f+1NT6GsjqtzZAZ19Xsxzb0jWLj3YJqBs9MBTJRthT9TGWBViD7MGcHCE+4
	 ootinPbrRWPwtchOCrMPbSt/4dXjGDdzjMdp9rW4lXJ1+/0H9vGP/hJ92zCzfSokOb0mh
	 AicFU4ggqR9Pal2JBpbn6aoTBAEXBR9f2u0244hT7x/RuPUSmx2RXvp2o/fmc1BXur2Sn
	 CM95Puu5eKdq5G62ce/Ie76OuPWBRnKVo2DY1E77bbCMBaMCgPWX808Yuvllai5UA0Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198184;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=zjE3RPeHs8dyfLzrDcCaKSay9Q5D+YG1hmYrydQv15g=;
	b=DP4HuYekXMeNzKye58fgRH/Y17e6RGfy3/pxwvUN9Muu+rx4H5LXgtiSMSk7h6f2QedX
	 f/aovpuQWIqmemdEkam3HNuHYOZUTYRCxpu8bKABlg5ZwNfKCkQPoQNQDDa3NFgfSd9/T
	 /Adly8bk6rj5QATRDfmFwGLNQj5JeXU4rRenEwc86zKVV/t7zc42STGCMuInzjRIxC24D
	 K7TBa7TnJSWaq8IcTqppogqMjy5/tSDpv8eB6F3XiP9cSdZSnY+nednbUOJpOeDmkjV/3
	 CJSmRbfXSXKuHGS1FY3Gbg0NPp0l4uwu1dkG0HS/boQCzrNiST9s1cfS41G1paMnrPA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BEE921F000C0;
	Fri, 20 Nov 2026 18:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198184;
	bh=zjE3RPeHs8dyfLzrDcCaKSay9Q5D+YG1hmYrydQv15g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=GRAIa4OlNMIpN5B9CNuVwnnyb2CQm0GTAHyT1tzl02V9LmO783SQnP8+eOkI0CIII
	 NJueXpJ20aevpi6BskxLQsy+UdlRE/zlgsCKXwe0ya8/CljT9OuyNMZknUV5xPUcgl
	 rDfyYKdA+0Rv4fNq+eWVFpMuGI8txU3H+SvcWraG0wtgX6QwCxqEl0DPhSXGFmZznj
	 PScUYXLeaSvn/ES010Oez/bE6sJIaqY4ARBBUP4p7TcQ1vZDu4dhSrHckipK0goZlz
	 i+DkKbii224Tanh4igYLNBI3fw2BgCE6CSHpVMrtC5MPAFoXcwhkJN+U7uB+V8FbQ+
	 Y6T5GKBpI8Hug==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B46A04B8D9;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:57 -0500
Subject: [PATCH 06/60] mm/memory_hotplug: migrate offlined pages to common
 memory
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
Message-Id: <20261120-private_nodes_v6-v1-6-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=2066;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=y+LG+FO6STODgbMk2P9Neg6dWT2V0RZ4aCGZDdcA1iI=;
 b=rF4QRfdnyeirN8cavwU1rBXmaiGs7/MuKraaTxIZF6cFZOTMnmNLGqUa7ewdFKbgEAKZSsWhS
 Nj0dPmjAPUKA3opSJvkIGXOZYeu3uu/WCfCgJJA/K1WyJMnnUOPr45Y
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

do_migrate_range() / alloc_migration_target() is only capable of
allocating memory on N_MEMORY_COMMON nodes. The destination nodemask
presently starts with N_MEMORY and removes the source-node.

In the current code, if the destination mask becomes empty, the source
node is restored to allow migration during partial offlining.

Consider this configuration:
  Node0 = N_MEMORY_COMMON
  Node1 = N_MEMORY, not N_MEMORY_COMMON

Node 1 keeps the destination mask non-empty, despite being unreachable.
This leaves migration with no usable destination because the source
node is not an eligible allocation target.

Restrict the hot-unplug migration target-list to N_MEMORY_COMMON so it
reflects the nodes the allocator can reach.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory_hotplug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e5cb770e4b09..1d3d1792074c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1926,7 +1926,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		folio_put(folio);
 	}
 	if (!list_empty(&source)) {
-		nodemask_t nmask = node_states[N_MEMORY];
+		nodemask_t nmask = node_states[N_MEMORY_COMMON];
 		struct migration_target_control mtc = {
 			.nmask = &nmask,
 			.gfp_mask = GFP_KERNEL | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
@@ -1941,9 +1941,9 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		mtc.nid = folio_nid(list_first_entry(&source, struct folio, lru));
 
 		/*
-		 * try to allocate from a different node but reuse this node
-		 * if there are no other online nodes to be used (e.g. we are
-		 * offlining a part of the only existing node)
+		 * try to allocate from a different common node but reuse this
+		 * node if there are no other common nodes to be used (e.g. we
+		 * are offlining a part of the only common node)
 		 */
 		node_clear(mtc.nid, nmask);
 		if (nodes_empty(nmask))

-- 
2.56.1


