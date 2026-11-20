Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198217;
	b=r5ADgAfg0jrJAmavflWlO/bjxwwy/+HzowsBOl1pM8a6o7IzSzwIzcmxXAxuHTHKD3TZ
	 Mx7L5OZEQUU0RsV5puj0Dnp1sl2/7nBY3GonC3WKPo5bQTxboT3adAOJbYSzX+4OcYg3U
	 TJMRvX44LvgOUJRROwB+yA/Y4r2+6pKE76tSb1S+iSK6C/a2bufZVGBVpWzKwuBwLLS8m
	 3oVw2G1jyQi1o+SQAQhMtqYxDl6bdn7Q+ulciQhL1CpTu87uCvWCvExxZosSmoUr/hDqh
	 Cp6Q9R8ATw04PQKNwYIv4H3hxyWnaKvh/9iwzYgT+UWT0yCWHC4nPhDvS2ILNHms9zA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198217;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=5H5FsDeB1gHzRgpDszJ63Z0a+uiOyNfPCLVuov6SBb4=;
	b=WS/onf9hBEBrPcOQrB8i5msqaMZEYJCWenO+H0AdOaIBQCMMbljYMRoTly6wyGO0Vlj1
	 HiMQTiTY8ByEknbYDgho0OrEg8HpaUe/bS1Kz0OLUSn4yU+mj0O2tP/kuzhj6jrqCm3JG
	 OnaoefcWaDD2xlL1qvBffA8Q7Rm4hsolhenvLgJ9oKd+ABM/Cw4Yo9ZIOIX21hgFRhxE8
	 TcmqUvpz1ays5IvOKMSRErLHOXNHjUcLhtP1XrJKAbuaL3CdeNyZAW+6hUfoYv7bN1v3O
	 jOB3UxcoUQuCxdIM+wlt4L+ChTcXIMMECnRXonPdVIRBSZpWDUvN/S52ZNaEfalKNcA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="do/Q+5EW";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C561606C6FC;
	Fri, 20 Nov 2026 18:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=do/Q+5EW
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198216;
	b=GZFeBE+iOJPTfa0eyLXhRtoujN3S3Dve9DZCSCYyQkur/hAjxfqseYNQpRopYoujepUC
	 vrzULKBx5jCgDfjGzc/JY/xtqGHLEwS2U81vMiTcqZ+KbC9VoHhSApPiqrbbfDFQs/0Ah
	 LhunB+Ez3XdE4J05N7MW+mMZnhHx2pZ3LGmIBj0R15NEhtHdz7nZqSMswYtD/Mpvd/k4i
	 hVmfVtK5Yyn1yrj94vT5L3iYL7bZYgGuiiolwG7u5mSfO/envyo7+zCaj5lF3q6o3Lclo
	 X1kJhYCCslzw4XJtcIcbor9ybykf0/bzUgESb93mM96OLPb+UM2DIBRpZeGTu669VZg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198216;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=5H5FsDeB1gHzRgpDszJ63Z0a+uiOyNfPCLVuov6SBb4=;
	b=Uieg79TAdg+DclqNWkP7N4oYvo3PYeVN81MaDKfqnwNQ66dpP4hxj+YcazbTQBy035jS
	 yGu5pXPNS4/465zLn8GGTv8O07w+uxCwaGGUMuL2ZTUgpoAXSrx22/b2N79b8rOwOxnE8
	 Ft6JfmF9lrtH4zum5LCx6dITnz1tmmZThDuD/eR1wATk5+uvcZ6nItVKGo4sEpOhYUdNo
	 UIoTsYMBlJL+vzItrIEH7+rJsTpefku8jyaK2OpSK2BEt4UoCLOkyKfPrrLQCa3E5nsNA
	 Y9+pZv16W+S7I5XGPylVeu7cCzcUhj+nsax/T/+V9sFiT+t6W2casL5uRLObdYPk22g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A71521F008B2;
	Fri, 20 Nov 2026 18:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198216;
	bh=5H5FsDeB1gHzRgpDszJ63Z0a+uiOyNfPCLVuov6SBb4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=do/Q+5EWfGqRujMYikSf0GgSLCaCZWsVMH5WqcdrEa/HD3nkHCtwYI5sXsCJ5/26c
	 sn2/jkbvXd3IEXgCzsA5Xjg91ZRiDx70x6qj9XSsvHdVuz57oqUlID2A9mc64i/hh+
	 Njfawtf8dXexSctqMKe95Ra9gvqYIkTOTA9mkuI8IsZfS2JlDWpc8h1TG3goRvtw98
	 EQAtrD775ocTPKh3fjc2tRWjf17il87lHbVRrQZ7G9nHRQsJUW35WOdInSOvP8qyKV
	 4wXp+QNmIXWpLgNPsQVnL8eVJJ3fQwM+Xz1Mo+81bjKx83nSd49/DNUgiHPfzW4BlW
	 KWQGlkzgksDUQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BFE184B91D;
	Fri, 20 Nov 2026 18:09:19 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:14 -0500
Subject: [PATCH 23/60] mm/damon: restrict DAMON-native folio operations to
 common memory
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
Message-Id: <20261120-private_nodes_v6-v1-23-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=1668;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=V04Qzs1fFpNTUapr14E0HnNb9Xxz8DrH55t1p7KWMZU=;
 b=RMc1L4r0dlZpqP5Q+uot3dU1rWD7OMYOabzEbwk3/bzUXH/pZdb+6OmzM/UnOgzxpD/hhyFTZ
 4DV6BPxrgdECffvg689x8JzsMYq+qTUvinCDA2UxDQTgWjuAldpeOdl
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

DAMON acquires folios to age them, check their accesses, and apply LRU
operations and migration. Treat these as general-purpose MM services
and restrict them to N_MEMORY_COMMON.

Memory outside N_MEMORY_COMMON can still hold ordinary LRU folios, so
it would pass the checks that keep ZONE_DEVICE memory out of these
operations.

Treat these folios like ZONE_DEVICE memory.

DAMON cannot acquire such a folio, so it never ages one and virtual
address monitoring reports it as accessed, and DAMOS cannot isolate
one for migration.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/damon/ops-common.c | 5 +++--
 mm/damon/vaddr.c      | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 15cabc79613b..57201a0c5e3a 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -17,8 +17,9 @@
 
 static bool damon_folio_acceptable(struct folio *folio, bool monitor)
 {
-	return folio_test_lru(folio) ||
-		(monitor && folio_test_hugetlb(folio));
+	return folio_is_common_memory(folio) &&
+		(folio_test_lru(folio) ||
+		 (monitor && folio_test_hugetlb(folio)));
 }
 
 /*
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 1e65e7651cd9..338876559140 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -830,7 +830,7 @@ static void damos_va_migrate_dests_add(struct folio *folio,
 	if (folio_nid(folio) == nid)
 		return;
 
-	if (!folio_isolate_lru(folio))
+	if (!folio_is_common_memory(folio) || !folio_isolate_lru(folio))
 		return;
 	node_stat_add_folio(folio, NR_ISOLATED_ANON +
 			folio_is_file_lru(folio));

-- 
2.56.1


