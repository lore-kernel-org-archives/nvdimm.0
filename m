Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF5C3BBFD
	for <nvdimm@lists.linux.dev>; Fri, 29 Mar 2024 05:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711690446; cv=none; b=Mjx06xAxWw9Ddr5Y6MCHpcLynfQTyk3720Lmo00LaI3AhWnr8ZpEtg1ssTx+DnYuEI2b3lJOojNYeZvtdjckxS+oBH8ncK8c4f1xc0bKIt5hpcrRvB8+Gd4+GKh6AQlZ0FOxdYg3uYQvVbENn7769xQ4iTr1uv+FPVxYepO9gTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711690446; c=relaxed/simple;
	bh=PaZ2AF3JeHPXJZBphflXd5DZx1k2kc8EgFP2kYGmJq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ads2FgOoO3tsW3f+VXlyfAsGmvT2ZUU8+V0z3Nu0DDP+br2bfG591IzvcJLUiY/XawluWerL7592u5KJADNI5I8lVL9UIFqSnM+V1xXx8+ww9qEdU4Kprkd6/8k2VYnZ2+UCo2H/5hkUxVCkfPUQyrgTNNtbr50nsipJhLEK7yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=U2r0XlO5; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="U2r0XlO5"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-42f52226f9bso6364211cf.3
        for <nvdimm@lists.linux.dev>; Thu, 28 Mar 2024 22:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1711690443; x=1712295243; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7gywZcWj8Uy1UfLQdLtf6937dGqAomoCBcBBPX1Jltg=;
        b=U2r0XlO52CQpHksNd+qL3EAJEExGiY3U048cMhouLscRRKVBkarEqcGLr+2PsScpsr
         lP/udqAUKov17Cko7I5ijy5ZpcyO1aRPWVCF7v1CYX7w1Vtdi962DsJ8eLQD0L3lJ1GP
         IKbg+nBvp0XoW1iG4CeQHgfBe+4G/pzHD9C12Kl1vZNkbeuMBRoAcElCUN9cLkyEq/9M
         GH8xPwA5Sr1VLnzHsKEpgk8K+7CTamgRcqrcA44E/ylWEgWZX/LDEMi5eWR6yoaCZ5dj
         Kywrbkb0dp/m8ZHTrAs0Vv2yVYDFW0JeZ3cKWh5C2qad3Kh9kJsozH7BmQzCEqzSKOY9
         xdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711690443; x=1712295243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7gywZcWj8Uy1UfLQdLtf6937dGqAomoCBcBBPX1Jltg=;
        b=JrF0qq9/1gdh7gQBEhShDa6eRWlvHdRymjkwA2i/ZCnYaTr/xBqLRuIozo4ZBIzQOo
         XJVdkOs9lJ+mWL3c3If0hKxfvI1nZvcunKCoA7JahRYywbyBd02SUJksB0IqbiRW+u7n
         7xqvYMCwtal4xO61qU9lSYgj8H0+9Pfr/9fvretN2PogTN2Qn1O1AkxUQmOry12A+Dyd
         Z0lHWy5pln4/uohdjSw90bcZkrOU+xR8BzKcjtQ9o7Q27d01pQqf3WRa7WrwxnWj7uh0
         2kHMHAR49H9QjJEEgRauxk83LRKVyhC6GVcTRPEfWjrgF0nHhWLe3ZBzs/cEO9wqNPAv
         WagA==
X-Forwarded-Encrypted: i=1; AJvYcCWChf4kMax2RLUnMsMpXtHjScQomZYnk/rGjVY9NO7eIBYFmM/sJVhCQ6hc/ZDf0au9ZHMmDWrs7NfDb37wTj9eZ4ba+n5M
X-Gm-Message-State: AOJu0YyViYNnU/w5Qyn1mdGbxjhUhs3JC4FYD65hMvQuwikJ3ZlZEecE
	TE6Y1Kc/YpvCiWARnQ5eAXnWS+P4cQMOrZjNf8bnyyW8ZOEP2zTODNaavNy5ZTo=
X-Google-Smtp-Source: AGHT+IHMKi8jQpAaT6v24K2SIK8/4KC+bbaOA6pAb143bozl04FLNTZDjzodC6fB+ReD22deVOL3iA==
X-Received: by 2002:a05:622a:5e89:b0:432:c1b3:7985 with SMTP id er9-20020a05622a5e8900b00432c1b37985mr849659qtb.55.1711690442938;
        Thu, 28 Mar 2024 22:34:02 -0700 (PDT)
