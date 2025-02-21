Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9451B205AB0
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 08:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740125709; cv=none; b=bBtH0pF10ssbMrEldJp7kRbQkzsPVd6jW+mXbr2rJrYwDsF6Qj1NBp3k2Txzn9G15xgSna9YRGS0ydYZe07FAxpfF5JhOIUaVOooo7XUTcQQqDS4JTUYN6F2mkpk5q3nC4Iuwispmcnk9wmsHDDkCdIl//Z2JTPShf2TWzHZ0fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740125709; c=relaxed/simple;
	bh=/3Nv2WH63vhmb0IIk1pnnQl9RFsEL+I20wtkbhg6JHc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YpJ2A4tyBvre/CfRdZaSpzPCO8slPVkZzmblI/MG/mWIYPrjKnadtIWZvweQN2wwJNEgztpu308vAQRv2k4xSrlKReM3pIv5/96YYyFyO9T3PmHDNemBRAjFUg/jFpJxJASz7gRapK/AlQ5U5Bt1NIBdnUIcq1OsOvedQ2Ti5U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YzjbP0H01z4f3lCf
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1E33B1A149B
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:15:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgC3Gl_8NbhnHF3eEQ--.3944S16;
	Fri, 21 Feb 2025 16:15:03 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: axboe@kernel.dk,
	song@kernel.org,
	colyli@kernel.org,
	yukuai3@huawei.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	dlemoal@kernel.org,
	yanjun.zhu@linux.dev,
	kch@nvidia.com,
	hare@suse.de,
	zhengqixing@huawei.com,
	john.g.garry@oracle.com,
	geliang@kernel.org,
	xni@redhat.com,
	colyli@suse.de
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 12/12] badblocks: use sector_t instead of int to avoid truncation of badblocks length
Date: Fri, 21 Feb 2025 16:11:09 +0800
Message-Id: <20250221081109.734170-13-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3Gl_8NbhnHF3eEQ--.3944S16
X-Coremail-Antispam: 1UD129KBjvJXoW3KrW3KrW7XF1DWF1Duw1kuFg_yoWkAr13pa
	1DJa4fJryUWF18W3WUZayq9r1Fy34ftFWUK3yUW34jgFykK3s7tF1kXFyYqFyjgFW3Grn0
	q3WY9rW3ua4kGrJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPqb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVWxJr0_GcWl84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
	WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7
	AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_Wr
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI
	0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x
	07jxwIDUUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

There is a truncation of badblocks length issue when set badblocks as
follow:

echo "2055 4294967299" > bad_blocks
cat bad_blocks
2055 3

Change 'sectors' argument type from 'int' to 'sector_t'.

This change avoids truncation of badblocks length for large sectors by
replacing 'int' with 'sector_t' (u64), enabling proper handling of larger
disk sizes and ensuring compatibility with 64-bit sector addressing.

Fixes: 9e0e252a048b ("badblocks: Add core badblock management code")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 block/badblocks.c             | 20 ++++++++------------
 drivers/block/null_blk/main.c |  2 +-
 drivers/md/md.h               |  6 +++---
 drivers/md/raid1-10.c         |  2 +-
 drivers/md/raid1.c            |  4 ++--
 drivers/md/raid10.c           |  8 ++++----
 drivers/nvdimm/nd.h           |  2 +-
 drivers/nvdimm/pfn_devs.c     |  7 ++++---
 drivers/nvdimm/pmem.c         |  2 +-
 include/linux/badblocks.h     |  8 ++++----
 10 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 8f057563488a..14e3be47d22d 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -836,7 +836,7 @@ static bool try_adjacent_combine(struct badblocks *bb, int prev)
 }
 
 /* Do exact work to set bad block range into the bad block table */
