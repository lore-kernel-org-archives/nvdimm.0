Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6126F227EB4
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 07:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740643167; cv=none; b=N6+J7dlxt1nw/Njul+c63K64kZv8AXB7RcSnRWTuVUvI14WM29XmrP189PdFyeDMF5d4ykOuIJWzec724UuNzCx/EMi1pJu0kAv0g2M6OIc8eQU/n5c2wWnWtfuZBrkTESNXxyKzHay02vCSH98FGNT1FSx8VoWAWWVeymiqtZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740643167; c=relaxed/simple;
	bh=oPRR0nurdfPioaXBDrapPjnRf2yTW8+5ovP+cJrb8Z4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hI2cH0YBv1/QRuQlVqgF9N1CHl9iCexRuZB0GBBTKfeTnlar5p/TZ7EINbr8gNIFKipdFImRUUWDu534imGGdkhb4eHawU61VaNx+tsr3xupBziX/du3RwxeNLhRjt8anVocclQT3wNTIk/RytWI5nlqH0fftnnoLkvssnMWvhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z3Nyd25bkz4f3jsv
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:59:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CF1D41A058E
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:59:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl9PG8Bn6c8gFA--.31377S14;
	Thu, 27 Feb 2025 15:59:21 +0800 (CST)
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
Subject: [PATCH V2 10/12] badblocks: return boolean from badblocks_set() and badblocks_clear()
Date: Thu, 27 Feb 2025 15:55:05 +0800
Message-Id: <20250227075507.151331-11-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHKl9PG8Bn6c8gFA--.31377S14
X-Coremail-Antispam: 1UD129KBjvJXoW3GFykGF48KFykZry7KF17ZFb_yoWfXFWfpa
	9xJa4fJrWUWr18WF1UZ3Z5tr1Fg3W3tF4UG3y3J340kryDt3yxtF1kXryYqFyjgrW3GrnI
	qa15urW5u34DW37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Change the return type of badblocks_set() and badblocks_clear()
from int to bool, indicating success or failure. Specifically:

- _badblocks_set() and _badblocks_clear() functions now return
true for success and false for failure.
- All calls to these functions are updated to handle the new
boolean return type.
- This change improves code clarity and ensures a more consistent
handling of success and failure states.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Coly Li <colyli@kernel.org>
---
 block/badblocks.c             | 41 +++++++++++++++++------------------
 drivers/block/null_blk/main.c | 14 ++++++------
 drivers/md/md.c               | 35 +++++++++++++++---------------
 drivers/nvdimm/badrange.c     |  2 +-
 include/linux/badblocks.h     |  6 ++---
 5 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index b66d5f12a766..e326a16fd056 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -836,8 +836,8 @@ static bool try_adjacent_combine(struct badblocks *bb, int prev)
 }
 
 /* Do exact work to set bad block range into the bad block table */
-static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
-			  int acknowledged)
+static bool _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
+			   int acknowledged)
 {
 	int len = 0, added = 0;
 	struct badblocks_context bad;
@@ -847,11 +847,11 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 
 	if (bb->shift < 0)
 		/* badblocks are disabled */
-		return 1;
+		return false;
 
 	if (sectors == 0)
 		/* Invalid sectors number */
-		return 1;
+		return false;
 
 	if (bb->shift) {
 		/* round the start down, and the end up */
@@ -977,7 +977,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 
 	write_sequnlock_irqrestore(&bb->lock, flags);
 
-	return sectors;
+	return sectors == 0;
 }
 
 /*
@@ -1048,21 +1048,20 @@ static int front_splitting_clear(struct badblocks *bb, int prev,
 }
 
 /* Do the exact work to clear bad block range from the bad block table */
-static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
+static bool _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 {
 	struct badblocks_context bad;
 	int prev = -1, hint = -1;
 	int len = 0, cleared = 0;
-	int rv = 0;
 	u64 *p;
 
 	if (bb->shift < 0)
 		/* badblocks are disabled */
-		return 1;
+		return false;
 
 	if (sectors == 0)
 		/* Invalid sectors number */
-		return 1;
+		return false;
 
 	if (bb->shift) {
 		sector_t target;
@@ -1182,9 +1181,9 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 	write_sequnlock_irq(&bb->lock);
 
 	if (!cleared)
-		rv = 1;
+		return false;
 
-	return rv;
+	return true;
 }
 
 /* Do the exact work to check bad blocks range from the bad block table */
@@ -1338,12 +1337,12 @@ EXPORT_SYMBOL_GPL(badblocks_check);
  * decide how best to handle it.
  *
  * Return:
- *  0: success
- *  other: failed to set badblocks (out of space). Parital setting will be
+ *  true: success
+ *  false: failed to set badblocks (out of space). Parital setting will be
  *  treated as failure.
  */
-int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
-			int acknowledged)
+bool badblocks_set(struct badblocks *bb, sector_t s, int sectors,
+		   int acknowledged)
 {
 	return _badblocks_set(bb, s, sectors, acknowledged);
 }
@@ -1360,10 +1359,10 @@ EXPORT_SYMBOL_GPL(badblocks_set);
  * drop the remove request.
  *
  * Return:
- *  0: success
- *  1: failed to clear badblocks
+ *  true: success
+ *  false: failed to clear badblocks
  */
-int badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
+bool badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 {
 	return _badblocks_clear(bb, s, sectors);
 }
@@ -1485,10 +1484,10 @@ ssize_t badblocks_store(struct badblocks *bb, const char *page, size_t len,
 		return -EINVAL;
 	}
 
-	if (badblocks_set(bb, sector, length, !unack))
+	if (!badblocks_set(bb, sector, length, !unack))
 		return -ENOSPC;
-	else
-		return len;
+
+	return len;
 }
 EXPORT_SYMBOL_GPL(badblocks_store);
 
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index d94ef37480bd..1f39617d780b 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -559,14 +559,14 @@ static ssize_t nullb_device_badblocks_store(struct config_item *item,
 		goto out;
 	/* enable badblocks */
 	cmpxchg(&t_dev->badblocks.shift, -1, 0);
-	if (buf[0] == '+')
-		ret = badblocks_set(&t_dev->badblocks, start,
-			end - start + 1, 1);
-	else
-		ret = badblocks_clear(&t_dev->badblocks, start,
-			end - start + 1);
-	if (ret == 0)
+	if (buf[0] == '+') {
+		if (badblocks_set(&t_dev->badblocks, start,
+				  end - start + 1, 1))
+			ret = count;
+	} else if (badblocks_clear(&t_dev->badblocks, start,
+				   end - start + 1)) {
 		ret = count;
+	}
 out:
 	kfree(orig);
 	return ret;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 30b3dbbce2d2..49d826e475cb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1748,7 +1748,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 			count <<= sb->bblog_shift;
 			if (bb + 1 == 0)
 				break;
-			if (badblocks_set(&rdev->badblocks, sector, count, 1))
+			if (!badblocks_set(&rdev->badblocks, sector, count, 1))
 				return -EINVAL;
 		}
 	} else if (sb->bblog_offset != 0)
