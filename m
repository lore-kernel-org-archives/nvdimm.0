Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2084.outbound.protection.outlook.com [40.107.215.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13E9158DC0;
	Thu, 26 Sep 2024 07:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727337437; cv=fail; b=gOpCjNoWJbOHn/ROeWSqQDInpvg6oqEnPBbFBCP69bMvhCv4U/aqqs7hBLQAD8L4hIvPOIPsiHkBRqLJnep9f3Cl5Qh3NJmte1ViXoMCgE34ECUKHhRmifL9B0kA1sR7epMEvI7oGwApbhcXzKxLh4xvbLYw9QICCnJmWf9oMVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727337437; c=relaxed/simple;
	bh=CNaOkb3vJQElLFni7E2dIixaAHK8DdeMCkmeqNwM2og=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=pjUxa90Lgda5pTP9+eJMk2cpE21OXR+z56L01myxYNvtoF9vxL3xA0gabvBFzYBTsLfV5gQu0IDEtNCDd02H9R5sEYzpGZJuaGEbRi+S4pxQ5hq4m54APzsTxaSU5XAzK2+2fb4nwM3N9eC0qm4tm0Oa8bdDzNfBJSA8O9hhnHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=UMZxMpdV; arc=fail smtp.client-ip=40.107.215.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="UMZxMpdV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xi9EBJpjNkFNH7n8qoxKhZLaQsMoXQVrCrOTQyBVWujIVYAslu+Qa8RSeajffnav5BRtLvIANnmersqF8ylRAg+tuT45PWknqJSNtu7k0lDEdOM34X+p+0ulwSDlykU78RDe6s1H8fs7jH5pHAYhVL73fYMz6WX5A16wlEHL1Q33o9wPb/RY+NXjzWTDE1qzdzUQG/IG8MXe+CUZjCkHPgdo5MzPQ76Ln5f1ajxCfUaUd7lHHfQFrjGgB68X+BC1Zsr5UZbtqMIgyFy2LNWUSRSK8/yAt9wVE1uK4+tY1bA+6fIRNcQmbvU8WrlAbF7ooR9suH+5xga2PYNVk+JdRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFSi/6MPl6CjRQBCJt74jpCnidNEs5yyMkUpCOLWOKM=;
 b=u4qIg9d+c4vFK/mQR6mHDs0ZZ7F0mm8Ki0QSDmkkcJDim35/L59ChCHhGqEql7fMWA++388KWizB97GlbHRrF6iA1BkvG04OKq+0esX5xm1fqEerWg4ERJFcT7S5LeNufqHn9Hqlg19GYiWCKZDWbnvUpiC5F9cPu2ZECFuTCtDmARXmKGuDbuMOivC5L2plHfcsx7388zgKvg0LGIxPny5lhGFkBeOKp7FTD8wzWpglY0d7C7IUlAEGGQndTLOVri5d8kYfKd2kK3Poy0AOS/jlWpvLOgAm+MUcITAmCFHDdjKAWcQtSBocKTLmPEiv8mCg/q8InGHyJm0lVUtxcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFSi/6MPl6CjRQBCJt74jpCnidNEs5yyMkUpCOLWOKM=;
 b=UMZxMpdVQylzqICTEMxGf7Eeefm2lFpRedn/+XUcfvbf/5dvImIVx0Q9oQ7tWShXTcDIMDkk9gJE6az0MK2XgdNiC3m1FBIlNODKGuvY5Nqbn83IVVa4sbbchVmZF38rD2rtOoPSikU6g32MkuFLDqL26Grmy9nWUQ/E/SkVCkb/pc1akCa8K06sG/jU5HwqSZWUvYHQ0Gh2jOTTGCMB7N3B7hGDR6wjLzVXQORHpxn3WFmfGizZQ2WWUnL0AmIL2UIVu4i6LEcJanWl5RWI7lujzlLMIdVO8feH8pN4A+2bv7ipGNSYhSG5m9BHLM2JlQAXY/TbitVkgWwNJRJg4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com (2603:1096:101:e3::16)
 by SEYPR06MB6484.apcprd06.prod.outlook.com (2603:1096:101:171::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Thu, 26 Sep
 2024 07:57:11 +0000
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce]) by SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce%3]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 07:57:11 +0000
From: Shen Lichuan <shenlichuan@vivo.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	pankaj.gupta.linux@gmail.com
Cc: nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com,
	Shen Lichuan <shenlichuan@vivo.com>
