Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBA5202C32
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 08:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740125706; cv=none; b=rAuqCw5x9kAbc6UM5abCWxlMCwcozixYmYvwbTui1h9ZpCpbayd1G+t6/XlTsO2Lwm5ky2UUztN9rl0np8h5wuK3+ar+UIqdvmsvhfEa74VU1zUg1zEBKBkooIRET3JP4SKaSpbue1Aw0Mb7cKqZjosIACS75U5Qe/oAL+D6JiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740125706; c=relaxed/simple;
	bh=Yp7v2oZW2J6dUnVZu1oprUC3k2FLZixhLh3Yd6lHxvY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sNc4lSwqQoXU6mQjU7z3uoY9eOPNyKLGiau9qwgx094OERfU++30VihQcBapctk1QpIgK9rXF73dnHncGTU859EDBklR+juAKej0sCSdQhxEru4fWG4u5eh2gLq4ild/lyZ5ZTwjyhE1wXRW7gICD30BEeZ8ddDAtDWzACXV4y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YzjbT1lvyz4f3jt4
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 947251A1792
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:15:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgC3Gl_8NbhnHF3eEQ--.3944S13;
	Fri, 21 Feb 2025 16:15:01 +0800 (CST)
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
Subject: [PATCH 09/12] badblocks: fix missing bad blocks on retry in _badblocks_check()
Date: Fri, 21 Feb 2025 16:11:06 +0800
Message-Id: <20250221081109.734170-10-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgC3Gl_8NbhnHF3eEQ--.3944S13
X-Coremail-Antispam: 1UD129KBjvJXoWxGFyfKw4DKFyfWw1DKrWxZwb_yoW5Xr48pF
	nxG34ftryjgry8Wa1Yva1qgrnYk34fJF47J3y7Ga48Cry8Kwn7tFykWr1rZFyYgFW3Jrn0
	qa1rury3uryDGaDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

From: Zheng Qixing <zhengqixing@huawei.com>

The bad blocks check would miss bad blocks when retrying under contention,
as checking parameters are not reset. These stale values from the previous
attempt could lead to incorrect scanning in the subsequent retry.

Move seqlock to outer function and reinitialize checking state for each
retry. This ensures a clean state for each check attempt, preventing any
missed bad blocks.

Fixes: 3ea3354cb9f0 ("badblocks: improve badblocks_check() for multiple ranges handling")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 block/badblocks.c | 50 +++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 381f9db423d6..79d91be468c4 100644
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

