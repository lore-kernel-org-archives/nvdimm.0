Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012008.outbound.protection.outlook.com [40.93.195.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E537E37EFF7
	for <nvdimm@lists.linux.dev>; Sun, 22 Mar 2026 19:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774209249; cv=fail; b=bVb6Y4FkUDURrgu1Lh2XHzwsKz/4DF4Ub95fBkw12NO5MHAN0Rm5B0FAYHS7Dl6681aFYx6WL1YZpm5rtKE4cTLBRY/fQm4LIwwGtEvT0PNEZJx9ow28bv+sAXF2S8LyzjuL3RZvKteXesLeNIme66lu6pZjl6f3WODZtlpMslc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774209249; c=relaxed/simple;
	bh=4Q19NQLb3//edjWKB3/v7TESXRCd/sadj4Ge1vmAdas=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gUzk9GRPowdnIAZMr7LyR7vR6tkZLs2lT88UGauuWD2zw5kuUsZIEXPAGnixBi6zeXjOwmlrqTUDcnXkGHm2iNWJ++mqeVFDj7NiPVVKjOTLIKLQ95MN+5vpDBfVOiqCMgqs040P2xeVSAjYidZvmw1/QM9WXRvQacn2Om8ufz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1Oy0GSS+; arc=fail smtp.client-ip=40.93.195.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1Oy0GSS+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E9LB/PGzRPMPyO1TRVaflwlnTbkvVcSLMWzFO/1k+zENfV8qbiOGpd60cuFVQ9ki+2TIvmdVDgLyOXbAvc8Ldyo0CEZJPOynEd7OWr8VFNjZYBkTbYOQ2GY8PWgtQK2F5AnapBxXXLGBfyH116ikEblkGfmB2S1pSkfDgepM9xoy7cZW+3VPcGORl4y4zU8d012Ggr5e7RE86XsK4s9yPjBYOfGnpHkOflMVsZkTYxiqNtlmqOXGIYvUzMW6G5A6y+lg3YzVD94rt9z9Ho67C7Tr0zgBPjHdePdUBUnmVLpNbULxxXde02p5Gk3S3SOeS1FDS9/ff+loRrkzTns0iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k4uYuYXziH+LdUWD1g9mqZb8P0ICrMsMs5RIYiGdobk=;
 b=SCEXnqj5nqxBs/sllgCf0XCEgXNb+jw2vonMC7F4tnANxXRFifUtwIuJYFaaCDFgL2qKaWSF2Uhcs+tPca68AlX7nj5vOuNPA/2860i7Uo4cTAX+Oh7asUrAY4mCVHluUXEg2bVHxpgErP8p6huakSasEINpbXOTW0vl5r55kA3dO3TYSD5TsbF31WVyUo81E1iL1mNwHbGt5MIVxL/nbZatQyMxDFBr90Bf+K6MDouQ84UKWYqXkrT9leWiyr+/X2+Yd+4JK0PzrOl5BYzigsn8943JG9f6oEprS8KRwtSqO+3VDYue9/BarzjW3VZK3GUK7XnXQmyqOgyIUWkL9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4uYuYXziH+LdUWD1g9mqZb8P0ICrMsMs5RIYiGdobk=;
 b=1Oy0GSS+KyYNDJfyyA6d3BbcAhJ/4ad4OyXujtvv3bvqb1+poUyfCGVxyS9Q6kJBeMAujvHKlpmF2nedRVdZPocFM1Qq8wTtXEdwaDVcnxUjQWPDX8IlGz6qTEcN5FTANBE2QScyU1PSNbdx/jQ2UdFyVWJ4hJCB6KSJQb6jY1M=
Received: from DS7PR07CA0016.namprd07.prod.outlook.com (2603:10b6:5:3af::18)
 by DS3PR12MB999218.namprd12.prod.outlook.com (2603:10b6:8:38e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Sun, 22 Mar
 2026 19:53:57 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:5:3af:cafe::9c) by DS7PR07CA0016.outlook.office365.com
 (2603:10b6:5:3af::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.25 via Frontend Transport; Sun,
 22 Mar 2026 19:53:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Sun, 22 Mar 2026 19:53:57 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 22 Mar
 2026 14:53:55 -0500
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
Subject: [PATCH v8 3/9] dax/hmem: Request cxl_acpi and cxl_pci before walking Soft Reserved ranges
Date: Sun, 22 Mar 2026 19:53:36 +0000
Message-ID: <20260322195343.206900-4-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|DS3PR12MB999218:EE_
X-MS-Office365-Filtering-Correlation-Id: a3dc9e3d-37e7-4d37-e5b2-08de884cc10a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|30052699003|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	wip4Q2TCHsYrBWayrOzHuuzTMVE4JbZXReyf7IT285uLP2OOSgXQSkporzNQAGVPWju/JsP38fD0uOVk0dDIXehiCzpzTv3SUqqaKCBhsyTcVCNcQeedLpS/84d08T5rzrLaSFpO4hybcTChrFPmNFoNWm2E6+S+WUlJXjkTV75uc7UfkiTNdgD7s2uC9IJlrFk1UK+IssIQHqdGNWWNenhGPtDCVWipxFwcaijqLqd+71s14OOZpIWqokyPWbvSVZJ1JqYBkSVpmsQ1Iqk/3jasVN5agrJ1zA9tFBxEhFml5ZMUJFm4k9cUlCPD8a417Bo0z026qgMERntgzYWXoASq+suvTHxg9LcW8vCu6RNNCNTIl02CdthfWscptxFH5SKIZZ97Gn2xcPGK4EowH3ZkPqDeWTIbOb+1u3LIVDy1WFWY4osYIodGmKzLHiLE/YeLSxg3IRz7KJENnDhGLVqK3SnpjZBKDX7WFa+Tv+Zx06dLwgrP8/DgryA5DG0/x1k043MNW56sDOr/TLByWxBs2LMJqbmIknv7/nox5cDLhr5jJ5WeAkDsSmCzymi0khb0uCFXsao3/GclYgoo/XZu/1oe4vl+h73XKXKCU++TtthSeF/Yij9AC30glXRS/YIEwy2jPT+SU8fK5ToBjX6vHZKUKPDKiZ0lQjRpyNeFYnsWNfC1FcSkNQWCXMM9TGgX/g+HmreBcEd0MKSMeBXbr4j8X1MrxwtzuDqdM23eXfWXMr+M04c/zE+0qOrdu7h+Fq8wScpYrclETu/GYQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(30052699003)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7xi857Afszol2T7jFsFv36cEeGPG6L+EddHOSMUmgVjK3bnrYTur/EdMDy6DiCFyV3a44D59OtrogN0TufWnHP3aLLJleCf4Fs6OlDpPnwRuBg0g3MTbFFSq3TvnRhjZG4+nkWHQzmlN48rpkAaADsVBeiIsZ79tolAnnhYzxB+wR0Trx8DyXAbOeuspGiOMoThMPYoTTlrH0aTxkSzEEWJHecrqb38A5vlRsmD/J6oV1WExtwt7tImvuiv3goGLLW6b19vPryTEEzsXbmAh0p2MaWQGHuaUVCBgt9rScbH7sGFq/PdNNelnjLemDGYgrKNa1X8qbfBYo77TiE4AFslm2mkHvf10sxv9bIQEok5DUBCJ6/83Tq4JedsKh1YRsrcWdLs0bFhfaTuDhK43R27AOlBJO3qhfxUKGIqmINd3pprWEphF4EtBQiU0clkF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2026 19:53:57.0009
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3dc9e3d-37e7-4d37-e5b2-08de884cc10a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999218

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
index a3d45032355c..85e751675f65 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -145,6 +145,16 @@ static __init int dax_hmem_init(void)
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
@@ -165,13 +175,6 @@ static __exit void dax_hmem_exit(void)
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

