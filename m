Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C1F259B
	for <nvdimm@lists.linux.dev>; Fri, 25 Nov 2022 09:29:21 +0000 (UTC)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NJV0m57FZzmWBc;
	Fri, 25 Nov 2022 17:28:40 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 17:29:14 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 25 Nov
 2022 17:29:14 +0800
From: Yang Yingliang <yangyingliang@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <santosh@fossix.org>
CC: <nvdimm@lists.linux.dev>, <yangyingliang@huawei.com>
Subject: [PATCH 2/2] ndtest: fix return value check in ndtest_dimm_register()
Date: Fri, 25 Nov 2022 17:27:21 +0800
Message-ID: <20221125092721.9433-3-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221125092721.9433-1-yangyingliang@huawei.com>
References: <20221125092721.9433-1-yangyingliang@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected

If device_create_with_groups() fails, it returns ERR_PTR()
and never return NULL, so replace NULL pointer check with
IS_ERR() to fix this problem.

Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 tools/testing/nvdimm/test/ndtest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 01ceb98c15a0..42954a6d0929 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -740,11 +740,11 @@ static int ndtest_dimm_register(struct ndtest_priv *priv,
 	dimm->dev = device_create_with_groups(ndtest_dimm_class,
 					     &priv->pdev.dev,
 					     0, dimm, dimm_attribute_groups,
 					     "test_dimm%d", id);
-	if (!dimm->dev) {
+	if (IS_ERR(dimm->dev)) {
 		pr_err("Could not create dimm device attributes\n");
-		return -ENOMEM;
+		return PTR_ERR(dimm->dev);
 	}
 
 	return 0;
 }
-- 
2.25.1

