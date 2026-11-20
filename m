Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795198226;
	b=osjBwc6bxcEGTi5Nk+AdKy7X62aFujrxnNiekG2T2FI7e8oqPTQqu/zMel2/BZ9AJllO
	 BY2KKf4oP6gAcfqYNZ1Nhx6U7R1jbwyxLbtARGZRffG5SJPgk78nEslfnaQD4Yfwm5Q9f
	 rVF6/q7/574eMXQq3hxBdZUqrc5omzs0m1nCDJJ3Fgoi522pvSbFbzq7sHxy7oMo4zPM+
	 6RVC4LqKnZbgoHuqXqqKSfDTGwn99VRkuWbyjcQ3E25NYhIJ1oIJKrU1SxpqvoU4oy6b5
	 EaR5ECHQbW5G3UqRzKfwp7v/L5svoYt/P3JLWNemjEiKSeAbrk2DrtaP5MAdDfLGj5g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198226;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=n/y8cFqv5JK+fAMYg6fQX9qejZNWm1aFs/7S7bAs+zY=;
	b=Ei4yNUl5BYz+zn/AyNoaxWiY+xnY4iQXDF7vXNOTJjuWDhrTzCSkDAoM2l35eCXW3bES
	 FgvL+FZK/2wmbi0O4+2fT15gkgFgSu4RbF8Tf102t06iORYBu4CVcb4ubU1AlCajUur7f
	 7AeM/nG6qhLg6VZQk27VFbh3dl+jnYAOCgcIpEFarAGoYdupdm4fFALh16DARiHOHNy5t
	 qKLrc2id527ItbteOuC3GsFp97pnnqwtJuaG1k6CQIs7atpBYaqSZLblKJG3eIzTlvNx8
	 pidFdMYeA+Ux9kER2tw3xZXHayiqxaUOLLqvmJn2DMWsyKEJgb4wwaGGawgnGdpw8kw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YIjD7q3s;
	arc=fail smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C110060A6F65;
	Fri, 20 Nov 2026 18:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YIjD7q3s
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198226;
	b=WKePp/1DPc71m7kcFSjrn/oH2L+rFpuDFZuC71pOzJGoIcaMb+fcHMsuUU4LTpTAnk7X
	 +D1rHU5MUPHRbTl20I8S1EHbuowTKRX3M8D7I+ZDjmdVXaVjYV/lrJwNDitYxv/zKBnqT
	 1DNVdOrpZHa02yyNn7as/SHZzlCKCq04mAR+3mntXp8fkCAYbvOHOC5F5Lqe2OE1plUSB
	 ITp7WrPjC8C4Jv1DObkylIK5QgfzlaPWVENt9htxP8Y5fX/uWvwDaELPpaxAn6hgJ9Zb1
	 sVK1dq5fZA3lM8I4bJxlZD30qcp5hLlXbfa1ofjoOHBJm4aj04St2ozcteiKu89eGFQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198226;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=n/y8cFqv5JK+fAMYg6fQX9qejZNWm1aFs/7S7bAs+zY=;
	b=Q20sw2UwpCdicKJ1db6bow8C5pCrPHM/PtIYcmuKVtiBBQBW1uRNF2R8CwkEud25ca5k
	 FQsmknP2yK4v8VekCysY6bstYtcBXHY7CaLFoF2s0vwOHzqSsZQP6pokmvRflIyCYe0Cr
	 S/vhNmA+TcpVn3B1O6Qd7kCy9XuvpSDM3cJ4I0lVCD5Zzj7H2S7I1EvtMB5yh+qCYWki7
	 c9cJ2Acsa3ZyzD/5500PgYwvJvClUWt28jDrZEixMw3zRJVVwEtNyCdYH3bCsFmhxEheg
	 K/V1dtpGRlAEkeMoDG3iDkThOu+U4aAfYAYHAZFJuvUi1ya6OOHBuZ8quH6/D2ZjP1g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 97AD21F00AD4;
	Fri, 20 Nov 2026 18:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198226;
	bh=n/y8cFqv5JK+fAMYg6fQX9qejZNWm1aFs/7S7bAs+zY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=YIjD7q3s8NeQn1uoTVBP15oEceAtLXqXtL5bWx3if+LgKseVVmOSOWvHTU/IOc/lz
	 TZ9g7MoHOvDrLmkDTQm7dqlE/JCJn9htLXbknpIq6Q0sda+nrBVFSh3iuCdIno3iqu
	 aiH6/8uQsqb4LlWS9lJk+GEhX5deZlPl9XMOZW1VJimC0yrdkS3xJ5KVTcrf63DqCj
	 hS0P4Mwzif3reMIm6PoMgNo8ojV2Kg7/UTArBfuhdXY8jtL/JnpR1ws2/qayIu1qla
	 yd8K9UfNcJFAaA88RXHjtL6fDf6iSqv7RTFQ/mZVCeeXCwKa9fABcJJ6C4Ha8UTBtw
	 R5SG6N8GvjxiQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 087694B925;
	Fri, 20 Nov 2026 18:09:20 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:16 -0500
Subject: [PATCH 25/60] mm/mempolicy: queue only common memory for mbind()
 and migrate_pages()
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
Message-Id: <20261120-private_nodes_v6-v1-25-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1280;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=oVUBe3L0N9OzvHIPOvGNp++MFXvEPdYO7K5H5oP/xXo=;
 b=z0Yss6rDFAVA1N5nV8ud28CkhXRAlSaKlLr0ZvA0vfg/FyvOeTLlv0XfslsD2RQQ13WZutKr6
 BXIJh30hlb0DJUOedF94r7a7FARtG2gTQbcL8IzU8HufAGAAA6nYwet
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

mbind(MPOL_MF_MOVE) and migrate_pages() queue folios from a task's
mappings for migration.

Queue only folios on common memory: convert the ZONE_DEVICE checks to
folio_is_common_memory(). As with ZONE_DEVICE folios, the skipped folios
do not count as failures, so MPOL_MF_STRICT does not report them.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 07d577aca78c..e208018499d6 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -687,7 +687,7 @@ static void queue_folios_pmd(pmd_t *pmd, unsigned long addr,
 		return;
 	}
 	folio = vm_normal_folio_pmd(walk->vma, addr, pmdval);
-	if (!folio || folio_is_zone_device(folio))
+	if (!folio || !folio_is_common_memory(folio))
 		return;
 	if (!queue_folio_required(folio, qp))
 		return;
@@ -745,7 +745,7 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 			continue;
 		}
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || !folio_is_common_memory(folio))
 			continue;
 		if (folio_test_large(folio) && max_nr != 1)
 			nr = folio_pte_batch(folio, pte, ptent, max_nr);

-- 
2.56.1