Received: from n231-228-171.byted.org ([147.160.184.85])
        by smtp.gmail.com with ESMTPSA id jd25-20020a05622a719900b00430bf59ebccsm1293700qtb.11.2024.03.28.22.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 22:34:02 -0700 (PDT)
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
To: "Huang, Ying" <ying.huang@intel.com>,
	"Gregory Price" <gourry.memverge@gmail.com>,
	aneesh.kumar@linux.ibm.com,
	mhocko@suse.com,
	tj@kernel.org,
	john@jagalactic.com,
	"Eishan Mirakhur" <emirakhur@micron.com>,
	"Vinicius Tavares Petrucci" <vtavarespetr@micron.com>,
	"Ravis OpenSrc" <Ravis.OpenSrc@micron.com>,
	"Alistair Popple" <apopple@nvidia.com>,
	"Srinivasulu Thanneeru" <sthanneeru@micron.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: "Ho-Ren (Jack) Chuang" <horenc@vt.edu>,
	"Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>,
	"Ho-Ren (Jack) Chuang" <horenchuang@gmail.com>,
	qemu-devel@nongnu.org,
	Hao Xiang <hao.xiang@bytedance.com>
Subject: [PATCH v9 2/2] memory tier: create CPUless memory tiers after obtaining HMAT info
Date: Fri, 29 Mar 2024 05:33:53 +0000
Message-Id: <20240329053353.309557-3-horenchuang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240329053353.309557-1-horenchuang@bytedance.com>
References: <20240329053353.309557-1-horenchuang@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current implementation treats emulated memory devices, such as
CXL1.1 type3 memory, as normal DRAM when they are emulated as normal memory
(E820_TYPE_RAM). However, these emulated devices have different
characteristics than traditional DRAM, making it important to
distinguish them. Thus, we modify the tiered memory initialization process
to introduce a delay specifically for CPUless NUMA nodes. This delay
ensures that the memory tier initialization for these nodes is deferred
until HMAT information is obtained during the boot process. Finally,
demotion tables are recalculated at the end.

* late_initcall(memory_tier_late_init);
Some device drivers may have initialized memory tiers between
`memory_tier_init()` and `memory_tier_late_init()`, potentially bringing
online memory nodes and configuring memory tiers. They should be excluded
in the late init.

* Handle cases where there is no HMAT when creating memory tiers
There is a scenario where a CPUless node does not provide HMAT information.
If no HMAT is specified, it falls back to using the default DRAM tier.

* Introduce another new lock `default_dram_perf_lock` for adist calculation
In the current implementation, iterating through CPUlist nodes requires
holding the `memory_tier_lock`. However, `mt_calc_adistance()` will end up
trying to acquire the same lock, leading to a potential deadlock.
Therefore, we propose introducing a standalone `default_dram_perf_lock` to
protect `default_dram_perf_*`. This approach not only avoids deadlock
but also prevents holding a large lock simultaneously.

* Upgrade `set_node_memory_tier` to support additional cases, including
  default DRAM, late CPUless, and hot-plugged initializations.
To cover hot-plugged memory nodes, `mt_calc_adistance()` and
`mt_find_alloc_memory_type()` are moved into `set_node_memory_tier()` to
handle cases where memtype is not initialized and where HMAT information is
available.

* Introduce `default_memory_types` for those memory types that are not
  initialized by device drivers.
