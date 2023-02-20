Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7997DED0
	for <nvdimm@lists.linux.dev>; Mon, 20 Feb 2023 07:13:07 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Vc1ux49_1676877177;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Vc1ux49_1676877177)
          by smtp.aliyun-inc.com;
          Mon, 20 Feb 2023 15:12:58 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] libnvdimm: Fix some kernel-doc comments
Date: Mon, 20 Feb 2023 15:12:56 +0800
Message-Id: <20230220071256.72513-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the description of @nvdimm to @ndd in function
nvdimm_init_nsarea() and nvdimm_allocated_dpa () to silence the warnings:
drivers/nvdimm/dimm_devs.c:59: warning: Function parameter or member 'ndd' not described in 'nvdimm_init_nsarea'
drivers/nvdimm/dimm_devs.c:59: warning: Excess function parameter 'nvdimm' description in 'nvdimm_init_nsarea'
drivers/nvdimm/dimm_devs.c:844: warning: Function parameter or member 'ndd' not described in 'nvdimm_allocated_dpa'
drivers/nvdimm/dimm_devs.c:844: warning: Excess function parameter 'nvdimm' description in 'nvdimm_allocated_dpa

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4118
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/nvdimm/dimm_devs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 957f7c3d17ba..fc152e6016ca 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -53,7 +53,7 @@ static int validate_dimm(struct nvdimm_drvdata *ndd)
 
 /**
  * nvdimm_init_nsarea - determine the geometry of a dimm's namespace area
- * @nvdimm: dimm to initialize
+ * @ndd: dimm to initialize
  */
 int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd)
 {
@@ -836,7 +836,7 @@ struct resource *nvdimm_allocate_dpa(struct nvdimm_drvdata *ndd,
 
 /**
  * nvdimm_allocated_dpa - sum up the dpa currently allocated to this label_id
- * @nvdimm: container of dpa-resource-root + labels
+ * @ndd: container of dpa-resource-root + labels
  * @label_id: dpa resource name of the form pmem-<human readable uuid>
  */
 resource_size_t nvdimm_allocated_dpa(struct nvdimm_drvdata *ndd,
-- 
2.20.1.7.g153144c

