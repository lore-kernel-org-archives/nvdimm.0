Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE5E221E2DA60
 for <linux-nvdimm@lists.01.org>; Tue, 22 Aug 2017 15:18:39 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v6 6/6] libnvdimm, btt: rework error clearing
Date: Tue, 22 Aug 2017 16:19:15 -0600
Message-Id: <20170822221915.1732-7-vishal.l.verma@intel.com>
In-Reply-To: <20170822221915.1732-1-vishal.l.verma@intel.com>
References: <20170822221915.1732-1-vishal.l.verma@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Clearing errors or badblocks during a BTT write requires sending an ACPI
DSM, which means potentially sleeping. Since a BTT IO happens in atomic
context (preemption disabled, spinlocks may be held), we cannot perform
error clearing in the course of an IO. Due to this error clearing for
BTT IOs has hitherto been disabled.

In this patch we move error clearing out of the atomic section, and thus
re-enable error clearing with BTTs. When we are about to add a block to
the free list, we check if it was previously marked as an error, and if
it was, we add it to the freelist, but also set a flag that says error
clearing will be required. We then drop the lane (ending the atomic
context), and send a zero buffer so that the error can be cleared. The
error flag in the free list is protected by the nd 'lane', and is set
only be a thread while it holds that lane. When the error is cleared,
the flag is cleared, but while holding a mutex for that freelist index.

When writing, we check for two things -
1/ If the freelist mutex is held or if the error flag is set. If so,
this is an error block that is being (or about to be) cleared.
2/ If the block is a known badblock based on nsio->bb

The second check is required because the BTT map error flag for a map
entry only gets set when an error LBA is read. If we write to a new
location that may not have the map error flag set, but still might be in
the region's badblock list, we can trigger an EIO on the write, which is
undesirable and completely avoidable.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c   | 109 ++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/nvdimm/btt.h   |   5 +++
 drivers/nvdimm/claim.c |   8 ----
 3 files changed, 103 insertions(+), 19 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index e9dd651..f5cbd60 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -31,6 +31,11 @@ enum log_ent_request {
 	LOG_OLD_ENT
 };
 
+static u64 adjust_initial_offset(struct nd_btt *nd_btt, u64 offset)
+{
+	return offset + nd_btt->initial_offset;
+}
+
 static int arena_read_bytes(struct arena_info *arena, resource_size_t offset,
 		void *buf, size_t n, unsigned long flags)
 {
@@ -38,7 +43,7 @@ static int arena_read_bytes(struct arena_info *arena, resource_size_t offset,
 	struct nd_namespace_common *ndns = nd_btt->ndns;
 
 	/* arena offsets may be shifted from the base of the device */
-	offset += arena->nd_btt->initial_offset;
+	offset = adjust_initial_offset(nd_btt, offset);
 	return nvdimm_read_bytes(ndns, offset, buf, n, flags);
 }
 
@@ -49,7 +54,7 @@ static int arena_write_bytes(struct arena_info *arena, resource_size_t offset,
 	struct nd_namespace_common *ndns = nd_btt->ndns;
 
 	/* arena offsets may be shifted from the base of the device */
-	offset += arena->nd_btt->initial_offset;
+	offset = adjust_initial_offset(nd_btt, offset);
 	return nvdimm_write_bytes(ndns, offset, buf, n, flags);
 }
 
@@ -381,7 +386,9 @@ static int btt_flog_write(struct arena_info *arena, u32 lane, u32 sub,
 	arena->freelist[lane].sub = 1 - arena->freelist[lane].sub;
 	if (++(arena->freelist[lane].seq) == 4)
 		arena->freelist[lane].seq = 1;
-	arena->freelist[lane].block = le32_to_cpu(ent->old_map);
+	if (ent_e_flag(ent->old_map))
+		arena->freelist[lane].has_err = 1;
+	arena->freelist[lane].block = le32_to_cpu(ent_lba(ent->old_map));
 
 	return ret;
 }
@@ -480,6 +487,40 @@ static int btt_log_init(struct arena_info *arena)
 	return ret;
 }
 
