Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01D9391E56
	for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774105454; cv=none; b=uWfjxnjT6b9gGT4v88JlNA/SeBVJU7W51L7tfEzNf7BZNoAZMuJSFacsXGpHB1yHw2/8MI+2aajxOFR5pQtVomVNvUjTjdH9W/TZnJvwatnn+pz3tCvHaMr53Nv9eZS04M7PiDbDAzTZTSxPu1mFX1lB7rMzDAzFbtE4mkT93VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774105454; c=relaxed/simple;
	bh=TQuW+OZpUZldWOSNfRy7f3RL4fU3SXCpUPS/DDnyruc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQS+yqGXBjNoqv/FjSrPCXeQ4c2ydgGPbwlBG2J/Uj20FJzHgGJDOtRuhPg0sS+IQZuftjwtuKrRGTOzhC0jrAyXL3mHFmbLPAlsaDM+waHOI3gq204NaUdRr690JCG11HFyx/jmW6FTw9n90JaC7zjg88G3b9SwZw4VEF3LaiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=L9v8XwjA; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="L9v8XwjA"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-5ffc1e25d6cso803290137.0
        for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 08:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105450; x=1774710250; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7xO5G1TTTEFUzwGvqajKTysfZ/iiFkVbZDpQBQ6HidU=;
        b=L9v8XwjAg728Dw4/oLpMfjlHuDy1nUaMNoV9hb/DpQd3385pY/XgBnuUaA7dojzk3k
         qDzWiPm7USMOxuTAxxFvjfbb9k/PXBkes1fq1xq47BsYiydF8u/+SSILRf6JO4KkyX5n
         rVaFnYkuNGfCk/Iuy/+TAjZhktS7NvjcI6sPjDC5Su70zDgjFpDdPmyZ7XnikgWpCb4d
         qH7bgfPRKTUyKgcz+NuXMQSUxNKSGnWkRcN7saP6zJDsV+eL7GtechBY7aXwEf9Je0vN
         zsb41HT0tUS0CnXrgJ5Ur36qxVaEoKwCujb4AIOA0lw+W72HKAgPUKF8WvgHrCaYX1uG
         8X6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105450; x=1774710250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7xO5G1TTTEFUzwGvqajKTysfZ/iiFkVbZDpQBQ6HidU=;
        b=QJ03SgYz9A4cPLhqGQzRq+rRg5b4jMDLlVqUy2Xl+tAfVnSnHR0XyUNQ9tOiLSvoI1
         /9/B0/Vnf/YJnve8MySshLNW/oVrINC6mH58lBRExRa4d/j0cUMd74FEFmKJUqggSsnc
         XXxKLxrj0bpqwPsRA0UGB2k73tJId7tKpAx8/M6ZOB9VKUIt/GAL7t6KL34+bk2puWzC
         IIBpuAxPBWLKbNkh8yfsxAFp5tyIz1IDsU3Cdh5vLgf3KUqmPIf6di2fU4u+9E4iga4H
         GW5dPTfDACQO1OwdGY72FMUuZMj/xhYTYlTQTHE6TV1zSMqNfkvUo7qyTKfeiYBVP97p
         A8+A==
X-Forwarded-Encrypted: i=1; AJvYcCUf0q0R0MGsYjOExTKj56ATA12szdHw4S2sDQ1994mayj2l11uUuBU9sEFgqnkLEvH4Z8tNgA8=@lists.linux.dev
X-Gm-Message-State: AOJu0YypX+3bSLg0OPegrzS7U1MeRHoPnlsU9fxL5FQRo3aDsFsMd0EJ
	o+NHkPhh4o1gPoPHjAuVkxzmyTVTUIz5wvQ8E+CI9nQa3/2lpQ0muaHeJAKK2/Q5uhc=
