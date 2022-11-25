Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA2415B5
	for <nvdimm@lists.linux.dev>; Fri, 25 Nov 2022 02:10:37 +0000 (UTC)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NJJGW4T3KzRpSH;
	Fri, 25 Nov 2022 10:09:55 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 25 Nov
 2022 10:10:27 +0800
From: Yuan Can <yuancan@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>, <sbhat@linux.ibm.com>,
	<jane.chu@oracle.com>, <dave.hansen@linux.intel.com>, <santosh@fossix.org>,
	<nvdimm@lists.linux.dev>
CC: <yuancan@huawei.com>
Subject: [PATCH] ndtest: Add checks for devm_kcalloc
Date: Fri, 25 Nov 2022 02:08:24 +0000
Message-ID: <20221125020825.37125-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected

As the devm_kcalloc may return NULL, the return value needs to be checked
to avoid NULL poineter dereference.

Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 tools/testing/nvdimm/test/ndtest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 01ceb98c15a0..94fbb9d0fb6a 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -849,6 +849,8 @@ static int ndtest_probe(struct platform_device *pdev)
 				   sizeof(dma_addr_t), GFP_KERNEL);
 	p->dimm_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
 				  sizeof(dma_addr_t), GFP_KERNEL);
+	if (!p->dcr_dma || !p->label_dma || !p->dimm_dma)
+		return -ENOMEM;
 
 	rc = ndtest_nvdimm_init(p);
 	if (rc)
-- 
2.17.1

