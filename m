Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A2D2321A0480F
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 15:44:32 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] nvdimm, btt: make sure initializing new metadata clears poison
Date: Wed, 26 Apr 2017 16:43:07 -0600
Message-Id: <20170426224307.28075-1-vishal.l.verma@intel.com>
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

If we had badblocks/poison in the metadata area of a BTT, recreating the
BTT would not clear the poison in all cases, notably the flog area. This
is because rw_bytes will only clear errors if the request being sent
down is 512B aligned and sized.

Make sure that when writing the map and info blocks, the rw_bytes being
sent are of the correct size/alignment. For the flog, instead of doing
the smaller log_entry writes only, first do a 'wipe' of the entire area
by writing zeroes in large enough chunks so that errors get cleared.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c | 54 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 368795a..6054e83 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -57,6 +57,14 @@ static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
 {
 	int ret;
 
+	/*
+	 * infooff and info2off should always be at least 512B aligned.
+	 * We rely on that to make sure rw_bytes does error clearing
+	 * correctly, so make sure that is the case.
+	 */
+	WARN_ON_ONCE(!IS_ALIGNED(arena->infooff, 512));
+	WARN_ON_ONCE(!IS_ALIGNED(arena->info2off, 512));
+
 	ret = arena_write_bytes(arena, arena->info2off, super,
 			sizeof(struct btt_sb));
 	if (ret)
@@ -393,9 +401,17 @@ static int btt_map_init(struct arena_info *arena)
 	if (!zerobuf)
 		return -ENOMEM;
 
+	/*
+	 * mapoff should always be at least 512B  aligned. We rely on that to
+	 * make sure rw_bytes does error clearing correctly, so make sure that
+	 * is the case.
+	 */
+	WARN_ON_ONCE(!IS_ALIGNED(arena->mapoff, 512));
+
 	while (mapsize) {
 		size_t size = min(mapsize, chunk_size);
 
+		WARN_ON_ONCE(size < 512);
 		ret = arena_write_bytes(arena, arena->mapoff + offset, zerobuf,
 				size);
 		if (ret)
@@ -417,11 +433,36 @@ static int btt_map_init(struct arena_info *arena)
  */
 static int btt_log_init(struct arena_info *arena)
 {
+	size_t logsize = arena->info2off - arena->logoff;
+	size_t chunk_size = SZ_4K, offset = 0;
+	struct log_entry log;
+	void *zerobuf;
 	int ret;
 	u32 i;
-	struct log_entry log, zerolog;
 
-	memset(&zerolog, 0, sizeof(zerolog));
+	zerobuf = kzalloc(chunk_size, GFP_KERNEL);
+	if (!zerobuf)
+		return -ENOMEM;
+	/*
+	 * logoff should always be at least 512B  aligned. We rely on that to
+	 * make sure rw_bytes does error clearing correctly, so make sure that
+	 * is the case.
+	 */
+	WARN_ON_ONCE(!IS_ALIGNED(arena->logoff, 512));
+
+	while (logsize) {
+		size_t size = min(logsize, chunk_size);
+
+		WARN_ON_ONCE(size < 512);
+		ret = arena_write_bytes(arena, arena->logoff + offset, zerobuf,
+				size);
+		if (ret)
+			goto free;
+
+		offset += size;
+		logsize -= size;
+		cond_resched();
+	}
 
 	for (i = 0; i < arena->nfree; i++) {
 		log.lba = cpu_to_le32(i);
@@ -430,13 +471,12 @@ static int btt_log_init(struct arena_info *arena)
 		log.seq = cpu_to_le32(LOG_SEQ_INIT);
 		ret = __btt_log_write(arena, i, 0, &log);
 		if (ret)
-			return ret;
-		ret = __btt_log_write(arena, i, 1, &zerolog);
-		if (ret)
-			return ret;
+			goto free;
 	}
 
-	return 0;
+ free:
+	kfree(zerobuf);
+	return ret;
 }
 
 static int btt_freelist_init(struct arena_info *arena)
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
