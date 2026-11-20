Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198218;
	b=mKmeVAnMoPlZ51hRqxQ9rBqzDbi4N//JxBebxGRg4Czy7eCfeLGvDGwzq5wXHviHvZA1
	 rw01gJzahLtjwRDMmAJHaCqu79zgwX4Tz9Vjn65Ez2QbJH7ZWuakOMrGTTjjzSBFJdtj0
	 RP7uny3DX7bZ7X8LJMSgX8LiP7FeMdSpUQLw/ZLQA/AdTmiCDR5xTOqJsx7RaU2Upa4X3
	 QHbs0Gx0QgylKZbaPNq4iOMwvSjw1SZjtJSsqnhToNoBbWb5xlMVStTv7jPHfPM7WHv5k
	 xI5jN7Xgff6O0LovEfVorIxk9rFYpiGKV0TyutAoAarEgpgCasPEyqm7vIhtrQFjgew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198218;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=T4U9voPWRkqEb5e9dPQUgRiRcqSJxhhWoKa+JQ6JU+w=;
	b=JL/cbaqk4AzdnFIM/EZvpUwR7eHWI/20JR1Kf8C8C1P/bidnaywOj1Q4yTjHa5Rnn99p
	 b24IWf0WS6ZVp5MUD2H+1Ns6Xf1/4ib6q7iFxVbsVNcpox6D7cDDNarbz4fHpVRozEQFj
	 Qjplq3EnYgBWzjifmDcofCH5f0Rk1bPNQyIodPO7GV0PTM+JudRdftqhpeFOR68ZUfm3M
	 R/XlrD4kP7oLuUjIK4T12iEkpmxa7vM2MxHeHSn/MlNTUlACralRAxtqPNfPSvOb8Ol13
	 yVqrnN97vZ9AnoBQqeJxCGoYSbLzBPRd9BWbldhXI6SBUg4715ybiE7cDOt3n5wU1jQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nZ4Cvpan;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D26B606A8B7;
	Fri, 20 Nov 2026 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nZ4Cvpan
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198218;
	b=QotMmU/sZw3zpwJwBzrIYR8Y/+9q8YqXY4S8f9QTICpVYRHGiqlBGXVfQAaLVHy4+eCV
	 /MxRhMbbsifoTeEytGvk7Cz9IWPlyPzld2Z4g0PLnYnEXD+vDEGi6o4WnfTbISddCl+RK
	 +UNfbmXrnJei4ky38Mb4DVtgR0cDsYmaOSXxG0oJ6h9Qx2zW268uM+C7lQzNFOKMwG2zT
	 INwQZHr/BGCVOLoUXAwO+TEpBU5YnHC2pIbCckgDqJW5XWzEieil3OSqbScbUYZORZd4h
	 j/FjnSEaKWtGEnWsShuYBdZtIBjoCyyECOe7J8FG1TIq7faC4uTjQFe6ZPqfRBCeLNg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198218;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=T4U9voPWRkqEb5e9dPQUgRiRcqSJxhhWoKa+JQ6JU+w=;
	b=kjd8up/0W804YL8u72U5z2W2KydoPR7DvNsZwloBCEz776jt8q/sX9XnkpIH9LnHnIwJ
	 PNgOjaY9wqhpGhDWdpEVQNVvzlkBuLs4zyJLxL0MnPAOFBJsswAt0hGhjQ1mzdVW5hKvx
	 uG9aO6uGxMlsW75oyVGOZ3YOLdl3n4j2OJoXWIKVcXYRV/F1zkbrQf2CnBjLU7ZL8gbSQ
	 aSIQhH3musRTqJH9z8mvey31v5gnXTHKNSnRli7+k6uo8k588tfhwQ3oXo9TFw+wtOWoz
	 Cp4GEyrszvSE3u9YySTx5C8OBT36krQQI8PXAxfeBbcyZNNjDeoXhxvyb/dBSAeP2wg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CF23B1F0180F;
	Fri, 20 Nov 2026 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198218;
	bh=T4U9voPWRkqEb5e9dPQUgRiRcqSJxhhWoKa+JQ6JU+w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=nZ4Cvpan1byPUGv1/lXsDs2KMyCSkqLaaBr9V8UWUtwdJZt5M8QLc49a3OQUGVCUL
	 ofV0FA2qVClj5UwvL4uCqDGEHLbBuEQBZU7+jEXVX0BujnHHnQ5aRN1gpR+tcdKaZm
	 wFvVJ49S/3JkRfVWvoAvbSz/qjwzt7Le3zibm31QsR80PCQ2PX9jC80GF6S/+JS3PE
	 MMas5iOYvLEeGtd79QzW4yKEol94SW+xoJl6mJYyyqnLRTslbNNlhfbydxhMBlAP9K
	 ckBp2oIyfU87hKx+0ygSnjXjxPGzSDKtnwhmZIajRn40PUzf94be6Ms/IHVrG4UBSh
	 kztf5qa08ZhUQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DDA634B921;
	Fri, 20 Nov 2026 18:09:19 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:15 -0500
Subject: [PATCH 24/60] mm/madvise: restrict reclaim advice to common memory
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
Message-Id: <20261120-private_nodes_v6-v1-24-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1781;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=/55J316jzS1Wh7mQFy6gzCQoU7Eiv7k39WwzIyNwWco=;
 b=s8Msb/DrpA/5wN3ASvagAuczkPPgA4E++0gfH202AUo7xPM8n5yupjDRsPxxFkVKilzb+fYxT
 xtWsWL7f8LdCntXyjxSr/jqmZ85TrM6YA0zmgNaeq1zdsJM3IBJCiUJ
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

MADV_COLD and MADV_PAGEOUT age or reclaim the folios a caller names,
and MADV_FREE marks them lazyfree, whatever node they are on.

Restrict them to common memory: convert their ZONE_DEVICE checks,
including the one in madvise_free_huge_pmd(), to
folio_is_common_memory().

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/huge_memory.c | 2 +-
 mm/madvise.c     | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 75e8641bf9ff..cae28513b121 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2452,7 +2452,7 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	folio = pmd_folio(orig_pmd);
 
-	if (folio_is_zone_device(folio))
+	if (!folio_is_common_memory(folio))
 		goto out;
 
 	/*
diff --git a/mm/madvise.c b/mm/madvise.c
index 2d54cb9863ea..0f1648526f15 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -404,7 +404,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		if (!folio)
 			goto huge_unlock;
 
-		if (folio_is_zone_device(folio))
+		if (!folio_is_common_memory(folio))
 			goto huge_unlock;
 
 		/* Do not interfere with other mappings of this folio */
@@ -485,7 +485,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			continue;
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || !folio_is_common_memory(folio))
 			continue;
 
 		/*
@@ -715,7 +715,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		}
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || !folio_is_common_memory(folio))
 			continue;
 
 		/*

-- 
2.56.1


