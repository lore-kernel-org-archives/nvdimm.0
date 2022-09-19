Received: from out199-5.us.a.mail.aliyun.com (out199-5.us.a.mail.aliyun.com [47.90.199.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDCBA2C
	for <nvdimm@lists.linux.dev>; Mon, 19 Sep 2022 06:15:04 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VQ6gxd6_1663568091;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VQ6gxd6_1663568091)
          by smtp.aliyun-inc.com;
          Mon, 19 Sep 2022 14:14:54 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] nvdimm/region: Fix kernel-doc
Date: Mon, 19 Sep 2022 14:14:28 +0800
Message-Id: <20220919061428.102883-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

drivers/nvdimm/region_devs.c:1103: warning: expecting prototype for nvdimm_flush(). Prototype was for generic_nvdimm_flush() instead.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2209
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/nvdimm/region_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 473a71bbd9c9..70f1a23cbe31 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1096,7 +1096,7 @@ int nvdimm_flush(struct nd_region *nd_region, struct bio *bio)
 	return rc;
 }
 /**
- * nvdimm_flush - flush any posted write queues between the cpu and pmem media
+ * generic_nvdimm_flush() - flush any posted write queues between the cpu and pmem media
  * @nd_region: interleaved pmem region
  */
 int generic_nvdimm_flush(struct nd_region *nd_region)
-- 
2.20.1.7.g153144c

