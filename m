Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C21481AB3
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576135; cv=none; b=HwdKK1kYkbqvMHE2T2VXExCpmt7V3uyNTvyGFt56eCM65GzIVHvt+gQPbVOUdNIhYICcDNmwyPtvq7VJiuQyzswZKoS1BurHQcGg+74PnJkhX/CeUHcpSp/cVyCkHmORoEp9oQHHqNIF+tljkQAI5xbc9355l+bmMFzs+ZONb20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576135; c=relaxed/simple;
	bh=6wvL9kFs+/iObzzTHi4ROLnjN3QU20HiRZxAvTAZnCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7VaOsoE8LibdmimKyBs79s0KTCG2pOF3Gj6f/40T/LV3CbykLBP/sIb2bNowUU0bwpIxMrLQqgtCML4iNOrWsjBzSy9uXA8JInpz/R2WUIegg6zFJ7iiIBcIvcFq95Rk4VAWoKxsceZ7RNyFQt4+vxPWQrRtybr7nm1s3Mob8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=ZBHPJkMN; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="ZBHPJkMN"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e512a9a6bso657019485a.2
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576130; x=1785180930; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5vrQuTcVEPlse/fTzTDhuMYNi8KtlAM6dYGGAEP65OU=;
        b=ZBHPJkMN/a254FdebdUu8f0zSnyptXo07QRl5xp5pZ1PZQS3zKoW1M3JRnaIi2dLsN
         55U5UQLNfh8J3pFHNbOuxYlL0LYfFZMT0EF5/ZJaS4ZL24K3XgpkLO0xbZWrxoU8x5/f
         zI6LQv299BD/dUeVZ5SzsnRyrnyH4mbynf6ckYYZ+TlCfF8dW2X6EdxLXTlc9EPjIxd1
         +sauBXm9JIdjwEgnRCnxQd4sDsYj0mvlEUxdxoa3ctzDdogqYTATtwubs2xHkOrGHiWI
         IglLeP+LS7cEj1lsFgfZUTFbfnK0mKHCz8jke3N5DZoYSni5tiiXE7G0B9D1q0PgRGvm
         Lp1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576130; x=1785180930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5vrQuTcVEPlse/fTzTDhuMYNi8KtlAM6dYGGAEP65OU=;
        b=OPNPhtoEzSVpzNjmPiWhxC1pRU92xBLcS6utbZC0iFfW+a/Mw7jj8Tn/ZsGCJeHcFn
         xwC9YuWnakEtXZ06GwidTLQlEPaMxbFCZPRsBj3DLBHRZhR+Xkaefgm6OAoOH5/C0269
         QCSRvFis+sgcdYPjxKnI9HULlBoUGDATAMzz1gDzlcO2DWepSdaMKHOFBcK1lYM1kewQ
         opjq4XSv7A+g75IgM8i6p5wSQHE7580YgYRQBqKSKWBpnwMaxV+xyvG9PSInIom0kPKw
         OdfnGBucfvW1Xfhcq/1QmZAmy/bMVgaP+1HLWx9wWIQbup0dwETBlc6wIH9j0TGdZtd0
         NLNg==
X-Forwarded-Encrypted: i=1; AHgh+Rpk+E4QA1wjm2tjX9N76rNgJ3GFLK2Sw0FZfGOrDJH0thya/jE7wz4ysxOH9PGNbJO1tljoczA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzgXrEV7cPRgl7QH75PTA+4x8IWC5IBeerpHHAj1qxnMmrGkuWs
	20F0mpZ/QEJDQbbU1voMS2Il60CMuqPSPa9eje/STVaECD9xMJ9pCuVy7Y+EItviHu0=
X-Gm-Gg: AfdE7cmQwTvk8BoPHZmLdy+YZpHHbJM5DFZnBh6NcDW1/XG03XC8O3uu4Th03m6U94U
	EYX40gCee5aPXeULTdlFLzofFnlnP1uxlkgdXC8eSpn8m5mto6TOh3V+jmrNrN699LzYfxS9j0S
	Abihni5haJrb/of2PrXe1YsNFKlYyAAUu9G/viKzpKCYV4kYqnlXH0EOWd0uL4nqjwxRLjjwxg6
	9j2r2q7SIddz6un/QJ18L6acwf8YHqDShNvxDkTWdRzj6trkHD9a+Y824GG60dnnK+QJtkmeDmg
	Il/PkEJDcxlYk5ZYT/TQTzEJTZQx66pi9AOJJtibkLZojN43GIsM/J4so1/2U+b/AQ4X8i4Xq86
	zhl9BtwB7EzpYH6yk47onSdmJ0eKrLqo0SjskQChCR19zM3XPBxpcLuh76T0QPeq0PSytLqOWLz
	8J15X6kD/qXv92RXLX84z9ocbiRr1cL8CoNNlSx0G9yQHuzehD4CZ56Ak+3xu6e58=
