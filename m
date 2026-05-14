Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1D738BF72
	for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 20:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778789882; cv=none; b=fvP2Cs7akVmn/KAh93ya6V+W0Vo84dgHXAFendFeX6saGdiUUZVwXlJ1qoPHdRSIQJDWTCOqsiHrfGVj8yC+xyqhMa44RqRHzT4Y4iE1BgHrVPoHSwXXsb9A0Dss2wfxEP7YlwCbC9pxWNqq4RahYPDWdxuNQh3bBYBsSYNAB5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778789882; c=relaxed/simple;
	bh=mqxS4uzCLMWJy5MswjxhazOQu1b0vDdvq8+9qBAL5Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CgWvJHbv0hKjTzDP6rLKEe/aVqUZcWwtuGXFXL03knN4FH4tNLwOO2kKzA+O66zHO5UrNN5GIeeWGlxG8lXviPPXrHzyN0ua2NQErpqcGsK9dx48DlEPOztEes0BM3J3YaE7ItMcXEKg3BPhouYGJOj6Wi8agGuo0RevQF6Z0bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lcbk02GE; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lcbk02GE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778789880; x=1810325880;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mqxS4uzCLMWJy5MswjxhazOQu1b0vDdvq8+9qBAL5Ec=;
  b=lcbk02GEk6rIYP/TP8mZKhSbnU/egYHMv738GVFYjOtKrUraFZSAj/cS
   Az1XLcQ3H32J2icYeaveWoSHg6O2TMiVD9RpUODPeJsoeJhaBr60HnJCM
   /wMT8LAs2cX38bZS7c5l5Z68zDarYIKAoKBDUA8vyVKqpNXjtpCXMKIXU
   oOApNsh+p1SnoMwt6wR/HNgdR+nnH7HYAhmOZKQirLQlx4Y2ASHSkQAQh
   EfURqJWqoQPETklKF8AGYkDxezGyo65rY0pUPrV9NhfSKLJTu0729ghny
   l5Cz5uS1htQ2mJHn3OskzIuiXKloVych6VOsHUfyjf77ALOXevGCzlaqA
   g==;
X-CSE-ConnectionGUID: cqQB4XYQQHeqT52yEB9M8A==
X-CSE-MsgGUID: /It2ylcYTQekeQD8Piovng==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="90844083"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="90844083"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 13:18:00 -0700
X-CSE-ConnectionGUID: 1Do76wHzQemgLH6bT3epwg==
X-CSE-MsgGUID: drNez0tfSwS3OaTO30yhPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="242485584"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.208])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 13:18:00 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <djbw@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH v4] nvdimm/btt: Handle preemption in BTT lane acquisition
Date: Thu, 14 May 2026 13:17:54 -0700
Message-ID: <20260514201757.86486-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BTT lanes serialize access to per-lane metadata and workspace state
during BTT I/O. The btt-check unit test reports data mismatches during
BTT writes due to a race in lane acquisition that can lead to silent
data corruption.

The existing lane model uses a spinlock together with a per-CPU
recursion count. That recursion model stopped being valid after BTT
lanes became preemptible: another task can run on the same CPU,
observe a non-zero recursion count, bypass locking, and use the same
lane concurrently.

BTT lanes are also held across metadata and data updates that can
reach nvdimm_flush(). Some provider flush callbacks can sleep, making
a spinlock the wrong primitive for the lane lifetime. That issue
predates this fix, but becomes more visible now that BTT lanes are
preemptible.

Replace the spinlock-based recursion model with a dynamically
allocated per-lane mutex array and take the lane lock unconditionally.

Add might_sleep() to catch any future atomic-context caller.

Found with the ndctl unit test btt-check.sh.

Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
Assisted-by: Claude Sonnet 4.5
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---


Changes in v4:
- Replace per-CPU lane storage w dynamically allocated mutex array (Sashiko)
- Remove the recursion fast path and take the lane lock unconditionally
- Update commit log

Changes in v3:
Replace spinlock with a per-lane mutex (Arboorva)

Changes in v2:
Use spin_(un)lock_bh() (Sashiko AI)
Update commit log per softirq re-enty and spinlock change