+static u64 to_namespace_offset(struct arena_info *arena, u64 lba)
+{
+	return arena->dataoff + ((u64)lba * arena->internal_lbasize);
+}
+
+static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
+{
+	int ret = 0;
+
+	if (arena->freelist[lane].has_err) {
+		void *zero_page = page_address(ZERO_PAGE(0));
+		u32 lba = arena->freelist[lane].block;
+		u64 nsoff = to_namespace_offset(arena, lba);
+		unsigned long len = arena->sector_size;
+
+		mutex_lock(&arena->err_lock);
+
+		while (len) {
+			unsigned long chunk = min(len, PAGE_SIZE);
+
+			ret = arena_write_bytes(arena, nsoff, zero_page,
+				chunk, 0);
+			if (ret)
+				break;
+			len -= chunk;
+			nsoff += chunk;
+			if (len == 0)
+				arena->freelist[lane].has_err = 0;
+		}
+		mutex_unlock(&arena->err_lock);
+	}
+	return ret;
+}
+
 static int btt_freelist_init(struct arena_info *arena)
 {
 	int old, new, ret;
@@ -505,6 +546,9 @@ static int btt_freelist_init(struct arena_info *arena)
 		arena->freelist[i].seq = nd_inc_seq(le32_to_cpu(log_new.seq));
 		arena->freelist[i].block = le32_to_cpu(log_new.old_map);
 
+		if (ent_e_flag(log_new.old_map))
+			arena_clear_freelist_error(arena, i);
+
 		/* This implies a newly created or untouched flog entry */
 		if (log_new.old_map == log_new.new_map)
 			continue;
@@ -525,7 +569,6 @@ static int btt_freelist_init(struct arena_info *arena)
 			if (ret)
 				return ret;
 		}
-
 	}
 
 	return 0;
@@ -695,6 +738,7 @@ static int discover_arenas(struct btt *btt)
 		arena->external_lba_start = cur_nlba;
 		parse_arena_meta(arena, super, cur_off);
 
+		mutex_init(&arena->err_lock);
 		ret = btt_freelist_init(arena);
 		if (ret)
 			goto out;
@@ -905,11 +949,6 @@ static void unlock_map(struct arena_info *arena, u32 premap)
 	spin_unlock(&arena->map_locks[idx].lock);
 }
 
-static u64 to_namespace_offset(struct arena_info *arena, u64 lba)
-{
-	return arena->dataoff + ((u64)lba * arena->internal_lbasize);
-}
-
 static int btt_data_read(struct arena_info *arena, struct page *page,
 			unsigned int off, u32 lba, u32 len)
 {
@@ -1067,8 +1106,14 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
 		}
 
 		ret = btt_data_read(arena, page, off, postmap, cur_len);
-		if (ret)
+		if (ret) {
+			int rc;
+
+			/* Media error - set the e_flag */
+			rc = btt_map_write(arena, premap, postmap, 0, 1,
+				NVDIMM_IO_ATOMIC);
 			goto out_rtt;
+		}
 
 		if (bip) {
 			ret = btt_rw_integrity(btt, bip, arena, postmap, READ);
@@ -1093,6 +1138,21 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
 	return ret;
 }
 
+/*
+ * Normally, arena_{read,write}_bytes will take care of the initial offset
+ * adjustment, but in the case of btt_is_badblock, where we query is_bad_pmem,
+ * we need the final, raw namespace offset here
+ */
+static bool btt_is_badblock(struct btt *btt, struct arena_info *arena,
+		u32 postmap)
+{
+	u64 nsoff = adjust_initial_offset(arena->nd_btt,
+			to_namespace_offset(arena, postmap));
+	sector_t phys_sector = nsoff >> 9;
+
+	return is_bad_pmem(btt->phys_bb, phys_sector, arena->internal_lbasize);
+}
+
 static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 			sector_t sector, struct page *page, unsigned int off,
 			unsigned int len)
@@ -1105,7 +1165,9 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 
 	while (len) {
 		u32 cur_len;
+		int e_flag;
 
+ retry:
 		lane = nd_region_acquire_lane(btt->nd_region);
 
 		ret = lba_to_arena(btt, sector, &premap, &arena);
@@ -1118,6 +1180,23 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 			goto out_lane;
 		}
 
