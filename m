Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FD2225A22
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 07:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740643161; cv=none; b=AmZYrR9+v6THTXp4ZQhrhwU/0HauN4E4VaBWNoGg+6ebVfOxs1psFVUitvKAs17CPzF0nZgz3a0aDcFZ/qgTK/VPewE3C2HUEO3pomHG2iS4qFOUha9m1yj0MdixOKK6yGWKhH0lUpa3IIkLKLwv49GDa1Ucm57mEd+Epug3xYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740643161; c=relaxed/simple;
	bh=6UurLvlN43kElnBkczOMnVLHlLCoVgNKvePLk7U36xM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WzcJqrXYLp1MTbbPToM2e7Ts+gBNAhUyh7sgOIcDPMhK64XS6grkN4AlCOjEgXgcbNXL4WqO4IN87zYMXEjX0bI2q4UvqA0aMgOROK5/yIDqWYRoMczAh45oMs0NNIFn79MnB1jVDrPZIojpkK2LN2YIZv2Uo4hFxBURgU8zRZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z3NyW1XY6z4f3jtG
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:58:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B44C71A1782
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:59:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl9PG8Bn6c8gFA--.31377S6;
	Thu, 27 Feb 2025 15:59:15 +0800 (CST)
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
Subject: [PATCH V2 02/12] badblocks: factor out a helper try_adjacent_combine
Date: Thu, 27 Feb 2025 15:54:57 +0800
Message-Id: <20250227075507.151331-3-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHKl9PG8Bn6c8gFA--.31377S6
X-Coremail-Antispam: 1UD129KBjvJXoW7AF13Ary5AF1rWryUWFyrCrg_yoW8uw4rpr
	nxAw1avryxC3WS9anxXa17Aw15C3WxJrWYyFW7J348GFyUtw1S9r18t34fZF9FvrWxJFna
	q3WUuFyv9FW8t37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI
	0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0I3
	85UUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Li Nan <linan122@huawei.com>

Factor out try_adjacent_combine(), and it will be used in the later patch.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
---
 block/badblocks.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index bcee057efc47..f069c93e986d 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -855,6 +855,31 @@ static void badblocks_update_acked(struct badblocks *bb)
 		bb->unacked_exist = 0;
 }
 
+/*
+ * Return 'true' if the range indicated by 'bad' is exactly backward
+ * overlapped with the bad range (from bad table) indexed by 'behind'.
+ */
+static bool try_adjacent_combine(struct badblocks *bb, int prev)
+{
+	u64 *p = bb->page;
+
+	if (prev >= 0 && (prev + 1) < bb->count &&
+	    BB_END(p[prev]) == BB_OFFSET(p[prev + 1]) &&
+	    (BB_LEN(p[prev]) + BB_LEN(p[prev + 1])) <= BB_MAX_LEN &&
+	    BB_ACK(p[prev]) == BB_ACK(p[prev + 1])) {
+		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
+				  BB_LEN(p[prev]) + BB_LEN(p[prev + 1]),
+				  BB_ACK(p[prev]));
+
+		if ((prev + 2) < bb->count)
+			memmove(p + prev + 1, p + prev + 2,
+				(bb->count -  (prev + 2)) * 8);
+		bb->count--;
+		return true;
+	}
+	return false;
+}
+
 /* Do exact work to set bad block range into the bad block table */
 static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			  int acknowledged)
@@ -1022,20 +1047,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	 * merged. (prev < 0) condition is not handled here,
 	 * because it's already complicated enough.
 	 */
-	if (prev >= 0 &&
-	    (prev + 1) < bb->count &&
-	    BB_END(p[prev]) == BB_OFFSET(p[prev + 1]) &&
-	    (BB_LEN(p[prev]) + BB_LEN(p[prev + 1])) <= BB_MAX_LEN &&
-	    BB_ACK(p[prev]) == BB_ACK(p[prev + 1])) {
-		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
-				  BB_LEN(p[prev]) + BB_LEN(p[prev + 1]),
-				  BB_ACK(p[prev]));
-
-		if ((prev + 2) < bb->count)
-			memmove(p + prev + 1, p + prev + 2,
-				(bb->count -  (prev + 2)) * 8);
-		bb->count--;
-	}
+	try_adjacent_combine(bb, prev);
 
 	if (space_desired && !badblocks_full(bb)) {
 		s = orig_start;
-- 
2.39.2

