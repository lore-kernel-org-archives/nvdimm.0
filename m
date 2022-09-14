Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0EB2905
	for <nvdimm@lists.linux.dev>; Wed, 14 Sep 2022 06:13:16 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VPlxrJZ_1663135974;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VPlxrJZ_1663135974)
          by smtp.aliyun-inc.com;
          Wed, 14 Sep 2022 14:13:08 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] nvdimm: make __nvdimm_security_overwrite_query static
Date: Wed, 14 Sep 2022 14:12:51 +0800
Message-Id: <20220914061251.42052-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This symbol is not used outside of security.c, so marks it static.

drivers/nvdimm/security.c:411:6: warning: no previous prototype for function '__nvdimm_security_overwrite_query'.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2148
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/nvdimm/security.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index b5aa55c61461..8aefb60c42ff 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -408,7 +408,7 @@ static int security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 	return rc;
 }
 
-void __nvdimm_security_overwrite_query(struct nvdimm *nvdimm)
+static void __nvdimm_security_overwrite_query(struct nvdimm *nvdimm)
 {
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nvdimm->dev);
 	int rc;
-- 
2.20.1.7.g153144c

