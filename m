Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E027C20E31B
	for <nvdimm@lists.linux.dev>; Wed, 19 Mar 2025 11:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742383979; cv=fail; b=t5Oc/65fIQxiaXbv+vQVlwIQfEaMue4yYwINcDXiwXE2AM4PGkpEQbZtzEFf3rfkuKfFYbnQXdaOXFHdAzDP5BpFAKw/peQKb2Gxn1ApX5VK5aIvEjyKACCjXwXrQ+qwylYLfPJ8ehNm3s+uXtfNsqpxC8zR5EWp+F/v+jh58iU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742383979; c=relaxed/simple;
	bh=35fYQMyXbAAey5BfB+tGq8ULoKJT/yFek0CuD2SxPzU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=taTf9vpBLk/5LY/SPkruZY0j8rRgRlAWbbUzC9S3UBV9gk2xFUXO7eQFVSN2kWSV8XsPwj5zb6v2QXzQ4o1bjfaFZczw61stIM+rqCD6k0VKs+X39veK4LGi7keumDcHDtxFwb/pk92RLuE6wIEZGidG8Crw1/eFwWMAarHK0fI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OFil0Gi8; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OFil0Gi8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R8ZWtjHqRZuIA6JvG4mHDIHIRjcQUaLDNQ22Fza8zgCiuvAci/HyuH2GXLxLat9DFkXYhGZ9QQ4iixU61Abh4uIFKj79C6sVQUa8pYsHAXlcyKIQH4QXxD4v7LRxMOb98ES3tCVZe3/4oIISxjsz6ETywDvFuIrtc2679cPED2CB3H/yFWDM9CrRaq98Vmo8Nh9mPQWSFGYFkp3ivqMk2vXQu49zxE3+fZS5MaTb2iIPsXphi4RuoezNeBJB9EKTaOloU1JejCYUFRqhExrTijbRgf7F/OQR2a/KysS10GMsT/QKGVqf+Ba/Nuo+6x7hjZ+9dzdNPr5CsSjpo/y7Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TxIBmsBUoszLCXdL+8SIrDZa0JyFEXMfiO9sYN0mdFg=;
 b=ZW0oXi9VDnM4RkBXWs0yl0SaUEWkuIPAKjV3oHr5tKe2brU18hq3QI4GRkPprq74bupwb7QpmyAJD3zUMUVPozo0OQkEu0aKGwhxOORd5JjQj1rMtWocIg5odPWusjLObG/AvTQkEdD9ZszNVRW2lGgQuee2ve6T5wIgu1kEB65mk8uYbbZ2hqne1NRKH9mlD0B8ZeH91ErBoGAoq/R46AT3psSWU4C0z0jIg3h81WyYlJ8tI97Z9XKA0CL98hBuusOqA87fzVTs6mp2+A3R/FgFAjnhXpMxsbLizX+L95Y0i51LOEdyYtT+AbMWzhG+EBDosAdYbiDvCw/zmbzaJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxIBmsBUoszLCXdL+8SIrDZa0JyFEXMfiO9sYN0mdFg=;
 b=OFil0Gi8chzRqZXup2+GyIrOL330ywpiVa79KFE2Cf942j3GRwrjIstFWBpKJXCIV+dtNr23Ik0ypdXWlLV3BuIKclUFSj/f1Xgg6kWqWU2DPaiI9CjTUk04a0Ss3tdYyhHzFYz3f3th7l/S8WH9niJEXOGXeFGiKNm/Yy3lEOI=
