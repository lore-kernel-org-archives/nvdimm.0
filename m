Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCCF2882D7
	for <nvdimm@lists.linux.dev>; Fri, 15 May 2026 01:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778809931; cv=none; b=N1kmvoixPPFFsXn8ImTIT9tsarVAq+qouP0o8SbK1sEwZaSATx6w4Iyc1EO9D2eYJYQ1TPsKMPnIBjxfBgXHptECWY4F1ou2rzqBR9hCI3aRKbY/BMID+5zN5R6QlcpOk+S3UY6uNqBw5bO6DZLDfgnFwUNRWVC/vyrV6aGe228=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778809931; c=relaxed/simple;
	bh=dp2kos4H2BqFgMzwZUwT4g0NTGwMeYmnIkdBYxk/alE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CqE/u+Jc9gFXENWJP6nn875RolY7/sMiwypmHfj7f1+5//bKfruiA9IV6TBO1uXu8SJcTqzx0DzKh1vqdpqwcE65rrD4WAuPjOGMiUylqYqi/1WPCSssJJEtfEZsHtX3STQYtNAJY65r8s3um06Np1JFsHNJzIxzjl8uuiDL0K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nKrLxQb5; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nKrLxQb5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778809930; x=1810345930;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dp2kos4H2BqFgMzwZUwT4g0NTGwMeYmnIkdBYxk/alE=;
  b=nKrLxQb5NtYlyCA7tgCi2DZx8B08e69DwCQL0i5MoVDRJs1XPX+9ft35
   7pMDbOtJhcea3+mgK+RCWemsljdCAGzfxQqCxcU3CsRe/oW7nSjbXeujI
   WJKDqi4qCvuVG+TlNuYEhedj6qbw9KoJTq49ZeRjHhGTIm30eLSX9RgPv
   k8+bjK93D6ikwWOKH+LZ9ZTV0vjh6VkocL7Cs3+rxg6oCxsroS170GE/7
   E3DICQEdMAbtdUe3j5BF9ZAiNP8Tx1ZG2evQRm4xExUkCr4Gmw5oo3Djs
   7/EDC9rh9krpa4rZJNzvaYdkUTeov5pKPdqLHOPZvvoX6YEKcZ4nBlm0J
   g==;
X-CSE-ConnectionGUID: bRQxMJSXSdeehpPeHPP1+A==
X-CSE-MsgGUID: 8ByGZivvSFGobq8AYeNmBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="82330758"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="82330758"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 18:52:09 -0700
X-CSE-ConnectionGUID: ZDY3yssRRaSPo7czWOnU+Q==
X-CSE-MsgGUID: 9PBahPqYSyqNDFZ0Tlh6Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="243530434"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.208])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 18:47:40 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH v5] nvdimm/btt: Handle preemption in BTT lane acquisition
Date: Thu, 14 May 2026 18:47:26 -0700
Message-ID: <20260515014729.107329-1-alison.schofield@intel.com>
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
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---


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

A new unit test to stress this is under review here:
https://lore.kernel.org/nvdimm/20260424233633.3762217-1-alison.schofield@intel.com/


 Documentation/driver-api/nvdimm/btt.rst |  4 +-
 drivers/nvdimm/nd.h                     |  7 ++-
 drivers/nvdimm/region_devs.c            | 64 ++++++++-----------------
 3 files changed, 25 insertions(+), 50 deletions(-)

diff --git a/Documentation/driver-api/nvdimm/btt.rst b/Documentation/driver-api/nvdimm/btt.rst
index 2d8269f834bd..e3218863ec96 100644
--- a/Documentation/driver-api/nvdimm/btt.rst
+++ b/Documentation/driver-api/nvdimm/btt.rst
@@ -162,8 +162,8 @@ process::
 
 A lane number is obtained at the start of any IO, and is used for indexing into
 all the on-disk and in-memory data structures for the duration of the IO. If
-there are more CPUs than the max number of available lanes, than lanes are
-protected by spinlocks.
+there are more CPUs than the max number of available lanes, then lanes are
+protected by mutexes.
 
 
 d. In-memory data structure: Read Tracking Table (RTT)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index b199eea3260e..263b7dde0f87 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -366,9 +366,8 @@ unsigned sizeof_namespace_label(struct nvdimm_drvdata *ndd);
 			res; res = next, next = next ? next->sibling : NULL)
 
 struct nd_percpu_lane {
-	int count;
-	spinlock_t lock;
-};
+	struct mutex lock; /* serialize lane access */
+} ____cacheline_aligned_in_smp;
 
 enum nd_label_flags {
 	ND_LABEL_REAP,
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
index e35c2e18518f..9f5a34181cf5 100644
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
@@ -904,52 +904,30 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
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
 
@@ -1019,17 +997,16 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
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
@@ -1046,7 +1023,6 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
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

