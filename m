Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38350202C56
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 08:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740125704; cv=none; b=CuR5vYdGHB3kEV+n5G4+pslmhGWdKOPaKC/huapDmnOyz6/n9QD8wCvBTc9GK/qazmycDIv3Cb6PF4k3AMxFHv+CiZRepRVJ5JC5A3pXxQJSSrwdYpWqZxrW63KYg0uYHPqpNpiag6cOa35yFiCL3LRzIVp61VfDAeMq56+SqhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740125704; c=relaxed/simple;
	bh=BVQ2JLHfvl7SJ1XVdk8tTQQ6U/sJhzvQG0qFBGRubgE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CVL914r/fr/4wihPu6nimI9uUcDcnntfrLDgwSOA+mPfo38SQZkhTmoAGRJAgJPwMj4YpuBnd9exjP5encZo6ePh/JjslCS67GzncKs8W7gRakeUUlPmk0mtz26p7VEFSd01hCHVUQ+vtcCrdSTEV1fkVyW//vWDS6FQ7ZxxN3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YzjbK2vMjz4f3jXt
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 152C41A1AC2
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:59 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgC3Gl_8NbhnHF3eEQ--.3944S10;
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
Subject: [PATCH 06/12] badblocks: fix the using of MAX_BADBLOCKS
Date: Fri, 21 Feb 2025 16:11:03 +0800
Message-Id: <20250221081109.734170-7-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgC3Gl_8NbhnHF3eEQ--.3944S10
X-Coremail-Antispam: 1UD129KBjvdXoWrtF48ZF4rCw1DAr47uw43trb_yoWkGwb_J3
	WDt3ykWr4kJr1rCw1ayryDtrWFyF47Cr4SkrZ2yr1kZr47tF1DZw45Xr98Xrs8CFWUJanx
	tw1fZrWS9F4IqjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbgxYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r126s
	0DM28IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
	WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7
	AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_Wr
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI
	0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x
	07jxwIDUUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Li Nan <linan122@huawei.com>

The number of badblocks cannot exceed MAX_BADBLOCKS, but it should be
allowed to equal MAX_BADBLOCKS.

Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 block/badblocks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index a953d2e9417f..87267bae6836 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -700,7 +700,7 @@ static bool can_front_overwrite(struct badblocks *bb, int prev,
 			*extra = 2;
 	}
 
-	if ((bb->count + (*extra)) >= MAX_BADBLOCKS)
+	if ((bb->count + (*extra)) > MAX_BADBLOCKS)
 		return false;
 
 	return true;
@@ -1135,7 +1135,7 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 		if ((BB_OFFSET(p[prev]) < bad.start) &&
 		    (BB_END(p[prev]) > (bad.start + bad.len))) {
 			/* Splitting */
-			if ((bb->count + 1) < MAX_BADBLOCKS) {
+			if ((bb->count + 1) <= MAX_BADBLOCKS) {
 				len = front_splitting_clear(bb, prev, &bad);
 				bb->count += 1;
 				cleared++;
-- 
2.39.2

