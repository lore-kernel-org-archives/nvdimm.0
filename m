Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010009.outbound.protection.outlook.com [52.101.85.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793E237DE8C
	for <nvdimm@lists.linux.dev>; Sun, 22 Mar 2026 19:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774209243; cv=fail; b=sm76PWu1xCSTvhwZfoa2KF8ypb7E6H5TOe/QLMmjvtya9pdaRyYE3u0Mb39G6vfcCc6LLDlpT5T6i7sKkNP5w3ea9A0nrW4gGljywIs4iwx3hdl5R8wmwKJc+sZsazMQ6a4m1Xc73v/6YlY0Cn367fmSr4mZw1YqVC5skICWs1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774209243; c=relaxed/simple;
	bh=W4BJWAMnd7sBRJyNRz+Dc3D25teAiNo8J+Dk534+RaA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gDYJ04NTSxSyXx0S+ToKCvXQe5hXGUORTGd6ZHwWfFyX8o7hU+Fde+k46lNU9eTYVXWowPok1JqsQCfavCMTIYuDVUJBX4KNHH512AdtO/rWiGn955brLs5Wm2QA3LRaND9CjVEGfFLA320UwHDr6//UYPewveL/9nEo+TW5q2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f9c1FZ23; arc=fail smtp.client-ip=52.101.85.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f9c1FZ23"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QnasGokszXXzghvMEODGIc1RS0keInh2Gch+rANmv4w4yiC6jVeVNm9jUv0+YBQT/q+VGaK6z0QnkAIu9Gjs4THE63bjJhboqp92qS+FgmQERhv+QANPQsGITP6ej0UBalMDGdxs45jMnr22gOVlyjkl/jczpJViDBFOrnU0QNNgykAxknh0zK8nljTZoVzLbLUM8PZD6Y20uihjVdjlGuUJ5XNAe+1j2s7ZfQUTt76rAq4FC1eYQZ/jj/NzF+zl92R+C3gfaeEKZ8SIubUSGQANaKvkgKe9ZrygHp50FbSTP8D8KuYf4B1Vw3O2x6ZasNJvO5Dm9DzSvpBXQiua8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nb3/g2QsOoRbAwB7rRbKE0PIaBY7uehA9pSGGP247W0=;
 b=c1jKX2d0Nl3Be90YAhMLSxn45cz9sgSE1hro00k7izoJ1R+p1z6G7rrS7Vu1pNBM22TDNtTv3NZVuAI6mbLi+arAR1NsQS1McLTDRmGB4fAHM6X13loBV1AU3vIkxIata3SV0O9lbbvQM/giIIfCS8l8xvbNP8YVp9SDYIU1+IS0wJW9pxhm2sCAZHl6yYzsG6E0ff/AiH0zJ9sZ7onGk4v8N0N7KNcPMV9af+FRHvPNShGwIill4WWyKZGTlRrB27sdF/zpNk7mo/iybzAQ52nKVENCuNFt8o0Eb11HRmWgL2OXTfB+UPG6TllKGmA2ApTHratszR67R/zOOqt/DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nb3/g2QsOoRbAwB7rRbKE0PIaBY7uehA9pSGGP247W0=;
 b=f9c1FZ23lH9BfOIapiW18JA2VVFref3WLTEsHS/t6+KKrzkrTNqrL4cy8GpIGtvJo6FQwOalJv/DYOMfWaecJcrGQK8uY4z+s8pClhNFJiV8DkOoB4GhmkxTREu72GfFaxFBWW0ZpEOONB8O+nytA4nBiATwWAgiUqUG8Aerc2w=
Received: from DS7PR07CA0014.namprd07.prod.outlook.com (2603:10b6:5:3af::17)
 by BL4PR12MB9536.namprd12.prod.outlook.com (2603:10b6:208:590::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Sun, 22 Mar
 2026 19:53:55 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:5:3af:cafe::22) by DS7PR07CA0014.outlook.office365.com
 (2603:10b6:5:3af::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.25 via Frontend Transport; Sun,
 22 Mar 2026 19:53:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Sun, 22 Mar 2026 19:53:55 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 22 Mar
 2026 14:53:54 -0500
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
Subject: [PATCH v8 1/9] dax/bus: Use dax_region_put() in alloc_dax_region() error path
Date: Sun, 22 Mar 2026 19:53:34 +0000
Message-ID: <20260322195343.206900-2-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|BL4PR12MB9536:EE_
X-MS-Office365-Filtering-Correlation-Id: 848863da-18d1-4662-5205-08de884cc000
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|7416014|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ozCAcXtg3viERuc4sQJIFDkOZFuQlN7xc0XI1UgcjO8f7QFUBtcyLacRX+91sZPgFT+lnMEJ01icQH5aeOI4g+awGJAVY1A3Z1ziIhFq3qTK+BGUcs0ZvR9mR58M9DKKjTuukMxtj6StxvO7/H2qiTvrd1qx0QRIwLSvKBxx2caaCEilJiaHM4ThP1k6wjL8dM/D9t36DyyWed9rkWgDsmqwZxgaMQjnKSsXKoLO6PsMPTIuWzVOs/7pArsHC4zh0poju2BcrkYVwJ3P13w2ap0VgORmoQyH2x/yZYy+xAIotzvqrHqLVdd6p4xM5iVlZPL4e8n8F1GURgUFrM5fjMfbPVoIxsajQa3z5IQzSw5c5QVP7YWbtPoFD3EML6AhlrO2jMobTz8j5Hnpi3sP3na2v+B61wE553GnJdGWjgPSek5P47D5w7aZGIzskKygWqLBbYnSy75drXqBpxLjm78QNTvDLnwsw8xeJg+dU3aNfYhUHXdSbkHjigvRfgriB7uhH10EfRZm1Tr9kYynoqUWWpOu5yidySdJ2tu75PIBi9UMNYQuEpfj2VmMZoPJ4Pd6yvAXJMUerJkpmKB0R98C6z6v3iEPK6gh8CtbADhR0cwP33pif/NwH7FxA+TOPAs9WTr0m2y2loGSfd3dYSpghucvlvUcUOA8xGI8XC/ry/Lgn10tZ9rAxqx5rekx5G3A6GC5H9IGMEq7U8ij/yx4ad3wN01dEHJ/GkvWUatsH32bxXEjTMAn3BgJFQ8a8h3ujvUdA9FB2y+3DGePPA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(7416014)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	veezwFEtX8TofSVfpHo2v9Iki4dpwRYUm/EXNr7cvnU4oydXTz86DBzqSJPOKKiHiNv7N++cItZ+TQGoabHSsHrB12bH82NSEwcc7EwAcamNYCBmzvhaZtjjliY+Bm4mxvw5yPV/6HAHGFoWHu1p3iN6zdoOFfE4xTb8xtg1chjpAyHK/pxAJvbj1Cfe/PRDuvPmra7kMKZArqEl+c5zeYXI+ddqDGcWnyn7x3zrvgZHz0jtJ+lc9Vur1nV/a9mv6MU3QA/JXBjGrnTeroSi1XaKy2lCXnGXmNkc7qDyMBUyduznicGUdRIzlwtj0RG6RZ1leBUwtl+VlZplmQsg8PoULOAlsFe4r1xeq4J5yl49cFgq0mzkwwbo1AvKfVC+c7turzpu5U5DdSiVHIny2FPc8z2tZdYg18qBkNYe1SkpA+jk+ppjeCkN3r6KnYb1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2026 19:53:55.2572
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 848863da-18d1-4662-5205-08de884cc000
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9536

alloc_dax_region() calls kref_init() on the dax_region early in the
function, but the error path for sysfs_create_groups() failure uses
kfree() directly to free the dax_region. This bypasses the kref lifecycle.

Use dax_region_put() instead to handle kref lifecycle correctly.

Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
---
 drivers/dax/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index c94c09622516..299134c9b294 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -668,7 +668,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 	};
 
 	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
-		kfree(dax_region);
+		dax_region_put(dax_region);
 		return NULL;
 	}
 
-- 
2.17.1

