Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012039.outbound.protection.outlook.com [40.93.195.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3B028371
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773882926; cv=fail; b=I/aMPVxBOsbPsUztlGTy8pxmOKjln3YfSihpXKBUCEIJawyff5seHzaxKg/4UFEpOJVk4zVE7ijPfK/xraXIwH2Nmd3xfLiiy8HshCe0KJPKBMfXxtiRBUEiT2uaYfoMkP8A5Dduq+JISY/0xl/GVeO58WU/C+nW1tS0fTT3zHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773882926; c=relaxed/simple;
	bh=lhgEXqFYtiGIWNx1Wl9A0CjBSh7dZID6gDP0l5DWu1k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tQ2Rb6CnvIbM/e6mKS+TxzbqSiWStyfNTqNtDIBCQCgvnbJKBJBRB+gWGfKO1wpTxEj8wSpninGn51H7qoFhHxtJIL/Nmt7bwFu5ehYciuV9+TYQhohNxj6hwsdtuMOdMKVeB7e1Ac8mU8sKhb+gYaPY6+YiPJ6kzeTnvC072Sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nKaS1Q+F; arc=fail smtp.client-ip=40.93.195.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nKaS1Q+F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v1esKqqW0u0aWFPUGt5aNK8vpIJmDJH1A/a8RK851Il5FQbiAqXzhcvrrr8uYFcDjwPiEZA6aO03kYuAbkfXhYbr1n4lXeLfS6EYbDOF5mIrGHCQSbCA/6HsMSXZka/EipAO6Kd3Ebns9Vh/t6M+37vf3fXFtlKHVad6YEj+Y7nWIuZiL3Txi27UVdoKYPweZAqk3yfJTyPPLnx8sHPuzNfg0lwLBfzVGv0v6PZDYxSYfW+H4twW0BpwPwoSXurcNjVpAN/JNh+vzpCm/T/MdZGVoC81SAH+SO8ccE94O6uhxQTVOObnz7kj7io/w4vXyTp+fdPUMtlxO+OGrCBzhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zY1gDnoAXjMDXYWKgOo1fvoKFkLxPDBWJW0ZoQ6pw/U=;
 b=sgiRifeu+nYh96+TfAROwDvmxt3CasjUJ+tUFEYVpJTf1J/LcYN43MyemLqP3PeU6nHjjYy2EXwAxCSiMyejFuFu2nFY+aoSmJWTKOYwXrHB9bjr8BjbPvLmWWboC/Qnw/x7S6YxRG9f8BWvckSuUCFIUgQ2YohAjLJ2uQUA+dXGkdVRRm0kDpG+iwdbcj0JN6X2QsWXvj1Akm2uPpLBWS092qKZ7HK9vLOx+uFskwjulqKBB2NCcOHBjBEL6e4FXzpcQwA02JBvlLnHirSsNKtoOmF8aU23653z6eCVurgoaeDxnVcw3y0ol0gMPZpaCyWs11cAvgi81Vs7Ycl1hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zY1gDnoAXjMDXYWKgOo1fvoKFkLxPDBWJW0ZoQ6pw/U=;
 b=nKaS1Q+FSVyfb7aoFbv7FRKvEbAn8MUJsCp5cFsWijKlT+Ehwt8Rw+XsfUE1qt/tCN5u9seZMrKdhKr3Gug/X/Qh+wGIGI+umWCkvX+GFtFpTaurWVDDqEPYo+s3ZCDU8xktZd14bTMqEQycd07n8mB/kFOQZke8/YnwSz2eemY=
Received: from SJ0PR03CA0377.namprd03.prod.outlook.com (2603:10b6:a03:3a1::22)
 by DM6PR12MB4297.namprd12.prod.outlook.com (2603:10b6:5:211::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 01:15:18 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::a) by SJ0PR03CA0377.outlook.office365.com
 (2603:10b6:a03:3a1::22) with Microsoft SMTP Server (version=TLS1_3,
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
 15.20.9723.19 via Frontend Transport; Thu, 19 Mar 2026 01:15:17 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Mar
 2026 20:15:16 -0500
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
Subject: [PATCH v7 2/7] dax/hmem: Gate Soft Reserved deferral on DEV_DAX_CXL
Date: Thu, 19 Mar 2026 01:14:55 +0000
Message-ID: <20260319011500.241426-3-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|DM6PR12MB4297:EE_
X-MS-Office365-Filtering-Correlation-Id: a2df837d-f9b2-49c8-b56a-08de8554fbc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|7416014|82310400026|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	z7+x0yhDM6XkHSJNflLq7Vsk72UE+m1RgxId+mRQgSGZZu5inrkYEWvGdxBKh+EWsYSszhN5LZoN1ee6TgyVBzFJwwr/PZiU4wOoxsuAt5Oa6sc+gjciZMBgkIJhLOF0/BCJ+9iMdq50Wc2EO7/LcWAXh8bAnaMMP21CDehpTWTbFGz2hdJ5fOOSj6ZRw35+QvGnL1ip7uvBBEcW7bmXSvLVI8Ly0FOa7uBH4Br6wHVjKbxcDHvKKbA4uGox87tlnZ9HTHOXK+ny54iJ5UJ1PVCAUAwOUxzNp4p8/TZYpHKYjJCU4PKCctgBlWDsqjH62LlocYblThgGF7tJoMvqxQSLi1kTO0AhwdGWwb3uGoMrwGJigZog76x9PdnHYT8M4EhX4AomMtrVpJieDK6Jk1xUkD8nr3bzthqTZqzBpyuPn0YtdhtHfXGrAOmdZrS/PvBw3BzZD31L5CV9PjH9P183kokRq6K1rbZiGq2BB3L1Vff/bQ1PlaAiNWcO8ZPJS/ZK11ZblfZTM8HKUn/cc1Wt9qIedUqckUQ2QYUQSfQe+fXs0/LoADw9+qx1YEpVl4N4qReLZ9CDq/mSM+nQGFXzN69WkYMJY00J3eWuDpzmy0XfN+tZt6NqFgZ1PnM2nlXmb+w0uu65GyBvpYUTINDkhUzAMGyE7HGE41Z/eW0A7Wloccn8C7Cp7K43Wb4vAEpf8vHmke8bO4TXLJRg2thSL66mmZqq6Bc9w/asMgYaL5qN1Ulq96teH/633Xg5k4ar48EMjQVcmyFQM0lgiA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(7416014)(82310400026)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mr8NXY+3uS1DzFcaCFJ2mv+xaCUxboSczPexnWBV3KRqRH8fE6c1hkiIZntoieenDd5XV6YUqVEwJeEpxhyA9AvbCfif+FWgol2NZ6ELDEt5L/ApKuBgQi1BSNJy8jJpB3R5GwuFxQVU0S2wFSrYVIqv9MSeb/33pDMTEDrYILydQxJgOi1M82pPGrYtVZHO6SQPA/wICto5EISInJ7CxmGDtSM4wrg4nb6t0P6sNuzf4XLlroqcWsn7Rl0ZHwwBezJ5+K/okaIs3gyrHDzqzEfEiJyEsFi67NlOtqZvsrdDzyAapSjyKHAHivZ/luPVtX5Z2Pz9fIF5SMhlVuGuGSN21NNs/qY7VaYZ5I9EJvuoe3qHQ7KofqWR2WPf+9Ec8Y3dWzUlInmT1OciV3In83Wiw/2CYxO5/aJ9238JlwMypd1qE5SKltzXFt5AfOwD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 01:15:17.9675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2df837d-f9b2-49c8-b56a-08de8554fbc2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4297

From: Dan Williams <dan.j.williams@intel.com>

Replace IS_ENABLED(CONFIG_CXL_REGION) with IS_ENABLED(CONFIG_DEV_DAX_CXL)
so that HMEM only defers Soft Reserved ranges when CXL DAX support is
enabled. This makes the coordination between HMEM and the CXL stack more
precise and prevents deferral in unrelated CXL configurations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
---
 drivers/dax/hmem/hmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 008172fc3607..1e3424358490 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -66,7 +66,7 @@ static int hmem_register_device(struct device *host, int target_nid,
 	long id;
 	int rc;
 
-	if (IS_ENABLED(CONFIG_CXL_REGION) &&
+	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
 	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
 			      IORES_DESC_CXL) != REGION_DISJOINT) {
 		dev_dbg(host, "deferring range to CXL: %pr\n", res);
-- 
2.17.1

