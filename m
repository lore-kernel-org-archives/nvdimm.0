Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B1F227E9C
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 07:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740643166; cv=none; b=lv2bXgp22QaXVT1W4X6MPIqJH5PNez1MENOp9+aWIETWofRLM6o4RSVVFCNV5xWM1CRDE3PI52BwLpbagkA5hCDX7pkFRPhivw5nUti3/kpBBaDqBR3953O6qgnP238CXCu35/goOvmEo14pVp2UpF3WPrDMxYil8vFf1s8sHUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740643166; c=relaxed/simple;
	bh=ajxDfF7hGLvReGe4TiaPqA2yfXu4wF45eBtFiFux/6k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IiRHIb0DG7qiOyszzZTjNGtGyqNcmvgLcUNjoPVUjZGZu+Ps0CmVV4XEKvOHZooTPx2lyk/LQVcmPiWz8KkxkOAJ3M0Sqb1ugXNTmH90yGIp03DVqQfer/ghegct2Swopv06IpA2fO4OpDE7gSlnXYQUsZn/u3by4+Ao4PrP+mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z3Nyc3nDyz4f3jtH
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:59:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 152521A1618
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:59:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl9PG8Bn6c8gFA--.31377S13;
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
Subject: [PATCH V2 09/12] badblocks: fix missing bad blocks on retry in _badblocks_check()
Date: Thu, 27 Feb 2025 15:55:04 +0800
Message-Id: <20250227075507.151331-10-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHKl9PG8Bn6c8gFA--.31377S13
X-Coremail-Antispam: 1UD129KBjvJXoWxGFyfKw4DKFyfWw1DKrWxZwb_yoW5Xw1rpF
	nxG343Jryjgr18Wa1Yva1qgr1Fk34fJF47J3y7Ga48Cry8Kwn7tFykWr1rZFyY9FW3Jrn0
	qa1rury3uryDG3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

From: Zheng Qixing <zhengqixing@huawei.com>

The bad blocks check would miss bad blocks when retrying under contention,
as checking parameters are not reset. These stale values from the previous
attempt could lead to incorrect scanning in the subsequent retry.

Move seqlock to outer function and reinitialize checking state for each
retry. This ensures a clean state for each check attempt, preventing any
missed bad blocks.

Fixes: 3ea3354cb9f0 ("badblocks: improve badblocks_check() for multiple ranges handling")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Coly Li <colyli@kernel.org>
---
 block/badblocks.c | 50 +++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 92bd43f7fff1..b66d5f12a766 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -1191,31 +1191,12 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 			    sector_t *first_bad, int *bad_sectors)
 {
-	int unacked_badblocks, acked_badblocks;
 	int prev = -1, hint = -1, set = 0;
 	struct badblocks_context bad;
-	unsigned int seq;
+	int unacked_badblocks = 0;
+	int acked_badblocks = 0;
+	u64 *p = bb->page;
 	int len, rv;
-	u64 *p;
-
-	WARN_ON(bb->shift < 0 || sectors == 0);
-
-	if (bb->shift > 0) {
-		sector_t target;
-
-		/* round the start down, and the end up */
-		target = s + sectors;
-		rounddown(s, 1 << bb->shift);
-		roundup(target, 1 << bb->shift);
-		sectors = target - s;
-	}
-
-retry:
-	seq = read_seqbegin(&bb->lock);
-
-	p = bb->page;
-	unacked_badblocks = 0;
-	acked_badblocks = 0;
 
 re_check:
 	bad.start = s;
@@ -1281,9 +1262,6 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 	else
 		rv = 0;
 
-	if (read_seqretry(&bb->lock, seq))
-		goto retry;
-
 	return rv;
 }
 
@@ -1324,7 +1302,27 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 			sector_t *first_bad, int *bad_sectors)
 {
-	return _badblocks_check(bb, s, sectors, first_bad, bad_sectors);
+	unsigned int seq;
+	int rv;
+
+	WARN_ON(bb->shift < 0 || sectors == 0);
+
+	if (bb->shift > 0) {
+		/* round the start down, and the end up */
+		sector_t target = s + sectors;
+
+		rounddown(s, 1 << bb->shift);
+		roundup(target, 1 << bb->shift);
+		sectors = target - s;
+	}
+
+retry:
+	seq = read_seqbegin(&bb->lock);
+	rv = _badblocks_check(bb, s, sectors, first_bad, bad_sectors);
+	if (read_seqretry(&bb->lock, seq))
+		goto retry;
+
+	return rv;
 }
 EXPORT_SYMBOL_GPL(badblocks_check);
 
-- 
2.39.2

