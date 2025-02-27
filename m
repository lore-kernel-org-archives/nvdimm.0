Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A438822DFB8
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 07:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740643178; cv=none; b=aEDuZWQQbo2a/ppl54OCgFwq1hOwZ/JS/b8J0DhCzRaUaKBlS73LVCgEtwUQf+ETWZWPijY7T7NTN2D9o0LOH6/g04aNIAILkew3J8hbS1Y90C3GUQYGKeHWp9VpJ4JvpMCDlnOt4rMq/4Bxj89J52kL1UBvEqi8ghvm6xe2CVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740643178; c=relaxed/simple;
	bh=7JfyPC4SKfaSXE9X/5i4eNtMjUhnK9ih2VMgcLSAHSI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t/pFjc6g1x4pPG1FhitVEAPC41/vOCBsCgzDKuL8n/YFu7z0xs2mYTjrhYQJZrGtO6BhEnPMOUKMTiulzJZkbzDPMWWMalo76UtScOxQFmcvXhRygrkimGmvCbI9o8BnBjEwG5OKqdJB0A4sYM9bK1IPlgDyZqlCMexHVxTGIRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z3NyV3GYSz4f3js6
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:58:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 53AE41A1617
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:59:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl9PG8Bn6c8gFA--.31377S12;
	Thu, 27 Feb 2025 15:59:20 +0800 (CST)
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
Subject: [PATCH V2 08/12] badblocks: fix merge issue when new badblocks align with pre+1
Date: Thu, 27 Feb 2025 15:55:03 +0800
Message-Id: <20250227075507.151331-9-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHKl9PG8Bn6c8gFA--.31377S12
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr45KrW3Jr4DurWDAr1DKFg_yoW8Xr4kpr
	nxCw1SkryqgF18Za1Uu3WxWrW09a4fGF48Ca9rJr4jkr98A3WIqr1kX3yYqryjqr43Grn0
	q3WY9Fy8Za4kG3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	W5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
	v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuY
	vjxUI-eODUUUU
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
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
---
 block/badblocks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 57e9edf9b848..92bd43f7fff1 100644
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

