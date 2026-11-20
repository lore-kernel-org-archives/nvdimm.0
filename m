Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198258;
	b=hIOaTSJ6aHT5ah9/XoohAgj6Kh991T2cImL4GZulvdD6dWSjwWnxWdMr56dU8ih+Bd/G
	 qevUhNAD8WOyceh8Io+FHOiFNRSNstbTPq7J9wKwRFI37kvUPQJ4+oXlI67hvJfRdtUd7
	 EE81obGyL8hZDnjTONEJtNyIGXiWJFBq7vPGlcE48aTUQ9KUKiw0Zg+g0zwf3qasvwKUE
	 H2uhTsgqO27a/J+Ab2hGW0e80JipkAmv9FR9k9WgtsgtF73pCyx2fjuIMREm/E2N/8Xfi
	 APszFGen/hwzcVbveFDHrquZ9yRLUG22gVAT7WLyD9SaxQbaR6zHpwirWmPOvK47HSA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198258;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=t9int1jy49B7hwGXzuzABb7Yf3ibBtagCxCa/Nz1EVw=;
	b=JNhdWYUO3rKyqafkq+1hdfQK2Eymnz+d9bPjWpCfLXAGfdkuvR/lzn+XjVi4PRZivS/5
	 lM+D4FgF+IbKW7Cewzp495PokumKYnccP+KmrHf12YGMwwoLZp5tLhosWaCQjlpclR/dZ
	 FEJBMMYxnE1X/+5NjR7nXyoGv0qYHtnotJHtv8KZZjeLQJkFsZ6QdZ+w3GtqQIlsBNytA
	 BxrjarBY/wUzF1pLjwQ5l8VNLUeMjWpWx1bvgKCSdXwPO8AF8OqgSIbutafLOH4xYZFai
	 smwg4JPYE6mt0lLKym5IGQgMR/qtik5IZq+hqt6cu0X16ER8lFmtkue4Gt+EcDHG4kg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZWx6zKX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C4B60A383B;
	Fri, 20 Nov 2026 18:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZWx6zKX
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198258;
	b=K+3Sphm/+Ihlwbw63MlZQiW2MDWuO3vCoH3mUAzibWuaLeMUJ74VeX5W/G6RDcwndDPN
	 wRSI/bCa7MJI7tAR+pGQsl8qLyxzJZv9cy+yj7CMDiFscXVqsvthyAJ48lNewJMJ+CGG7
	 ayiRySufvAs19sc0mct8w0CMkAGKCeWt2X9tp6/xqI+2lyV3akVv5Wj5exqLGdG6JJ21U
	 8yHXq6zO9XHmNyytkRGhKiaFbK+cNaTBnAZLyPehogFu5BAnyaaSjhaBEtzq1j2p6CPOG
	 4oYTgT0F5k/I6DUkcF48vDkehY1G4WssUih5KOK8t0FXj/n6xfuyl3M46z/kwxuA9wA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198258;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=t9int1jy49B7hwGXzuzABb7Yf3ibBtagCxCa/Nz1EVw=;
	b=rJVo8pSR6djvuibmFOxHS+E14uaT+CVZj/ULKspC3k4+xPMtxn7RDFgj9n0QTKTeWW0J
	 tyLDpxb3UgmxxpcvFSjzTgxPtyjBf8upINta76Siz0QL7c1SrjilY5vX6XgxqY5tSdjqY
	 VcZGbHw8ywI65mAy9ZRlJmmpAP4dNq9oGiTbzygzOgxIsphXsLJ9TyjDwO1/hXzRbg9tD
	 sxoGsuQYngunsXAs3unoVFl50ULIhiKcS8xNPZI/xfjb/y0u+EJB1i48A9Lbh0r+84CrB
	 57ZYoW4jfCXzy8vNDKFDvLlqKP9TmigaLBUuYrTZ6oRw2laGH5eMCuULyLDCWlSJ3uw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0CE481F01561;
	Fri, 20 Nov 2026 18:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198258;
	bh=t9int1jy49B7hwGXzuzABb7Yf3ibBtagCxCa/Nz1EVw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=IZWx6zKX2GJFsFpj9nPjSVwreu32F2qzBsNLO0BN7egLNjAwf94SC7bEx7mvfhf3Z
	 ModgJOraBe+b6PstuGPyYbpO0zCye9q83WIb4nJQgAuG2RrRAOzWE4TWVszoM8R9EM
	 Iv+g+ydFVduRfx95tmPhgsdJ0fMSRjWc+j+wMr9GedaRm3XHL5eYJZOOit4gMBhpEx
	 O+tjTb6pSDQlYHgetvqytNBU1517jC+sINnUEfZaCVo+SlBQ/jfXaesayLgajiOf3i
	 hBF4n/ZkpxP3vV3v/9K53gB93FPvCTmOq5WNdwx6QTi+keTxqEUH54HdBs13CX/Tu1
	 3rGrEvxWMKE2w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 78A5D4B975;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:36 -0500
