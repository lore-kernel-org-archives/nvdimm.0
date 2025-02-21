Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E246520468E
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 08:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740125705; cv=none; b=cPA61z4kCJP6mEe6UNZbldwimgdV3Y7rtWBfT4AsoW0rRXbdFXuP6dlK/QqlXE5jIsECbiV3xJutILgpCY7VDlUZITy7esmapDH73EGO9c4LbqD9defbN7+Bo0rEI/afEwFvmVw0Ipe9nzE9axO6Z0bzsvTo9mE04geqt5QT30E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740125705; c=relaxed/simple;
	bh=7ZRWqUauzNgndbsVmlesgyLeNJlD1ke3gVJGXBhMU3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CKDjTYRTGxKChmiuoixREvoki85lHrwbhvdJJqYAJGk7PwuNu30RjDwoS2ibYGpyCGOsCGcJkqzw/vE3KCssbqUQG1HYNARLBe6g1hAt/maFEwGjs7cNyjftUupq2VMqJ+rWUaR2VsLz73+hUAzQ/duWaTfwf5iAXJa4XGte+rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YzjbS2ndfz4f3jqj
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BB2D01A058E
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:15:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgC3Gl_8NbhnHF3eEQ--.3944S12;
	Fri, 21 Feb 2025 16:15:00 +0800 (CST)
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
Subject: [PATCH 08/12] badblocks: fix merge issue when new badblocks align with pre+1
Date: Fri, 21 Feb 2025 16:11:05 +0800
Message-Id: <20250221081109.734170-9-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgC3Gl_8NbhnHF3eEQ--.3944S12
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr45KrW3Jr4DurWDAr1DKFg_yoW8Gw18pr
	n8Cw1SkrWqgF18Za1Uu3W7Wr1F9a4fGF4UCa1UJr4jkr98A3WIqF1kXrWYqryjqr4fGrn0
	q3WY9FykZa4kG3DanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	W5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
	v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuY
	vjxUI1v3UUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Li Nan <linan122@huawei.com>

There is a merge issue when adding badblocks as follow:
  echo 0 10 > bad_blocks
  echo 30 10 > bad_blocks
  echo 20 10 > bad_blocks
  cat bad_blocks
  0 10
  20 10    //should be merged with (30 10)
  30 10

In this case, if new badblocks does not intersect with prev, it is added
by insert_at(). If there is an intersection with prev+1, the merge will
be processed in the next re_insert loop.

However, when the end of the new badblocks is exactly equal to the offset
of prev+1, no further re_insert loop occurs, and the two badblocks are not
merge.

Fix it by inc prev, badblocks can be merged during the subsequent code.

Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 block/badblocks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index bb46bab7e99f..381f9db423d6 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -892,7 +892,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 		len = insert_at(bb, 0, &bad);
 		bb->count++;
 		added++;
-		hint = 0;
+		hint = ++prev;
 		goto update_sectors;
 	}
 
@@ -947,7 +947,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	len = insert_at(bb, prev + 1, &bad);
 	bb->count++;
 	added++;
-	hint = prev + 1;
+	hint = ++prev;
 
 update_sectors:
 	s += len;
-- 
2.39.2

