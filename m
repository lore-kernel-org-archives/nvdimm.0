Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198248;
	b=ouAkZbRF4YuM/niA0mWIBFB5istSy/sNsdUxBfa3jGMvH1RrqBxRnWJzVVYlPOgx72Pa
	 37lAxhBnnJLXSLCfOZDG38gU86RiukSvP7xDyUoxpWGSZguldAmwPGxYE4u07JEEpC6r7
	 ZhQbay5oDioKr038xpA0TD1IY5BNJOTNVF7ZlTrsmPKtKOT7kJyQXqhu8Q+5K0IVY04BF
	 0yx16vuQQePbo7zkj9hi9Sl/PE2chWn0kdGbXUN3MbdBbDjZf7S1GQrB+LBJXIf96FIBF
	 jVOB5OEUcRC+PlM9Daxx3ngD4DHKvqcWOvywoJMZhkD+wx4Nqg+A8n4gngtt7iTviXw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198248;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=FBy5UCo8x8GxER/KqUcslMwbrqch/uKM5MuNKEpgn9Q=;
	b=z/L95DmAtZ33Bpou+nlWATqFkpAXr6n0JFxPJw7AG0Osf7MIf86ZEhts5ZtnlKPRgN2Q
	 og5lE+0K+NpZDtlloBC9Xusw+gY9YNKaQa2E4IbfeeADbhdOvMQDdKK5+25ggPHlZZAIu
	 WWNfVcy8mAAqMKMGvgWtztl0DAW2OGKAt/R+S2Jlp+otsUl6u0QPW8nNd2ZWywe+bSsVe
	 uWb+8KzNZVSTkp7Dv+t5FLek/V4fjcEAqsqLynOUp/3DTXuST1GWJyPVogAt50ovTswLS
	 Y3irTbKKMfzUGmtRCCAn0tg+gwUz3vWfoar4B4IBF/opCs4oWDBKoSUOyXzvvrYxlVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hyCLUaXa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D3D606CD2E;
	Fri, 20 Nov 2026 18:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hyCLUaXa
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198248;
	b=19ISg4NGgGBK3jzZeYhaeme9hkY2Y1oKabqrSTcjxbcyFvMYXF7bWa79xBhOVDLGnavb
	 UGgr57LoijtozGXYRgzmIqP2khGAJvYdmn/+nZVTBGahSNThTOivDCo/3SnQtE/vcbWYA
	 RU36xPEDhtHzLIH4R4tC+p6pNbSVd5meCg2xIK5SdM0uHZK+S01dpiC4aOuQ8K3afZAOC
	 aC31xLVSpM1tCMp5HyxhnbsznbIoU59jLlVliPlWQq3+mUcRsueh0jQ5gkZNwoIpZW6ll
	 M/ZZoomDjIdj6sdtpQD06VyYYhHkQChIYZn7FTe/vA+E0izaOE6VW27VVl8a27jWX3w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198248;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=FBy5UCo8x8GxER/KqUcslMwbrqch/uKM5MuNKEpgn9Q=;
	b=3q9KnuhUgRcwp21KxRw6eMpxY3Vc7rN+RiI9ob8Iklo3MP+8y4To04/4PUGe0f2KIdgG
	 SzmgG8LkYVwz1Lq9hEIuT4JpvY3fFGWSE+6GuClTNFcj/eM2BShIfD1ida7R4luEYHwRX
	 NTx7P94ubcwgZhjyf/KHbMhDSBlgCLRpBdl2belh9p45/+rFoijaka3x8OC6hL2YncxRS
	 T3CjJ3kIY/DBB7qaGx9wxWA12MebyV0rJI6r+K9+dSLIvkNlN8njI/0iHvvmVAovzedQs
	 9+sIPpU+QBa4kKx+OTP77k6YUW3u6KaxMMJs9UGPbgKl34rSKkZgzfZfjENYDHrwdjw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 86E0A1F0180B;
	Fri, 20 Nov 2026 18:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198248;
	bh=FBy5UCo8x8GxER/KqUcslMwbrqch/uKM5MuNKEpgn9Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=hyCLUaXaNr0UrnVJSxX1Vg8RevXhXv7tKfQHtZrRv6OM3tmmAXPAiCbSZEq+vP4x+
	 TaDjnzyM5dBze57NlG2Y7+pNNR3DiljbDjM192y0smTuTUj9ggn6ipoJgfnVwYjBBe
	 HhWhGeNe5YOE/0jKG1S9SfRfGMha+becru9/zuUX71ffYt4JjbHvSJo+QLEmP1Jkdh
	 eyxj72HF7CSRLEuNAqdlQJFzUNQyvIoCWq+rk5jATd5bHmsyT9GMhuaWIkKDFqwq5r
	 Asa8oR+Q3LyxgfgehWs1seuBNFygv4bSAXNG7jpD7QBlG/PwyOp4Nn15UJeVNyVsuX
	 X4scQ1v6pgz3w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D4DB04B941;
	Fri, 20 Nov 2026 18:09:20 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:23 -0500
Subject: [PATCH 32/60] cgroup/cpuset: keep spread page cache off private
 nodes
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
Message-Id: <20261120-private_nodes_v6-v1-32-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1224;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=U/hUJktwLNtMpFnMwtT8ZUgdvPgOHOmoMK5TEsERPVo=;
 b=6zBGjHr356XwIzle3h4wX/iKnG/2+8B5GuEfHIteJvz4xCnBp6ubmqH5bkGYDUttwW2K1KHpu
 JKpw6/sCtwuDyKwjrhDyjB+1mRZE/zXC/EcJ5YWA5D7ZKOSyFjgOwu9
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

With memory_spread_page set, cpuset_mem_spread_node() rotates the
preferred node for page cache over the task's mems_allowed.

mems_allowed can include private nodes. A private preferred node will
fall back to the nearest common node, which takes an extra share.

Rotate only over the allowed nodes outside N_MEMORY_PRIVATE. A task's
mems_allowed always holds common memory, so the loop always terminates.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/cgroup/cpuset.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6802ca13c46b..8401b69ee3da 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4600,7 +4600,14 @@ void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
  */
 static int cpuset_spread_node(int *rotor)
 {
-	return *rotor = next_node_in(*rotor, current->mems_allowed);
+	int nid = *rotor;
+
+	/* Spread page cache only over memory that ordinary allocations use. */
+	do {
+		nid = next_node_in(nid, current->mems_allowed);
+	} while (nid < MAX_NUMNODES && node_state(nid, N_MEMORY_PRIVATE));
+
+	return *rotor = nid;
 }
 
 /**

-- 
2.56.1


