Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010044.outbound.protection.outlook.com [52.101.85.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630691F4CB3
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773882929; cv=fail; b=VLW4I1MAMm1lym8CRRsBdhtbxAOisZ7JdHF3inwnE/YkC9OIazRjSUe3sGjnPESn3Vdg5hS8h/SACTFRY0WE7HKumOw4rQb/EP2yXU/DhWZv6aT2SHFfwxYoyBnQOi85NBeqFsgBJXEdQKAwlyIHShrA8RBZ4xVU3i/FMbOXRQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773882929; c=relaxed/simple;
	bh=xN7OnDcU64g2Htoiba7oZYi+s9i+z0+6Oexr5FsaDpY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W9RdMK8G3Q2pv+gUQWf7IMCXPDRzWtzAX3vUg9FsYyNgFFI4pRuCuf9Nm5DXQDUe5qXLirD5ekzDRDWSg5UmarMeRkQFeqhYI4fdbK1Lirbw6vHumXGMeVlZu/FDn6KqzO82Bek51rQwduZT8xAIUYI82J+DH1tKz1pUCHq1VPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NC/vXdWO; arc=fail smtp.client-ip=52.101.85.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NC/vXdWO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Plv2z0nnzUHd1q+N4j1NAlwqJe004XIp7QGiK8aYkFZeQB5bctHneSCG7qJyoVHEkughVE80TVujTyhKV0mv6ObmoMWMzqGCngDAyNeosHaZatNea3sBfIyxYOXuXhJoGdqbs12Gx42e2PXN4gx/Htr205CC07jjtSr0jFzU5NAUGf6iLdIReZXy9lsoqGiQsQrR2+EYeFQX8NFBRoyepE0OAZEA4+fXKDnH06UCdZ9jgHrRksQuDv5AaoWPmTTiOOrJAR3sZhZNT6mn7Dlm/+0mS0XNYoNwOPsbVBb0QHdEMw91jWqwnNEOL8M82TR0BbD6xMX/VNG3D/JuJlRKng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FrCV9HOXBam/sXSxJNQkXdCA1MPqyk+1k+L4Ha43EmI=;
 b=O1HUpCavZjkLlrhEeZ62Nby1QuW14GrkiP88OktbD+l4nHkuL+duSzvkUelcGZjKsLlqO8S67k91qL9sUNfd2VC27L2xxprBgtOJfmUI3K7fe7Ms0k8RL2ZA9aYKW0VH4c5QzdWKX5TCX4toBbI9zExfJepmUMYupoFM3OHOW1nMPN05Qmr4FCJRUO+mO14/0SUYdJ51TXT/bTRwQp1ee/LzoGNZPWel/3rxkXPj1b2QEZtShBZl6sFbtrscTXa6+LWnlDN04PTQw8TMIp+e/S6Y4n2vrvewB/tjumeLbO9UYufxUFPEErsV5i2c370AztG4AWpG117ts3RIxjSuiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FrCV9HOXBam/sXSxJNQkXdCA1MPqyk+1k+L4Ha43EmI=;
 b=NC/vXdWO1OBBGROhSNIRJWng2NqLj/fc4jRIzJTQbxed658yaCgZC72e/LdFe/4JOxcOpT1DUuyz/4bR3sA4XeK+eDMrQUq5wonrsWyL+2Tv5xUmE7yyAi1FXmbTC8qJ+nf/uAzWmg3XGAYkuHq4I/7f45MkwxIdPoXVC15Hws8=
Received: from SJ0PR03CA0371.namprd03.prod.outlook.com (2603:10b6:a03:3a1::16)
 by MW6PR12MB8759.namprd12.prod.outlook.com (2603:10b6:303:243::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Thu, 19 Mar
 2026 01:15:19 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::51) by SJ0PR03CA0371.outlook.office365.com
 (2603:10b6:a03:3a1::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 01:15:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Thu, 19 Mar 2026 01:15:19 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Mar
 2026 20:15:18 -0500
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
Subject: [PATCH v7 4/7] dax: Track all dax_region allocations under a global resource tree
Date: Thu, 19 Mar 2026 01:14:57 +0000
Message-ID: <20260319011500.241426-5-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|MW6PR12MB8759:EE_
X-MS-Office365-Filtering-Correlation-Id: a4ddbffc-5981-4e37-a379-08de8554fcb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	b/7XAG76WDEQVPu7Qik+02NiIcrGhdkLnEeYs0s6C1oIqT6/e9mMmIiYDO9BZm8GhanU3Dg4MexwxX7SbQd0UPTH32yFRJ8hBvf/V8rBAdEWvS0elkoT4ZYEk4HP8G/Vb5sPBSALapaLlAm0qETEBd50Q3IIzMUD+XJ3/C+hvH6cdgvKpZxKmrYHyD6oX0LZ+Z4MSIQSinnxOFArJNVR+QcWd57Sr8URGYfgQdXYUUW4/PTfWPKKCUpAOXyCmcWSfOrfHiGZc0g8M9+zW7BN9RL7WHcJndRaWel6g8qxc/HH6r8R75XqUGuWlJM/9GV1PBwjR1b+trNqGbhCoPXvJN/zPPVudUUE/f57pY05uj5BPvoIdkVN4YdQCFTG4F1y7Lx5wCuc3j0EKBAWvikegnioc2gsZJWqoR7UMtgmYtTXVBQ08CZldWOQkziVPwGLaDuH/uE1rWZIrLASQh7tn7yePYdTXPEci4Jkwcbhls264GH5IZETpUOGb4uJjdKDiN37QsM3GzAw7/Mgj/N7mMRAQAk6U1uhgUzXrxp4rt+b/jMhCHIRwyQTBS6ZYmY/mNCzt2uS2PsN1bBwyvnYALCQRzH+jgxw7dCjuScAipOduTJGpIbgrZ7sgc2t9+vHk1SWXxGSfOZyjuGsCp2h+o6oBigOIt50XcxNOT/676grY9j0o3trrLCgfYYlXT2S9B2lIWWnPECn7Crv0a9zrCqQJzKxUBpELTfBNzQIvuFO8rNVjRSXXAwrC54DMh1uvD8OGKuRNLP0giUH8KUepg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JeCOHLyZ6pdGw6U5oph9VSJ9QS/U9NG4GfWW7ZL7x11HYEaq7AciKuZNibdZcQeXX41nMX5ZKQriKoom5tPFkTKhPdqOnzMQ0SSIKFKM3xJiWWRXRqR6REyHj9gnrK/SVnLWBdwh8jXIQ23mKlKxfbsg8YWB3iD88MwmSIujs+mIDi5Av3ldDr4mzw2R3dadwoPQ+tODXnVjdeCT467zINpalXqAxxmT6P5UEVVy2WABiQ52uQJ9bEvLZw0wOF4IWZ8cEUQJsRADcE6uWbAJd9ZgSdPBJnKPsmgKobk50L+L+7GJnT8qQhmt0Dhxj99BWgzeSRT4MHM8yHVBCzW5VId0yQEEJ2xRgi4lDyrgIS/r2lMGnU6GErpND/3XDcAKY/D2u448Xw1xm3CPVmOfU9VOhow0GtryHxsvdkh4hBSCAy6QpAunw8WGqNBx7RWq
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 01:15:19.5582
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ddbffc-5981-4e37-a379-08de8554fcb5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8759

Introduce a global "DAX Regions" resource root and register each
dax_region->res under it via request_resource(). Release the resource on
dax_region teardown.

By enforcing a single global namespace for dax_region allocations, this
ensures only one of dax_hmem or dax_cxl can successfully register a
dax_region for a given range.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
---
 drivers/dax/bus.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index c94c09622516..448e2bc285c3 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -10,6 +10,7 @@
 #include "dax-private.h"
 #include "bus.h"
 
+static struct resource dax_regions = DEFINE_RES_MEM_NAMED(0, -1, "DAX Regions");
 static DEFINE_MUTEX(dax_bus_lock);
 
 /*
@@ -625,6 +626,7 @@ static void dax_region_unregister(void *region)
 {
 	struct dax_region *dax_region = region;
 
+	release_resource(&dax_region->res);
 	sysfs_remove_groups(&dax_region->dev->kobj,
 			dax_region_attribute_groups);
 	dax_region_put(dax_region);
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
-		kfree(dax_region);
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
+	kfree(dax_region);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);
 
-- 
2.17.1

