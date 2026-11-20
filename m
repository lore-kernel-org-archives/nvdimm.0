Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198232;
	b=uJeqj+zxwb4kMG4o+TuJOVNKd58OtOcuyWRRudXhRwGga6+W5q91qAUKQ8I0L/lBkC7d
	 tz6CmxVA/P7X451RmKV9x+UkJ4zzRy3HdTEhdJMWGifzMcRor5jMQEa8TSYOwpzgktsyz
	 JR2QQ6atgRt40JQCEKtFrtKOu7gi/yFZ+tCGj7+pfFucozmKC55zq2JwXCs9GsOWcYeSr
	 OcTJxszXhYS6Tlcfbe4Cz99S8wx66oYbbh2G5ydGtmLRw1HHwphnMUzSWM7T3IGWR3ZwA
	 mY2RWy+dALMzY6uPmvmYjo657krttr/0M1rvYLNu8D2P8c5W2iESu09PvL7XXzJI0Yw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198232;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DdtYjjt4icTMCNkBVK8ZqJ6Cita/durqIaktzLd3ASQ=;
	b=027DnVB9jXZKnAioRJwBJ9U0zy9rLczyuKb+hIGz47kbm91c4m56l/z+0vDx+a5yVf9t
	 RaQRtZGzmUOyHwHdBX2iGwuF7gE72hUX9KnPQsR+0IEDXP4p/UMfryg5ofWBSvkRrZra6
	 P17NqrJaVXB397DL6DtCPtchBVUME0mgzmRXxJrMBVqd77A9JIcRriqERbojxPKtO/SHI
	 dH0n+DHrVT2gIo8d1G/lyYUyNFb+qL7ItxGSjyO8k/N4mRMAUovxW8OcHaODkqwUpHCXE
	 1bsusdJtS8JPBos71h9jrWVtYEwmf9TdMRnu4JRZdzOGXutwloraqQT++sJRPnK3JFQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fVa07GAX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE5960A6F7A;
	Fri, 20 Nov 2026 18:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fVa07GAX
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198231;
	b=Alxg5aHQ463Ab7E73YMGr06nNxftuD9R2pHpJUhNH67h/hNSaIg65hyfqH0LgZjv9y5t
	 x0z9Jena1gwNOF1TVYx3j1X2J9IyVd+xvEjj3bw5JiRqWOmxcvoBl2pb5L1W4vxfwNCP+
	 P21G6ChB7nbQdSTIRynx0Hdji/XEFRhd71+6MGvZkSW1rtAL9crku7a35sup/12X+LV47
	 I9uouImPS4YwXvlRqsyq54/wATQTcarjUojPWPceMY3HX+wkghYuryf5yJfLRIR+MmNF4
	 Job4ooKB+COmsqVfbbvN4h0YGHwOMTObZ33CG5MnyIxV6YMZGqg1lsOzgyEWQ4N/sAQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198231;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DdtYjjt4icTMCNkBVK8ZqJ6Cita/durqIaktzLd3ASQ=;
	b=YW379Ly2JAL/gcWovZ5hPFwZ5Bs1cuBHZc5ffkX2n4eMmjxVtBKEfasQ/U4uYUHjuptk
	 SWODoKukUnCP92AX6JLsoOlQBn7qwFhN+0m4fAl/yUgNLu8SgzzHGB+SKuJlZu8ZmIX14
	 YQxUaczroxI3Jvwq9pR2BAFvM02PmuHCsEBq7EWnX33rH3RLV2KHsbcHzwx11TAPO0hP3
	 P6NPI+RmQgRheGYkNKNn1UApTmvde93RDGNb3VRFoImQoxyOzL0VO4iMlgT5P0HxGchZ5
	 6eaw8QIqyoteogRW+pwguBZ83uYZauuKZWeBmASuXoJ4RWZdG+pCgk74+2u4A00m5Hw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 41FAF1F0089F;
	Fri, 20 Nov 2026 18:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198231;
	bh=DdtYjjt4icTMCNkBVK8ZqJ6Cita/durqIaktzLd3ASQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fVa07GAXI/2Rt3bNMQKTQCk0iW4W7wjQiC7O9dTHK6g1Av2PUmuloNiSYk8HhWnaZ
	 g9S/rVVGs2UV+r92CspEFiOKu7nxhlprY/EtBndpTDXEC41s2afGNh6lqrwqEQpCFE
	 nw239g0Zj4tp43qJtkSx721usQM7qW2yruVe09fZvKQVfw1VFfhsgsBYziGq9U6HHh
	 mHYeBFSDmKD/4Gi2pK0EJjSoWdrZhjR0gnP4MNADt3EU8mvMJbfcz+mqUEBmTaE7n/
	 oQxqw13TbMDT+VNNvRyoefAuSQEEkXVzs79d1neEdpanwIg+wyGF22T6xu7EDF6TzQ
	 l7mGz8CPyGxyA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9B3534B939;
	Fri, 20 Nov 2026 18:09:20 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:21 -0500
Subject: [PATCH 30/60] mm/memory_hotplug: keep private memory out of the
 auto-movable ratio
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
Message-Id: <20261120-private_nodes_v6-v1-30-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1663;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=HgTV8d94LjdwsJMGwb3+Vry/TTvf1tnHS+uF7N7JLj4=;
 b=1P55MY17I+a8cu0KecQdsP4lOTbFUbQWC6JVR7uUJH6xpwOzawPJ9vMaF4+CKy+NuwVaaINT8
 wCDorNsASZVCR3jg5Bhndx5xpS/opyzqs664oVh52KWLV73mn24pwg2
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

The auto-movable online policy keeps ZONE_MOVABLE within
auto_movable_ratio of the early kernel memory, since kernel memory
holds the metadata movable memory needs. It counts all populated zones.

Private memory in ZONE_NORMAL is counted as kernel memory, but no
kernel allocation can use it. The policy can then online more
ZONE_MOVABLE than kernel memory can support.

Leave zones and dynamic memory groups on private nodes out of the
statistics the ratio is computed from, as ZONE_DEVICE memory already is.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory_hotplug.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b4d94021d46e..d7ce60c6815f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -782,6 +782,10 @@ struct auto_movable_stats {
 static void auto_movable_stats_account_zone(struct auto_movable_stats *stats,
 					    struct zone *zone)
 {
+	/* Private memory is outside the movable:kernel balance. */
+	if (node_state(zone_to_nid(zone), N_MEMORY_PRIVATE))
+		return;
+
 	if (zone_idx(zone) == ZONE_MOVABLE) {
 		stats->movable_pages += zone->present_pages;
 	} else {
@@ -808,6 +812,10 @@ static int auto_movable_stats_account_group(struct memory_group *group,
 	struct auto_movable_group_stats *stats = arg;
 	long pages;
 
+	/* private memory is outside the movable:kernel balance. */
+	if (node_state(group->nid, N_MEMORY_PRIVATE))
+		return 0;
+
 	/*
 	 * We don't support modifying the config while the auto-movable online
 	 * policy is already enabled. Just avoid the division by zero below.

-- 
2.56.1


