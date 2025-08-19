Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013006.outbound.protection.outlook.com [52.101.127.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3D131E11F
	for <nvdimm@lists.linux.dev>; Tue, 19 Aug 2025 13:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755611768; cv=fail; b=uaXK9n8TV0Cm9bU+yifRZKM7LMctxRQFYEKBTG78sHiMngETeQzwwO2DbauB+IJfOhymluOdgl6RlJdW4xsmIothEdfnRKfgGv5M5xObSM9jcGFsRDvhQQpZITm3HxozFOSDRL76hotxWETxVTC1oh3DqKYT181WLF2XNak29mc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755611768; c=relaxed/simple;
	bh=cCDBMICbmfZnW7cjuvYgF5GGREvjypOmMZrAupOI7R0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=q8QT4KKTK559aKaa4Io113OCHqrt9xJcjqbH1g+XkvxZTtS3GntGBEXoas94WusRrYZjMjU3CQXgQgYSGILpIFqGF9Wzqb05x4zHVOoiiT57KcRVZ4XTcgCxMKrZ59sPlySGQjv4jECugnSxbrDXvLAk6VqBxzQEg3ECqv3OeW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=jzxktjfA; arc=fail smtp.client-ip=52.101.127.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="jzxktjfA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dApAMNozt0vfWf6MksYxl37sKw+gH7O8S25MVKGufFJKCOi+/ZsPxvmsAC0yVxJ1gZFB2lW2LqJpCQ1P3TEVejMeCQVMh95IdzFNJTJnrB84XTNV20pETq5ATywgLPknVVkKrbr/e4VutobiY3C04wNVurDWxaLk+EuI4ItBn+gcs478OknU6hD9IMezGjKuTnXbzjgK+oeVhUwErboHWTfHP4UEiOTrkYnMxjBauShfMdhNIxHYzRkFWdRWNI0Bsf9ToHcGqlooSVXTcdaZWB9zVJsOKAXGfD7uj6eBTCBh8q0pIz9mKkV6Q7mY1aMhevqbBaYKOUpjBDNWJpqOug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AnPxRBRRhbbW91cQFkiy8C8kAvgKBtruGLhB7wubvyg=;
 b=FukFxwUWRmxtSTUaHKvGv4xY+D1HsNViUTiyk5zjiyK3GdbRVLw4yzgopjc9IP5y+eUfD+j6u36UDjk8YIeoumtahtw4TCZu+vO5DExDI4z/fkcHWXE7RoIKnWxgMcBJMXgdu39TpZM4gseLA5OYh9mZPtGFgQLqUD8EuOxDz/2HJUKhYY1qCCtW6Jt3/Owkos051/QUNmRlrkDc+6JDvE1WwVZtJO9uit5o5ZF9Wj3K25v3WzLInx/J/MXGwBfpmYpQN6KuYzKRaZg1q5D8IQQImqtppE5/nPgQ1pk48Vp5aBFOZ7tlYMFPyADw6jYiP0G0u1gDop9CbAlsGuFhlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AnPxRBRRhbbW91cQFkiy8C8kAvgKBtruGLhB7wubvyg=;
 b=jzxktjfA2NZ35bxpRwBAZeRYRbqSQsi4pIweWKew7XuS6LMeX2mwEcRWswlPtXt0mVo6A5I+Ah23X4qlLwd+5exUmwthZgxViq3abLyHhS3m04602/CtF0MkxXdpseJ0LoHrViWgTeyaXKcqkiXw6n2dm1YKvJ3m9UJQwJeaJvLmFceQXCvfWB+MkX8n8kJ2dhf98yUx9HBo1m+WyJhyblmrOhVmUkMHwLgn4nI5P6reAICossgAaJ5bApFW35UOHYS9R7CvD85i2k0RQrtQJdQ/xxQT4pcnyqTO4IPCdXORdM6114h7Cw3AtrYIhtt78jF7t5rETBatuPXF9HRNJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by SEZPR06MB5070.apcprd06.prod.outlook.com (2603:1096:101:3a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 13:56:04 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%5]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 13:56:04 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev (open list:LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH] nvdimm/pfn_dev: Remove redundant semicolons
Date: Tue, 19 Aug 2025 21:55:53 +0800
Message-Id: <20250819135554.339511-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::17)
 To SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|SEZPR06MB5070:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fae9532-2f30-43f4-a2c1-08dddf282338
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Om6kCZA2mxOF/DpCTZH8S+gHbD6v9jR79/nmD8gfAWVMiBpk6SedPn3P9tpb?=
 =?us-ascii?Q?CyJ/uWOpSFt/hNiUg99iC5Gq2mTvJLsXiDV+UXH5ldfwmr7N9FH51UCptROE?=
 =?us-ascii?Q?/DuDa0belrJDxiMEYg8+AnCBv+Od0TNCfHwtPCSoXbnvv3DT3oeSxldwO6YB?=
 =?us-ascii?Q?mksVyij1AO1GOJA41SB9uatbpssgaYRmhSINZj2lqQ3icWxLNQwZj7755yU9?=
 =?us-ascii?Q?ElBQL9I1lezzXGGBiSitsDZWUDa7iFy5Z6YPoo0MCby3EtTH0zYBGF2W+E9i?=
 =?us-ascii?Q?NH1prZ2vce+sG7Y9sB5sMyjXa3m7cUtSRQD46cElS8c+NKlUkAX5OBOsJnVW?=
 =?us-ascii?Q?2CMuVswGad5CVW1651RYvt0szdB3SezALsWBCoTRO7SjVL2p7gfJS4g8SzC0?=
 =?us-ascii?Q?jdZT1wOC9zBIe/w3iZSxwWDb50sFPc7kpyH+K06XpMrWAjIwdzsk7+WeUAc3?=
 =?us-ascii?Q?VD0suUmNZnQ+EtV8BkWPSFjVwS0rv4jU/SXb73dZiZpMkegbBZA0+WF7JOG+?=
 =?us-ascii?Q?bDNuoEHsWUa1htAs2kU/o6qQI59A9ZuEGDAzDz8EHi9DyP7BmcgK6ZbiyMEv?=
 =?us-ascii?Q?h3ainLcTbYuuff7nweylgNo/YpIx2nXG/FTGRYOEUrURyoWq1TGS577hwQk3?=
 =?us-ascii?Q?6g4Ehjo3LLwX4q1ifPjqFXDMMQEcdDgq7ZSJwuzaoopFnCT+alzE6/F3zRtp?=
 =?us-ascii?Q?gzCJl9ItnA/0C3jWEMnkuJyp5UUqOxhh3b/ja/NKVzzOJsYRCRe5cb4tSt3C?=
 =?us-ascii?Q?g2NiYgYXkxt001RzALKXAJ0wzrN72lBMe5vgFx065Hcrqr/gYpNIFujzfq37?=
 =?us-ascii?Q?W3rPSCshXouzgst8jgWk7Mc+1B8TvwabpUvQUcG4s9vfwlRx+m1olTiFp//I?=
 =?us-ascii?Q?EplqYjjgq9SVkaZM3er4g0adLyNPdXNsxZwFbnOkhVNso7kdmzwI5ro44yoZ?=
 =?us-ascii?Q?k28iWeErkWTtW4868+A8T0wyN2IcIvGxou1Sjch/R8sSmZEltk8SKW/RDUS1?=
 =?us-ascii?Q?HP8sKM14SwGJrrlVxX1M0TXUoWXh/BvdPjrSzKSwSp5pmCvC9pKIwU4T/o8p?=
 =?us-ascii?Q?SKzafnllcR/DHx4vmgJowtFTikWmjpJl/dZWrFsut7J9Ie5fP99WYUevoa/n?=
 =?us-ascii?Q?NJqrrrIfvw9sgzrMB4Lkr1ryIGuvNmwf4TU+eliKugwNHt6AuirdoJ4z+OgJ?=
 =?us-ascii?Q?Z2fBmcZuq1ViXrXcn3wcR+5f2sKYSMvKGREw5qoVTLu1mOHh103nyFvW5b4k?=
 =?us-ascii?Q?epzRjVdKwjUp2eodT3GEpIXB0ce/oRtZVeGo4CKO0NNtlqpcGPTOWgYXIMlt?=
 =?us-ascii?Q?sj+Qd/abpQP52JeTunQfcC9BqlCZ+JZag43qUgHHlivgQ4c/scm1zk7FElLU?=
 =?us-ascii?Q?0Xzo9GGkVSUmlv6Z8PJmA5pJlU0Vf3vPnvP4S9QK6W1H8bktUbXiuM+qkubO?=
 =?us-ascii?Q?LJjkEgDzu1h/7ExoDUU6CA92VMDCgL9qvfWZJAaZqFM421EykQ60lA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?if7PKgKLNUlqT1gwImNNUCmMkTAqPXerd38obpzkDqbiuSsIgQBjWWYuyIu6?=
 =?us-ascii?Q?kZJcUJMbDLQvHl+p1PrkfF7zlHqEgKP599NRrZxtvpbsYImOKZ8Q+6RYjz4R?=
 =?us-ascii?Q?ogWTWK9kmIgLVWl94jYNTRKKiudgIAjIBaSztBwrrCr+x9nLZOuDHIpHAoME?=
 =?us-ascii?Q?OcEOLN2VYbBpz1lsmXpv5PCVbIGTXOakeTWcTU+yLJMliAltltcIHTor7kll?=
 =?us-ascii?Q?5OQ7K8GUl9pvVqwk9XKlubzkWksFwcXwnUb11hUHr8cANkacXM889b1k912P?=
 =?us-ascii?Q?wYzJZQsE3uZuvmmXPvA3LPy0FNndHwz3bU+2PG2zKjHqkrxwvbN+66YgRNCO?=
 =?us-ascii?Q?wgEB2lqmQcpkj5BDw2y8mmDgX/fejOCM5JrpnlrvSbp4in3QGbCgFgaIKvOw?=
 =?us-ascii?Q?KuDx8kntbmm3Mujp+lcVPO/udeRaeU/FLZ6lAkbHUm28oNcqTIiUGd20a1C2?=
 =?us-ascii?Q?JaXOBMAg1fBjqVmvnde8PuAB9DussDBJ0ISW3jEhx9mQlPJVUSwb/imQZc3K?=
 =?us-ascii?Q?mqmzX+HvWwpdekq6tWv2l64vWDOLcqqFeCOa+hM4u/2Hm1AK46pcouTondFD?=
 =?us-ascii?Q?6ndfzOTiLzifCh+n7YtbDxbb1VYt16Bg8x6mWhlsTp3PoXW7YAsiL8kc0FQF?=
 =?us-ascii?Q?zcXIHKJAQ0MhQGLUTwguUKfD4MtiAx0WczDC0qW5AWk/g5NmomtZwCrZ2Yyi?=
 =?us-ascii?Q?GpOe9Ay41bBCXFBtIMPN26laHHlKnGMZGIlLHbKv9E0i8J8tNflIveG2DMo3?=
 =?us-ascii?Q?XYKQwWPhMGQsQdPlzvYRLA1uzbqlIlnie/OYeehAFThJU+HqAZ6DHWejquvi?=
 =?us-ascii?Q?HXl2QHAypwete/W2Ivu/c9gXoPbotk0ZC5Wsu4g5O9EGBohdvTgWf4V0QHvY?=
 =?us-ascii?Q?5lnhUrhOL/IBV37A/o2C/+dQ+tAzE9YU2ZYsP9aSTe8xCvVdD09eq6bDvazX?=
 =?us-ascii?Q?82a9wfdGFaXReD4najusEH7crU3FwULSiFGPbDxKvbyTBmux5VEhC3jEATQI?=
 =?us-ascii?Q?3IR7HEy7oMEw66CcP/Qnx5GzQyNkEReVQo3p/8BipcPBdmjiABwCr2gqhLeg?=
 =?us-ascii?Q?/XswfkWXBVIFv+dvNU6651yyeC+g2fOE/ag1lm2G2HUsSvy+jOKhViM2eOsM?=
 =?us-ascii?Q?ocqb7Kc0e+XzjRPRfVpz3/5x68geuuTFJRgLxM0y89GAhc8e9BFQNiYrnsLQ?=
 =?us-ascii?Q?nLbNCiS6pSQ4+aXDNtmh+Y5jwPpDhtX5vZUAuUDjJFielGEzgA9gXcmxRAm5?=
 =?us-ascii?Q?SoBJ7y69qvNpotN0hZTFOW/9KbLKWZLa0zZQxsYks02SY0Lr3spAy3R58XKA?=
 =?us-ascii?Q?DXhyJ/AO0m1FOV74XLR16EMSUy+JK/AxZiYEse5ARWGkxUVr7alWrfT3PEQR?=
 =?us-ascii?Q?85wsnD+AaUa/sROfpSp8uJDBgk/hYREgHoI4NtfQnuxbrGpnZ8COBzoYbeUJ?=
 =?us-ascii?Q?09ZIufRajMn6C5RPKbEicYHqBwmdphRFjK2ut6JyoxKyUTk6RfMQ/v0FQ5tF?=
 =?us-ascii?Q?wVF2i7CxHWO5qzJJInhr6GZMlm5o9fWhm7dBVFCVqR0OkDzJ7+uK2D17Sm60?=
 =?us-ascii?Q?0gCG3FgAWV2n3qiQ5FygAFxNy4T/vG7Pg4gB9w4L?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fae9532-2f30-43f4-a2c1-08dddf282338
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 13:56:04.1337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GwQl8HEEzIisgW3odYB9Lzr9DNm6oGcyGZ0JYrkHh3J87QB0MYOS8ICjIwYUjn9mcu+k4JEErAy+n0SNdBoqDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5070

Remove unnecessary semicolons.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 drivers/nvdimm/pfn_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 8f3e816e805d..d5798aba9ad9 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -755,7 +755,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	if (rc != -ENODEV)
 		return rc;
 
-	/* no info block, do init */;
+	/* no info block, do init */
 	memset(pfn_sb, 0, sizeof(*pfn_sb));
 
 	nd_region = to_nd_region(nd_pfn->dev.parent);
-- 
2.34.1

