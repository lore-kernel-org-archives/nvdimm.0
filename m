Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A201920010A
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 08:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740125701; cv=none; b=Wm5osKU7kSSyPLofhj5nMxTkqpnpH6N4uH1jMY5XDANqmtX3MJzsvck33r6Jv0mvfZnjkWkEroyZjRESl0ONXn0uwZYoYAQ6kEoKbS6CvfrQJ3HtTf0fLJx3hSx+I55XGd2JYP8ed7iZQyctj+ype65c+jhRiNekR7KnvzHcqOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740125701; c=relaxed/simple;
	bh=inw6EWFD77UrpetEvUb7B9biT+ZNTa+rIlC6cJXxygc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oEcwErpPMY0gA4avJjbI1rqXmrDXPdv0GAvF5jAey9pB0Dme2yn157EtEQKOZsp9jkteOJ7/2NvL27PxEOFv0VRzNm0Sz2jxYxF98WzVTor0TaS4CVENvPIYZVojvYRqSkdm/+6IVzSpYJTTUqFaW5l/tJyi62l/sot3PN+GPtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YzjbG6d2mz4f3jYG
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 93CE41A1320
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgC3Gl_8NbhnHF3eEQ--.3944S7;
	Fri, 21 Feb 2025 16:14:56 +0800 (CST)
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
Subject: [PATCH 03/12] badblocks: attempt to merge adjacent badblocks during ack_all_badblocks
Date: Fri, 21 Feb 2025 16:11:00 +0800
Message-Id: <20250221081109.734170-4-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgC3Gl_8NbhnHF3eEQ--.3944S7
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr4fJF1UXF4rGrWDur4rZrb_yoWDCrg_Ja
	s7tryUG3s5AF13Cr1Syr1Utr4SgF4DCrn7Kr1UAr1rZr17tFZrAan0krs8Wrn8GFyUu3sx
	Ar95Xr13urWI9jkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbqkYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r1rM2
	8IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
	4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxV
	W8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
	0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07j4
	T5LUUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Li Nan <linan122@huawei.com>

If ack and unack badblocks are adjacent, they will not be merged and will
remain as two separate badblocks. Even after the bad blocks are written
to disk and both become ack, they will still remain as two independent
bad blocks. This is not ideal as it wastes the limited space for
badblocks. Therefore, during ack_all_badblocks(), attempt to merge
badblocks if they are adjacent.

Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 block/badblocks.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/badblocks.c b/block/badblocks.c
index f069c93e986d..ad8652fbe1c8 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -1491,6 +1491,11 @@ void ack_all_badblocks(struct badblocks *bb)
 				p[i] = BB_MAKE(start, len, 1);
 			}
 		}
+
+		for (i = 0; i < bb->count ; i++)
+			while (try_adjacent_combine(bb, i))
+				;
+
 		bb->unacked_exist = 0;
 	}
 	write_sequnlock_irq(&bb->lock);
-- 
2.39.2

