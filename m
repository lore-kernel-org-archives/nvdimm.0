Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198223;
	b=EseRMzF8eg3Mqj+/X/rWp1TTFq3OyQRrtjcd3P1+IZJtM5vMutsgQ342RNNy9Wme0EC4
	 uIhOddw1ptUFvCRsDYdE0ijh8+2SYtf1CH/cSlFdBbS+snTWhbvcEo0xcc3pWNRXQUy5D
	 T574jukT3OY5GEJ7XKmtM8XEcrdc5AItKm1/YPAm/Fm11+qlth+OW3f0quW6vZJaKqQ/D
	 uZLD+Pm4fn/rFzr4YTWnOy6Q9CGdrRWUQH5QJEV0z+Ieh1MepvZOTJPX4FLy7Keh23FFL
	 bqvPJzyARTca4cLpuLawkCkknLqljfMsMKnJoCaci1fAHTf9HDRcNsVuEMS/Svz41Zg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198223;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=rPWblFMOlUoCwhrsGsfTvXS//TfIn5L5I+BHDpUhjpg=;
	b=OlFCysqdmEwXC/iaUbQGsC1vj/5zRsMFfX6JIk6JkE4o21jZIrdVy5c3YiVtgC0YmAVI
	 nQuvtwlrbZb3qO8jnzk+wTHYSGLYVAi9+JpZurOLVPPhj8fviKkMG+OwA+zNDa9qPt2zs
	 Ox6lv0pN03IQQDmhV7IdHhyi2+uEt4HJWmUUeqQnHw/NjDqDuWQJSahqtOUAu00BnT1kd
	 A0zwABOFx4Xf2JlN6Xy/+J9yvqasxinX66D6wY9t5AFh6Y1PVtCCl2EMN5fns8QzAz1sa
	 4TDjGgTLwNyBxqeVUYMs28RBrke0hmGdcpy5IndLFsBRr1qCDGoICdgaWHozeTp9mkA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LQdjjNII;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69676606E846;
	Fri, 20 Nov 2026 18:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LQdjjNII
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198223;
	b=hhK5UbecIBKWVk6VyE2wD8ykcbE8T7omMolL33NZdMGoG5Mt3YztX6IgdQRGQ//Tczg7
	 xTV9JxFsPttcjNoj9gc7ylr2GN6q8rx/FruMRkNdjtBdDnA6+22Vns2oq4+sk7tRYq0A0
	 9KvviMWXW5xp6Sp0rVp1WEGD3kygdBTvo82z7UrNSZgEEA2z77F26sE6dp/pmjSr2/Ef6
	 d+uPMpIoTvK5C1JeQbs+osS2xwgyGdCMbwgyXm7sw+K+00ZEDm1FCAHrIbHGjpQ2hf75k
	 JssE3LDpRGp8x7KBm4TIcxR+72HnAvSXFc1WAFfp4n5PgOF7uwX29U5AdeaO1HcYtIQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198223;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=rPWblFMOlUoCwhrsGsfTvXS//TfIn5L5I+BHDpUhjpg=;
	b=zhq89V4A82qXnioVtdJtAw0jVDGcugZEraNkwDEWu+2TLBWgbN5NiYfooG3KiO1Gr/3L
	 C/iw4bKvEDow2sBGqjdVfjLkRAek/jvmF9QQv731LLOPLXs2En39yfl/o5guzzpZiVkv6
	 dwle2FyfmGuwBfZv877SRsjvUiCAvX6Te9AlBG/fQDGoeGZSRhzmjJEYzxF/p+/DVCk9w
	 71caijYq/bPhfOElK0RG7OXbizj5wkaHufmzDSJXyRZhgjjiWgudMc4kjc3uXafkLvf84
	 NVn1jESwY1HpMFxT39OCqbIx5lXi9z1MnqP7QBEXoJj5WGOtXg6VfguZ287qsyHJE2A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 653D41F01579;
	Fri, 20 Nov 2026 18:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198223;
	bh=rPWblFMOlUoCwhrsGsfTvXS//TfIn5L5I+BHDpUhjpg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=LQdjjNIIQ+cqSWVjzAoh82aGsUJ6wJT1gMZzwQrTJBmzAOeZALwo2ANkRLEkkxU8D
	 6L+xsJUpYym1+7aTBnRXnHznOaBp9qxH4zYVrRpE0y5OcXt+bag79shPytFQK8x58y
	 4g8u2sdY0Qpx3QwPJtYWINXEbyH6HtyUUEBPjspzqBFn+de/wMvy7g4OtvpwpHg+vW
	 8RXrmqNdca+9+6Y1zyHMhwho9ErrdNN+zu6O+TIdt54RdnPASH9BpgzadJ1XiaSEXt
	 nX0rpjN7rSsms/ubHva29oadw4fOSLTdUdd2Dfqzbf7y6yD4A9vjc5wkDb4qTnfOMs
	 tQQJ3sX/jAVJQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 659764B911;
	Fri, 20 Nov 2026 18:09:19 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:11 -0500
Subject: [PATCH 20/60] mm/ksm: restrict merging to common memory
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
Message-Id: <20261120-private_nodes_v6-v1-20-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=1590;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=1HskuxEf+1Zhw3YBFVrlQVKDFRcqnw9jX4hWONKblFA=;
 b=KX1ctcadjm/RHab3rq+KPJ8U93Fk/aZfsz1s26MHn6QysyfvDO0bjL2QQSMq3Q+U4X6ZzNMXd
 mEI5+NqYbr6CfPqa/Ro1yHh+HAbQ9NETS1e/yCFhGps0epW+mqx8JOq
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

KSM is an opportunistic MM service and should leave memory outside
the ordinary memory pool alone - as it already does for ZONE_DEVICE
folios where its scan picks up candidate pages.

Use folio_is_common_memory() at those same sites, which still rejects
ZONE_DEVICE folios.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/ksm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 623a2cdb3924..25b2c2f94486 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -831,7 +831,7 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 
 	folio = folio_walk_start(&fw, vma, addr, 0);
 	if (folio) {
-		if (!folio_is_zone_device(folio) &&
+		if (folio_is_common_memory(folio) &&
 		    folio_test_anon(folio)) {
 			folio_get(folio);
 			page = fw.page;
@@ -2571,7 +2571,8 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 				goto not_found_unlock;
 			folio = page_folio(page);
 
-			if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+			if (!folio_is_common_memory(folio) ||
+			    !folio_test_anon(folio))
 				goto not_found_unlock;
 
 			page += ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
@@ -2595,7 +2596,8 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 			continue;
 		folio = page_folio(page);
 
-		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+		if (!folio_is_common_memory(folio) ||
+		    !folio_test_anon(folio))
 			continue;
 		goto found_unlock;
 	}

-- 
2.56.1


