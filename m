Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DE33D7C
	for <nvdimm@lists.linux.dev>; Thu, 30 Jun 2022 13:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656596543; x=1688132543;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9gVHeF0MVQHsnI7u9OePiX5VHPzODaP4jxNsxOYOHks=;
  b=eeQinGJCkv76vtcyljN9eW6FY5ETKKwA3r3muo2Ez8k027JwPCw1ZWAX
   kCyFbXDjs9mf+/Y3l4CwwS5Yx82JnMgtUSq5EBt2oc9+Fmkqx7vyDUokb
   frPSfwJKl85CHKswuoWf+W5Wqix3yxPvt9kzbs7ACQuGpGuhU3yg6fQvB
   JqScmrJh76jx5fLL7VPYNEA3jVnEbGAq3bh6zTazW6j3axZSmRYJHyjTc
   HP05f0tctVEJGgVtsVwO88d7I7xryD5zpFDaf4IuOifru3xtWFgnaQAOX
   K/RaDw5sqc1oXoP/MuLq5RDZPJ/bF+dZ9uHvQecgdp7FKu4GeKxwSIRZg
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="271118395"
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="271118395"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 06:42:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="733635947"
Received: from ac02.sh.intel.com ([10.112.227.141])
  by fmsmga001.fm.intel.com with ESMTP; 30 Jun 2022 06:42:21 -0700
From: "dennis.wu" <dennis.wu@intel.com>
To: nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	dan.j.williams@intel.com,
	dave.jiang@intel.com,
	"dennis.wu" <dennis.wu@intel.com>
Subject: [PATCH] BTT: Use dram freelist and remove bflog to otpimize perf
Date: Thu, 30 Jun 2022 21:42:44 +0800
Message-Id: <20220630134244.685331-1-dennis.wu@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dependency:
[PATCH] nvdimm: Add NVDIMM_NO_DEEPFLUSH flag to control btt
data deepflush
https://lore.kernel.org/nvdimm/20220629135801.192821-1-dennis.wu@intel.com/T/#u

Reason:
In BTT, each write will write sector data, update 4 bytes btt_map
entry and update 16 bytes bflog (two 8 bytes atomic write),the
meta data write overhead is big and we can optimize the algorithm
and not use the bflog. Then each write, we will update the sector
data and then 4 bytes btt_map entry.

How:
1. scan the btt_map to generate the aba mapping bitmap, if one
internal aba used, the bit will be set.
2. generate the in-memory freelist according the aba bitmap, the
freelist is a array that records all the free ABAs like:
| 340 | 422 | 578 |...
that means ABA 340, 422, 578 are free. The last nfree(nlane)
records in the array will be used for each lane at the beginning.
3. Get a free ABA of a lane, write data to the ABA. If the premap
btt_map entry is initialization state (e_flag=0, z_flag=0), get
an free ABA from the free ABA array for the lane. If the premap
btt_map entry is not in initialization state, the ABA in the
btt_map entry will be looked as the free ABA of the lane.Once
the free ABAs = nfree that means the arena is fully written and
we can free the whole freelist (not implimented yet).
4. In the code, "version_major ==2" is the new algorithm and
the logic in else is the old algorithm.

Result:
1. The write performance can improve ~50% and the latency also
reduce to 60% of origial algorithm.
2. During initialization, scan btt_map and generate the freelist
will take time and lead namespace enable longer. With 4K sector,
1TB namespace, the enable time less than 4s. This will only happen
once during initalization.
3. Take 4 bytes per sector memory to store the freelist. But once
the arena fully written, the freelist can be freed. As we know,in
the storage case, the disk always be fully written for usage, then
we don't have memory space overhead.

Compatablity:
1. The new algorithm keep the layout of bflog, only ignore its
logic, that means no update during new algorithm.
2. If a namespace create with old algorithm and layout, you can
switch to the new algorithm seamless w/o any specific operation.
3. Since the bflog will not be updated if you move to the new
algorithm. After you write data with the new algorithmyou, you
can't switch back from the new algorithm to old algorithm.

Signed-off-by: dennis.wu <dennis.wu@intel.com>
---
 drivers/nvdimm/btt.c | 231 ++++++++++++++++++++++++++++++++++---------
 drivers/nvdimm/btt.h |  15 +++
 2 files changed, 199 insertions(+), 47 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index c71ba7a1edd0..1d75e5f4d88e 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -70,10 +70,6 @@ static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
 	dev_WARN_ONCE(to_dev(arena), !IS_ALIGNED(arena->info2off, 512),
 		"arena->info2off: %#llx is unaligned\n", arena->info2off);
 
