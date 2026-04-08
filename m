Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010014.outbound.protection.outlook.com [52.101.61.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEEF39EF38
	for <nvdimm@lists.linux.dev>; Wed,  8 Apr 2026 20:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775680406; cv=fail; b=Asc2Orc7LH2Yr8Trd+EUKRuliCI02t70iCLHNzW6Xgh1mj0KAKsdowRKOEucngYs9v+PdJRQ6i6L7eOk3Y3HyD6V6zhQgyIeI3xffMNbcdujCTiXHYB3RUiWre2/1F+wyY45ubWHP207Zy4pWJyiCENc20RmDrnBYzdyODgubNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775680406; c=relaxed/simple;
	bh=HpJJr2beVw8w06+tJvWbmRvYpIT8sM4GVtuL6SDyr0Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hv9ZGHa/CzKZXWRA90/SOsIuyMnqJ7+NDv5RxjbefXpZIAkrBMS+9zu0eHUKpX3KvBi+a/QB4jwhdGNOB7I+y45CGdvBjpblZJfaoRJKZ3TYGFsGMC7hgQa+f1rtOJc6oaTaFg6wSnnG1Me3XznmzLp/oFyASm3cRdlU+asZqSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YuFGiZDE; arc=fail smtp.client-ip=52.101.61.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YuFGiZDE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VtjPFqJluL+L0OFdR75b/KEgtu/R4Wc4lt42KzLwFSgm8T5lJm18XTZDWlUxlE2dyiQ9CsbazTyeHF55ZldqAUEEdif1ZjwVBAqlCKpEOV8fHTHWGvYzRsy6+CPVkwRILf8VP+CG9SMoVjM5uKBgU7muAMXjhUkbl7hXzKwGDF4eJqQUclbjY2hPCdU1jBgwxLPMCPbU7tmqaemtkmoF3L1Fh3W4UZruPH3Sy7FE24Ol1lNyWA3PchRpd7KMDvNwnZ+Dra5FgXUjY9zxHwUHhlbS89APgFvFZXIiodxWr1ckHM3UC1Locl8IaSaMJYy8ibYINadSZ2nuiJiLoiSGGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCYpGEYSm6to/IjdqcgFk5GaR2FBqS8Js8jJiVQrYHw=;
 b=ANATWh9SJqr/cmIPurdjiPWW/NNN55WJS7HfpczqAKqkW+Mcfgu+jdg1SaXfxJ8D8tlG3Sm+zwOaVSeD3ANwjkHl/B8Zi2/ScWrLSwWhWrIndhZi4OQsTFtqruMv5PVLkANLdFIP7h1TuZjG7DQ6399iTh+vyD559ggRh5MlhzQEfsRjgMtlhGMkDkSphguLBN/f9bX5KdwdPUuDsNYU0tq/5437F6q9d0vKhEDLzXkD0aePgxnW4K4z2zT7cZn/mifLEvz6ApPdd006oONuPLxLs0pZdC/tVMUz3iuPmuYDSw0FZfu0cOTgVZ24lNPwomJX+QTzZSHB/NWoi388pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=stgolabs.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCYpGEYSm6to/IjdqcgFk5GaR2FBqS8Js8jJiVQrYHw=;
 b=YuFGiZDEd0LJCrhb/fEPWX7RDzmBlB8MV/dsqHee0/92dEwCIjURlS8HJBz0cclHg0z8CzhcSt6fzF4U9gTm0cWNW/kKd9KUGLnIiavzjpCLEc8/pPAMDxFJ/bqw12bD7M8j/eIPF552189XD6DaOmiv1u45UY+j/tFAzj7DW6o=
Received: from MN2PR05CA0053.namprd05.prod.outlook.com (2603:10b6:208:236::22)
 by LV2PR12MB5751.namprd12.prod.outlook.com (2603:10b6:408:17d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Wed, 8 Apr
 2026 20:33:16 +0000
Received: from BL6PEPF00020E63.namprd04.prod.outlook.com
 (2603:10b6:208:236:cafe::a8) by MN2PR05CA0053.outlook.office365.com
 (2603:10b6:208:236::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.38 via Frontend Transport; Wed,
 8 Apr 2026 20:33:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E63.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 8 Apr 2026 20:33:16 +0000
Received: from ethanolx7ea3host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 8 Apr
 2026 15:33:15 -0500
From: Terry Bowman <terry.bowman@amd.com>
To: <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<dan.j.williams@intel.com>, <shiju.jose@huawei.com>, <ming.li@zohomail.com>,
	<Smita.KoralahalliChannabasappa@amd.com>, <rrichter@amd.com>,
	<dan.carpenter@linaro.org>, <PradeepVineshReddy.Kodamati@amd.com>,
	<lukas@wunner.de>, <Benjamin.Cheatham@amd.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <nvdimm@lists.linux.dev>,
	<alucerop@amd.com>, <ira.weiny@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>
Subject: [ndctl PATCH 3/3] test/cxl: Force RAS status in cxl_handle_cor_ras() and cxl_handle_ras()
Date: Wed, 8 Apr 2026 15:32:31 -0500
Message-ID: <20260408203231.962206-4-terry.bowman@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260408203231.962206-1-terry.bowman@amd.com>
References: <20260408203231.962206-1-terry.bowman@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E63:EE_|LV2PR12MB5751:EE_
X-MS-Office365-Filtering-Correlation-Id: a0d4ea3b-b326-405e-b696-08de95ae1069
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700016|376014|921020|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	BrF6JyOJUI3f8oYdR/Exnr1EFI+3nZD4Z0pePBccoS3lf3c6HUsJAbDltcxY9/JNOcvx14sNi5kzkerrmzL2Q2XAYMmPuLYScm186nnIVSFp2OceoVLkEK2Nmv4HMe/XUP/z1EDpcQ/ezGGNBT0rXHtBT2hyNBHZBd77iNASvsJk08g1ALHUDERJr5fv66VwVYo88CQAuPuk54qGQSSp7iAV3Ov75Zui4z9A9o3YUuiBxvIW8uZ7aISoPq/zJUfb323b2g2fqlkojZJqd/luGfWCuAZ2ZWKr+Rqura2zlGN4ztMQRHyPcDDDHb0HcSVbDUuwOB9GanpS3U1j6lXyBxUku9TLlCJUDmMhfBigrkcolCNzpTDuYUfTfH/0nnnhDoV6zMYkFDMRAMiMqTHIJmgzEq5gfN19UA8bXsuvwvjeob9kcctMbRuBZQeykBFEAdnOUg+pzte8YFpbQViJjriJca5s96gqCrmAwNxXQDnUgQIWI9mD1L0LHy0eUfxMD9kqXoWWbAS4ZTY36MiOECEcO9dK0yjdjT5AudWIS9m07d3pAJiTxH/mwXiTwMhcTR06k0c9aLW1pVWsfWBFOxjwTOcLQx+XqInrPPtYkRmf39FS1ehP3SDxzjcCGr90/DRGQdclTbrGfY0Au1KvpXkWBYHKMrqi//PloWwKEEBKaoyEgMwbA4XcWJhvvnR91dg+qLOQfVlKVfzjH+dvlM1Ry0lD/SvDXxW/L0w+YrY6334Iq/FwdLJPRVn9KA/II8JxRhRteLXvs7ulAyIPA7lWNp4nXSzjGplmKszZ6SPBpAhu6ElVBa7Lk5geRTN0
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700016)(376014)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LCRECotU0IyDAkdEE1okGC9j+ubQOEv1TwR3yXqUfJiJ0DIu1PRb2OH3OL/pRuk3iO6R4n/4EsFqNZ7SSqyuxSyf5AJsobg7FM/dRzL+DsE/nLgnsG9d0vS7MOZJTn4REplDbmj1KnjKjTNsCkOytvpGyrbbhXK562dBuyrAjitbGHVaAkl1oRdhK0NsCm/37wyHWaOztKHrp5b06HyOQJ3M3p5oVWIOmzIBmsFjsN9O0Nss84LNm3WR1qvBFidygmom2VuLGFYSVha/kNtVGyElqzVUCOMcousdj6cwRaXB0kj38jPZvvyEUWD5Q/5Io4ISJqXEc1O3Qo4IusH3zVKw9lFCaTTD6NytkFdL+7sUkhU6aQlSlV7zkS2X2JMZU0c4ItSNuCs8EXEBATDd488R29IuZyDvhq93RmmRqqu7+AeJeZ0ZcTncQFmXdxg7
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 20:33:16.3493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d4ea3b-b326-405e-b696-08de95ae1069
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5751

CXL RAS error injection (EINJ) is present for Root Ports but not for other CXL
devices. Provide the means to test protocol errors for all CXL devices
in a testing environment. Use 'aer-inject' userspace tool to deliver AER
internal error notification which will trigger the CXL driver's RAS
handling. Hardcode the status for CE and UCE errors in cxl_handle_ras()
and cxl_handle_cor_ras().

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
---
 ...AS-status-in-cxl_handle_cor_ras-and-.patch | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 test/contrib/cxl-aer-einj/patches/0001-test-cxl-Force-RAS-status-in-cxl_handle_cor_ras-and-.patch

diff --git a/test/contrib/cxl-aer-einj/patches/0001-test-cxl-Force-RAS-status-in-cxl_handle_cor_ras-and-.patch b/test/contrib/cxl-aer-einj/patches/0001-test-cxl-Force-RAS-status-in-cxl_handle_cor_ras-and-.patch
new file mode 100644
index 0000000..d8562cc
--- /dev/null
+++ b/test/contrib/cxl-aer-einj/patches/0001-test-cxl-Force-RAS-status-in-cxl_handle_cor_ras-and-.patch
@@ -0,0 +1,51 @@
+From 1b4054d82a1834e211ef3f284b9f51926db8f060 Mon Sep 17 00:00:00 2001
+From: Terry Bowman <terry.bowman@amd.com>
+Date: Tue, 7 Apr 2026 16:47:45 -0500
+Subject: [PATCH] test/cxl: Force RAS status in cxl_handle_cor_ras() and
+ cxl_handle_ras()
+
+CXL RAS error injection is present for Root Ports but not for other CXL
+devices. Provide the means to test protocol errors for all CXL devices
+in a testing environment. Use 'aer-inject' userspace tool to deliver AER
+internal error notification which will trigger the CXL driver's RAS
+handling. Hardcode the status for CE and UCE errors in cxl_handle_ras()
+and cxl_handle_cor_ras().
+
+Signed-off-by: Terry Bowman <terry.bowman@amd.com>
+---
+ drivers/cxl/core/ras.c | 5 +++++
+ 1 file changed, 5 insertions(+)
+
+diff --git a/drivers/cxl/core/ras.c b/drivers/cxl/core/ras.c
+index 006c6ffc2f56..09ff82973c70 100644
+--- a/drivers/cxl/core/ras.c
++++ b/drivers/cxl/core/ras.c
+@@ -183,6 +183,9 @@ void devm_cxl_port_ras_setup(struct cxl_port *port)
+ }
+ EXPORT_SYMBOL_NS_GPL(devm_cxl_port_ras_setup, "CXL");
+ 
++#define CXL_RAS_UNCORRECTABLE_STATUS_CACHE_ECC 0x1
++#define CXL_RAS_CORRECTABLE_STATUS_CACHE_ECC 0x1
++
+ void cxl_handle_cor_ras(struct device *dev, void __iomem *ras_base)
+ {
+ 	void __iomem *addr;
+@@ -193,6 +196,7 @@ void cxl_handle_cor_ras(struct device *dev, void __iomem *ras_base)
+ 
+ 	addr = ras_base + CXL_RAS_CORRECTABLE_STATUS_OFFSET;
+ 	status = readl(addr);
++	status |= CXL_RAS_CORRECTABLE_STATUS_CACHE_ECC;
+ 	if (status & CXL_RAS_CORRECTABLE_STATUS_MASK) {
+ 		writel(status & CXL_RAS_CORRECTABLE_STATUS_MASK, addr);
+ 		trace_cxl_aer_correctable_error(to_cxl_memdev(dev), status);
+@@ -232,6 +236,7 @@ bool cxl_handle_ras(struct device *dev, void __iomem *ras_base)
+ 
+ 	addr = ras_base + CXL_RAS_UNCORRECTABLE_STATUS_OFFSET;
+ 	status = readl(addr);
++	status |= CXL_RAS_UNCORRECTABLE_STATUS_CACHE_ECC;
+ 	if (!(status & CXL_RAS_UNCORRECTABLE_STATUS_MASK))
+ 		return false;
+ 
+-- 
+2.34.1
+
-- 
2.34.1