Received: from SJ2PR07CA0017.namprd07.prod.outlook.com (2603:10b6:a03:505::17)
 by DM6PR12MB4156.namprd12.prod.outlook.com (2603:10b6:5:218::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Wed, 19 Mar
 2025 11:32:55 +0000
Received: from MWH0EPF000989EA.namprd02.prod.outlook.com
 (2603:10b6:a03:505:cafe::c1) by SJ2PR07CA0017.outlook.office365.com
 (2603:10b6:a03:505::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.33 via Frontend Transport; Wed,
 19 Mar 2025 11:32:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989EA.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Wed, 19 Mar 2025 11:32:54 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Mar
 2025 06:32:50 -0500
From: Robert Richter <rrichter@amd.com>
To: Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, "Gregory
 Price" <gourry@gourry.net>, Terry Bowman <terry.bowman@amd.com>, "Robert
 Richter" <rrichter@amd.com>, <nvdimm@lists.linux.dev>
Subject: [PATCH] libnvdimm/labels: Fix divide error in nd_label_data_init()
Date: Wed, 19 Mar 2025 12:32:14 +0100
Message-ID: <20250319113215.520902-1-rrichter@amd.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EA:EE_|DM6PR12MB4156:EE_
X-MS-Office365-Filtering-Correlation-Id: faa9c908-0a0c-440d-9111-08dd66d9ca66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IHuTOL4kthzj9sQGAZnUujhWd5TFuJhrMV68VJee+XwyQkMTJrShN3G+pT4g?=
 =?us-ascii?Q?erarGWJcjEoZBnyHO9M5JouMwSvjF44WPTQboyaxWeyhmkjLHS6EC+r73Zvg?=
 =?us-ascii?Q?+PfoX9MVa+cxlTui5KzEquq1jbQknaeeCjiizhm2gyhbpSrgG9TkL+gU1940?=
 =?us-ascii?Q?4Vkb34liHHui3Vri8yhmt1okP2WwLPvOqBox8sJqaggPGq+LnqJek9k7g/oJ?=
 =?us-ascii?Q?kj8PtFVmXba3ZtPwE20Vu0cm6+xqlk2EgLOdPWYrNhGeWRpu6B8L+GXfcsNI?=
 =?us-ascii?Q?tNG1je1donzPNktSEl0EkvxWclQRRHnWWFKh+tNFRMADpePkTZQirrePdNj8?=
 =?us-ascii?Q?etLfpVD1tGShzEMoEMoiZXRk3PWimLTXknBFEeLn486SO3FIMs9uxv+mCqDl?=
 =?us-ascii?Q?JQSgBlkBUnQ36RBXhNtSBXWd/XvRS+590prjJqusSZ4TEh7ZV2V3J4tIUJ3T?=
 =?us-ascii?Q?N3TjEmOCQ8fLB2b1oz9R5xrhxR8wgrpja9OrMExpdg4Gle6OcYEl0ZpxIpNq?=
 =?us-ascii?Q?LWKdG6dr034fUg/2nDb2ywO7+0chOQu5IuYwDckgdw5ULK3QAznemqzfIG1V?=
 =?us-ascii?Q?CihwPGWNLXaiVJR4CzJ2DDt/VZJI6FVdn0HoJFuvL5isWlK+P/XarliCBi/u?=
 =?us-ascii?Q?i9ROOwv9BqkkpO6UQsWmrd5FDIagjpAH1u7MOK6iP8wnz/gocHGCvDHIRI6v?=
 =?us-ascii?Q?X5EhM3NSYj9UfL2EE+hjejXPWjd8nAJp8/mYvsGhrVh16KyRZK37fOri1G5e?=
 =?us-ascii?Q?OsP97g70ygq9vryQ5pToAD7SuZyggnUrmGi+5Ha7SP1WX246h5v1n7RXzRxf?=
 =?us-ascii?Q?VCE66tUOxyJMvTlAJ3yTExb5sH5l17u0WuRAqKMlzVPxAFIESaa7iCW5tKfy?=
 =?us-ascii?Q?qST8zsfSHYAcTpJbmXrTiiGAdadujPM0EpWGuGgRvkykFw5xpZdp1x6FCYyz?=
 =?us-ascii?Q?LBsd2TiSBTJgJzRtFZ17gsv1NSIwRqV7I3kCODDsZUj3AjQrNjO0UhC2C0mg?=
 =?us-ascii?Q?cpK/nnC9OQuf/Gew0qwlP0wFohZmaqBDXGOUYCAD8DqopoPsVI0gIwN0erW/?=
 =?us-ascii?Q?gi95GBkUyzBVVtJfY7MYvKBuaRBH22kZx9Mng4Xkf0sz5q3mrZwbPgI885hA?=
 =?us-ascii?Q?gM02gKzjWaSwj71ouMWD2SRUYZ/0b+k7FiGgiDdJCC385tSy5TPste8KMnNM?=
 =?us-ascii?Q?BKCLu5TBF7DIz0+p0HwFlmBkZG2DsjBMbkvOWBq2Mz+xpCxQJJDLojq0xtNJ?=
 =?us-ascii?Q?pKG4kWBSq/OrcwjqNSI7So/QvIFXJrl2bPTN8mU/UupyBjnDPqThK0w+DOuV?=
 =?us-ascii?Q?6SGC4RtrnMwMRwymDZPaszTg0+NUaOKnKcUmOkiWb9/rLZZ81CIxBNbrI7NT?=
 =?us-ascii?Q?tzKUxa6SKOMG8Y1XcuDY3x0Fq94usBN2+a/F/A176KLJ5y6vbtSEkbPagIMY?=
 =?us-ascii?Q?jkk8udRN+Bp4hxHKvk1ISvrO0S01fdxSntNU5pcs2pbZ3pbOKQLR6WhzgviE?=
 =?us-ascii?Q?6uuCPq2ekR46fj8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 11:32:54.4571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: faa9c908-0a0c-440d-9111-08dd66d9ca66
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4156

If a CXL memory device returns a broken zero LSA size in its memory
device information (Identify Memory Device (Opcode 4000h), CXL
spec. 3.1, 8.2.9.9.1.1), a divide error occurs in the libnvdimm
driver:

 Oops: divide error: 0000 [#1] PREEMPT SMP NOPTI
 RIP: 0010:nd_label_data_init+0x10e/0x800 [libnvdimm]

Code and flow:

1) CXL Command 4000h returns LSA size = 0,
2) config_size is assigned to zero LSA size (CXL pmem driver):

drivers/cxl/pmem.c:             .config_size = mds->lsa_size,

3) max_xfer is set to zero (nvdimm driver):

