Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198170;
	b=RYS94LFQo8KmowxcPLU1YxDyewCeB/SJYONMtfdcGYAV3XqbHzRULyuwmR/1v6NACUwP
	 AM0q6cUvb6YvXHSkWBArHzIf3612xtOLfyEfZtWVqB94Rz/4q8ODwgcAgn0OkQzlrBu2x
	 Wlx9dn8DG9nxgmCnXYIWOM3s91xU6G7PwioemBqildOhJiYUVzbWQYJnK0rS9MiQVTtw4
	 WjxfS0k2xhZa7TpC8d1/s7aR2frdErV/hWINPp71XBQ8cSkpEmU9q+K+skI3Gnrn59cRK
	 zHJq9wUazqVIIB2OiuGtjK1AqqfeD5bPRgEdkCNkr1/fIACQU4RLLNP1hsjnx/Z0suA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198170;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NTsNDMBuz7zPhiY5EdCthhkTLILbhAv/FdI9gjXNQX4=;
	b=09joYTU4NEQEkqaO5lifnx0QmtpSjHGDQrB6AexiC3wtanAzM5aCJ81VQc8SjqtTxkZK
	 1EhQt9LZsXhffJz2QPUM2C5InJ5c+NafznpRu/ZZ0Vmpdi9lp6uOSroDipWW/zWR2PdSr
	 dCo3rLtzCZDd9Ar1plTKt/W01oq+XL8E7ckZY/qxlcjauk8t4ft/Be+VpYGuaqtfsQ49q
	 U0JALq3CP4M1qdKmEtmmBTvTQybb9wrkgPuDQ0BVgf1+4qkrv5dc9C7JiOHYs3iZjcKsB
	 S3rmqieOi0TZPkfz8W0AOxam7d2bo6jrnKJ255l/MuVT9abApoodx4cFNYo8ioMyF6g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="l5V/+EuU";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C34606A335;
	Fri, 20 Nov 2026 18:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l5V/+EuU
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198169;
	b=2fm3oJIfacRV58tKr04+SjQjMgImPzFLABofcMO1aHpUdC9kBYP0m3RljKh2gdP3nlgb
	 55wWHmckTLkwcoIHxkxqsZ5tZ4HHtEgAlMErealMjIoKIEqQCTpMhy24G0xdjAlWgg0pE
	 Xcm3QE6CgufIwHs/vpqtNAkxTAm7qEHq84x5Vz27pP26M3EMoDC50j0isf320mIaKNaUT
	 QA6hQ0SQ9WVmXnX8VaTZ7YCIvVOhDyhZo45lIoo2acQoOtiEUs/tFCYrocBtctFQOBD3Z
	 bZWNo9ugj0QyPNfXiwEQPdYqETWwtKCJl/1e4Xn+Vdgn4EscvSK9tt9DJ1/snCG0qKQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198169;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NTsNDMBuz7zPhiY5EdCthhkTLILbhAv/FdI9gjXNQX4=;
	b=LJoIBWBFUvpUJrpm17RNmyFzxgu+lnaz0+GBXz7ntuzt06i3N0MCEp4CDhOjR2UQwOsA
	 e5xXve3wzj0seFIStGNRb5mjSFW6VcLyPbz+Jk/FCREtfuLzk9QLFyaptxG0YRSSAG7SG
	 y/QvplTB8MvM+edaSl/uit8iun7LxDnNsZCxl0tDoolpwOAYmWK+15S0ibjx1+nZcZTP5
	 OBEiAQbihcGI1szIsvGro3XGfGCvESujPoFgDv77sZudeXh9/NA+B+ZQfJtz39mSHqgzd
	 4kIGGHg7/i64kHItu/AVV4/N1XA2sxJy5ROtKtTQOr60PMD/eIXw7B2RkkRilEZULKA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A20D41F000D1;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198169;
	bh=NTsNDMBuz7zPhiY5EdCthhkTLILbhAv/FdI9gjXNQX4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=l5V/+EuU4PvP0RiYrfLT3SAD6U0KHvuf8qFxU309jSif57nh8Q0kGkmO7OPyCYr0q
	 xbfFznMM+Rqz9WIWIl7p6AkSSmv4OXaITj37z1Z64zPRjTIjI3x2ePMyPViiqBtKIv
	 tB1yxIe0zridNxcKT1HYPTrvCG19lO5fk3WiT2wrXmI2YE3qs4p29+bUMh3+OnUb+v
	 YMGpWtO24FIJ8Ye2j0cUBzu9SKjH9PAIGHaQS8YPTTUYxLp+YTa70ZCXxSQp2/4CVH
	 B78U1I1xMApAe4FrDnZw4c1bUfl1u4ifFc4AiOypCExWG6d8IS+xvJVEakaynbeP8I
	 0iJeg6O21zthw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 26D6D4B8C9;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:52 -0500
Subject: [PATCH 01/60] nodemask: add node-state iterators
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
Message-Id: <20261120-private_nodes_v6-v1-1-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=2119;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=G4ssD0bod7vgjZxwR56nCucNo1kgkEnObUnor5Z23Ok=;
 b=RjAl7uvfEf4NqVkoeEx7BN6LIu7ylgrHkEUd9mkFu97o60NZ4EyCUrePrl7IYTdG0pVE3cvIL
 Tfn22wnQtSZAtJ0uk4weMboEXWaQLw3lMEAfCsBn1GD/x5mvmm8mTel
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Add first_node_state() and next_node_state(), so callers can walk any
node state the way first_memory_node and next_memory_node walk N_MEMORY.

Add for_each_node_mask_state(), which iterates a nodemask intersected
with a node state using the bitmap intersection helpers, without a
temporary nodemask.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/nodemask.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 607373bd83ee..90bdcffa42ea 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -411,6 +411,11 @@ enum node_states {
 
 extern nodemask_t node_states[NR_NODE_STATES];
 
+/* Iterate the nodes in a mask that also belong to the specified state. */
+#define for_each_node_mask_state(node, mask, state)			\
+	for_each_and_bit(node, nodes_addr(mask),			\
+			 nodes_addr(node_states[state]), MAX_NUMNODES)
+
 #if MAX_NUMNODES > 1
 static __always_inline int node_state(int node, enum node_states state)
 {
@@ -435,6 +440,12 @@ static __always_inline int num_node_state(enum node_states state)
 #define for_each_node_state(__node, __state) \
 	for_each_node_mask((__node), node_states[__state])
 
+#define first_node_state(state)	first_node(node_states[state])
+static __always_inline unsigned int next_node_state(int nid, enum node_states state)
+{
+	return next_node(nid, node_states[state]);
+}
+
 #define first_online_node	first_node(node_states[N_ONLINE])
 #define first_memory_node	first_node(node_states[N_MEMORY])
 static __always_inline unsigned int next_online_node(int nid)
@@ -481,6 +492,12 @@ static __always_inline int num_node_state(enum node_states state)
 #define for_each_node_state(node, __state) \
 	for ( (node) = 0; (node) == 0; (node) = 1)
 
+#define first_node_state(state)	0
+static __always_inline unsigned int next_node_state(int nid, enum node_states state)
+{
+	return MAX_NUMNODES;
+}
+
 #define first_online_node	0
 #define first_memory_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)

-- 
2.56.1