-static bool _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
+static bool _badblocks_set(struct badblocks *bb, sector_t s, sector_t sectors,
 			   int acknowledged)
 {
 	int len = 0, added = 0;
@@ -956,8 +956,6 @@ static bool _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	if (sectors > 0)
 		goto re_insert;
 
-	WARN_ON(sectors < 0);
-
 	/*
 	 * Check whether the following already set range can be
 	 * merged. (prev < 0) condition is not handled here,
@@ -1048,7 +1046,7 @@ static int front_splitting_clear(struct badblocks *bb, int prev,
 }
 
 /* Do the exact work to clear bad block range from the bad block table */
-static bool _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
+static bool _badblocks_clear(struct badblocks *bb, sector_t s, sector_t sectors)
 {
 	struct badblocks_context bad;
 	int prev = -1, hint = -1;
@@ -1171,8 +1169,6 @@ static bool _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 	if (sectors > 0)
 		goto re_clear;
 
-	WARN_ON(sectors < 0);
-
 	if (cleared) {
 		badblocks_update_acked(bb);
 		set_changed(bb);
@@ -1187,8 +1183,8 @@ static bool _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 }
 
 /* Do the exact work to check bad blocks range from the bad block table */
-static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
-			    sector_t *first_bad, int *bad_sectors)
+static int _badblocks_check(struct badblocks *bb, sector_t s, sector_t sectors,
+			    sector_t *first_bad, sector_t *bad_sectors)
 {
 	int prev = -1, hint = -1, set = 0;
 	struct badblocks_context bad;
@@ -1298,8 +1294,8 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
  * -1: there are bad blocks which have not yet been acknowledged in metadata.
  * plus the start/length of the first bad section we overlap.
  */
-int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
-			sector_t *first_bad, int *bad_sectors)
+int badblocks_check(struct badblocks *bb, sector_t s, sector_t sectors,
+			sector_t *first_bad, sector_t *bad_sectors)
 {
 	unsigned int seq;
 	int rv;
@@ -1340,7 +1336,7 @@ EXPORT_SYMBOL_GPL(badblocks_check);
  *  true: success
  *  false: failed to set badblocks (out of space)
  */
-bool badblocks_set(struct badblocks *bb, sector_t s, int sectors,
+bool badblocks_set(struct badblocks *bb, sector_t s, sector_t sectors,
 		   int acknowledged)
 {
 	return _badblocks_set(bb, s, sectors, acknowledged);
@@ -1361,7 +1357,7 @@ EXPORT_SYMBOL_GPL(badblocks_set);
  *  true: success
  *  false: failed to clear badblocks
  */
-bool badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
+bool badblocks_clear(struct badblocks *bb, sector_t s, sector_t sectors)
 {
 	return _badblocks_clear(bb, s, sectors);
 }
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 623db72ad66b..6e7d80b6e92b 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1302,7 +1302,7 @@ static inline blk_status_t null_handle_badblocks(struct nullb_cmd *cmd,
 {
 	struct badblocks *bb = &cmd->nq->dev->badblocks;
 	sector_t first_bad;
-	int bad_sectors;
+	sector_t bad_sectors;
 
 	if (badblocks_check(bb, sector, nr_sectors, &first_bad, &bad_sectors))
 		return BLK_STS_IOERR;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 923a0ef51efe..6edc0f71b7d4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -266,8 +266,8 @@ enum flag_bits {
 	Nonrot,			/* non-rotational device (SSD) */
 };
 
-static inline int is_badblock(struct md_rdev *rdev, sector_t s, int sectors,
-			      sector_t *first_bad, int *bad_sectors)
+static inline int is_badblock(struct md_rdev *rdev, sector_t s, sector_t sectors,
+			      sector_t *first_bad, sector_t *bad_sectors)
 {
 	if (unlikely(rdev->badblocks.count)) {
 		int rv = badblocks_check(&rdev->badblocks, rdev->data_offset + s,
@@ -284,7 +284,7 @@ static inline int rdev_has_badblock(struct md_rdev *rdev, sector_t s,
 				    int sectors)
 {
 	sector_t first_bad;
-	int bad_sectors;
+	sector_t bad_sectors;
 
 	return is_badblock(rdev, s, sectors, &first_bad, &bad_sectors);
 }
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 4378d3250bd7..62b980b12f93 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -247,7 +247,7 @@ static inline int raid1_check_read_range(struct md_rdev *rdev,
 					 sector_t this_sector, int *len)
 {
 	sector_t first_bad;
-	int bad_sectors;
+	sector_t bad_sectors;
 
 	/* no bad block overlap */
 	if (!is_badblock(rdev, this_sector, *len, &first_bad, &bad_sectors))
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8beb8cccc6af..0b2839105857 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1537,7 +1537,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		atomic_inc(&rdev->nr_pending);
 		if (test_bit(WriteErrorSeen, &rdev->flags)) {
 			sector_t first_bad;
-			int bad_sectors;
+			sector_t bad_sectors;
 			int is_bad;
 
 			is_bad = is_badblock(rdev, r1_bio->sector, max_sectors,
@@ -2886,7 +2886,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		} else {
 			/* may need to read from here */
 			sector_t first_bad = MaxSector;
-			int bad_sectors;
+			sector_t bad_sectors;
 
 			if (is_badblock(rdev, sector_nr, good_sectors,
 					&first_bad, &bad_sectors)) {
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7ed933181712..a8664e29aada 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -747,7 +747,7 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 
 	for (slot = 0; slot < conf->copies ; slot++) {
 		sector_t first_bad;
-		int bad_sectors;
+		sector_t bad_sectors;
 		sector_t dev_sector;
 		unsigned int pending;
 		bool nonrot;
@@ -1438,7 +1438,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
 			sector_t first_bad;
 			sector_t dev_sector = r10_bio->devs[i].addr;
-			int bad_sectors;
+			sector_t bad_sectors;
 			int is_bad;
 
 			is_bad = is_badblock(rdev, dev_sector, max_sectors,
@@ -3413,7 +3413,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				sector_t from_addr, to_addr;
 				struct md_rdev *rdev = conf->mirrors[d].rdev;
 				sector_t sector, first_bad;
-				int bad_sectors;
+				sector_t bad_sectors;
 				if (!rdev ||
 				    !test_bit(In_sync, &rdev->flags))
 					continue;
@@ -3609,7 +3609,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		for (i = 0; i < conf->copies; i++) {
 			int d = r10_bio->devs[i].devnum;
 			sector_t first_bad, sector;
-			int bad_sectors;
+			sector_t bad_sectors;
 			struct md_rdev *rdev;
 
 			if (r10_bio->devs[i].repl_bio)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 5ca06e9a2d29..cc5c8f3f81e8 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -673,7 +673,7 @@ static inline bool is_bad_pmem(struct badblocks *bb, sector_t sector,
 {
 	if (bb->count) {
 		sector_t first_bad;
-		int num_bad;
+		sector_t num_bad;
 
 		return !!badblocks_check(bb, sector, len / 512, &first_bad,
 				&num_bad);
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index cfdfe0eaa512..8f3e816e805d 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -367,9 +367,10 @@ static int nd_pfn_clear_memmap_errors(struct nd_pfn *nd_pfn)
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	void *zero_page = page_address(ZERO_PAGE(0));
 	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
-	int num_bad, meta_num, rc, bb_present;
+	int meta_num, rc, bb_present;
 	sector_t first_bad, meta_start;
 	struct nd_namespace_io *nsio;
+	sector_t num_bad;
 
 	if (nd_pfn->mode != PFN_MODE_PMEM)
 		return 0;
@@ -394,7 +395,7 @@ static int nd_pfn_clear_memmap_errors(struct nd_pfn *nd_pfn)
 		bb_present = badblocks_check(&nd_region->bb, meta_start,
 				meta_num, &first_bad, &num_bad);
 		if (bb_present) {
-			dev_dbg(&nd_pfn->dev, "meta: %x badblocks at %llx\n",
+			dev_dbg(&nd_pfn->dev, "meta: %llx badblocks at %llx\n",
 					num_bad, first_bad);
 			nsoff = ALIGN_DOWN((nd_region->ndr_start
 					+ (first_bad << 9)) - nsio->res.start,
@@ -413,7 +414,7 @@ static int nd_pfn_clear_memmap_errors(struct nd_pfn *nd_pfn)
 			}
 			if (rc) {
 				dev_err(&nd_pfn->dev,
-					"error clearing %x badblocks at %llx\n",
+					"error clearing %llx badblocks at %llx\n",
 					num_bad, first_bad);
 				return rc;
 			}
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index d81faa9d89c9..43156e1576c9 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -249,7 +249,7 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 	unsigned int num = PFN_PHYS(nr_pages) >> SECTOR_SHIFT;
 	struct badblocks *bb = &pmem->bb;
 	sector_t first_bad;
-	int num_bad;
+	sector_t num_bad;
 
 	if (kaddr)
 		*kaddr = pmem->virt_addr + offset;
diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
index 8764bed9ff16..996493917f36 100644
--- a/include/linux/badblocks.h
+++ b/include/linux/badblocks.h
@@ -48,11 +48,11 @@ struct badblocks_context {
 	int		ack;
 };
 
-int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
-		   sector_t *first_bad, int *bad_sectors);
-bool badblocks_set(struct badblocks *bb, sector_t s, int sectors,
+int badblocks_check(struct badblocks *bb, sector_t s, sector_t sectors,
+		    sector_t *first_bad, sector_t *bad_sectors);
+bool badblocks_set(struct badblocks *bb, sector_t s, sector_t sectors,
 		   int acknowledged);
-bool badblocks_clear(struct badblocks *bb, sector_t s, int sectors);
+bool badblocks_clear(struct badblocks *bb, sector_t s, sector_t sectors);
 void ack_all_badblocks(struct badblocks *bb);
 ssize_t badblocks_show(struct badblocks *bb, char *page, int unack);
 ssize_t badblocks_store(struct badblocks *bb, const char *page, size_t len,
-- 
2.39.2

