Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2123.outbound.protection.outlook.com [40.107.215.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159672C80
	for <nvdimm@lists.linux.dev>; Tue, 16 Nov 2021 06:44:24 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGVYXO/heikiuYrsbyLEiwG2QioUiFJaQB+qHRzVfx6/Jr+/ou7hJZrFEbnH1TwpCU7g68VtzU+e739/pLE9+OOUj9wHU/g5OOQZbvdeCTb/sy/3gNVxmeuHcDqyYg8gkIYy+E9vL6azCltSZWW49EAYSxE/6X9cc7qbXCkUH4+DfyWqofNoH0yjWJlcpsY6Purz/uhDmg64p5Ooml0f07OCpodmTpHhCgVXh/sa8kDtVcJp95hDJS2oWGHjaHuzsiN0QFZKgzamwK3aHRd3vB9rIro1RNvtP0v4puLKztUC0kXM/CVunaVeDRWS4jud7fdYG60pgcDXXNSzlM6uWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MEGkmWs5b3i/VohxYy4fM8Zgpl/FZJ2ghxCgmr4pdZM=;
 b=KtW2UK9M56iyE/y4mTD7RzXgW2cajm7LHy9YUWN7a2jXmhmu1sUIncDC5JUory5FO7867OxEwPGU+sDTffulkK1Zy6eIWdaOEOELvuWVWbQMQNpM76EZaMXA4/sswYyDxy2cVIC6NcZwt1tq+e9hc9vAwJHUTvSwrHyDtQE7YxScSdl67XPw81ZMa7sdWaOM+hqXG299nT35CFKQnauMEyflkFAyXRKhWt4cVuFP4jUwrTjEjjRDoV1ceoE2wNHfLHbMnKkfYfogRujbZW4S9nQLBFtHeQ9ezFS+/9o8fE3xoxrrzvW+I78a6o7TMh2piBR6R3bmoSrryAGVbEFr9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MEGkmWs5b3i/VohxYy4fM8Zgpl/FZJ2ghxCgmr4pdZM=;
 b=US4rxpsDt0KJeN6Mq3yUL0zLRk+q8PqGXKK0erxG+SJHi46FDP+CXp5GZd0QRu5bTfMzi9ucE+MLIIdVK7WusBQe4I5iyxOdtdaF3+HZKT46MsNR+9RJfFDjYX0xJVyXSvrxgycRMnTVcJ3clpCtykEGMg+aGF3RVS5D5reitdk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com (2603:1096:301:37::11)
 by PU1PR06MB2328.apcprd06.prod.outlook.com (2603:1096:803:3a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 06:44:22 +0000
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385]) by PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385%5]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 06:44:22 +0000
From: Bernard Zhao <bernard@vivo.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Bernard Zhao <bernard@vivo.com>
Subject: [PATCH] nvdimm: use kobj_to_dev instead of container_of
Date: Mon, 15 Nov 2021 22:44:11 -0800
Message-Id: <20211116064411.27877-1-bernard@vivo.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0059.apcprd03.prod.outlook.com
 (2603:1096:202:17::29) To PSAPR06MB4021.apcprd06.prod.outlook.com
 (2603:1096:301:37::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from ubuntu.localdomain (203.90.234.87) by HK2PR03CA0059.apcprd03.prod.outlook.com (2603:1096:202:17::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.14 via Frontend Transport; Tue, 16 Nov 2021 06:44:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e975258b-833a-42b8-ea3a-08d9a8cc857f
X-MS-TrafficTypeDiagnostic: PU1PR06MB2328:
X-Microsoft-Antispam-PRVS:
	<PU1PR06MB2328DD05CBDF189ABE616725DF999@PU1PR06MB2328.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fUfmCtumNNah4g94QAh4b9ikz4P4sQgFR8eGxvBLYNViz9eAubbCDmPY3zlQRDATkF8dp1DpvFsknMuhp7yaUnW5W46Q05esqCA3Qxrp/f/X87lHOodib6XjtMMC8rSJPsDPtEddnNcsBsXHMJFcSug8fSYVewx5AvD805kPL//+7QgJaHV4U+K8YZqsKaDQ6EqrRikSuFNOv7eJd9aXijhsaGxbc9zgH6cXIIK3FNrjcSYftwzn1+wq6FCLxmpgv667ry4XhYHorFb7EuazyNpz8nODEFNjNYSpKKEz4ee5QvJOfLmDMUxfSMmWIpMygzUkenA5IM95739DR33EgtzffFM4GMQlWxkLtTIrL48948KIeKJpmyGWnH6u7kDxzT4rbtqTXsbLXNeL6Ik5NtgC7c4SC2nZaZ5QxAFNpyXX9bhWYpRevRwiqWvB4LPXVFRB3liIga2ORT6koT8l8sy3e1Q0tZn4sSXwA005uFpB40mJpxBlQFqI4DKYio+U9S/zxm5SRLwuCpdoj9C5F6He5HXezjcRzltkmurldnWTiaibcouEdRnAqhfPuB0+hEF6mjBroEWQGf9cVvbMKcWcoGUndeibjl8xRjTC5C/o8iYd7P3Wdh1BrnhMHULQ0nDq6xitrJZFjZ1+ib9HRyxN4fS0BdNkL866tJptnhZX2jXRjoKNLRWaQP5lVTLaC3roDiPDgMvj6NcrP7FxhA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB4021.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(956004)(6486002)(86362001)(6512007)(2906002)(4326008)(5660300002)(110136005)(66946007)(66476007)(6506007)(508600001)(52116002)(83380400001)(66556008)(6666004)(8936002)(8676002)(316002)(26005)(107886003)(38350700002)(36756003)(38100700002)(1076003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T3PMAUSzqI/WQDm9DmtDHsSw4WPfCy4VjcOnxnfADICLYRQAnZeKCrixxvLP?=
 =?us-ascii?Q?pJkwBWVhC1LJGBHjHKKN6/RoZCj3ANHsF4kWgChx5ScpvpY/hxB+Ykb8KMGm?=
 =?us-ascii?Q?FdTKWCDwfbAKii0yNjWor0jJfn+1jt84I29+1/rbd5UwleZcwAnFmV9hmyH3?=
 =?us-ascii?Q?b2bw230O3JraJbkuigWlbNRfVTaJlhr27ckp2wlfJ/R9ERtqX+vfyLU2r8xW?=
 =?us-ascii?Q?8G9PqPXlMVrHp3+Lq5Ip18Tt7B59bMb4K2I8RmFSUs4JG7CtHy1zcfqgbxPC?=
 =?us-ascii?Q?ZsARCJDOGOWqN51seYZAS9dgMl/NmqCrl2Jj8W88wfwU49tArYXh/5uWM7tp?=
 =?us-ascii?Q?P22NoFbUzcNFE/aiWuyBVmgnWNZBt/K903XHqwkonAPRnwv69FwKmhexthxh?=
 =?us-ascii?Q?wEr+By8+MJill7APoQoeSSMvopp/MrrOQxBMXH2tlOoQ8jli6VE7c9BX0kUy?=
 =?us-ascii?Q?Vaoyis8iUbon0djY+nImUP2IIL2cyVIFRplBzxRMQJhQe5G+lVCyjgj5QBGW?=
 =?us-ascii?Q?/gmn9a4BHnQdlas4TfWHpC5BR+YUiD0+bbNq3y/gss8F7JLVWOxSjsKZj+mk?=
 =?us-ascii?Q?ySGWPJn6S5XyQm8Oka3tggiWS6mN3/gLzzmxbRHFsRyC+/YWEVaMWXtu0q8D?=
 =?us-ascii?Q?fWZMQwPDCEldIfOKXuE6vMGhEK6iIO9MGtIRucTwY+tdg6NJtCREKScLFSXd?=
 =?us-ascii?Q?ZPH0LVzXsuWIyhZMy3VuvCmM6oEqvoUwRO4UIZZ3EYEnYlj/v2WjetoF9/Iy?=
 =?us-ascii?Q?TIxHlIowxElGYSg3JRSUfvPsC6vm0Rdvzo/skYaJJ6OSZaO+jY1wc+BDP9X/?=
 =?us-ascii?Q?iLXUpOdyN4wJrkKGbUwC8H+w+mIgd3dPqqiJzoS+kgKJESXgJrwnosXflT3F?=
 =?us-ascii?Q?dRmBMxbMtHuO+g2zUNGcHDTP7dYiA5EM5vDOQC6JvsjvIQhHbzWKsQMmDBMA?=
 =?us-ascii?Q?yO0ZuSEn6pzQ0OIN9/1QMIxMKRPuq1mL+PbJrHVP+eSCeBlUc0WZv0a5n0Ax?=
 =?us-ascii?Q?P7Eg9ULviGuh//0sGOcVQceZnJAT8v8HVBl3UxQ0debr6ECFQNePU9BBJWpw?=
 =?us-ascii?Q?+sIsIwSB9LGiBxtRnSCVQbspu+UB9zfJEeWcCEl45OURAT0oW4OCxhCoS9kb?=
 =?us-ascii?Q?3g7bhCf1XjxbZ6mXf3SFkVZ4FWBmZ/ED5SRu/BRFVqP1L0bcISLUV6i9OGgg?=
 =?us-ascii?Q?BsZ2AQ7HgrBeH/vBrUbSgx4YOaJ0ujRX5Qr0+czZ+c9bRTCgyYSSRTrP/Fp9?=
 =?us-ascii?Q?R2fR25wiTFzwpUpX2ifjSdLzOPM0MEIAYz+JBSGJmtQpqA0NfUxx968miblV?=
 =?us-ascii?Q?xt+5lMfn0pOB8CmKeSMjLPnOGsJV+61FibftIbkwNOMUNRUSOjtb/Bdnr+3n?=
 =?us-ascii?Q?BCNv3gng5rBwFK4GDzvHAMvLe6mtRTiD49uBm7Ii+XAR5O+fMdrutitXN+ew?=
 =?us-ascii?Q?jbYkt2iTRPm15Q5yJ+uGz7fml5v4Qhcjbo0lyU1wHj1nluEmtJBHhpHM+WwC?=
 =?us-ascii?Q?XnVWsQD4Zbd7X+3RUbvNF+inlaKhbOTyaefUKvCFHgWhXyLLYwSoTKJ5eKOe?=
 =?us-ascii?Q?0tFjqhiE/phR5ntnLC7hyKcEATnPnc8YkZyScFACgYJ+Li04pEqCRKoRhEB2?=
 =?us-ascii?Q?udQmG2pmQ1fu4FC5RKmSj90=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e975258b-833a-42b8-ea3a-08d9a8cc857f
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB4021.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:44:21.9060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5OCaVNfmimOSIxPbtuTFx/4RrwZo60NiHfWUwYxNFRcusd6U9dEN3Dy21pe54Um4YLHZmETEdHJbj4EvJx7/Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1PR06MB2328

This change is to cleanup the code a bit.

Signed-off-by: Bernard Zhao <bernard@vivo.com>
---
 drivers/nvdimm/dimm_devs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index dc7449a40003..bea41bb5f830 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -430,7 +430,7 @@ static struct attribute *nvdimm_attributes[] = {
 
 static umode_t nvdimm_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, typeof(*dev), kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 
 	if (a != &dev_attr_security.attr && a != &dev_attr_frozen.attr)
@@ -546,7 +546,7 @@ static struct attribute *nvdimm_firmware_attributes[] = {
 
 static umode_t nvdimm_firmware_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, typeof(*dev), kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
 	struct nvdimm *nvdimm = to_nvdimm(dev);
-- 
2.33.1