Subject: [PATCH 45/60] mm/compaction: restrict compaction to
 N_MEMORY_COMPACTION
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
Message-Id: <20261120-private_nodes_v6-v1-45-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=2489;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=M6oyV+uEjYSavi/eHygS70B16tEpJIW4P5C3UsQGkVw=;
 b=i/PUXbQkpoN7NVE8RFc+oEQ2kDN3DCJbLPIIOQ1aa2JDj2LavBaQ5jxI9kU+y+KQpdfh6F4lB
 iarRB2RDZBvD/7ptCHks4k7qA+bRL3m/1zijoNFVJyaSj9mQYSEfV+o
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Restrict compaction to N_MEMORY_COMPACTION instead of common memory:
  - compact N_MEMORY_COMPACTION nodes for /proc/sys/vm/compact_memory.
  - start kcompactd and trigger proactive compaction on those nodes.

Direct compaction is unchanged: an allocation compacts the zones on its
zonelist, and a private node's zones are only on its private zonelist.

nodeN/compact fails with -EOPNOTSUPP for private nodes without the
state.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/compaction.c     | 9 +++++----
 mm/memory_hotplug.c | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 283d4d4e78c3..6835ddb91f29 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2973,7 +2973,7 @@ static int compact_nodes(void)
 	/* Flush pending updates to the LRU lists */
 	lru_add_drain_all();
 
-	for_each_node_state(nid, N_MEMORY_COMMON) {
+	for_each_node_state(nid, N_MEMORY_COMPACTION) {
 		ret = compact_node(NODE_DATA(nid), false);
 		if (ret)
 			return ret;
@@ -2992,7 +2992,7 @@ static int compaction_proactiveness_sysctl_handler(const struct ctl_table *table
 		return rc;
 
 	if (write && sysctl_compaction_proactiveness) {
-		for_each_node_state(nid, N_MEMORY_COMMON) {
+		for_each_node_state(nid, N_MEMORY_COMPACTION) {
 			pg_data_t *pgdat = NODE_DATA(nid);
 
 			if (pgdat->proactive_compact_trigger)
@@ -3038,7 +3038,8 @@ static ssize_t compact_store(struct device *dev,
 	int nid = dev->id;
 
 	if (nid >= 0 && nid < nr_node_ids && node_online(nid)) {
-		if (node_state(nid, N_MEMORY_PRIVATE))
+		if (node_state(nid, N_MEMORY) &&
+		    !node_state(nid, N_MEMORY_COMPACTION))
 			return -EOPNOTSUPP;
 
 		/* Flush pending updates to the LRU lists */
@@ -3369,7 +3370,7 @@ static int __init kcompactd_init(void)
 {
 	int nid;
 
-	for_each_node_state(nid, N_MEMORY_COMMON)
+	for_each_node_state(nid, N_MEMORY_COMPACTION)
 		kcompactd_run(nid);
 	register_sysctl_init("vm", vm_compaction);
 	return 0;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index d7ce60c6815f..1cb10c88954e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1232,7 +1232,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 
 	if (node_state(nid, N_MEMORY_COMMON))
 		kswapd_run(nid);
-	if (node_state(nid, N_MEMORY_COMMON))
+	if (node_state(nid, N_MEMORY_COMPACTION))
 		kcompactd_run(nid);
 
 	if (node_arg.nid >= 0)

-- 
2.56.1


