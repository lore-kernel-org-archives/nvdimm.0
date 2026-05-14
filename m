Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591981A76BB
	for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 00:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778718201; cv=none; b=o30+teAqsl9ZnTk9IsEfX5Ue6MICsachy/dRolIKnh1Ug9vPEJY2/wO0+6vtnkRZ8WF236ge7NQiJcigi3SkUry1USESBGnGrfbLVfd1QK4YQ7UoYjm0oWL6wMVpYE+pmEDPOCc9UufzJe9Yw+l79mx+yjAxqbkXCKAEx9/Gdmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778718201; c=relaxed/simple;
	bh=NQmjoc30frsViKEOipZOQ5pEMd0x0kgUHQMWdf6Xj2g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KZEArV4nGg9rzBobmBw+1WTtAUwR2Z7D4mLnHU8oH6gsSwKruId3QeBmXn9MTnBxrxRaBnmvcq/jbDaGikfVvY0PvyknO0TFm+t6+nn80zbKGM5BikvRmlfVlp0crQubS4f/uHHfWRbfSk1m6zcLVZ1zPGPh9jAMdrEuifD8H58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dom+Bjjc; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dom+Bjjc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778718199; x=1810254199;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NQmjoc30frsViKEOipZOQ5pEMd0x0kgUHQMWdf6Xj2g=;
  b=Dom+BjjchwvpVmwPdeAnwBNmVHLJQRO/swI/dkbEeaV54o5/yf63HGLv
   Xcv0cl3lIR79gxd+L0JCrfj1pGAtavSPF97LGJCsPw43ljc0cqtm2Zn11
   jrTyzH2pMuHKlNRwSy9hcQR4A1s9eX/wa5kNu0C/TbGhUEmzORH8ea4iC
   R16Hkn5LYV8Km2cE2cBLndIpGboid6WEBRrWVUqws+4GycDyRsVC5rJum
   NBKzuCHVYHPeRq8RhqPinVMnfVJpUftMZht6ke7E6aDUZa0I/C2RbQAHV
   QEZ0GWtJLURPw/nfqTsfEuhy2TXqs+Srgx+787IEoD0oIuHVYKpzT+aft
   g==;
X-CSE-ConnectionGUID: r/Ge63mbQs6WjymHkRaLjw==
X-CSE-MsgGUID: gnmU19W4TASRsSgoWDez6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="79370442"
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="79370442"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 17:23:19 -0700
X-CSE-ConnectionGUID: kDRpDckaQ5W500RAOdy5Kg==
X-CSE-MsgGUID: wMgFFgpMRMawrCiRmH0AcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="238121102"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.125])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 17:23:18 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH v3] nvdimm/btt: Handle preemption in BTT lane acquisition
Date: Wed, 13 May 2026 17:23:12 -0700
Message-ID: <20260514002314.65024-1-alison.schofield@intel.com>
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

Replace the spinlock with a per-lane mutex, remove the per-CPU
recursion fast path, and take the lane lock unconditionally.

Add might_sleep() to catch any future atomic-context caller.

Found with the ndctl unit test btt-check.sh.

Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
Assisted-by: Claude Sonnet 4.5
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Aboorva: I appreciate your Tested-by tag, yet due to the churn,
I did not apply it. Please re-test with this version.

Changes in v3:
- Replace spinlock with a per-lane mutex (Arboorva)*
- Rebase onto 7.1-rc1
- Update commit log

*Arboorva pointed out that BTT write-side lane ownership can reach
provider flush callbacks that may sleep, making the existing
spinlock-based lane lifetime invalid. My initial thought was to
create a small series where the first patch converts the per-lane
lock to a mutex so the lane critical section can safely sleep.
That left an intermediate bad state, so the changes are kept
together in this single patch.

Changes in v2:
Use spin_(un)lock_bh() (Sashiko AI)
Update commit log per softirq re-enty and spinlock change

A new unit test to stress this is under review here:
https://lore.kernel.org/nvdimm/20260424233633.3762217-1-alison.schofield@intel.com/


 drivers/nvdimm/nd.h          |  3 +--
 drivers/nvdimm/region_devs.c | 50 ++++++++++--------------------------
 2 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index b199eea3260e..3fbeaddb5b5c 100644
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
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e35c2e18518f..d01b16f6a463 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -904,52 +904,33 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
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
 	unsigned int cpu, lane;
 
-	migrate_disable();
-	cpu = smp_processor_id();
-	if (nd_region->num_lanes < nr_cpu_ids) {
-		struct nd_percpu_lane *ndl_lock, *ndl_count;
+	might_sleep();
 
+	cpu = raw_smp_processor_id();
+	if (nd_region->num_lanes < nr_cpu_ids)
 		lane = cpu % nd_region->num_lanes;
-		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
-		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
-		if (ndl_count->count++ == 0)
-			spin_lock(&ndl_lock->lock);
-	} else
+	else
 		lane = cpu;
 
+	mutex_lock(&per_cpu_ptr(nd_region->lane, lane)->lock);
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
+	mutex_unlock(&per_cpu_ptr(nd_region->lane, lane)->lock);
 }
 EXPORT_SYMBOL(nd_region_release_lane);
 
@@ -1023,13 +1004,8 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	if (!nd_region->lane)
 		goto err_percpu;
 
-        for (i = 0; i < nr_cpu_ids; i++) {
-		struct nd_percpu_lane *ndl;
-
-		ndl = per_cpu_ptr(nd_region->lane, i);
-		spin_lock_init(&ndl->lock);
-		ndl->count = 0;
-	}
+	for (i = 0; i < nr_cpu_ids; i++)
+		mutex_init(&per_cpu_ptr(nd_region->lane, i)->lock);
 
 	for (i = 0; i < ndr_desc->num_mappings; i++) {
 		struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];

base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.37.3

