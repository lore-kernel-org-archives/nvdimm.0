Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7E4D221EA0C7
 for <linux-nvdimm@lists.01.org>; Thu, 14 Dec 2017 16:21:40 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 2/2] libnvdimm, btt: Fix an incompatibility in the log layout
Date: Thu, 14 Dec 2017 17:26:14 -0700
Message-Id: <20171215002614.25335-2-vishal.l.verma@intel.com>
In-Reply-To: <20171215002614.25335-1-vishal.l.verma@intel.com>
References: <20171215002614.25335-1-vishal.l.verma@intel.com>
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

Due to a spec misinterpretation, the Linux implementation of the BTT log
area had different padding scheme from other implementations, such as
UEFI and NVML.

This fixes the padding scheme, and defaults to it for new BTT layouts.
We attempt to detect the padding scheme in use when probing for an
existing BTT. If we detect the older/incompatible scheme, we continue
using it.

Reported-by: Juston Li <juston.li@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c | 194 ++++++++++++++++++++++++++++++++++++++++++---------
 drivers/nvdimm/btt.h |  45 +++++++++++-
 2 files changed, 204 insertions(+), 35 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index e949e3302af4..1b8692dd6ca3 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -211,12 +211,12 @@ static int btt_map_read(struct arena_info *arena, u32 lba, u32 *mapping,
 	return ret;
 }
 
-static int btt_log_read_pair(struct arena_info *arena, u32 lane,
-			struct log_entry *ent)
+static int btt_log_group_read(struct arena_info *arena, u32 lane,
+			struct log_group *log)
 {
 	return arena_read_bytes(arena,
-			arena->logoff + (2 * lane * LOG_ENT_SIZE), ent,
-			2 * LOG_ENT_SIZE, 0);
+			arena->logoff + (lane * LOG_GRP_SIZE), log,
+			LOG_GRP_SIZE, 0);
 }
 
 static struct dentry *debugfs_root;
@@ -256,6 +256,8 @@ static void arena_debugfs_init(struct arena_info *a, struct dentry *parent,
 	debugfs_create_x64("logoff", S_IRUGO, d, &a->logoff);
 	debugfs_create_x64("info2off", S_IRUGO, d, &a->info2off);
 	debugfs_create_x32("flags", S_IRUGO, d, &a->flags);
+	debugfs_create_u32("log_index_0", S_IRUGO, d, &a->log_index[0]);
+	debugfs_create_u32("log_index_1", S_IRUGO, d, &a->log_index[1]);
 }
 
 static void btt_debugfs_init(struct btt *btt)
@@ -283,7 +285,7 @@ static void btt_debugfs_init(struct btt *btt)
  *
  * TODO The logic feels a bit kludge-y. make it better..
  */
