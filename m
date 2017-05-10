Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2175321A13489
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 12:27:06 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 1/2] libnvdimm: add an atomic vs process context flag to
 rw_bytes
Date: Wed, 10 May 2017 13:25:30 -0600
Message-Id: <20170510192531.13032-1-vishal.l.verma@intel.com>
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

nsio_rw_bytes can clear media errors, but this cannot be done while we
are in an atomic context due to locking within ACPI. From the BTT,
->rw_bytes may be called either from atomic or process context depending
on whether the calls happen during initialization or during IO.

During init, we want to ensure error clearing happens, and the flag
marking process context allows nsio_rw_bytes to do that. When called
during IO, we're in atomic context, and error clearing can be skipped.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/blk.c      |  3 ++-
 drivers/nvdimm/btt.c      | 69 ++++++++++++++++++++++++++---------------------
 drivers/nvdimm/btt_devs.c |  3 ++-
 drivers/nvdimm/claim.c    |  6 +++--
 drivers/nvdimm/nd.h       |  5 ++++
 drivers/nvdimm/pfn_devs.c |  6 +++--
 include/linux/nd.h        | 10 +++----
 7 files changed, 60 insertions(+), 42 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 9faaa96..7cf6f7b 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -218,7 +218,8 @@ static blk_qc_t nd_blk_make_request(struct request_queue *q, struct bio *bio)
 }
 
 static int nsblk_rw_bytes(struct nd_namespace_common *ndns,
-		resource_size_t offset, void *iobuf, size_t n, int rw)
+		resource_size_t offset, void *iobuf, size_t n, int rw,
+		u32 flags)
 {
 	struct nd_namespace_blk *nsblk = to_nd_namespace_blk(&ndns->dev);
 	struct nd_blk_region *ndbr = to_ndbr(nsblk);
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 368795a..5cdc3aa 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -32,25 +32,25 @@ enum log_ent_request {
 };
 
 static int arena_read_bytes(struct arena_info *arena, resource_size_t offset,
-		void *buf, size_t n)
+		void *buf, size_t n, u32 flags)
 {
 	struct nd_btt *nd_btt = arena->nd_btt;
 	struct nd_namespace_common *ndns = nd_btt->ndns;
 
 	/* arena offsets are 4K from the base of the device */
 	offset += SZ_4K;
-	return nvdimm_read_bytes(ndns, offset, buf, n);
+	return nvdimm_read_bytes(ndns, offset, buf, n, flags);
 }
 
 static int arena_write_bytes(struct arena_info *arena, resource_size_t offset,
-		void *buf, size_t n)
+		void *buf, size_t n, u32 flags)
 {
 	struct nd_btt *nd_btt = arena->nd_btt;
 	struct nd_namespace_common *ndns = nd_btt->ndns;
 
 	/* arena offsets are 4K from the base of the device */
 	offset += SZ_4K;
-	return nvdimm_write_bytes(ndns, offset, buf, n);
+	return nvdimm_write_bytes(ndns, offset, buf, n, flags);
 }
 
 static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
@@ -58,19 +58,19 @@ static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
 	int ret;
 
 	ret = arena_write_bytes(arena, arena->info2off, super,
-			sizeof(struct btt_sb));
+			sizeof(struct btt_sb), NVDIMM_IO_NORMAL);
 	if (ret)
 		return ret;
 
 	return arena_write_bytes(arena, arena->infooff, super,
-			sizeof(struct btt_sb));
+			sizeof(struct btt_sb), NVDIMM_IO_NORMAL);
 }
 
 static int btt_info_read(struct arena_info *arena, struct btt_sb *super)
 {
 	WARN_ON(!super);
 	return arena_read_bytes(arena, arena->infooff, super,
-			sizeof(struct btt_sb));
+			sizeof(struct btt_sb), NVDIMM_IO_NORMAL);
 }
 
 /*
@@ -79,16 +79,17 @@ static int btt_info_read(struct arena_info *arena, struct btt_sb *super)
  *   mapping is in little-endian
  *   mapping contains 'E' and 'Z' flags as desired
  */
