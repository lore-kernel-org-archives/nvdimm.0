Received: from out199-2.us.a.mail.aliyun.com (out199-2.us.a.mail.aliyun.com [47.90.199.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD0B2100
	for <nvdimm@lists.linux.dev>; Tue,  6 Dec 2022 06:37:21 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=yang.lee@linux.alibaba.com;NM=0;PH=DS;RN=8;SR=0;TI=SMTPD_---0VWdx-.o_1670308304;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VWdx-.o_1670308304)
          by smtp.aliyun-inc.com;
          Tue, 06 Dec 2022 14:31:45 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] nvdimm: Fix some kernel-doc comments
Date: Tue,  6 Dec 2022 14:31:41 +0800
Message-Id: <20221206063142.52876-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the description of @nvdimm to @ndd in nvdimm_init_nsarea()
and nvdimm_allocated_dpa() to clear the below warnings:

drivers/nvdimm/dimm_devs.c:59: warning: Function parameter or member 'ndd' not described in 'nvdimm_init_nsarea'
drivers/nvdimm/dimm_devs.c:59: warning: Excess function parameter 'nvdimm' description in 'nvdimm_init_nsarea'
drivers/nvdimm/dimm_devs.c:841: warning: Function parameter or member 'ndd' not described in 'nvdimm_allocated_dpa'
drivers/nvdimm/dimm_devs.c:841: warning: Excess function parameter 'nvdimm' description in 'nvdimm_allocated_dpa'

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3361
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/nvdimm/dimm_devs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 1fc081dcf631..17b56171c2c2 100644
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
@@ -833,7 +833,7 @@ struct resource *nvdimm_allocate_dpa(struct nvdimm_drvdata *ndd,
 
 /**
  * nvdimm_allocated_dpa - sum up the dpa currently allocated to this label_id
- * @nvdimm: container of dpa-resource-root + labels
+ * @ndd: container of dpa-resource-root + labels
  * @label_id: dpa resource name of the form pmem-<human readable uuid>
  */
 resource_size_t nvdimm_allocated_dpa(struct nvdimm_drvdata *ndd,
-- 
2.20.1.7.g153144c