Because late initialized memory and default DRAM memory need to be managed,
a default memory type is created for storing all memory types that are
not initialized by device drivers and as a fallback.

Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
Signed-off-by: Hao Xiang <hao.xiang@bytedance.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
---
 mm/memory-tiers.c | 93 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 77 insertions(+), 16 deletions(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 974af10cfdd8..9f8ae99e8e6e 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -36,6 +36,11 @@ struct node_memory_type_map {
 
 static DEFINE_MUTEX(memory_tier_lock);
 static LIST_HEAD(memory_tiers);
+/*
+ * The list is used to store all memory types that are not created
+ * by a device driver.
+ */
+static LIST_HEAD(default_memory_types);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 struct memory_dev_type *default_dram_type;
 
@@ -108,6 +113,8 @@ static struct demotion_nodes *node_demotion __read_mostly;
 
 static BLOCKING_NOTIFIER_HEAD(mt_adistance_algorithms);
 
+/* The lock is used to protect `default_dram_perf*` info and nid. */
+static DEFINE_MUTEX(default_dram_perf_lock);
 static bool default_dram_perf_error;
 static struct access_coordinate default_dram_perf;
 static int default_dram_perf_ref_nid = NUMA_NO_NODE;
@@ -505,7 +512,8 @@ static inline void __init_node_memory_type(int node, struct memory_dev_type *mem
 static struct memory_tier *set_node_memory_tier(int node)
 {
 	struct memory_tier *memtier;
-	struct memory_dev_type *memtype;
+	struct memory_dev_type *mtype = default_dram_type;
+	int adist = MEMTIER_ADISTANCE_DRAM;
 	pg_data_t *pgdat = NODE_DATA(node);
 
 
@@ -514,11 +522,20 @@ static struct memory_tier *set_node_memory_tier(int node)
 	if (!node_state(node, N_MEMORY))
 		return ERR_PTR(-EINVAL);
 
-	__init_node_memory_type(node, default_dram_type);
+	mt_calc_adistance(node, &adist);
+	if (node_memory_types[node].memtype == NULL) {
+		mtype = mt_find_alloc_memory_type(adist, &default_memory_types);
+		if (IS_ERR(mtype)) {
+			mtype = default_dram_type;
+			pr_info("Failed to allocate a memory type. Fall back.\n");
+		}
+	}
+
+	__init_node_memory_type(node, mtype);
 
-	memtype = node_memory_types[node].memtype;
-	node_set(node, memtype->nodes);
-	memtier = find_create_memory_tier(memtype);
+	mtype = node_memory_types[node].memtype;
+	node_set(node, mtype->nodes);
+	memtier = find_create_memory_tier(mtype);
 	if (!IS_ERR(memtier))
 		rcu_assign_pointer(pgdat->memtier, memtier);
 	return memtier;
@@ -655,6 +672,33 @@ void mt_put_memory_types(struct list_head *memory_types)
 }
 EXPORT_SYMBOL_GPL(mt_put_memory_types);
 
+/*
+ * This is invoked via `late_initcall()` to initialize memory tiers for
+ * CPU-less memory nodes after driver initialization, which is
+ * expected to provide `adistance` algorithms.
+ */
+static int __init memory_tier_late_init(void)
+{
+	int nid;
+
+	mutex_lock(&memory_tier_lock);
+	for_each_node_state(nid, N_MEMORY)
+		if (node_memory_types[nid].memtype == NULL)
+			/*
+			 * Some device drivers may have initialized memory tiers
+			 * between `memory_tier_init()` and `memory_tier_late_init()`,
+			 * potentially bringing online memory nodes and
+			 * configuring memory tiers. Exclude them here.
+			 */
+			set_node_memory_tier(nid);
+
+	establish_demotion_targets();
+	mutex_unlock(&memory_tier_lock);
+
+	return 0;
+}
+late_initcall(memory_tier_late_init);
+
 static void dump_hmem_attrs(struct access_coordinate *coord, const char *prefix)
 {
 	pr_info(
@@ -668,7 +712,7 @@ int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 {
 	int rc = 0;
 
-	mutex_lock(&memory_tier_lock);
+	mutex_lock(&default_dram_perf_lock);
 	if (default_dram_perf_error) {
 		rc = -EIO;
 		goto out;
@@ -716,23 +760,30 @@ int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 	}
 
 out:
-	mutex_unlock(&memory_tier_lock);
+	mutex_unlock(&default_dram_perf_lock);
 	return rc;
 }
 
 int mt_perf_to_adistance(struct access_coordinate *perf, int *adist)
 {
-	if (default_dram_perf_error)
-		return -EIO;
+	int rc = 0;
 
-	if (default_dram_perf_ref_nid == NUMA_NO_NODE)
-		return -ENOENT;
+	mutex_lock(&default_dram_perf_lock);
+	if (default_dram_perf_error) {
+		rc = -EIO;
+		goto out;
+	}
 
 	if (perf->read_latency + perf->write_latency == 0 ||
-	    perf->read_bandwidth + perf->write_bandwidth == 0)
-		return -EINVAL;
+	    perf->read_bandwidth + perf->write_bandwidth == 0) {
+		rc = -EINVAL;
+		goto out;
+	}
 
-	mutex_lock(&memory_tier_lock);
+	if (default_dram_perf_ref_nid == NUMA_NO_NODE) {
+		rc = -ENOENT;
+		goto out;
+	}
 	/*
 	 * The abstract distance of a memory node is in direct proportion to
 	 * its memory latency (read + write) and inversely proportional to its
@@ -745,8 +796,9 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist)
 		(default_dram_perf.read_latency + default_dram_perf.write_latency) *
 		(default_dram_perf.read_bandwidth + default_dram_perf.write_bandwidth) /
 		(perf->read_bandwidth + perf->write_bandwidth);
-	mutex_unlock(&memory_tier_lock);
 
+out:
+	mutex_unlock(&default_dram_perf_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt_perf_to_adistance);
@@ -858,7 +910,8 @@ static int __init memory_tier_init(void)
 	 * For now we can have 4 faster memory tiers with smaller adistance
 	 * than default DRAM tier.
 	 */
-	default_dram_type = alloc_memory_type(MEMTIER_ADISTANCE_DRAM);
+	default_dram_type = mt_find_alloc_memory_type(MEMTIER_ADISTANCE_DRAM,
+									&default_memory_types);
 	if (IS_ERR(default_dram_type))
 		panic("%s() failed to allocate default DRAM tier\n", __func__);
 
@@ -868,6 +921,14 @@ static int __init memory_tier_init(void)
 	 * types assigned.
 	 */
 	for_each_node_state(node, N_MEMORY) {
+		if (!node_state(node, N_CPU))
+			/*
+			 * Defer memory tier initialization on CPUless numa nodes.
+			 * These will be initialized after firmware and devices are
+			 * initialized.
+			 */
+			continue;
+
 		memtier = set_node_memory_tier(node);
 		if (IS_ERR(memtier))
 			/*
-- 
Ho-Ren (Jack) Chuang

