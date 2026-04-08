Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012064.outbound.protection.outlook.com [52.101.43.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B8C3DB636
	for <nvdimm@lists.linux.dev>; Wed,  8 Apr 2026 20:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775680389; cv=fail; b=kmaFSiKRaQfWFerLN/fWbGdAgpkiM0ywVlWkjVUOcWlqNK9/ulM1Tiz1XD3S4jCi7awn43UCITFiXKe8J5UgkXOsbZ6l/fopmn+Mj2OoQ+HyvbvAvS3StEbVh5aNZn2Kk916j0bFGG+qHkV1CZI0djj7sg8bXODMg/xt1bhbuYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775680389; c=relaxed/simple;
	bh=ddoEZ5c83zO2CXn+lcHDEZt63ZIzWTxJ36UwiICThy0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JsDvE+e7EnYzQ4i7d8gEj6dXdFHcwvvCFltlsY6kTKAUMuOy2xwKXwBhkwGLhie7pOqpOoZBb0Bav/an4uRK+e0fUG1PflClaoM2tmN+cU45p4aFyijw3idGxmGHjXlUQFcJNKZX1qvMX7MNar+bxu9Ncp+XWwAogk3bNoo5DoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bGhxhZaT; arc=fail smtp.client-ip=52.101.43.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bGhxhZaT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dduJ8Za+1oUVe1ht1o7pkstYL1hTI7qH/H0gB4S9dBX2PR/X6Qu4oLnTvdSqTCNzNmuVb5MXfcxlfAuk+m/LyfyBNkaAiSvs0gSI/1lHiLxxCsppcUzFIf7nOThl+K9NJ70/SEzvjhj8pnQv8jwBT/BWpOqpfAS1RaPynwt1hIbEbXZKg3DNdDAB06cb32M8pLHKkg4mzgoEc2lcKvs5EekHAxNAqn+IkRKSIGLFhSoe6VfuiDABx1FgM2gQQflCdCX2m3QHtMzeaSr1tKEa5rrVSkGT4C4cFbbJNO2xfH133FtbzpiElwP5aXAPlULn9vYj88wsroHvTCmqbRKskQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=42XDM+JW3dJhuUviCNSqPWmjxadakKM2+aBSmiMK+U0=;
 b=VYBhBssaUNHntsgMHRiVbIm3oLNEWcCcT3V1Z8X51gn3RJxaNl4bHmBinc6hWiylpQt/uZPx61O6u4kJqtd66ucuirOxNgpWzu2N+hNtHZ5wQ5VCSrOH/0Oc4wW0rznWznq3CqkrkQC3ArXYkxr/WN5vjBlec/A+vKL1PlPf5vnwWGwyBggk36zlAwCMhd4Rd01xECjdHi+g9nHHbIA6DDPLSCAZUD1OSDU2RwAg2MnzlbHCBMEaoyIG4nQtbdFiJowmXf+4AAzC9A0nMtZ3tMzJHz+sujtqiX/iiVg7ki9cF3Nweut2rO7YwiTxlMq7w7FLcI8fLzPLoiKDEYIDCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=stgolabs.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42XDM+JW3dJhuUviCNSqPWmjxadakKM2+aBSmiMK+U0=;
 b=bGhxhZaTyFtBFhiaY0plOts86cNqPa7mgdJqn1znTdQJQDRxYlApKMwLaHyMVzxRG6Y1vE74FcVs2SQjxuf4mxekouIsNist0AiKZbBqvs4qlboJfW2CmrIy2lwQTOzJGn+UBiRIG7RnaolaW1h+pRPLhikggzts0IlsUaIBDJk=
Received: from MN2PR06CA0003.namprd06.prod.outlook.com (2603:10b6:208:23d::8)
 by BN7PPF5D27497F1.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.41; Wed, 8 Apr
 2026 20:33:00 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:208:23d:cafe::48) by MN2PR06CA0003.outlook.office365.com
 (2603:10b6:208:23d::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.37 via Frontend Transport; Wed,
 8 Apr 2026 20:33:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 8 Apr 2026 20:33:00 +0000
Received: from ethanolx7ea3host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 8 Apr
 2026 15:32:59 -0500
From: Terry Bowman <terry.bowman@amd.com>
To: <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<dan.j.williams@intel.com>, <shiju.jose@huawei.com>, <ming.li@zohomail.com>,
	<Smita.KoralahalliChannabasappa@amd.com>, <rrichter@amd.com>,
	<dan.carpenter@linaro.org>, <PradeepVineshReddy.Kodamati@amd.com>,
	<lukas@wunner.de>, <Benjamin.Cheatham@amd.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <nvdimm@lists.linux.dev>,
	<alucerop@amd.com>, <ira.weiny@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>
Subject: [ndctl PATCH 2/3] test/aer-inject: Add aer-inject correctable and uncorrectable interanl error support
Date: Wed, 8 Apr 2026 15:32:30 -0500
Message-ID: <20260408203231.962206-3-terry.bowman@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260408203231.962206-1-terry.bowman@amd.com>
References: <20260408203231.962206-1-terry.bowman@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|BN7PPF5D27497F1:EE_
X-MS-Office365-Filtering-Correlation-Id: 30a24185-2237-49bb-7d55-08de95ae06c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|7416014|1800799024|82310400026|22082099003|18002099003|56012099003|921020;
X-Microsoft-Antispam-Message-Info:
	INgO+VYM2eRntMcUVYNfXep+B/3VhuM4TjAJGchrXYjc9jidQzwBwjXNOH85zFbtCdOWvLRxzah/r2PcKW+O9m/g91dOSDenb1RW0S9F65/5NhSY5fNWC2r46ScqdLkMW96V84dWv57UTqq0+N5Onlrptg6CrvLX3VpHfEj5IhSNfcg361zj3KyDlkDbMrclzNGVPPFmAw2ywqIbmqBrjSRa4rKBEm6pSPLBQj2RswJ5v8kq6iyR46eGYDpu0N3sShWiEegRb56tR8oCIiKpdMXCpWN5rc44NHi0UR2bGb8SxSFGdXgAKeoAfy0ghAVjhqy7By8xJ2Swr5QNaK0aSrh2bGMHAYhYvWZ2UQqTbYc6NsW/Su+V40FOrHls+eu3NWiLXe9oXwazbbx04IpuJaIHIieS9vZHuEbW/DfkbbLWNXc2+3IwHOV2bPy6yB8pplTjzLiF3GcVvRC8KSKiBmMNIow9OBJulmoVrUI6LyDysfOlu+MecTIG2A0RT00Orfy8JNXUsM7N9OJa43H6S51idvG9fus2yEjXUt3jIh+CgS3qm3rFq1gdJGo/wEe3oOqXRLsx09/szOEcYDPSFMAQXxUo4An6FMVeRaKZB9N9FIZEtkpJv7J9IBGj9WLM4JtGE0BLLPKYbiiTie2IBN6OJmhX4hSA4M3SjMZWeB6qLQzIWHdpAmvX8iq6LzUMtYUn1Y1wRTT1bdNu3ahJGtUK+4WG0v6jU+JD2oYs8D1gYoe0qdBt8WTqNaaY6qcX71vAT8OI2IxPMODo4CVPjpvOYdDRm2hssD1KjctbYiBpurOpy0XeEOLkADrZew+Q
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(7416014)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	a7Iy4koflOr9NGxdd2BR+IgXuWNM9BiPfQMb9hvcDilvOlvMNtMDVCBCKe8YSVS8mjwZRgzEuQr3CQJVD5B3lKXhUWX+51PeQ5ZqO4HB7DDCVVBxREvTnym6Ss9nM9GgO/zL5ug2YLTBPv8hK32wlVDnI5OH6mvb6g4/piL/6it6zrpiLEcCdVgRNnNKNKfjDzHr6ICJk6faOvRRBupBK1y9HmF8KVnkQRxRFC1aEv9wVImx+Ol5mWRhoIIdtqpRJrCCwNh3lJPX478h2Dw9iQnYrC0yDfLlGoasCvbHe0fOi9gVri3LN3UFuUJ+Ycc1k/0m071LmTaYoSVEeDUDDHQjTJ8y8OB0r9gDjsSB4yqx0Iy46qCLxOh4Ch3yN9XwRlen9/aQtLvsHOAHRaNrCWWjEbrKtl6nQ+SK/RkdL79j286R7zkoWOs1IVHFBLWf
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 20:33:00.3012
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a24185-2237-49bb-7d55-08de95ae06c2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF5D27497F1

The `aer-inject` tool currently does not support injecting Correctable
Internal Errors (CIE) or Uncorrectable Internal Errors (UIE). By default,
internal errors are masked according to the PCI specification and are
generally not used. However, these internal errors are now leveraged to
notify the PCI and CXL subsystems of CXL protocol errors. The attached
patches enable support for CIE and UIE internal errors in `aer-inject`,
allowing for injected CXL protocol errors to be delivered to the CXL core.

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
---
 ...Add-internal-error-injection-support.patch | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100644 test/contrib/cxl-aer-einj/patches/0001-aer-inject-Add-internal-error-injection-support.patch

diff --git a/test/contrib/cxl-aer-einj/patches/0001-aer-inject-Add-internal-error-injection-support.patch b/test/contrib/cxl-aer-einj/patches/0001-aer-inject-Add-internal-error-injection-support.patch
new file mode 100644
index 0000000..e5675ee
--- /dev/null
+++ b/test/contrib/cxl-aer-einj/patches/0001-aer-inject-Add-internal-error-injection-support.patch
@@ -0,0 +1,91 @@
+From 9d273a798950122059e9428a698d1d9d2520362b Mon Sep 17 00:00:00 2001
+From: Terry Bowman <terry.bowman@amd.com>
+Date: Thu, 17 Oct 2024 12:12:58 -0500
+Subject: [PATCH] aer-inject: Add internal error injection support
+
+The `aer-inject` tool currently does not support injecting internal errors
+such as Correctable Errors (CE) and Uncorrectable Errors (UCE). By default,
+internal errors are masked according to the PCI specification and are
+generally not used. However, these internal errors are now leveraged to
+notify the PCI and CXL subsystems of CXL protocol errors. The attached
+patches enable support for CE and UCE internal errors in `aer-inject`,
+allowing for injected CXL protocol errors to be delivered to the CXL core.
+
+Signed-off-by: Terry Bowman <terry.bowman@amd.com>
+---
+ aer.h   | 2 ++
+ aer.lex | 2 ++
+ aer.y   | 8 ++++----
+ 3 files changed, 8 insertions(+), 4 deletions(-)
+
+diff --git a/aer.h b/aer.h
+index a0ad152..e55a731 100644
+--- a/aer.h
++++ b/aer.h
+@@ -30,11 +30,13 @@ struct aer_error_inj
+ #define  PCI_ERR_UNC_MALF_TLP	0x00040000	/* Malformed TLP */
+ #define  PCI_ERR_UNC_ECRC	0x00080000	/* ECRC Error Status */
+ #define  PCI_ERR_UNC_UNSUP	0x00100000	/* Unsupported Request */
++#define  PCI_ERR_UNC_INTERNAL   0x00400000      /* Internal error */
+ #define  PCI_ERR_COR_RCVR	0x00000001	/* Receiver Error Status */
+ #define  PCI_ERR_COR_BAD_TLP	0x00000040	/* Bad TLP Status */
+ #define  PCI_ERR_COR_BAD_DLLP	0x00000080	/* Bad DLLP Status */
+ #define  PCI_ERR_COR_REP_ROLL	0x00000100	/* REPLAY_NUM Rollover */
+ #define  PCI_ERR_COR_REP_TIMER	0x00001000	/* Replay Timer Timeout */
++#define  PCI_ERR_COR_CINTERNAL	0x00004000	/* Internal error */
+ 
+ extern void init_aer(struct aer_error_inj *err);
+ extern void submit_aer(struct aer_error_inj *err);
+diff --git a/aer.lex b/aer.lex
+index 6121e4e..4fadd0e 100644
+--- a/aer.lex
++++ b/aer.lex
+@@ -82,11 +82,13 @@ static struct key {
+ 	KEYVAL(MALF_TLP, PCI_ERR_UNC_MALF_TLP),
+ 	KEYVAL(ECRC, PCI_ERR_UNC_ECRC),
+ 	KEYVAL(UNSUP, PCI_ERR_UNC_UNSUP),
++	KEYVAL(INTERNAL, PCI_ERR_UNC_INTERNAL),
+ 	KEYVAL(RCVR, PCI_ERR_COR_RCVR),
+ 	KEYVAL(BAD_TLP, PCI_ERR_COR_BAD_TLP),
+ 	KEYVAL(BAD_DLLP, PCI_ERR_COR_BAD_DLLP),
+ 	KEYVAL(REP_ROLL, PCI_ERR_COR_REP_ROLL),
+ 	KEYVAL(REP_TIMER, PCI_ERR_COR_REP_TIMER),
++	KEYVAL(CINTERNAL, PCI_ERR_COR_CINTERNAL),
+ };
+ 
+ static int cmp_key(const void *av, const void *bv)
+diff --git a/aer.y b/aer.y
+index e5ecc7d..500dc97 100644
+--- a/aer.y
++++ b/aer.y
+@@ -34,8 +34,8 @@ static void init(void);
+ 
+ %token AER DOMAIN BUS DEV FN PCI_ID UNCOR_STATUS COR_STATUS HEADER_LOG
+ %token <num> TRAIN DLP POISON_TLP FCP COMP_TIME COMP_ABORT UNX_COMP RX_OVER
+-%token <num> MALF_TLP ECRC UNSUP
+-%token <num> RCVR BAD_TLP BAD_DLLP REP_ROLL REP_TIMER
++%token <num> MALF_TLP ECRC UNSUP INTERNAL
++%token <num> RCVR BAD_TLP BAD_DLLP REP_ROLL REP_TIMER CINTERNAL
+ %token <num> SYMBOL NUMBER
+ %token <str> PCI_ID_STR
+ 
+@@ -77,14 +77,14 @@ uncor_status_list: /* empty */			{ $$ = 0; }
+ 	;
+ 
+ uncor_status: TRAIN | DLP | POISON_TLP | FCP | COMP_TIME | COMP_ABORT
+-	| UNX_COMP | RX_OVER | MALF_TLP | ECRC | UNSUP | NUMBER
++	| UNX_COMP | RX_OVER | MALF_TLP | ECRC | UNSUP | INTERNAL | NUMBER
+ 	;
+ 
+ cor_status_list: /* empty */			{ $$ = 0; }
+ 	| cor_status_list cor_status		{ $$ = $1 | $2; }
+ 	;
+ 
+-cor_status: RCVR | BAD_TLP | BAD_DLLP | REP_ROLL | REP_TIMER | NUMBER
++cor_status: RCVR | BAD_TLP | BAD_DLLP | REP_ROLL | REP_TIMER | CINTERNAL | NUMBER
+ 	;
+ 
+ %% 
+-- 
+2.34.1
+
-- 
2.34.1

