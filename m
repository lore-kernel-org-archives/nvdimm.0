Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198239;
	b=PdkjHbV/UA0NVPuv7Xk9BCG++Qz+XK7/arrFmzhJExLSVTrVlU4/Drak8/8SSu8FKsQ+
	 wSallv2WdoDsmJQ8dmSH0EMm+lKLQ3oIsw1obgGgBFFDXNC8V6rABkjdgeb1KgUN0/gGP
	 L2GfE2MArLOr77mL/lwZmxM/HeLqo1xJj24dmlSo92dTyjmzPOgT3ZkmoMJFA9VCCxfyK
	 xXcuuqYFMZHrWLTFHEWLbTqhl/eOdsuJhRjon0OiFDo5m3UuTZZbo+HvQOAgOuW7lBG3o
	 He8OMV3fuv/wSx/u21UINKKmA4Q+1TFAWj6ZO2+3WbUrqteP4Ks9h6T0vrmHkx5C7RA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198239;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=r0JQqq0QcNOC5zLbyFWvr2UyNsYB0EDGYPVXscJvS70=;
	b=1PxZVqnYcBgQsSI79c8KBaOBAQXhXWeHHIqCNNXv0G0rqXFSrvmCxkCnN8OlwlH0z+ow
	 eNTLqQY2RD4TUxUxZnxQek+c5L5rmvIoMckgcSytTHEyzMvrMuPj49RKBoBYt9aeg68qp
	 kR1ohXnNXhSE2Yknxhggm1IfqMUzArnChhUIBGkHjTdQG4EFKB4Q9PZrlk//cvUDfTE/S
	 t9WcLg3cn3sJUvgQnKDRuiSpV50D9S31aH9lPwn69+Bw+hWGC4YRfXhDyfuUVwUsG1aOk
	 E0Edz8Aq/4PDWVDkxi29KPqrQJaif7z/Ch9g3CqeZR8FL8BoykQKSln174b3pEmRoOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eFOCvjqq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EBB60A6F5F;
	Fri, 20 Nov 2026 18:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eFOCvjqq
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198238;
	b=ADhTnukhE5KJiv3+DDwBkM4lnd/qAKegPct5ZemJlDzAIJi9DI0c8TUvjdpci2BqInn2
	 50xJur9pbh+9ee+gvQxdQB+s4jA2VI/tKuCIOULBoGHRTb37cr/Dc935qq3HTWfsgqkdm
	 vQ0+6zKtAXlEdwzItv2K0cys355bML0i53CpOF79knGZLXVkl0By3OnJlm5tWPguyXhe1
	 78I3N4+YVkKsEhPNuJhw20E6WY7kCABAOoJi7OGaC9hE8EHrB5Pt9NOtLxiG3/xYsh2a9
	 b/haZ9GD+TPDKy78ZZE6HDxPWh04Tov7PvnDQW9vyCD0obEXSgtbu1A92sFmt/nn+yg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198238;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=r0JQqq0QcNOC5zLbyFWvr2UyNsYB0EDGYPVXscJvS70=;
	b=ajL5Bp7v0Z6hpKInprU+FYfAe6IZmRgEHCPklc4AC/zihNZvIZo6LhN7jjhPjWmZaVLp
	 epqyWsbivnWg9OfX0IKOkdeTYLm20tPxITpupsXL07+RKvsB/R4B/Q/kDjZsszRGBQh7s
	 CgVlrSAIlbq2afKtVqDT3vwhtnGnpPt8hQ22ig9jX/M+9c/O0Ukk1IUsWsp8hLVLpY/oM
	 ToxjaqXZ4AZAvFnHfp2qCdfHIKJT5qvO+/q23GimeHrUcIF1BPUDGPHaZbpannoeXhXMq
	 l5UVbBUlmOteSPgfCHIoP21I10iSGXA1cB4fHnhaJMYz8bernEV2zu8Qx+2Zv1w27ig==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E0D301F01579;
	Fri, 20 Nov 2026 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198238;
	bh=r0JQqq0QcNOC5zLbyFWvr2UyNsYB0EDGYPVXscJvS70=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=eFOCvjqq/hzbQsZGhGUOLRXvfxme1t+QAX90jvrxmoGJzEJhGuylVwLaQOoqwulOI
	 IrkqiZtlFOQAYPXIqFYubYaEtq3lCFfbfGAnwINVSxPk84UjEMQH5j+dwk91TJZ9uy
	 EZJzyyf55n3n1OTcxo39TpwkPN3BmISvj6Y10azqiU/cMqWu6iKLQGh/eFTLzL4JOc
	 792FjImkJ/WzhbKbCn/0BxX4iA0QDxe0wRmaPZe0n4kuxvVG/Vm4nps8r8B+qoqZOj
	 niHy5IM6m3S+p7ZAq2tJp9me1H8DpvU6WP1FrndQEN/WcGi0X2REGEs+lYDjopk4N6
	 n8s9ByJH51LqQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5B9844B951;
	Fri, 20 Nov 2026 18:09:21 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:27 -0500
Subject: [PATCH 36/60] mm: refuse explicit reclaim and compaction of
 private nodes
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
Message-Id: <20261120-private_nodes_v6-v1-36-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1212;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=eVaoyJoyzU9zyOtulCuIbI+hG2+czzxVMTo5PX+qnoE=;
 b=67qX9eYJBrvlvPcdtzToXyRPuTdmsGPvAub9aazmEHJk4ZHCWWJWu7Tqa8XRPOPW+PAeiRoBS
 +WMnYQ09bUHA4ZgWD9y4UJK3j2zi7pY+0jx9YkmAbm61ZjkvAHWzQu6
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

kswapd and kcompactd do not run on private nodes, but nodeN/reclaim and
nodeN/compact name a node directly. Reject them for a private node with
-EOPNOTSUPP.

Memoryless nodes keep accepting the requests.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/compaction.c | 3 +++
 mm/vmscan.c     | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 879f372a891e..283d4d4e78c3 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -3038,6 +3038,9 @@ static ssize_t compact_store(struct device *dev,
 	int nid = dev->id;
 
 	if (nid >= 0 && nid < nr_node_ids && node_online(nid)) {
+		if (node_state(nid, N_MEMORY_PRIVATE))
+			return -EOPNOTSUPP;
+
 		/* Flush pending updates to the LRU lists */
 		lru_add_drain_all();
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5b53e0391d80..3e934135e805 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -8268,6 +8268,9 @@ static ssize_t reclaim_store(struct device *dev,
 {
 	int ret, nid = dev->id;
 
+	if (node_state(nid, N_MEMORY_PRIVATE))
+		return -EOPNOTSUPP;
+
 	ret = user_proactive_reclaim((char *)buf, NULL, NODE_DATA(nid));
 	return ret ? ret : count;
 }

-- 
2.56.1