+		/* The block had a media error, and is being cleared */
+		if (mutex_is_locked(&arena->err_lock)
+				|| arena->freelist[lane].has_err) {
+			nd_region_release_lane(btt->nd_region, lane);
+			goto retry;
+		}
+
+		/* The block had a media error, and needs to be cleared */
+		if (btt_is_badblock(btt, arena, arena->freelist[lane].block)) {
+			arena->freelist[lane].has_err = 1;
+			nd_region_release_lane(btt->nd_region, lane);
+
+			arena_clear_freelist_error(arena, lane);
+			/* OK to acquire a different lane/free block */
+			goto retry;
+		}
+
 		new_postmap = arena->freelist[lane].block;
 
 		/* Wait if the new block is being read from */
@@ -1143,7 +1222,7 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 		}
 
 		lock_map(arena, premap);
-		ret = btt_map_read(arena, premap, &old_postmap, NULL, NULL,
+		ret = btt_map_read(arena, premap, &old_postmap, NULL, &e_flag,
 				NVDIMM_IO_ATOMIC);
 		if (ret)
 			goto out_map;
@@ -1151,6 +1230,8 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 			ret = -EIO;
 			goto out_map;
 		}
+		if (e_flag)
+			set_e_flag(old_postmap);
 
 		log.lba = cpu_to_le32(premap);
 		log.old_map = cpu_to_le32(old_postmap);
@@ -1169,6 +1250,9 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 		unlock_map(arena, premap);
 		nd_region_release_lane(btt->nd_region, lane);
 
+		if (e_flag)
+			arena_clear_freelist_error(arena, lane);
+
 		len -= cur_len;
 		off += cur_len;
 		sector += btt->sector_size >> SECTOR_SHIFT;
@@ -1349,6 +1433,7 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 {
 	int ret;
 	struct btt *btt;
+	struct nd_namespace_io *nsio;
 	struct device *dev = &nd_btt->dev;
 
 	btt = devm_kzalloc(dev, sizeof(struct btt), GFP_KERNEL);
@@ -1362,6 +1447,8 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 	INIT_LIST_HEAD(&btt->arena_list);
 	mutex_init(&btt->init_lock);
 	btt->nd_region = nd_region;
+	nsio = to_nd_namespace_io(&nd_btt->ndns->dev);
+	btt->phys_bb = &nsio->bb;
 
 	ret = discover_arenas(btt);
 	if (ret) {
diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
index 2bc0d10b..578c205 100644
--- a/drivers/nvdimm/btt.h
+++ b/drivers/nvdimm/btt.h
@@ -15,6 +15,7 @@
 #ifndef _LINUX_BTT_H
 #define _LINUX_BTT_H
 
+#include <linux/badblocks.h>
 #include <linux/types.h>
 
 #define BTT_SIG_LEN 16
@@ -41,6 +42,7 @@
 #define ent_lba(ent) (ent & MAP_LBA_MASK)
 #define ent_e_flag(ent) (!!(ent & MAP_ERR_MASK))
 #define ent_z_flag(ent) (!!(ent & MAP_TRIM_MASK))
+#define set_e_flag(ent) (ent |= MAP_ERR_MASK)
 
 enum btt_init_state {
 	INIT_UNCHECKED = 0,
@@ -82,6 +84,7 @@ struct free_entry {
 	u32 block;
 	u8 sub;
 	u8 seq;
+	u8 has_err;
 };
 
 struct aligned_lock {
@@ -153,6 +156,7 @@ struct arena_info {
 	struct dentry *debugfs_dir;
 	/* Arena flags */
 	u32 flags;
+	struct mutex err_lock;
 };
 
 /**
@@ -187,6 +191,7 @@ struct btt {
 	struct mutex init_lock;
 	int init_state;
 	int num_arenas;
+	struct badblocks *phys_bb;
 };
 
 bool nd_btt_arena_is_valid(struct nd_btt *nd_btt, struct btt_sb *super);
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 3e6404f..b2fc29b 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -280,14 +280,6 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 	}
 
 	if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
-		/*
-		 * FIXME: nsio_rw_bytes() may be called from atomic
-		 * context in the btt case and the ACPI DSM path for
-		 * clearing the error takes sleeping locks and allocates
-		 * memory. An explicit error clearing path, and support
-		 * for tracking badblocks in BTT metadata is needed to
-		 * work around this collision.
-		 */
 		if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)
 				&& !(flags & NVDIMM_IO_ATOMIC)) {
 			long cleared;
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
