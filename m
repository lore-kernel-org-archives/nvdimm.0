Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198181;
	b=YIp6t0DbV00bTrPWqT6I5TJyZvtycIOGHNGDma3wrCBDWvvV20jfmeRbqW8U3SNWa2wr
	 8baYh3usFU5x4T8oSvsi5sqmNJlkmIYIb5tuO/45xaQMqyZbir+1Phqme+SQe0GQtxKNJ
	 FggVVfa7nwGuD7RqCsMPS8pnzbhlrEgg9smAHxIbFjmWOSbndCOqFPY5hnwQa0/EBJ29N
	 0bJRs8e6tNoRWYw67vBkDWLzE0r7q7ukGd149h5LdKtF77CEFzZd9ELrfFnf36UkZ5OTe
	 +CTyprXDHFEwtFf4nPbT4py6Wol4vVxylQaBRoWRlOaAahi4p9Pfg9iGLuYSFLYxDgw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198181;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1fr3kKexKN6/LyygAXFTIEKl3iK6RW/c/i9QMIazwjQ=;
	b=upXSeXyqBFelDul301orJ/tpFRMS1psrJD2jFN6A53nAym3Z71UjzqPojyUybWDdhYHx
	 UwXRNh+w7nGWrC1oruocckE1VHd6nEPb4dKg1WAztFwzCAMQXOKct3dk+GUlrRh1N+8Dj
	 fUEycAzdgGAP5fRx08FNQiFNsq07VC9ZvS37vZHGg8oVlBh4q1D+Z2x+pyrBzAg+vLTon
	 PKMpMP3krGy81IpJGrYEWrjTvekZoy2UukiKPyWSfYSezrcW3jkKTFNkffq8dJKPzhvWq
	 qe/SDF4ZbXy3nKBvLx4F0ngL+wr8ijKbSiiPNblOrtAecZujmSJlFufu1xug2TnoQxw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="QQNLjO/A";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9B160A2623;
	Fri, 20 Nov 2026 18:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QQNLjO/A
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198181;
	b=tkiLDR64Na+wfBYnDDJfn/s65Xoq4YHJXxEtveXrL44aO389zZsTNok1N/T5436mVSEb
	 bByGx6wIDb9CGV3/JSH+Wm1imk5zraEBJJ3N1yuOr8m7PC8znYXB0HoSSceV9miRHaqxs
	 ouFl4IIBp/UnAJXocV/a+vUcobCMPAAbaB3yzbMBRrL+bDs3jYnHpMG83Gz8BK5ebEmdW
	 mvzzykZWFNTWO/DF2e130R1RXtn19B4f9xNsx2HK7ZcGxuDdl19n240uFr44ZBsGjOIpP
	 fcdwBf+jo3QtakTfrNAj2IqI1N09DEjzT7ZZlcFGz+HgRT89VKLs8sRqmrglBihTVQA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198181;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1fr3kKexKN6/LyygAXFTIEKl3iK6RW/c/i9QMIazwjQ=;
	b=yJPlilkdB/Uj5DREtZqIp2hjevTLMFgw4oq7ikPSj8i5EwL4zksYFFJojvT+EPdqwwYp
	 IppHn8JHeMS11QdAfFuneOzoWUYf6kVAWwCuLYvOS7UICk0mTqowAdg1vFSelayMo0DdD
	 D5+pWM5+YUV8M3/ijc+9Ia18x7A5ygBjxTD/Op62zKwhn+75hmUn6EIgwl9xvi8hWVpze
	 TPd18IJatsu8IYVR5nAYcQObokxpeYbztF8XWpIDJUtZETWAv9p4ZAfmaOIJTfp7xArgX
	 baXo5mbCEOC+nxUjkdnTnIMz0f84iXiVdcKQjCC2FWigWidSPT6t/1/2is3HnvkK54Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AE0CC1F000EB;
	Fri, 20 Nov 2026 18:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198181;
	bh=1fr3kKexKN6/LyygAXFTIEKl3iK6RW/c/i9QMIazwjQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=QQNLjO/AGEsdVDWq/dxgiR6dej4HbQKtukVFuY5he60ufYSkQ1oWWGrbr1rhQU54D
	 /775ZjzZXOCikDHf0Qn0ql775/A3AFaDGXWoutbch5nBfzJ9EIEB0YANrWDLwDgF8S
	 ufK73d4VtcQElmApOr8vrZ0hi9k0iL1jk8BKWjSwYk0SQNL63IIbpyL5bhx1bp6/6L
	 7+z4wghYetMtR9Iwg+jjugoUPGW5/mQCSY/+ez08D5sqhOY0EZiYyMDEQBptn3H3e/
	 wb6hlndjcyVPT6dpGbnytedZGUR5LEhFo2eJndfduqG5SjE1DrZkOpPkmmnrnN1+jq
	 aCg9VKf5kd2Ng==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7ECCF4B8D1;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:55 -0500
Subject: [PATCH 04/60] mm/page_alloc: build zonelists from common memory
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
Message-Id: <20261120-private_nodes_v6-v1-4-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=2108;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=hYnZoxMJ3yP49nfY0PYkTWJ6krAi0Bs8xOcweeGlZSI=;
 b=0+ENTTd09K3orEMzSi6wiR5qOFJD5dDrUYY3xdoPrBK5gY7zLwZQW1DS5dBPmSiXPxJfW0mkv
 12JJVCclp0MC6jQLSgCNEVIyNSUniufk9x/6ovTQjJziND5MyE5ogoK
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Zonelists decide which nodes an allocation can reach.

The fallback lists hold every node in N_MEMORY, and a node's
__GFP_THISNODE list holds its own zones whatever the node's state.

Ordinary allocations should reach only common (general purpose) memory.

Build the fallback zonelists from N_MEMORY_COMMON, and __GFP_THISNODE
zonelists only for a common node.

The build_local_zonelist() refactor lets us reuse the code to build
a local-only zonelist for nodes outside the N_MEMORY_COMMON set later.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ddb04b72a160..0448d04e048a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5947,17 +5947,14 @@ int find_next_best_node_in(int node, nodemask_t *used_node_mask,
 }
 
 
-/*
- * Build __GFP_THISNODE zonelists
- */
-static void build_thisnode_zonelists(pg_data_t *pgdat)
+/* Build a local-only zonelist when this node is eligible. */
+static void build_local_zonelist(pg_data_t *pgdat, int zlidx, bool eligible)
 {
-	struct zoneref *zonerefs;
-	int nr_zones;
+	struct zoneref *zonerefs =
+		pgdat->node_zonelists[zlidx]._zonerefs;
 
-	zonerefs = pgdat->node_zonelists[ZONELIST_NOFALLBACK]._zonerefs;
-	nr_zones = build_zonerefs_node(pgdat, zonerefs);
-	zonerefs += nr_zones;
+	if (eligible)
+		zonerefs += build_zonerefs_node(pgdat, zonerefs);
 	zonerefs->zone = NULL;
 	zonerefs->zone_idx = 0;
 }
@@ -6001,8 +5998,12 @@ static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
 
 static void build_zonelists(pg_data_t *pgdat)
 {
-	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK);
-	build_thisnode_zonelists(pgdat);
+	int nid = pgdat->node_id;
+
+	build_node_zonelist(pgdat, &node_states[N_MEMORY_COMMON],
+			    ZONELIST_FALLBACK);
+	build_local_zonelist(pgdat, ZONELIST_NOFALLBACK,
+			     node_state(nid, N_MEMORY_COMMON));
 }
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES

-- 
2.56.1


