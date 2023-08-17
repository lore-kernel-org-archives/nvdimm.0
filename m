Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A340134DD
	for <nvdimm@lists.linux.dev>; Thu, 17 Aug 2023 11:59:53 +0000 (UTC)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RRNkB001Dz6J6ZG;
	Thu, 17 Aug 2023 19:55:45 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 17 Aug 2023 12:59:51 +0100
From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To: <dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>
Subject: [PATCH] drivers: nvdimm: fix memleak
Date: Thu, 17 Aug 2023 19:59:45 +0800
Message-ID: <20230817115945.771826-1-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml100001.china.huawei.com (7.188.26.227) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected

Memory pointed by 'nd_pmu->pmu.attr_groups' is allocated in function
'register_nvdimm_pmu' and is lost after 'kfree(nd_pmu)' call in function
'unregister_nvdimm_pmu'.

Co-developed-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 drivers/nvdimm/nd_perf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvdimm/nd_perf.c b/drivers/nvdimm/nd_perf.c
index 433bbb68a..14881c4e0 100644
--- a/drivers/nvdimm/nd_perf.c
+++ b/drivers/nvdimm/nd_perf.c
@@ -323,7 +323,8 @@ EXPORT_SYMBOL_GPL(register_nvdimm_pmu);
 void unregister_nvdimm_pmu(struct nvdimm_pmu *nd_pmu)
 {
 	perf_pmu_unregister(&nd_pmu->pmu);
 	nvdimm_pmu_free_hotplug_memory(nd_pmu);
+	kfree(nd_pmu->pmu.attr_groups);
 	kfree(nd_pmu);
 }
 EXPORT_SYMBOL_GPL(unregister_nvdimm_pmu);
-- 
2.34.1

