Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012003.outbound.protection.outlook.com [52.101.53.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677A937DE87
	for <nvdimm@lists.linux.dev>; Sun, 22 Mar 2026 19:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774209244; cv=fail; b=vCz+WcvQSg2rHdXpufmXJUaj+/Y1kS91uKQO9IUOYdKwLVpXHbdJ9j8Yv6MAQBnSsJ6rRTyJICik19KWDAq7spFzeh3CH+NeGpprXjNqN7Lp+a04XntZLYRR2Fu3H7xPVnxLPhofrCYZMZ8RMrCRsBRwYwMEHGJUd0tQfqNKwhA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774209244; c=relaxed/simple;
	bh=CirBcGoO3cDn3L3WEctc6sxd/WvdHYA0/Evd1ybLpLA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SHQdLMymCqoMmEC7qPUR5JQIOj8C2nywk1OXBf6p5I8yqBpv8ktHN24RQRb0wCmILdzRPGVzR90IypnQwSVGlyh7ykExSCnHM+74+3vfWf61TifaSQfGMKuMo1pm14zbJJhWEN2OCdphhKAHcinvGwv9x26/SUHKeFBjR3GF+q0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0SYnsF7V; arc=fail smtp.client-ip=52.101.53.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0SYnsF7V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qt8/2yPJSpAspjTJC0qaQyQIlBJ7okwfKt+igmXauGU0dQy8Kte/eYYyS2Yb2awhrStUPfV/ukJ/6OfaTkF9Yd2J+VvPUtQy6QniQ9E6hiGDGuOnZWLke0x/MkQfYiL4pa9FtkP98dbLYuO4HWeVSqfnOQV5vDFxemAuN5jgFMFvPsNkSVnw0wNt0z2dCGnLr7qmjNYXMF6y32KSqkFG00FmqCO3d4LZno/yWnD+lYdr3xy3UYUVpz3ZHYWWpTT0tZq2knw9sZngzd31zm1rra8GlA772hlHqtwqNTT2LvnP9xkR0t5CPLJ4pCtB2p7xgBracBeGd65F3XOEVMrsTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xr3BWMd+GsGccxDM7WI8lsPKnRb83NcdLGNW5d9FhO8=;
 b=jCBEMwAh+LkoqpzZAnKkSkBs35/914B3FK7aRD40HG9iKBww0AaGC6fywXXIJmcbAEnkcVRc90cwhoN5LESaOLX2bK8rl2jSLvhuSlK4KN27Wyl4zElsBbmnqVf2oBZvOk1dM1uvoso6Gkeq/B6gFJ/gHJPeq8q5c2ZYna6Dm9iNrs5Z6CKjsU2BzDE2oZQwxl0vKtAPNQCNNQqDNTSi/E3K2CsAEc0JAGupDR4mMT/Bn4NeMEu1x15n5JJvSzmrGbxUcZMpEJvCb83KjoaBL6OtsuB0uRwUjhkDUEINWm1laabR2FPIjHY3jkF/V+S3ErAQZyT1AazAS3zpDPVrBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xr3BWMd+GsGccxDM7WI8lsPKnRb83NcdLGNW5d9FhO8=;
 b=0SYnsF7VNpJckvDmncKaeATrtHHmuLlZjTerDcnRvKDktm7hOscokDld5fyvbwFQ1QyjJntIyH+gt3bAeDwj7zEEl9OjguzqJkiud779BKaBqucMZ0D0+ZnCEJK0pnHmeInVnE0gHwiOSWBtC+UM9nTRt/aRf6+R7ge8dzX/170=
Received: from DS7PR07CA0010.namprd07.prod.outlook.com (2603:10b6:5:3af::29)
 by MW4PR12MB7311.namprd12.prod.outlook.com (2603:10b6:303:227::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.15; Sun, 22 Mar
 2026 19:53:56 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:5:3af:cafe::c6) by DS7PR07CA0010.outlook.office365.com
 (2603:10b6:5:3af::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.25 via Frontend Transport; Sun,
 22 Mar 2026 19:53:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Sun, 22 Mar 2026 19:53:56 +0000
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
Subject: [PATCH v8 2/9] dax/hmem: Factor HMEM registration into __hmem_register_device()
Date: Sun, 22 Mar 2026 19:53:35 +0000
Message-ID: <20260322195343.206900-3-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|MW4PR12MB7311:EE_
X-MS-Office365-Filtering-Correlation-Id: 164cab45-d6c2-4539-e51a-08de884cc09b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700016|82310400026|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	zY4jKYMX8rLzxosIVrpvLVJsaaO+Bpf6ih5cWby7i/xnxuG7LlxYcDlxWvATIlqAJpcBY4Sb5i3flemHTSsRTk+t9hZld/mrP/kngNDXbMAaGoD1qaCCGB+zShw0riFdzhwUgwox4XmVkoJzvFk6+mRyH2HXx9H+MR9vDkVYF9/q0KAnwQkBpffhNeRjgU+j7QTUnWpWqUaxfU+SwUBwSQT8dIbZaQMqniRKNJB4XqZ1Gl6Mfzw6DxN1oFtzNI/sloa9zM//w1hJ25FStYZ2VjWS3S72MymyuW3H3asg6AjbAei4kQ/jRjHWkWTdVNnvw5VnzP33aVPmfDTwsRPINsBDxf97TIwI54FV8GTm5ozFzDasD4Nl13l/48G9V7smuEfDtrDz4ftvStJDo2P2BMGQar2mFE0MFbUweDoE8iIrnYdqKmgTEuOSTgBexOgTwyoG+ADt+kaZ2enWOjFVHhwaUIgLdeAezqNVjPWyBWL7uQeoLnwNzRoeW60GxrsSEzj6cDQsh5Z11IMcAa1ByOCMmkq2Q4TpK4C1L8Ded8owhrnF3miBd0MafpBhHKYll9hwNZOkszozaN3n4hnZRorES9+iH7WkyXm6KUoOfDrA3H3Yn7N6Iz4PoPlWndavSR/2Fa4j7G6RcPFjfQE90lzkyBexlvibTu8JC2qX0RkLI5NRvt7D+07tB34kH4QRrDw0j5ZMC/esv5i9SN1Xkk2JSpDsJuHBy+VIOBlhCYs9EfYQjzjefuagSYxh1lM2/RtQ5QL22W7uzrfc7BRV6w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700016)(82310400026)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cWvsdGpXGbNQWLyWKhVJMl0sl87soVk+zVRkj4HzCNy09kVMaUOzCLwjkFMFOIcZP6Z9Ki2DnJ8yqXRa40XWT06FcUgRzP2TY0QYIs9uYvuYmnA+QJX/72Vesq/RCueoTqtPTrfdgIUW5X4bEUQmlSE2QAkn6LGQkPVCiEVKZG2jNeZSPK7FugavFcj6l4hNEfZqZt3FAcEXqc32gFNm7vsfUNKjMT+TVsYrHaiApuOWkdPHoJLvayuKMvHj6iDqmX3s8nF0hg1Ay3mgkAmiERCTbNwRlOS7gCPSfcsMMxo2nlpDwnAOoSwiefzh0rf87+ylLeVMwll0t/39JnLRKEb+ya6Y0RAoih0ECKjd8RamvAqM39NB9D//YXfG4MyYWzDrL0sr00Z7tWrvxgzQDnhcGnB+XvjiP8gzth0/o/AmUCCyqC7pvi/+WZVgEzEF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2026 19:53:56.2732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 164cab45-d6c2-4539-e51a-08de884cc09b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7311

Separate the CXL overlap check from the HMEM registration path and keep
the platform-device setup in a dedicated __hmem_register_device().

This makes hmem_register_device() the policy entry point for deciding
whether a range should be deferred to CXL, while __hmem_register_device()
handles the HMEM registration flow.

No functional changes.

Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
---
 drivers/dax/hmem/hmem.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 1cf7c2a0ee1c..a3d45032355c 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -58,21 +58,14 @@ static void release_hmem(void *pdev)
 	platform_device_unregister(pdev);
 }
 
-static int hmem_register_device(struct device *host, int target_nid,
-				const struct resource *res)
+static int __hmem_register_device(struct device *host, int target_nid,
+				  const struct resource *res)
 {
 	struct platform_device *pdev;
 	struct memregion_info info;
 	long id;
 	int rc;
 
-	if (IS_ENABLED(CONFIG_CXL_REGION) &&
-	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
-			      IORES_DESC_CXL) != REGION_DISJOINT) {
-		dev_dbg(host, "deferring range to CXL: %pr\n", res);
-		return 0;
-	}
-
 	rc = region_intersects_soft_reserve(res->start, resource_size(res));
 	if (rc != REGION_INTERSECTS)
 		return 0;
@@ -123,6 +116,19 @@ static int hmem_register_device(struct device *host, int target_nid,
 	return rc;
 }
 
+static int hmem_register_device(struct device *host, int target_nid,
+				const struct resource *res)
+{
+	if (IS_ENABLED(CONFIG_CXL_REGION) &&
+	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
+			      IORES_DESC_CXL) != REGION_DISJOINT) {
+		dev_dbg(host, "deferring range to CXL: %pr\n", res);
+		return 0;
+	}
+
+	return __hmem_register_device(host, target_nid, res);
+}
+
 static int dax_hmem_platform_probe(struct platform_device *pdev)
 {
 	return walk_hmem_resources(&pdev->dev, hmem_register_device);
-- 
2.17.1

