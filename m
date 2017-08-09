Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8080E21E11D63
 for <linux-nvdimm@lists.01.org>; Tue,  8 Aug 2017 17:07:21 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v5 6/7] libnvdimm, btt: refactor initial_offset calculations
Date: Tue,  8 Aug 2017 18:07:45 -0600
Message-Id: <20170809000746.10585-7-vishal.l.verma@intel.com>
In-Reply-To: <20170809000746.10585-1-vishal.l.verma@intel.com>
References: <20170809000746.10585-1-vishal.l.verma@intel.com>
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

In preparation for BTT error clearing, refactor the initial offset
calculations. Until now, all callers of arena_{read,write}_bytes assumed
a relative offset to the arena, and it was later adjusted for the
initial offset. Until now, every time we calculated a relative offset,
we passed it to these functions to do reads or writes, and so where the
offset calculations happened didn't matter.

For error clearing, there will be places where we calculate offsets to
check for the presence of media errors, and the above scheme becomes
error prone.

Make the initial_offset calculations explicit for all callers of
arena_{read,write}_bytes, and provide a helper to do them. The error
checking/clearing code can then use these same helpers.

Reported-by: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c | 69 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 27 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index e9dd651..9acf06b 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -31,14 +31,17 @@ enum log_ent_request {
 	LOG_OLD_ENT
 };
 
+static inline u64 calc_nsoff(struct nd_btt *nd_btt, u64 relative_offset)
+{
+	return relative_offset + nd_btt->initial_offset;
+}
+
 static int arena_read_bytes(struct arena_info *arena, resource_size_t offset,
 		void *buf, size_t n, unsigned long flags)
 {
 	struct nd_btt *nd_btt = arena->nd_btt;
 	struct nd_namespace_common *ndns = nd_btt->ndns;
 
-	/* arena offsets may be shifted from the base of the device */
-	offset += arena->nd_btt->initial_offset;
 	return nvdimm_read_bytes(ndns, offset, buf, n, flags);
 }
 
