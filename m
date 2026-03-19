Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010036.outbound.protection.outlook.com [40.93.198.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEB2279907
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773882926; cv=fail; b=MZPycN5yLHJyX9P0aNfEG7J3v5CNIN8A2sVeMAVRz773+tBKNrg04gIC06MXew5YFCZaGSuNNfWiAKkDQhC+wt91LOTXwj/9igd6Th0mTs57NxXAXMUY9E0Rxwgi4RHafFISmR5RMRttxbCh34HvzqmOrV97B80H2bI/V6sNtSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773882926; c=relaxed/simple;
	bh=p6RolRsSRS8Z+16Ku2/zxl1+Z0/L2HBZxyrVTAHdvsM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PJJqbPffzNCPAU6O+TOTKMxfM7diS7+3IvPCnQFFOlDZn48uif+M9Du9RPfZwA2gH85ElSpqu/46GfdwB3EESXinF+FRRHV5WqQ1XsAYMkeb6orrdOVuUcrwZvSvDJwevgBDLvfzNDaeWG99BrQiPGq9M7Lxi8rfI7vRV2VPmNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YbNYHlIc; arc=fail smtp.client-ip=40.93.198.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YbNYHlIc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HpS1wpKwOX4HdFEnB/LlOxKveXxzXyyupmjoDhDhas0nFzkfLb+qa9HMWme/i9lZDFwRebRnmZNHRPsNSNAksmBlI9zoajTr2L0lilo1Uwm2g03hddb4ohpw2WevhFN9gz4OWyWgmcPV0ai7qxskSTxjepfAwH0zYdbpRjqleIfc8By90Q8FhRiV2Zz+7UQsyJP3jfa4PpN2SRCjR9sRB85vPCoTbqZnGjEVYojT9egfJ/G/ImwjkJZc7tfCNHSMnI+lwnGi7NLz/OrZlrXf8/9ynrX7X9ANc00eb4aXxRzpHIWh0PNSW/JsV6bnI6boC/tpoM8+jDASZTOmd0q2VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4DP0t0eS8SW+roTZpq1XYy34wLQKLkoy+NI7r18WiK8=;
 b=wl5u/kxw2xotxtGI6BL5w0lldQb4JIaMsmvoxLDjg8ImYSDc0xTmIJ9z1UjbOoWEmiyU0ySHtmwoVgRrKGf0HHHHW2RyZhCGsPaInGHoAGSNyNy/pF/jA1+3mEJCtw+zbIUfKYWcAPCBLTCYTrbm841xOzbE7M5gDLmldltJXPaK5zmhz52i4VviHgG3lMA/VwcmDtG/jTUInU5BHPsM3nXnzGkRqapVmDhfF1PiZHHE3Oj82hAC7jQzDzkZxiqJKu84uTcDNT5dVzbjSHev7aGAeiB38OFjHBChLP9WC/u2ZrGn+m2lstTfmcYfB6Q2aKN3RrfiCoqRdZuP50J5Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DP0t0eS8SW+roTZpq1XYy34wLQKLkoy+NI7r18WiK8=;
 b=YbNYHlIc1AimS16u1OUUuJ6UISNXGdap0E3/yDVxa0yp2ZKUmccakgoxgEMSeOct9QFOL9ucIPnRXOqC41nTlTjlXxy4z08IXZT7H0W6lpsDrjFQhj60Z4R+mqgzRurdIzmHHdnqCgyGjoAiF9JTzl9/Opu4d+dj07xaZABURbo=
Received: from SJ0PR03CA0371.namprd03.prod.outlook.com (2603:10b6:a03:3a1::16)
 by MW4PR12MB7381.namprd12.prod.outlook.com (2603:10b6:303:223::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.13; Thu, 19 Mar
 2026 01:15:19 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::2) by SJ0PR03CA0371.outlook.office365.com
 (2603:10b6:a03:3a1::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 01:15:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Thu, 19 Mar 2026 01:15:18 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Mar
 2026 20:15:17 -0500
From: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
To: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>
CC: Ard Biesheuvel <ardb@kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, Yazen Ghannam
	<yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
	<len.brown@intel.com>, Pavel Machek <pavel@kernel.org>, Li Ming
	<ming.li@zohomail.com>, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, "Ying
 Huang" <huang.ying.caritas@gmail.com>, Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Zhijian Li
	<lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, Tomasz Wolski
	<tomasz.wolski@fujitsu.com>
Subject: [PATCH v7 3/7] dax/cxl, hmem: Initialize hmem early and defer dax_cxl binding
Date: Thu, 19 Mar 2026 01:14:56 +0000
Message-ID: <20260319011500.241426-4-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
References: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|MW4PR12MB7381:EE_
X-MS-Office365-Filtering-Correlation-Id: d0492144-eeed-4d70-4905-08de8554fc4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|1800799024|376014|82310400026|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	h5pNGFzZo1LHHJNUWC5zW2kNsI8Kss2DUB9TLc/P78P2H4LDTqZlNOE20mKffpJwH0ujqyFBsidssA2Mtj/T6m+uHIja1DsDjAp3d10fecxvlLnvTp22XALytWRJghEVnRmMfQwsmm+1S6VoJ5NjiXKq+SHKT3TcbTySujOyn6rUfw5GKgBiPXNeDcVJ8tFL1T4Fyim03KmriBxzNids/LYrgD5/0c24aRy1yadxjdQtpbqpEBe4RkUglZA2ZVPE8JId5RpJjXAqjNeKXG8t26mOeu9qfjD0QmqYu/hzr02rqg3F6Q9HKmSGw3bfCTKcmjM0mXqUX1+Bjpz6f/yG10KSpb+N3RdA3z7G6YkK4eaB2DSoVdbUMmRQur8533tNka/ZmQ96243eWP9+6rfQXQsMYV5y8y0Bbcpshkuby/2Kzi8dDqzMB9LrdWRn4soJ0c8fyN6ZF5GgYOU+pJ4DhrmxOUhLF7NZ0PxEfT5PrNDzNRa60RnwSMU4WhdOdk6qre5bKOXb7XtMeE/oTFDwniDXiJBiy3pWe4rnE1c+PNQaXCtDSQBY+vR0aBv83l4ijvkwZ3CGFaCuCfadV7tAH5958OcgB5BUcvd/azskiDz2RIvJhZn0YyACaZ7ZkaJQOM7XAVE1edTgbdUc6PlBcy3H2Me3FedEIor656yzPkYK+c9orRMDx7thKk/NO1u1/OzuvbBwNceLp1Pr/ivZaEK1DGWWirAmVNKr/LRvbHC2Te+a3+izv7tc2ixTACKaRUf/L/8FvCwRUQTM7PHAyg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(1800799024)(376014)(82310400026)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UMtuwPpvpsyQ7tOqp5dpsCYNg8eWTTIiDCE5egQX9ecClS3W7iwDXXgyVylYv/O+xP+brHPlBg6LvcERJUrPgZf/rRB9G7Web3G5otoZbuWOM6t/8MBpXMbqptmOZTUHq8uGkNRH/etQRt3C0cITwSijDsBP2DZF3HgfgoYhPMW4l0XPwfK3XHloGM2EBrzLI0Hh2c8m9lhXzxqzCVeG/Po0gyzJiv8yRNjE0ow+WWgeXFKbZNxXn1fRzgnds7Ogq30xQK7afWK2RQvrOm4PTipl8D02X62wI/Msc0MDeo5noR3RDuAOVsG1RFL2hh/C0iO9R0HQNjwMbI+HklyJIrk89C2bdafCcsusnrhuYLEFCYeerA6lHJgyd+Msd1KMO/vCcwcOjDBtltpImvmR964EMWE7A+eAu7d2scQD7diF1TvWeWswn+STipKGXr7x
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 01:15:18.8386
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0492144-eeed-4d70-4905-08de8554fc4b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7381

From: Dan Williams <dan.j.williams@intel.com>

Move hmem/ earlier in the dax Makefile so that hmem_init() runs before
dax_cxl.

In addition, defer registration of the dax_cxl driver to a workqueue
instead of using module_cxl_driver(). This ensures that dax_hmem has
an opportunity to initialize and register its deferred callback and make
ownership decisions before dax_cxl begins probing and claiming Soft
Reserved ranges.

Mark the dax_cxl driver as PROBE_PREFER_ASYNCHRONOUS so its probe runs
out of line from other synchronous probing avoiding ordering
dependencies while coordinating ownership decisions with dax_hmem.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 drivers/dax/Makefile |  3 +--
 drivers/dax/cxl.c    | 27 ++++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
index 5ed5c39857c8..70e996bf1526 100644
--- a/drivers/dax/Makefile
+++ b/drivers/dax/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+obj-y += hmem/
 obj-$(CONFIG_DAX) += dax.o
 obj-$(CONFIG_DEV_DAX) += device_dax.o
 obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
@@ -10,5 +11,3 @@ dax-y += bus.o
 device_dax-y := device.o
 dax_pmem-y := pmem.o
 dax_cxl-y := cxl.o
-
-obj-y += hmem/
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 13cd94d32ff7..a2136adfa186 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -38,10 +38,35 @@ static struct cxl_driver cxl_dax_region_driver = {
 	.id = CXL_DEVICE_DAX_REGION,
 	.drv = {
 		.suppress_bind_attrs = true,
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 };
 
-module_cxl_driver(cxl_dax_region_driver);
+static void cxl_dax_region_driver_register(struct work_struct *work)
+{
+	cxl_driver_register(&cxl_dax_region_driver);
+}
+
+static DECLARE_WORK(cxl_dax_region_driver_work, cxl_dax_region_driver_register);
+
+static int __init cxl_dax_region_init(void)
+{
+	/*
+	 * Need to resolve a race with dax_hmem wanting to drive regions
+	 * instead of CXL
+	 */
+	queue_work(system_long_wq, &cxl_dax_region_driver_work);
+	return 0;
+}
+module_init(cxl_dax_region_init);
+
+static void __exit cxl_dax_region_exit(void)
+{
+	flush_work(&cxl_dax_region_driver_work);
+	cxl_driver_unregister(&cxl_dax_region_driver);
+}
+module_exit(cxl_dax_region_exit);
+
 MODULE_ALIAS_CXL(CXL_DEVICE_DAX_REGION);
 MODULE_DESCRIPTION("CXL DAX: direct access to CXL regions");
 MODULE_LICENSE("GPL");
-- 
2.17.1