X-Gm-Gg: ATEYQzwuv518tOV55m+8C1eHSxEj7WhC6v+N5W03jrQxYm9yYkJCOYfmP34NFT7YNqD
	A/jEzkXZQ77TYn0mJyhvhlozWrw4fzDNpCv+hQ7qQ8L8Pr2skjAikpUhrhXvR5n+/u7VxSsVl8P
	sMzbqtSJd+dEXEms8FkmFCsBS/qfVqiAxY9zOJDjiNVvx1tW+1nIRl30RGy53FC6+Zuy36HDPsX
	vPafm2K5izErAj7A/w2yc/nSO8kf4FhaCiIsA8rVuLFtkal5mi9tnxR8GzL1vnDfyNYkMesSQeS
	14zK7v+n0WainNBm4SquxnrtdKzOj57qfpA4/tDNepZjAIT5tQ4hE6XPPxhO9t88GoCi/cJzGBT
	HvockoLdiTdlnyNOEAj3fE+lcVtMZakf3LR8sP1gQfLIBG3I4LCgIOb4woP/2QeEqNurbFv5Ew9
	O3faZfOEj/RNozI7rG+q99hvT9SwqnMphkaGABkC2+NJJ+DouR+if63trGPIhHxOAJeji2GTUgV
	XT7eZeTq2Gia2k=
X-Received: by 2002:a05:6102:dd0:b0:601:f386:9ed2 with SMTP id ada2fe7eead31-602aea8d861mr2785184137.7.1774105450228;
        Sat, 21 Mar 2026 08:04:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:09 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 1/8] mm/memory-tiers: consolidate memory type dedup into mt_get_memory_type()
Date: Sat, 21 Mar 2026 11:03:57 -0400
Message-ID: <20260321150404.3288786-2-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace per-driver memory type list infrastructure with a single
mt_get_memory_type(adist) that deduplicates against the global
default_memory_types list under memory_tier_lock.

The per-driver lists (mutex + list_head + find/put wrappers) provided
dedup within a single driver, but not across drivers or with the core.
Since the number of distinct adist values is bounded and types on
default_memory_types are never freed anyway, the per-driver cleanup
on module unload was not useful.

Add MEMTIER_DEFAULT_LOWTIER_ADISTANCE to replace the default DAX
adistance, since it was really used as a standin for all kmem hotplugged
memory.  This at least makes the default tier relationship clearer to
other drivers and they can see where to put their memory in relation to
the default lower tier.

Core changes:
 - Add mt_get_memory_type() as the single exported entry point
 - Drop most other interfaces - clear_node_memory_type() is now the
   appropriate put function.
 - export MEMTIER_DEFAULT_LOWTIER_ADISTANCE

dax/kmem changes:
 - Remove MEMTIER_DEFAULT_DAX_ADISTANCE, use MEMTIER_DEFAULT_LOWTIER_ADISTANCE
 - Remove per-driver kmem_memory_type_lock/kmem_memory_types/wrappers
 - Store mtype per-device in dax_kmem_data
 - Pass data->mtype to clear_node_memory_type() instead of NULL

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c           | 32 +++++---------------------------
 include/linux/memory-tiers.h | 34 ++++++++++------------------------
 mm/memory-tiers.c            | 29 +++++++++++++----------------
 3 files changed, 28 insertions(+), 67 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 2cc8749bc871..eb693a581961 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -16,13 +16,6 @@
 #include "dax-private.h"
 #include "bus.h"
 
-/*
- * Default abstract distance assigned to the NUMA node onlined
- * by DAX/kmem if the low level platform driver didn't initialize
- * one for this NUMA node.
- */
-#define MEMTIER_DEFAULT_DAX_ADISTANCE	(MEMTIER_ADISTANCE_DRAM * 5)
-
 /* Memory resource name used for add_memory_driver_managed(). */
 static const char *kmem_name;
 /* Set if any memory will remain added when the driver will be unloaded. */
@@ -47,24 +40,10 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 struct dax_kmem_data {
 	const char *res_name;
 	int mgid;
+	struct memory_dev_type *mtype;
 	struct resource *res[];
 };
 
