Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85B2C21F833D0
 for <linux-nvdimm@lists.01.org>; Fri, 12 Jan 2018 15:58:04 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/2] ndctl/check-namespace: Updates for BTT log
 compatibility
Date: Fri, 12 Jan 2018 17:03:14 -0700
Message-Id: <20180113000315.29082-1-vishal.l.verma@intel.com>
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

Update ndctl check-namespace with the BTT log compatibility fixes. This
detects the existing log/padding scheme, and uses that to perform its
checks.

Reported-by: Juston Li <juston.li@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/check.c     | 205 +++++++++++++++++++++++++++++++++++++++++++++---------
 ndctl/namespace.h |  46 +++++++++++-
 2 files changed, 216 insertions(+), 35 deletions(-)

diff --git a/ndctl/check.c b/ndctl/check.c
index 3d58f89..d3aa1aa 100644
--- a/ndctl/check.c
+++ b/ndctl/check.c
@@ -82,6 +82,7 @@ struct arena_info {
 	u32 flags;
 	int num;
 	struct btt_chk *bttc;
+	int log_index[2];
 };
 
 static sigjmp_buf sj_env;
@@ -239,10 +240,15 @@ static int btt_map_write(struct arena_info *a, u32 lba, u32 mapping)
 	return 0;
 }
 
-static void btt_log_read_pair(struct arena_info *a, u32 lane,
-			struct log_entry *ent)
+static void btt_log_group_read(struct arena_info *a, u32 lane,
+			struct log_group *log)
 {
-	memcpy(ent, &a->map.log[lane * 2], 2 * sizeof(struct log_entry));
+	memcpy(log, &a->map.log[lane], LOG_GRP_SIZE);
+}
+
+static u32 log_seq(struct log_group *log, int log_idx)
+{
+	return le32_to_cpu(log->ent[log_idx].seq);
 }
 
 /*
@@ -250,22 +256,24 @@ static void btt_log_read_pair(struct arena_info *a, u32 lane,
  * find the 'older' entry. The return value indicates which of the two was
  * the 'old' entry
  */
