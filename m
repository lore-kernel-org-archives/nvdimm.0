Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BE9194C96
	for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 23:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777074250; cv=none; b=T45Eg2K0UdjJ/LL5bmTCaGuH3pd10F0fJZWvkts0z+IoWP1+zjMgS1vNrMl0Nnp4yOggOooDsRylgg6JGsF273d7stGCErg6L4bygwy9guEYmQC90bpNxmkSsFke86gxyMva9dlJ3ZiOoDZwlB5HHg4Zkd5SYIuQ9L/W5Kv0gpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777074250; c=relaxed/simple;
	bh=TyuXjTOqy3M+dUkimhxPphHpXnlZj50N9LwqabfZDsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nPo80m/PyW8kOJadCv2MiCuRdmb36JoV4Dus8IeL60MDkyyzZdaZAnckWY0oT7VHb4uz13JFkusrKG7j9vw2SyIRc8oAJ8kDnNGMx7VRxUivWCgN9hpXKSegRtP7/k0WcdmfZjw10JrkSoq4QCTPUaBBWidwh9zchsNH/8eUXDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VMl/3Zzo; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VMl/3Zzo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777074248; x=1808610248;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TyuXjTOqy3M+dUkimhxPphHpXnlZj50N9LwqabfZDsQ=;
  b=VMl/3ZzoUIu3XeyzOWKoxHTR5ylUYx9Je1y3M2S2p14eb6tN3HOtbVwD
   KSWoraTxQ72hY6yqPx59SqKEHDcUZZqHmlm6uRUu57zMyoIVgcZkhM6F2
   3jBYeGA00GrY2koNS0DQm/1JpTeoEWy0rDChEQdW+WIBOvBC07u65NRHB
   G9ZZ3Ua3CQ5HEs/avNWb/xddtG63ydb8U0JBUv6g4jSwwLAeX/fTi/0Wl
   /rTFZ5rcu9dHlk549idt26uvQsbrw5rmRNB4kFnkr7Quplpu27Q00o9Zo
   NbLA2ZIvlQ/OW0BIYsCQL7QBPv6ClERxvtVvf8N4rEER8ssXMbFld04Ur
   w==;
X-CSE-ConnectionGUID: 1KTS6M0SSguRCbwTRz2f2g==
X-CSE-MsgGUID: dCNuv1qbQoCnC7ikLV6s7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11766"; a="78045796"
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="78045796"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 16:44:08 -0700
X-CSE-ConnectionGUID: CpyA3JJtQWO7Y1Yeo1i16g==
X-CSE-MsgGUID: 5sn2jgbpTqKTl/TNN4Fe1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="228768811"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.229])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 16:44:08 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH] nvdimm/btt: Handle preemption in BTT lane acquisition
Date: Fri, 24 Apr 2026 16:44:03 -0700
Message-ID: <20260424234405.3762827-1-alison.schofield@intel.com>
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

Found with the NDCTL unit test btt-check.sh

Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
Assisted-by: Claude Sonnet 4.5
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

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
index e35c2e18518f..830241b93bf2 100644
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
+		spin_lock(&ndl->lock);
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
+		spin_unlock(&ndl->lock);
 	}
+
+out:
 	migrate_enable();
 }
 EXPORT_SYMBOL(nd_region_release_lane);

base-commit: 028ef9c96e96197026887c0f092424679298aae8
-- 
2.37.3

