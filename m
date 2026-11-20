Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198206;
	b=F1qZZpRpJb1nNxpaH/GUpBrvItDfH3YmNqgRZmqsLWVP1iYikjKYKL9Gim+DxPF8TCyn
	 n7m5BN9nJbHdPrSFmMgJo4/FG0Y6KEVqy5eYB0wprJHxqCZRLpB9tQm04M/u5qPYRW0vF
	 tfyfSoGKNrwTXj6Rg0Li99FerolsgfvzlTqgzpHw+HV1jGdt3HXpNFaeQh8LbYvO61pE+
	 L57OEmB+qNYN1PLHxvnF/EySHAwDxfGTaBTHUTcj6N/JIZBg6ykjynep9wObQeYhLmArg
	 4L5Tf2k3UEtGuDt45zuS3tceXiRCj6UpIfsTrBn1dlt02vZ+WExHrh/0R1XTqFcLtOQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198206;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=cabvuNy33zQdENtGlK+47ghfpMiZg8BMWdRKAMzcY20=;
	b=3cw6m6cTZvU8cyOTHLAhMcx5oiPYByqjEFvcY5uDCriMToOVEh2dNdaC4m9rAEJsUe4Z
	 R/QdpHfAnUm3YCD9zRA6+Q1olg1mwBFV9dXyOgEZldMxzKRnZsydbMscCj0bQRc5zKjDU
	 lcXKEbS1AkfJplBpFD7o4mScoTOuV4iKlx5uSQlYUU/K8eDNcYFlcCSw8/D+ykqKi9xW2
	 lSRGf9yqasj9dzUgH2NxSg7X83ks1SqJ9IlVCOIb7CjtpdlWAleFsxlIb3mnendaALxAr
	 RfmyIxvR8QDUh2BxX1UTCCk6AdBk+ci6Q0sXWw+VV8j9ML1I8eALP/sw8k5+zusifsA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VMd2YHbQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5781C606B215;
	Fri, 20 Nov 2026 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VMd2YHbQ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198206;
	b=bAp+V2pwwo8SnkySWvuUEc9rJAGG+hsIql8r3D3liBzRR5bsDqrt3ttRTxz/UG1vLC7a
	 97N6OJBIDK4dId40nuSSpYnWrrbAidwMRoVUs00kEpbeMtgmz4zH5WHSCmEsiefStGIoN
	 k3nCljVD9xWE2QAnhgz6DAfz6Jee2w2Q28c/B2QUs8uUBQIGB0sbjMJNgx4tpfOGZFc5I
	 twOuQrWKc2GaWx6a5sbOtSNbiI7Mif3IluRdljh0DawNZEJRlu2n7smO51Kr+dqFl76lY
	 jzThOKrrN3N8+NrDlzrRtzMxtF4JR/mLZzE5E/r+lUvZUKSHNPddUM2tJMWeX0Z4EzA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198206;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=cabvuNy33zQdENtGlK+47ghfpMiZg8BMWdRKAMzcY20=;
	b=nwinzJEdR94I82pdXcusbTPMZendGHBea/zAm2Jsryb3FMS8oHX+fuKaABgIPLbw82Af
	 AH8Ip+OZVSpxFri99OSvE2grUp4yP726I5Qc8MMxbSmNOh45B25v4ZckPUWyorfZjw42n
	 /uQQy8L3axk7e60NBpWqc78JzfP9jYvY+g+dx1/NgvVewzeCBVxT8RZvTPbjNGgcvFdT4
	 PK6r3I1sZt+Fx9Yr3KhhgZv/Xm1PtsaEHfySAHZgmht+9IDew1/TA87Bf+SZQNqqq/DXX
	 bDLRHKowFUDur33iQoCfYs5iDnY3rbUpdFmkkjt9FDEp+hp23zDcPfdfYWY+CflGVDA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8D0751F00ADF;
	Fri, 20 Nov 2026 18:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198206;
	bh=cabvuNy33zQdENtGlK+47ghfpMiZg8BMWdRKAMzcY20=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=VMd2YHbQxHa4uHPD4Wj1+zjnYRlG0p4QelfMkKNuTROtg8CQG38dio6caSrg8tROJ
	 NSroWdKB3fSlPhjVw9AXvGcP6cAiiTn0eRNQSE7rPMO7+D2TQfGxRPdERthXBas4Yr
	 9i/O+tAn4NJFA/+sKR8eickRzjEKuw1W9GhylQSJsbtfvNgdjMaNX3g2G43QU2nqDV
	 d1Ckb0cWqNcnz53DTesQg5VEBX365iOybZy32GAhS6OORQjvKTvvPiG/IwtHVvqbYi
	 9Cc0bB12F4tnKC66Pjudh+xjpqVZO3RAe8NDvwmGJB7Y6HCrqRf9dsGc3W0l2Vs/DG
	 +DHGUFFjQGzSg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 86BA04B8F5;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:04 -0500
Subject: [PATCH 13/60] mm/compaction: restrict compaction to common memory
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
Message-Id: <20261120-private_nodes_v6-v1-13-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=2217;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=BmbnHul2BY8/db5+GiTddW3CKoXNqAVos1d4H4BuQY8=;
 b=UBJbyCgvQkAHnb0K2qbW7oGYgoTN2r8jD/DTCgat/O2ohtOkVQif8zR9qpcfBTBGByrEoQt25
 bXDi/nE8V3+AUav43Xm1EHfXoH0es9WCRtJpbKRVj72i9Kflq8+RAVP
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Compaction serves the ordinary allocation domain.

Restrict it to N_MEMORY_COMMON:
  - start kcompactd only on common nodes, at boot and hotplug.
  - compact only common nodes for /proc/sys/vm/compact_memory,
    and trigger proactive compaction only on common nodes.

compact_memory and the proactiveness trigger walked every online node
before. Memoryless nodes have nothing to compact and no kcompactd, so
leaving them out changes nothing.

Direct compaction serves an allocation from its own zonelist, so it is
left alone.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/compaction.c     | 6 +++---
 mm/memory_hotplug.c | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 426563acf7ac..879f372a891e 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2973,7 +2973,7 @@ static int compact_nodes(void)
 	/* Flush pending updates to the LRU lists */
 	lru_add_drain_all();
 
-	for_each_online_node(nid) {
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		ret = compact_node(NODE_DATA(nid), false);
 		if (ret)
 			return ret;
@@ -2992,7 +2992,7 @@ static int compaction_proactiveness_sysctl_handler(const struct ctl_table *table
 		return rc;
 
 	if (write && sysctl_compaction_proactiveness) {
-		for_each_online_node(nid) {
+		for_each_node_state(nid, N_MEMORY_COMMON) {
 			pg_data_t *pgdat = NODE_DATA(nid);
 
 			if (pgdat->proactive_compact_trigger)
@@ -3366,7 +3366,7 @@ static int __init kcompactd_init(void)
 {
 	int nid;
 
-	for_each_node_state(nid, N_MEMORY)
+	for_each_node_state(nid, N_MEMORY_COMMON)
 		kcompactd_run(nid);
 	register_sysctl_init("vm", vm_compaction);
 	return 0;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a599fcad65d3..6b6873cfbc5a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1224,7 +1224,8 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 
 	if (node_state(nid, N_MEMORY_COMMON))
 		kswapd_run(nid);
-	kcompactd_run(nid);
+	if (node_state(nid, N_MEMORY_COMMON))
+		kcompactd_run(nid);
 
 	if (node_arg.nid >= 0)
 		/* First memory added successfully. Notify consumers. */

-- 
2.56.1