A new unit test to stress this is under review here:
https://lore.kernel.org/nvdimm/20260424233633.3762217-1-alison.schofield@intel.com/


 drivers/nvdimm/nd.h          |  5 ++-
 drivers/nvdimm/region_devs.c | 62 +++++++++++-------------------------
 2 files changed, 20 insertions(+), 47 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index b199eea3260e..69f329075527 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -366,8 +366,7 @@ unsigned sizeof_namespace_label(struct nvdimm_drvdata *ndd);
 			res; res = next, next = next ? next->sibling : NULL)
 
 struct nd_percpu_lane {
-	int count;
-	spinlock_t lock;
+	struct mutex lock; /* serialize lane access */
 };
 
 enum nd_label_flags {
@@ -420,7 +419,7 @@ struct nd_region {
 	struct kernfs_node *bb_state;
 	struct badblocks bb;
 	struct nd_interleave_set *nd_set;
-	struct nd_percpu_lane __percpu *lane;
+	struct nd_percpu_lane *lane;
 	int (*flush)(struct nd_region *nd_region, struct bio *bio);
 	struct nd_mapping mapping[] __counted_by(ndr_mappings);
 };
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e35c2e18518f..bc5e402bbd9a 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -192,7 +192,7 @@ static void nd_region_release(struct device *dev)
 
 		put_device(&nvdimm->dev);
 	}
-	free_percpu(nd_region->lane);
+	kfree(nd_region->lane);
 	if (!test_bit(ND_REGION_CXL, &nd_region->flags))
 		memregion_free(nd_region->id);
 	kfree(nd_region);
@@ -904,52 +904,28 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
  * nd_region_acquire_lane - allocate and lock a lane
  * @nd_region: region id and number of lanes possible
  *
- * A lane correlates to a BLK-data-window and/or a log slot in the BTT.
- * We optimize for the common case where there are 256 lanes, one
- * per-cpu.  For larger systems we need to lock to share lanes.  For now
- * this implementation assumes the cost of maintaining an allocator for
- * free lanes is on the order of the lock hold time, so it implements a
- * static lane = cpu % num_lanes mapping.
+ * A lane correlates to a log slot in the BTT. Lanes are shared across
+ * CPUs using a static lane = cpu % num_lanes mapping, with a per-lane
+ * mutex to serialize access.
  *
- * In the case of a BTT instance on top of a BLK namespace a lane may be
- * acquired recursively.  We lock on the first instance.
- *
- * In the case of a BTT instance on top of PMEM, we only acquire a lane
- * for the BTT metadata updates.
+ * Callers must be in sleepable context. The only in-tree caller is
+ * BTT's ->submit_bio handler (btt_read_pg / btt_write_pg).
  */
 unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
 {
-	unsigned int cpu, lane;
+	unsigned int lane;
 
-	migrate_disable();
-	cpu = smp_processor_id();
-	if (nd_region->num_lanes < nr_cpu_ids) {
-		struct nd_percpu_lane *ndl_lock, *ndl_count;
-
-		lane = cpu % nd_region->num_lanes;
-		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
-		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
-		if (ndl_count->count++ == 0)
-			spin_lock(&ndl_lock->lock);
-	} else
-		lane = cpu;
+	might_sleep();
 
+	lane = raw_smp_processor_id() % nd_region->num_lanes;
+	mutex_lock(&nd_region->lane[lane].lock);
 	return lane;
 }
 EXPORT_SYMBOL(nd_region_acquire_lane);
 
 void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
 {
-	if (nd_region->num_lanes < nr_cpu_ids) {
-		unsigned int cpu = smp_processor_id();
-		struct nd_percpu_lane *ndl_lock, *ndl_count;
-
-		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
-		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
-		if (--ndl_count->count == 0)
-			spin_unlock(&ndl_lock->lock);
-	}
-	migrate_enable();
+	mutex_unlock(&nd_region->lane[lane].lock);
 }
 EXPORT_SYMBOL(nd_region_release_lane);
 
@@ -1019,17 +995,16 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 			goto err_id;
 	}
 
-	nd_region->lane = alloc_percpu(struct nd_percpu_lane);
+	nd_region->num_lanes = ndr_desc->num_lanes;
+	if (!nd_region->num_lanes)
+		goto err_percpu;
+	nd_region->lane = kcalloc(nd_region->num_lanes,
+				  sizeof(*nd_region->lane), GFP_KERNEL);
 	if (!nd_region->lane)
 		goto err_percpu;
 
-        for (i = 0; i < nr_cpu_ids; i++) {
-		struct nd_percpu_lane *ndl;
-
-		ndl = per_cpu_ptr(nd_region->lane, i);
-		spin_lock_init(&ndl->lock);
-		ndl->count = 0;
-	}
+	for (i = 0; i < nd_region->num_lanes; i++)
+		mutex_init(&nd_region->lane[i].lock);
 
 	for (i = 0; i < ndr_desc->num_mappings; i++) {
 		struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
@@ -1046,7 +1021,6 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	}
 	nd_region->provider_data = ndr_desc->provider_data;
 	nd_region->nd_set = ndr_desc->nd_set;
-	nd_region->num_lanes = ndr_desc->num_lanes;
 	nd_region->flags = ndr_desc->flags;
 	nd_region->ro = ro;
 	nd_region->numa_node = ndr_desc->numa_node;

base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.37.3

