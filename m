Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A5928F8
	for <nvdimm@lists.linux.dev>; Tue,  5 Sep 2023 09:32:29 +0000 (UTC)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Rg0Dc2kG6z6D8WV;
	Tue,  5 Sep 2023 17:13:52 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 5 Sep 2023 10:15:11 +0100
From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To: <dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<peterz@infradead.org>, <kjain@linux.ibm.com>, <maddy@in.ibm.com>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>
Subject: [PATCH] drivers: nvdimm: fix possible memory leak
Date: Tue, 5 Sep 2023 17:15:07 +0800
Message-ID: <20230905091507.1672987-1-konstantin.meskhidze@huawei.com>
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

Memory pointed by 'nd_pmu->pmu.attr_groups[NVDIMM_PMU_CPUMASK_ATTR]->attrs[0]'
is allocated in function 'nvdimm_pmu_cpu_hotplug_init' via
'create_cpumask_attr_group' call. But not released in function
'nvdimm_pmu_free_hotplug_memory' or anywhere else before memory pointed by
'nd_pmu->pmu.attr_groups[NVDIMM_PMU_CPUMASK_ATTR]->attrs' will be freed.

Fixes: 0fab1ba6ad6b ("drivers/nvdimm: Add perf interface to expose nvdimm performance stats")
Co-developed-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---
 drivers/nvdimm/nd_perf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd_perf.c b/drivers/nvdimm/nd_perf.c
index 2b6dc80d8..ecfa1f635 100644
--- a/drivers/nvdimm/nd_perf.c
+++ b/drivers/nvdimm/nd_perf.c
@@ -264,10 +264,14 @@ static void nvdimm_pmu_free_hotplug_memory(struct nvdimm_pmu *nd_pmu)
 {
 	cpuhp_state_remove_instance_nocalls(nd_pmu->cpuhp_state, &nd_pmu->node);
 	cpuhp_remove_multi_state(nd_pmu->cpuhp_state);
 
-	if (nd_pmu->pmu.attr_groups[NVDIMM_PMU_CPUMASK_ATTR])
+	if (nd_pmu->pmu.attr_groups[NVDIMM_PMU_CPUMASK_ATTR]) {
+		if (nd_pmu->pmu.attr_groups[NVDIMM_PMU_CPUMASK_ATTR]->attrs)
+			kfree(nd_pmu->pmu.attr_groups[NVDIMM_PMU_CPUMASK_ATTR]->attrs[0]);
+
 		kfree(nd_pmu->pmu.attr_groups[NVDIMM_PMU_CPUMASK_ATTR]->attrs);
+	}
 	kfree(nd_pmu->pmu.attr_groups[NVDIMM_PMU_CPUMASK_ATTR]);
 }
 
 int register_nvdimm_pmu(struct nvdimm_pmu *nd_pmu, struct platform_device *pdev)
-- 
2.34.1
