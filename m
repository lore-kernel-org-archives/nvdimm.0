Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A0D3AEF58
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576087; cv=none; b=lLDruFI/u6P8S0um3+h9V0Wlj1HNN4aI/uz9KxNsHd7P1gqkdtr5w6BUWT3sZFoNK2BsgLT9feMh0gvoMJTRRo2kwZnXuK4VASednX0E6k3a041OXZC6P2xf4ZlK7Wwt5tmLE3/q+XPCa8hHrXFicSCtvxGyZYb7casdyl8M5y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576087; c=relaxed/simple;
	bh=BXKkjPaqRDLvf1Rsfxqjf9a9bmU7Z6cyMAMgQYWOA+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnullAwhx82+csUGbEyN4mKXr0hM9Ash3hCBPaDKjQD6d6IBQRyQmOvyUIywrY7+3I1f/fY+szc/PMDXagKjB+uJS30tRpqwFqxZlsHjFvHsL2LbGchR/RGW8hPOVdPIXpblCyN5dhxCORMolXeU6aXMItOXlBWM1Sf0d39jGBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=YpKXaLNI; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="YpKXaLNI"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e5d6f35c1so921046385a.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576084; x=1785180884; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/c51hvMQmc3XHuoW6uDjvccdoKFQfSnHZbbwUxq30Zg=;
        b=YpKXaLNIRLTQ4whQ4dnPBXlIJgmgqRsVBTaV7DusIEq6asgbj4uECYP2bDubVBSpln
         3Zx7eb+E8F6zR0un4/SEJU36R+H7HWynrDDUWfI1iFYuOiej3R8AmkIX/MwPZBuGvTGf
         MCtX1+w4uaKjKW2t6z13TGDJA9RTMmAy+w21eGscmbZGj8PQD+Va7OrCkmzTcwDTiS6l
         6r7VFjdrQODBv4W/DiDsd6/ooNnlLRWbKFWr63YnQp1qaFMKfn9Hc8BmAbw02mvBTq4V
         riSTSFyIePOKDeMXMACrPpJIIWJQwDdMLwR2YZzK8Y5kdnikFMUczSfg8AZMpg76RcHT
         7LcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576084; x=1785180884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/c51hvMQmc3XHuoW6uDjvccdoKFQfSnHZbbwUxq30Zg=;
        b=rV7AoNSkld6mtuUcxGwD9wdYQN98QnRL10sxj9WmT777iLcA5mYZCZWdjQckLvpSPZ
         qezHFjSK05K0pe6ik3dwwUvH7pl1Qg0c/uFggKXih8ebLdRFZtARo+IH2oC5Rcv0zM6A
         KNuVT6gEWfZH/v7ILI+wmgg3noui3JmRYegr1AnbRfKFfFhBx/iaHg/dyvdPrd08sASG
         84NTDmv8583R2DiWpv2NZL7sFh/txF0D99h2m8NXGZOmLHzwC9j+C7acMBrZnKl7LXGW
         TVvNoLaninnfoEdRUB2y3odpo1X9Iou7dwnFdM26wD9m6mmJ75FD7Vvu7agJK3RrRLnK
         pX+Q==
X-Forwarded-Encrypted: i=1; AHgh+Rq1RGi+rxKoWsTqZJLOteSSvbWiU/AQQdkoJa+PjepTsfPy98lP+IyjY2z3rCugKxdU7+iLgRk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJ64ujkZqihI2p1C5zkRwsOhDPIcTi77Opg6uTHktA4m8NNhoH
	aHPAa16+vqGS1f1zEB/7kMOhEYi0IPOQ9wnUslqbaqA9JjeNw2VRqcc5LZBd6tWaoL8=
X-Gm-Gg: AfdE7cmZ0uj2UhkCbId6nqV3R2YFvsw4hR5HTqIxpqHIN/TX/f4TLi0JaMyHvW0kTfS
	RIosc9pbmY2LEDiQDHfnCH10yIfyXTsWNHubwUcGKEJZhv3A+FmNT+xZfIQzg2sGvsbn+6qavs+
	y1mLmix106B6rVmslfHm4mBazsYLYBdEJ3c+FY9fVM4sLxiwC5da+5ScYK2KUzzecOM4u97f5sO
	p9glmgHMPPUHtHIWvdjDDf4/GY1hGthkxu63468J777PH9YPE6o33rLP+2n2oQCuaj4P9uOVdAm
	83G1A0A07/RPo8xJNMFMyBgwKMC1qevdENE86pBWlw6HJfLcu1JZpQUPFexgUWjHI4OuxPRtGXQ
	RCtokJXcuAvCnNxoKH7jIIO6Iv3k4z1ILG4IZ9u3y3Ffdlwjrap6QMLkONepySFFZm00qdS5ZHj
	jFbrbjM9ddtKSHpA52gjwP8yhL6sYSVOSXgczhoBIWTK9B8FvG0QTn2+LifQU8h8XEvwIjiiehM
	w==