Subject: [PATCH v1] nvdimm: Correct some typos in comments
Date: Thu, 26 Sep 2024 15:57:00 +0800
Message-Id: <20240926075700.10122-1-shenlichuan@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0015.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::15) To SEZPR06MB5899.apcprd06.prod.outlook.com
 (2603:1096:101:e3::16)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5899:EE_|SEYPR06MB6484:EE_
X-MS-Office365-Filtering-Correlation-Id: f03e54c9-0571-4f9f-be11-08dcde00d3dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vk+PYtKrejafvLAsOMs39Q+v+OYTDD6qFtTQGo9UCE1krbvWJELAFnMLCcUE?=
 =?us-ascii?Q?y0Gqrh4hsfr5kT52WxUbAV9fVRG4vwjMy6VT53Yd/lrXOMJktIQXZE1+5JM5?=
 =?us-ascii?Q?yC1Gyq8Y3QRYyd8wrKgTa8QBSBfDEdQlXaCEpEWQ6DbHh0XlQqpIqPXLGfsR?=
 =?us-ascii?Q?dXcqlgwhj6Bo/GqF7pY/GweXshYicBwNk65xPuE70gmuH86e9ckGI24hO7KK?=
 =?us-ascii?Q?Cc+0Mkyc3N3+CVMSW55gGYXjpmuAaByWBPBwh8e4FydJkdMePcOF352fr3Eb?=
 =?us-ascii?Q?S4/j/5+p8G6I6wSebJhcng5XlKpDJzoGwcnzcbxDHxzemeOK/9DIrbLjq6I7?=
 =?us-ascii?Q?o/3PH27sT8YaQqMtv0LyyhesLlp8kV26Y4H/NC3T/iDE9t/USUiyT4PvuvKg?=
 =?us-ascii?Q?eeHSULdmoGpjrCuf2WMfj4PQzswiUiZfDKNZq5371CqRUrpJRIzJBTq33Jq3?=
 =?us-ascii?Q?a5dLs7y/j38RrEqSsa7qPZ8FJCaqlyp/ddpBRKN5exUdmkbu6FEzLh2hPjR5?=
 =?us-ascii?Q?vLHBuDjOxNAUHuWbWEKwj2jAFs/Vpy7axzhuxu+VhbV2ZKUq3OsSA7gjfQ4U?=
 =?us-ascii?Q?MBfjy9PCtfRHzSYBFM2k9ynP0+/jREuBxLEBqwa5JXaiRS7GBrubhgu45XKY?=
 =?us-ascii?Q?7pW4O1jbPam301X8C83wlKqmw03YTKd6e9p7GpGO8+ITe7fBw90yryD8KGe1?=
 =?us-ascii?Q?KJZnTBs1KgIPzeEoG7qLXPXyD6Py1MDSnnFy6Z3IThNeLHuw9cyLy/XsQy2P?=
 =?us-ascii?Q?8KNsl/F7G9q/YgYIzixmBGGRKC4UuCznmH998vm05Td2gg0y8NHxDTD8zCh0?=
 =?us-ascii?Q?6SZMgN13vYtJxlBVvYRNTKIjA/1qjM4Bwhm0rABmnYCvVaNXxGTi6HCfczF+?=
 =?us-ascii?Q?lQhUbJiSHpBJdZ3ZotDVDZK0rH1opdTgjHLGPyHrIdANAjWjn+H/OOqIfkhI?=
 =?us-ascii?Q?aDEO/DQdDx2SJej4qJr71q/WU2/cxDUOC9K4u6s7c/sKP5N0mdkgYX5ZDsLm?=
 =?us-ascii?Q?F6Z5KDc/nYcqH01zCZaxdCqYxk4nAVa1bR+Q2AKSqZ+ZdvAjF8SrNt/VauMa?=
 =?us-ascii?Q?85nIutaOBeCq9l4wbrZ9xzmD9iM2TqO+s11R5WECmKj2XYk7Zm4dtNlG//4I?=
 =?us-ascii?Q?588i3IBirLWz3kIbGy7Sk7MtpHRnw758Hx4Ho5m8Z5IPB6qbXGsru2dyg0co?=
 =?us-ascii?Q?oT77SphIuu+9+ZtMdDx0+rmqn5Zu4nj+cogC/oDnR5i79BsWeCVre2WA6F3M?=
 =?us-ascii?Q?1nCUqWXRVdr3pJz6P0PwS9prSEkWA9AfKcgZX8tGdmf0fxwuTHB3LeO3SAgD?=
 =?us-ascii?Q?Wdzdg+wG1Nq2ErLXiY00T4N0yWZLFiufUEwSFIRFCvVrRKXm6bGmuumDXv/e?=
 =?us-ascii?Q?7uDCYfR5q5rtvv/keuT4ndyGWrJEfpoW0xUBzpWK/eVTzXdu4Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5899.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D+CcQ+VIz8iQy7yW5VJMQQHIH4pyMYuCiiaElz8GDLFaJfTl/wTKOWFuLMW0?=
 =?us-ascii?Q?WSTsj4+CnoYh+W/lShGqIFDOVMJftzj1EoiKUS3qd41VpsTqSkKTj2zDWiht?=
 =?us-ascii?Q?5F1H8OXoYOq1D9+psV7JlRIpSWK6eXec9SlFRcBsAPuw+i4A3fMQKtRvmKz8?=
 =?us-ascii?Q?fki+JpIc42IcSL0ksA4Ec1pAQBqrvRGKflqvM1JeO+KM7UbdV28Ky8fE/ISM?=
 =?us-ascii?Q?IpDe+0nOdwAZEXQqIGK9vPQCqSfp+JZ/eDs5EkcywB0V1HeXfUQ77hfwfPie?=
 =?us-ascii?Q?BVcHKhrjLhy969gnCVg1qOqxafSt82yrDgkxnvizPJaRIijcvTOl4QymqSP4?=
 =?us-ascii?Q?mZDWpzL5T/UZTngRZkE7LjcL1r0aWFx6oft5zw39C8qf8a9gFfuSMKIVEIvt?=
 =?us-ascii?Q?OERES0J1T9SNlYsrLqm5s62dDeNglt3r3tuUpM64ELnqvrQ6Vdirzc377KGb?=
 =?us-ascii?Q?gXO3qBhMmh0U8hEUt2xMNGWGFsgWNqjd0z2Cmepr06WKo/DyHbT4HLs1czTw?=
 =?us-ascii?Q?aGVI8XfY5xa1rY8Md/Hgqv0mFgUDzbEER4NoceOD/gF3sYAUK5Jxl1QcJ+ab?=
 =?us-ascii?Q?kceRK6iHcF9ULKjMtUq4hz0As13kyR/J0nz7R01jDcc/vRWyvAkVTQbgcy0O?=
 =?us-ascii?Q?DnTKjFjD4FCsAUIoF9Nm6gRmCwVbHIsDTM0MzxGLlf6Mo7P8yX/PLafoUtWN?=
 =?us-ascii?Q?UEK1LHI/VEeDTvNnxRWJNgsNy2mZpWAmHJuOiuDznYgj4iuLopW8EuHuq10r?=
 =?us-ascii?Q?RMpf5w9UW9/lTDAQ+g5KXCIbt36oFsKIKY1Lu4wjRsCpZeGyKsBCf0OOtBYf?=
 =?us-ascii?Q?lh+8dH9Q27SQ3Y4ER6r9HpgM+vuPijLQr6tvLVFyD9OimHMNyY73t4FVc7z/?=
 =?us-ascii?Q?oNAuIKSUE68GePIgVXGyTRg4weK77zyKn8XRS0u0hn7eapKU22wXRiwCkezm?=
 =?us-ascii?Q?5h7e4CjyePwyqhiFefHbdapVUxqhyBQ7qp07e6bryHXXrj/CPLxpbpP9XM71?=
 =?us-ascii?Q?nLw/b8maZjt9vjh3H6Syzb4A4AsgVb+Ee8Z2ou7lx+pzUKaTk8qZNNL0Sh4F?=
 =?us-ascii?Q?qJudBZtDWT6hmm0ub9R/Ji+JUNOSGDlO/LjmLWEGUghrgvLk3VtxR9ql+Bpf?=
 =?us-ascii?Q?asv2zXe4fkpvdCUNvfEyGhCpYskdUIEFpJlAONrya0dznnpAFVb2SNUIJnFJ?=
 =?us-ascii?Q?FipTW8CfbRXwXZl7cpDdSpWQuSy+m3XYjI9lQRyjIJZ8qaggCjN1oq23ageH?=
 =?us-ascii?Q?b/7Hzn/LD6SX3LUPiU2gS4Ub8Fjisd9K0JI5evVbJ9dyJLmhSAqVVKLJLQOY?=
 =?us-ascii?Q?NEsnGn3xVsie4gpf4AQUiXs3AYMN5qRWRhRHIyELATYMUX2pauHuXyCR1XbO?=
 =?us-ascii?Q?e2UTKiQ4gItwlZWeDDqzhcde52lIGuar8b0YTQKAu5N1ULC2s5lmxnaqFFpL?=
 =?us-ascii?Q?NGjxrEnYZAT5kUUgT/EaqydPpJfVSzhdnaVu/onpmh2gNaDoYnKDu3GH34as?=
 =?us-ascii?Q?Lc8FqZHUhwpKLaXHHMipSmcUYyHEY3eNiBY9ixgymG7LQMVOzh4hCO7SnKWw?=
 =?us-ascii?Q?1ik1J+AmHrmiO+JA+OJGyjR5K0iK68v+KOgo+bU4?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f03e54c9-0571-4f9f-be11-08dcde00d3dd
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5899.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 07:57:11.7757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBwwfuvIKgqjONaZuXzWkCy7se2nGPiVWeizONHXWWm1c23ZJN8wFku1gvItQBOfGx6phK6fL7ijJ9W77KRzDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6484

