Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CA559B56
	for <nvdimm@lists.linux.dev>; Tue, 12 Mar 2024 06:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710224282; cv=none; b=nKvs7JTQBubOpWPEyiSzM8qZribBJUTqo+rmPQjH6i7TUCExm+nbjs+eqZxW7EiavYu44JLo4P57rgx2kS34/bUopCj93eNo2G93jWeKwmpaj9lHTjDNs99WmJXGIOeTXVEf9824q/+VHrtHPoqsc6QM19SombryHmdqZ6cb0ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710224282; c=relaxed/simple;
	bh=IfuVqQZeLDnfRh3KTirmLIiuQgZqTIEnGVG9hFhgBTg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZakE0Dw9aQrfdaCpmkovnFTv8L0vDngznvZKf2cs4/GtEFcA/4VfwpQVRsVKt3fhoIRX1WcUadmcahoZsX/qNb/hlm70PeJ8am7HhOWk6zr72MxRhiXKixEtiSqnWrcKGiWhyHhxLqclqRifKRTSXGJ5hs5Y2Kctvsl2PFVl2Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=fOqfBBJn; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="fOqfBBJn"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7884124b06aso232326385a.2
        for <nvdimm@lists.linux.dev>; Mon, 11 Mar 2024 23:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1710224279; x=1710829079; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3g1w+Bq/HKayQEtXVRZT/0IpFF4Q07xqLAcu8q3O3ps=;
        b=fOqfBBJnjJnIPtP5SoPLW7N80P7q/FDJMhrHBrl6dTRpG3slMMaoM4WAjjQ5RHxi6a
         YKU3uqSI/lc7sLnO2ZKmgOh3y1tYJ0J83+QFWZmoppffQ6A9jB6hk70xkvilfw4th0PT
         4bjBnTSUh2fqarjfBm/TcJcGv/6juVymKR5pHv+zHs3MBdx9BkARhfMjLYheUwT/Wu6m
         m1idNoEA+5pYrWuGMwyyWARETZO6sDRgeYr2zRSeU5sZ2G6CNoLS3LzWiOBkGQYHfsZX
         I8tKG2qUe4nrt+OBLNiKq1bfb/m0DtBKMvpecXT1T/VoMydMNHxi/+n3bAuTkRqU2bIU
         mKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710224279; x=1710829079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3g1w+Bq/HKayQEtXVRZT/0IpFF4Q07xqLAcu8q3O3ps=;
        b=fLfKXhj68jNm+V4h5jkWr7wAvfbyDNa5tFLVIvEmJ2+hl/Wf+vPDHty2ZxqwK5HHte
         5+ss00Qa/K/qe2+/Fy4+XoRNrXLdZyoGZMJE0nmznxM1f+Pv3rytiH2f9IvjVcHJ+hTD
         XNFlbeHNXnP5+1XIP70PMfQyKM/aQTgxPiZ7aOJ438AkdbsIIFLgXszcEF02dfSwZ6Nx
         27fEEFnGVh0pkq1X45nsJpRleJJ9Bzv/4tEJpa9+OGOfE2M3TUZ5fyPfIY53OT8cVTSP
         XazhKoL+mIY/sSId5x/FQe6CyjQ1w57TZ2erLMJW+wyRCTIFNqonPtT/6snAo1KIrCDz
         BwrA==
X-Forwarded-Encrypted: i=1; AJvYcCWGAzbE1bXP7uiOwflrMni9cy25WQl1eXd+hJ4nCpr/5u3+jKhG60eE9j3Y+y1HeFZmzj8sF0DRoD+dTeNjQ2A+DPz8Iljw
X-Gm-Message-State: AOJu0Yxqzah7e8/k0MWktOw08YpxxusM7FWS4VwqqcFZTk+kx2rfnQzM
	yFoDpSjSGCiC63azI8FEj2nZTUEpFb93cLHH/Mp2Uq8J04S4OJME2FSVahe/QUM=
X-Google-Smtp-Source: AGHT+IFtueu2hHzThmvc/JKtQbFGEvZGODzMhvBN+JE313AMau+fPRj/Wh1ccpFe+lfa9yfwLLS1Ww==
X-Received: by 2002:a05:620a:15bc:b0:788:70b4:159 with SMTP id f28-20020a05620a15bc00b0078870b40159mr4209916qkk.42.1710224279479;
        Mon, 11 Mar 2024 23:17:59 -0700 (PDT)
