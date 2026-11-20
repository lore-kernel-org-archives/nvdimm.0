Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198203;
	b=2CLecMVVOccqumCSgiJLH8wKb6/JcZj7Kq7+XKRFclmAYj2RqVP2wE50vIzCdrVIO3Sk
	 o0ng316GEWXnB0wrNUROe1yvauE96WpktiRxGWC/1x0vMYaS/OHQ67WLrU8mGNn+Lzthr
	 FwqAH6InQrVSwEk/kLFouupVEq9iLExz3IivK9VlcJDa5etcLz/ID9fM2iIRv2f4wEXmg
	 0vH1zqad1wa7ZDogiBv09zfKQ2BniJU5Q3i7kUMys47X3azwO9nf0Si8q7j0fKnOFXsja
	 8M5teMsdl/oYRuvawB226VxqekMAP5ons9CKCWW7KI/lEOxzdQIOd3XLtgx03iiC0Ng==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198203;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4M2rXiYs2G6SjYidH711tRE1Q56dF/DSHWjxK6H/p44=;
	b=u+vM10eu2mhg7DUpbULjHvktcJJrV7G1WrOnqnd8Vzx6Q40mIt2BqsfWCLBNGXWHyJDU
	 +r2ErMvF4T1nhVL7d1UyiYORg97yOx/YQdTvdhzXEjY44GQnIFDZlrnWJNC/r18xwa2Qc
	 G4cBpIakRvYUaMuYKKcdlwm/lByrU/N7/ZDBWC7CSGSkZxTeFxkb7MSS7UvrlmoWJjza4
	 ijtYzSKnTsHA8hg9v+4cmUGBMGuysEZNFE6QaDzUg7lC6H8WdHDwzpiTMlzcmM6ndlFPO
	 LSP8RhgCcCl72pcCecFqka8SlE4wGeb0J9zLknHVqt0MEP/ncrrJfi5Vyez9qEQRw9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=npIpvQo0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9D260A3834;
	Fri, 20 Nov 2026 18:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=npIpvQo0
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198203;
	b=ljF/7TeKcDgbxvSqHCegLHgSjJ0RTLGQUaZHCKBxfT1t5teUEzo0mh2lQpyHNV/Y+sPw
	 yuCmPTtSdSW2eQrDb4xmO1ubSC9JwBYhiRvhvaB9ZkPSQ8E9FJuh1vN34ntFDhqOPf8Fe
	 jDa1wIpyY2jVcEZWfVpawdrlELWnizBdMPJ/G+1QCf0cJBc8O4ltQIFTG+q1j1NoQJbPp
	 XyUi+NNAaAB30Mg99r1LbZsDvxZuu0SAztlxUD5K+9nbFjcpNTdGpZ+vc4qPPwFwUh2DK
	 hqcBc/eGtz9ZWtn/9k6iNTkPaMPk9iAU9tjcMuKQTvuK8GCfdRaLDNkAH57L27u5W9Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198203;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4M2rXiYs2G6SjYidH711tRE1Q56dF/DSHWjxK6H/p44=;
	b=t/aZdUK3HhexuX8FaBkbf78mXGvq3Jbfx2Cw4bVGwrkvWZvdUPLiuJG682S6lQP38WfD
	 o4dxGROzW+6OOk/ZCsf6eBoH6RNYajUwId8N8009lgEoMHATBR62qKx0Sd+1xD8VqE+IH
	 zseAAujPQJlJSkeGlO0RYcWF+IOeZLYED3sf6k0yvWaPw2LGQDcRlu4fp5kmHle34sj2F
	 0iY9bzmjXwicXA0RGq1Ln8+gmQ2Buhvw30QzyiJO/NUG3s1EkdOXfld8HzXXCqZWKRRN0
	 q5K/1gUnhWclMFhMei2FieXXoNOHslNHu1g0gtWFBQ7FgfqYdUXZkDoSPZF1MXogSwg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 37E561F008B2;
	Fri, 20 Nov 2026 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198203;
	bh=4M2rXiYs2G6SjYidH711tRE1Q56dF/DSHWjxK6H/p44=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=npIpvQo08GPPyawwy2tSG2OGFA4RQSKrW5TRczFP/YHHIaSmYqYO+X4TE5ZjdvXnU
	 jFPeWYxy3aAyPEYJIy1BrCTxgnrSKc4C1ohHSivqCs+27tJ+zAomlubfFNGLv2uw7Q
	 fV8mJpQCNyU468AQhqFzhxv5gDNy4mzZ0uGy3YxZzra0tzTTuDAH5OG2k2m0+zG/E9
	 p4ghKJlrsn49bj+PKLdUSf8cCKDO14TeOvBkulHzMmQifRaw206CQSvZAK6NBkzMip
	 R9L7ZypOl60ugUzVYc4+knhqQ6mGThXBGY6cz7FZG9DjTIDEt/JEQX6ANVjMf/ULrl
	 DfxO6BztkWhAw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 323304B8E9;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:01 -0500
Subject: [PATCH 10/60] sched/numa: restrict NUMA migration targets to
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
Message-Id: <20261120-private_nodes_v6-v1-10-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=1044;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=8xAnUIGjGSJir+fD8yB81C3j8AQ2SKbyFL5jvqemmlk=;
 b=ITwE6KTd6aOZpuyjJFOoe0STMIT7+0eaFIXOVs6I0ryUIxRHLbIno5UO04kFOxJT7OvBREvQE
 aMVtqVwDWbPApem/lyw9QN2C2QmxHB1p/MFJmF6ejxZlsuwRg6Ycrdi
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

should_numa_migrate_memory() refuses to migrate folios towards a
memoryless node, since the migration can only fail; see
commit 3fb43636876d ("sched/numa, mm: do not try to migrate memory to
memoryless nodes").

A node outside N_MEMORY_COMMON can have CPUs but has an empty
__GFP_THISNODE zonelist, so a NUMA hinting fault from one of its CPUs
would isolate the folio, fail to allocate the destination and put the
folio back.

Check N_MEMORY_COMMON instead.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0c8af1cac2d5..18db9bd25db2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2876,7 +2876,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	/*
 	 * Cannot migrate to memoryless nodes.
 	 */
-	if (!node_state(dst_nid, N_MEMORY))
+	if (!node_state(dst_nid, N_MEMORY_COMMON))
 		return false;
 
 	/*

-- 
2.56.1