-static int __btt_map_write(struct arena_info *arena, u32 lba, __le32 mapping)
+static int __btt_map_write(struct arena_info *arena, u32 lba, __le32 mapping,
+		u32 flags)
 {
 	u64 ns_off = arena->mapoff + (lba * MAP_ENT_SIZE);
 
 	WARN_ON(lba >= arena->external_nlba);
-	return arena_write_bytes(arena, ns_off, &mapping, MAP_ENT_SIZE);
+	return arena_write_bytes(arena, ns_off, &mapping, MAP_ENT_SIZE, flags);
 }
 
 static int btt_map_write(struct arena_info *arena, u32 lba, u32 mapping,
-			u32 z_flag, u32 e_flag)
+			u32 z_flag, u32 e_flag, u32 rwb_flags)
 {
 	u32 ze;
 	__le32 mapping_le;
@@ -127,11 +128,11 @@ static int btt_map_write(struct arena_info *arena, u32 lba, u32 mapping,
 	}
 
 	mapping_le = cpu_to_le32(mapping);
-	return __btt_map_write(arena, lba, mapping_le);
+	return __btt_map_write(arena, lba, mapping_le, rwb_flags);
 }
 
 static int btt_map_read(struct arena_info *arena, u32 lba, u32 *mapping,
-			int *trim, int *error)
+			int *trim, int *error, u32 rwb_flags)
 {
 	int ret;
 	__le32 in;
@@ -140,7 +141,7 @@ static int btt_map_read(struct arena_info *arena, u32 lba, u32 *mapping,
 
 	WARN_ON(lba >= arena->external_nlba);
 
-	ret = arena_read_bytes(arena, ns_off, &in, MAP_ENT_SIZE);
+	ret = arena_read_bytes(arena, ns_off, &in, MAP_ENT_SIZE, rwb_flags);
 	if (ret)
 		return ret;
 
@@ -189,7 +190,7 @@ static int btt_log_read_pair(struct arena_info *arena, u32 lane,
 	WARN_ON(!ent);
 	return arena_read_bytes(arena,
 			arena->logoff + (2 * lane * LOG_ENT_SIZE), ent,
-			2 * LOG_ENT_SIZE);
+			2 * LOG_ENT_SIZE, NVDIMM_IO_NORMAL);
 }
 
 static struct dentry *debugfs_root;
@@ -335,7 +336,7 @@ static int btt_log_read(struct arena_info *arena, u32 lane,
  * btt_flog_write is the wrapper for updating the freelist elements
  */
 static int __btt_log_write(struct arena_info *arena, u32 lane,
-			u32 sub, struct log_entry *ent)
+			u32 sub, struct log_entry *ent, u32 flags)
 {
 	int ret;
 	/*
@@ -350,13 +351,13 @@ static int __btt_log_write(struct arena_info *arena, u32 lane,
 	void *src = ent;
 
 	/* split the 16B write into atomic, durable halves */
-	ret = arena_write_bytes(arena, ns_off, src, log_half);
+	ret = arena_write_bytes(arena, ns_off, src, log_half, flags);
 	if (ret)
 		return ret;
 
 	ns_off += log_half;
 	src += log_half;
-	return arena_write_bytes(arena, ns_off, src, log_half);
+	return arena_write_bytes(arena, ns_off, src, log_half, flags);
 }
 
 static int btt_flog_write(struct arena_info *arena, u32 lane, u32 sub,
@@ -364,7 +365,7 @@ static int btt_flog_write(struct arena_info *arena, u32 lane, u32 sub,
 {
 	int ret;
 
-	ret = __btt_log_write(arena, lane, sub, ent);
+	ret = __btt_log_write(arena, lane, sub, ent, NVDIMM_IO_ATOMIC);
 	if (ret)
 		return ret;
 
@@ -397,7 +398,7 @@ static int btt_map_init(struct arena_info *arena)
 		size_t size = min(mapsize, chunk_size);
 
 		ret = arena_write_bytes(arena, arena->mapoff + offset, zerobuf,
-				size);
+				size, NVDIMM_IO_NORMAL);
 		if (ret)
 			goto free;
 
@@ -428,10 +429,10 @@ static int btt_log_init(struct arena_info *arena)
 		log.old_map = cpu_to_le32(arena->external_nlba + i);
 		log.new_map = cpu_to_le32(arena->external_nlba + i);
 		log.seq = cpu_to_le32(LOG_SEQ_INIT);
-		ret = __btt_log_write(arena, i, 0, &log);
+		ret = __btt_log_write(arena, i, 0, &log, NVDIMM_IO_NORMAL);
 		if (ret)
 			return ret;
-		ret = __btt_log_write(arena, i, 1, &zerolog);
+		ret = __btt_log_write(arena, i, 1, &zerolog, NVDIMM_IO_NORMAL);
 		if (ret)
 			return ret;
 	}
@@ -470,7 +471,7 @@ static int btt_freelist_init(struct arena_info *arena)
 
 		/* Check if map recovery is needed */
 		ret = btt_map_read(arena, le32_to_cpu(log_new.lba), &map_entry,
-				NULL, NULL);
+				NULL, NULL, NVDIMM_IO_NORMAL);
 		if (ret)
 			return ret;
 		if ((le32_to_cpu(log_new.new_map) != map_entry) &&
@@ -480,7 +481,8 @@ static int btt_freelist_init(struct arena_info *arena)
 			 * to complete the map write. So fix up the map.
 			 */
 			ret = btt_map_write(arena, le32_to_cpu(log_new.lba),
-					le32_to_cpu(log_new.new_map), 0, 0);
+					le32_to_cpu(log_new.new_map), 0, 0,
+					NVDIMM_IO_NORMAL);
 			if (ret)
 				return ret;
 		}
