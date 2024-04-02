Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A08DF43
	for <nvdimm@lists.linux.dev>; Tue,  2 Apr 2024 00:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712017067; cv=none; b=K+Rbixej292ig7Lix2mvOvHopEXEteA66Xd87hKKIQ5Rv9XFb5BRT5QHBQjqT74kNJvCAP1OPvKp8OHHMupS0bqcz4GZyfHpT36taXFRFPx1HBYLt0gwC1CbP+MJi0IW9T4O9PBea2uDzaGLX4Gx9brdSFAstXTaXXLWK/j6Cn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712017067; c=relaxed/simple;
	bh=iJW9SJHyneSYmEGyeWzEpCU4A7K7euTYpJk6Xq1gIfM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aNY2cKjm11LbkJllFQM9ne7axWAR4p48pCnoYQ/3/vbB6DonvrQFswxCyIqPHo2vLsMTKwoexGg8QeUMZsaie7VF9SFHGgcRypCZznRqeysWZQ4GThvbx23+9v+Xi72QFFX9TQG758NbM+CPGLH7cp2H7+QctioD+VqzokLd8oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=CIlXBpsB; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="CIlXBpsB"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4317fbb669dso20827911cf.1
        for <nvdimm@lists.linux.dev>; Mon, 01 Apr 2024 17:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1712017065; x=1712621865; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZYYFgVRrQCyHvtBEuYH7h6o9TH4NNMhZD/5GyRy63w=;
        b=CIlXBpsBJm5NXncV5IUbSpW+wNAACyt15Vv+pIX60hwMPe8k466AfIWL3kV4zVtmoO
         todDaHym4j+UAtFbUqjjuo4fBKzV8u/cXWh/S4xKV02gMgiLexJlqsxKcZBBf8TFC7RG
         el2dYGWVZC25KhcorGXh2w7L6IEz6hXiERHA6eTOVK90kkCYAqGkp0aeAWIp7GlONsug
         JFEeh99cFBsM3abxa2J2Rk5BXg9oZAnM2hN/Czblh2zfdRhYgkZbDfYCL+Vc0aUA5kgs
         5OQU9HXu/CbDVClkTTTPfM+yakFQhl0QAl66ml0JWRf+f2UiNkufWt39lUmMuQorVMwv
         aPyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712017065; x=1712621865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PZYYFgVRrQCyHvtBEuYH7h6o9TH4NNMhZD/5GyRy63w=;
        b=SIjEkdqA6LnMuMDffMh+zWHpRt8dd6P6/08h6kDfj0GsJR8RJEoqULme7RYsZJIqss
         dvlbb8WAey+9dVSJ9bV9FcyoBPeeTXZ85y1HFPE8y3xnh9Y/CFjzIK5zB2jMLTiGdxbq
         Br6ffs0D/L7WZXawWf35h+owynP8MO7TuwU1epeGQ7180yioKrEQ+noqZ13lNCl3DXZK
         YAMDOrsu9AwZOZnBDyrBtpHNKL+B7odOPQ+RZuN33A82L7Qv0Xk0aA8QPuHgNimk8F7W
         Qdt3maOrwL6yUPUEM/MlvqP0mvJue9RCoQyJozMPb0aul8jyaGG81+smdQRSi3zH9U3L
         +glQ==
X-Forwarded-Encrypted: i=1; AJvYcCWh//c/L51gSz7x+ENS3VoyPnqdVb/V84ShWTHCZfZSdVdt1I+QgTLeH5rV3MOcvO0pPidGaXXXgax0h59LDSvbkeumzXbV
X-Gm-Message-State: AOJu0YwZuSW879NBR4aYfCz8FnQ7wFoMgJF9qwguYEnpkiO8TgpdTI5V
	90iJENhXydI2KeVknv4/UQCW6LN5zuP8azv6Ev2HTqfOCAVJdDxJXm4KlvNlkf0=
X-Google-Smtp-Source: AGHT+IH0dKZtlTit1GSkvLXp6F0jF1c0z74lQPxxIbr4JWCWw37kSgbA6kdWs7YXSpceE6HdVzmoDA==
X-Received: by 2002:ad4:4c46:0:b0:699:184a:9315 with SMTP id cs6-20020ad44c46000000b00699184a9315mr358028qvb.62.1712017064933;
        Mon, 01 Apr 2024 17:17:44 -0700 (PDT)
Received: from n231-228-171.byted.org ([130.44.212.125])
        by smtp.gmail.com with ESMTPSA id e10-20020a0562141d0a00b00698f9771822sm3013112qvd.83.2024.04.01.17.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 17:17:44 -0700 (PDT)
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
	"SeongJae Park" <sj@kernel.org>,
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
Subject: [PATCH v10 2/2] memory tier: create CPUless memory tiers after obtaining HMAT info
Date: Tue,  2 Apr 2024 00:17:38 +0000
Message-Id: <20240402001739.2521623-3-horenchuang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240402001739.2521623-1-horenchuang@bytedance.com>
References: <20240402001739.2521623-1-horenchuang@bytedance.com>
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
 include/linux/memory-tiers.h |  5 +-
 mm/memory-tiers.c            | 95 +++++++++++++++++++++++++++++-------
 2 files changed, 81 insertions(+), 19 deletions(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index a44c03c2ba3a..16769552a338 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -140,12 +140,13 @@ static inline int mt_perf_to_adistance(struct access_coordinate *perf, int *adis
 	return -EIO;
 }
 
-struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *memory_types)
+static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
+					struct list_head *memory_types)
 {
 	return NULL;
 }
 
-void mt_put_memory_types(struct list_head *memory_types)
+static inline void mt_put_memory_types(struct list_head *memory_types)
 {
 
 }
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 974af10cfdd8..44fa10980d37 100644
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
@@ -745,9 +796,10 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist)
 		(default_dram_perf.read_latency + default_dram_perf.write_latency) *
 		(default_dram_perf.read_bandwidth + default_dram_perf.write_bandwidth) /
 		(perf->read_bandwidth + perf->write_bandwidth);
-	mutex_unlock(&memory_tier_lock);
 
-	return 0;
+out:
+	mutex_unlock(&default_dram_perf_lock);
+	return rc;
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

