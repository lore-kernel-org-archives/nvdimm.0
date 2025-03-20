Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4151D5144
	for <nvdimm@lists.linux.dev>; Thu, 20 Mar 2025 11:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742469764; cv=fail; b=AIFDyDX+b48RFdTrY6iKwHsJwS5zDGrOWrsPra7GFMm0bWwdlCL39+v7KyK41ctApUnqBu3eShTO1FzMusAmAlu5n67Kt8HxKWRtuv8zxbtZ4AMiXn7BOp3fMBiSZ21zhc8997iPhhl8dWAWdHHY6ejVr+kK91LOwqpivaukNmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742469764; c=relaxed/simple;
	bh=Km1LncM0+4Ui7FNmLwv3fSi3RA0UI1OMWEMh1F9nYEo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sipTnFniqzIElK+0MTxcFNkZ0pvW90TT70+NFHZSwUQ7NizXx1wr4fFZeAX5z8xkISnvuKdRNI14ySsxqEVShnLR+YrLqPyz+8XS/6uakFyrd57SxIhFvTlcuvBcUr4zsFi3K+PTnzctsyU3GJxkDoUwhAzU8hE/PtGOwZOPvP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hLxoDFdD; arc=fail smtp.client-ip=40.107.93.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hLxoDFdD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IOOdK4AO4q6aTh1PzKzvWYb+H3d3823U4J8SPF/rqzA7/b8tij+hi8G/frvIXBLzX2kHHFERuavv/pa0NgRDSlvtWIu/EX/QL3pdZbLf7CnrzEnTbv+QPvVjZx+vA2IEzu4axF6y1DNyD4PraVGRP3pz5ElhghNr6xAp+ZPotwyithjJhD9GVE7F3RbtUP/7IKP53IeqrAJXbyC0ZfUO+M4cdoyAMEuPE1ohNvcN9JsLi5sutwF0OBObgyudsK9dobzvkxLFwYWSrECG6kDj7P2M8QZMy8dsG3dM7IzyuznImwbP2hg8cd+7puuFXaRC3Rtrb737pYnYm5ksp3TXTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QP1ZzqNrLwtYyNmyyrVc6yukQK6DnxNqv7HSo/xGRYk=;
 b=bC0gKZ5eZEQBzp1PikaOaT/3krWyVHMtCJnxZr9elmvZVibV9mGgyVnLYlJm9cBzGlaufHzL8zvG3Me22/wkbU8P4wOd0K5VlWP+lQWxzLjaJD1VU65CByPlOToyd1iUakkWZf5BytS2F9xSFrXkMivWY+yo/R3NnwXC8WHoCdWQNsSlEcT+riBe3gGnn4yto3wLD6n5Pg4tofk2k8cqyPukZkSnim/5BNpfEmOSVsXZhpia3+Yq2HI9sSLK1HsiDN7KGadB4llnWZj215y0ch4WGLkEQi0/r42Mb0Z/qV2Zye3GigB0gdbJB6UX/ISWEJ5nLhO583wLhSW/VcIWyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QP1ZzqNrLwtYyNmyyrVc6yukQK6DnxNqv7HSo/xGRYk=;
 b=hLxoDFdDwVVXwj1V8DaqGgs7jQAmtYTZ4ua/BEPGwZS00Gs0Dzjdesyw+DrypP5TPNLtVVKj9JVWpg6xPfC46vKDv6uP9eddPbZTlzjo2+3ZFsDNvy6a+IAJ2FAeZp5olrsmKDgQ7LbF9aT9hjBIGYqZ8esALJc4bm+7F80FHGg=
