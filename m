Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE26200B9B
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 08:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740125702; cv=none; b=Fv+bhHXYK4EaC3Afw77V6vQBymPWxTmJ1rF0XTGKDcEQymMAxH3LoIi/R0B8x+P2qJTu0leQrgWeAYYzW+ttR3gSQqwSFS7TJcq0/a2imcJgZmNk8+qKUFpWM0Z7pAgK3+eV+2S6Zlnz/B5UV3yqCAdSfSHsSDDJz33QW75wOSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740125702; c=relaxed/simple;
	bh=DgtB7y4vZh9te6M7bK3173Va3ntgqMaiEcp563JO4AE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nXMyGzc45v7kWwkMltDtF7uNi2Z2fFncnNj8XnRLsmEdJhMPxKVhoQz+f7ctTrQR0cl2lLwPVXyWTEQKYgnRqfbjztUKzlm0eyc7HSecBbAK1xPOijxxeI2ULQUOWrG2mfgENWreYmOp5rY/3DsGVxAQ1LFNSc5Ktvng6Hvowf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YzjbH5Ly1z4f3jRG
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 68FA71A058E
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgC3Gl_8NbhnHF3eEQ--.3944S8;
	Fri, 21 Feb 2025 16:14:57 +0800 (CST)
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
Subject: [PATCH 04/12] badblocks: return error directly when setting badblocks exceeds 512
Date: Fri, 21 Feb 2025 16:11:01 +0800
Message-Id: <20250221081109.734170-5-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3Gl_8NbhnHF3eEQ--.3944S8
X-Coremail-Antispam: 1UD129KBjvJXoW3Gry8Xry8ZFW3ur4UXFykAFb_yoW7ZF4kpF
	sxW393tryDtr1Fg3WkZa1DJr1F934xJFWUCay5Xw10kFy0k3s7WF18X34F9Fyj9rWfGrn0
	qa18uryrZFWkG3DanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPvb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2
	AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6r
	W5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
	v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuY
	vjxUI1v3UUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Li Nan <linan122@huawei.com>

In the current handling of badblocks settings, a lot of processing has
been done for scenarios where the number of badblocks exceeds 512.
This makes the code look quite complex and also introduces some issues,

Fixing those issues wouldn’t be too complicated, but it wouldn’t
simplify the code. In fact, a disk shouldn’t have too many badblocks,
and for disks with 512 badblocks, attempting to set more bad blocks
doesn’t make much sense. At that point, the more appropriate action
would be to replace the disk. Therefore, to resolve these issues and
simplify the code somewhat, return error directly when setting badblocks
exceeds 512.

Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 block/badblocks.c | 121 ++++++++--------------------------------------
 1 file changed, 19 insertions(+), 102 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index ad8652fbe1c8..1c8b8f65f6df 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -527,51 +527,6 @@ static int prev_badblocks(struct badblocks *bb, struct badblocks_context *bad,
 	return ret;
 }
 
