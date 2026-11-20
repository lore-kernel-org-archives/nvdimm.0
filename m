Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198224;
	b=Hof+wtj2hUxwLe3rzJ3VbZ7VA/8YCfOdmpPM+SgmUp2dYacQanZZJP0lBJ5+ndVXT89u
	 XQWdm9CGmULYmY7aMeJHdz5vZL7Jtq2rlz65W8kjBbw11jhCcV6+0lHLU9am74kbiS4EN
	 Y26fQFBLvmxsSOWLGZ+zcwCJvAZMwMqBCC//pTU+mT5hiDQreGmMwE8hm+ABSF6gvLTse
	 vzDdvIiNcqAh3uSZ5kwbsFnCRMtCtTm6iA7PFcDkkoU+POXzOphlBWl+mj6/QNtHfQ5QI
	 WF6SB2H/spzkXbyf2uAAo2r91SSTXyNZsL1uebg9kw1xhUvnP/5d7itLnwRRvCeGmaw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198224;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=MYei4KuJf+QfbxwWuL97G2Caql6yWhkkwRbrkOuMiXs=;
	b=1tgiKEa5oQDSpDSCPhGYIpOE7yrvZUONstIWg5gkoShWQxUFIHKPmkuHTwMeIb4RFvkv
	 TpnqPUElebI3Mt9Uxpa5ySWxajkVTzbirwyrelEuxEDCyK0zIryfySZfCvBsNtURIkrvO
	 MrDl0LLjC80TRIwjlYq0JT4afylYgARENmx8VTNENRB+5Yf1N0CoB+Wso046a75+IVizT
	 /JeujJ+UaZmacKfcKafS4IGJaA8B7tXIKFrPMr6f43xrUl74ZxwAJ19VffpraINlFw7EI
	 kbqREIpMd+AAo84bd27wyQPsUd02nz+Il+Za/5johQBDPlDRP59LkRk15fovS+j3/Pw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bfr7gsN9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C386A606A8A3;
	Fri, 20 Nov 2026 18:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bfr7gsN9
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198224;
	b=HZ/kRQ9cFPxp3qbVVoFe6DRfR75D9Q3svGPSPfhZRQKOhtd7wKsUKjCKOTiU2MJsH6Ig
	 cKt1Q/WFL2vH4AaePF1pxr+nU1RLvbqygwnGLXmpplmB7iNolit2NyVXL06zXiVTwOBM/
	 OO2talt8oWdgSpyXEhHm9VdvlqLoZx+hILSYHScn5NSH69k6Mvo4gzIgPMrZZZvYIKzu6
	 +etIioEXGURqHcoz1b2HBopMaTbIXTHMSkRDDqNSU6xmYS36N58MQxMPViskcwAFjyoOS
	 Fg5yOCMykwrVCgl4ih/KhZ9LVVLbZk31hpkiFH4BsobtdmdnVRYR7viCfDNMnDHmwIw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198224;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=MYei4KuJf+QfbxwWuL97G2Caql6yWhkkwRbrkOuMiXs=;
	b=o6L3Q+lr/h4pigjE2ZjodmuZhP5wcm6X2+JBFJbCA57MSP4JMunFfCjNbPMLbQMNcFIq
	 /EON2Vfx/798nNEv4aJdaTkDWnwPGqHEIfVJmjFadfWa8LtffwAu3WMCs/Nj0qURkU7xM
	 ZzP4VdCpbxs0ldenEYcEcMEQkOrspVToNfQwPJ291CfYC8JXYSi1IBDgqu3N2tR71QqXG
	 vuO3k2aNRAe+5QTOeyn4hvQJbQ7lp/GFwX6/vlD1TmNMes/3R0M0FBHo3NbDKmPjWP6ih
	 aT0bFHgMlWCkBk+6kCjdLTMg0nxV0A1rY5QfuqNuwfG3M+jadnKgRmonez+BtbJRUuQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1F5541F000D1;
	Fri, 20 Nov 2026 18:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198224;
	bh=MYei4KuJf+QfbxwWuL97G2Caql6yWhkkwRbrkOuMiXs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=bfr7gsN9HGFgagPxUethiledap0CYhJmAdy16Ejj+yKICb7IBFi71E44m74b2gvvG
	 3M3Wv64z3II5NsQ1IvtD79HZr/sir3F3KreH9VxLbHmXVIlvOjTgha7OiKMuiCIfs7
	 uZunKKA11gXcv6Y6lhr6B+I8qAaemzdFoCm9423YMeBUdRythlMzPZY+vSex2N5012
	 zHIvpa4eAtmuFEsEtjVqlhcWrwlRddYu6lKlhYHyWxWWGln5VDCw4L/Y4tMGxeenrz
	 Qm6bc1WUXjerxhcB0+3x59QmnpiQeKc/pcuDUzRAJe0lGvHD/wPDC5O84SzreXarY1
	 KbL4oOfZBKZYg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 82FDE4B915;
	Fri, 20 Nov 2026 18:09:19 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:12 -0500
Subject: [PATCH 21/60] mm/khugepaged: restrict collapse to common memory
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
Message-Id: <20261120-private_nodes_v6-v1-21-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=2345;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=ZHvwrgi2a6sCoho/O0VKGbyW17jDoPTBbXNa5AUwPa0=;
 b=TQS2bHGS+OuUEC48m/xNSWijxkvjbzhLZJ7z4ADh21pF7ZIpFCDog9ykVjustle3i7kJOVUnm
 Ml0Xe8rxuVDB0u52WP6/DVBClG54gRk4+r9fp5F4BpeiiOAJlZfj2pv
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Collapse is an opportunistic MM service and should operate only on
common memory. The anonymous scan and isolation paths already filter
zone device for the same reason.

Replace the zone_device check with page_is_common_memory().

collapse_scan_file() gains a folio_is_common_memory() check. Page-cache
folios are never ZONE_DEVICE, so there it only filters memory outside
N_MEMORY_COMMON.

collapse_file() rechecks once each folio is locked, since a folio can be
added or migrated after collapse_scan_file() looked at it.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/khugepaged.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a930d99f89da..b1c6bb95a936 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -628,7 +628,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			goto out;
 		}
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+		if (unlikely(!page) || unlikely(!page_is_common_memory(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out;
 		}
@@ -1673,7 +1673,7 @@ static enum scan_result collapse_scan_anon(struct vm_area_struct *vma,
 		}
 
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+		if (unlikely(!page) || unlikely(!page_is_common_memory(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
 		}
@@ -2397,6 +2397,12 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
+		/* A folio may have been added or migrated since the scan. */
+		if (unlikely(!folio_is_common_memory(folio))) {
+			result = SCAN_PAGE_NULL;
+			goto out_unlock;
+		}
+
 		if (!is_shmem && (folio_test_dirty(folio) ||
 				  folio_test_writeback(folio))) {
 			/*
@@ -2737,6 +2743,13 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 			continue;
 		}
 
+		if (unlikely(!folio_is_common_memory(folio))) {
+			result = SCAN_PAGE_NULL;
+			failed_pfn = folio_pfn(folio);
+			folio_put(folio);
+			break;
+		}
+
 		if (is_pmd_order(folio_order(folio))) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			failed_pfn = folio_pfn(folio);

-- 
2.56.1


