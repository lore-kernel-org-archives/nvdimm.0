Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE66F1FFC66
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 08:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740125700; cv=none; b=XqYoj2V1r8+zZKY6oY4gabisaoR87BH6RCMa+5DP0TqBWPy7xu9Ah+9w62zBVIuWg+9O48ZAtfkEfjBr7S4gB0Kb/crnNgso+P/K/Mfkl3QM82EJkpwgCxz75m7RJO3BHNH9iG6QUjS2XTLdleVvn1zFm6lXbEJaq3IA2gyTiYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740125700; c=relaxed/simple;
	bh=GmSI9j+0w1+KoAlLwFcKpK37RVlcl8GSiVylg774Ieo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SSe5pcHwzyQmgMDgfD6h4zk6iHHirBUxcbj2QpEIFyTecPo+8LDwkju2fm0+7cyWeLLeufjyxMpslJfxSq4j/U9/ETmP9DsqorQp33CLxnLwxw7M5+cGSBcYczCEWuyeXFLhVo7CsNDLMc8HrmMUgruAgj4bEQMLxTvtmnffPu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YzjbD4tv3z4f3kvw
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BCC131A1316
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgC3Gl_8NbhnHF3eEQ--.3944S6;
	Fri, 21 Feb 2025 16:14:55 +0800 (CST)
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
Subject: [PATCH 02/12] badblocks: factor out a helper try_adjacent_combine
Date: Fri, 21 Feb 2025 16:10:59 +0800
Message-Id: <20250221081109.734170-3-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgC3Gl_8NbhnHF3eEQ--.3944S6
X-Coremail-Antispam: 1UD129KBjvJXoW7AF13Ary5Ar1DWrW3ury7Awb_yoW8uF4xpr
	nxAr1avryxG3WS9anxXanrAw15C3WxJrWYyFW7J348CFyUtw1I9F18t34fZF9FvrWxJFna
	qw1UuFyv9FW8t37anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI
	0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
	0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0zp
	BDUUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Li Nan <linan122@huawei.com>

Factor out try_adjacent_combine(), and it will be used in the later patch.

Signed-off-by: Li Nan <linan122@huawei.com>
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

