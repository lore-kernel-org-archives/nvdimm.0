Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0CB0621A04823
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 14:17:15 -0700 (PDT)
Subject: [PATCH] libnvdimm: fix clear poison locking with spinlock and mempool
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 11 Apr 2017 14:17:03 -0700
Message-ID: <149194542385.32517.16332902766093858868.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The following warning results from holding a lane spinlock,
preempt_disable(), or the btt map spinlock and then trying to take the
reconfig_mutex to walk the poison list and potentially add new entries.

BUG: sleeping function called from invalid context at kernel/locking/mutex.
c:747
in_atomic(): 1, irqs_disabled(): 0, pid: 17159, name: dd
[..]
Call Trace:
dump_stack+0x85/0xc8
___might_sleep+0x184/0x250
__might_sleep+0x4a/0x90
__mutex_lock+0x58/0x9b0
? nvdimm_bus_lock+0x21/0x30 [libnvdimm]
? __nvdimm_bus_badblocks_clear+0x2f/0x60 [libnvdimm]
? acpi_nfit_forget_poison+0x79/0x80 [nfit]
? _raw_spin_unlock+0x27/0x40
mutex_lock_nested+0x1b/0x20
nvdimm_bus_lock+0x21/0x30 [libnvdimm]
nvdimm_forget_poison+0x25/0x50 [libnvdimm]
nvdimm_clear_poison+0x106/0x140 [libnvdimm]
nsio_rw_bytes+0x164/0x270 [libnvdimm]
btt_write_pg+0x1de/0x3e0 [nd_btt]
? blk_queue_enter+0x30/0x290
btt_make_request+0x11a/0x310 [nd_btt]
? blk_queue_enter+0xb7/0x290
? blk_queue_enter+0x30/0x290
generic_make_request+0x118/0x3b0

Two things are done to address this issue. First, we introduce a spinlock to
protect the poison list. This allows us to not having to acquire the
reconfig_mutex for touching the poison list. Second, we introduce a mempool
for the poison list entry allocation. This provides a pool of entries we can
allocate from. Once we run out, we will acquire entries via GFP_NOWAIT to
avoid the sleep with GFP_KERNEL allocation.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/bus.c      |   16 ++++++++-----
 drivers/nvdimm/core.c     |   56 +++++++++++++++++++++++++++------------------
 drivers/nvdimm/nd-core.h  |    1 +
 include/linux/libnvdimm.h |    2 --
 4 files changed, 45 insertions(+), 30 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 5ad2e59..dc9b403 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -24,6 +24,7 @@
 #include <linux/fs.h>
 #include <linux/io.h>
 #include <linux/mm.h>
+#include <linux/mempool.h>
 #include <linux/nd.h>
 #include "nd-core.h"
 #include "nd.h"
@@ -33,6 +34,7 @@ int nvdimm_major;
 static int nvdimm_bus_major;
 static struct class *nd_class;
 static DEFINE_IDA(nd_ida);
