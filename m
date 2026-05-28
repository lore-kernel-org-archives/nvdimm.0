Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844762DF6E6
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 02:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779934593; cv=none; b=XDesakVLOpQE/QHkZrENRjv+40mMVMPLnRyn4ip77M7OutdGBV/ctPGLnwLZUFiy4tr/rZ5EhF3h2PzAG2eJXSnhvIlMpo3Imqhhm+cQupeFgixR3O04G/0O7CXXtfBHBpBSZCTdwyQLC1qJ17PxXRA34BDK4Eueim9kcieSFv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779934593; c=relaxed/simple;
	bh=MaYss3l04Y2vm5VU19xpUhh9ybEZGTSuRnJyHDR5nPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bk9tsBhFadB3lSO81UsEAVwBOcSN3c0R4opHhw7/S30gxS6f51K6dPylvgG1NEkp1z0l1MDrUGIemTxeUkafI+BDryzTSQoxCS4hRYDQtGwBfoPNm8uB1DOhKxKIst8Z66rGEfBRoH3lKoxdfXZ/vpX1JGeAincN5vFJP1Fpnuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DH5f+iUm; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DH5f+iUm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779934591; x=1811470591;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MaYss3l04Y2vm5VU19xpUhh9ybEZGTSuRnJyHDR5nPc=;
  b=DH5f+iUmrMvIROeW5tUiWtg5xWwEH/k6U3N0Wd3IeYBiI43qDQQFks28
   2wo1s/HbKRIXvZNKmrqEvMP3U5SRahjiF8Uza0fswb1sBUTXccAkDaS1x
   Jhdww16mXQLMjUErE34ghl0V4+bGnO9p3VUM0kO1mDdFA58FjO+xqUFMt
   qIC7BvoFFKNoYwXX+Nzh0+ReD7SOctQmM3Hn00xMHwffDPnCaP4AIA9z3
   hBs1VEfJdxuYAHg+q5fEiwn5hmcSTThvDLlRKdJjWl8tJCb50m7ZljkE0
   mLzBMsNv4jtAetFSqzjgYaAdxVCTN7VSAaArIwv3WBY/q8PQ4o5Woqvdu
   Q==;
X-CSE-ConnectionGUID: FuiFdFa6Q+a4sCLV8FlokQ==
X-CSE-MsgGUID: 2dT/eY58TSSYLoufpAIOZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="103448151"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="103448151"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 19:16:30 -0700
X-CSE-ConnectionGUID: kK36h3bFTXqOg8NhYXAxFQ==
X-CSE-MsgGUID: pxjNYUQzR+SkZPw5Qh5suw==
X-ExtLoop1: 1
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.163])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 19:16:29 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH v6] nvdimm/btt: Handle preemption in BTT lane acquisition
Date: Wed, 27 May 2026 19:16:22 -0700
Message-ID: <20260528021625.618462-1-alison.schofield@intel.com>
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

BTT lanes are also held across arena_write_bytes() calls. That path
reaches nsio_rw_bytes(), which flushes writes with nvdimm_flush().
Some provider flush callbacks can sleep, making a spinlock the wrong
primitive for the lane lifetime.

Replace the spinlock-based recursion model with a dynamically
allocated per-lane mutex array and take the lane lock
unconditionally.

Add might_sleep() to catch any future atomic-context caller.

Found with the ndctl unit test btt-check.sh.

Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
Assisted-by: Claude Sonnet 4.5
Tested-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

A new unit test to stress this is under review here:
https://lore.kernel.org/nvdimm/20260424233633.3762217-1-alison.schofield@intel.com/

Changes in v6:
- Add mutex_destroy() to match dynamic allocation (Aboorva)
- btt.rst drop the stale 'if more CPUs than lanes qualifier (Vishal)
- Rename struct nd_percpu_lane to struct nd_lane (Vishal)
- Drop the stale __percpu annotation on nd_region->lane (Vishal)
- Move struct nd_lane definition to avoid a checkpatch false positive