-	/*
-	 * btt_sb is critial information and need proper write
-	 * nvdimm_flush will be called (deepflush)
-	 */
 	ret = arena_write_bytes(arena, arena->info2off, super,
 			sizeof(struct btt_sb), 0);
 	if (ret)
@@ -194,6 +190,8 @@ static int btt_map_read(struct arena_info *arena, u32 lba, u32 *mapping,
 		break;
 	case 3:
 		*mapping = postmap;
+		z_flag = 1;
+		e_flag = 1;
 		break;
 	default:
 		return -EIO;
@@ -507,6 +505,30 @@ static u64 to_namespace_offset(struct arena_info *arena, u64 lba)
 	return arena->dataoff + ((u64)lba * arena->internal_lbasize);
 }
 
+static int arena_clear_error(struct arena_info *arena, u32 lba)
+{
+	int ret = 0;
+
+	void *zero_page = page_address(ZERO_PAGE(0));
+	u64 nsoff = to_namespace_offset(arena, lba);
+	unsigned long len = arena->sector_size;
+
+	mutex_lock(&arena->err_lock);
+	while (len) {
+		unsigned long chunk = min(len, PAGE_SIZE);
+
+		ret = arena_write_bytes(arena, nsoff, zero_page,
+			chunk, 0);
+		if (ret)
+			break;
+		len -= chunk;
+		nsoff += chunk;
+	}
+	mutex_unlock(&arena->err_lock);
+
+	return ret;
+}
+
 static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
 {
 	int ret = 0;
@@ -536,6 +558,82 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
 	return ret;
 }
 
+/*
+ * get_aba_in_a_lane - get a free block out of the freelist.
+ * @arena: arena handler
+ * @lane:	the block (postmap) will be put back to free array list
+ */
+static inline void get_lane_aba(struct arena_info *arena,
+		u32 lane, u32 *entry)
+{
+	uint32_t free_num;
+
+	spin_lock(&(arena->list_lock.lock));
+	free_num = arena->freezone_array.free_num;
+	arena->lane_free[lane] = arena->freezone_array.free_array[free_num - 1];
+	arena->freezone_array.free_num = free_num - 1;
+	spin_unlock(&(arena->list_lock.lock));
+
+	*entry = arena->lane_free[lane];
+}
+
+static int btt_freezone_init(struct arena_info *arena)
+{
+	int ret = 0, trim, err;
+	u32 i;
+	u32 mapping;
+	u8 *aba_map_byte, *aba_map;
+	u32 *free_array;
+	u32 free_num = 0;
+	u32 aba_map_size = (arena->internal_nlba>>3) + 1;
+
+	aba_map = vzalloc(aba_map_size);
+	if (!aba_map)
+		return -ENOMEM;
+
+	/*
+	 * prepare the aba_map, each aba will be in a bit, occupied bit=1, free bit=0
+	 * the scan will take times, but it is only once execution during initialization.
+	 */
+	for (i = 0; i < arena->external_nlba; i++) {
+		ret = btt_map_read(arena, i, &mapping, &trim, &err, 0);
+		if (ret || (trim == 0 && err == 0))
+			continue;
+		if (mapping < arena->internal_nlba) {
+			aba_map_byte = aba_map + (mapping>>3);
+			*aba_map_byte |= (u8)(1<<(mapping % 8));
+		}
+	}
+
+	/*
+	 * Scan the aba_bitmap , use the static array, that will take 1% memory.
+	 */
+	free_array = vmalloc(arena->internal_nlba*sizeof(u32));
+	if (!free_array) {
+		vfree(aba_map);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < arena->internal_nlba; i++) {
+		aba_map_byte = aba_map + (i>>3);
+		if (((*aba_map_byte) & (1<<(i%8))) == 0) {
+			free_array[free_num] = i;
+			free_num++;
+		}
+	}
+	spin_lock_init(&(arena->list_lock.lock));
+
+	for (i = 0; i < arena->nfree; i++) {
+		arena->lane_free[i] = free_array[free_num - 1];
+		free_num--;
+	}
+	arena->freezone_array.free_array = free_array;
+	arena->freezone_array.free_num = free_num;
+
+	vfree(aba_map);
+	return ret;
+}
+
 static int btt_freelist_init(struct arena_info *arena)
 {
 	int new, ret;
@@ -597,8 +695,7 @@ static int btt_freelist_init(struct arena_info *arena)
 			 * to complete the map write. So fix up the map.
 			 */
 			ret = btt_map_write(arena, le32_to_cpu(log_new.lba),
-					le32_to_cpu(log_new.new_map), 0, 0,
-					NVDIMM_NO_DEEPFLUSH);
+					le32_to_cpu(log_new.new_map), 0, 0, NVDIMM_NO_DEEPFLUSH);
 			if (ret)
 				return ret;
 		}