@@ -875,7 +877,7 @@ static int btt_data_read(struct arena_info *arena, struct page *page,
 	u64 nsoff = to_namespace_offset(arena, lba);
 	void *mem = kmap_atomic(page);
 
-	ret = arena_read_bytes(arena, nsoff, mem + off, len);
+	ret = arena_read_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
 	kunmap_atomic(mem);
 
 	return ret;
@@ -888,7 +890,7 @@ static int btt_data_write(struct arena_info *arena, u32 lba,
 	u64 nsoff = to_namespace_offset(arena, lba);
 	void *mem = kmap_atomic(page);
 
-	ret = arena_write_bytes(arena, nsoff, mem + off, len);
+	ret = arena_write_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
 	kunmap_atomic(mem);
 
 	return ret;
@@ -931,10 +933,12 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
 		mem = kmap_atomic(bv.bv_page);
 		if (rw)
 			ret = arena_write_bytes(arena, meta_nsoff,
-					mem + bv.bv_offset, cur_len);
+					mem + bv.bv_offset, cur_len,
+					NVDIMM_IO_ATOMIC);
 		else
 			ret = arena_read_bytes(arena, meta_nsoff,
-					mem + bv.bv_offset, cur_len);
+					mem + bv.bv_offset, cur_len,
+					NVDIMM_IO_ATOMIC);
 
 		kunmap_atomic(mem);
 		if (ret)
@@ -976,7 +980,8 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
 
 		cur_len = min(btt->sector_size, len);
 
-		ret = btt_map_read(arena, premap, &postmap, &t_flag, &e_flag);
+		ret = btt_map_read(arena, premap, &postmap, &t_flag, &e_flag,
+				NVDIMM_IO_ATOMIC);
 		if (ret)
 			goto out_lane;
 
@@ -1006,7 +1011,7 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
 			barrier();
 
 			ret = btt_map_read(arena, premap, &new_map, &t_flag,
-						&e_flag);
+						&e_flag, NVDIMM_IO_ATOMIC);
 			if (ret)
 				goto out_rtt;
 
@@ -1093,7 +1098,8 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 		}
 
 		lock_map(arena, premap);