-static DEFINE_MUTEX(kmem_memory_type_lock);
-static LIST_HEAD(kmem_memory_types);
-
-static struct memory_dev_type *kmem_find_alloc_memory_type(int adist)
-{
-	guard(mutex)(&kmem_memory_type_lock);
-	return mt_find_alloc_memory_type(adist, &kmem_memory_types);
-}
-
-static void kmem_put_memory_types(void)
-{
-	guard(mutex)(&kmem_memory_type_lock);
-	mt_put_memory_types(&kmem_memory_types);
-}
-
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -74,7 +53,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	int i, rc, mapped = 0;
 	mhp_t mhp_flags;
 	int numa_node;
-	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
+	int adist = MEMTIER_DEFAULT_LOWTIER_ADISTANCE;
 
 	/*
 	 * Ensure good NUMA information for the persistent memory.
@@ -90,7 +69,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	}
 
 	mt_calc_adistance(numa_node, &adist);
-	mtype = kmem_find_alloc_memory_type(adist);
+	mtype = mt_get_memory_type(adist);
 	if (IS_ERR(mtype))
 		return PTR_ERR(mtype);
 
@@ -189,6 +168,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		}
 		mapped++;
 	}
+	data->mtype = mtype;
 
 	dev_set_drvdata(dev, data);
 
@@ -253,7 +233,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 		 * for that. This implies this reference will be around
 		 * till next reboot.
 		 */
-		clear_node_memory_type(node, NULL);
+		clear_node_memory_type(node, data->mtype);
 	}
 }
 #else
@@ -292,7 +272,6 @@ static int __init dax_kmem_init(void)
 	return rc;
 
 error_dax_driver:
-	kmem_put_memory_types();
 	kfree_const(kmem_name);
 	return rc;
 }
@@ -302,7 +281,6 @@ static void __exit dax_kmem_exit(void)
 	dax_driver_unregister(&device_dax_kmem_driver);
 	if (!any_hotremove_failed)
 		kfree_const(kmem_name);
-	kmem_put_memory_types();
 }
 
 MODULE_AUTHOR("Intel Corporation");
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 96987d9d95a8..70fbd3ad577f 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -20,11 +20,17 @@
  */
 #define MEMTIER_ADISTANCE_DRAM	((4L * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
 
+/*
+ * Default abstract distance assigned to non-DRAM memory if the platform
+ * driver didn't initialize one for this NUMA node.
+ */
+#define MEMTIER_DEFAULT_LOWTIER_ADISTANCE	(MEMTIER_ADISTANCE_DRAM * 5)
+
 struct memory_tier;
 struct memory_dev_type {
 	/* list of memory types that are part of same tier as this type */
 	struct list_head tier_sibling;
-	/* list of memory types that are managed by one driver */
+	/* memory types on global list */
 	struct list_head list;
 	/* abstract distance for this specific memory type */
 	int adistance;
@@ -39,8 +45,6 @@ struct access_coordinate;
 extern bool numa_demotion_enabled;
 extern struct memory_dev_type *default_dram_type;
 extern nodemask_t default_dram_nodes;
-struct memory_dev_type *alloc_memory_type(int adistance);
-void put_memory_type(struct memory_dev_type *memtype);
 void init_node_memory_type(int node, struct memory_dev_type *default_type);
 void clear_node_memory_type(int node, struct memory_dev_type *memtype);
 int register_mt_adistance_algorithm(struct notifier_block *nb);
@@ -49,9 +53,7 @@ int mt_calc_adistance(int node, int *adist);
 int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 			     const char *source);
 int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
-struct memory_dev_type *mt_find_alloc_memory_type(int adist,
-						  struct list_head *memory_types);
-void mt_put_memory_types(struct list_head *memory_types);
+struct memory_dev_type *mt_get_memory_type(int adist);
 #ifdef CONFIG_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -78,18 +80,6 @@ static inline bool node_is_toptier(int node)
 #define numa_demotion_enabled	false
 #define default_dram_type	NULL
 #define default_dram_nodes	NODE_MASK_NONE
