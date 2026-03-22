Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012051.outbound.protection.outlook.com [52.101.53.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27B137F000
	for <nvdimm@lists.linux.dev>; Sun, 22 Mar 2026 19:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774209248; cv=fail; b=SNXN0i87kRjNv38HsXZV5AVeZMOoV2AbM3Hjf1bUiSPoctjiXfvJnPRNDkixMQaI2GbWTamtGZnS5MqPVe/YgL4xuiALKRsXMXdasMnAHl6xDIjif4SkkDkTYdY5S5yHRKr1fy1LYzjXPuud5JX46qOujQRf+7vdr/0SIS68VJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774209248; c=relaxed/simple;
	bh=1Xe6cqFQcQEPk9MQAEJKowlFr+ZwsmkxlTAJbjwH6G0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZKVTG/+2AtnCnUmtPNBjp6CQY6/or/IrwRbXyMb7ca649pIsyL9ftm72qEaVRC5akx7FfgP31KfBGJg+ttf0rKsU/jspbqfmH+HVD+wHu97FG8fegh93lv5GXNxBGv1SntpjXDRlMi73phiuGghhJUh7DzWoJjK2rUFqokMWWns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ewnAvxCe; arc=fail smtp.client-ip=52.101.53.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ewnAvxCe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lcDGNEE8nd9pbGSOcg/efOPiypoHsGrsua+v/rGMWCGy6B8LfjnHVr8AeW+6Y+F9DExMnGxWCtHn2NTxdkHa0WnZ+XHxO0Ns8KTBgbvY/h0uj4hUToNiulJX1SnYGC/IJtG45M5CDP8WPVpUg1LnbzgKvJ/pPdkrphEOgdfnauiPsn2numO1Cct9QS0LYEHwaONfLjktxIOscx9bU1aH0+BHhphI2wxT8PCtYrIUiNZH7dnwLX0c/z9OYk8fupVPf659bhDywGgNZium52j7yLMTSqNElzB75yRNCPvdyQJ3ADb5iLVFkM8uPpzOFxc8LTULbZsgU8q501SOsF7ArQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xBd3/vIjfU7Iyxj2xdR3/qXW4REcQtA8DRXmy3IlufI=;
 b=eMnFP5pWeZ03txkgzLTYjvBo0983TMevzbgYVtQnHwQAJY9E7eS8dd8zaVInONXLw0SbAT+cy5InhYda4Jc0GwTG/QYJ3TA5OvlIpQ/F6Zi9a/Rd2Z43VF8E9+RlEUbv/x9c+ZkI89IP3AKyy3uIBzeLuXCqRzG+1+kLhvcUn9KErQf2nOCfNu1FZmopDu82Kdx08HZJlEUvkHNolQNTCEp6V3igxOP5rP36Px/KUbqhD8Uy1WyUpUC+Qg7UQYZp5sojrBO2qHt1fPYfUK4qhMv9uVlyWPkeeoN1j6X1eMCvtc5L9x52EJnxenXp4pCl6Z+En0iQR2cBax0hs8VNnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBd3/vIjfU7Iyxj2xdR3/qXW4REcQtA8DRXmy3IlufI=;
 b=ewnAvxCecXkoaSqj5Q24GYnhP4ePR095+WGBUdCVnhlgie6sbJ/z7TOoOvvgIhGFe0LdAaS4iiwbzDE6qx1cXiF348vx07/ptOtfmFJ0FrLO1zUkfo4mGqgWDFE9Vgeb9xMcZb5WJFNhIN7SKPB9pFgf7WibSn5UEqAqAwKrnyo=
Received: from CH0P221CA0003.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::7)
 by SJ0PR12MB7007.namprd12.prod.outlook.com (2603:10b6:a03:486::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.15; Sun, 22 Mar
 2026 19:54:00 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:610:11c:cafe::2f) by CH0P221CA0003.outlook.office365.com
 (2603:10b6:610:11c::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.29 via Frontend Transport; Sun,
 22 Mar 2026 19:53:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Sun, 22 Mar 2026 19:53:59 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 22 Mar
 2026 14:53:58 -0500
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
Subject: [PATCH v8 6/9] dax: Track all dax_region allocations under a global resource tree
Date: Sun, 22 Mar 2026 19:53:39 +0000
Message-ID: <20260322195343.206900-7-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|SJ0PR12MB7007:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ae48706-779c-405b-0d14-08de884cc2aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|7416014|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	M4qONq5P1pnYU2lmNVDi8D7oMH8PCPuwTm+IBxv3HF/FYrXbX1g6Tm3ZDsQA5iHvLlBMFGI0VWnPqkxG38lzqsL6/Tiiug9zlxLdWCW5A7qpUlDUSuwTtPWfr5oGg7XKZGFu+Aly+PPTt00PUb2aONEuHaXAvY47GNa9II713UwPIGWAluc9r4x/KgVS0SqF1gu7uKjqWeiXmkr+sZGlbki0CYH992evuflgPGc9PP7RrqKuqRQCBIzilQ1iazs/uNk2AMIsO+/vTndKukQZqMW/kKfWcnZm5q0C2eT8OULkShsmIEM9bmhjgxpNCmBeEWdHnrXjLGv4MCJCv2dqovGSzEU6xBO+j/qdcCpCbGHD9MaAjc0+TXqIVz303XTAWRv8snf/HjJgyMBxWL4uVM75OnH26I+Vm9s8Il0z41muJpqwuN+F9X8lD4dbnCr50fgHQbB/6klJJQvq7wzsk7QvJP/UBKxAk+4pWdL/zqtdNDPwHp8NTeg9LWhpTUw2ZGF8BUm8wPYKep/dTqBMlB3dna3opuGoo0n5fe9so4RsfuNzXYP74z0wgHWdnsJ4LbfzEehl7O+YDVF+atLrtH3pkJ+W6mdIVGzsmPXp5OjXrlBp3j++8gc4Bh2194QoCvFYb9esCxMDrQzDcNa4QHc5TruAdMhckd0mNh81Ky9uXBM6krvbq3mnoAsBJmcDNhKF/9I9oELduOKb0m1jlAgewhBFBt2CKk+48u3vW/s5yr825eUCTvdVlLKn/rNm4zZYTeCSh6yPGu7O+CoM2w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	h0UAcsauoRnItGTVl6H7S0pMnL28f9ppTOcxCzgbnXks9tJerqnHBWXu6yrBKLlAv2ygdF402JU0AxQEZ4XMVwimKzIy9iA6EqldkXdnups/wCLKNPxEvxjAANXcYIR6wCd0i7hf9L+Wb+XyRW1Svb00UeNTD0wXsmGGkx4AyVAn6hMsBurPEWv1YQQHvY02Dc870n6H4xyXYItYGrzYAhjlcAOFLsK0zuUHCkvKPrWVJvXrg1nQpvd+vYcQ5gjV/i/eVgNZ+vQtnNHjPqmxXZBINMSLFbw+gsZOWChXDwiZ20WSCcTlOPwa1+ebNu+DbG2hEbwJkc+vIfo3Y05qUylzheC53Ztx2qgErxD7xIrO5e4i8QVK8FP5isdKVrWG4QeUD4gdxpglO+sly8/5Qto/C+xVPXHDZeqvuV7LEvAprhCwJxWS3wu6dNvNkfGT
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2026 19:53:59.7269
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ae48706-779c-405b-0d14-08de884cc2aa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7007

Introduce a global "DAX Regions" resource root and register each
dax_region->res under it via request_resource(). Release the resource on
dax_region teardown.

By enforcing a single global namespace for dax_region allocations, this
ensures only one of dax_hmem or dax_cxl can successfully register a
dax_region for a given range.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 drivers/dax/bus.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 299134c9b294..68437c05e21d 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -10,6 +10,7 @@
 #include "dax-private.h"
 #include "bus.h"
 
+static struct resource dax_regions = DEFINE_RES_MEM_NAMED(0, -1, "DAX Regions");
 static DEFINE_MUTEX(dax_bus_lock);
 
 /*
@@ -627,6 +628,7 @@ static void dax_region_unregister(void *region)
 
 	sysfs_remove_groups(&dax_region->dev->kobj,
 			dax_region_attribute_groups);
+	release_resource(&dax_region->res);
 	dax_region_put(dax_region);
 }
 
@@ -635,6 +637,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		unsigned long flags)
 {
 	struct dax_region *dax_region;
+	int rc;
 
 	/*
 	 * The DAX core assumes that it can store its private data in
@@ -667,14 +670,25 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		.flags = IORESOURCE_MEM | flags,
 	};
 
-	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
-		dax_region_put(dax_region);
-		return NULL;
+	rc = request_resource(&dax_regions, &dax_region->res);
+	if (rc) {
+		dev_dbg(parent, "dax_region resource conflict for %pR\n",
+			&dax_region->res);
+		goto err_res;
 	}
 
+	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups))
+		goto err_sysfs;
+
 	if (devm_add_action_or_reset(parent, dax_region_unregister, dax_region))
 		return NULL;
 	return dax_region;
+
+err_sysfs:
+	release_resource(&dax_region->res);
+err_res:
+	dax_region_put(dax_region);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);
 
-- 
2.17.1