-static int btt_log_get_old(struct log_entry *ent)
+static int btt_log_get_old(struct arena_info *a, struct log_group *log)
 {
+	int idx0 = a->log_index[0];
+	int idx1 = a->log_index[1];
 	int old;
 
-	if (ent[0].seq == 0) {
-		ent[0].seq = cpu_to_le32(1);
+	if (log_seq(log, idx0) == 0) {
+		log->ent[idx0].seq = cpu_to_le32(1);
 		return 0;
 	}
 
-	if (le32_to_cpu(ent[0].seq) < le32_to_cpu(ent[1].seq)) {
-		if (le32_to_cpu(ent[1].seq) - le32_to_cpu(ent[0].seq) == 1)
+	if (log_seq(log, idx0) < log_seq(log, idx1)) {
+		if ((log_seq(log, idx1) - log_seq(log, idx0)) == 1)
 			old = 0;
 		else
 			old = 1;
 	} else {
-		if (le32_to_cpu(ent[0].seq) - le32_to_cpu(ent[1].seq) == 1)
+		if ((log_seq(log, idx0) - log_seq(log, idx1)) == 1)
 			old = 1;
 		else
 			old = 0;
@@ -277,13 +285,13 @@ static int btt_log_get_old(struct log_entry *ent)
 static int btt_log_read(struct arena_info *a, u32 lane, struct log_entry *ent)
 {
 	int new_ent;
-	struct log_entry log[2];
+	struct log_group log;
 
 	if (ent == NULL)
 		return -EINVAL;
-	btt_log_read_pair(a, lane, log);
-	new_ent = 1 - btt_log_get_old(log);
-	memcpy(ent, &log[new_ent], sizeof(struct log_entry));
+	btt_log_group_read(a, lane, &log);
+	new_ent = 1 - btt_log_get_old(a, &log);
+	memcpy(ent, &log.ent[a->log_index[new_ent]], LOG_ENT_SIZE);
 	return 0;
 }
 
@@ -406,6 +414,8 @@ static void btt_xlat_status(struct arena_info *a, int errcode)
 /* Check that log entries are self consistent */
 static int btt_check_log_entries(struct arena_info *a)
 {
+	int idx0 = a->log_index[0];
+	int idx1 = a->log_index[1];
 	unsigned int i;
 	int rc = 0;
 
@@ -413,28 +423,30 @@ static int btt_check_log_entries(struct arena_info *a)
 	 * First, check both 'slots' for sequence numbers being distinct
 	 * and in bounds
 	 */
-	for (i = 0; i < (2 * a->nfree); i+=2) {
-		if (a->map.log[i].seq == a->map.log[i + 1].seq)
+	for (i = 0; i < a->nfree; i++) {
+		struct log_group *log = &a->map.log[i];
+
+		if (log_seq(log, idx0) == log_seq(log, idx1))
 			return BTT_LOG_EQL_SEQ;
-		if (a->map.log[i].seq > 3 || a->map.log[i + 1].seq > 3)
+		if (log_seq(log, idx0) > 3 || log_seq(log, idx1) > 3)
 			return BTT_LOG_OOB_SEQ;
 	}
 	/*
 	 * Next, check only the 'new' slot in each lane for the remaining
-	 * entries being in bounds
+	 * fields being in bounds
 	 */
 	for (i = 0; i < a->nfree; i++) {
-		struct log_entry log;
+		struct log_entry ent;
 
-		rc = btt_log_read(a, i, &log);
+		rc = btt_log_read(a, i, &ent);
 		if (rc)
 			return rc;
 
-		if (log.lba >= a->external_nlba)
+		if (ent.lba >= a->external_nlba)
 			return BTT_LOG_OOB_LBA;
-		if (log.old_map >= a->internal_nlba)
+		if (ent.old_map >= a->internal_nlba)
 			return BTT_LOG_OOB_OLD;
-		if (log.new_map >= a->internal_nlba)
+		if (ent.new_map >= a->internal_nlba)
 			return BTT_LOG_OOB_NEW;
 	}
 	return rc;
@@ -462,23 +474,23 @@ static int btt_check_log_map(struct arena_info *a)
 	int rc = 0, rc_saved = 0;
 
 	for (i = 0; i < a->nfree; i++) {
-		struct log_entry log;
+		struct log_entry ent;
 
-		rc = btt_log_read(a, i, &log);
+		rc = btt_log_read(a, i, &ent);
 		if (rc)
 			return rc;
-		mapping = btt_map_lookup(a, log.lba);
+		mapping = btt_map_lookup(a, ent.lba);
 
 		/*
 		 * Case where the flog was written, but map couldn't be
 		 * updated. The kernel should also be able to detect and
 		 * fix this condition.
 		 */
-		if (log.new_map != mapping && log.old_map == mapping) {
+		if (ent.new_map != mapping && ent.old_map == mapping) {
 			info(a->bttc,
 				"arena %d: log[%d].new_map (%#x) doesn't match map[%#x] (%#x)\n",
-				a->num, i, log.new_map, log.lba, mapping);
-			rc = btt_map_write(a, log.lba, log.new_map);
+				a->num, i, ent.new_map, ent.lba, mapping);
+			rc = btt_map_write(a, ent.lba, ent.new_map);
 			if (rc)
 				rc_saved = rc;
 		}
@@ -528,19 +540,19 @@ static int btt_check_bitmap(struct arena_info *a)
 
 	/* map 'nfree' number of flog entries */
 	for (i = 0; i < a->nfree; i++) {
-		struct log_entry log;
+		struct log_entry ent;
 
-		rc = btt_log_read(a, i, &log);
+		rc = btt_log_read(a, i, &ent);
 		if (rc)
 			goto out;
-		if (test_bit(log.old_map, bm)) {
+		if (test_bit(ent.old_map, bm)) {
 			info(a->bttc,
 				"arena %d: internal block %#x is referenced by two map/log entries\n",
-				a->num, log.old_map);
+				a->num, ent.old_map);
 			rc = BTT_BITMAP_ERROR;
 			goto out;
 		}
-		bitmap_set(bm, log.old_map, 1);
+		bitmap_set(bm, ent.old_map, 1);
 	}
 
 	/* check that the bitmap is full */
@@ -632,6 +644,123 @@ static int btt_parse_meta(struct arena_info *arena, struct btt_sb *btt_sb,
 	return 0;
 }
 
+static bool ent_is_padding(struct log_entry *ent)
+{
+	return (ent->lba == 0) && (ent->old_map == 0) && (ent->new_map == 0)
+		&& (ent->seq == 0);
+}
+
+/*
+ * Detecting valid log indices: We read a log group, and iterate over its
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
+	int log_index[2] = {-1, -1};
+	struct log_group log;
+	int j, next_idx = 0;
+	u32 pad_count = 0;
+	u32 i;
+
+	for (i = 0; i < arena->nfree; i++) {
+		btt_log_group_read(arena, i, &log);
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
+	else {
+		err(arena->bttc, "Found an unknown padding scheme\n");
+		return -ENXIO;
+	}
+
+	arena->log_index[0] = log_index[0];
+	arena->log_index[1] = log_index[1];
+	info(arena->bttc, "arena[%d]: log_index_0 = %d\n",
+		arena->num, log_index[0]);
+	info(arena->bttc, "arena[%d]: log_index_1 = %d\n",
+		arena->num, log_index[1]);
+	return 0;
+}
+
 static int btt_discover_arenas(struct btt_chk *bttc)
 {
 	int ret = 0;
@@ -978,6 +1107,7 @@ int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
 	struct btt_chk *bttc;
 	struct sigaction act;
 	char path[50];
+	int i;
 
 	bttc = calloc(1, sizeof(*bttc));
 	if (bttc == NULL)
@@ -1108,6 +1238,15 @@ int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
 	if (rc)
 		goto out_close;
 
+	for (i = 0; i < bttc->num_arenas; i++) {
+		rc = log_set_indices(&bttc->arena[i]);
+		if (rc) {
+			err(bttc,
+				"Unable to deduce log/padding indices\n");
+			goto out_close;
+		}
+	}
+
 	rc = btt_check_arenas(bttc);
 
 	btt_remove_mappings(bttc);
diff --git a/ndctl/namespace.h b/ndctl/namespace.h
index 6d56468..bc21085 100644
--- a/ndctl/namespace.h
+++ b/ndctl/namespace.h
@@ -107,6 +107,8 @@ struct namespace_label {
 #define ARENA_MAX_SIZE (1ULL << 39)	/* 512 GB */
 #define BTT_INFO_SIZE 4096
 #define IB_FLAG_ERROR_MASK 0x00000001
+#define LOG_GRP_SIZE sizeof(struct log_group)
+#define LOG_ENT_SIZE sizeof(struct log_entry)
 
 #define BTT_NUM_OFFSETS 2
 #define BTT1_START_OFFSET 4096
@@ -117,7 +119,47 @@ struct log_entry {
 	le32 old_map;
 	le32 new_map;
 	le32 seq;
-	le64 padding[2];
+};
+
+/*
+ * A log group represents one log 'lane', and consists of four log entries.
+ * Two of the four entries are valid entries, and the remaining two are
+ * padding. Due to an old bug in the padding location, we need to perform a
+ * test to determine the padding scheme being used, and use that scheme
+ * thereafter.
+ *
+ * In kernels prior to 4.15, 'log group' would have actual log entries at
+ * indices (0, 2) and padding at indices (1, 3), where as the correct/updated
+ * format has log entries at indices (0, 1) and padding at indices (2, 3).
+ *
+ * Old (pre 4.15) format:
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
+struct log_group {
+	struct log_entry ent[4];
 };
 
 struct btt_sb {
@@ -155,7 +197,7 @@ struct arena_map {
 	size_t data_len;
 	u32 *map;
 	size_t map_len;
-	struct log_entry *log;
+	struct log_group *log;
 	size_t log_len;
 	struct btt_sb *info2;
 	size_t info2_len;
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