@@ -813,7 +910,12 @@ static void free_arenas(struct btt *btt)
 		list_del(&arena->list);
 		kfree(arena->rtt);
 		kfree(arena->map_locks);
-		kfree(arena->freelist);
+		if (arena->version_major == 2) {
+			if (arena->freezone_array.free_array)
+				vfree(arena->freezone_array.free_array);
+		} else {
+			kfree(arena->freelist);
+		}
 		debugfs_remove_recursive(arena->debugfs_dir);
 		kfree(arena);
 	}
@@ -892,14 +994,18 @@ static int discover_arenas(struct btt *btt)
 		arena->external_lba_start = cur_nlba;
 		parse_arena_meta(arena, super, cur_off);
 
-		ret = log_set_indices(arena);
-		if (ret) {
-			dev_err(to_dev(arena),
-				"Unable to deduce log/padding indices\n");
-			goto out;
-		}
+		if (arena->version_major == 2) {
+			ret = btt_freezone_init(arena);
+		} else {
+			ret = log_set_indices(arena);
+			if (ret) {
+				dev_err(to_dev(arena),
+					"Unable to deduce log/padding indices\n");
+				goto out;
+			}
 
-		ret = btt_freelist_init(arena);
+			ret = btt_freelist_init(arena);
+		}
 		if (ret)
 			goto out;
 
@@ -984,9 +1090,11 @@ static int btt_arena_write_layout(struct arena_info *arena)
 	if (ret)
 		return ret;
 
-	ret = btt_log_init(arena);
-	if (ret)
-		return ret;
+	if (arena->version_major != 2) {
+		ret = btt_log_init(arena);
+		if (ret)
+			return ret;
+	}
 
 	super = kzalloc(sizeof(struct btt_sb), GFP_NOIO);
 	if (!super)
@@ -1039,7 +1147,10 @@ static int btt_meta_init(struct btt *btt)
 		if (ret)
 			goto unlock;
 
-		ret = btt_freelist_init(arena);
+		if (arena->version_major == 2)
+			ret = btt_freezone_init(arena);
+		else
+			ret = btt_freelist_init(arena);
 		if (ret)
 			goto unlock;
 
@@ -1233,12 +1344,14 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
 			u32 new_map;
 			int new_t, new_e;
 
