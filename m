Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010070.outbound.protection.outlook.com [52.101.61.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680AC1F4CB3
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773882927; cv=fail; b=lGyVzu3tAySFyhwKHU4f1TyaKgTIxSrKOZvP0b4NaWta4bHIQYC78yr1L8b1NpZ4wqynmPaCaMARBvVyR13HeFJ0JzXgCOsQSQtR4jqRfihlu1zwViflqZxULQUcxzlBydFRumnIH8f2gEBnqmgaxpGe2D5eusrF9KFSknvVjW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773882927; c=relaxed/simple;
	bh=r0KX32uOnfJtmRMkAD47jZWPkYBELnX/MXXP+NS+eIM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VscyTIhngNcqVzajSTOkmPahJkRap8YISyV3bt2NcbEhJIrDFkFtZ0LnpaeZ4nWXiNJV07ONJUske2lZMYyWbXoYyhQglS2mTJJqPsse0OH9X2g7CLSrXPfZC+skkMCdkh8AvkcxK8vtUclKSczZj3s9LL1ae5fT0CoEgQREaOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=swiqnejd; arc=fail smtp.client-ip=52.101.61.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="swiqnejd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rMfzRQB1S1TfutNh3O+IpKAUDQkj4ngZzXpIUWWYKNjIxHaeSmV9/kq7wNWtpAFesyLUokX98bIwPxwrmJgmyIKJyO2vQlH+IW5JMdspi4jTiCMgLkumctwqYxScc7JGjllnC8R/yA+/znVoAwpNW2eIQ8YczabdUL0TquP9kl0RSLcknSZGZrTqXdYillcwhXONJAuRpGVflqLBCjiK76u20Z6MVFuzYeAshISwiHBoMJiZs1xpUX7c+SukbTCC9MiIA93PHbDOkjpWJJ8Xd6Shp0mRvEW82mJlgF/hceDZPExaYaB3/cpzdaGs/N5EhW1+RWLRFNxJ/v0rvFgF/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KWigDYCvOnXSiIeYBPAQMzlYG08Hwbr07OkIWf+DZQ8=;
 b=gWvHGiOYthCXAc8UwJa/kgVAW71xZssWy7Yl9s3RY/5DP7oVoVbDE6bclXwLHWdqe+DVR2Fc+dj0jNuzQhh7bAxdDm2eLHNqGjFB+A5KkGWyCLrbS9icWa5EAjyKdZjcywlCVITFi8HlsGihwDeUfwgu5J1tgl0azi5+ABFTJgxojEWwoOCTTHFTJ/oWXyY14aokusXdfK3edoYFFf6F27chxhjDq3LRjG4rsTsOpf6QaW42M/X+83JYrVO9Nn1AR5o0JGZ61E0iJrKYw/QHK+V/hoktugJboeE7w+8qHxVqnRvaNdujI4qwAVq6NXZGzjwSJzLlpbS/uxXRdusDZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWigDYCvOnXSiIeYBPAQMzlYG08Hwbr07OkIWf+DZQ8=;
 b=swiqnejduPUZ5zUNrhM4Ubu0Ctz/D2VTDWgB289nxnI0BUUDKINyWkFMXcVFwEgeQGnHio0FuaAMeY+a69FmSZdwxZMQWwxmYvc9q6nE++eUQNvdBDZ4Kcw7jz8IvoWJnKNZagsV5bpzKYz73CZlfMtKnyJCUmLNCbo7qvbqyLc=
Received: from SJ0PR13CA0227.namprd13.prod.outlook.com (2603:10b6:a03:2c1::22)
 by DM4PR12MB5938.namprd12.prod.outlook.com (2603:10b6:8:69::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.9; Thu, 19 Mar 2026 01:15:18 +0000
Received: from SJ5PEPF00000204.namprd05.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::66) by SJ0PR13CA0227.outlook.office365.com
 (2603:10b6:a03:2c1::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 01:15:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000204.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Thu, 19 Mar 2026 01:15:17 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Mar
 2026 20:15:15 -0500
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
Subject: [PATCH v7 1/7] dax/hmem: Request cxl_acpi and cxl_pci before walking Soft Reserved ranges
Date: Thu, 19 Mar 2026 01:14:54 +0000
Message-ID: <20260319011500.241426-2-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000204:EE_|DM4PR12MB5938:EE_
X-MS-Office365-Filtering-Correlation-Id: 3afc2214-50de-4d3f-1dbe-08de8554fbb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|30052699003|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	u7u2pGroPXrVkXBuVaGLT6WwfBVDB8r1UaYlQj+YwC6YWO+seaMqa+7sUyhTLD/kpAoC91Mg8HDyKrLs40Q/23ADn6MSYa4S1KJxWGPARNQwFhIw0svjbkAOoVIPzKTSD/kAc5CHM/UsAQLLU35IIy40oEaqva4e0WuastbmWW4I/fKS+4Mra3zY8E5S9EbVGURVXipsyAwGX8BgeB4f5fSjud9uDEHEF7dj7yBq8uFNbMGcnB1mO3+eIMlLnF8/8u1Z0YmqNrcdiGTNsXocX5N61suboQ7dERLopaScvklFs4vvrsaN7s89W7OuxrQVpGiRhNZ0GJCNYWLdN69Aa/mf5Ii5AfjP+PB/yUakYuBiqammGh5gUCZJ7YMAeASKYb+TMFEcxWd+atyc+UEbdaIKUTRBrUTCkDEsWROpzNiby5MbWpiGAhRY11iT2D41HF3nT9FFDhuJKs6ZnZNaSc6UlVxJGGyIFYovbjt7Ii3t/NL9nzv6Mtp6d3rqXXyPUwulPaIO2hF8gB883sbyh32VOnK1GzKwAwJIdgSvJHJ1ZLCrj8bjW+v7SB1LV/a8vHiRdVncscFL+8FcZwx8EnRRkVGz1TSNset6VfA1pKKxz3QSpfBFsWee+izLEOd3ko7PpoY8bLPf7V6eKPcq2CguiLIawoQCLlqMJyHNlkeSLsQ+AP4zm/xj0oaO2BrZyazkcOGA6OpE8fKmtKTYxuXMLLU/1Z5jH9JOqEWcrcpzdldJNvGEQBQXYLhOFvddzHwzSbXGZ56MnHyeVV1o+g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(30052699003)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lgDkLkM+QnRzxv9uZULp94QKeXfZiuz1Z8ZNC8228IuV08o9+AElD4mrMJ7ZN0TwiMJLdZVQzX7M74xrsDyDhyFwcMfnMEhvd7I9GloUzLsjVAp2WaV+b93KBqgLfrMwMaPnPa+c5/nRG8l7GeBxzu0yHg1Pbx5+tQ5hwZ7dUu/hottbH9e4QCN6WhC+OnnoAfe/A0gHFWT8aSiOpNaQi9fgPFTMXDnO/vsmMpJCWypo3UxxApJ7BUh5iW9HcjyauI0EuqjvBpUQ4Q6RJ1E2kG2JDtyQQf2PU89mnoEnRS/jZuIN03ubnbXEAQmernNj2ZwKUfJA8tLCraAF8Np9f0HCN/hw9YmaGAiML7VRr3AkfwVta4SGJQnVosoDV1ACHIhVd5+s/bBqG8NMwRrbfEly0F36qBjuA5xu3Bi9tEyvk6tNHuw3b+otmg8KnG3l
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 01:15:17.8421
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3afc2214-50de-4d3f-1dbe-08de8554fbb3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000204.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5938

From: Dan Williams <dan.j.williams@intel.com>

Ensure cxl_acpi has published CXL Window resources before HMEM walks Soft
Reserved ranges.

Replace MODULE_SOFTDEP("pre: cxl_acpi") with an explicit, synchronous
request_module("cxl_acpi"). MODULE_SOFTDEP() only guarantees eventual
loading, it does not enforce that the dependency has finished init
before the current module runs. This can cause HMEM to start before
cxl_acpi has populated the resource tree, breaking detection of overlaps
between Soft Reserved and CXL Windows.

Also, request cxl_pci before HMEM walks Soft Reserved ranges. Unlike
cxl_acpi, cxl_pci attach is asynchronous and creates dependent devices
that trigger further module loads. Asynchronous probe flushing
(wait_for_device_probe()) is added later in the series in a deferred
context before HMEM makes ownership decisions for Soft Reserved ranges.

Add an additional explicit Kconfig ordering so that CXL_ACPI and CXL_PCI
must be initialized before DEV_DAX_HMEM. This prevents HMEM from consuming
Soft Reserved ranges before CXL drivers have had a chance to claim them.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
---
 drivers/dax/Kconfig     |  2 ++
 drivers/dax/hmem/hmem.c | 17 ++++++++++-------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index d656e4c0eb84..3683bb3f2311 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -48,6 +48,8 @@ config DEV_DAX_CXL
 	tristate "CXL DAX: direct access to CXL RAM regions"
 	depends on CXL_BUS && CXL_REGION && DEV_DAX
 	default CXL_REGION && DEV_DAX
+	depends on CXL_ACPI >= DEV_DAX_HMEM
+	depends on CXL_PCI >= DEV_DAX_HMEM
 	help
 	  CXL RAM regions are either mapped by platform-firmware
 	  and published in the initial system-memory map as "System RAM", mapped
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 1cf7c2a0ee1c..008172fc3607 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -139,6 +139,16 @@ static __init int dax_hmem_init(void)
 {
 	int rc;
 
+	/*
+	 * Ensure that cxl_acpi and cxl_pci have a chance to kick off
+	 * CXL topology discovery at least once before scanning the
+	 * iomem resource tree for IORES_DESC_CXL resources.
+	 */
+	if (IS_ENABLED(CONFIG_DEV_DAX_CXL)) {
+		request_module("cxl_acpi");
+		request_module("cxl_pci");
+	}
+
 	rc = platform_driver_register(&dax_hmem_platform_driver);
 	if (rc)
 		return rc;
@@ -159,13 +169,6 @@ static __exit void dax_hmem_exit(void)
 module_init(dax_hmem_init);
 module_exit(dax_hmem_exit);
 
-/* Allow for CXL to define its own dax regions */
-#if IS_ENABLED(CONFIG_CXL_REGION)
-#if IS_MODULE(CONFIG_CXL_ACPI)
-MODULE_SOFTDEP("pre: cxl_acpi");
-#endif
-#endif
-
 MODULE_ALIAS("platform:hmem*");
 MODULE_ALIAS("platform:hmem_platform*");
 MODULE_DESCRIPTION("HMEM DAX: direct access to 'specific purpose' memory");
-- 
2.17.1

