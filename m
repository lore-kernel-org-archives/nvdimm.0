Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E6128E8
	for <nvdimm@lists.linux.dev>; Fri, 25 Nov 2022 09:29:27 +0000 (UTC)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NJV0n0Mbnz15Mv3;
	Fri, 25 Nov 2022 17:28:41 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 17:29:14 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 25 Nov
 2022 17:29:13 +0800
From: Yang Yingliang <yangyingliang@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <santosh@fossix.org>
CC: <nvdimm@lists.linux.dev>, <yangyingliang@huawei.com>
Subject: [PATCH 1/2] nfit_test: fix return value check in nfit_test_dimm_init()
Date: Fri, 25 Nov 2022 17:27:20 +0800
Message-ID: <20221125092721.9433-2-yangyingliang@huawei.com>
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

Fixes: 231bf117aada ("tools/testing/nvdimm: unit test for acpi_nvdimm_notify()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 tools/testing/nvdimm/test/nfit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index c75abb497a1a..220315091143 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1833,10 +1833,10 @@ static int nfit_test_dimm_init(struct nfit_test *t)
 		t->dimm_dev[i] = device_create_with_groups(nfit_test_dimm,
 				&t->pdev.dev, 0, NULL,
 				nfit_test_dimm_attribute_groups,
 				"test_dimm%d", i + t->dcr_idx);
-		if (!t->dimm_dev[i])
-			return -ENOMEM;
+		if (IS_ERR(t->dimm_dev[i]))
+			return PTR_ERR(t->dimm_dev[i]);
 	}
 	return 0;
 }
 
-- 
2.25.1

