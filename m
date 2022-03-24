Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2D51B60
	for <nvdimm@lists.linux.dev>; Thu, 24 Mar 2022 08:10:13 +0000 (UTC)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.55])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KPHVT0SKWz1GCxN;
	Thu, 24 Mar 2022 15:51:45 +0800 (CST)
Received: from huawei.com (10.175.127.227) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 24 Mar
 2022 15:51:53 +0800
From: Zheng Bin <zhengbin13@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
CC: <tangyizhou@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next] drivers/nvdimm: Fix build error without PERF_EVENTS
Date: Thu, 24 Mar 2022 16:06:53 +0800
Message-ID: <20220324080653.1364201-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected

If PERF_EVENTS is not set, bulding fails:

drivers/nvdimm/nd_perf.o: In function `nvdimm_pmu_cpu_offline':
nd_perf.c:(.text+0x12c): undefined reference to `perf_pmu_migrate_context'
drivers/nvdimm/nd_perf.o: In function `register_nvdimm_pmu':
nd_perf.c:(.text+0x3c4): undefined reference to `perf_pmu_register'
drivers/nvdimm/nd_perf.o: In function `unregister_nvdimm_pmu':
nd_perf.c:(.text+0x4c0): undefined reference to `perf_pmu_unregister'

Make LIBNVDIMM depends on PERF_EVENTS to fix this.

Fixes: 0fab1ba6ad6b ("drivers/nvdimm: Add perf interface to expose nvdimm performance stats")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/nvdimm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 5a29046e3319..e93bd0b787e9 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -4,6 +4,7 @@ menuconfig LIBNVDIMM
 	depends on PHYS_ADDR_T_64BIT
 	depends on HAS_IOMEM
 	depends on BLK_DEV
+	depends on PERF_EVENTS
 	select MEMREGION
 	help
 	  Generic support for non-volatile memory devices including
--
2.31.1

