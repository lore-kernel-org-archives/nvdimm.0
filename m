Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592CD1947E
	for <nvdimm@lists.linux.dev>; Wed, 20 Mar 2024 06:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710915050; cv=none; b=ITgjx9yQu61Vxn1ceos9CHzIvDQn5NWAZJBzWWtm7FyPlV/eI5URye7LEEbX06Crxopap158C3gNK3h8ufYuGE1vD+5P2BQak+lBmDfGCihbuEE2EbrWLBZeGJ6kFZeo7xEwLq4cVBjlj2dEpxcflAhzydN1P/V0bgnhJQJC9bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710915050; c=relaxed/simple;
	bh=nPM0FNUHl2H8tDvyjY1tnvNPrdJjAxEbdlobBKBsCwA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h54doXgPrw5z2dujzOrn3b/zoRDrEu4YJfa6cGeDOycow8IzEAB43woroM8WspD+AV4uzl7bUEQtN2PUQqnnQFzjGQFUhC4iDOlfmd9tySfvTuMXF428xiVRjpkIx+A3QzZ+Tyvs/I/h4kLVA9JUY1Wp0trjLQ8UqvRFrYterjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=N5KFAOSN; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="N5KFAOSN"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-789e6e1d96eso306475085a.3
        for <nvdimm@lists.linux.dev>; Tue, 19 Mar 2024 23:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1710915047; x=1711519847; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ERz1B7CkAMP0XI8jiGkcKeihtxJbJIbVUzaDZdJGjjc=;
        b=N5KFAOSNcQiZeOzzRa2aVK4PdKgRPPfUYa4+wgS7siIklh3jBbBXJoTm8+lP29o2As
         4XKg1i/n+ESYbP4W/gCnHFEaiyE73Q0qBNutS9aJih0QGZw63i+75RfzdYBoB87U63or
         xQTJ3EKVbYIlgEdwy3821UiQaGBS/gyX9NpGROUXZrnHXVOyVufYdlQHfDA9yzNo2OIh
         clx8Xwwv5CQmtsBmc37nSayU5nEmQMFV5mRHHHhZnwulj92sBBmh7liJTPkC+7/Cs0DT
         2LsC2azViDeUf4aHs7g9vvm76Ivbnkv/fDgs2sXxdixOYvK9z2INlM8MLvSaRNZlKnpL
         R9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710915047; x=1711519847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ERz1B7CkAMP0XI8jiGkcKeihtxJbJIbVUzaDZdJGjjc=;
        b=jM651Bm1NJ6H4y937hrutdFi9sPalZ2pwjE/wx3ixR6z+gwtAlIcWCyvpv9W1vLmrM
         /Vc9WRWOAQ/N2Rc9gyokCR1wLkYhDYIsr1rlQWSuKuCPm/7A1fG/VgBELPjiSSkDBk85
         E+XJe4MH1A7PYBgroXv+R7DyRNWgZGgbpSV8BcwiUviDxupxVcYHBrGtJAwVzZdza3aH
         SwlHDAp37RAmoReINh81He2NYgVS/HdNysXGBsSdxCYjx1VqDvV3k5+ov6nMi32Wb7wM
         /V59dFCqiSLseVe8jXkUKMXEEjGKoFZNXReB4Ba389xEe5274hDvtFEuyFcJ2tFFsc/n
         5Vvw==
X-Forwarded-Encrypted: i=1; AJvYcCV2PoLiic7qpSlEisiM3kjV4ttNV3OmDthGb9wsaC8xZFbZlIG0ajhb9Arq243b2Yz/twtGU/7iVYbDhlfMBAo+95exJ/9x
X-Gm-Message-State: AOJu0YxKLoZphK5G4uFWC255goX4tBilRxGbTxZsvdvIHF8tK41lqmGI
	4Ka4EGf6bpMvBhX5DhXe8RCS0jwL3sg2rxo3xSKnu5E4LxK7g6ZDzIeRYwAUx4k=
X-Google-Smtp-Source: AGHT+IFd61Cf+hhll8BkkKkcQ5sTHn50l75EQClN97QQIN2IQKz/s0QGwRvVZ3WiMi85sO8BQ6K+lw==
X-Received: by 2002:a05:620a:1673:b0:789:e1f2:b0f0 with SMTP id d19-20020a05620a167300b00789e1f2b0f0mr993376qko.35.1710915047238;
        Tue, 19 Mar 2024 23:10:47 -0700 (PDT)
