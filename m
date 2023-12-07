Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C2A5236
	for <nvdimm@lists.linux.dev>; Thu,  7 Dec 2023 04:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from localhost.localdomain (unknown [10.190.66.146])
	by mail-app4 (Coremail) with SMTP id cS_KCgBHTzeBP3FlODFaAA--.40820S4;
	Thu, 07 Dec 2023 11:44:08 +0800 (CST)
From: Dinghao Liu <dinghao.liu@zju.edu.cn>
To: dinghao.liu@zju.edu.cn
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nvdimm-btt: fix a potential memleak in btt_freelist_init
Date: Thu,  7 Dec 2023 11:43:32 +0800
Message-Id: <20231207034332.24107-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:cS_KCgBHTzeBP3FlODFaAA--.40820S4
X-Coremail-Antispam: 1UD129KBjvJXoW7urWrArWxXw4rKF1xXFW7twb_yoW8Ww1DpF
	s3ArW5Ar4UJF47ur17ZwsrWa43Ca1fG3srGa4Yka4Syr15AFWqvFWSyayavry5Cr48ZFWj
	kr4ktrWrGF4UAwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
	aVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
	4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxG
	rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
	CI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
	z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgsCBmVwRZQp9wAAsX
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

When an error happens in btt_freelist_init(), its caller
discover_arenas() will directly free arena, which makes
arena->freelist allocated in btt_freelist_init() a leaked
memory. Fix this by freeing arena->freelist in all error
handling paths of btt_freelist_init().

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/nvdimm/btt.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index d5593b0dc700..d8c4ba8bfdda 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -544,8 +544,10 @@ static int btt_freelist_init(struct arena_info *arena)
 
 	for (i = 0; i < arena->nfree; i++) {
 		new = btt_log_read(arena, i, &log_new, LOG_NEW_ENT);
-		if (new < 0)
-			return new;
+		if (new < 0) {
+			ret = new;
+			goto out_free;
+		}
 
 		/* old and new map entries with any flags stripped out */
 		log_oldmap = ent_lba(le32_to_cpu(log_new.old_map));
@@ -577,7 +579,7 @@ static int btt_freelist_init(struct arena_info *arena)
 		ret = btt_map_read(arena, le32_to_cpu(log_new.lba), &map_entry,
 				NULL, NULL, 0);
 		if (ret)
-			return ret;
+			goto out_free;
 
 		/*
 		 * The map_entry from btt_read_map is stripped of any flag bits,
@@ -594,11 +596,16 @@ static int btt_freelist_init(struct arena_info *arena)
 			ret = btt_map_write(arena, le32_to_cpu(log_new.lba),
 					le32_to_cpu(log_new.new_map), 0, 0, 0);
 			if (ret)
-				return ret;
+				goto out_free;
 		}
 	}
 
 	return 0;
+
+out_free:
+	kfree(arena->freelist);
+	arena->freelist = NULL;
+	return ret;
 }
 
 static bool ent_is_padding(struct log_entry *ent)
-- 
2.17.1