-			if (t_flag) {
+			/* t_flag = 1, e_flag = 0 or t_flag=0, e_flag=0 */
+			if ((t_flag && e_flag == 0) || (t_flag == 0 && e_flag == 0)) {
 				zero_fill_data(page, off, cur_len);
 				goto out_lane;
 			}
 
-			if (e_flag) {
+			/* t_flag = 0, e_flag = 1*/
+			if (e_flag && t_flag == 0) {
 				ret = -EIO;
 				goto out_lane;
 			}
@@ -1326,6 +1439,7 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 	while (len) {
 		u32 cur_len;
 		int e_flag;
+		int z_flag;
 
  retry:
 		lane = nd_region_acquire_lane(btt->nd_region);
@@ -1340,29 +1454,41 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 			goto out_lane;
 		}
 
-		if (btt_is_badblock(btt, arena, arena->freelist[lane].block))
-			arena->freelist[lane].has_err = 1;
+		if (arena->version_major == 2) {
+			new_postmap = arena->lane_free[lane];
+			if (btt_is_badblock(btt, arena, new_postmap)
+				|| mutex_is_locked(&arena->err_lock)) {
+				nd_region_release_lane(btt->nd_region, lane);
+				ret = arena_clear_error(arena, new_postmap);
+				if (ret)
+					return ret;
+				/* OK to acquire a different lane/free block */
+				goto retry;
+			}
+		} else {
+			if (btt_is_badblock(btt, arena, arena->freelist[lane].block))
+				arena->freelist[lane].has_err = 1;
 
-		if (mutex_is_locked(&arena->err_lock)
-				|| arena->freelist[lane].has_err) {
-			nd_region_release_lane(btt->nd_region, lane);
+			if (mutex_is_locked(&arena->err_lock)
+					|| arena->freelist[lane].has_err) {
+				nd_region_release_lane(btt->nd_region, lane);
 
-			ret = arena_clear_freelist_error(arena, lane);
-			if (ret)
-				return ret;
+				ret = arena_clear_freelist_error(arena, lane);
+				if (ret)
+					return ret;
 
-			/* OK to acquire a different lane/free block */
-			goto retry;
-		}
+				/* OK to acquire a different lane/free block */
+				goto retry;
+			}
 
-		new_postmap = arena->freelist[lane].block;
+			new_postmap = arena->freelist[lane].block;
+		}
 
 		/* Wait if the new block is being read from */
 		for (i = 0; i < arena->nfree; i++)
 			while (arena->rtt[i] == (RTT_VALID | new_postmap))
 				cpu_relax();
 
-
 		if (new_postmap >= arena->internal_nlba) {
 			ret = -EIO;
 			goto out_lane;
@@ -1380,7 +1506,7 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 		}
 
 		lock_map(arena, premap);
-		ret = btt_map_read(arena, premap, &old_postmap, NULL, &e_flag,
+		ret = btt_map_read(arena, premap, &old_postmap, &z_flag, &e_flag,
 				NVDIMM_IO_ATOMIC);
 		if (ret)
 			goto out_map;
@@ -1388,17 +1514,25 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 			ret = -EIO;
 			goto out_map;
 		}
-		if (e_flag)
-			set_e_flag(old_postmap);
-
-		log.lba = cpu_to_le32(premap);
-		log.old_map = cpu_to_le32(old_postmap);
-		log.new_map = cpu_to_le32(new_postmap);
-		log.seq = cpu_to_le32(arena->freelist[lane].seq);
-		sub = arena->freelist[lane].sub;
-		ret = btt_flog_write(arena, lane, sub, &log);
-		if (ret)
-			goto out_map;
+
+		if (arena->version_major == 2) {
+			if (z_flag == 0 && e_flag == 0) /* initialization state (00)*/
+				get_lane_aba(arena, lane, &old_postmap);
+			else
+				arena->lane_free[lane] = old_postmap;
+		} else {
+			if (e_flag && z_flag != 1) /* Error State (10) */
+				set_e_flag(old_postmap);
+
+			log.lba = cpu_to_le32(premap);
+			log.old_map = cpu_to_le32(old_postmap);
+			log.new_map = cpu_to_le32(new_postmap);
+			log.seq = cpu_to_le32(arena->freelist[lane].seq);
+			sub = arena->freelist[lane].sub;
+			ret = btt_flog_write(arena, lane, sub, &log);
+			if (ret)
+				goto out_map;
+		}
 
 		ret = btt_map_write(arena, premap, new_postmap, 0, 0,
 			NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
@@ -1408,8 +1542,11 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 		unlock_map(arena, premap);
 		nd_region_release_lane(btt->nd_region, lane);
 
-		if (e_flag) {
-			ret = arena_clear_freelist_error(arena, lane);
+		if (e_flag && z_flag != 1) {
+			if (arena->version_major == 2)
+				ret = arena_clear_error(arena, old_postmap);
+			else
+				ret = arena_clear_freelist_error(arena, lane);
 			if (ret)
 				return ret;
 		}
diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
index 0c76c0333f6e..996af269f854 100644
--- a/drivers/nvdimm/btt.h
+++ b/drivers/nvdimm/btt.h
@@ -8,6 +8,7 @@
 #define _LINUX_BTT_H
 
 #include <linux/types.h>
+#include "nd.h"
 
 #define BTT_SIG_LEN 16
 #define BTT_SIG "BTT_ARENA_INFO\0"
@@ -185,6 +186,20 @@ struct arena_info {
 	u64 info2off;
 	/* Pointers to other in-memory structures for this arena */
 	struct free_entry *freelist;
+
+	/*divide the whole arena into #lanes zone. */
+	struct zone_free {
+		u32 free_num;
+		u32 *free_array;
+	} freezone_array;
+	struct aligned_lock list_lock;
+
+	/*
+	 * each lane, keep at least one free ABA
+	 * if in the lane, no ABA, get one from freelist
+	 */
+	u32 lane_free[BTT_DEFAULT_NFREE];
+
 	u32 *rtt;
 	struct aligned_lock *map_locks;
 	struct nd_btt *nd_btt;
-- 
2.27.0

