Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8386230100E
	for <nvdimm@lists.linux.dev>; Thu, 30 Apr 2026 02:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777517224; cv=none; b=P4pcumN+NGpbNQH5SbnRqOmF2FxXRPIfYOu4Yed5bYGwvVwZjEJkJEPc2PuY659Kgab5LqzU9FIwY8ViB5cmL9glzns6LajIMJEYlBwRmwWvCxMtv9Bi7KjarilAaldNQ0SxyU7hxPbNrMur5NSp9yhE/ZMN6FQU4Pepdk6A8kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777517224; c=relaxed/simple;
	bh=KMuJ775i2IvXsA3eGKUTifx8KzctA5qOIkepgc9fvp0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YmTRBErSngLG9gWXxd36UF1fOoc+n8/aplKydTvMiDAgNilav1eAfOv+kl5DyfmR2oiBRg/cbohWeVbgQSCggkJWzWjV7OiZM9T4G+rOIWqV2ICSpT/hdKXoGL1+oTIZxl935R9hUQeGYKDN8GyS+TB9Q8l2ZZQeYTrF5VZRJzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IcDSgH82; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IcDSgH82"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777517223; x=1809053223;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KMuJ775i2IvXsA3eGKUTifx8KzctA5qOIkepgc9fvp0=;
  b=IcDSgH82VpO3uJ+nvdHZrLaj1ajbQBnqSSkitT8Py5HI7YPd4wyLZOJ+
   jUfVF75d1ffbHBr1+Xh3GNKnQn8XK7sIKL4fKckBI62eNsZkClFX5Q39u
   pdpyJfu+TpquD4S+EYDbIRpYxPxsNPUFamaz0Nok6F8LKrkWVejORSpxE
   LfSdt2AeT75V1y8ntFZCPPlRaYaI94UrfGH7MGfUQixovp+BP56/djE/n
   hEFyiVc3/lXHuPN35LSGHo5G33Inm01qqVx/jateXm4B2yI5ygHJVTqZ5
   YfCQ4xzeK6Xfd1gcQhA4u7D9ZZZSwDTPcYZ1VL5RVsWXpLwqZ8Git0wLq
   Q==;
X-CSE-ConnectionGUID: 6cidd/30RymiQIz0zDW61w==
X-CSE-MsgGUID: xOzcAMPuQ5aUFWgkEGE1qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89553164"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="89553164"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 19:47:02 -0700
X-CSE-ConnectionGUID: /WtTsGYHSSq79sCD/0qmXA==
X-CSE-MsgGUID: eLZ4lQdJQYqZaNKLzKcytw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="239470457"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.255])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 19:47:02 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH v2] nvdimm/btt: Handle preemption in BTT lane acquisition
Date: Wed, 29 Apr 2026 19:46:51 -0700
Message-ID: <20260430024652.3920875-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BTT (Block Translation Table) makes persistent memory safe for block
I/O by guaranteeing atomic sector updates. It uses reserved lanes
for in-flight BTT operations, which must be used exclusively.

The btt-check unit test reports data mismatches during BTT I/O due
to a race in lane acquisition, leading to silent data corruption.

BTT lane acquisition uses per-CPU recursion tracking with
migrate_disable(). However, migrate_disable() does not prevent
preemption, so another task can run on the same CPU and share the
recursion state. That task can observe a non-zero recursion count,
bypass locking, and use the same lane at the same time.

Track lane ownership per task and only allow lockless recursion for
the owning task. Otherwise, serialize access with the lane spinlock.
Use spin_(un)lock_bh() so softirq re-entry on the same CPU cannot
bypass ownership checks or deadlock on the lane lock.

Found with the NDCTL unit test btt-check.sh

Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
Assisted-by: Claude Sonnet 4.5
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Changes in v2:
Use spin_(un)lock_bh() (Sashiko AI)
Update commit log per softirq re-enty and spinlock change

A new unit test to stress this is under review here:
https://lore.kernel.org/nvdimm/20260424233633.3762217-1-alison.schofield@intel.com/


 drivers/nvdimm/nd.h          |  1 +
 drivers/nvdimm/region_devs.c | 48 +++++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index b199eea3260e..424c38ca4960 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -368,6 +368,7 @@ unsigned sizeof_namespace_label(struct nvdimm_drvdata *ndd);
 struct nd_percpu_lane {
 	int count;
 	spinlock_t lock;
+	struct task_struct *owner;
 };
 
 enum nd_label_flags {
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e35c2e18518f..f1c6dcd95b5a 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -905,11 +905,10 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
  * @nd_region: region id and number of lanes possible
  *
  * A lane correlates to a BLK-data-window and/or a log slot in the BTT.
- * We optimize for the common case where there are 256 lanes, one
- * per-cpu.  For larger systems we need to lock to share lanes.  For now
- * this implementation assumes the cost of maintaining an allocator for
- * free lanes is on the order of the lock hold time, so it implements a
- * static lane = cpu % num_lanes mapping.
+ * Lanes are shared across CPUs using a static lane = cpu % num_lanes
+ * mapping, with a per-lane spinlock to serialize access when multiple
+ * tasks share a lane (including when preemption causes multiple tasks
+ * to run on the same CPU).
  *
  * In the case of a BTT instance on top of a BLK namespace a lane may be
  * acquired recursively.  We lock on the first instance.
@@ -920,35 +919,44 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
 unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
 {
 	unsigned int cpu, lane;
+	struct nd_percpu_lane *ndl;
 
 	migrate_disable();
 	cpu = smp_processor_id();
-	if (nd_region->num_lanes < nr_cpu_ids) {
-		struct nd_percpu_lane *ndl_lock, *ndl_count;
-
+	if (nd_region->num_lanes < nr_cpu_ids)
 		lane = cpu % nd_region->num_lanes;
-		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
-		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
-		if (ndl_count->count++ == 0)
-			spin_lock(&ndl_lock->lock);
-	} else
+	else
 		lane = cpu;
 
+	/*
+	 * migrate_disable() keeps the lane stable, but does not prevent
+	 * preemption. Only the owning task may recurse without taking the
+	 * lock.
+	 */
+	ndl = per_cpu_ptr(nd_region->lane, lane);
+	if (READ_ONCE(ndl->owner) != current) {
+		spin_lock_bh(&ndl->lock);
+		WRITE_ONCE(ndl->owner, current);
+	}
+	ndl->count++;
+
 	return lane;
 }
 EXPORT_SYMBOL(nd_region_acquire_lane);
 
 void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
 {
-	if (nd_region->num_lanes < nr_cpu_ids) {
-		unsigned int cpu = smp_processor_id();
-		struct nd_percpu_lane *ndl_lock, *ndl_count;
+	struct nd_percpu_lane *ndl = per_cpu_ptr(nd_region->lane, lane);
 
-		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
-		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
-		if (--ndl_count->count == 0)
-			spin_unlock(&ndl_lock->lock);
+	if (WARN_ON_ONCE(READ_ONCE(ndl->owner) != current))
+		goto out;
+
+	if (--ndl->count == 0) {
+		WRITE_ONCE(ndl->owner, NULL);
+		spin_unlock_bh(&ndl->lock);
 	}
+
+out:
 	migrate_enable();
 }
 EXPORT_SYMBOL(nd_region_release_lane);

base-commit: 028ef9c96e96197026887c0f092424679298aae8
-- 
2.37.3