Changes in v5:
- Align lane mutex entries to cachelines in SMP builds (Sashiko AI)
- Add sparse lock annotations for lane mutexes (DaveJ)
- s/spinlock/mutexes in the driver-api doc btt.rst

Changes in v4:
- Replace per-CPU lane storage w dynamically allocated mutex array (Sashiko AI)
- Remove the recursion fast path and take the lane lock unconditionally
- Update commit log

Changes in v3:
Replace spinlock with a per-lane mutex (Arboorva)

Changes in v2:
Use spin_(un)lock_bh() (Sashiko AI)
Update commit log per softirq re-enty and spinlock change


 Documentation/driver-api/nvdimm/btt.rst |  5 +-
 drivers/nvdimm/nd.h                     | 11 ++---
 drivers/nvdimm/region_devs.c            | 66 +++++++++----------------
 3 files changed, 29 insertions(+), 53 deletions(-)

diff --git a/Documentation/driver-api/nvdimm/btt.rst b/Documentation/driver-api/nvdimm/btt.rst
index 2d8269f834bd..d29fab95f149 100644
--- a/Documentation/driver-api/nvdimm/btt.rst
+++ b/Documentation/driver-api/nvdimm/btt.rst
@@ -161,9 +161,8 @@ process::
 	nlanes = min(nfree, num_cpus)
 
 A lane number is obtained at the start of any IO, and is used for indexing into
-all the on-disk and in-memory data structures for the duration of the IO. If
-there are more CPUs than the max number of available lanes, than lanes are
-protected by spinlocks.
+all the on-disk and in-memory data structures for the duration of the IO. Lanes
+are protected by mutexes.
 
 
 d. In-memory data structure: Read Tracking Table (RTT)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index b199eea3260e..197e5368c0a4 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -365,11 +365,6 @@ unsigned sizeof_namespace_label(struct nvdimm_drvdata *ndd);
 	for (res = (ndd)->dpa.child, next = res ? res->sibling : NULL; \
 			res; res = next, next = next ? next->sibling : NULL)
 
-struct nd_percpu_lane {
-	int count;
-	spinlock_t lock;
-};
-
 enum nd_label_flags {
 	ND_LABEL_REAP,
 };
@@ -400,6 +395,10 @@ struct nd_mapping {
 	struct nvdimm_drvdata *ndd;
 };
 
+struct nd_lane {
+	struct mutex lock; /* serialize lane access */
+} ____cacheline_aligned_in_smp;
+
 struct nd_region {
 	struct device dev;
 	struct ida ns_ida;
@@ -420,7 +419,7 @@ struct nd_region {
 	struct kernfs_node *bb_state;
 	struct badblocks bb;
 	struct nd_interleave_set *nd_set;
-	struct nd_percpu_lane __percpu *lane;
+	struct nd_lane *lane;
 	int (*flush)(struct nd_region *nd_region, struct bio *bio);
 	struct nd_mapping mapping[] __counted_by(ndr_mappings);
 };
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e35c2e18518f..5e079d61cbaa 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -192,7 +192,9 @@ static void nd_region_release(struct device *dev)
 
 		put_device(&nvdimm->dev);
 	}
-	free_percpu(nd_region->lane);
+	for (i = 0; i < nd_region->num_lanes; i++)
+		mutex_destroy(&nd_region->lane[i].lock);
+	kfree(nd_region->lane);
 	if (!test_bit(ND_REGION_CXL, &nd_region->flags))
 		memregion_free(nd_region->id);
 	kfree(nd_region);
@@ -904,52 +906,30 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
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
+	__acquires(&nd_region->lane[lane].lock)
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
+	__releases(&nd_region->lane[lane].lock)
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
 
@@ -1019,17 +999,16 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
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
@@ -1046,7 +1025,6 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
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

