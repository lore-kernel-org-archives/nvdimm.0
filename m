Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F0E22B59D
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 07:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740643169; cv=none; b=dzPOV7lVdjV6HuTBAzwWsHwYj4S4nxdInzG/rcRQy5glkJ+uZBE2uipcslhD4sF0QVtfvjUw0n5fEWATXqiJ1GNd+nHGxKCl0OlOh0R6GDxUBFwF2+CB1si36dd52Y/qelNWMOwNJiV+8aetEkqadJ6L42LEOm2LTYahRc+4CDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740643169; c=relaxed/simple;
	bh=Kk0MBNT8yCR6K/0nlIq9Xcwt4wUbeup5aR7M6JJco4A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nhZXpeJWPDlUq4tafWz7I9zuYX2L2/cToNkxCBrZUPmOD4TbZjAvdndou+SkpqVg/NO5ZABmPTUHbiLjnIepmYOuJFNaUuQxwS3iQeGCj5n/ijchyu06IglH5aqe87J9gHALLpn1rPI3LTesdollXuB7W61xIEjV1gKWma+xhpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z3NyS6T4sz4f3jXV
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:58:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BE5771A1C52
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:59:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl9PG8Bn6c8gFA--.31377S10;
	Thu, 27 Feb 2025 15:59:18 +0800 (CST)
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
Subject: [PATCH V2 06/12] badblocks: fix the using of MAX_BADBLOCKS
Date: Thu, 27 Feb 2025 15:55:01 +0800
Message-Id: <20250227075507.151331-7-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDHKl9PG8Bn6c8gFA--.31377S10
X-Coremail-Antispam: 1UD129KBjvJXoW7AF1kKr4DKr15JFWftrW8Zwb_yoW8Gr1fp3
	ZxKwn8KrW09F1UWa1DZ3W5A34rW3WxAr48ua1rA3Wj9Fy8Aw1ftF1vqr1Yqry0gF43XFn2
	q3Wq9FyruayxC37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

The number of badblocks cannot exceed MAX_BADBLOCKS, but it should be
allowed to equal MAX_BADBLOCKS.

Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
Fixes: c3c6a86e9efc ("badblocks: add helper routines for badblock ranges handling")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Coly Li <colyli@kernel.org>
---
 block/badblocks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 88f27d4f3856..43430bd3efa7 100644
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

