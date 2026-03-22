Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012032.outbound.protection.outlook.com [52.101.53.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D898C37DEB9
	for <nvdimm@lists.linux.dev>; Sun, 22 Mar 2026 19:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774209247; cv=fail; b=AcBUCy74NKFUQVV8ysAFbsDISCKYEDya5/9ZuoGcib4gbn90AqX0/QIJa/xhOIeqn5ymOaNf+HQ1v0k9P79QqTV6EOwENnx5HczR7POYV/QF7ZPYU34SmSd3u2vhxqgrGcnqXMYy4cFo3XTVuBRE1rM/tWGwn6zGzkXiqXDITOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774209247; c=relaxed/simple;
	bh=p6RolRsSRS8Z+16Ku2/zxl1+Z0/L2HBZxyrVTAHdvsM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U6CCSOvrcGu11TQ5DzELFwo3R5U2dYrvsBtteJgVui4get8DgzlJwZkCWjMO2+M2lSYDU0qGtVfwgDJn97nBwD3r0GX4oc5sSzj79/JbpnYGv8/sdjpIru1MuSmtFR6GBpuk/DN7UzXkg7eW4DTyYDIOyN68FPYFMNosAx7ka8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oUaTauc3; arc=fail smtp.client-ip=52.101.53.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oUaTauc3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O7nPmp7IptOelpLrkdcjZ+hIlSLlZrZNWjvydbHHNwHXfdskWu+0funhbBVztsI03XGc0baiXvbMklGc2/zi8Frb3pwNrvz4iuRei5vnRgNgUDLva5ruQgCBUbK6Vb/pAPqXByMXcgJvQMjr57vPYMM6pUlQaIuXyssSeZxjV9W5PaA6IU6bCOPA+OkehfK0UJQTgmwHfc2Jw+gu5ga8OQYLdTaP/rI0gQWpDoPG8mxqPe+hWhBm30ydAbJTQrSHh/FrtIiOQ9fMywur/57+SixP2MoiLqKzzgKcrvfN9AlUhTpt8oTJcvW60XhbvZLl0odLfNDli+plqFjS3r0cpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4DP0t0eS8SW+roTZpq1XYy34wLQKLkoy+NI7r18WiK8=;
 b=aZ1VlvohXGBSm1mfR/Q1JrL+5T/gOVMu/tQXQV4NwlN/JTnuxEyMasbG8ywQZykxiECK/bTw4IL99JVY/v1py9U5ilGSxkabuXnEiMSi5n3rbCdq6cDDdIuayNmTsF7Ug1AoRWdfW6s0Ta68gMz1/iSBPrDOgJatj+k1SioCEyl5peYNm9tzgKhe08HiFjwNWgLTSM8Zq3eFcKDeznSwcCaoTu0Xdq+4CYualbfK5vwCtCBgWVLfrc0uZ169vNcdTwoc5rBC6C5sfIDrB7U3Y0wmMO0euwTV9Jiu/0jteHN6hcdciq6EXlZVlCD9pP3tzwjvsHAQIqcz3UCCxATFZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DP0t0eS8SW+roTZpq1XYy34wLQKLkoy+NI7r18WiK8=;
 b=oUaTauc3pSZGL3LrP4c4HrG08wG5RCrf/3U6cUKRH9mrh3xM94I38WHsaVwFtCJz5IGQIT3AP64ubpNpx3jMwMoKAuDwQ2Zu3kUokSgtWzBAk+z87PPArptSVJtQ1orD1yTl9SJltb5RWGeld6wgLKSZtzLIL8Ezto96pWpRhb0=
Received: from CH0P221CA0016.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::18)
 by SJ2PR12MB8738.namprd12.prod.outlook.com (2603:10b6:a03:548::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.16; Sun, 22 Mar
 2026 19:53:59 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:610:11c:cafe::ee) by CH0P221CA0016.outlook.office365.com
 (2603:10b6:610:11c::18) with Microsoft SMTP Server (version=TLS1_3,
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
 2026 14:53:57 -0500
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
Subject: [PATCH v8 5/9] dax/cxl, hmem: Initialize hmem early and defer dax_cxl binding
Date: Sun, 22 Mar 2026 19:53:38 +0000
Message-ID: <20260322195343.206900-6-Smita.KoralahalliChannabasappa@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|SJ2PR12MB8738:EE_
X-MS-Office365-Filtering-Correlation-Id: b5c30cdf-43fa-46b5-82c2-08de884cc216
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|1800799024|376014|82310400026|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	wSjOnu0KonQeH6Rl6WGVUKGP7haxMiRDfY6neTaeZYGqyIZd2MoPTF0lWjGcZgvgaQVRhna5iTtAK6ww/P5N0TivEyMbkwE6Cv+KwhtTwfGbzST9NpdZO1KbUfAEHOt78ZVa4qgdpmMqDSLtOfXwK/w3XpGrGHcjNWuWjcfKcU34d73HibKFQQcSL+2xM30/gnRlJDoMUMOOtKLYnvuWNJCm9lEH8dqMb4iHGFK1asO2DmniKedhHcxlSwVIFKXEosVQNZiPgSBG9HRnCXnzHk4UXTZinQFo1icJHPcNFqF2VHWUPVIcvXaNnePiB5QZesBdzygHpwPNUHhaAj3daENSZx77E/UQwXylF/xBgA4ccWFV2+CWR6makQp2gAI9ycImCiDWa/GU7fkPgt30zKssrDdpHzfJozXV8NvvBTwm2zZXKunGa3naIaSkiyMr7HwoAbvqClYbkJmt+TJzxylSadg4Gkb3QJaaIt6KaL7UIvH/qr/MBJ+bELjBe5XEP/SSJTcFXqziujSShOJOG+xUIJUa3Mz9TBhRiCYhd9g+EeLUzYO8uf9pZjjlcvrzfI1p3wcYIhC+GAXR3OR+B+ptuIP8SDPaBPLh/cfay13jBD/WRzShEZHzJdGEtxdwAKe9UwsZ3Xa6I82tyrN5Dx4k2shOa8pfTkygDYscqvKLtYZgztfwYhc6dqtYS/AvCn2vQM3idGiD88HzQ9D5LjtLI8VgohRRiQO9tc8ha0eD9RLhU6MH3mRCeSFry9DZbZXl4P7TQT5cOsd98l4n4g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(1800799024)(376014)(82310400026)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ScOnaer4fMwkaSW8+yxYFHoWh26HGl4SsctSwNrzKZLsTLvC+GYH3ErkJ+7XT3oAUW/4nCkVj47u6yknVivPQTK4tl5h2YYMWtJFYC2ksGHT0aLpgrq+DMICCilwYvdeaXuOm1grrYZQX24E8vtNYgAfsYJnPhqQELehFy0/IZGgHa9sTBq4vwJ7HVQnVoXOns+pfqo9mPGfjLBfjtZ8ItzC6brIFHyu63OgjgMnKiOO7gwkZn3PmOrnSXWAstyDVLp8FNXSvq99omRhZyn+2RrvUNat6yTNmwlF2VEjF8CTqX5XgLwe8o+AurhA9jEoJrRf8VGOVedVSfL/AltQf6LrEyzagTpUY9uQOSMMSypv96MtD6IOmXgb79OC7b8+QQB5WF9UcqoSIhYJ7fT9TNPfTtk6nlXk/4jdzeSTS5+hC9Q8Twt0qf4lXoIkkqFo
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2026 19:53:58.7895
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5c30cdf-43fa-46b5-82c2-08de884cc216
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8738

From: Dan Williams <dan.j.williams@intel.com>

Move hmem/ earlier in the dax Makefile so that hmem_init() runs before
dax_cxl.

In addition, defer registration of the dax_cxl driver to a workqueue
instead of using module_cxl_driver(). This ensures that dax_hmem has
an opportunity to initialize and register its deferred callback and make
ownership decisions before dax_cxl begins probing and claiming Soft
Reserved ranges.

Mark the dax_cxl driver as PROBE_PREFER_ASYNCHRONOUS so its probe runs
out of line from other synchronous probing avoiding ordering
dependencies while coordinating ownership decisions with dax_hmem.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 drivers/dax/Makefile |  3 +--
 drivers/dax/cxl.c    | 27 ++++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
index 5ed5c39857c8..70e996bf1526 100644
--- a/drivers/dax/Makefile
+++ b/drivers/dax/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+obj-y += hmem/
 obj-$(CONFIG_DAX) += dax.o
 obj-$(CONFIG_DEV_DAX) += device_dax.o
 obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
@@ -10,5 +11,3 @@ dax-y += bus.o
 device_dax-y := device.o
 dax_pmem-y := pmem.o
 dax_cxl-y := cxl.o
-
-obj-y += hmem/
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 13cd94d32ff7..a2136adfa186 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -38,10 +38,35 @@ static struct cxl_driver cxl_dax_region_driver = {
 	.id = CXL_DEVICE_DAX_REGION,
 	.drv = {
 		.suppress_bind_attrs = true,
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 };
 
-module_cxl_driver(cxl_dax_region_driver);
+static void cxl_dax_region_driver_register(struct work_struct *work)
+{
+	cxl_driver_register(&cxl_dax_region_driver);
+}
+
+static DECLARE_WORK(cxl_dax_region_driver_work, cxl_dax_region_driver_register);
+
+static int __init cxl_dax_region_init(void)
+{
+	/*
+	 * Need to resolve a race with dax_hmem wanting to drive regions
+	 * instead of CXL
+	 */
+	queue_work(system_long_wq, &cxl_dax_region_driver_work);
+	return 0;
+}
+module_init(cxl_dax_region_init);
+
+static void __exit cxl_dax_region_exit(void)
+{
+	flush_work(&cxl_dax_region_driver_work);
+	cxl_driver_unregister(&cxl_dax_region_driver);
+}
+module_exit(cxl_dax_region_exit);
+
 MODULE_ALIAS_CXL(CXL_DEVICE_DAX_REGION);
 MODULE_DESCRIPTION("CXL DAX: direct access to CXL regions");
 MODULE_LICENSE("GPL");
-- 
2.17.1

