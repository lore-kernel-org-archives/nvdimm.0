Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01EFB241E8
	for <nvdimm@lists.linux.dev>; Thu, 14 Dec 2023 08:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from localhost.localdomain (unknown [10.190.71.46])
	by mail-app3 (Coremail) with SMTP id cC_KCgCHj_JMv3plIqvdAA--.15533S4;
	Thu, 14 Dec 2023 16:39:57 +0800 (CST)
From: Dinghao Liu <dinghao.liu@zju.edu.cn>
To: dinghao.liu@zju.edu.cn
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] nvdimm-btt: simplify code with the scope based resource management
Date: Thu, 14 Dec 2023 16:39:19 +0800
Message-Id: <20231214083919.22218-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:cC_KCgCHj_JMv3plIqvdAA--.15533S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uF45Gr1xZw4DArWfGw13CFg_yoW8Wr1xpF
	s5A34kArWDJF1xuFyDAw4xZry3Ga1fAa4UKryj9393ZrWaqw1jqrZYyFyS9rykuFWxZryj
	g3yUtwnIkFW5Ar7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgIIBmV4LpY5mAAKsA
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Use the scope based resource management (defined in
linux/cleanup.h) to automate resource lifetime
control on struct btt_sb *super in discover_arenas().

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---

Changelog:

v2: Set the __free attribute before kzalloc.
---
 drivers/nvdimm/btt.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index d5593b0dc700..32a9e2f543c5 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <linux/nd.h>
 #include <linux/backing-dev.h>
+#include <linux/cleanup.h>
 #include "btt.h"
 #include "nd.h"
 
@@ -847,23 +848,20 @@ static int discover_arenas(struct btt *btt)
 {
 	int ret = 0;
 	struct arena_info *arena;
-	struct btt_sb *super;
 	size_t remaining = btt->rawsize;
 	u64 cur_nlba = 0;
 	size_t cur_off = 0;
 	int num_arenas = 0;
 
-	super = kzalloc(sizeof(*super), GFP_KERNEL);
+	struct btt_sb *super __free(kfree) = kzalloc(sizeof(*super), GFP_KERNEL);
 	if (!super)
 		return -ENOMEM;
 
 	while (remaining) {
 		/* Alloc memory for arena */
 		arena = alloc_arena(btt, 0, 0, 0);
-		if (!arena) {
-			ret = -ENOMEM;
-			goto out_super;
-		}
+		if (!arena)
+			return -ENOMEM;
 
 		arena->infooff = cur_off;
 		ret = btt_info_read(arena, super);
@@ -919,14 +917,11 @@ static int discover_arenas(struct btt *btt)
 	btt->nlba = cur_nlba;
 	btt->init_state = INIT_READY;
 
-	kfree(super);
 	return ret;
 
  out:
 	kfree(arena);
 	free_arenas(btt);
- out_super:
-	kfree(super);
 	return ret;
 }
 
-- 
2.17.1