+extern mempool_t *poison_mempool;
 
 static int to_nd_device_type(struct device *dev)
 {
@@ -296,6 +298,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 	init_waitqueue_head(&nvdimm_bus->probe_wait);
 	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
 	mutex_init(&nvdimm_bus->reconfig_mutex);
+	spin_lock_init(&nvdimm_bus->poison_lock);
 	if (nvdimm_bus->id < 0) {
 		kfree(nvdimm_bus);
 		return NULL;
@@ -342,13 +345,14 @@ static int child_unregister(struct device *dev, void *data)
 	return 0;
 }
 
-static void free_poison_list(struct list_head *poison_list)
+static void free_poison_list(struct nvdimm_bus *nvdimm_bus)
 {
+	struct list_head *poison_list = &nvdimm_bus->poison_list;
 	struct nd_poison *pl, *next;
 
 	list_for_each_entry_safe(pl, next, poison_list, list) {
 		list_del(&pl->list);
-		kfree(pl);
+		mempool_free(pl, poison_mempool);
 	}
 	list_del_init(poison_list);
 }
@@ -364,9 +368,9 @@ static int nd_bus_remove(struct device *dev)
 	nd_synchronize();
 	device_for_each_child(&nvdimm_bus->dev, NULL, child_unregister);
 
-	nvdimm_bus_lock(&nvdimm_bus->dev);
-	free_poison_list(&nvdimm_bus->poison_list);
-	nvdimm_bus_unlock(&nvdimm_bus->dev);
+	spin_lock(&nvdimm_bus->poison_lock);
+	free_poison_list(nvdimm_bus);
+	spin_unlock(&nvdimm_bus->poison_lock);
 
 	nvdimm_bus_destroy_ndctl(nvdimm_bus);
 
@@ -990,7 +994,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 
 		if (clear_err->cleared) {
 			/* clearing the poison list we keep track of */
-			__nvdimm_forget_poison(nvdimm_bus, clear_err->address,
+			nvdimm_forget_poison(nvdimm_bus, clear_err->address,
 					clear_err->cleared);
 
 			/* now sync the badblocks lists */
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 40a3da0..8475578 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -21,11 +21,15 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/io.h>
+#include <linux/mempool.h>
 #include "nd-core.h"
 #include "nd.h"
 
 LIST_HEAD(nvdimm_bus_list);
 DEFINE_MUTEX(nvdimm_bus_list_mutex);
+struct kmem_cache *poison_cache;
+mempool_t *poison_mempool;
+
 
 void nvdimm_bus_lock(struct device *dev)
 {
@@ -518,12 +522,11 @@ void nvdimm_badblocks_populate(struct nd_region *nd_region,
 }
 EXPORT_SYMBOL_GPL(nvdimm_badblocks_populate);
 
-static int add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length,
-			gfp_t flags)
+static int add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 {
 	struct nd_poison *pl;
 
-	pl = kzalloc(sizeof(*pl), flags);
+	pl = mempool_alloc(poison_mempool, GFP_NOWAIT);
 	if (!pl)
 		return -ENOMEM;
 
@@ -539,7 +542,7 @@ static int bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 	struct nd_poison *pl;
 
 	if (list_empty(&nvdimm_bus->poison_list))
-		return add_poison(nvdimm_bus, addr, length, GFP_KERNEL);
+		return add_poison(nvdimm_bus, addr, length);
 
 	/*
 	 * There is a chance this is a duplicate, check for those first.
@@ -559,30 +562,29 @@ static int bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 	 * as any overlapping ranges will get resolved when the list is consumed
 	 * and converted to badblocks
 	 */
-	return add_poison(nvdimm_bus, addr, length, GFP_KERNEL);
+	return add_poison(nvdimm_bus, addr, length);
 }
 
 int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 {
 	int rc;
 
-	nvdimm_bus_lock(&nvdimm_bus->dev);
+	spin_lock(&nvdimm_bus->poison_lock);
 	rc = bus_add_poison(nvdimm_bus, addr, length);
-	nvdimm_bus_unlock(&nvdimm_bus->dev);
+	spin_unlock(&nvdimm_bus->poison_lock);
 
 	return rc;
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_add_poison);
 
-void __nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus, phys_addr_t start,
+void nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus, phys_addr_t start,
 		unsigned int len)
 {
 	struct list_head *poison_list = &nvdimm_bus->poison_list;
 	u64 clr_end = start + len - 1;
 	struct nd_poison *pl, *next;
 
-	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
-
+	spin_lock(&nvdimm_bus->poison_lock);
 	WARN_ON_ONCE(list_empty(poison_list));
 
 	/*
@@ -604,7 +606,7 @@ void __nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus, phys_addr_t start,
 		/* Delete completely overlapped poison entries */
 		if ((pl->start >= start) && (pl_end <= clr_end)) {
 			list_del(&pl->list);
-			kfree(pl);
+			mempool_free(pl, poison_mempool);
 			continue;
 		}
 		/* Adjust start point of partially cleared entries */
@@ -629,21 +631,13 @@ void __nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus, phys_addr_t start,
 			u64 new_len = pl_end - new_start + 1;
 
 			/* Add new entry covering the right half */
-			add_poison(nvdimm_bus, new_start, new_len, GFP_NOIO);
+			add_poison(nvdimm_bus, new_start, new_len);
 			/* Adjust this entry to cover the left half */
 			pl->length = start - pl->start;
 			continue;
 		}
 	}
-}
-EXPORT_SYMBOL_GPL(__nvdimm_forget_poison);
-
-void nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus,
-		phys_addr_t start, unsigned int len)
-{
-	nvdimm_bus_lock(&nvdimm_bus->dev);
-	__nvdimm_forget_poison(nvdimm_bus, start, len);
-	nvdimm_bus_unlock(&nvdimm_bus->dev);
+	spin_unlock(&nvdimm_bus->poison_lock);
 }
 EXPORT_SYMBOL_GPL(nvdimm_forget_poison);
 
@@ -680,9 +674,21 @@ static __init int libnvdimm_init(void)
 {
 	int rc;
 
+	poison_cache = kmem_cache_create("nvdimm_bus_poison",
+			sizeof(struct nd_poison), 0,
+			SLAB_HWCACHE_ALIGN, NULL);
+	if (!poison_cache)
+		return -ENOMEM;
+
+	poison_mempool = mempool_create_slab_pool(SZ_4K, poison_cache);
+	if (!poison_mempool) {
+		rc =  -ENOMEM;
+		goto err_mempool;
+	}
+
 	rc = nvdimm_bus_init();
 	if (rc)
-		return rc;
+		goto err_bus;
 	rc = nvdimm_init();
 	if (rc)
 		goto err_dimm;
@@ -694,6 +700,10 @@ static __init int libnvdimm_init(void)
 	nvdimm_exit();
  err_dimm:
 	nvdimm_bus_exit();
+ err_bus:
+	mempool_destroy(poison_mempool);
+ err_mempool:
+	kmem_cache_destroy(poison_cache);
 	return rc;
 }
 
@@ -705,6 +715,8 @@ static __exit void libnvdimm_exit(void)
 	nvdimm_bus_exit();
 	nd_region_devs_exit();
 	nvdimm_devs_exit();
+	mempool_destroy(poison_mempool);
+	kmem_cache_destroy(poison_cache);
 }
 
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 8623e57..4c4bd20 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -32,6 +32,7 @@ struct nvdimm_bus {
 	struct list_head poison_list;
 	struct list_head mapping_list;
 	struct mutex reconfig_mutex;
+	spinlock_t poison_lock;
 };
 
 struct nvdimm {
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 1c609e8..98b2076 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -122,8 +122,6 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
 int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length);
 void nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus,
 		phys_addr_t start, unsigned int len);
-void __nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus,
-		phys_addr_t start, unsigned int len);
 struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nfit_desc);
 void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
