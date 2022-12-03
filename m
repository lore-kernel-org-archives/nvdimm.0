Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C7F23B9
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 09:59:08 +0000 (UTC)
Received: from dggpeml500005.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NPQCS03vBzqScY;
	Sat,  3 Dec 2022 17:55:00 +0800 (CST)
Received: from huawei.com (10.175.112.125) by dggpeml500005.china.huawei.com
 (7.185.36.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 3 Dec
 2022 17:59:05 +0800
From: Yongqiang Liu <liuyongqiang13@huawei.com>
To: <linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <akpm@linux-foundation.org>,
	<joao.m.martins@oracle.com>, <zhangxiaoxu5@huawei.com>,
	<liuyongqiang13@huawei.com>
Subject: [PATCH] dax/hmem: Fix refcount leak in dax_hmem_probe()
Date: Sat, 3 Dec 2022 09:58:58 +0000
Message-ID: <20221203095858.612027-1-liuyongqiang13@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500005.china.huawei.com (7.185.36.59)
X-CFilter-Loop: Reflected

We should always call dax_region_put() whenever devm_create_dev_dax()
succeed or fail to avoid refcount leak of dax_region. Move the return
value check after dax_region_put().

Fixes: c01044cc8191 ("ACPI: HMAT: refactor hmat_register_target_device to hmem_register_device")
Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
---
 drivers/dax/hmem/hmem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 1bf040dbc834..09f5cd7b6c8e 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -36,12 +36,11 @@ static int dax_hmem_probe(struct platform_device *pdev)
 		.size = region_idle ? 0 : resource_size(res),
 	};
 	dev_dax = devm_create_dev_dax(&data);
-	if (IS_ERR(dev_dax))
-		return PTR_ERR(dev_dax);
 
 	/* child dev_dax instances now own the lifetime of the dax_region */
 	dax_region_put(dax_region);
-	return 0;
+
+	return IS_ERR(dev_dax) ? PTR_ERR(dev_dax) : 0;
 }
 
 static int dax_hmem_remove(struct platform_device *pdev)
-- 
2.25.1

