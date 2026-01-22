Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012022.outbound.protection.outlook.com [52.101.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D72437FF78
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 04:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769057765; cv=fail; b=sP99CNoZsKNLD9jIcuwzV5lTXbHXy95KgRDoe/ohIWi7NaICh9DRZ3U7dlE+AxjZAuLK/kcud8l93Hl5f+Zt2J5Zau25sZRwODZg2tWUbRO87stwtXohMUl9boxX+vBE0f//gsnLEsTofrdkMdrLg5VRufvM7zzVK4f6zr4gqrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769057765; c=relaxed/simple;
	bh=afm89nDm4ASpDn6xKbaTlecdTrAazzhCD+AKSgYyG30=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h6OiJAAT7m6OlWcsfwPektIRKyWb0m19+IxKfH4CRGaXh95J2meJWgMXTqIYTuEW26kEBxcR5im19J34TjKyd4aO+FXj94kxzxssbWBBpdMzK+jcSJByequSBaWjBCwVgHfTRvuEXC/EanV43gf/ya54mf3bQAi+6SuSCbhKeIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=R4ExrHqa; arc=fail smtp.client-ip=52.101.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="R4ExrHqa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LdpZdrVwLYTg83mdLqws/RTnHNbaNjZ8IRNRJp+vG/DuDYS/aGZkm1oSniknnJPlwHl54OIZ/3ubCDWncgVQLzks3pV4jncmptDPRUjATF7Bmrviycqpnn4KWg2O4Gn79Wdq8lgemvRvpNt1BSOZZgxPkcDqK6EEnPdGLdkV0H1i6dUZMIJ3RRD12r3pPnsn2CUn7padJReVB4GTexjhiZfFL9g4qnyGLIphfixeyOOxJ3y5jl6GrRxcNSwXTBflErwZUwiFVW8YXakdOi2SF+muOAvoU9pPOXmkl/mBzLzow9s0ikPDCSTKXedrj6ixzrtxWee4GfmrPbaPBDTuJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D+WsW5g+KUeSkdt26Tbmpdm7Zd1kpnUtVCJ+GLDEtYY=;
 b=djz6A5dCk1+l1gfa44+A6paHpZcXJe5sM3TBD70Luvz0ZUUV9X4mEY+CVp43zf0sqRYGiovWNYbrEJ6EG1GNnI9tH6QKWPLbsG+AXo88/qX1rC4LAPrcwnXie9Qv2dgBLYK9g+IgOWbTEZJJ2TEibxscb6bVCC81Zem0V+RSu5DoleFoFQtbm7UqH8/T30F52whOB8WMjb3+kNSI91Fsu8fgHgpdGStWaZ+e0aeCS0FLr7YiLDQHx8in8m4hnlMINw0DiLux98lpJaC6W8p8NXYs95S1CYgQcJKdBP+0oXLs3bopgeuTkU2bpb5Rgw3YfTUEqZ7+teyrj+NWNuwe6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+WsW5g+KUeSkdt26Tbmpdm7Zd1kpnUtVCJ+GLDEtYY=;
 b=R4ExrHqaVkaO9UfdDdf64JTY9i93nZjSdh8+YZXzwtmDQgv/n0dJiaV33IxtewMo2ew8RnBiquJSwf0cl4FzXDwj7MrQn1EuvlIb+shW+tbR+MmkOwg1Ovglt4zKOnwSIOcuOJUBXcAvKGvWK2e0yN04PK7nMOTIxR7aPurVTpY=
Received: from DS7PR05CA0096.namprd05.prod.outlook.com (2603:10b6:8:56::28) by
 DS7PR12MB5933.namprd12.prod.outlook.com (2603:10b6:8:7c::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.9; Thu, 22 Jan 2026 04:55:57 +0000
Received: from DS3PEPF000099E2.namprd04.prod.outlook.com
 (2603:10b6:8:56:cafe::c0) by DS7PR05CA0096.outlook.office365.com
 (2603:10b6:8:56::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via Frontend Transport; Thu,
 22 Jan 2026 04:55:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF000099E2.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Thu, 22 Jan 2026 04:55:57 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 22:55:56 -0600
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
Subject: [PATCH v5 3/7] cxl/region: Skip decoder reset on detach for autodiscovered regions
Date: Thu, 22 Jan 2026 04:55:39 +0000
Message-ID: <20260122045543.218194-4-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260122045543.218194-1-Smita.KoralahalliChannabasappa@amd.com>
References: <20260122045543.218194-1-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E2:EE_|DS7PR12MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 08039bb7-05bc-4596-77a4-08de59728837
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Qsa1uZ9iC/pSNlN3WwiUO+P5cINCTj+7h5FIcFvZnm/rX0CKxQNi3YCYTkdH?=
 =?us-ascii?Q?gLSuQppnqKZCx+Aot5+jRVdADi7Mwhm4V4Po0QIPrANeYqgEqD3O7mK5Odjj?=
 =?us-ascii?Q?uC7ppFdBlrFYBAbl8i4wVtUDH+WGAiy53eDB6vXcw9Yul6qTnpS+UQR6ciGQ?=
 =?us-ascii?Q?nvYCSawTd0LqIfDfLQmBSmou19hjbtoOSmkvCqWQx5kZSUUeq+YLl4S58tLb?=
 =?us-ascii?Q?djAQv0kmWcycPW8V6a4XPsxPsHvn+pEXt1vlLEavizWitPhpkpo2kB1NNJE5?=
 =?us-ascii?Q?/toVh4MI00sZr/0I0ct98Ac/hnzgSIQm2HgJTW6CWS8g5431PWtfgOLT7Q08?=
 =?us-ascii?Q?lAb64DZ0zHnpfebCfj5rE5PN0iT3Doum987HiQX5fSsXaeAN0prOhHaU4CHJ?=
 =?us-ascii?Q?a1O+LPrj3ad1mK6ofv3ANRSC25Wctwng0iyA8NhUhPPgu3l2BHM+kcfq6EeW?=
 =?us-ascii?Q?sApv+UdMiQTUE0jkU0jKakgGKITas9HYF4fu3ZNsfqE7V+1PI5qX0V+nxA70?=
 =?us-ascii?Q?20AIWCYRRX6ws/eOcXzhpUkpKOjBZ8/VtP9CktQkzaTFxAgqZqyCs16h+fgQ?=
 =?us-ascii?Q?Os6dPdg2GYb/VG0HDOcbT2NPpc/kOk2wbpqQ0Iu5MgbHAVNI2D6hOqkAru7X?=
 =?us-ascii?Q?sRjZHiS2U3i3ti1VC9/E88F8j4KQh3TBWEfCTsZKpwpIIxGBNbibLPpswecO?=
 =?us-ascii?Q?eU0mjZy4XKw1KL4so//01OrBE1RYIYDw3mCaWSAhR3OfiYlmtPp0kUOqQbhl?=
 =?us-ascii?Q?LDHApxj6Cfn/ekmAnJS2ChJnx+g7XwV2nd+YxZRQKlNmFIXnDy4d+A0llVvP?=
 =?us-ascii?Q?maEjS/6oi/rW6HGbFyxApUBZIldeLHJqSkXtugTtXfibVee0OrfrkBZwka7E?=
 =?us-ascii?Q?8u5Xj9wxwYNrdWHinnPSGHkcVLsUH8mhN7lSsEtARdCfoWLkKFFO//GlKkxy?=
 =?us-ascii?Q?MT3A4DoUsFGduznae8RQ3qcFcDEhiDVydhC2SLR9sk7bcVgxLXQUwI/oyPkT?=
 =?us-ascii?Q?76vEcoW+DlPXQFcIOlVfjlP8xZvSPz/1aj34Oib6Zn/1jLSdbguB+ZaapIEp?=
 =?us-ascii?Q?hVeSZljwus3ZvJ2xUrc3ZcG5kRuHMWkmnGx5cOpej2XY+SWP19qxeWY7rt3S?=
 =?us-ascii?Q?/DCY5mHarCyCwPyikVNxXITl6/lXgRsghklbQwakFs7y/83zoQ2H8ZgsOho3?=
 =?us-ascii?Q?fbXyPtV1/deEg+zM4kQaN6oMXSGGuaFMIwQOkO/DDQUqeP9ATDCloL8P4V72?=
 =?us-ascii?Q?L/sclnuPYX3aRDBV9bI82izxUudAPIbxdQvrg0NvuqewACSvSoCL72EX12XB?=
 =?us-ascii?Q?tgS0IEnRx16MDxtMRPgVZo/4dAQknjNWHakZhBaBaXSJBF7uNuMqoNDy0C+G?=
 =?us-ascii?Q?3PoPKfpeM6CwHFFJOve9ZeutCUIKM+NN1KXqRmMJ2Gz4z4Ksw6Of1Cdztn5j?=
 =?us-ascii?Q?QQSIwnIWBPomcd6UFgc3vGpw1wfUUvsc5vk9noU5GYGx7dqyNkI57LuNOCFR?=
 =?us-ascii?Q?bFZhqdrUBVPFjruESM1IKZ7F9v0dDT0l7Dbf/VZHgzamNsLGiuqJPVzd1EeL?=
 =?us-ascii?Q?MTpnneTvMtvwq0WNCd2Z63M8W7G/a/uBzcht2UyszfOu/dmzlsqlIB3Y5lcL?=
 =?us-ascii?Q?q0D8wkiDZtTFtPi/71M6U/v0oIn78ssZGe5YvWPsuX9AjXVH/J0GxXJV3F+Y?=
 =?us-ascii?Q?1XKdAQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 04:55:57.9187
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08039bb7-05bc-4596-77a4-08de59728837
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5933

__cxl_decoder_detach() currently resets decoder programming whenever a
region is detached if cxl_config_state is beyond CXL_CONFIG_ACTIVE. For
autodiscovered regions, this can incorrectly tear down decoder state
that may be relied upon by other consumers or by subsequent ownership
decisions.

Skip cxl_region_decode_reset() during detach when CXL_REGION_F_AUTO is
set.

Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
---
 drivers/cxl/core/region.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index ae899f68551f..45ee598daf95 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2178,7 +2178,9 @@ __cxl_decoder_detach(struct cxl_region *cxlr,
 		cxled->part = -1;
 
 	if (p->state > CXL_CONFIG_ACTIVE) {
-		cxl_region_decode_reset(cxlr, p->interleave_ways);
+		if (!test_bit(CXL_REGION_F_AUTO, &cxlr->flags))
+			cxl_region_decode_reset(cxlr, p->interleave_ways);
+
 		p->state = CXL_CONFIG_ACTIVE;
 	}
 
-- 
2.17.1