-/*
- * CONFIG_NUMA implementation returns non NULL error.
- */
-static inline struct memory_dev_type *alloc_memory_type(int adistance)
-{
-	return NULL;
-}
-
-static inline void put_memory_type(struct memory_dev_type *memtype)
-{
-
-}
 
 static inline void init_node_memory_type(int node, struct memory_dev_type *default_type)
 {
@@ -142,14 +132,10 @@ static inline int mt_perf_to_adistance(struct access_coordinate *perf, int *adis
 	return -EIO;
 }
 
-static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
-								struct list_head *memory_types)
+static inline struct memory_dev_type *mt_get_memory_type(int adist)
 {
 	return NULL;
 }
-
-static inline void mt_put_memory_types(struct list_head *memory_types)
-{
-}
 #endif	/* CONFIG_NUMA */
+
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 986f809376eb..c8f032a75249 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -38,14 +38,17 @@ struct node_memory_type_map {
 static DEFINE_MUTEX(memory_tier_lock);
 static LIST_HEAD(memory_tiers);
 /*
- * The list is used to store all memory types that are not created
- * by a device driver.
+ * The list is used to store all memory types, both auto-initialized
+ * and driver-requested.  Drivers obtain types via mt_get_memory_type().
  */
 static LIST_HEAD(default_memory_types);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 struct memory_dev_type *default_dram_type;
 nodemask_t default_dram_nodes __initdata = NODE_MASK_NONE;
 
+static struct memory_dev_type *mt_find_alloc_memory_type(int adist,
+							 struct list_head *memory_types);
+
 static const struct bus_type memory_tier_subsys = {
 	.name = "memory_tiering",
 	.dev_name = "memory_tier",
@@ -621,7 +624,7 @@ static void release_memtype(struct kref *kref)
 	kfree(memtype);
 }
 
-struct memory_dev_type *alloc_memory_type(int adistance)
+static struct memory_dev_type *alloc_memory_type(int adistance)
 {
 	struct memory_dev_type *memtype;
 
@@ -635,13 +638,11 @@ struct memory_dev_type *alloc_memory_type(int adistance)
 	kref_init(&memtype->kref);
 	return memtype;
 }
-EXPORT_SYMBOL_GPL(alloc_memory_type);
 
-void put_memory_type(struct memory_dev_type *memtype)
+static void put_memory_type(struct memory_dev_type *memtype)
 {
 	kref_put(&memtype->kref, release_memtype);
 }
-EXPORT_SYMBOL_GPL(put_memory_type);
 
 void init_node_memory_type(int node, struct memory_dev_type *memtype)
 {
@@ -670,7 +671,8 @@ void clear_node_memory_type(int node, struct memory_dev_type *memtype)
 }
 EXPORT_SYMBOL_GPL(clear_node_memory_type);
 
-struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *memory_types)
+static struct memory_dev_type *mt_find_alloc_memory_type(int adist,
+							 struct list_head *memory_types)
 {
 	struct memory_dev_type *mtype;
 
@@ -686,18 +688,13 @@ struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *m
 
 	return mtype;
 }
-EXPORT_SYMBOL_GPL(mt_find_alloc_memory_type);
 
-void mt_put_memory_types(struct list_head *memory_types)
+struct memory_dev_type *mt_get_memory_type(int adist)
 {
-	struct memory_dev_type *mtype, *mtn;
-
-	list_for_each_entry_safe(mtype, mtn, memory_types, list) {
-		list_del(&mtype->list);
-		put_memory_type(mtype);
-	}
+	guard(mutex)(&memory_tier_lock);
+	return mt_find_alloc_memory_type(adist, &default_memory_types);
 }
-EXPORT_SYMBOL_GPL(mt_put_memory_types);
+EXPORT_SYMBOL_GPL(mt_get_memory_type);
 
 /*
  * This is invoked via `late_initcall()` to initialize memory tiers for
-- 
2.53.0

