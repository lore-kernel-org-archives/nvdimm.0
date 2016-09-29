Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14E101A1E48
 for <linux-nvdimm@lists.01.org>; Wed, 28 Sep 2016 17:11:04 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 3/3] libnvdimm: clear the internal poison_list when clearing
 badblocks
Date: Wed, 28 Sep 2016 18:10:11 -0600
Message-Id: <1475107811-8880-4-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1475107811-8880-1-git-send-email-vishal.l.verma@intel.com>
References: <1475107811-8880-1-git-send-email-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

nvdimm_clear_poison cleared the user-visible badblocks, and sent
commands to the NVDIMM to clear the areas marked as 'poison', but it
neglected to clear the same areas from the internal poison_list which is
used to marshal ARS results before sorting them by namespace. As a
result, once on-demand ARS functionality was added:

37b137f nfit, libnvdimm: allow an ARS scrub to be triggered on demand

A scrub triggered from either sysfs or an MCE was found to be adding
stale entries that had been cleared from gendisk->badblocks, but were
still present in nvdimm_bus->poison_list.

This adds the missing step of clearing poison_list entries when clearing
poison, so that it is in sync with badblocks.

Fixes: 37b137f nfit, libnvdimm: allow an ARS scrub to be triggered on demand
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/bus.c      |  2 ++
 drivers/nvdimm/core.c     | 73 ++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/libnvdimm.h |  2 ++
 3 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 935866f..a8b6949 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -217,6 +217,8 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 		return rc;
 	if (cmd_rc < 0)
 		return cmd_rc;
+
+	nvdimm_clear_from_poison_list(nvdimm_bus, phys, len);
 	return clear_err.cleared;
 }
 EXPORT_SYMBOL_GPL(nvdimm_clear_poison);
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 715583f..42e40db 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -541,11 +541,12 @@ void nvdimm_badblocks_populate(struct nd_region *nd_region,
 }
 EXPORT_SYMBOL_GPL(nvdimm_badblocks_populate);
 
-static int add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
+static int add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length,
+			gfp_t flags)
 {
 	struct nd_poison *pl;
 
-	pl = kzalloc(sizeof(*pl), GFP_KERNEL);
+	pl = kzalloc(sizeof(*pl), flags);
 	if (!pl)
 		return -ENOMEM;
 
@@ -561,7 +562,7 @@ static int bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 	struct nd_poison *pl;
 
 	if (list_empty(&nvdimm_bus->poison_list))
-		return add_poison(nvdimm_bus, addr, length);
+		return add_poison(nvdimm_bus, addr, length, GFP_KERNEL);
 
 	/*
 	 * There is a chance this is a duplicate, check for those first.
@@ -581,7 +582,7 @@ static int bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 	 * as any overlapping ranges will get resolved when the list is consumed
 	 * and converted to badblocks
 	 */
-	return add_poison(nvdimm_bus, addr, length);
+	return add_poison(nvdimm_bus, addr, length, GFP_KERNEL);
 }
 
 int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
@@ -596,6 +597,70 @@ int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_add_poison);
 
+void nvdimm_clear_from_poison_list(struct nvdimm_bus *nvdimm_bus,
+		phys_addr_t start, unsigned int len)
+{
+	struct list_head *poison_list = &nvdimm_bus->poison_list;
+	u64 clr_end = start + len - 1;
+	struct nd_poison *pl, *next;
+
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	WARN_ON_ONCE(list_empty(poison_list));
+
+	/*
+	 * [start, clr_end] is the poison interval being cleared.
+	 * [pl->start, pl_end] is the poison_list entry we're comparing
+	 * the above interval against. The poison list entry may need
+	 * to be modified (update either start or length), deleted, or
+	 * split into two based on the overlap characteristics
+	 */
+
+	list_for_each_entry_safe(pl, next, poison_list, list) {
+		u64 pl_end = pl->start + pl->length - 1;
+
+		/* Skip intervals with no intersection */
+		if (pl_end < start)
+			continue;
+		if (pl->start >  clr_end)
+			continue;
+		/* Delete completely overlapped poison entries */
+		if ((pl->start >= start) && (pl_end <= clr_end)) {
+			list_del(&pl->list);
+			kfree(pl);
+			continue;
+		}
+		/* Adjust start point of partially cleared entries */
+		if ((start <= pl->start) && (clr_end > pl->start)) {
+			pl->length -= clr_end - pl->start + 1;
+			pl->start = clr_end + 1;
+			continue;
+		}
+		/* Adjust pl->length for partial clearing at the tail end */
+		if ((pl->start < start) && (pl_end <= clr_end)) {
+			/* pl->start remains the same */
+			pl->length = start - pl->start;
+			continue;
+		}
+		/*
+		 * If clearing in the middle of an entry, we split it into
+		 * two by modifying the current entry to represent one half of
+		 * the split, and adding a new entry for the second half.
+		 */
+		if ((pl->start < start) && (pl_end > clr_end)) {
+			u64 new_start = clr_end + 1;
+			u64 new_len = pl_end - new_start + 1;
+
+			/* Add new entry covering the right half */
+			add_poison(nvdimm_bus, new_start, new_len, GFP_NOIO);
+			/* Adjust this entry to cover the left half */
+			pl->length = start - pl->start;
+			continue;
+		}
+	}
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+}
+EXPORT_SYMBOL_GPL(nvdimm_clear_from_poison_list);
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 int nd_integrity_init(struct gendisk *disk, unsigned long meta_size)
 {
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index b519e13..bbfce62 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -129,6 +129,8 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
 }
 
 int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length);
+void nvdimm_clear_from_poison_list(struct nvdimm_bus *nvdimm_bus,
+		phys_addr_t start, unsigned int len);
 struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nfit_desc);
 void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