@@ -48,14 +51,13 @@ static int arena_write_bytes(struct arena_info *arena, resource_size_t offset,
 	struct nd_btt *nd_btt = arena->nd_btt;
 	struct nd_namespace_common *ndns = nd_btt->ndns;
 
-	/* arena offsets may be shifted from the base of the device */
-	offset += arena->nd_btt->initial_offset;
 	return nvdimm_write_bytes(ndns, offset, buf, n, flags);
 }
 
 static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
 {
 	int ret;
+	u64 nsoff;
 
 	/*
 	 * infooff and info2off should always be at least 512B aligned.
@@ -65,19 +67,23 @@ static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
 	WARN_ON_ONCE(!IS_ALIGNED(arena->infooff, 512));
 	WARN_ON_ONCE(!IS_ALIGNED(arena->info2off, 512));
 
-	ret = arena_write_bytes(arena, arena->info2off, super,
+	nsoff = calc_nsoff(arena->nd_btt, arena->info2off);
+	ret = arena_write_bytes(arena, nsoff, super,
 			sizeof(struct btt_sb), 0);
 	if (ret)
 		return ret;
 
-	return arena_write_bytes(arena, arena->infooff, super,
+	nsoff = calc_nsoff(arena->nd_btt, arena->infooff);
+	return arena_write_bytes(arena, nsoff, super,
 			sizeof(struct btt_sb), 0);
 }
 
 static int btt_info_read(struct arena_info *arena, struct btt_sb *super)
 {
+	u64 nsoff = calc_nsoff(arena->nd_btt, arena->infooff);
+
 	WARN_ON(!super);
-	return arena_read_bytes(arena, arena->infooff, super,
+	return arena_read_bytes(arena, nsoff, super,
 			sizeof(struct btt_sb), 0);
 }
 
@@ -90,10 +96,11 @@ static int btt_info_read(struct arena_info *arena, struct btt_sb *super)
 static int __btt_map_write(struct arena_info *arena, u32 lba, __le32 mapping,
 		unsigned long flags)
 {
-	u64 ns_off = arena->mapoff + (lba * MAP_ENT_SIZE);
+	u64 nsoff = calc_nsoff(arena->nd_btt,
+		arena->mapoff + (lba * MAP_ENT_SIZE));
 
 	WARN_ON(lba >= arena->external_nlba);
-	return arena_write_bytes(arena, ns_off, &mapping, MAP_ENT_SIZE, flags);
+	return arena_write_bytes(arena, nsoff, &mapping, MAP_ENT_SIZE, flags);
 }
 
 static int btt_map_write(struct arena_info *arena, u32 lba, u32 mapping,
@@ -145,11 +152,12 @@ static int btt_map_read(struct arena_info *arena, u32 lba, u32 *mapping,
 	int ret;
 	__le32 in;
 	u32 raw_mapping, postmap, ze, z_flag, e_flag;
-	u64 ns_off = arena->mapoff + (lba * MAP_ENT_SIZE);
+	u64 nsoff = calc_nsoff(arena->nd_btt,
+		arena->mapoff + (lba * MAP_ENT_SIZE));
 
 	WARN_ON(lba >= arena->external_nlba);
 
-	ret = arena_read_bytes(arena, ns_off, &in, MAP_ENT_SIZE, rwb_flags);
+	ret = arena_read_bytes(arena, nsoff, &in, MAP_ENT_SIZE, rwb_flags);
 	if (ret)
 		return ret;
 
@@ -195,10 +203,11 @@ static int btt_map_read(struct arena_info *arena, u32 lba, u32 *mapping,
 static int btt_log_read_pair(struct arena_info *arena, u32 lane,
 			struct log_entry *ent)
 {
+	u64 nsoff = calc_nsoff(arena->nd_btt,
+		arena->logoff + (2 * lane * LOG_ENT_SIZE));
+
 	WARN_ON(!ent);
-	return arena_read_bytes(arena,
-			arena->logoff + (2 * lane * LOG_ENT_SIZE), ent,
-			2 * LOG_ENT_SIZE, 0);
+	return arena_read_bytes(arena, nsoff, ent, 2 * LOG_ENT_SIZE, 0);
 }
 
 static struct dentry *debugfs_root;
@@ -355,17 +364,20 @@ static int __btt_log_write(struct arena_info *arena, u32 lane,
 	 * media wear and write amplification
 	 */
 	unsigned int log_half = (LOG_ENT_SIZE - 2 * sizeof(u64)) / 2;
-	u64 ns_off = arena->logoff + (((2 * lane) + sub) * LOG_ENT_SIZE);
 	void *src = ent;
+	u64 nsoff;
+
+	nsoff = calc_nsoff(arena->nd_btt,
+		arena->logoff + (((2 * lane) + sub) * LOG_ENT_SIZE));
 
 	/* split the 16B write into atomic, durable halves */
-	ret = arena_write_bytes(arena, ns_off, src, log_half, flags);
+	ret = arena_write_bytes(arena, nsoff, src, log_half, flags);
 	if (ret)
 		return ret;
 
-	ns_off += log_half;
+	nsoff += log_half;
 	src += log_half;
-	return arena_write_bytes(arena, ns_off, src, log_half, flags);
+	return arena_write_bytes(arena, nsoff, src, log_half, flags);
 }
 
 static int btt_flog_write(struct arena_info *arena, u32 lane, u32 sub,
@@ -413,8 +425,9 @@ static int btt_map_init(struct arena_info *arena)
 		size_t size = min(mapsize, chunk_size);
 
 		WARN_ON_ONCE(size < 512);
-		ret = arena_write_bytes(arena, arena->mapoff + offset, zerobuf,
-				size, 0);
+		ret = arena_write_bytes(arena,
+			calc_nsoff(arena->nd_btt, arena->mapoff + offset),
+			zerobuf, size, 0);
 		if (ret)
 			goto free;
 
@@ -455,8 +468,9 @@ static int btt_log_init(struct arena_info *arena)
 		size_t size = min(logsize, chunk_size);
 
 		WARN_ON_ONCE(size < 512);
-		ret = arena_write_bytes(arena, arena->logoff + offset, zerobuf,
-				size, 0);
+		ret = arena_write_bytes(arena,
+			calc_nsoff(arena->nd_btt, arena->logoff + offset),
+			zerobuf, size, 0);
 		if (ret)
 			goto free;
 
@@ -905,16 +919,17 @@ static void unlock_map(struct arena_info *arena, u32 premap)
 	spin_unlock(&arena->map_locks[idx].lock);
 }
 
-static u64 to_namespace_offset(struct arena_info *arena, u64 lba)
+static u64 lba_to_nsoff(struct arena_info *arena, u64 lba)
 {
-	return arena->dataoff + ((u64)lba * arena->internal_lbasize);
+	return calc_nsoff(arena->nd_btt,
+		arena->dataoff + ((u64)lba * arena->internal_lbasize));
 }
 
 static int btt_data_read(struct arena_info *arena, struct page *page,
 			unsigned int off, u32 lba, u32 len)
 {
 	int ret;
-	u64 nsoff = to_namespace_offset(arena, lba);
+	u64 nsoff = lba_to_nsoff(arena, lba);
 	void *mem = kmap_atomic(page);
 
 	ret = arena_read_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
@@ -927,7 +942,7 @@ static int btt_data_write(struct arena_info *arena, u32 lba,
 			struct page *page, unsigned int off, u32 len)
 {
 	int ret;
-	u64 nsoff = to_namespace_offset(arena, lba);
+	u64 nsoff = lba_to_nsoff(arena, lba);
 	void *mem = kmap_atomic(page);
 
 	ret = arena_write_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
@@ -955,7 +970,7 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
 	if (bip == NULL)
 		return 0;
 
-	meta_nsoff = to_namespace_offset(arena, postmap) + btt->sector_size;
+	meta_nsoff = lba_to_nsoff(arena, postmap) + btt->sector_size;
 
 	while (len) {
 		unsigned int cur_len;
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
