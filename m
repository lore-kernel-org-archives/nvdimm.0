Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FF517C9
	for <nvdimm@lists.linux.dev>; Sat, 26 Aug 2023 07:21:40 +0000 (UTC)
Received: from dggpeml500003.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RXp7D4R3VztSMt;
	Sat, 26 Aug 2023 15:17:44 +0800 (CST)
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
Subject: [PATCH v2 1/2] ACPI: NFIT: Fix incorrect calculation of idt size
Date: Sat, 26 Aug 2023 15:16:53 +0800
Message-ID: <20230826071654.564372-1-liaoyu15@huawei.com>
X-Mailer: git-send-email 2.25.1
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

acpi_nfit_interleave's field 'line_offset' is switched to flexible array [1],
but sizeof_idt() still calculates the size in the form of 1-element array.

Therefore, fix incorrect calculation in sizeof_idt().

[1] https://lore.kernel.org/lkml/2652195.BddDVKsqQX@kreacher/

Fixes: 2a5ab99847bd ("ACPICA: struct acpi_nfit_interleave: Replace 1-element array with flexible array")
Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
v1 -> v2: add Dave's review tag and cc nvdimm@lists.linux.dev
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 07204d482968..305f590c54a8 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -855,7 +855,7 @@ static size_t sizeof_idt(struct acpi_nfit_interleave *idt)
 {
 	if (idt->header.length < sizeof(*idt))
 		return 0;
-	return sizeof(*idt) + sizeof(u32) * (idt->line_count - 1);
+	return sizeof(*idt) + sizeof(u32) * idt->line_count;
 }
 
 static bool add_idt(struct acpi_nfit_desc *acpi_desc,
-- 
2.25.1

