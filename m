Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9698168
	for <nvdimm@lists.linux.dev>; Thu, 30 Dec 2021 09:25:30 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V0KInZy_1640856322;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V0KInZy_1640856322)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 30 Dec 2021 17:25:22 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: vishal.l.verma@intel.com
Cc: dan.j.williams@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] nvdimm/btt: Fix btt_init() kernel-doc comment
Date: Thu, 30 Dec 2021 17:25:20 +0800
Message-Id: <20211230092520.115275-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the description of @nd_region and remove @maxlane in
btt_init() kernel-doc comment to remove warnings found
by running scripts/kernel-doc, which is caused by using 'make W=1'.
drivers/nvdimm/btt.c:1584: warning: Function parameter or member
'nd_region' not described in 'btt_init'
drivers/nvdimm/btt.c:1584: warning: Excess function parameter 'maxlane'
description in 'btt_init'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/nvdimm/btt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index da3f007a1211..293b8c107817 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1567,7 +1567,7 @@ static void btt_blk_cleanup(struct btt *btt)
  * @rawsize:	raw size in bytes of the backing device
  * @lbasize:	lba size of the backing device
  * @uuid:	A uuid for the backing device - this is stored on media
- * @maxlane:	maximum number of parallel requests the device can handle
+ * @nd_region:  region id and number of lanes possible
  *
  * Initialize a Block Translation Table on a backing device to provide
  * single sector power fail atomicity.
-- 
2.20.1.7.g153144c