@@ -9846,7 +9846,6 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 		       int is_new)
 {
 	struct mddev *mddev = rdev->mddev;
-	int rv;
 
 	/*
 	 * Recording new badblocks for faulty rdev will force unnecessary
@@ -9862,33 +9861,35 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 		s += rdev->new_data_offset;
 	else
 		s += rdev->data_offset;
-	rv = badblocks_set(&rdev->badblocks, s, sectors, 0);
-	if (rv == 0) {
-		/* Make sure they get written out promptly */
-		if (test_bit(ExternalBbl, &rdev->flags))
-			sysfs_notify_dirent_safe(rdev->sysfs_unack_badblocks);
-		sysfs_notify_dirent_safe(rdev->sysfs_state);
-		set_mask_bits(&mddev->sb_flags, 0,
-			      BIT(MD_SB_CHANGE_CLEAN) | BIT(MD_SB_CHANGE_PENDING));
-		md_wakeup_thread(rdev->mddev->thread);
-		return 1;
-	} else
+
+	if (!badblocks_set(&rdev->badblocks, s, sectors, 0))
 		return 0;
+
+	/* Make sure they get written out promptly */
+	if (test_bit(ExternalBbl, &rdev->flags))
+		sysfs_notify_dirent_safe(rdev->sysfs_unack_badblocks);
+	sysfs_notify_dirent_safe(rdev->sysfs_state);
+	set_mask_bits(&mddev->sb_flags, 0,
+		      BIT(MD_SB_CHANGE_CLEAN) | BIT(MD_SB_CHANGE_PENDING));
+	md_wakeup_thread(rdev->mddev->thread);
+	return 1;
 }
 EXPORT_SYMBOL_GPL(rdev_set_badblocks);
 
 int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 			 int is_new)
 {
-	int rv;
 	if (is_new)
 		s += rdev->new_data_offset;
 	else
 		s += rdev->data_offset;
-	rv = badblocks_clear(&rdev->badblocks, s, sectors);
-	if ((rv == 0) && test_bit(ExternalBbl, &rdev->flags))
+
+	if (!badblocks_clear(&rdev->badblocks, s, sectors))
+		return 0;
+
+	if (test_bit(ExternalBbl, &rdev->flags))
 		sysfs_notify_dirent_safe(rdev->sysfs_badblocks);
-	return rv;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 
diff --git a/drivers/nvdimm/badrange.c b/drivers/nvdimm/badrange.c
index a002ea6fdd84..ee478ccde7c6 100644
--- a/drivers/nvdimm/badrange.c
+++ b/drivers/nvdimm/badrange.c
@@ -167,7 +167,7 @@ static void set_badblock(struct badblocks *bb, sector_t s, int num)
 	dev_dbg(bb->dev, "Found a bad range (0x%llx, 0x%llx)\n",
 			(u64) s * 512, (u64) num * 512);
 	/* this isn't an error as the hardware will still throw an exception */
-	if (badblocks_set(bb, s, num, 1))
+	if (!badblocks_set(bb, s, num, 1))
 		dev_info_once(bb->dev, "%s: failed for sector %llx\n",
 				__func__, (u64) s);
 }
diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
index 670f2dae692f..8764bed9ff16 100644
--- a/include/linux/badblocks.h
+++ b/include/linux/badblocks.h
@@ -50,9 +50,9 @@ struct badblocks_context {
 
 int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 		   sector_t *first_bad, int *bad_sectors);
-int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
-			int acknowledged);
-int badblocks_clear(struct badblocks *bb, sector_t s, int sectors);
+bool badblocks_set(struct badblocks *bb, sector_t s, int sectors,
+		   int acknowledged);
+bool badblocks_clear(struct badblocks *bb, sector_t s, int sectors);
 void ack_all_badblocks(struct badblocks *bb);
 ssize_t badblocks_show(struct badblocks *bb, char *page, int unack);
 ssize_t badblocks_store(struct badblocks *bb, const char *page, size_t len,
-- 
2.39.2