Fixed some confusing typos that were currently identified with codespell,
the details are as follows:

-in the code comments:
drivers/nvdimm/nd_virtio.c:100: repsonse ==> response
drivers/nvdimm/pfn_devs.c:542: namepace ==> namespace
drivers/nvdimm/pmem.c:319: reenable ==> re-enable

Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
---
 drivers/nvdimm/nd_virtio.c | 2 +-
 drivers/nvdimm/pfn_devs.c  | 2 +-
 drivers/nvdimm/pmem.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index f55d60922b87..c3f07be4aa22 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -97,7 +97,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		dev_info(&vdev->dev, "failed to send command to virtio pmem device\n");
 		err = -EIO;
 	} else {
-		/* A host repsonse results in "host_ack" getting called */
+		/* A host response results in "host_ack" getting called */
 		wait_event(req_data->host_acked, req_data->done);
 		err = le32_to_cpu(req_data->resp.ret);
 	}
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 586348125b61..cfdfe0eaa512 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -539,7 +539,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 
 	if (!nd_pfn->uuid) {
 		/*
-		 * When probing a namepace via nd_pfn_probe() the uuid
+		 * When probing a namespace via nd_pfn_probe() the uuid
 		 * is NULL (see: nd_pfn_devinit()) we init settings from
 		 * pfn_sb
 		 */
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 210fb77f51ba..d81faa9d89c9 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -316,7 +316,7 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
  * range, filesystem turns the normal pwrite to a dax_recovery_write.
  *
  * The recovery write consists of clearing media poison, clearing page
- * HWPoison bit, reenable page-wide read-write permission, flush the
+ * HWPoison bit, re-enable page-wide read-write permission, flush the
  * caches and finally write.  A competing pread thread will be held
  * off during the recovery process since data read back might not be
  * valid, and this is achieved by clearing the badblock records after
-- 
2.17.1