-static int btt_log_get_old(struct log_entry *ent)
+static int btt_log_get_old(struct arena_info *a, struct log_group *log)
 {
 	int old;
 
@@ -292,23 +294,27 @@ static int btt_log_get_old(struct log_entry *ent)
 	 * the next time, the following logic works out to put this
 	 * (next) entry into [1]
 	 */
-	if (ent[0].seq == 0) {
-		ent[0].seq = cpu_to_le32(1);
+	if (log->ent[a->log_index[0]].seq == 0) {
+		log->ent[a->log_index[0]].seq = cpu_to_le32(1);
 		return 0;
 	}
 
-	if (ent[0].seq == ent[1].seq)
+	if (log->ent[a->log_index[0]].seq == log->ent[a->log_index[1]].seq)
 		return -EINVAL;
-	if (le32_to_cpu(ent[0].seq) + le32_to_cpu(ent[1].seq) > 5)
+	if (le32_to_cpu(log->ent[a->log_index[0]].seq) +
+			le32_to_cpu(log->ent[a->log_index[1]].seq) > 5)
 		return -EINVAL;
 
-	if (le32_to_cpu(ent[0].seq) < le32_to_cpu(ent[1].seq)) {
-		if (le32_to_cpu(ent[1].seq) - le32_to_cpu(ent[0].seq) == 1)
+	if (le32_to_cpu(log->ent[a->log_index[0]].seq) <
+			le32_to_cpu(log->ent[a->log_index[1]].seq)) {
+		if (le32_to_cpu(log->ent[a->log_index[1]].seq) -
+				le32_to_cpu(log->ent[a->log_index[0]].seq) == 1)
 			old = 0;
 		else
 			old = 1;
 	} else {
-		if (le32_to_cpu(ent[0].seq) - le32_to_cpu(ent[1].seq) == 1)
+		if (le32_to_cpu(log->ent[a->log_index[0]].seq) -
+				le32_to_cpu(log->ent[a->log_index[1]].seq) == 1)
 			old = 1;
 		else
 			old = 0;
@@ -328,17 +334,18 @@ static int btt_log_read(struct arena_info *arena, u32 lane,
 {
 	int ret;
 	int old_ent, ret_ent;
-	struct log_entry log[2];
+	struct log_group log;
 
-	ret = btt_log_read_pair(arena, lane, log);
+	ret = btt_log_group_read(arena, lane, &log);
 	if (ret)
 		return -EIO;
 
-	old_ent = btt_log_get_old(log);
+	old_ent = btt_log_get_old(arena, &log);
 	if (old_ent < 0 || old_ent > 1) {
 		dev_err(to_dev(arena),
 				"log corruption (%d): lane %d seq [%d, %d]\n",
-			old_ent, lane, log[0].seq, log[1].seq);
+				old_ent, lane, log.ent[arena->log_index[0]].seq,
+				log.ent[arena->log_index[1]].seq);
 		/* TODO set error state? */
 		return -EIO;
 	}
@@ -346,7 +353,7 @@ static int btt_log_read(struct arena_info *arena, u32 lane,
 	ret_ent = (old_flag ? old_ent : (1 - old_ent));
 
 	if (ent != NULL)
-		memcpy(ent, &log[ret_ent], LOG_ENT_SIZE);
+		memcpy(ent, &log.ent[arena->log_index[ret_ent]], LOG_ENT_SIZE);
 
 	return ret_ent;
 }
@@ -360,17 +367,13 @@ static int __btt_log_write(struct arena_info *arena, u32 lane,
 			u32 sub, struct log_entry *ent, unsigned long flags)
 {
 	int ret;
-	/*
-	 * Ignore the padding in log_entry for calculating log_half.
-	 * The entry is 'committed' when we write the sequence number,
-	 * and we want to ensure that that is the last thing written.
-	 * We don't bother writing the padding as that would be extra
-	 * media wear and write amplification
-	 */
-	unsigned int log_half = (LOG_ENT_SIZE - 2 * sizeof(u64)) / 2;
-	u64 ns_off = arena->logoff + (((2 * lane) + sub) * LOG_ENT_SIZE);
+	u32 group_slot = arena->log_index[sub];
+	unsigned int log_half = LOG_ENT_SIZE / 2;
 	void *src = ent;
+	u64 ns_off;
 
+	ns_off = arena->logoff + (lane * LOG_GRP_SIZE) +
+		(group_slot * LOG_ENT_SIZE);
 	/* split the 16B write into atomic, durable halves */
 	ret = arena_write_bytes(arena, ns_off, src, log_half, flags);
 	if (ret)
@@ -453,7 +456,7 @@ static int btt_log_init(struct arena_info *arena)
 {
 	size_t logsize = arena->info2off - arena->logoff;
 	size_t chunk_size = SZ_4K, offset = 0;
-	struct log_entry log;
+	struct log_entry ent;
 	void *zerobuf;
 	int ret;
 	u32 i;
@@ -485,11 +488,11 @@ static int btt_log_init(struct arena_info *arena)
 	}
 
 	for (i = 0; i < arena->nfree; i++) {
-		log.lba = cpu_to_le32(i);
-		log.old_map = cpu_to_le32(arena->external_nlba + i);
-		log.new_map = cpu_to_le32(arena->external_nlba + i);
-		log.seq = cpu_to_le32(LOG_SEQ_INIT);
-		ret = __btt_log_write(arena, i, 0, &log, 0);
+		ent.lba = cpu_to_le32(i);
+		ent.old_map = cpu_to_le32(arena->external_nlba + i);
+		ent.new_map = cpu_to_le32(arena->external_nlba + i);
+		ent.seq = cpu_to_le32(LOG_SEQ_INIT);
+		ret = __btt_log_write(arena, i, 0, &ent, 0);
 		if (ret)
 			goto free;
 	}
@@ -594,6 +597,119 @@ static int btt_freelist_init(struct arena_info *arena)
 	return 0;
 }
 
+static bool ent_is_padding(struct log_entry *ent)
+{
+	return (ent->lba == 0) && (ent->old_map == 0) && (ent->new_map == 0)
+		&& (ent->seq == 0);
+}
+
+/*
+ * Detecting valid log indices: We read a log group (see the comments in btt.h
+ * for a description of a 'log_group' and its 'slots'), and iterate over its
+ * four slots. We expect that a padding slot will be all-zeroes, and use this
+ * to detect a padding slot vs. an actual entry.
+ *
+ * If a log_group is in the initial state, i.e. hasn't been used since the
+ * creation of this BTT layout, it will have three of the four slots with
+ * zeroes. We skip over these log_groups for the detection of log_index. If
+ * all log_groups are in the initial state (i.e. the BTT has never been
+ * written to), it is safe to assume the 'new format' of log entries in slots
+ * (0, 1).
+ */
+static int log_set_indices(struct arena_info *arena)
+{
+	bool idx_set = false, initial_state = true;
+	int ret, log_index[2] = {-1, -1};
+	u32 i, j, next_idx = 0;
+	struct log_group log;
+	u32 pad_count = 0;
+
+	for (i = 0; i < arena->nfree; i++) {
+		ret = btt_log_group_read(arena, i, &log);
+		if (ret < 0)
+			return ret;
+
+		for (j = 0; j < 4; j++) {
+			if (!idx_set) {
+				if (ent_is_padding(&log.ent[j])) {
+					pad_count++;
+					continue;
+				} else {
+					/* Skip if index has been recorded */
+					if ((next_idx == 1) &&
+						(j == log_index[0]))
+						continue;
+					/* valid entry, record index */
+					log_index[next_idx] = j;
+					next_idx++;
+				}
+				if (next_idx == 2) {
+					/* two valid entries found */
+					idx_set = true;
+				} else if (next_idx > 2) {
+					/* too many valid indices */
+					return -ENXIO;
+				}
+			} else {
+				/*
+				 * once the indices have been set, just verify
+				 * that all subsequent log groups are either in
+				 * their initial state or follow the same
+				 * indices.
+				 */
+				if (j == log_index[0]) {
+					/* entry must be 'valid' */
+					if (ent_is_padding(&log.ent[j]))
+						return -ENXIO;
+				} else if (j == log_index[1]) {
+					;
+					/*
+					 * log_index[1] can be padding if the
+					 * lane never got used and it is still
+					 * in the initial state (three 'padding'
+					 * entries)
+					 */
+				} else {
+					/* entry must be invalid (padding) */
+					if (!ent_is_padding(&log.ent[j]))
+						return -ENXIO;
+				}
+			}
+		}
+		/*
+		 * If any of the log_groups have more than one valid,
+		 * non-padding entry, then the we are no longer in the
+		 * initial_state
+		 */
+		if (pad_count < 3)
+			initial_state = false;
+		pad_count = 0;
+	}
+
+	if (!initial_state && !idx_set)
+		return -ENXIO;
+
+	/*
+	 * If all the entries in the log were in the initial state,
+	 * assume new padding scheme
+	 */
+	if (initial_state)
+		log_index[1] = 1;
+
+	/*
+	 * Only allow the known permutations of log/padding indices,
+	 * i.e. (0, 1), and (0, 2)
+	 */
+	if ((log_index[0] == 0) && ((log_index[1] == 1) || (log_index[1] == 2)))
+		; /* known index possibilities */
+	else
+		return -ENXIO;
+
+	arena->log_index[0] = log_index[0];
+	arena->log_index[1] = log_index[1];
+	return 0;
+}
+
 static int btt_rtt_init(struct arena_info *arena)
 {
 	arena->rtt = kcalloc(arena->nfree, sizeof(u32), GFP_KERNEL);
@@ -650,8 +766,7 @@ static struct arena_info *alloc_arena(struct btt *btt, size_t size,
 	available -= 2 * BTT_PG_SIZE;
 
 	/* The log takes a fixed amount of space based on nfree */
-	logsize = roundup(2 * arena->nfree * sizeof(struct log_entry),
-				BTT_PG_SIZE);
+	logsize = roundup(arena->nfree * LOG_GRP_SIZE, BTT_PG_SIZE);
 	available -= logsize;
 
 	/* Calculate optimal split between map and data area */
@@ -668,6 +783,10 @@ static struct arena_info *alloc_arena(struct btt *btt, size_t size,
 	arena->mapoff = arena->dataoff + datasize;
 	arena->logoff = arena->mapoff + mapsize;
 	arena->info2off = arena->logoff + logsize;
+
+	/* Default log indices are (0,1) */
+	arena->log_index[0] = 0;
+	arena->log_index[1] = 1;
 	return arena;
 }
 
@@ -758,6 +877,13 @@ static int discover_arenas(struct btt *btt)
 		arena->external_lba_start = cur_nlba;
 		parse_arena_meta(arena, super, cur_off);
 
+		ret = log_set_indices(arena);
+		if (ret) {
+			dev_err(to_dev(arena),
+				"Unable to deduce log/padding indices\n");
+			goto out;
+		}
+
 		mutex_init(&arena->err_lock);
 		ret = btt_freelist_init(arena);
 		if (ret)
diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
index 884fbbbdd18a..be1031c5b1ba 100644
--- a/drivers/nvdimm/btt.h
+++ b/drivers/nvdimm/btt.h
@@ -27,6 +27,7 @@
 #define MAP_ERR_MASK (1 << MAP_ERR_SHIFT)
 #define MAP_LBA_MASK (~((1 << MAP_TRIM_SHIFT) | (1 << MAP_ERR_SHIFT)))
 #define MAP_ENT_NORMAL 0xC0000000
+#define LOG_GRP_SIZE sizeof(struct log_group)
 #define LOG_ENT_SIZE sizeof(struct log_entry)
 #define ARENA_MIN_SIZE (1UL << 24)	/* 16 MB */
 #define ARENA_MAX_SIZE (1ULL << 39)	/* 512 GB */
@@ -50,12 +51,52 @@ enum btt_init_state {
 	INIT_READY
 };
 
+/*
+ * A log group represents one log 'lane', and consists of four log entries.
+ * Two of the four entries are valid entries, and the remaining two are
+ * padding. Due to an old bug in the padding location, we need to perform a
+ * test to determine the padding scheme being used, and use that scheme
+ * thereafter.
+ *
+ * An old format 'log group' would have actual log entries at indices (0, 2)
+ * and padding at indices (1, 3), where as the correct/updated format has
+ * log entries at indices (0, 1) and padding at indices (2, 3).
+ *
+ * Old (incompatible) format:
+ * +-----------------+-----------------+
+ * |      ent[0]     |      ent[1]     |
+ * |       16B       |       16B       |
+ * | lba/old/new/seq |       pad       |
+ * +-----------------------------------+
+ * |      ent[2]     |      ent[3]     |
+ * |       16B       |       16B       |
+ * | lba/old/new/seq |       pad       |
+ * +-----------------+-----------------+
+ *
+ * New format:
+ * +-----------------+-----------------+
+ * |      ent[0]     |      ent[1]     |
+ * |       16B       |       16B       |
+ * | lba/old/new/seq | lba/old/new/seq |
+ * +-----------------------------------+
+ * |      ent[2]     |      ent[3]     |
+ * |       16B       |       16B       |
+ * |       pad       |       pad       |
+ * +-----------------+-----------------+
+ *
+ * We detect during start-up which format is in use, and set
+ * arena->log_index[(0, 1)] with the detected format.
+ */
+
 struct log_entry {
 	__le32 lba;
 	__le32 old_map;
 	__le32 new_map;
 	__le32 seq;
-	__le64 padding[2];
+};
+
+struct log_group {
+	struct log_entry ent[4];
 };
 
 struct btt_sb {
@@ -126,6 +167,7 @@ struct aligned_lock {
  * @debugfs_dir:	Debugfs dentry
  * @flags:		Arena flags - may signify error states.
  * @err_lock:		Mutex for synchronizing error clearing.
+ * @log_index:		Indices of the valid log entries in a log_group
  *
  * arena_info is a per-arena handle. Once an arena is narrowed down for an
  * IO, this struct is passed around for the duration of the IO.
@@ -158,6 +200,7 @@ struct arena_info {
 	/* Arena flags */
 	u32 flags;
 	struct mutex err_lock;
+	int log_index[2];
 };
 
 /**
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