X-Received: by 2002:a05:620a:4606:b0:92e:c117:5ecb with SMTP id af79cd13be357-930b430a072mr1502942385a.75.1784576130602;
        Mon, 20 Jul 2026 12:35:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:30 -0700 (PDT)
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
Subject: [PATCH v5 20/36] mm/memcontrol: account private-node memory in per-node stats
Date: Mon, 20 Jul 2026 15:34:14 -0400
Message-ID: <20260720193431.3841992-21-gourry@gourry.net>
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

Private nodes folios are charged like any other - the node's per-cpu
lruvec counters are increment even for N_MEMORY_PRIVATE.

The memcg-level totals in memory.stat therefore include this memory,
but the per-node views do not:

  - mem_cgroup_css_rstat_flush() folds the per-node percpu deltas into the
    aggregate only for N_MEMORY nodes, so a private node's lruvec aggregate
    is never refreshed.

  - memory.numa_stat (v2) and the v1 numa_stat skip private nodes, so they
    never emit an Nx= field for one.

So memory.numa_stat does not sum to memory.stat once a cgroup has memory
on a private node.

Include N_MEMORY_PRIVATE in the flush/display process so private-node
memory is folded in and reported per node.

This is pure accounting of memory that already exists and is already
charged, so it is unconditional - regardless of future capabilities.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memcontrol-v1.c |  8 ++++++--
 mm/memcontrol.c    | 11 +++++++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 2dc599484d006..5e464e52dfb9a 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2132,14 +2132,18 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	const struct numa_stat *stat;
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+	nodemask_t reportable;
 
 	mem_cgroup_flush_stats(memcg);
 
+	/* Private nodes hold cgroup memory too, report them. */
+	nodes_or(reportable, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
+
 	for (stat = stats; stat < ARRAY_END(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
 						   false));
-		for_each_node_state(nid, N_MEMORY)
+		for_each_node_mask(nid, reportable)
 			seq_printf(m, " N%d=%lu", nid,
 				   mem_cgroup_node_nr_lru_pages(memcg, nid,
 							stat->lru_mask, false));
@@ -2151,7 +2155,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 		seq_printf(m, "hierarchical_%s=%lu", stat->name,
 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
 						   true));
-		for_each_node_state(nid, N_MEMORY)
+		for_each_node_mask(nid, reportable)
 			seq_printf(m, " N%d=%lu", nid,
 				   mem_cgroup_node_nr_lru_pages(memcg, nid,
 							stat->lru_mask, true));
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f0dde52dc9e0e..4d79e238bc57d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4496,6 +4496,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 	struct memcg_vmstats_percpu *statc;
 	struct aggregate_control ac;
+	nodemask_t reportable;
 	int nid;
 
 	flush_nmi_stats(memcg, parent);
@@ -4524,7 +4525,9 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 	};
 	mem_cgroup_stat_aggregate(&ac);
 
-	for_each_node_state(nid, N_MEMORY) {
+	/* Private nodes must also be accounted or numa_stat is misleading */
+	nodes_or(reportable, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
+	for_each_node_mask(nid, reportable) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
 		struct lruvec_stats *lstats = pn->lruvec_stats;
 		struct lruvec_stats *plstats = NULL;
@@ -4947,9 +4950,13 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 {
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+	nodemask_t reportable;
 
 	mem_cgroup_flush_stats(memcg);
 
+	/* Private nodes hold cgroup memory too, report them. */
+	nodes_or(reportable, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
+
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
 
@@ -4957,7 +4964,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 			continue;
 
 		seq_printf(m, "%s", memory_stats[i].name);
-		for_each_node_state(nid, N_MEMORY) {
+		for_each_node_mask(nid, reportable) {
 			u64 size;
 			struct lruvec *lruvec;
 
-- 
2.53.0-Meta

