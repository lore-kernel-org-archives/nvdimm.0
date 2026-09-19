Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013055.outbound.protection.outlook.com [40.107.162.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF793A9632
	for <nvdimm@lists.linux.dev>; Sat, 19 Sep 2026 13:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789823425; cv=fail; b=tvlh/WqR5VcrSSLQfj7l5MweBMzzUyBAogIBV/h7H7mZQ51cINSjYUXa3AzUwhGI2Venb0zs/qy3Iz/6NNWgTvzZtHM3SupCl2c0KUHdCmA5g5dts4Siwf61TGAS+qful/efOddvSN5TViV7stb9VsLo7alAwWdebyfyYGUMzZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789823425; c=relaxed/simple;
	bh=CYTuqPgXy/LzhxVoNxYMyyxxb8T7kJ3DiPnbyH6wjy4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Q5S7GrmcFBO6a5ruWAVJLuCh2ibB76rpa07lVTIKlUmAEfhXDhZHkEpjsHgJP0zMqe8EK/VxSDOcR3nQmolB7c3yFnSgHn9DMcl5C5oGM0aSU/sflM4K9QjZICsWteP2t58JUn1RydusdJJgTP7/2XGdWI/sbZE35i4CmzZh1M8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=UQ2aWl5s; arc=fail smtp.client-ip=40.107.162.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="UQ2aWl5s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cNwqDH27w/8YDPwsfmeRm3AfJKsFpgMXCOhfjc/ilbBcDDBzYf71idnVefxiOUWsebwC9JyNbQ3AE3HBUt4on0d7kdRCLY+pgTxRb3y/NeyZHE+VGGPFA1n6paocN3TRWtfeB21jwQ4pI7CCMb7LaeLnnmy+olzcQHMBlmGD7WIVW1rpBgxVHkNV9AHYLBTaAQ4eYebZwgYFXEYtTL0jPD9rZrnMVtvFJmcWEqiU64lBMfXSTe7Gjz2OqT36zqYStUFzMsIfrJuwY55MITMYdgkodRWmlEDkqnU5riYwaivpcctPfO27hrHoZ/hwLADaedrbbDqb3VKvy5ERTkxYrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1ILWb045XXOA7tOgIAbfLy8FtbcV2r7ocP9bsL7vT4=;
 b=VVpk1nNeYBeh6MOWG3UBi16D2HchAvZXIX1qCqx+i6aSIsh5sidN9Mbehzx42G/TN58r6SCFzlsEpeitqcd4IMcdAMNqngo+tr4MWcqlrEDED+ZzRjVHKBnEn5HzvQHPdf+ZaMb96JGLSapMDZFwJUxKoH7ujxVlZXgZmsdEOBCPZUE3vOtjEyci00prgJ4scTPUwxwfvXhWKEXWqWqkwRaUaX9MIwQpdd3XgTCJ5/5nO2JigFaF4eOHA8zHl3kjtH+oFWNT1lv28ny/FRuZ0hRWs9jh7ugtIoAlzih4iU1C5U8FayfsC0NTtd7ihqZa8Z616uiZqa43Teveli435w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1ILWb045XXOA7tOgIAbfLy8FtbcV2r7ocP9bsL7vT4=;
 b=UQ2aWl5seIN0hb4Quqd6SN8XQegkkBpvLSH4PvCz5BkbdWOFW85Av0XWpwz9on0Df8vSgGhZzCHehP+JzQH3k9dq8Wd8PBcg7hKdUK4fhUXHmTdoWfxAR6hW3aFRSh4/dnLZHKRnWjT6+iKuG9Z5Hi9QVXv0jWiz7dhrueF/rmqu5UW5XaxhkOt7xBOqyoYlWJHM1r3+/7ZQdiu5AyFGSXZrKUpYC9Rmf3Jc57M34NSSjXE6I4AXQVcc+/FVk5L86R9LXVYHeOpduB7y6MmrLzxiGOXBXl0/KPW8Lg7i0unegIOYHQkmagFmx8V3duj15ZtITCRyQZu2kwNYAkqahg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by AS4PR04MB9507.eurprd04.prod.outlook.com (2603:10a6:20b:4ca::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.14; Sat, 19 Sep
 2026 13:10:20 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0428.014; Sat, 19 Sep 2026
 13:10:20 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: linux-kernel@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [PATCH] dax: use assign_bit() where applicable
Date: Sat, 19 Sep 2026 21:07:50 +0800
Message-ID: <20260919130750.3041470-1-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0041.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::15) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|AS4PR04MB9507:EE_
X-MS-Office365-Filtering-Correlation-Id: 62552367-b514-44b3-a9cb-08df164f5b95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|19092799006|1800799024|23010399003|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	NlruIwGd4/2t0/oHdcZ2qXR/1jtRtjA1jqTzzBg4eYX8O5AbNcucFDWnCPb5+2ygzc5sFPSqHhbbfba8nYS6ypYrZ7hHRdZe91j37jftNP91F++Ga5K0xlDQgGWpNOC2+PhG5IvkKmqVVWq4uI+ZJITveowyp9N0/QpFJ7CEJoXSCSZVagNCoYixB4U/71/QBnHrBHqS0e1Y7qDY4u6Xd21/xWYrEkKBw+y7M89+LlxIkAta2m34c/RbzztZLJaIX4sYmtf2NuIkZuziAqjP9yMhB2C6xSjDVznHWscQuH+q+FcmjVhG95XEpJzFaSgpVhvz7f33QQKUfoEWy1osx71QHdwKJJsp4j9M6sIuBX8tNobP+XZa96hqldGIgazyesPFIKI6xBJ8F8ERnIArU3vESRbwTROJVdluD96FCTMKitzyt7sTLUbDAWM/YXONyT1GmANCdU9UAevrkJc35Y5VDF0jejM4VgZDNPkZKNWLknwfuvoT86Of0UYIMNEGQEs1sylpxOVJRpZsbDhWRuIhaqA8A7hNdgafXL2xwYO2P8MWLxyv8w4To1KbXO7rr9H4aUSMnaecH+Drb5rzdKmuD6ddEUWzvsHwfabbef7HwcEB0JKKLNMgjkk6n17GeGKIg8XGhnobGJzm+ohzlntznCv4iTPHwjVMCZZhBUM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(19092799006)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aaaH2SRXIIM3E3AwSnyAhAvgARmEXGcyBJIodFA85dsoTwo99z1fVaqHnzd4?=
 =?us-ascii?Q?dAvmcQ7GYQWsnVyRJaXoW0R4TH6xp3tlAOT5ug6mK92o4lSAUITbCH0ngE+e?=
 =?us-ascii?Q?pUOenhSxeV9FEtpmHFTV2iRq6elvK9lVs3seyN0V3CFHWl0VXg/SAXe+cG8B?=
 =?us-ascii?Q?AEMEHZPpAMParSHncnWte9W+JX1KdnqRkzWEC7a+M4tyuvmDe7w34dd/0py7?=
 =?us-ascii?Q?wP/FQYJk5ohdSIQW5DIktqXf/MM0zU9Ns1giCJycetupMTpkoHVQoCnIsJRc?=
 =?us-ascii?Q?3NBHifCot4SxSPllokZWFUQ029miZNNCQVk6ZxE6W07HNi7BVWEbgqoAI5sa?=
 =?us-ascii?Q?b3UC/62NAIHRTdsTpxphsyl4CKSF4T7QagVmzqMJ9QorccK+9vh8pIFIxlTB?=
 =?us-ascii?Q?enIZDhuTcCyvSqP8GJ/IyE1QhFRMinn0GEnIXl/P05qI/D1FfFYntJj8Ydgj?=
 =?us-ascii?Q?IvJXlIvDWFiBkefHqYSMY6TLUJdvCmpzH0bCwp24FXoggGNz+hczQa1hj2UV?=
 =?us-ascii?Q?pFDxrmYo5dsBoTBXWRWGRgncat9tTTa9OS8I3WrLUZIsiAH+J97MAJcaHCTp?=
 =?us-ascii?Q?GkrYHFpb2HA+SaBb7QOZdUF6w54rItszod/Uo+F4KQQOfkMEd4A9yU9UVbLm?=
 =?us-ascii?Q?Dx7JLQ97eifa4QZviUAnM9qOYUq3KG+ZwggAt9tNLCb7PYzjATqImN5gdmby?=
 =?us-ascii?Q?nW9TFvvEpZN5IHOr6vkm3HGC54IkYDWOM8yzc6uuRcMrb9VoUFKRS+UZx0xE?=
 =?us-ascii?Q?CoIcQIMGh5zvHCBcAQgmdzGjKuZ7bhxlazGfXWszut/Vt4hHTW08ZEwFo1RG?=
 =?us-ascii?Q?tbBjp3YFLxYBZxGF7ByeXLID34quYjMzk39NWHqvKCLZMk7k1FuCx4JeRsj/?=
 =?us-ascii?Q?GZV1L5wXKGjZxPAHUd4UISnnAQOwLEH0+3A85MUFMOJe67TgxcddniK3VQ/U?=
 =?us-ascii?Q?9EA5g0kYB6cMgrmRG9JVFdeXoiSXmTqXhWuWV6OvqR+HShXkwiYbuA5/Sf20?=
 =?us-ascii?Q?q9gqIE9DfKdDtJ8c0QGOH7deoXt2YIaOD0sxGUAWU1wfuPlc9vHHWnO8mcf3?=
 =?us-ascii?Q?cm/brLWPPKwFZJrM8AcjSgGz6csHmZurr8Xls9o0AYseHsPl6qj4/LRB6cws?=
 =?us-ascii?Q?LFQS8MGqRAueZg4yky+l/BYkTiMNjitvjxd7mzB0C0jXvTzlkmpdNNNE8STu?=
 =?us-ascii?Q?/jlq++gB0GVLK+gpeILe0Fa6bumSMSjk/dcSA7bDGrEQmPUk08euryn9h8Ev?=
 =?us-ascii?Q?pUuBZg4ihy4ndFXhz5ijTZc2zbGyIjm7GhGGVsiy9NfZYs3V2NeBZGlC/mkS?=
 =?us-ascii?Q?xJ1KW9EGfNN0vSDWP31PfrTK1quN4lBf5DCz1NBuocm4unKPQtSWibw/jyAm?=
 =?us-ascii?Q?b0+N0bWdoAYbostHKYwV/usvEYzCx7Vsdke9sWMLV7fO3xAZ7ptGEqgVNqSi?=
 =?us-ascii?Q?IV3ZHmcJWFJQKrDHBVmIpCclkfEqE+6+eHdtkoLJWZAY3R/zzYHWHaGkKlW3?=
 =?us-ascii?Q?DWwy8otcUsmKR8aE9+g1Jv2CcyHJAu0csx0C3+LTMIfe8bwwJEe+2Tedq5wx?=
 =?us-ascii?Q?njXQBtMQN33v2IuqiURz68VNogNjq8XVBJQVstOKfaB5GNJNTzo9nnHvAew2?=
 =?us-ascii?Q?QZWwgbxVsquIR46dsREqTPr8vTWb+uKHhQRvOI8xckFkuoWNsWOhu+vohuh9?=
 =?us-ascii?Q?Ac3NnfqPj1zFiaMPARgTwU4u4F9JVwIObSEWm3uvucnyhIkuzAfItOi+vdE9?=
 =?us-ascii?Q?Ukr5le1N32OGpPyP2semPyNJJr/nZ0q5f0K3Gn+9sWppfYoF7BUo?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62552367-b514-44b3-a9cb-08df164f5b95
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 13:10:20.5477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lhlk6hfMvPNn1Eld9Uh/7PQMooTsl7uyXO+E8ja0oWRiEf+zWFzYtqdB/HwrNxCpU2p0fSjxatdf4cAsMkkhGfW9isXqtlzkcjfPsh/gcmajCdqQyklBP8tOUXFcZVQV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9507

From: Peng Fan <peng.fan@nxp.com>

Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 drivers/dax/super.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 45f84b0eb909..60c4aec52ae1 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -385,10 +385,7 @@ EXPORT_SYMBOL_GPL(dax_flush);
 
 void dax_write_cache(struct dax_device *dax_dev, bool wc)
 {
-	if (wc)
-		set_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
-	else
-		clear_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
+	assign_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags, wc);
 }
 EXPORT_SYMBOL_GPL(dax_write_cache);
 
-- 
2.51.0

