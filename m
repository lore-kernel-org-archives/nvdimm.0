Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198207;
	b=1GHEJ4hQqKJdKOHMRcDJpGA/gVRMcSQhRHYpyFawb8XXGr49ho9llw7immgWMQvkOwSJ
	 8eBuEaJ9HUYlBO2niFA5UrTk6A6gGceWpbFlhv+gBXxYhrczDgvUTPn7YExp3wcZoJi5r
	 CDii91sbQ1JF5iFYU6irwVfQQnZSAZ7JLEktoxV3gmiOqQGej9cS9U4ZfUz3VdEu9v4tq
	 3++Tm6OipEoBpDSv1ETByb4sSRfwuyrg1s98C4AjVf1Xhc4oEMqQ2zthmiIASOVRTt+6j
	 tR/8RL1fG4582sfGJ1QkAa2wt/9lO2+U8H6lZS/q+W6Z7b1bc+Sqr5GI998vH+my1+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198207;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=kS8ULtElOh9VKJauHuptEbqEopupzknKORQFIhtAO3g=;
	b=kQbd4ARPjRe1t49+jizBvT0KeQjT/k4jkNWNhzkGSlEWMpBK/nUCCbVlOl3WbX9miOtG
	 2RidvX8ck+/OlL7/Es3QbHuzpX+2x/IdE9UGnU8rVSSKmwnwULPrm5wyQikh+2t59e6KS
	 A5f8uOJKL3Mfv+KNjF7rs9QPKPeOwhtik6pw9liDb1cfBfBqBeSHp6juXv91gheJI/RQQ
	 /R+xy6YGQrixfO4iA05LXK0m1sbSmsHv9i1nlLVz+pkRvOSPsWamCJ81s9LiET8994J4y
	 jP0dARAGJn3uzDy2XH7TivEebfGysJ2/Wd4tJU7S6xD3z13sHLp4crI6FrqEAm1x0wA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nmpGkOHM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598B5606B239;
	Fri, 20 Nov 2026 18:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nmpGkOHM
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198207;
	b=rhbLIWnoeah4+Pg0Bh25heTkgOMOwy8+kdjSX6dpFpVb8OixjXxxR95U9dR2wI5IxlXn
	 hwkW8d931TpcbBzuE5fKsCen0ke0i3Kdw3wTsGw9NtK6hI7CshwJ57NK72FM7Gp14Bc+l
	 gcP905DGfxPrbr+g1w5N75T8+WC8NZcZbl6S1+MGIwwB1a+ZX7uSjWnGd+eJm/yr75+ab
	 0Tu0fZBTo2802TK/HDcSDS+SNNDIuqtM4upfp/0L56qA200Hhc5z4CATuVfOl9Yqo23Gl
	 MvPR44qcZxwszArywPCArxBPPcAR1H4P+FlNEgWFIFYYD7i3LQ9I8UnT0baRglfIj7Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198207;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=kS8ULtElOh9VKJauHuptEbqEopupzknKORQFIhtAO3g=;
	b=gafFd1hFivTR1EnDOfgQ5BjbkW8P6m1oL7wpJXNKKjcfqGppKImYACtnCEPlmynLPYvz
	 oQ9IMkSPpjsQfEb+Mcm/cRoEtIPn09CvJ7F6Xwo0L6MQ1WEbiFB0vsRmIluvr/EINDgX7
	 xgsKzjZ6CZOTtixOBRY3bj5VSD3Aph9iRCEWW19H8cyxfXWuofTZAuf8TExSJh5AgeF/7
	 ASbM3fHNlNhcIQSZLO1w6AbOUN5di9HdwAvKiMygca1CpxfECPKpubRiRjr9/pASY8+Qx
	 sqaWAmKWr85nhRl1F3qIiF1uxrCrO61gDbMB8RTBY8S5AnDxHdOeswDbufVP/FZzQbw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E2E2A1F01561;
	Fri, 20 Nov 2026 18:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198207;
	bh=kS8ULtElOh9VKJauHuptEbqEopupzknKORQFIhtAO3g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=nmpGkOHMHeAt0ferEtV3OfGvY9ht35A2lBRivtOZfW6DchavZvY1MEc9wOHH4KgJh
	 3FNJkN1c/Kiu16ckro4mMzkhdziUVKNKQX6Gmk0JEBqGpokOV2haZJrspUFat7mBeB
	 HH5+vYdvYwCekMxWdEP2xGa4Ng/zgoq6AdBDI+NWB88V1pPgbTesGccZ13Z2UzTg9R
	 qE0ThmvM13ojxHh2voH566stwnq+0S2AW8EaUBvEYdbXv8PBcZQTSmWEYcmLS2UjaC
	 yTXorXrS7TgUBgui17Zzn1rViYo1JKs5dEEPl7G4gBQV++ys+GLPbF9ujfOhdUylo3
	 EokS1f9cvxgCQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A2E054B8F9;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:05 -0500
Subject: [PATCH 14/60] mm: base hash distribution on common memory nodes
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
Message-Id: <20261120-private_nodes_v6-v1-14-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=752;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=kzu60kHcR4jg5+83pzySdZg/16HqDs5ZJU+b16doVWE=;
 b=748lnM0UAIWYIikKEzoqzk1NLfEf9UkP/kYV8mG5fcRoZKQ2waLuxmbZewbEadsHLukTRzV3V
 r9lLSXCux+nBTwzYAwYPzqHH+pyb+k2EBGnYxU14R5HCUN2/FGpt/7x
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

hashdist is useful when large kernel hash tables can be allocated across
multiple NUMA nodes. The tables come from ordinary allocations, which
only N_MEMORY_COMMON nodes serve.

Count N_MEMORY_COMMON nodes when applying the single-node optimization.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mm_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 46fe9a274a7a..f21b3dbcc92a 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -685,7 +685,7 @@ __setup("hashdist=", set_hashdist);
 
 static inline void fixup_hashdist(void)
 {
-	if (num_node_state(N_MEMORY) == 1)
+	if (num_node_state(N_MEMORY_COMMON) == 1)
 		hashdist = false;
 }
 #else

-- 
2.56.1


