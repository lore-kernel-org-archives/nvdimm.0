Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F54ECA
	for <nvdimm@lists.linux.dev>; Sat, 26 Aug 2023 07:21:35 +0000 (UTC)
Received: from dggpeml500003.china.huawei.com (unknown [172.30.72.54])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RXp9q2qVBz1L9Vf;
	Sat, 26 Aug 2023 15:19:59 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpeml500003.china.huawei.com
 (7.185.36.200) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Sat, 26 Aug
 2023 15:21:31 +0800
From: Yu Liao <liaoyu15@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>, <rafael@kernel.org>
CC: <liaoyu15@huawei.com>, <liwei391@huawei.com>, <lenb@kernel.org>,
	<robert.moore@intel.com>, <linux-acpi@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] ACPI: NFIT: use struct_size() helper
Date: Sat, 26 Aug 2023 15:16:54 +0800
Message-ID: <20230826071654.564372-2-liaoyu15@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230826071654.564372-1-liaoyu15@huawei.com>
References: <20230826071654.564372-1-liaoyu15@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500003.china.huawei.com (7.185.36.200)
X-CFilter-Loop: Reflected

Make use of the struct_size() helper instead of an open-coded version,
in order to avoid any potential type mistakes or integer overflows that,
in the worst scenario, could lead to heap overflows.

Signed-off-by: Yu Liao <liaoyu15@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 305f590c54a8..2f7217600307 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -712,8 +712,7 @@ static bool add_spa(struct acpi_nfit_desc *acpi_desc,
 		}
 	}
 
-	nfit_spa = devm_kzalloc(dev, sizeof(*nfit_spa) + sizeof_spa(spa),
-			GFP_KERNEL);
+	nfit_spa = devm_kzalloc(dev, struct_size(nfit_spa, spa, 1), GFP_KERNEL);
 	if (!nfit_spa)
 		return false;
 	INIT_LIST_HEAD(&nfit_spa->list);
@@ -741,7 +740,7 @@ static bool add_memdev(struct acpi_nfit_desc *acpi_desc,
 			return true;
 		}
 
-	nfit_memdev = devm_kzalloc(dev, sizeof(*nfit_memdev) + sizeof(*memdev),
+	nfit_memdev = devm_kzalloc(dev, struct_size(nfit_memdev, memdev, 1),
 			GFP_KERNEL);
 	if (!nfit_memdev)
 		return false;
@@ -812,8 +811,7 @@ static bool add_dcr(struct acpi_nfit_desc *acpi_desc,
 			return true;
 		}
 
-	nfit_dcr = devm_kzalloc(dev, sizeof(*nfit_dcr) + sizeof(*dcr),
-			GFP_KERNEL);
+	nfit_dcr = devm_kzalloc(dev, struct_size(nfit_dcr, dcr, 1), GFP_KERNEL);
 	if (!nfit_dcr)
 		return false;
 	INIT_LIST_HEAD(&nfit_dcr->list);
@@ -855,7 +853,7 @@ static size_t sizeof_idt(struct acpi_nfit_interleave *idt)
 {
 	if (idt->header.length < sizeof(*idt))
 		return 0;
-	return sizeof(*idt) + sizeof(u32) * idt->line_count;
+	return struct_size(idt, line_offset, idt->line_count);
 }
 
 static bool add_idt(struct acpi_nfit_desc *acpi_desc,
-- 
2.25.1