Received: from n231-228-171.byted.org ([147.160.184.133])
        by smtp.gmail.com with ESMTPSA id m18-20020a05620a221200b00787b93d8df1sm3394396qkh.99.2024.03.11.23.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 23:17:59 -0700 (PDT)
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
To: "Gregory Price" <gourry.memverge@gmail.com>,
	aneesh.kumar@linux.ibm.com,
	mhocko@suse.com,
	tj@kernel.org,
	john@jagalactic.com,
	"Eishan Mirakhur" <emirakhur@micron.com>,
	"Vinicius Tavares Petrucci" <vtavarespetr@micron.com>,
	"Ravis OpenSrc" <Ravis.OpenSrc@micron.com>,
	"Alistair Popple" <apopple@nvidia.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Huang Ying <ying.huang@intel.com>,
	"Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-mm@kvack.org
Cc: "Ho-Ren (Jack) Chuang" <horenc@vt.edu>,
	"Ho-Ren (Jack) Chuang" <horenchuang@gmail.com>,
	qemu-devel@nongnu.org,
	Hao Xiang <hao.xiang@bytedance.com>
Subject: [PATCH v2 1/1] memory tier: acpi/hmat: create CPUless memory tiers after obtaining HMAT info
Date: Tue, 12 Mar 2024 06:17:27 +0000
Message-Id: <20240312061729.1997111-2-horenchuang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240312061729.1997111-1-horenchuang@bytedance.com>
References: <20240312061729.1997111-1-horenchuang@bytedance.com>
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

* Abstract common functions into `find_alloc_memory_type()`
Since different memory devices require finding or allocating a memory type,
these common steps are abstracted into a single function,
`find_alloc_memory_type()`, enhancing code scalability and conciseness.

* Handle cases where there is no HMAT when creating memory tiers
There is a scenario where a CPUless node does not provide HMAT information.
If no HMAT is specified, it falls back to using the default DRAM tier.

* Change adist calculation code to use another new lock, mt_perf_lock.
In the current implementation, iterating through CPUlist nodes requires
holding the `memory_tier_lock`. However, `mt_calc_adistance()` will end up
trying to acquire the same lock, leading to a potential deadlock.
Therefore, we propose introducing a standalone `mt_perf_lock` to protect
`default_dram_perf`. This approach not only avoids deadlock but also
prevents holding a large lock simultaneously.

Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
Signed-off-by: Hao Xiang <hao.xiang@bytedance.com>
---
 drivers/acpi/numa/hmat.c     | 11 ++++++
 drivers/dax/kmem.c           | 13 +------
 include/linux/acpi.h         |  6 ++++
 include/linux/memory-tiers.h |  8 +++++
 mm/memory-tiers.c            | 70 +++++++++++++++++++++++++++++++++---
 5 files changed, 92 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index d6b85f0f6082..28812ec2c793 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -38,6 +38,8 @@ static LIST_HEAD(targets);
 static LIST_HEAD(initiators);
 static LIST_HEAD(localities);
 
+static LIST_HEAD(hmat_memory_types);
+
 static DEFINE_MUTEX(target_lock);
 
 /*
@@ -149,6 +151,12 @@ int acpi_get_genport_coordinates(u32 uid,
 }
 EXPORT_SYMBOL_NS_GPL(acpi_get_genport_coordinates, CXL);
 
+struct memory_dev_type *hmat_find_alloc_memory_type(int adist)
+{
+	return find_alloc_memory_type(adist, &hmat_memory_types);
+}
+EXPORT_SYMBOL_GPL(hmat_find_alloc_memory_type);
+
 static __init void alloc_memory_initiator(unsigned int cpu_pxm)
 {
 	struct memory_initiator *initiator;
@@ -1038,6 +1046,9 @@ static __init int hmat_init(void)
 	if (!hmat_set_default_dram_perf())
 		register_mt_adistance_algorithm(&hmat_adist_nb);
 
+	/* Post-create CPUless memory tiers after getting HMAT info */
+	memory_tier_late_init();
+
 	return 0;
 out_put:
 	hmat_free_structures();
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 42ee360cf4e3..aee17ab59f4f 100644
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
+	mtype = find_alloc_memory_type(adist, &kmem_memory_types);
 	mutex_unlock(&kmem_memory_type_lock);
 
 	return mtype;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index b7165e52b3c6..3f927ff01f02 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -434,12 +434,18 @@ int thermal_acpi_critical_trip_temp(struct acpi_device *adev, int *ret_temp);
 
 #ifdef CONFIG_ACPI_HMAT
 int acpi_get_genport_coordinates(u32 uid, struct access_coordinate *coord);
+struct memory_dev_type *hmat_find_alloc_memory_type(int adist);
 #else
 static inline int acpi_get_genport_coordinates(u32 uid,
 					       struct access_coordinate *coord)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline struct memory_dev_type *hmat_find_alloc_memory_type(int adist)
