Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012002.outbound.protection.outlook.com [40.107.209.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84B337FF59
	for <nvdimm@lists.linux.dev>; Sun, 22 Mar 2026 19:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774209251; cv=fail; b=mu5Xsav/MYmJbf8QfrQ/uaxdndlzeYTy2E1pzwUz/pgcEUL+CYsJlMsGXJ0su4d8ppMab0K6REkm3MYSHu9nqe0SybEV23lD7Y1b1xEz3/7vzAR4gJa8/IwsQXXiN0kfDSnxK1iEItfQa0h/NMSNhiD93ws7BgLOyEETgSH8Ogc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774209251; c=relaxed/simple;
	bh=3DEzI9nacP/eOrUNkK7+SorgSwdRNLtDMi0+RuqSJzA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iObm1FdesL8MhZ0vFugCBFG+soVPu/pZYnbJ+Vi+LfWDgdJeJhFaxJspP9BBFACN60JUjlL5sZdFFLUSWb8OtHqFqurJNOmZKTjX5z63+/+xRyGGTglPPfGt395hk6ZerOlE/Jl51SF58twWFz39Gmf+8esUaHlWwCAFJHSsTUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FczBumv4; arc=fail smtp.client-ip=40.107.209.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FczBumv4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LdK0nW4ryLD8qRkvWAniiQc3Apfjm08sEurxoYJS4PtsOl+fS1oaj9pXtXLc1wM/fcCRh9EACuYSOibvBjjNP9BWp3dR2bP2oYv66YmOsGQuvHoa49tzoVgfwRlBrEtNqBmjlxr6Co7jWafh6ADfolYsIF6Z4bUOLk0S//pSfv0qxzfRO6Y1wdlvD6oTWGay7Gp8653sNK0kbvtUBs1HTc3WFLUxdg3UU/+B+l0qXLg7ai03n/ZzEr/kJJ/m+xq5O1A8oBb8wH9EovYFlt/9IR5XYCa3PfGo3CKPU9Rjbc2zXt5F4yZT1Qq2wjNKGY6ht+X2q28mgwOl2P1ETi2e4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbBOmfDuKSL7p1aKy63n4YQ9yJ2OGT0d5cMTj62c6lM=;
 b=FgP7iIhVbC1zIct670XB3RS0pQJ9MX2bijgvOOnwxMoxEn30E2DBXdojqyei21BT/wwSCwBWsT7dknxfGsq7V24hHFP6WhGuZKHHL25MMCay8PA9Bur0ZDwNzpEERx6CKnnkb21BtQI8xyfIAiNz2EN0SX9tCJmJWhyTdC9sEp7fEE0YN5Ine5bxfZC9DWefiq68ZuZTHcqM1wESbcPljFnuo5QVVog0HOIlhvQN5+SnDCZuAJwb5B/PKFaaCIGOU+EyL73AcyFMp+uC5XeM8m46/uBJBkYBqMLs5siPbM03wnXwm+8mGmPB109X1E4NyuJBoJMu25qtdeeRbXpHyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbBOmfDuKSL7p1aKy63n4YQ9yJ2OGT0d5cMTj62c6lM=;
 b=FczBumv4aTIlWoTNR/JX2vsN4yrfcLvWfXgRjwKolc4i79iV1hciDN1AuAda7YvQDV77Y2x5fMIMsUkLuZiEREljLIzOlrMltA7wfjECE/d64RNHe6NnF32x7YFM/rYMkHKl6jbttb6uZV3SP6bk/TdD2yHQKAKZOIq6b6OpPpw=
Received: from DS7P220CA0051.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:224::24) by
 LV2PR12MB5989.namprd12.prod.outlook.com (2603:10b6:408:171::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.15; Sun, 22 Mar
 2026 19:54:04 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:8:224:cafe::12) by DS7P220CA0051.outlook.office365.com
 (2603:10b6:8:224::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.25 via Frontend Transport; Sun,
 22 Mar 2026 19:54:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Sun, 22 Mar 2026 19:54:04 +0000
Received: from ethanolx50f7host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 22 Mar
 2026 14:54:01 -0500
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
Subject: [PATCH v8 9/9] dax/hmem: Reintroduce Soft Reserved ranges back into the iomem tree
Date: Sun, 22 Mar 2026 19:53:42 +0000
Message-ID: <20260322195343.206900-10-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|LV2PR12MB5989:EE_
X-MS-Office365-Filtering-Correlation-Id: 9db0729a-279d-4fea-e6c6-08de884cc59b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|1800799024|36860700016|13003099007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZBul8IRAbXqtqfVceWIsNVkHz1biQCJNNVf9YEFhl80jGOnAGWVH1LSShfnDBtS0ZbKXTwnkIaz83Qm0qCp22CmXLdbrukF3SkxUMU09ymqIc9OoBWaQBx3k7nOUR5FsNSEFVY6kXwq3IHXBkigeiUBc+1RmPTC7b54Cya3ycPkqVLMjvh1/Mg0ilHrTBkaFdEpgCcgg5R1Y1ibMQP8XwSP/kN55AUUgvJk6J5S5SAeStyS+TFw8aMYj05HTRxL8l5UdgVKHSKxBma5sVG/DUmkM9tLoOzkJirsvc3rtSXpf+zJHXsYnkrGdNBOGY3iG9ZkGdhKGqIN9rRIX1KUXL/2WhbfhkHoN0G9MQTB/9EHWQu+4CJKjg383rcyJKc8bvavBk4Plk/JVWspVxsI0Mjw+eMIMIZekBI3aqBi8SaNw9ErNrHFI56HeTB5umcFCt/bOor/txuTow2cp/5lnqkf29aCYE/j1f8ilmSr1mLl6Qex8jXj4T1zH+DtCucttluYy7CRRGD+F+VKdwep0mMKaE4VEr7vWTsV5vnN65Vcx6NFi4nxZ7eOrHt3gyvi4ktrKMW2+19aJSBXvdoG1jWoCDxPLdu4HLAqSOpxx4NwA/4zt/3GCJNZX6FKxah5L622llSl2E1s8skjTsRltgSBb8cGqNpnmvdgrFSdc2sEMk+gwSMfCsq+mMHyHZL5klV+QPtOMgY67GGPVhF6xJBfi0pr5xeOeUFz0rWe8ASAcav9NSSrbUw83LjMBYdr8BC2AwiU0l32FqbPCLoq7hw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(1800799024)(36860700016)(13003099007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6a3jV6/SeRU4lhnHYtanlnfyDebfZKFb1jjuuZnjaWjQdd7N5VKlEjbMxz2oaD122LvdcxqKv7a+GExVoaMQsaENBddq+pioWP9Ov4SP4eDdDKiwL2peeI6gprgJ0AEbW93v4HHU2JaK7a32QZs2+zZnCJb7G2t81wkQxy5wHBXs7+4RJ8lG0hAbuqrEp08lK0PN+YsTZkzE3a3othhEkcP2V/2xREKMa5zfM03G5SJvjiox8sVHHCGF4efZHh+IZvhwRaCwMngK4nLvE1mKq+wFrR2MGe5zAISZ7ZPql4SK/bP/eVdIDc9cWcdEFpiJjWxmInUXa1HMsPhnMDcvW8TUoONTnU5iv35Hvy/yhz/L7U9JipBFKDJAoTFITR3eKvCoO1/BM4xGM+CBmC9cGvPLAynKS1TNjiYdNrYtXRYus877AvDWYzKYsc0Jsw51
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2026 19:54:04.6884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db0729a-279d-4fea-e6c6-08de884cc59b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5989

Reworked from a patch by Alison Schofield <alison.schofield@intel.com>

Reintroduce Soft Reserved range into the iomem_resource tree for HMEM
to consume.

This restores visibility in /proc/iomem for ranges actively in use, while
avoiding the early-boot conflicts that occurred when Soft Reserved was
published into iomem before CXL window and region discovery.

Link: https://lore.kernel.org/linux-cxl/29312c0765224ae76862d59a17748c8188fb95f1.1692638817.git.alison.schofield@intel.com/
Co-developed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Co-developed-by: Zhijian Li <lizhijian@fujitsu.com>
Signed-off-by: Zhijian Li <lizhijian@fujitsu.com>
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/hmem/hmem.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 9ceda6b5cadf..b590e1251bb8 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -76,6 +76,33 @@ void dax_hmem_flush_work(void)
 }
 EXPORT_SYMBOL_GPL(dax_hmem_flush_work);
 
+static void remove_soft_reserved(void *r)
+{
+	remove_resource(r);
+	kfree(r);
+}
+
+static int add_soft_reserve_into_iomem(struct device *host,
+				       const struct resource *res)
+{
+	int rc;
+
+	struct resource *soft __free(kfree) = kmalloc_obj(*soft);
+	if (!soft)
+		return -ENOMEM;
+
+	*soft = DEFINE_RES_NAMED_DESC(res->start, (res->end - res->start + 1),
+				      "Soft Reserved", IORESOURCE_MEM,
+				      IORES_DESC_SOFT_RESERVED);
+
+	rc = insert_resource(&iomem_resource, soft);
+	if (rc)
+		return rc;
+
+	return devm_add_action_or_reset(host, remove_soft_reserved,
+					no_free_ptr(soft));
+}
+
 static int __hmem_register_device(struct device *host, int target_nid,
 				  const struct resource *res)
 {
@@ -88,7 +115,9 @@ static int __hmem_register_device(struct device *host, int target_nid,
 	if (rc != REGION_INTERSECTS)
 		return 0;
 
-	/* TODO: Add Soft-Reserved memory back to iomem */
+	rc = add_soft_reserve_into_iomem(host, res);
+	if (rc)
+		return rc;
 
 	id = memregion_alloc(GFP_KERNEL);
 	if (id < 0) {
-- 
2.17.1

