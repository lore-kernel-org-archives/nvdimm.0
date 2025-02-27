Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A4F229B32
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 07:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740643167; cv=none; b=SrbWYnY8107m3c/RtfxjNmoPHMFgrmueX+Q1Xn7u2ufURbTp0EtVNQULyWt2IJXM46Rk4lE63NEVajE/QeBkyKqc0LkXE79xzaEZNjSrH4kTUEDcxSVG9JHjSs3KGd1aySfYTiefShUe1eBd2/P4kyvd6YsBk0cpq71/Dm+YsGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740643167; c=relaxed/simple;
	bh=13nvwrvCEDT49k56qUAeIZalncyZDgfLetpeDdlOjBM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SQxQC35Ag0S8bajD3wu8f0+2FQlDBRwEN9QEpEfrFL3r2QS/uqh6pjctc6RwpHMjFDtC4WzcWhlmEcm5aX0YlFjKKVwASVaYxNTGxvqNkdXzteb74RqV0hr7vy42fkPCi+zDDXHClnkE2hxTbbhzOR57B6gCzFgL/cTDAh3LhoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z3Nyf0BzNz4f3jtG
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:59:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8E4F01A12BD
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:59:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl9PG8Bn6c8gFA--.31377S15;
	Thu, 27 Feb 2025 15:59:22 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: axboe@kernel.dk,
	song@kernel.org,
	yukuai3@huawei.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	dlemoal@kernel.org,
	kch@nvidia.com,
	yanjun.zhu@linux.dev,
	hare@suse.de,
	zhengqixing@huawei.com,
	colyli@kernel.org,
	geliang@kernel.org,
	xni@redhat.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH V2 11/12] md: improve return types of badblocks handling functions
Date: Thu, 27 Feb 2025 15:55:06 +0800
Message-Id: <20250227075507.151331-12-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
References: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl9PG8Bn6c8gFA--.31377S15
X-Coremail-Antispam: 1UD129KBjvJXoW3Aw1rJrWfKr4kXry5AFykGrg_yoW7Gw4fpa
	yUJF93J3yUW348W3WUZrWDC3WF9a43KFW2yrWfC342k34kKrZ3tF48XryYvFyDKF9xuF12
	q3WUWrWUuw18WrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPvb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2
	AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6r
	W5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
	v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuY
	vjxUI-eODUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

rdev_set_badblocks() only indicates success/failure, so convert its return
type from int to boolean for better semantic clarity.

rdev_clear_badblocks() return value is never used by any caller, convert it
to void. This removes unnecessary value returns.

Also update narrow_write_error() in both raid1 and raid10 to use boolean
return type to match rdev_set_badblocks().

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md.c     | 19 +++++++++----------
 drivers/md/md.h     |  8 ++++----
 drivers/md/raid1.c  |  6 +++---
 drivers/md/raid10.c |  6 +++---
 4 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 49d826e475cb..9b9b2b4131d0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9841,9 +9841,9 @@ EXPORT_SYMBOL(md_finish_reshape);
 
 /* Bad block management */
 
-/* Returns 1 on success, 0 on failure */
-int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
-		       int is_new)
+/* Returns true on success, false on failure */
+bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
+			int is_new)
 {
 	struct mddev *mddev = rdev->mddev;
 
@@ -9855,7 +9855,7 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 	 * avoid it.
 	 */
 	if (test_bit(Faulty, &rdev->flags))
-		return 1;
+		return true;
 
 	if (is_new)
 		s += rdev->new_data_offset;
@@ -9863,7 +9863,7 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 		s += rdev->data_offset;
 
 	if (!badblocks_set(&rdev->badblocks, s, sectors, 0))
-		return 0;
+		return false;
 
 	/* Make sure they get written out promptly */
 	if (test_bit(ExternalBbl, &rdev->flags))
@@ -9872,12 +9872,12 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 	set_mask_bits(&mddev->sb_flags, 0,
 		      BIT(MD_SB_CHANGE_CLEAN) | BIT(MD_SB_CHANGE_PENDING));
 	md_wakeup_thread(rdev->mddev->thread);
-	return 1;
+	return true;
 }
 EXPORT_SYMBOL_GPL(rdev_set_badblocks);
 
-int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
-			 int is_new)
+void rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
+			  int is_new)
 {
 	if (is_new)
 		s += rdev->new_data_offset;
@@ -9885,11 +9885,10 @@ int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 		s += rdev->data_offset;
 
 	if (!badblocks_clear(&rdev->badblocks, s, sectors))
-		return 0;
+		return;
 
 	if (test_bit(ExternalBbl, &rdev->flags))
 		sysfs_notify_dirent_safe(rdev->sysfs_badblocks);
-	return 1;
 }
 EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index def808064ad8..923a0ef51efe 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -289,10 +289,10 @@ static inline int rdev_has_badblock(struct md_rdev *rdev, sector_t s,
 	return is_badblock(rdev, s, sectors, &first_bad, &bad_sectors);
 }
 
-extern int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
-			      int is_new);
-extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
-				int is_new);
+extern bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
+			       int is_new);
+extern void rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
+				 int is_new);
 struct md_cluster_info;
 
 /**
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 10ea3af40991..8e9f303c5603 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2486,7 +2486,7 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	}
 }
 
-static int narrow_write_error(struct r1bio *r1_bio, int i)
+static bool narrow_write_error(struct r1bio *r1_bio, int i)
 {
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
@@ -2507,10 +2507,10 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 	sector_t sector;
 	int sectors;
 	int sect_to_write = r1_bio->sectors;
-	int ok = 1;
+	bool ok = true;
 
 	if (rdev->badblocks.shift < 0)
-		return 0;
+		return false;
 
 	block_sectors = roundup(1 << rdev->badblocks.shift,
 				bdev_logical_block_size(rdev->bdev) >> 9);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 15b9ae5bf84d..45faa34f0be8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2786,7 +2786,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 	}
 }
 
-static int narrow_write_error(struct r10bio *r10_bio, int i)
+static bool narrow_write_error(struct r10bio *r10_bio, int i)
 {
 	struct bio *bio = r10_bio->master_bio;
 	struct mddev *mddev = r10_bio->mddev;
@@ -2807,10 +2807,10 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 	sector_t sector;
 	int sectors;
 	int sect_to_write = r10_bio->sectors;
-	int ok = 1;
+	bool ok = true;
 
 	if (rdev->badblocks.shift < 0)
-		return 0;
+		return false;
 
 	block_sectors = roundup(1 << rdev->badblocks.shift,
 				bdev_logical_block_size(rdev->bdev) >> 9);
-- 
2.39.2

