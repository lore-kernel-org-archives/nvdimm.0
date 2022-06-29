Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9923E7E0
	for <nvdimm@lists.linux.dev>; Wed, 29 Jun 2022 12:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656506665; x=1688042665;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=U0Vgp+01jpqVuj3tOsx9veURZ0rxMbCvTMpUiVszy1I=;
  b=XAwcvkE1Q852tHrS3ptGUFcC2wBWdNc3028jphQyisqqj+n9B2yphA8V
   bqzyb63Pnk4JWX0Y90rnmhLBvNBXBj3I8sIa6/x47pkKmaqxDCj/iQILc
   oNogci55OHoJxCU/mIk5cp+35tt+3nO2BfGAluWuGlfMnUNzb9u9yOMCJ
   w3fjlIFBiqBDph3Bra9zYO2TggVvrT88rvl+vL+WkVruKwQDPYwGrWLK4
   xwWieYwYRrqT8ypGg0p/vC9DKpo/UQKwtwsTIXVSO7zkAfRCZJiyMO4kg
   pAgTodWNKM8/x7U2vA83dnkoTinrvNo7SiwuLwjpsEoEZ0iOUO4KKCihk
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="279565112"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="279565112"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 05:44:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="837115177"
Received: from ac02.sh.intel.com ([10.112.227.141])
  by fmsmga006.fm.intel.com with ESMTP; 29 Jun 2022 05:44:23 -0700
From: "Dennis.Wu" <dennis.wu@intel.com>
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	"Dennis.Wu" <dennis.wu@intel.com>
Subject: [PATCH] nvdimm: Add NVDIMM_NO_DEEPFLUSH flag to control btt data deepflush
Date: Wed, 29 Jun 2022 20:44:19 +0800
Message-Id: <20220629124419.3916-1-dennis.wu@intel.com>
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
 drivers/nvdimm/btt.c   | 30 +++++++++++++++++++-----------
 drivers/nvdimm/claim.c |  9 +++++++--
 drivers/nvdimm/nd.h    |  4 ++++
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index da3f007a1211..a3787dd3b017 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -71,6 +71,10 @@ static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
 	dev_WARN_ONCE(to_dev(arena), !IS_ALIGNED(arena->info2off, 512),
 		"arena->info2off: %#llx is unaligned\n", arena->info2off);
 
+	/*
+	 * btt_sb is critial information and need proper write
+	 * nvdimm_flush will be called (deepflush)
+	 */
 	ret = arena_write_bytes(arena, arena->info2off, super,
 			sizeof(struct btt_sb), 0);
 	if (ret)
@@ -385,7 +389,8 @@ static int btt_flog_write(struct arena_info *arena, u32 lane, u32 sub,
 {
 	int ret;
 
-	ret = __btt_log_write(arena, lane, sub, ent, NVDIMM_IO_ATOMIC);
+	ret = __btt_log_write(arena, lane, sub, ent,
+		NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
 	if (ret)
 		return ret;
 
@@ -430,7 +435,7 @@ static int btt_map_init(struct arena_info *arena)
 		dev_WARN_ONCE(to_dev(arena), size < 512,
 			"chunk size: %#zx is unaligned\n", size);
 		ret = arena_write_bytes(arena, arena->mapoff + offset, zerobuf,
-				size, 0);
+				size, NVDIMM_NO_DEEPFLUSH);
 		if (ret)
 			goto free;
 
@@ -474,7 +479,7 @@ static int btt_log_init(struct arena_info *arena)
 		dev_WARN_ONCE(to_dev(arena), size < 512,
 			"chunk size: %#zx is unaligned\n", size);
 		ret = arena_write_bytes(arena, arena->logoff + offset, zerobuf,
-				size, 0);
+				size, NVDIMM_NO_DEEPFLUSH);
 		if (ret)
 			goto free;
 
@@ -488,7 +493,7 @@ static int btt_log_init(struct arena_info *arena)
 		ent.old_map = cpu_to_le32(arena->external_nlba + i);
 		ent.new_map = cpu_to_le32(arena->external_nlba + i);
 		ent.seq = cpu_to_le32(LOG_SEQ_INIT);
-		ret = __btt_log_write(arena, i, 0, &ent, 0);
+		ret = __btt_log_write(arena, i, 0, &ent, NVDIMM_NO_DEEPFLUSH);
 		if (ret)
 			goto free;
 	}
@@ -519,7 +524,7 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
 			unsigned long chunk = min(len, PAGE_SIZE);
 
 			ret = arena_write_bytes(arena, nsoff, zero_page,
-				chunk, 0);
+				chunk, NVDIMM_NO_DEEPFLUSH);
 			if (ret)
 				break;
 			len -= chunk;
@@ -593,7 +598,8 @@ static int btt_freelist_init(struct arena_info *arena)
 			 * to complete the map write. So fix up the map.
 			 */
 			ret = btt_map_write(arena, le32_to_cpu(log_new.lba),
-					le32_to_cpu(log_new.new_map), 0, 0, 0);
+					le32_to_cpu(log_new.new_map), 0, 0,
+					NVDIMM_NO_DEEPFLUSH);
 			if (ret)
 				return ret;
 		}
@@ -1124,7 +1130,8 @@ static int btt_data_write(struct arena_info *arena, u32 lba,
 	u64 nsoff = to_namespace_offset(arena, lba);
 	void *mem = kmap_atomic(page);
 
-	ret = arena_write_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
+	ret = arena_write_bytes(arena, nsoff, mem + off, len,
+		NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
 	kunmap_atomic(mem);
 
 	return ret;
@@ -1168,11 +1175,11 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
 		if (rw)
 			ret = arena_write_bytes(arena, meta_nsoff,
 					mem + bv.bv_offset, cur_len,
-					NVDIMM_IO_ATOMIC);
+					NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
 		else
 			ret = arena_read_bytes(arena, meta_nsoff,
 					mem + bv.bv_offset, cur_len,
-					NVDIMM_IO_ATOMIC);
+					NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
 
 		kunmap_atomic(mem);
 		if (ret)
@@ -1263,7 +1270,8 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
 		ret = btt_data_read(arena, page, off, postmap, cur_len);
 		if (ret) {
 			/* Media error - set the e_flag */
-			if (btt_map_write(arena, premap, postmap, 0, 1, NVDIMM_IO_ATOMIC))
+			if (btt_map_write(arena, premap, postmap, 0, 1,
+				NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH))
 				dev_warn_ratelimited(to_dev(arena),
 					"Error persistently tracking bad blocks at %#x\n",
 					premap);
@@ -1396,7 +1404,7 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
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
index 6f8ce114032d..4d8c23c8acc4 100644
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

