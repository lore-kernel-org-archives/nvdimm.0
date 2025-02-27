Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACE922B8B2
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 07:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740643169; cv=none; b=dex3Pm3S3u+ywJmx3rgHC8R6sjn3NtUXikCT1sszcn2BfHvOujUpdPXQJHxKTVu/ZS44E316SX1rhLVqHXa9Bg2ucO+DBnVp/+VVmlvUmmB4SdTjEOFVRjjvd/J0KihdXfhjRzC1yH/4BRyR26WMTvhnDu1Db4KhGKI/bwOp8tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740643169; c=relaxed/simple;
	bh=Px/mUYvsmiGzmhUc+tXa1Dybn4SpIBzdm7FmG97uj/k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TK3mDL7FrPalW52xGOQEawhMVDaqzeYh4xDl4ef2AfauHnmMBugKdx+MgwUs8Og2CCTdaBJXCynUC31p9nFvqx7YE2kEavf41iQktLsV6ZDqZ3aYlyNQv72o/zEdO62Qk0vQ9ZwAvqlPfM6P5VcpFpIy1bHqmIVKMIPfISfZZig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z3NyT4cJ8z4f3js1
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:58:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 829881A058E
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:59:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl9PG8Bn6c8gFA--.31377S11;
	Thu, 27 Feb 2025 15:59:19 +0800 (CST)
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
Subject: [PATCH V2 07/12] badblocks: try can_merge_front before overlap_front
Date: Thu, 27 Feb 2025 15:55:02 +0800
Message-Id: <20250227075507.151331-8-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHKl9PG8Bn6c8gFA--.31377S11
X-Coremail-Antispam: 1UD129KBjvJXoW7trWxJFWkuFW5Jr1kZF43Wrg_yoW8Cw45pw
	nIvr1akrZ7Kw17ur13u3ZFqr1agFW8GFsrKa17Jw1FkryIvas3KF1Iq3WxK34jqFZIyrn0
	qw15CFy0vFy8trJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Regardless of whether overlap_front() returns true or false,
can_merge_front() will be executed first. Therefore, move
can_merge_front() in front of can_merge_front() to simplify code.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
---
 block/badblocks.c | 48 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 43430bd3efa7..57e9edf9b848 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -905,39 +905,35 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 		goto update_sectors;
 	}
 
+	if (can_merge_front(bb, prev, &bad)) {
+		len = front_merge(bb, prev, &bad);
+		added++;
+		hint = prev;
+		goto update_sectors;
+	}
+
 	if (overlap_front(bb, prev, &bad)) {
-		if (can_merge_front(bb, prev, &bad)) {
-			len = front_merge(bb, prev, &bad);
-			added++;
-		} else {
-			int extra = 0;
+		int extra = 0;
 
-			if (!can_front_overwrite(bb, prev, &bad, &extra)) {
-				if (extra > 0)
-					goto out;
+		if (!can_front_overwrite(bb, prev, &bad, &extra)) {
+			if (extra > 0)
+				goto out;
 
-				len = min_t(sector_t,
-					    BB_END(p[prev]) - s, sectors);
-				hint = prev;
-				goto update_sectors;
-			}
+			len = min_t(sector_t,
+				    BB_END(p[prev]) - s, sectors);
+			hint = prev;
+			goto update_sectors;
+		}
 
-			len = front_overwrite(bb, prev, &bad, extra);
-			added++;
-			bb->count += extra;
+		len = front_overwrite(bb, prev, &bad, extra);
+		added++;
+		bb->count += extra;
 
-			if (can_combine_front(bb, prev, &bad)) {
-				front_combine(bb, prev);
-				bb->count--;
-			}
+		if (can_combine_front(bb, prev, &bad)) {
+			front_combine(bb, prev);
+			bb->count--;
 		}
-		hint = prev;
-		goto update_sectors;
-	}
 
-	if (can_merge_front(bb, prev, &bad)) {
-		len = front_merge(bb, prev, &bad);
-		added++;
 		hint = prev;
 		goto update_sectors;
 	}
-- 
2.39.2

