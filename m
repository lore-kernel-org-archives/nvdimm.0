Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D252575
	for <nvdimm@lists.linux.dev>; Wed, 29 Jun 2022 13:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656511060; x=1688047060;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=w/6Q7O6GEZNOlUMT7r8ge77hg2bDL8J4HlnZ4GUxTsc=;
  b=XQEXDoiHJxUuxSeJwsrRglKcMcfowgeM/Vw1yhvLrcaXawIRB5wICZgh
   MYHyoNK6dFGQsxH3EyEL5owgP8vW6WOes1Ul7ORDPd/tMqtDkkV1UurYO
   xBXMsAG5CEouH0HahGHDc9z3McR6CG1mh8s7zRObLEi3B0ODShpnqX5jT
   dCb8G/U8N+92gwbcfWV8E+q6Lfp2G0bDZY3YWS5otzSqU6DnTb7uGOJGl
   KE65Gh8nv+R6UFcAlVR58ZGpwyKI3NOU6DwBZiWPkhWYyswHiUhclBhjc
   IN0Sc9ybLY/mPemzNiw68DYrLiQs3jmLNR4FD+7+MUFj9gqCm+nlzdr7W
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="265073128"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="265073128"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 06:57:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="647402034"
Received: from ac02.sh.intel.com ([10.112.227.141])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jun 2022 06:57:37 -0700
From: "Dennis.Wu" <dennis.wu@intel.com>
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	"Dennis.Wu" <dennis.wu@intel.com>
Subject: [PATCH] nvdimm: Add NVDIMM_NO_DEEPFLUSH flag to control btt data deepflush
Date: Wed, 29 Jun 2022 21:58:01 +0800
Message-Id: <20220629135801.192821-1-dennis.wu@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reason: we can have a global control of deepflush in the nfit module
by "no_deepflush" param. In the case of "no_deepflush=0", we still
need control data deepflush or not by the NVDIMM_NO_DEEPFLUSH flag.
In the BTT, the btt information block(btt_sb) will use deepflush.
Other like the data blocks(512B or 4KB),4 bytes btt_map and 16 bytes
bflog will not use the deepflush. so that, during the runtime, no
deepflush will be called in the BTT.

How: Add flag NVDIMM_NO_DEEPFLUSH which can use with NVDIMM_IO_ATOMIC
like NVDIMM_NO_DEEPFLUSH | NVDIMM_IO_ATOMIC.
"if (!(flags & NVDIMM_NO_DEEPFLUSH))", nvdimm_flush() will be called,
otherwise, the pmem_wmb() called to fense all previous write.

Signed-off-by: Dennis.Wu <dennis.wu@intel.com>
---
 drivers/nvdimm/btt.c   | 26 +++++++++++++++++---------
 drivers/nvdimm/claim.c |  9 +++++++--
 drivers/nvdimm/nd.h    |  4 ++++
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 9613e54c7a67..c71ba7a1edd0 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -70,6 +70,10 @@ static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
 	dev_WARN_ONCE(to_dev(arena), !IS_ALIGNED(arena->info2off, 512),
 		"arena->info2off: %#llx is unaligned\n", arena->info2off);
 
+	/*
+	 * btt_sb is critial information and need proper write
+	 * nvdimm_flush will be called (deepflush)
+	 */
 	ret = arena_write_bytes(arena, arena->info2off, super,
 			sizeof(struct btt_sb), 0);
 	if (ret)