-		ret = btt_map_read(arena, premap, &old_postmap, NULL, NULL);
+		ret = btt_map_read(arena, premap, &old_postmap, NULL, NULL,
+				NVDIMM_IO_ATOMIC);
 		if (ret)
 			goto out_map;
 		if (old_postmap >= arena->internal_nlba) {
@@ -1110,7 +1116,8 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 		if (ret)
 			goto out_map;
 
-		ret = btt_map_write(arena, premap, new_postmap, 0, 0);
+		ret = btt_map_write(arena, premap, new_postmap, 0, 0,
+			NVDIMM_IO_NORMAL);
 		if (ret)
 			goto out_map;
 
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 4b76af2..0ecb001 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -273,7 +273,8 @@ static int __nd_btt_probe(struct nd_btt *nd_btt,
 	if (!btt_sb || !ndns || !nd_btt)
 		return -ENODEV;
 
-	if (nvdimm_read_bytes(ndns, SZ_4K, btt_sb, sizeof(*btt_sb)))
+	if (nvdimm_read_bytes(ndns, SZ_4K, btt_sb, sizeof(*btt_sb),
+		NVDIMM_IO_NORMAL))
 		return -ENXIO;
 
 	if (nvdimm_namespace_capacity(ndns) < SZ_16M)
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 93d128d..a89f63e 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -228,7 +228,8 @@ u64 nd_sb_checksum(struct nd_gen_sb *nd_gen_sb)
 EXPORT_SYMBOL(nd_sb_checksum);
 
 static int nsio_rw_bytes(struct nd_namespace_common *ndns,
-		resource_size_t offset, void *buf, size_t size, int rw)
+		resource_size_t offset, void *buf, size_t size, int rw,
+		u32 flags)
 {
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
@@ -259,7 +260,8 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 		 * work around this collision.
 		 */
 		if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)
-				&& (!ndns->claim || !is_nd_btt(ndns->claim))) {
+				&& !(flags & NVDIMM_IO_ATOMIC)
+				&& !ndns->claim) {
 			long cleared;
 
 			cleared = nvdimm_clear_poison(&ndns->dev,
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 77d0321..12be701 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -33,6 +33,11 @@ enum {
 	INT_LBASIZE_ALIGNMENT = 64,
 };
 
+enum {
+	NVDIMM_IO_NORMAL = 0,
+	NVDIMM_IO_ATOMIC = 1,
+};
+
 struct nd_poison {
 	u64 start;
 	u64 length;
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 335c817..efa87f4 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -357,7 +357,8 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	if (!is_nd_pmem(nd_pfn->dev.parent))
 		return -ENODEV;
 
-	if (nvdimm_read_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb)))
+	if (nvdimm_read_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb),
+		NVDIMM_IO_NORMAL))
 		return -ENXIO;
 
 	if (memcmp(pfn_sb->signature, sig, PFN_SIG_LEN) != 0)
@@ -662,7 +663,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	checksum = nd_sb_checksum((struct nd_gen_sb *) pfn_sb);
 	pfn_sb->checksum = cpu_to_le64(checksum);
 
-	return nvdimm_write_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb));
+	return nvdimm_write_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb),
+		NVDIMM_IO_NORMAL);
 }
 
 /*
diff --git a/include/linux/nd.h b/include/linux/nd.h
index fa66aee..a1a46d3 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -48,7 +48,7 @@ struct nd_namespace_common {
 	struct device dev;
 	struct device *claim;
 	int (*rw_bytes)(struct nd_namespace_common *, resource_size_t offset,
-			void *buf, size_t size, int rw);
+			void *buf, size_t size, int rw, u32 flags);
 };
 
 static inline struct nd_namespace_common *to_ndns(struct device *dev)
@@ -134,9 +134,9 @@ static inline struct nd_namespace_blk *to_nd_namespace_blk(const struct device *
  * @buf is up-to-date upon return from this routine.
  */
 static inline int nvdimm_read_bytes(struct nd_namespace_common *ndns,
-		resource_size_t offset, void *buf, size_t size)
+		resource_size_t offset, void *buf, size_t size, u32 flags)
 {
-	return ndns->rw_bytes(ndns, offset, buf, size, READ);
+	return ndns->rw_bytes(ndns, offset, buf, size, READ, flags);
 }
 
 /**
@@ -152,9 +152,9 @@ static inline int nvdimm_read_bytes(struct nd_namespace_common *ndns,
  * to media is handled internal to the @ndns driver, if at all.
  */
 static inline int nvdimm_write_bytes(struct nd_namespace_common *ndns,
-		resource_size_t offset, void *buf, size_t size)
+		resource_size_t offset, void *buf, size_t size, u32 flags)
 {
-	return ndns->rw_bytes(ndns, offset, buf, size, WRITE);
+	return ndns->rw_bytes(ndns, offset, buf, size, WRITE, flags);
 }
 
 #define MODULE_ALIAS_ND_DEVICE(type) \
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
