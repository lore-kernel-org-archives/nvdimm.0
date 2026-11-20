Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198238;
	b=UihgF7Uzc+UOqZrQ8Gv2SAHk7SJ87BdCPHGfABR7J/0uEtjrDMt3Czs3JijIhchyJj+Z
	 RefyRWVNaRlq8Cl/OmISEat1Ik9y7vaPsP5cZHhVlILIDCW6HYVEdZqsl2GMk5g6P3rzI
	 0AwckLnzDukZbsVymIzK0rXq106XwqTcixiqVsroRBwF2CPEwEipxspx4Gu4XyWCZTSFe
	 fGP+f4xgv7MAq/znbFDv4F9lyfiaBZStIRZcdXi3GDExAbOVBJPHoRsyn/5cluMQXxPRV
	 RIepBv3np8VqjeX0DQhq9qb34FUq5Gth34JEBw/SE3piUGy6/XRj8ocB1oJGZdev8qA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198238;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ah7hRwVf6ds4TiFuASfnE4NQuTk/w//pBxssLX2GVTI=;
	b=AB1giPFXTYBJTOgcfxuqolbJ6XDpEyVyr0hk62J5QjeZ/4U2YaXV3n4pmal2LKuo0LMx
	 0irMSnKEWly3MAGzppbksxfuAtqQ31rmj0E2pxOfIS3o/TGUZLjc9TmHRyRKlB+qNDdYL
	 l6Vi40idG+bOGCU4VAGJ4CGrRv8s9NTR/Fl2JqQTL3BUg4QYKpht1ZLenqyUBIIXq8tVd
	 FakWrNmFWZFwUieeR+bnSUCCnsUTmusBWWB6ppoKnanuv+e1E0G2KfJQtucCisXmcjjA4
	 lMmM31WXNo38q9R1Ur4efj8hclWi/j0K6Eqsw58RI1MJLMhnSIwS8CCtUv7KPctyx5Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R7RrdNXJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421DB606A89D;
	Fri, 20 Nov 2026 18:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R7RrdNXJ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198238;
	b=x2c7EJYfG/GDmZ/Ad5E7CBibcB6m0Un8sAB+XSfzIcWmJ2+mgO7oxvKb79YS8UjWrvPV
	 CBYPq8zIOd+hvPA1RrQA4Z+XVwLwfRBCm6UEZbMyAIQHOFfiyZGgYtLwSHOtYBJk+raXT
	 UCGnOvNZ3hGhh2+FmDLRvVX8IOPXVHCnvRXlxmMJZ3T3los0649I2/sr1MXLc1oW5P2lI
	 hOF07KGAMyvvkK0SwucMsmKqkPWra8bDc0HZZtfKn6+cyHKXBJQOxC5Q4ikYNNh7dbxgV
	 SIYs2y6Xb0DEulveLjrXgKI42/gAYcPLvMLLGwiJ2J74sOsKbLPz8he/+qJ8LbO0WGQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198238;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ah7hRwVf6ds4TiFuASfnE4NQuTk/w//pBxssLX2GVTI=;
	b=JYonikjBlr3WpwgsS/STnW6LWY5A1T9SBK2rPueS7q2PXbb6U8HvpR8bX6v7yd62jUJy
	 dhFVCSQA0EHse3e+VqmaiDEJGKArE/8PItb+eb6xJsHyVrD5b5g/5TVg8k1OQJhL6eBuf
	 Fm0awUZMBknL4zKdxY3ddNdvHE9aRvE+MXMaRXdg3ozt9VkfE1GVvUcJK5mcCISPG5P6m
	 PbIyehAyPjB7t4Jrd87QYcMCxVokHX40t996eepyVABGX0R8aPBDKiDMjVD3SO/LjxZRG
	 RkYsL94XCGZ6shDHU1YDjveRmRk6Ji/QXC/vPccK2mvw+ZaJh3GTobgo21bfxfbPCgg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 35DCE1F0156C;
	Fri, 20 Nov 2026 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198238;
	bh=ah7hRwVf6ds4TiFuASfnE4NQuTk/w//pBxssLX2GVTI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=R7RrdNXJ+kgnDJVXq/jZRR823nNEWB+5pzX2p+2Adf20fkwctypDJ3LZ5+eHa025M
	 UuRQtS3Do34w+fQex+9u83C3KjaS8RuRXyZLoBr1YHbujfBy9zqUlB0Vt24zzw5zbV
	 3btZNj2oSBHHZqWuIv/X/cmlsoFjmdXOYXZTDL9vdqNZVkAKZ1akc+7SDJJokRirDf
	 QmYzQkvJ3nMQ7MZwvfZoqwBiaN51mv7ZCbtlBvgWySYp2Rd/XInGDd2FL4l/4LS/gK
	 3mtYh987/KRgusLHWn3q4XC27pEJx4UwdlxjOT1H3dRjEd3G3T7FbSgG/cy9yAiaZc
	 wheS6CnN0ixzA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3D19F4B94D;
	Fri, 20 Nov 2026 18:09:21 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:26 -0500
Subject: [PATCH 35/60] mm/mempolicy: keep private nodes out of
 migrate_pages() destinations
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
Message-Id: <20261120-private_nodes_v6-v1-35-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1114;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=H9nkzUJ+W/B+CQbALDD5SyhxQlr5AVXp1jZnonCs+2k=;
 b=qYt4WGgIFvq2RJT+D/LbNX9eFwn5eLa1APiNG0q/gFK7SazhE8Ij9A//vMkPQj7FL/v1ICdhS
 jrfi9jSAKC+C0aiThj8fYRh2F/Gs/FtXJaqopNXu15BKaJfgfgG0QYs
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

migrate_pages(2) intersects its destination nodes with the caller's
cpuset, which can include private nodes.

A private destination gets mapped to some source node, and every page
bound for it attempts a __GFP_THISNODE allocation. A private node is not
on its own __GFP_THISNODE zonelist, so the call fails with -ENOMEM and
logs an allocation failure.

Leave private nodes out of the destination mask, as move_pages(2)
already rejects them. A mask that names only private nodes fails with
-EINVAL.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 81ccc481cea1..2bfe8b2b6287 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1958,6 +1958,8 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	}
 
 	task_nodes = cpuset_mems_allowed(current);
+	/* Private memory is not a migration destination. */
+	nodes_andnot(task_nodes, task_nodes, node_states[N_MEMORY_PRIVATE]);
 	if (!nodes_and(*new, *new, task_nodes))
 		goto out_put;
 

-- 
2.56.1