X-Received: by 2002:a05:620a:1a19:b0:92e:c118:18bb with SMTP id af79cd13be357-930b43dfc05mr1508161685a.90.1784576083785;
        Mon, 20 Jul 2026 12:34:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:43 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 02/36] mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
Date: Mon, 20 Jul 2026 15:33:56 -0400
Message-ID: <20260720193431.3841992-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extract per-node fallback-list construction into build_node_zonelist().

This lets use build zonelists from candidate nodemasks instead of just
the default N_MEMORY node state list.

No functional change: build_zonelists() builds the same FALLBACK list over
N_MEMORY with node_load updates as before.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index acf096f525f49..4c1ef84c02a3d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5813,12 +5813,12 @@ int find_next_best_node_in(int node, nodemask_t *used_node_mask,
  * DMA zone, if any--but risks exhausting DMA zone.
  */
 static void build_zonelists_in_node_order(pg_data_t *pgdat, int *node_order,
-		unsigned nr_nodes)
+		unsigned int nr_nodes, int zlidx)
 {
 	struct zoneref *zonerefs;
 	int i;
 
-	zonerefs = pgdat->node_zonelists[ZONELIST_FALLBACK]._zonerefs;
+	zonerefs = pgdat->node_zonelists[zlidx]._zonerefs;
 
 	for (i = 0; i < nr_nodes; i++) {
 		int nr_zones;
@@ -5847,26 +5847,28 @@ static void build_thisnode_zonelists(pg_data_t *pgdat)
 	zonerefs->zone_idx = 0;
 }
 
-static void build_zonelists(pg_data_t *pgdat)
+/*
+ * Build one node-ordered fallback list from a candidate nodemask.
+ * update_load round-robins node_load across equidistant nodes.
+ */
+static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
+				int zlidx, bool update_load,
+				int *node_order, int *nr)
 {
-	static int node_order[MAX_NUMNODES];
-	int node, nr_nodes = 0;
 	nodemask_t used_mask = NODE_MASK_NONE;
-	int local_node, prev_node;
-
-	/* NUMA-aware ordering of nodes */
-	local_node = pgdat->node_id;
-	prev_node = local_node;
+	int local_node = pgdat->node_id;
+	int prev_node = local_node;
+	int node, nr_nodes = 0;
 
-	memset(node_order, 0, sizeof(node_order));
 	while ((node = find_next_best_node_in(local_node, &used_mask,
-					      &node_states[N_MEMORY])) >= 0) {
+					      candidates)) >= 0) {
 		/*
 		 * We don't want to pressure a particular node.
 		 * So adding penalty to the first node in same
 		 * distance group to make it round-robin.
 		 */
-		if (node_distance(local_node, node) !=
+		if (update_load &&
+		    node_distance(local_node, node) !=
 		    node_distance(local_node, prev_node))
 			node_load[node] += 1;
 
@@ -5874,8 +5876,22 @@ static void build_zonelists(pg_data_t *pgdat)
 		prev_node = node;
 	}
 
-	build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
+	build_zonelists_in_node_order(pgdat, node_order, nr_nodes, zlidx);
+	*nr = nr_nodes;
+}
+
+static void build_zonelists(pg_data_t *pgdat)
+{
+	static int node_order[MAX_NUMNODES];
+	int local_node = pgdat->node_id;
+	int node, nr_nodes = 0;
+
+	memset(node_order, 0, sizeof(node_order));
+
+	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK,
+			    true, node_order, &nr_nodes);
 	build_thisnode_zonelists(pgdat);
+
 	pr_info("Fallback order for Node %d: ", local_node);
 	for (node = 0; node < nr_nodes; node++)
 		pr_cont("%d ", node_order[node]);
-- 
2.53.0-Meta