drivers/nvdimm/label.c: max_xfer = min_t(size_t, ndd->nsarea.max_xfer, config_size);
drivers/nvdimm/label.c: if (read_size < max_xfer) {
drivers/nvdimm/label.c-         /* trim waste */

4) DIV_ROUND_UP() causes division by zero:

drivers/nvdimm/label.c:         max_xfer -= ((max_xfer - 1) - (config_size - 1) % max_xfer) /
drivers/nvdimm/label.c:                     DIV_ROUND_UP(config_size, max_xfer);
drivers/nvdimm/label.c-         /* make certain we read indexes in exactly 1 read */
drivers/nvdimm/label.c:         if (max_xfer < read_size)
drivers/nvdimm/label.c:                 max_xfer = read_size;
drivers/nvdimm/label.c- }

Fix this by checking the config size parameter by extending an
existing check.

Signed-off-by: Robert Richter <rrichter@amd.com>
---
 drivers/nvdimm/label.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 082253a3a956..04f4a049599a 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -442,7 +442,8 @@ int nd_label_data_init(struct nvdimm_drvdata *ndd)
 	if (ndd->data)
 		return 0;
 
-	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0) {
+	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0 ||
+	    ndd->nsarea.config_size == 0) {
 		dev_dbg(ndd->dev, "failed to init config data area: (%u:%u)\n",
 			ndd->nsarea.max_xfer, ndd->nsarea.config_size);
 		return -ENXIO;
-- 
2.39.5