-/*
- * Return 'true' if the range indicated by 'bad' can be backward merged
- * with the bad range (from the bad table) index by 'behind'.
- */
-static bool can_merge_behind(struct badblocks *bb,
-			     struct badblocks_context *bad, int behind)
-{
-	sector_t sectors = bad->len;
-	sector_t s = bad->start;
-	u64 *p = bb->page;
-
-	if ((s < BB_OFFSET(p[behind])) &&
-	    ((s + sectors) >= BB_OFFSET(p[behind])) &&
-	    ((BB_END(p[behind]) - s) <= BB_MAX_LEN) &&
-	    BB_ACK(p[behind]) == bad->ack)
-		return true;
-	return false;
-}
-
-/*
- * Do backward merge for range indicated by 'bad' and the bad range
- * (from the bad table) indexed by 'behind'. The return value is merged
- * sectors from bad->len.
- */
-static int behind_merge(struct badblocks *bb, struct badblocks_context *bad,
-			int behind)
-{
-	sector_t sectors = bad->len;
-	sector_t s = bad->start;
-	u64 *p = bb->page;
-	int merged = 0;
-
-	WARN_ON(s >= BB_OFFSET(p[behind]));
-	WARN_ON((s + sectors) < BB_OFFSET(p[behind]));
-
-	if (s < BB_OFFSET(p[behind])) {
-		merged = BB_OFFSET(p[behind]) - s;
-		p[behind] =  BB_MAKE(s, BB_LEN(p[behind]) + merged, bad->ack);
-
-		WARN_ON((BB_LEN(p[behind]) + merged) >= BB_MAX_LEN);
-	}
-
-	return merged;
-}
-
 /*
  * Return 'true' if the range indicated by 'bad' can be forward
  * merged with the bad range (from the bad table) indexed by 'prev'.
@@ -884,11 +839,9 @@ static bool try_adjacent_combine(struct badblocks *bb, int prev)
 static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			  int acknowledged)
 {
-	int retried = 0, space_desired = 0;
-	int orig_len, len = 0, added = 0;
+	int len = 0, added = 0;
 	struct badblocks_context bad;
 	int prev = -1, hint = -1;
-	sector_t orig_start;
 	unsigned long flags;
 	int rv = 0;
 	u64 *p;
@@ -912,8 +865,6 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 
 	write_seqlock_irqsave(&bb->lock, flags);
 
-	orig_start = s;
-	orig_len = sectors;
 	bad.ack = acknowledged;
 	p = bb->page;
 
@@ -922,6 +873,11 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	bad.len = sectors;
 	len = 0;
 
+	if (badblocks_full(bb)) {
+		rv = 1;
+		goto out;
+	}
+
 	if (badblocks_empty(bb)) {
 		len = insert_at(bb, 0, &bad);
 		bb->count++;
@@ -933,32 +889,14 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 
 	/* start before all badblocks */
 	if (prev < 0) {
-		if (!badblocks_full(bb)) {
-			/* insert on the first */
-			if (bad.len > (BB_OFFSET(p[0]) - bad.start))
-				bad.len = BB_OFFSET(p[0]) - bad.start;
-			len = insert_at(bb, 0, &bad);
-			bb->count++;
-			added++;
-			hint = 0;
-			goto update_sectors;
-		}
-
-		/* No sapce, try to merge */
-		if (overlap_behind(bb, &bad, 0)) {
-			if (can_merge_behind(bb, &bad, 0)) {
-				len = behind_merge(bb, &bad, 0);
-				added++;
-			} else {
-				len = BB_OFFSET(p[0]) - s;
-				space_desired = 1;
-			}
-			hint = 0;
-			goto update_sectors;
-		}
-
-		/* no table space and give up */
-		goto out;
+		/* insert on the first */
+		if (bad.len > (BB_OFFSET(p[0]) - bad.start))
+			bad.len = BB_OFFSET(p[0]) - bad.start;
+		len = insert_at(bb, 0, &bad);
+		bb->count++;
+		added++;
+		hint = 0;
+		goto update_sectors;
 	}
 
 	/* in case p[prev-1] can be merged with p[prev] */
@@ -978,6 +916,11 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			int extra = 0;
 
 			if (!can_front_overwrite(bb, prev, &bad, &extra)) {
+				if (extra > 0) {
+					rv = 1;
+					goto out;
+				}
+
 				len = min_t(sector_t,
 					    BB_END(p[prev]) - s, sectors);
 				hint = prev;
@@ -1004,24 +947,6 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 		goto update_sectors;
 	}
 
-	/* if no space in table, still try to merge in the covered range */
-	if (badblocks_full(bb)) {
-		/* skip the cannot-merge range */
-		if (((prev + 1) < bb->count) &&
-		    overlap_behind(bb, &bad, prev + 1) &&
-		    ((s + sectors) >= BB_END(p[prev + 1]))) {
-			len = BB_END(p[prev + 1]) - s;
-			hint = prev + 1;
-			goto update_sectors;
-		}
-
-		/* no retry any more */
-		len = sectors;
-		space_desired = 1;
-		hint = -1;
-		goto update_sectors;
-	}
-
 	/* cannot merge and there is space in bad table */
 	if ((prev + 1) < bb->count &&
 	    overlap_behind(bb, &bad, prev + 1))
@@ -1049,14 +974,6 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	 */
 	try_adjacent_combine(bb, prev);
 
-	if (space_desired && !badblocks_full(bb)) {
-		s = orig_start;
-		sectors = orig_len;
-		space_desired = 0;
-		if (retried++ < 3)
-			goto re_insert;
-	}
-
 out:
 	if (added) {
 		set_changed(bb);
-- 
2.39.2