+{
+	return NULL;
+}
 #endif
 
 #ifdef CONFIG_ACPI_NUMA
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 69e781900082..4bc2596c5774 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -48,6 +48,9 @@ int mt_calc_adistance(int node, int *adist);
 int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 			     const char *source);
 int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
+struct memory_dev_type *find_alloc_memory_type(int adist,
+							struct list_head *memory_types);
+void memory_tier_late_init(void);
 #ifdef CONFIG_MIGRATION
 int next_demotion_node(int node);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -136,5 +139,10 @@ static inline int mt_perf_to_adistance(struct access_coordinate *perf, int *adis
 {
 	return -EIO;
 }
+
+static inline void memory_tier_late_init(void)
+{
+
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 0537664620e5..79f748d60e6f 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -6,6 +6,7 @@
 #include <linux/memory.h>
 #include <linux/memory-tiers.h>
 #include <linux/notifier.h>
+#include <linux/acpi.h>
 
 #include "internal.h"
 
@@ -35,6 +36,7 @@ struct node_memory_type_map {
 };
 
 static DEFINE_MUTEX(memory_tier_lock);
+static DEFINE_MUTEX(mt_perf_lock);
 static LIST_HEAD(memory_tiers);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 struct memory_dev_type *default_dram_type;
@@ -623,6 +625,58 @@ void clear_node_memory_type(int node, struct memory_dev_type *memtype)
 }
 EXPORT_SYMBOL_GPL(clear_node_memory_type);
 
+struct memory_dev_type *find_alloc_memory_type(int adist, struct list_head *memory_types)
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
+EXPORT_SYMBOL_GPL(find_alloc_memory_type);
+
+static void memory_tier_late_create(int node)
+{
+	struct memory_dev_type *mtype = NULL;
+	int adist = MEMTIER_ADISTANCE_DRAM;
+
+	mt_calc_adistance(node, &adist);
+	if (adist != MEMTIER_ADISTANCE_DRAM) {
+		mtype = hmat_find_alloc_memory_type(adist);
+		if (!IS_ERR(mtype))
+			__init_node_memory_type(node, mtype);
+		else
+			pr_err("Failed to allocate a memory type at %s()\n", __func__);
+	}
+
+	set_node_memory_tier(node);
+}
+
+void memory_tier_late_init(void)
+{
+	int nid;
+
+	mutex_lock(&memory_tier_lock);
+	for_each_node_state(nid, N_MEMORY)
+		if (!node_state(nid, N_CPU))
+			memory_tier_late_create(nid);
+
+	establish_demotion_targets();
+	mutex_unlock(&memory_tier_lock);
+}
+EXPORT_SYMBOL_GPL(memory_tier_late_init);
+
 static void dump_hmem_attrs(struct access_coordinate *coord, const char *prefix)
 {
 	pr_info(
@@ -636,7 +690,7 @@ int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 {
 	int rc = 0;
 
-	mutex_lock(&memory_tier_lock);
+	mutex_lock(&mt_perf_lock);
 	if (default_dram_perf_error) {
 		rc = -EIO;
 		goto out;
@@ -684,7 +738,7 @@ int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 	}
 
 out:
-	mutex_unlock(&memory_tier_lock);
+	mutex_unlock(&mt_perf_lock);
 	return rc;
 }
 
@@ -700,7 +754,7 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist)
 	    perf->read_bandwidth + perf->write_bandwidth == 0)
 		return -EINVAL;
 
-	mutex_lock(&memory_tier_lock);
+	mutex_lock(&mt_perf_lock);
 	/*
 	 * The abstract distance of a memory node is in direct proportion to
 	 * its memory latency (read + write) and inversely proportional to its
@@ -713,7 +767,7 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist)
 		(default_dram_perf.read_latency + default_dram_perf.write_latency) *
 		(default_dram_perf.read_bandwidth + default_dram_perf.write_bandwidth) /
 		(perf->read_bandwidth + perf->write_bandwidth);
-	mutex_unlock(&memory_tier_lock);
+	mutex_unlock(&mt_perf_lock);
 
 	return 0;
 }
@@ -836,6 +890,14 @@ static int __init memory_tier_init(void)
 	 * types assigned.
 	 */
 	for_each_node_state(node, N_MEMORY) {
+		if (!node_state(node, N_CPU))
+			/*
+			 * Defer memory tier initialization on CPUless numa nodes.
+			 * These will be initialized when HMAT information is
+			 * available.
+			 */
+			continue;
+
 		memtier = set_node_memory_tier(node);
 		if (IS_ERR(memtier))
 			/*
-- 
Ho-Ren (Jack) Chuang