@@ -384,7 +388,8 @@ static int btt_flog_write(struct arena_info *arena, u32 lane, u32 sub,
 {
 	int ret;
 
-	ret = __btt_log_write(arena, lane, sub, ent, NVDIMM_IO_ATOMIC);
+	ret = __btt_log_write(arena, lane, sub, ent,
+		NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
 	if (ret)
 		return ret;
 
@@ -429,7 +434,7 @@ static int btt_map_init(struct arena_info *arena)
 		dev_WARN_ONCE(to_dev(arena), size < 512,
 			"chunk size: %#zx is unaligned\n", size);
 		ret = arena_write_bytes(arena, arena->mapoff + offset, zerobuf,
-				size, 0);
+				size, NVDIMM_NO_DEEPFLUSH);
 		if (ret)
 			goto free;
 
@@ -473,7 +478,7 @@ static int btt_log_init(struct arena_info *arena)
 		dev_WARN_ONCE(to_dev(arena), size < 512,
 			"chunk size: %#zx is unaligned\n", size);
 		ret = arena_write_bytes(arena, arena->logoff + offset, zerobuf,
-				size, 0);
+				size, NVDIMM_NO_DEEPFLUSH);
 		if (ret)
 			goto free;
 
@@ -487,7 +492,7 @@ static int btt_log_init(struct arena_info *arena)
 		ent.old_map = cpu_to_le32(arena->external_nlba + i);
 		ent.new_map = cpu_to_le32(arena->external_nlba + i);
 		ent.seq = cpu_to_le32(LOG_SEQ_INIT);
-		ret = __btt_log_write(arena, i, 0, &ent, 0);
+		ret = __btt_log_write(arena, i, 0, &ent, NVDIMM_NO_DEEPFLUSH);
 		if (ret)
 			goto free;
 	}
@@ -518,7 +523,7 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
 			unsigned long chunk = min(len, PAGE_SIZE);
 
 			ret = arena_write_bytes(arena, nsoff, zero_page,
-				chunk, 0);
+				chunk, NVDIMM_NO_DEEPFLUSH);
 			if (ret)
 				break;
 			len -= chunk;
@@ -592,7 +597,8 @@ static int btt_freelist_init(struct arena_info *arena)
 			 * to complete the map write. So fix up the map.
 			 */
 			ret = btt_map_write(arena, le32_to_cpu(log_new.lba),
-					le32_to_cpu(log_new.new_map), 0, 0, 0);
+					le32_to_cpu(log_new.new_map), 0, 0,
+					NVDIMM_NO_DEEPFLUSH);
 			if (ret)
 				return ret;
 		}
@@ -1123,7 +1129,8 @@ static int btt_data_write(struct arena_info *arena, u32 lba,
 	u64 nsoff = to_namespace_offset(arena, lba);
 	void *mem = kmap_atomic(page);
 
-	ret = arena_write_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
+	ret = arena_write_bytes(arena, nsoff, mem + off, len,
+		NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
 	kunmap_atomic(mem);
 
 	return ret;
@@ -1260,7 +1267,8 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
 		ret = btt_data_read(arena, page, off, postmap, cur_len);
 		if (ret) {
 			/* Media error - set the e_flag */
-			if (btt_map_write(arena, premap, postmap, 0, 1, NVDIMM_IO_ATOMIC))
+			if (btt_map_write(arena, premap, postmap, 0, 1,
+				NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH))
 				dev_warn_ratelimited(to_dev(arena),
 					"Error persistently tracking bad blocks at %#x\n",
 					premap);
@@ -1393,7 +1401,7 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 			goto out_map;
 
 		ret = btt_map_write(arena, premap, new_postmap, 0, 0,
-			NVDIMM_IO_ATOMIC);
+			NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
 		if (ret)
 			goto out_map;
 
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 030dbde6b088..c1fa3291c063 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -294,9 +294,14 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 	}
 
 	memcpy_flushcache(nsio->addr + offset, buf, size);
-	ret = nvdimm_flush(to_nd_region(ndns->dev.parent), NULL);
-	if (ret)
+	if (!(flags & NVDIMM_NO_DEEPFLUSH)) {
+		ret = nvdimm_flush(to_nd_region(ndns->dev.parent), NULL);
+		if (ret)
+			rc = ret;
+	} else {
 		rc = ret;
+		pmem_wmb();
+	}
 
 	return rc;
 }
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index ec5219680092..a16e259a8cff 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -22,7 +22,11 @@ enum {
 	 */
 	ND_MAX_LANES = 256,
 	INT_LBASIZE_ALIGNMENT = 64,
+	/*
+	 * NVDIMM_IO_ATOMIC | NVDIMM_NO_DEEPFLUSH is support.
+	 */
 	NVDIMM_IO_ATOMIC = 1,
+	NVDIMM_NO_DEEPFLUSH = 2,
 };
 
 struct nvdimm_drvdata {
-- 
2.27.0