Received: from BYAPR21CA0005.namprd21.prod.outlook.com (2603:10b6:a03:114::15)
 by MW4PR12MB6780.namprd12.prod.outlook.com (2603:10b6:303:20e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Thu, 20 Mar
 2025 11:22:39 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:a03:114:cafe::ca) by BYAPR21CA0005.outlook.office365.com
 (2603:10b6:a03:114::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8583.9 via Frontend Transport; Thu,
 20 Mar 2025 11:22:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Thu, 20 Mar 2025 11:22:39 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 20 Mar
 2025 06:22:36 -0500
From: Robert Richter <rrichter@amd.com>
To: Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
CC: Alison Schofield <alison.schofield@intel.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, "Gregory
 Price" <gourry@gourry.net>, Terry Bowman <terry.bowman@amd.com>, "Robert
 Richter" <rrichter@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	<nvdimm@lists.linux.dev>
Subject: [PATCH v2] libnvdimm/labels: Fix divide error in nd_label_data_init()
Date: Thu, 20 Mar 2025 12:22:22 +0100
Message-ID: <20250320112223.608320-1-rrichter@amd.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|MW4PR12MB6780:EE_
X-MS-Office365-Filtering-Correlation-Id: 31734f59-9c0c-44b8-d652-08dd67a18652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bSPy4SAevFeZMtdAJAu8TRzL59sAxt55Iyd0Unl40LBiJkZIQ3BpKk5C2VbA?=
 =?us-ascii?Q?8iCCC5uxSYeffpUKUyr1MCQyCBQRKkCuJ/dpG8btyVHaHnCbjmlVK6OJohFt?=
 =?us-ascii?Q?doNBgUYzP887fTt3Dtl4ahJUC++1aLvDes8Ei3NrPjwd5X55OVthba7ywn2G?=
 =?us-ascii?Q?Scvzz4GtWrOFCyQgtXb23sPfLaW8gZz8VyTE7ryw789nExFXTE/OIMEgbfhW?=
 =?us-ascii?Q?Jl2/m/XpCj7J1bSe9NvePYU37PP8RiZxFyemgEwfXG9gg8MrenXmHckr7RDZ?=
 =?us-ascii?Q?fUIw3tSHrUxr+yqu7neqGjn1tLsJZmC5qm3Du8xBbCK66CRg2wEDunU7TD7D?=
 =?us-ascii?Q?ofo+dKCeQ96JLk9wlMsi5TBHCUSMiAhKufyU57CUkGp/ZlvoG//VUW/J1jWt?=
 =?us-ascii?Q?NU2pjij1y9IpfKf+qwWXlzodM+aAvxp1kaQ+l469vAxJjwQ+yRh5wYJ2yPDB?=
 =?us-ascii?Q?f3AkRlRGdvq4H69aDqFV3wn2090tQ2U4yLu1hK3FK3DRhZk7RSGz4+ePjC07?=
 =?us-ascii?Q?ElPnnZyDoeKq6o8Z4vr+TBjh0Zfu2I6voU6sDpbb+e0mUXXw/41mx49NwQPQ?=
 =?us-ascii?Q?DlJITPLMCvvVILhldf88AeVlyZ8zeexfz5Re1n4151EcOROQWkKR8k08fT7k?=
 =?us-ascii?Q?/se6b51v4StvQgAXLy7e8L98ZRYBKE3Mt2VNosjKlY7WBtNJScwbkB4j7oBZ?=
 =?us-ascii?Q?xIAxf2+UV1yk2cKZ23EyY67shotsfn4fxwjkcM57b2njkkNSRYlevOwExMuE?=
 =?us-ascii?Q?iLVJkH1aD6gTi6IV5C1iUs9xEhcB1DGkNxLjQDMmczf1uZTItF+1CVsQf4p1?=
 =?us-ascii?Q?aYIra7ZMSSaDkoytc1B9/VpUe94OU7iR28OaOLeuzLVErs9P0xHSCjFRy+FV?=
 =?us-ascii?Q?ukTT/GxSkxCz6T9FdhmnJ1PElBbK9QeD427x3nD5+FhuKmMOI9ETMRlslruc?=
 =?us-ascii?Q?bqaS4kq9h61Y+pdsltF8bJOwc83NLw0drFYOp36JcoZFls9FgAUeqAaMUGoy?=
 =?us-ascii?Q?RYy/+/L+Mhr7cAnnX5eAJqPwn5Jl8JcO1L221/J6IoC/gXqQjdMyiKrL3uSB?=
 =?us-ascii?Q?Rk7yrgX12Pd8dXgvlk+CE3UZU0kuvHoFuuQV3i2P3cqMwGPQ64KoaiBD3XpN?=
 =?us-ascii?Q?QmtYHPNuA5zPJpbxUi9zYlgKjJ4AAqY8/5YYdY204tsjuxPipPAkzaKN1Etg?=
 =?us-ascii?Q?p2/3EyUiRYF0V3KTjp244fDx09d8yB9n+6zxrdf8um+tYvI0HmL1XXoQwaLh?=
 =?us-ascii?Q?Gj34EN2xRYYsbBov7qkMkFVjwFwXEcUyRDi/MVU5ZuV/2jTCjNnWaHSk4LqS?=
 =?us-ascii?Q?gS6LoPBS1oMQgU5srkWHS8g2EjOD/jn/GT4Naq+JLIfOcnm95d2GRphimQU1?=
 =?us-ascii?Q?CypqTf5sDjV+bb7rgPST1amJY/yv76fZJ5lpEMucI4mo4BCRaTXsnNfp9/6D?=
 =?us-ascii?Q?qIuhwlZZ8Spl3gXBhoMM1Wyig2FQW9b05EPFsqObYk+jvLbCrZxi7Q/8UwTG?=
 =?us-ascii?Q?q57xEevc2gYRO7Y=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 11:22:39.6199
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31734f59-9c0c-44b8-d652-08dd67a18652
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6780

If a faulty CXL memory device returns a broken zero LSA size in its
memory device information (Identify Memory Device (Opcode 4000h), CXL
spec. 3.1, 8.2.9.9.1.1), a divide error occurs in the libnvdimm
driver:

 Oops: divide error: 0000 [#1] PREEMPT SMP NOPTI
 RIP: 0010:nd_label_data_init+0x10e/0x800 [libnvdimm]

Code and flow:

1) CXL Command 4000h returns LSA size = 0
2) config_size is assigned to zero LSA size (CXL pmem driver):

drivers/cxl/pmem.c:             .config_size = mds->lsa_size,

3) max_xfer is set to zero (nvdimm driver):

drivers/nvdimm/label.c: max_xfer = min_t(size_t, ndd->nsarea.max_xfer, config_size);

4) A subsequent DIV_ROUND_UP() causes a division by zero:

drivers/nvdimm/label.c: /* Make our initial read size a multiple of max_xfer size */
drivers/nvdimm/label.c: read_size = min(DIV_ROUND_UP(read_size, max_xfer) * max_xfer,
drivers/nvdimm/label.c-                 config_size);

Fix this by checking the config size parameter by extending an
existing check.

Signed-off-by: Robert Richter <rrichter@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
v2:
 * modified description to correct the instruction that is causing
   the div by zero (Ira)
 * updated tags
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