Received: from n231-228-171.byted.org ([130.44.215.123])
        by smtp.gmail.com with ESMTPSA id r15-20020a05620a03cf00b0078a042376absm2295914qkm.22.2024.03.19.23.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 23:10:47 -0700 (PDT)
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
Subject: [PATCH v3 1/2] memory tier: dax/kmem: create CPUless memory tiers after obtaining HMAT info
Date: Wed, 20 Mar 2024 06:10:39 +0000
Message-Id: <20240320061041.3246828-2-horenchuang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240320061041.3246828-1-horenchuang@bytedance.com>
References: <20240320061041.3246828-1-horenchuang@bytedance.com>
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

More details:
* late_initcall(memory_tier_late_init);
Some device drivers may have initialized memory tiers between
`memory_tier_init()` and `memory_tier_late_init()`, potentially bringing
online memory nodes and configuring memory tiers. They should be excluded
in the late init.

* Abstract common functions into `mt_find_alloc_memory_type()`
Since different memory devices require finding or allocating a memory type,
these common steps are abstracted into a single function,
`mt_find_alloc_memory_type()`, enhancing code scalability and conciseness.

* Handle cases where there is no HMAT when creating memory tiers
There is a scenario where a CPUless node does not provide HMAT information.
If no HMAT is specified, it falls back to using the default DRAM tier.

* Change adist calculation code to use another new lock, `mt_perf_lock`.
In the current implementation, iterating through CPUlist nodes requires
holding the `memory_tier_lock`. However, `mt_calc_adistance()` will end up
trying to acquire the same lock, leading to a potential deadlock.
Therefore, we propose introducing a standalone `mt_perf_lock` to protect
`default_dram_perf`. This approach not only avoids deadlock but also
prevents holding a large lock simultaneously.

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
---
 drivers/dax/kmem.c           | 13 +----
 include/linux/memory-tiers.h |  7 +++
 mm/memory-tiers.c            | 94 +++++++++++++++++++++++++++++++++---
 3 files changed, 95 insertions(+), 19 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 42ee360cf4e3..de1333aa7b3e 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -55,21 +55,10 @@ static LIST_HEAD(kmem_memory_types);
 
 static struct memory_dev_type *kmem_find_alloc_memory_type(int adist)
 {
-	bool found = false;
 	struct memory_dev_type *mtype;
 
 	mutex_lock(&kmem_memory_type_lock);
-	list_for_each_entry(mtype, &kmem_memory_types, list) {
-		if (mtype->adistance == adist) {
-			found = true;
-			break;
-		}
-	}
-	if (!found) {
-		mtype = alloc_memory_type(adist);
-		if (!IS_ERR(mtype))
-			list_add(&mtype->list, &kmem_memory_types);
-	}
+	mtype = mt_find_alloc_memory_type(adist, &kmem_memory_types);
 	mutex_unlock(&kmem_memory_type_lock);
 
 	return mtype;
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 69e781900082..b2135334ac18 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -48,6 +48,8 @@ int mt_calc_adistance(int node, int *adist);
 int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 			     const char *source);
 int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
