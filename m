Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013010.outbound.protection.outlook.com [40.107.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4081C258ED6
	for <nvdimm@lists.linux.dev>; Wed, 27 Aug 2025 02:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756260833; cv=fail; b=Etf1/qp5fjvbX+5167W/jq2Vq258Qb9EbiLUqYhZBAdNcc5Xt0aVyLapMY1r78zh665dDTU7PnorzqrpbT71kRll9getfWg8sz3TM0WLxWMex/H7yQicVWw0TohqheDbCySAriUGHeSBz1jzCLVgqNckOekLX3OkvCxpsFAXhAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756260833; c=relaxed/simple;
	bh=aE7kdnseJ7XkvdmOm2ygAdZJqXgAmf/XSx48hVZgDxY=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=F+TW4aM1+bvspTrfTZw6Z8VGsdPWfjE5IgYUaMbJTUnGb6Ww/csnDwq64HeIFChEQ1CRBF2c6j4xI7kIN5dySv1R6kExihX3HbKBa07tXdfSs8sxVGU9GD1+hRiigyXb10a0nPX+2LJiQ+TF51fUmDJ2bCQ/5cARsCUy5+OrEnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=d7Mx7NuV; arc=fail smtp.client-ip=40.107.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="d7Mx7NuV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ai15KMMQtIBTxiyoyz5tPiQw98JWHXr9yXiEkzeTzDXij6izjuU8AaKY+/lVXm4IaII+KjCPgQRjgXhS4bmRKNaToFnbfnyammKJdqDnGUBEOncNXsPeuzaaGcKCsF+gFQCn2bm3sfLlmvX5JDk1QeLetw5B7DZrOrN97hHASgSfEXxjgx3PeWIRKofKUgrIkp6iFQFtFkFOkKGTi3t4CFkrzjVygGyhsPhKxVS/MWGVaEwj4OlXkXxqo9Vb03XqZblov1hCOT88toVRew4W7mk3N/peaynduVzmIH2KFo+L+lTrTJSdz1dOI0jG6gGlpPK109fPy0Kfq2jxNhERQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlUMawGKxHnF/ggaGzpm4roYOYKIz37OtmoFCQVwhYA=;
 b=i+ndSnp1pM2bUoGuelAe8a+nY0+2TTsmUVK1KwSxGQT5PFbXjHBDc/AN60PUAzBcdvN2Za8/64E6xImR9C4ugyBWiyhhLgSSWPLRKOkh4XsTabQsgMpQxFC85fMsxumaWHy4scYreFLygqXqpP6K4UP9ftToGeUZp2HuPStykg6wfPfBGcxObWEOUbsaRUPpgKZzHfLNsweq1ADecnU/3his1YQEYIhfK0sXiIcK/gsQz5VaieQnscM4YZhqpPuNMgN3iQmteyN9PG+E09dUp38vthP7+fJDQm0kIzI4hEjiUf3UYEqHw67icJUMIfXUEhEDlQP7Nc9u2F2j4LMaTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlUMawGKxHnF/ggaGzpm4roYOYKIz37OtmoFCQVwhYA=;
 b=d7Mx7NuVSl3usDYttPW86yOJ3HbaJGhfAqRNL4VraTuMhzwQ4WDy7GVIz208jrBja0WSxK8BEAoxndtzJGarkNIiPasrbfOGgqTkjZ9QLkfyNy2G2CPGZY7+dDFnrYnKloqYAZFB+It5Ga0WnFKMryTNmty4fp4l/VSzPcDflSGimtokrJUSFP5Q6qheKx+iW5GEGa3Wb6ICYMX3SUVuW5ztWiz6wQKYUb0CKdBzNAkBaB7EUYxuqiIfoivXdFLnvMI0UHGZX+JbPH52be7HJy4OzSkqIj85fNmrV7XSoEYkiiKUIZsO19qup43cggHoEj5KumIQN7g91EUT90q0YQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by TYSPR06MB7157.apcprd06.prod.outlook.com (2603:1096:405:8b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 02:13:48 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9073.010; Wed, 27 Aug 2025
 02:13:48 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH] nvdimm: Use str_plural() to simplify the code
Date: Wed, 27 Aug 2025 10:13:25 +0800
Message-Id: <20250827021325.61145-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR04CA0006.apcprd04.prod.outlook.com
 (2603:1096:404:15::18) To KL1PR06MB6020.apcprd06.prod.outlook.com
 (2603:1096:820:d8::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6020:EE_|TYSPR06MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: 88d7b49d-0996-4184-6609-08dde50f5b8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tPLPK845RnU8Dg9IRCTA8vDHUgGMWQd2kMaBKwHlH6BlBtDQjQEBfiW/GfEw?=
 =?us-ascii?Q?0mNgmW1Ndd9AFFmFViCkNNAUISOe7YYwTHK52d1qeycfD8J45e3P/FeSFkiB?=
 =?us-ascii?Q?AA76X1EvulqnIm7zNeDLAYY3m1AGLR5oknXPWGcReruNE2XGlwTYY4acdXJY?=
 =?us-ascii?Q?FE+fUC8W6TdbG3JKZThpEEvXjKF98MlNjpJmSQsK0oPqIh3F5WaUxzz2KhHa?=
 =?us-ascii?Q?psxsoEFe/0fIHaNbDXwYbv2CCOCH82dyULMPuAwXLwhMm2sBrULEWYG38HZ5?=
 =?us-ascii?Q?69rpfaXgAXym+NoC6PRdbLT46++9GAnaHdU+l4tGPUD4ZVdZQjkgkTiW/WQ7?=
 =?us-ascii?Q?Kxuk+4kRkXY0cllS3qJJLsopLn13Hi8pRB+athbzRrs2tL3FZvp8LjH5Mi+c?=
 =?us-ascii?Q?LoIFBqRkBoxy8Kh7kYQUIme2zNz32Cp73z9urbFdjKup5t/ExNic/ZcHVBMo?=
 =?us-ascii?Q?idX1IBoQ5MRPc3bxloDbBAE85s/Iz+jYxWSorNDB7H4Az9Q7/B4VKRBq5uZq?=
 =?us-ascii?Q?7f9iORtRZiDA6avEIYxHQkpI0HPzz0lPSZ604tKkY8VX7Esg4TPaXs19DgaA?=
 =?us-ascii?Q?SsjZhFTMPH2eIVpuztM0BqOHNE9MsgqgiejM+dAPXSRO6+XRiVlrf1Ar91z0?=
 =?us-ascii?Q?Jj/WusIx5v4L2GYPDoiulR5knyA6xCMRpZ+KcEDnp8ZiUih6nuNuD/8AqGZh?=
 =?us-ascii?Q?6Sutx276Ksb4H79z9yYYtCd0xJgiByeveiaxyCluDigWL0rjgLm3t3wOLFL+?=
 =?us-ascii?Q?Ewg4R7bLGnwN8jXorssyVVUhRaDSrddxryVsrMzHTQo1BFIRSJ+ePfg/YAau?=
 =?us-ascii?Q?Iao4WlMsnK2ceFsSh3TxeV5n69v59To5IDu8dcan5e2Zu5EoJjtTAhsJoEvp?=
 =?us-ascii?Q?niBQc2wEPfymeeZSf2c4bz8tt5JIcEfIxM3Yp4QwV4rdNuBvYNi0uhWoGLpU?=
 =?us-ascii?Q?UUB5S4bxHGqrsK0qBNI38vJZ7t6gUZmNeDJu04JyfRQ/bGf9KBTG1dbd52Z3?=
 =?us-ascii?Q?EkXwPv6eWTGp5dXqJtvGhRFiFrdzeH+trJx4cyAt5mNqZzqnEdXxkeXLFw+b?=
 =?us-ascii?Q?Yt5ztWHpFwIrNl4+0lWsfg5A/+5poNYEV+IeYDXrXqsR77lFVrS71u/r7ysg?=
 =?us-ascii?Q?KvcbwrTReDyVjw06sdrAPhnu5iNFhaxbRfaXDP7TtQdK3ie32V9OnE2pW6Ib?=
 =?us-ascii?Q?DKZ86ssw1N15Jyv15+b/S3LSTSdZWpuOcwLPdwdnPbb8riILX0d7Zc4Lg7pd?=
 =?us-ascii?Q?QT4rnksMSwgni2Qoi1O8874kv+8OvkfMlmVcAagVSQ+YywI5+alPmIFn6fRd?=
 =?us-ascii?Q?OFwgQ5LnfAcnwahf5xOFatNtF/lUJEG1+ZD1GxzZscw+xONbCejY7TRUBSbU?=
 =?us-ascii?Q?Eglguo/bGPBZh/OFUxOH2OwS6ciT0F0tnA4B8oZlcQNI58a79upmysAHvFhe?=
 =?us-ascii?Q?+JwBBYLY029K6QsrhorRPYFKsA1EOchAeMdoPsPih3uckhHbGENFIg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ABQ5UJsyEDiAfMmi4MYgCMlRpYNiY/9H3U0l5Ctjq+T0xWlH/RJhquT66zHd?=
 =?us-ascii?Q?AUu3wLMGI7pVwQjCNePlF/5k1J6uJtUlJ4DqZeDxVtpOrMbPxpBcbpRFVwG9?=
 =?us-ascii?Q?ZbkhsUYPi/WR4If1CQmprgDsNuKKyHIKQuPraxrdUfBZwYomxfvGRm2CC9qk?=
 =?us-ascii?Q?Fyhs+kHWS7Y6Ek2C6Jykq57ufs4w7e5yonEFODcKBe+8dDLzHvRMeBLxPJ4Y?=
 =?us-ascii?Q?GqVejN28kNh03Z/fjtfNcrAiASn5pmYOuuXwhGvdyYGaFtV1/tgF1WgVq0NL?=
 =?us-ascii?Q?OL5P3JqDi+MNilKbCpy2Fqlemg0IvdVfHLuIPRsddeB4TaA9Yx/aVWYYeZsh?=
 =?us-ascii?Q?K0lmZFKoxqbovt9IOBlTYUHrDzRhFbyBaXqcczP9+k1VWTKvihG71BgsQCTg?=
 =?us-ascii?Q?taDFwjh+fKiCYuJ4Mg2dOywnkFYtTE1a/ehNZc5XBE0pr40V7NwRPNKWu20m?=
 =?us-ascii?Q?076vCd5eB7OobuuGCtjW00d+6LhCJHQY9gcradfEDXEcYI1Sd5F71TfxUyp1?=
 =?us-ascii?Q?toDMe7OF0OEt1EGuvcoHC046gk+APcfjlqn7FMkgm5WXw7JkCM8ATCrMu1gp?=
 =?us-ascii?Q?48K06FmO0XCs1J1VmieuJWZBrgU6YLi5GJ7ovdZLQXtUKLVNoliWqvyGx9OG?=
 =?us-ascii?Q?Kl0SI9oIEPl2ux0Tt/GbUYadejVBNZnoAQs7NHj73hmKzDbkODedVyvsiCbU?=
 =?us-ascii?Q?rLNW2vb7B6RTVJP30tgpc8JoWo525/IRczRWiwx9Hal5+j1XH6i6QbYXXXVz?=
 =?us-ascii?Q?dCSRaSCUzph4W0gXZPFO39e4ujOhe2cFcua7Rp8L6CKHwmtm3dVYQZknbiTO?=
 =?us-ascii?Q?a4+nIv+aORR0RWJ2c4TyuLv/h7mVFBd5h8zuLqzsGmykyPb7YNjPhpXHX3PO?=
 =?us-ascii?Q?Q2/pWF14HWUi+kblmfc29wkTa9lX7UVU87AndKIUVnO/7IjlueOpqCrMRIlS?=
 =?us-ascii?Q?JiE3iVncAK6ODvYQD0VURXnFDOKXzauZivtMraBKkdvRg82Cm11iWVn+tGKV?=
 =?us-ascii?Q?Otxt3KGt10eY7HN3/Uhuqt4qhGclwc/J7nKPHPv4PdTBz0msyKKKq7W1MwG7?=
 =?us-ascii?Q?Lf6ST/1DBB4OmiUU1C5SBvsUQg0CEDx/oI7Vpwcnxofb5idxFis2fR7f7MiA?=
 =?us-ascii?Q?gsWEXj5E9sR7xhZcVAp+MQzvoUqsapS6IdbN5QD/wAT5SfHMCZHPYk8pbhug?=
 =?us-ascii?Q?AIakvV2okKUSOKp3btfqn34ijAXvrbN5v8gbwK6RvHbfNgo32YwdWC3KG4Zz?=
 =?us-ascii?Q?xvxEvnfTcTCan76PcHgUznY+GSMUWg65qGW+QPS2UXQt3iM+SCSqYg6W2VLu?=
 =?us-ascii?Q?IFvdieuyU9cGt2k7gBPpbj1H+oeDiuJ+uLTu7CHZ8WfQ6DRM0n+fVbkZwdeQ?=
 =?us-ascii?Q?J4TaKSrcQc3f+QOLP4FyHbX8kKQWcY3ncBykD4VFhJq/D6I8Bbc+Nvj6JYdU?=
 =?us-ascii?Q?fHA+07zkKzdIH3t9frKYz/zHs211RQLvpOFtdq1X9kXLde0v7a8hhO64/rG+?=
 =?us-ascii?Q?estrOAV2qhFtAsesNdvrlJcvyMNTOgxP27Mk87MntxaTqdQ+3L/bCqJWyXcM?=
 =?us-ascii?Q?7fl1Rrg4wtUIXea0Cu14lBjriqbwG55t2VQqEVv7?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d7b49d-0996-4184-6609-08dde50f5b8c
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 02:13:48.2353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eX/SAiJYembSUpR9p1HV9DE8S6/wg/g8jLAK45OHQUnwve+OGsWevN4JBqjEjzYEf+2KtucwEUDy8bE4qI7JqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB7157

Use the string choice helper function str_plural() to simplify the code.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 drivers/nvdimm/namespace_devs.c | 2 +-
 drivers/nvdimm/region.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 55cfbf1e0a95..507dcae9dac0 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1983,7 +1983,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
 	}
 
 	dev_dbg(&nd_region->dev, "discovered %d namespace%s\n", count,
-		count == 1 ? "" : "s");
+		str_plural(count));
 
 	if (count == 0) {
 		struct nd_namespace_pmem *nspm;
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 88dc062af5f8..68a26002f8b9 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -70,7 +70,7 @@ static int nd_region_probe(struct device *dev)
 	 * "<async-registered>/<total>" namespace count.
 	 */
 	dev_err(dev, "failed to register %d namespace%s, continuing...\n",
-			err, err == 1 ? "" : "s");
+			err, str_plural(err));
 	return 0;
 }
 
-- 
2.34.1

