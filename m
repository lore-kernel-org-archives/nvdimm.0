Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198279;
	b=gOyuhfrsK5bDsUWGvYWfdopLI05F3g7QOXqMzDxisO7VFKk+rxz+f95wa472Mu0WFxVM
	 8ODiQe02WiP29NxOOeGsTqSA1UtnW1ybSr3Cw+2oUGe5oDNk0yDilbyeNqUwcXLhPo8XY
	 TObI3sCBp5wOCmua0DxS9UlXKBfVnNrDoIx8WFMs8tK4OddLfviNTi4FA3+eYUaWk/ctm
	 DyDKPOqJM3xKuY8HBwweMIS0hX3bTjPuQVUrBCsZZfZHDuGNDpr3+2k3IJaSGgoEIJSRb
	 XfNd7T4XS7Fzbf9WQwdHaM9WJFPpey3Jw3nPKZ0MjQ/W/jbl71N5uMu7EHFZX6kFkoA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198279;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6ZIvh780Er1fFAiiG/5dzmAinodD1fFI24Yf0GcsOag=;
	b=lkDGv8eTDxBXG38kiYwpwquvQ8S+GYMk1ju9ZEv2PGllv73DPpeV7UOgzAbMRFy9rOIr
	 mOkOVeOsrgeYZvzRETVtiBGdVp39oavIuRG9G7OUhK/IO6W1QSsz3T2YsUHM9D0GA/BYU
	 wwqUpHFIB/pqpffy5scTaZlz1T82fJiY0+HEqWyI8ooYBkTAMFXMbavijp5tXg+kR0DLl
	 RTsyRABs557f8uq6YWQESSGfqL9XRQdCvTKYKSLl/V8Pwu/sVw1hLQ32jH6B34GuGfNMx
	 sI0L0v3gF5o6YR6LnunM+77IWzW7BTSRGd90Cf0LfzDljkof1Uzxf4zT4AOZvJMxHjw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xx2LbsDg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1791B606B98D;
	Fri, 20 Nov 2026 18:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xx2LbsDg
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198278;
	b=1lcde/aZQBCroOsDLusBaTAuwEG9GCzg8AKrS4Rclc8ZvGglPnsStGvj2H3kT2iw1h0D
	 F2MQkUiSu0WvS+k2uuZXCwKhUKfH+7ZW0FXRQW4SSiixtJ1MoHBWz4LTuO8MRQUK+mAmb
	 uTDScJS3xsN4O736Xh3HRQ1+u5V8YMfIDVnKM4fP5jREN04KzcA24FoPV+Pt8Doa7evkX
	 3I+V2cmPnO0LLng4VfJlFPtTTtC1GYXNWAF3h1zBGTX4k3jfHmv80sYKAtQBgU6wZ98e0
	 I2Kn30TVp+EYLy62dev7tKLnjilQNutuyK7S1k7YsvN1xO4hx+wForbDcEbk7Dr/ohg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198278;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6ZIvh780Er1fFAiiG/5dzmAinodD1fFI24Yf0GcsOag=;
	b=LrxwbxL24yWMbH0+8laG3aiEGMN3EdUho3Cq1eWYpYqg/nvpeSUMFqgSrCbKKd6vaKVj
	 2cMuXWuvzJItbmFzFryviioIvP7lhpf4jPdYWcmeeo2S+KMCV5HFEeUedyp8PwSs2N5KE
	 9aMr/m2u46v+POTH4+zOxRdP59WaLo7pGq6+hpejh38O5LFNeq1iz7r091xYYPTrl+/1N
	 1CCMwJoCmbLfTihQCHs6LtXrPWccREX90pnq7j8iptLsurKTi14PinyfUZGHHMc0uxl/B
	 3OCiI5J0SnCa/8hsrXAU2WQ4f4WqQrEDCydqbuHpij6/iACUodqyIZBG0BlqlwokVFw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C65151F000EB;
	Fri, 20 Nov 2026 18:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198278;
	bh=6ZIvh780Er1fFAiiG/5dzmAinodD1fFI24Yf0GcsOag=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Xx2LbsDgf7lG4BF45ma7TAkYGEqdqIRCraobimDvRaPMADYxEWbuImUGrZF5dh/kC
	 K7TrPGRPDRB0iVcjmXRneECVoNttNy/AceODw1Akmz7wdj/RlRvIHbt4+cvL98k7YX
	 BF85k+Ld7AZsjCPsph+m4htx9XP1yNaRB0JjoCI/QpmSdceelLh9bSWvWOqblX9Tr0
	 deCQt6Y2pOlc5Dygck4gn8vIRDRSzwlCEIqSWNaEHIR3vUJ8TdMawX2nL1hqNA+UH4
	 TbZ6v3PlvdQHPslKVhaniJYsyx+P3jbyL5vDwixJGKO7tKdRBuWtlEMh04Y5PuXajl
	 IwBSvB1+ZHc2A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D38034B981;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:39 -0500
Subject: [PATCH 48/60] mm/madvise: restrict reclaim advice to
 reclaim-capable memory
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
Message-Id: <20261120-private_nodes_v6-v1-48-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=2519;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=/7n8Y7BJF+n1w6zg34qEl4WSAk5zs5lFqc/saob4yDc=;
 b=x5v1UZjZD7NavKPzy3gZFJ4vk2PBUASf1WJMKcO8I8rh0UDg9n2rwb6VVYJJEjpdeaXC+C4/N
 8FX/kkSJcmcBGbIA1sklk5dsK0Xt7WZPXHmG0HW7LdpXEcbdkmZLRkY
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

MADV_COLD, MADV_PAGEOUT and MADV_FREE reclaim or age folios directly,
bypassing the node filter reclaim uses, so they act only on common
memory.

Add folio_allows_reclaim(), which requires the folio's node to permit
reclaim, and use it instead for those advices, including their
huge-page paths.

No behavior change to common nodes.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/huge_memory.c | 2 +-
 mm/internal.h    | 7 +++++++
 mm/madvise.c     | 6 +++---
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index cae28513b121..00c72b91ed30 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2452,7 +2452,7 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	folio = pmd_folio(orig_pmd);
 
-	if (!folio_is_common_memory(folio))
+	if (!folio_allows_reclaim(folio))
 		goto out;
 
 	/*
diff --git a/mm/internal.h b/mm/internal.h
index 9c162ded5305..fa1ae221564e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -80,6 +80,13 @@ static inline bool page_is_common_memory(struct page *page)
 	return folio_is_common_memory(page_folio(page));
 }
 
+/* May reclaim act on this folio's memory? */
+static inline bool folio_allows_reclaim(struct folio *folio)
+{
+	return !folio_is_zone_device(folio) &&
+	       node_state(folio_nid(folio), N_MEMORY_RECLAIM);
+}
+
 /* mm/vmscan.c */
 unsigned long zone_reclaimable_pages(struct zone *zone);
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
diff --git a/mm/madvise.c b/mm/madvise.c
index 0f1648526f15..a5fa3b948a20 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -404,7 +404,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		if (!folio)
 			goto huge_unlock;
 
-		if (!folio_is_common_memory(folio))
+		if (!folio_allows_reclaim(folio))
 			goto huge_unlock;
 
 		/* Do not interfere with other mappings of this folio */
@@ -485,7 +485,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			continue;
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || !folio_is_common_memory(folio))
+		if (!folio || !folio_allows_reclaim(folio))
 			continue;
 
 		/*
@@ -715,7 +715,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		}
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || !folio_is_common_memory(folio))
+		if (!folio || !folio_allows_reclaim(folio))
 			continue;
 
 		/*

-- 
2.56.1