+struct memory_dev_type *mt_find_alloc_memory_type(int adist,
+							struct list_head *memory_types);
 #ifdef CONFIG_MIGRATION
 int next_demotion_node(int node);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -136,5 +138,10 @@ static inline int mt_perf_to_adistance(struct access_coordinate *perf, int *adis
 {
 	return -EIO;
 }
+
+struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *memory_types)
+{
+	return NULL;
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 0537664620e5..d9b96b21b65a 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -6,6 +6,7 @@
 #include <linux/memory.h>
 #include <linux/memory-tiers.h>
 #include <linux/notifier.h>
+#include <linux/acpi.h>
 
 #include "internal.h"
 
@@ -36,6 +37,11 @@ struct node_memory_type_map {
 
 static DEFINE_MUTEX(memory_tier_lock);
 static LIST_HEAD(memory_tiers);
+/*
+ * The list is used to store all memory types that are not created
+ * by a device driver.
+ */
+static LIST_HEAD(default_memory_types);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 struct memory_dev_type *default_dram_type;
 
@@ -505,7 +511,8 @@ static inline void __init_node_memory_type(int node, struct memory_dev_type *mem
 static struct memory_tier *set_node_memory_tier(int node)
 {
 	struct memory_tier *memtier;
-	struct memory_dev_type *memtype;
+	struct memory_dev_type *memtype, *mtype = NULL;
+	int adist = MEMTIER_ADISTANCE_DRAM;
 	pg_data_t *pgdat = NODE_DATA(node);
 
 
@@ -514,7 +521,18 @@ static struct memory_tier *set_node_memory_tier(int node)
 	if (!node_state(node, N_MEMORY))
 		return ERR_PTR(-EINVAL);
 
-	__init_node_memory_type(node, default_dram_type);
+	mt_calc_adistance(node, &adist);
+	if (adist != MEMTIER_ADISTANCE_DRAM &&
+			node_memory_types[node].memtype == NULL) {
+		mtype = mt_find_alloc_memory_type(adist, &default_memory_types);
+		if (IS_ERR(mtype)) {
+			mtype = default_dram_type;
+			pr_info("Failed to allocate a memory type. Fall back.\n");
+		}
+	} else
+		mtype = default_dram_type;
+
+	__init_node_memory_type(node, mtype);
 
 	memtype = node_memory_types[node].memtype;
 	node_set(node, memtype->nodes);
@@ -623,6 +641,55 @@ void clear_node_memory_type(int node, struct memory_dev_type *memtype)
 }
 EXPORT_SYMBOL_GPL(clear_node_memory_type);
 
+struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *memory_types)
+{
+	bool found = false;
+	struct memory_dev_type *mtype;
+
+	list_for_each_entry(mtype, memory_types, list) {
+		if (mtype->adistance == adist) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		mtype = alloc_memory_type(adist);
+		if (!IS_ERR(mtype))
+			list_add(&mtype->list, memory_types);
+	}
+
+	return mtype;
+}
+EXPORT_SYMBOL_GPL(mt_find_alloc_memory_type);
+
+/*
+ * This is invoked via late_initcall() to create
+ * CPUless memory tiers after HMAT info is ready or
+ * when there is no HMAT.
+ */
+static int __init memory_tier_late_init(void)
+{
+	int nid;
+
+	mutex_lock(&memory_tier_lock);
+	for_each_node_state(nid, N_MEMORY)
+		if (!node_state(nid, N_CPU) &&
+			node_memory_types[nid].memtype == NULL)
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
@@ -631,12 +698,16 @@ static void dump_hmem_attrs(struct access_coordinate *coord, const char *prefix)
 		coord->read_bandwidth, coord->write_bandwidth);
 }
 
+/*
+ * The lock is used to protect the default_dram_perf.
+ */
+static DEFINE_MUTEX(mt_perf_lock);
 int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 			     const char *source)
 {
 	int rc = 0;
 
-	mutex_lock(&memory_tier_lock);
+	mutex_lock(&mt_perf_lock);
 	if (default_dram_perf_error) {
 		rc = -EIO;
 		goto out;
@@ -684,7 +755,7 @@ int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 	}
 
 out:
-	mutex_unlock(&memory_tier_lock);
+	mutex_unlock(&mt_perf_lock);
 	return rc;
 }
 
@@ -700,7 +771,7 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist)
 	    perf->read_bandwidth + perf->write_bandwidth == 0)
 		return -EINVAL;
 
-	mutex_lock(&memory_tier_lock);
+	mutex_lock(&mt_perf_lock);
 	/*
 	 * The abstract distance of a memory node is in direct proportion to
 	 * its memory latency (read + write) and inversely proportional to its
@@ -713,7 +784,7 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist)
 		(default_dram_perf.read_latency + default_dram_perf.write_latency) *
 		(default_dram_perf.read_bandwidth + default_dram_perf.write_bandwidth) /
 		(perf->read_bandwidth + perf->write_bandwidth);
-	mutex_unlock(&memory_tier_lock);
+	mutex_unlock(&mt_perf_lock);
 
 	return 0;
 }
@@ -826,7 +897,8 @@ static int __init memory_tier_init(void)
 	 * For now we can have 4 faster memory tiers with smaller adistance
 	 * than default DRAM tier.
 	 */
-	default_dram_type = alloc_memory_type(MEMTIER_ADISTANCE_DRAM);
+	default_dram_type = mt_find_alloc_memory_type(
+					MEMTIER_ADISTANCE_DRAM, &default_memory_types);
 	if (IS_ERR(default_dram_type))
 		panic("%s() failed to allocate default DRAM tier\n", __func__);
 
@@ -836,6 +908,14 @@ static int __init memory_tier_init(void)
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

