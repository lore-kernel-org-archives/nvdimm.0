Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3492E201021
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 08:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740125703; cv=none; b=oT47chFL2ySKtkUQLys4CX/cV/mloHUiFdt8atF1hctLr3moMaBeL6jn1lq4I0eejUgCJcQnaDa0V7/i3cpR5e7ty+zhbetKZLzOP3BhlVSscDHtjGBq0nYLb4jLiGwPB2vMsOBN2gPxXuE0ntNgrb2LiOM2qBMBtRt2r4Yp5pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740125703; c=relaxed/simple;
	bh=CbvBFTs6oVuHlnnYB0uVi6sV0YMKAMhrhPzqxWvsxxc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lWS06RTyos0kq1Qq9C7BM0rdLCAGtavRyZ5hgIV60pdRzTEwEsNV6NsXQKxY5XKG0hEG+SSteErka21fz3MhmeR/Jk2A6dxe43awXKUXwXgERzYZgMUxozDQt1A3qdJ2C84UXnjF+FUG9znIkQUqp2FF/F9XuFOlYLOawMFnHG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YzjbJ43wPz4f3jYC
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3BD301A16AA
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgC3Gl_8NbhnHF3eEQ--.3944S9;
	Fri, 21 Feb 2025 16:14:58 +0800 (CST)
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
Subject: [PATCH 05/12] badblocks: return error if any badblock set fails
Date: Fri, 21 Feb 2025 16:11:02 +0800
Message-Id: <20250221081109.734170-6-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgC3Gl_8NbhnHF3eEQ--.3944S9
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4rtw4kJrWUtw4xAw15twb_yoW5GF1Dpr
	sxC3s3KrWjgr1UXF4UZ3Zrtr1Fg34fJF4UW3yrG34jkryUW343tF1kXr4YgFyjqry3AFn0
	q3W5urWrZ34DG3DanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

_badblocks_set() returns success if at least one badblock is set
successfully, even if others fail. This can lead to data inconsistencies
in raid, where a failed badblock set should trigger the disk to be kicked
out to prevent future reads from failed write areas.

_badblocks_set() should return error if any badblock set fails. Instead
of relying on 'rv', directly returning 'sectors' for clearer logic. If all
badblocks are successfully set, 'sectors' will be 0, otherwise it
indicates the number of badblocks that have not been set yet, thus
signaling failure.

By the way, it can also fix an issue: when a newly set unack badblock is
included in an existing ack badblock, the setting will return an error.
···
  echo "0 100" /sys/block/md0/md/dev-loop1/bad_blocks
  echo "0 100" /sys/block/md0/md/dev-loop1/unacknowledged_bad_blocks
  -bash: echo: write error: No space left on device
```
After fix, it will return success.

Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 block/badblocks.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 1c8b8f65f6df..a953d2e9417f 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -843,7 +843,6 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	struct badblocks_context bad;
 	int prev = -1, hint = -1;
 	unsigned long flags;
-	int rv = 0;
 	u64 *p;
 
 	if (bb->shift < 0)
@@ -873,10 +872,8 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	bad.len = sectors;
 	len = 0;
 
-	if (badblocks_full(bb)) {
-		rv = 1;
+	if (badblocks_full(bb))
 		goto out;
-	}
 
 	if (badblocks_empty(bb)) {
 		len = insert_at(bb, 0, &bad);
@@ -916,10 +913,8 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			int extra = 0;
 
 			if (!can_front_overwrite(bb, prev, &bad, &extra)) {
-				if (extra > 0) {
-					rv = 1;
+				if (extra > 0)
 					goto out;
-				}
 
 				len = min_t(sector_t,
 					    BB_END(p[prev]) - s, sectors);
@@ -986,10 +981,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 
 	write_sequnlock_irqrestore(&bb->lock, flags);
 
-	if (!added)
-		rv = 1;
-
-	return rv;
+	return sectors;
 }
 
 /*
@@ -1353,7 +1345,7 @@ EXPORT_SYMBOL_GPL(badblocks_check);
  *
  * Return:
  *  0: success
- *  1: failed to set badblocks (out of space)
+ *  other: failed to set badblocks (out of space)
  */
 int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			int acknowledged)
-- 
2.39.2

