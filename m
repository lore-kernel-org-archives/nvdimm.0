Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012023.outbound.protection.outlook.com [52.101.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD6237E319
	for <nvdimm@lists.linux.dev>; Sun, 22 Mar 2026 19:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774209249; cv=fail; b=durvhoBcZoP9iiY7v/jw7TiSMExPm7pI9dUraDEPm5tbMwmgi0uZ7FUCr48trMP/hKyJIXYgx0iGkigVTJ5Cbn7Z5cxAU3wsKI1WGrFqNvdnyckuWU9p3IRk06i0h4X6jjrAK51wvwEi8gBLXDdEB2GOFmRBRZ7KwIsA58TcwsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774209249; c=relaxed/simple;
	bh=7HHGC1FPMKeoKCFnKzed2C1c0LH2Fu9wgElZyZdXMec=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tAlsG86Sr2llTnbHN9QF1MZ3XwBdNyDdZj3jDHvR8qfRYdjxAmFxD27MulHRA4iaIoF5OZGWXpfq0pza+LQdtu46C+hPlPtFF0RBnCF9wNi6VKLuN3lTO0aE/clUCNFN6CzxQXzsQOBDFFDcl/fToBjSr+YB9SJ+gfDpWX54roE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MZictCaX; arc=fail smtp.client-ip=52.101.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MZictCaX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A4TAn6DCx8G+7ihh1Aejr5rHRw7ThxDw5pmjF/UJkrBpRMCn/QFH4mpMl/NQWTuZlYXOgRpgOQqukY0I5PSDubF/8d/+vSZH9XxmhRpjgddaPg5kwfSfBU9bwUrBxm+zjrLZ6ginAdpd74VWwCT0s/TqhgaleMLl15oPFcGrRAS5rDcBUCJdg5zJofKrYepq+LX3GbPlrFJmMT5kdL7WHQ3IbthTyOJ8mAHGbnKnPT3Pq+cQ52wAh4klGt4uQ+meCbs401Zjxx/reBhzMbv7sQ3n9aAE9/MBWUGFS2SZK3ghtJ0VxSuI1l4I/OOaqD8wjkB2XWs2XOvLFCg2PZJz1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EkGpfCChZpYY7ppP88SJ6JLRKmBilznCbrQPh2ZKZkE=;
 b=h7Ne+Qiad42s15GUZnIAYWJnGxstNFVqjWAj/jmsMNPZa/UWqoo/kar2ISrd7O2jRVYB0Ag3h6tDjqsJYMscj6btMei5kn6tEdsyeMV5Hra3EKJWXyQ5/p0+I5tR5BFjHNC+L7fwL3f3/a/XNG8bMOlNqBE+8mlm+mz66swB/IZE/+ECW3W7IBYWNA6kNES91CcFt2KB4Y9NZ9KMpxI6JVm5LseDAGgmG8CLTvLNu2AF6HoJb+SORvxfpQ+Yc7rHSDMeaCqLyac6zlOV2svfe7U/CWMCFKm4PySt20aKbgatDwt24zHiTsoSa1hMgmjN6TuMQdBAPjRmH4+/83Znnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkGpfCChZpYY7ppP88SJ6JLRKmBilznCbrQPh2ZKZkE=;
 b=MZictCaXJfUJKCkbgZCbnMrqUz46H5Euki5n8BhTluGfeCE6/i7U1yLfrAzR4bXqOLEW+Xw5ToAoDcBOeDzRFyRMmINT7oiOEifd5/DjOfkWfmRMayzEl8EyPW+s8W8OOqCO8MmZg5rj3+ahsgUWuZ/OEvMr+c2iYBnuneX2kt4=
Received: from CH0P221CA0020.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::21)
 by IA1PR12MB6236.namprd12.prod.outlook.com (2603:10b6:208:3e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.15; Sun, 22 Mar
 2026 19:53:58 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:610:11c:cafe::5e) by CH0P221CA0020.outlook.office365.com
 (2603:10b6:610:11c::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.25 via Frontend Transport; Sun,
 22 Mar 2026 19:53:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Sun, 22 Mar 2026 19:53:58 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 22 Mar
 2026 14:53:56 -0500
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
Subject: [PATCH v8 4/9] dax/hmem: Gate Soft Reserved deferral on DEV_DAX_CXL
Date: Sun, 22 Mar 2026 19:53:37 +0000
Message-ID: <20260322195343.206900-5-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|IA1PR12MB6236:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ee7ed8b-3a0c-4eea-b76b-08de884cc1a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	sCMJOUe1cky1LfFWXQg3hlvpol0pyrmAbRCh6A4Id2eJ9AXEdXENMlcdZHBW46bVNlysYjg7sTh5NkuRppa+BA3tz4ZpKOZbJwdKSwDV22JDrDCXIx29IYRUEW89d80FZOfhMHdmfp+kpsIqZqtylUic3hSoFyt7FaTxb6NMdMi1snQbSypfbntJw1Aa9/EHfETFibYuvpyFGJzhaJkd9zAgHKVGTCP3jrup8tweNlXmaVwn+Jzu/yYHE7j0pOFCbmmDzfZnGbY3ugrgSoyDkO9UzDtZDS1yhcjGtVPwbwoqF4w88q4/8yinmGba29Qs+IvkyFwReFKslN2sMTfWhrY5GaIqgafXGCr5l0ifGv32MR/EeQw9M7YhBq4JyBiG8Yj0Vd+TOSzB8b0/mY6aWLPO4n1jo8+xuT7TwTRuSNNzFz9lXLW0G4YWwb8GSdICGBIJ3S/tJd5Q88oG4f9QJ0+oHJMvdOX0h6qdWiaU0k6/plWFRP7k7gbXg3noAzJeqhAV5IF2FNHvcW/j4iJ4ik2MZN7XvKTsFMPv1SZbUuxcZwIdMRa9DGsbWTxcirZcTMakZrhgqu5aNSxhvQBICuNCWpnKN+LC/Tf2lLjXblmCOrq4089P0pBiyF2aLo0GGeon9nsRHdNmlcfROoWTG3jFCNcySyfAoh1CMGQ7tKGSVa4ftK07BV4p5S6FdgRdl4i7T41kzIa9sp1qA2unzUjof1yHwPs9LAsV6jL70dsjDKLLeo9YEQ7OeOzETexyvQbcgOALdnIkARW7x6CXEQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WI/dqSCt3KkQ+5zOpvKRlLXemIZO30/pRUuJQsFsQRdHogX2zAsE8BJ2V9xERNaFOCF8gowyXf1KSqh3YMQmAcTB97laUbap9xLD461oaZGi3+BFkNdlzDnAG4SISWeBksCwS90B8TrkzToLcAm5h6e98BidnpFvgIOHEqFHoFz6LaAzvCllFzZGb/zo1RogwaMy5PnOm8gKZogPMUBtQZapsAFOjzFNFMTJje8ILhN1cQYnU6pvMnfhf9PQkMMldqYi65cszfAxzW4aTDxumgTufB5KBdtspRnMd9bC5CqbIdER33gqbtP672UgTEbTqvwTt/v4+wzoLkwGaGAxNItJlNJM8c8qsqd167akKy8fG+YFqCMa6g3QSyMU1ls0Cl03rSE2bnf2wNygQkdqCHUlLJRlZH5gYaeH03SmXrudi9qvNhklimJI6dbOIxLA
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2026 19:53:58.0471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee7ed8b-3a0c-4eea-b76b-08de884cc1a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6236

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
index 85e751675f65..ca752db03201 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -119,7 +119,7 @@ static int __hmem_register_device(struct device *host, int target_nid,
 static int hmem_register_device(struct device *host, int target_nid,
 				const struct resource *res)
 {
-	if (IS_ENABLED(CONFIG_CXL_REGION) &&
+	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
 	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
 			      IORES_DESC_CXL) != REGION_DISJOINT) {
 		dev_dbg(host, "deferring range to CXL: %pr\n", res);
-- 
2.17.1

