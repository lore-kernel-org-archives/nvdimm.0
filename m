Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198202;
	b=3EDEwvNmuX8d27AjFbq6HJcu0fmoiXU2pMQs9qj3l7mBOod7elv2GhsP9KvEzBsF2vA1
	 rcHF6xDltHVZBX4X611Yj6T3rNeRilgbXhvVkUGtASM8PWotR1qL68hs9XMAjJGHJIaLa
	 c90zt39ZBX3VWCQVjOoFzwOIKkpxlBOjwYIIMoV/uwB5Z3TKnE0mghfjBOjbg64Dc8HoA
	 t8s7Ry37n7bUTJQuDME3kE7mqQCtBW8yVJmaW+oePheQfjQnFp3z26uB6M/hzX1IhEjFz
	 qN0GiV8lxUKKilZHTD70gBSiKNVunfhBwLNHb8Go2d2K4JTuRNCAdgYzMN21CQaXBNA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198202;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=EBVDrIkZhM4Nb0FLnM6t7I85jx1pyyYz9Vpq72X6eKI=;
	b=b8ufLfXMt/RVgKiuuqByarsx5Gf8+77EHzSQFGwEDdAfMbO9DPSDOtL2Q4e6HnJ8C+6y
	 UKg1Ks18HQxZ/nxrjPVeH5Jm7PYZTp8LlDjgf5lXUdFW+Do13h8fDKSrli0Am90xXacSC
	 HSNBGNWhQ/4p8mA+Sck7Z/wAkZJ4OA9sKbRpYxFYyPdGsquHeLTSOtXWASM6+uxQpK/Mf
	 JYO2U4rZGyqwjokGPJrWTtXyDpbvAFB0rRkYJjHVvqJxpFgCvdNfnqC3C6Jy1hUiWXzsZ
	 v8AdUqUDqmBYGtb3XIPXA0rJLi3vHdIPXfisyNmIGwD+kYL/0tvKTH7olPx+gsc70Ag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KZLiocUv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F273B60A2637;
	Fri, 20 Nov 2026 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KZLiocUv
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198201;
	b=XuN7S9mLuXsxzqtgifAJLhDADRHzS0IO1IEaRW0883V6crYycC7Q90d2X5CS4AibwqCF
	 +EMpKOplj/it5yHFeR/bOtAl0gpfGM6HxZ/ctVG1XqITQrdvIjkwfRdozQxKuDtHpNjns
	 d05LBmMx29haIHZsYg5798DSp7lMC6Nvhb3TfGqyLNgvLjD7TpPk8phPsoFAyEHD0cuEr
	 eAoxijxyLtSWANVLFkyQOt48/ulojwCBdOdOWHy0076jZwHAP9Yq3oo1kbnitInIrxigO
	 fB4zrl3m/Uh/R/uZk9Nu9RmaGVsE+mXfBoqB5LF5JQbAC244PbXhh6Ear8cW4ReyQqg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198201;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=EBVDrIkZhM4Nb0FLnM6t7I85jx1pyyYz9Vpq72X6eKI=;
	b=BFXF0HZ5dFnY0GOiqANtxha0N8TlpfG1fedapNbBTCpfHAt0dfgyGgO7xgGrK+gC2dgO
	 KWKsk4lXE83iN3ucj+0ryuV2K9/zYNuNVAPISPKJORFXb/ip26b6USLDzD21yLcPSljqF
	 zLkgy10T4tSZ0IflJKR1f/B0qwVlCS4DBLlNAnDs/rQWGdUrzXDvh79NcOByGResSo8Cr
	 RGeALSOoyNAcH9eso32jWNklNKW+UvtpyrmA8HuRK0ZfqBoZ+uQ3VgUpp39AaarueKi8r
	 LbdJjcSLYPMi47+7EO6flEBEGvR5tZKZePsSvjOE3sB5bplDkz+KRppK+3DlWLqURqg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6525C1F00A01;
	Fri, 20 Nov 2026 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198201;
	bh=EBVDrIkZhM4Nb0FLnM6t7I85jx1pyyYz9Vpq72X6eKI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=KZLiocUvuXJId5ciyEv8Pl9h7flE2FulREnv93PCzgXt8pWoYOGns2N5e8FRgD3E9
	 doPB6UpMi8drHgOZCueVCF2RgoGt+N4jQ3gpklphwpHfyG16b8nN4HGkvhdIrIu5kx
	 Q/cb5sGgXn2CQhrSFw8KFaxciQXeSmUWzxIlZWkkhwafAEeVpGCMkj8LT39hrVGHEx
	 ovPPA8YBkGrX0z386keH1N1oVzYzuOpMIK9HjkuUYt9cnc9lPDzk7esPvCbBDwBNPh
	 MwY0TpQDnHaINrZW4/EBdzsmjfEwfhIPR259EUYnYGRjuUobpraZLhSfAXiweGkG9q
	 8EZreMXED4+rw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4D7494B8ED;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:02 -0500
Subject: [PATCH 11/60] fork: check cached stack locality only on common
 memory nodes
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
Message-Id: <20261120-private_nodes_v6-v1-11-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=1024;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=FFFpqhBLc8gM/DlQGaqjHX/JHYwyjj4bi22co9/B61M=;
 b=rO3nC+tuGAUkZK+up/1r/p+QOF9uTflwwwI5VKLdkKL6Sn+VumAtsjX3b0agV4OanZqd598EQ
 09gpdfrfuhCCZcNNEYTDTQ0+HvWE+lv0vLlhX9nLj+fGFDMFKeEbBl2
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

try_release_thread_stack_to_cache() caches a freed stack only if all of
its pages are on the local node, unless the local node has no memory.

A CPU on a node outside N_MEMORY_COMMON gets its stacks from other
nodes, as a CPU on a memoryless node does, so the locality check would
keep it from ever caching a stack.

Skip the check when the local node has no common memory.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..28c58f2765f7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -254,7 +254,7 @@ static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
 	 */
 	scoped_guard(preempt) {
 		nid = numa_node_id();
-		if (node_state(nid, N_MEMORY)) {
+		if (node_state(nid, N_MEMORY_COMMON)) {
 			for (i = 0; i < vm_area->nr_pages; i++) {
 				struct page *page = vm_area->pages[i];
 				if (page_to_nid(page) != nid)

-- 
2.56.1


