Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.4
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794429899;
	b=xMdMgtGSpb94/Ob5aUzmL4lRzlQCMObj17+BKDbWV8WTOoPEglrslOKIC/9DWkJ3roap
	 5MPu9yjJSTMGJJWA3PBR6vLVZ5KqNfynE/IB9dt0ZNVokEm/V6ROU+ipOyI3GROvVa5xA
	 cZiGqKs8upVeXIzNur6y/MClSaVAeTrA3EhB7j/RyUsCW/HLru4hNqSJf1GuBMJxheUa8
	 /QKrm0DSFfZDpcKk3zuFra4cFn3cVHRofjf6pu5zrgOr9l2JZ6hcUwBpCGpVa/t9r2Cy0
	 wLnnnpD2Cn3QDuhoucQldS6UUo0mVAzdPOa0+R8mzClTAJe1zb0SgOhKbgfB4pJ/Obw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794429899;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=dJGDWtcDvqR226Fppem0GCEZZF8GtFqSS2LQOHOOVcw=;
	b=U7M37FfoAAxkvBcip/87UlmrfBwIhAII8TbNVBaWidInMu3CUiL19vB0YujVLeblp6v4
	 G6209B3JhBrzPCevETs5iBBtwefYWuBXUTMsL65LpwWVM+K8GAbAh1dbpLy/nxiBowSzm
	 2e2sm2w6+ZerwTgDdbklH/6KrnNWtHR1hGQ/dT1/YISYOa60nuY+3kupotaC1GJ8i/z7H
	 7UWxTQOzgov8FoiXE+VPgCklvsWoRkWijQswz63xwdFKtgslBT0yZecT4CsmaLR/bHkzh
	 lyecGXWdkdIznQ9rlGRV23xG7H1+Pft7aPVAZ7lF9kkVig3YJ+hmuR584/So2EmwCYQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=J5V9KVl+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.4
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012004.outbound.protection.outlook.com [52.101.66.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA20B606A326
	for <nvdimm@lists.linux.dev>; Wed, 11 Nov 2026 20:44:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA20B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=J5V9KVl+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E0PkAB7t3ezWEns05u51pG//WPYlTs8zLY4rLHNuEMXn1vtpCjzvKFjnT5G7vSTrOFy0+msbr4xMKAv10OPF0vONr/14cvRN2hA09sLAqNi1PkgUmQ71arPQ6TzlS5Qm7D70Uv/mpvFah0yEQXTPGLB7zbI9iKV/Bo4DUwnahG16m2zL6HeHbitLY8iQB9fyqzAr4QifN288HHr7h2xyhIPQYaQjfVyfFkecEereM8EFAdGQZYVy3bB4u87jvRtroMNfX5Ga4bDNoEagKdhMuwEu2+horOQ6MX1lTF3EAVBopAYran1+4nu8grnVG6Ssad8fwwwGwtgNp3yBv0XHwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJGDWtcDvqR226Fppem0GCEZZF8GtFqSS2LQOHOOVcw=;
 b=yQ5Y/gDh2kX2oIp8ovJ2o0Jg8c56G+6cTsH7/4OMAtfOwifF0BtMPo/QUJxEjuu6vm8qflc1pe6nYD2en088hcM+pPWL2QMQNgTjCZoYh5lCC2QxEH8nRBZhvFB+E2L4IDteycDHELQ/ALphlQeLCc0ocHZmzJBOlQWF0gA1NXQBZOa7jNBMVVMB4sDCZKfMM+EHUmRAEZL1Fr37B4EHEQMAygaCa+AgG52T4NTtbC1x2rP6dJ+Bi8BtzO97nhxDrYvWKozA/qQPc7z74MGdshCrWPfg1DB1TUp8VlxoQBYILwKib2JxcgINNMCsEnhFNrt70YdHHDe54gv79gQyAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJGDWtcDvqR226Fppem0GCEZZF8GtFqSS2LQOHOOVcw=;
 b=J5V9KVl+omu24sexio8+Mjr9u2FgyxihIGXE83P10FRsLPBqe8fqOSuQiLNc1rJj5uwPUfnI+C+OjZfoPJ7fQrz7n23lHxdQOHw2ed5ZqkqV0t4YcBJOiXBXze2gLczAVkKpiQQDXKLwyYFlVWTmCaDb3hKbW4jl1dJSX/TojtEoG5cGTEXSzk9b5aoCLiLSIfB5NctWrBxNbgvW0wENr+d9maP0eYl5Aedi0e7wzEXUavm42oqvGk0F1npP6smDpVs3ksev50grMDD2V4bmCV8NC28ulaMRcqHscRx2AI4ka3Fn8T1F2A4SdppZ3C36DWQY+JXuFdzEUagaMqygyg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by GV2PR04MB475645.eurprd04.prod.outlook.com (2603:10a6:150:39b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Wed, 11 Nov
 2026 20:44:54 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%4]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 20:44:52 +0000
Date: Wed, 11 Nov 2026 15:44:44 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>, Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: Re: [PATCH v2] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for
 djbw
Message-ID: <avTTvIK-K-WW6vvD@lizhi-Precision-Tower-5810>
References: <20261110210152.3494345-1-dave.jiang@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110210152.3494345-1-dave.jiang@intel.com>
X-ClientProxiedBy: DS7P221CA0040.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:8:25e::11) To MI3PR04MB12438.eurprd04.prod.outlook.com
 (2603:10a6:290:76::14)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MI3PR04MB12438:EE_|GV2PR04MB475645:EE_
X-MS-Office365-Filtering-Correlation-Id: 41c195d7-15ba-43ee-8315-08df4034a2c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|19092799006|10067099003|11063799006|56012099006|261102123227099003|261021121427099003|261021123027099003|261022105027099003|261009223027099003|261026121527099003|261028144727099003|261026140227099003|21046099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	leQEa2eJQp8uCvc+L2/wjGXmFDJQsTvLjYiH38NH6kDlRHtoLq6zkbeXKqc9lOONSNuRoh4AKMyXqDN3yIxi6Q9R7Gpju2UrNVkaLyel5LricjIHAuSutKLTX9cKyIbqmn56z/iKSVzhOPZfvN/0G43SskAcVS0jLyJxyuM2DOfT7DK6GRvqlHecGQgXkuqob+BMcSDe9LrDz2634tjwN7k3GhVeeOaNyh4AEa02cDyqVnDJy1hd7eGQigfftEN2PC1dzFqVmlrGQWB7LOJr5meBKJyMZ/sLlgbdQFujcCLYRE57id+GFPbP62d0gRezs4I5kzYWw33lub/+dxhinxjoFmIq+B2COU1nnGNaKWf0d9W4t+kTty4gso/SZQf6G5WE7bcP8XIIhbwWHxcn8uhlSGT0PoMJlTUAg1Omo9m9w/UV/saZ0YHQ0LDelpvIMVUrg6D3gkgtsG8CJi8Dr/boAcubhRg2kvvkb4ex1sfRCgCxb5E6p2ARHjCdL+yv6ivfuqlb+Koh/Bjg6LAbPwJ3fXrywJTqfn+w9YQ4VPMNwqb5oFTSa8vb+JifpIoqIzf/JD5EKIQWX/U1Q0LV1G4NUqnr5rau7Qn25s725LPjZF2nJ9UrLpJkVj90S0Yb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(19092799006)(10067099003)(11063799006)(56012099006)(261102123227099003)(261021121427099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026121527099003)(261028144727099003)(261026140227099003)(21046099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/qtNkuynJQTUBtZhNJIEju8y6yc2kwJJFF8iWtY3i27vsdeLs5wbWWr1prnp?=
 =?us-ascii?Q?M9Za1xLecLPcNh52kp+ExmH97dp2vM4T5ATaOcwhpzNfN8h5Y5OgVHx1x0KX?=
 =?us-ascii?Q?Mv2pxwkzLxY5lON6wvafIQ7uDdK0ooAzyTilBMOYP/NIqG2J4RcI83bbHt+f?=
 =?us-ascii?Q?QT6+LSDwQYHG+YUzJMr3407+GomgFwC+wRB5fGrTImvXtRDU5tcFQJOf1Lvf?=
 =?us-ascii?Q?He/Ur0UeIez/HSkrdX4lSpLoXpB7VVNMgyojQAqIsrfhWUbH6YkcoSAGupda?=
 =?us-ascii?Q?48rUOHGgTT8v0QOjt/ThYkDlippvLX/LEXmV66VwRWAJiU0YWOxxQQ+LuZ4k?=
 =?us-ascii?Q?CxFUHo7vVkznBuqGk6db+wHBYIK/Pw76g6P8ulAqTjHJx5g4Z4xq9vViK5dH?=
 =?us-ascii?Q?HBW/1asdryepVIB7lSs37bwmSFz8FBXWIAIc1oawD1jjt8BVIrLAOcylQJRp?=
 =?us-ascii?Q?sWjuKuGxf8Mp3UJWIjaL30LVHj/rqqtF0nXEtHv8i45HsoX7xOEzkucaLT3N?=
 =?us-ascii?Q?fmTD2VfZeHD+Ty1QsUHvbEdLDReKa9OstZlA1SPEvAs1VjEC5Zrc9bRgMY3E?=
 =?us-ascii?Q?zB7kWU/jZx3eGxKqh0zANIjUN6YuvfsGzRWPK4L2JeKwtC0U+siBw+ZE47uB?=
 =?us-ascii?Q?cIz3YogVuvw5kh5OUradlmcf49IuS0RNjEFUEuByb2JlJH2vWpJ4rjJqaP7O?=
 =?us-ascii?Q?25JdiqSw/XbwdZfVrxh/f+9ad9o2LJrpK6rKfmb4PYx2zSyhbzfogkn9RVUe?=
 =?us-ascii?Q?1xfteXD73hldXzCxkXm93pFKOyK1XNLEc9SzFPVmCGEOg6h0w/vdxOrsPGoW?=
 =?us-ascii?Q?N0PhkeCba9uZ7QKiL/lqI3F8mAL4DO2WhrU0JKGXyWYLW0Qi1rG7umaFebLs?=
 =?us-ascii?Q?3oTWoWHtJCTmeM3nNoIG1cdjVzvwJhFOWT1LqzUTExAkKLVojELoIQrLgz6W?=
 =?us-ascii?Q?zKj8JGiQCvbQl0r7ZKquVOsw0AIcEjxVnsgy1UqYNwgdotdLIzxWUFrfAt85?=
 =?us-ascii?Q?QLPnwduYgxzJ4Naa+Dlr0Fc6uXxZnVAQ6X7MLWyP58Og/7Y2ysrTg19BYayW?=
 =?us-ascii?Q?d8V9dLKRxHwfFOos38Juk2Db+RVTSpuGm0tgsG6YsqDuqijt6gbUI82JwEEl?=
 =?us-ascii?Q?r2PbyJeDv7y+rmJuRv3hZZkpikMj3xTPaDALnwnzX652el1JVSiJhYA+2fTs?=
 =?us-ascii?Q?94UxwleWocsG2oiw2saaKVz/tXYWHIlnUDQZy2Z8pMfhkzOEAr1yc/AmVv4W?=
 =?us-ascii?Q?0QWqSAOsjT4hAgQ3ePdGWmy/jn4k6ohVM7F/dbLjivx9PO4QKoxHlz5rdaEX?=
 =?us-ascii?Q?wjixiGGAdlfoouGKycb63rqIY352qcQrooEOcOHLFzQsrz1VHKC3+4swZqQS?=
 =?us-ascii?Q?VI27O68sJq3LuCyIytD3I2wRdqd9ZFkqjcpc+o/QoEJt32fliNZJ9pfyj4hQ?=
 =?us-ascii?Q?OJ2hZVbSsNr4QeneabR0787l0HMDze5auplJuiAzXqEFmqq/sBSHrhTTaAA2?=
 =?us-ascii?Q?2zRTg2CopLJzq8GBuUGFVzUR8+hrKj3HDcYNo9zJcJBAXGOoz9Nv0rGBz+mC?=
 =?us-ascii?Q?t5QqVAMR2iY9cxuuX8khu3OyADV9BbMi28aF2I5SLr3884a0VuAaswu9VRcc?=
 =?us-ascii?Q?h65w6pdsXa5pPiH2nrQDa/wrpNOCkQ4vGENZ6fxvVuGQLmP3fJLL5KClV2DQ?=
 =?us-ascii?Q?DE3I0oiZPTIRUziWpSIZIghcVj/4IZP1AEo/T9xxiJREPSDZOW+PnsFcJ1MY?=
 =?us-ascii?Q?GNLhJBzw3GLrsm5rFF5Xtt4i/8wUmMIYxVf0lXQkM6jltJP+9mMk?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c195d7-15ba-43ee-8315-08df4034a2c4
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 20:44:52.3888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0n35OfjnDM8z/zhRdTxL1NxnjFQQcrhlD5KdMOWBVcDV9h7/kO2kaH/P/CwNrk35MqUY6pmJDoRiNpyA81d3nbRyP/gMSXERs0ZwrqmTFLMRqUSN+4TV35Kwq+f84YsK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB475645

On Tue, Nov 10, 2026 at 02:01:52PM -0700, Dave Jiang wrote:
> Dan is no longer with us. Removing entries in MAINTAINERS to prevent
> people from keep emailing his address.
>
> Frank will take over for async_tx until the feature is removed.
>
> Alistair will take over on fsdax with Alison continue to wrangle patches
> for DAX overall patches.
>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Frank Li <Frank.Li@kernel.org>
> Cc: Alistair Popple <apopple@nvidia.com>
> Acked-by: Davidlohr Bueso <dave@stgolabs.net>
> Acked-by: Vishal Verma <vishal.l.verma@intel.com>
> Acked-by: Alison Schofield <alison.schofield@intel.com>
> Acked-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>
> ---

Acked-by: Frank Li <Frank.Li@nxp.com>

>
> v2:
> - Add Frank as reviewer for async_tx.
> - Alistair has been working on fsdax and agreed to be maintainer.
> ---
>  MAINTAINERS | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 93abbb315065..58bdd5eff5c2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4294,7 +4294,7 @@ S:	Maintained
>  F:	crypto/rsa*
>
>  ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
> -R:	Dan Williams <djbw@kernel.org>
> +R:	Frank Li <Frank.li@oss.nxp.com>
>  S:	Odd fixes
>  W:	http://sourceforge.net/projects/xscaleiop
>  F:	Documentation/crypto/async-tx-api.rst
> @@ -6726,7 +6726,6 @@ M:	Jonathan Cameron <jic23@kernel.org>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
> -M:	Dan Williams <djbw@kernel.org>
>  R:	Ira Weiny <iweiny@kernel.org>
>  R:	Li Ming <ming.li@zohomail.com>
>  R:	Richard Cheng <icheng@nvidia.com>
> @@ -7621,7 +7620,6 @@ S:	Maintained
>  F:	scripts/dev-needs.sh
>
>  DEVICE DIRECT ACCESS (DAX)
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
> @@ -10315,12 +10313,12 @@ F:	include/linux/fcntl.h
>  F:	include/uapi/linux/fcntl.h
>
>  FILESYSTEM DIRECT ACCESS (DAX)
> -M:	Dan Williams <djbw@kernel.org>
> +M:	Alistair Popple <apopple@nvidia.com>
>  R:	Matthew Wilcox <willy@infradead.org>
>  R:	Jan Kara <jack@suse.cz>
>  L:	linux-fsdevel@vger.kernel.org
>  L:	nvdimm@lists.linux.dev
> -S:	Supported
> +S:	Maintained
>  F:	fs/dax.c
>  F:	include/linux/dax.h
>  F:	include/trace/events/fs_dax.h
> @@ -13455,7 +13453,6 @@ F:	drivers/platform/x86/intel/hid.c
>
>  INTEL I/OAT DMA DRIVER
>  M:	Dave Jiang <dave.jiang@intel.com>
> -R:	Dan Williams <djbw@kernel.org>
>  L:	dmaengine@vger.kernel.org
>  S:	Supported
>  Q:	https://patchwork.kernel.org/project/linux-dmaengine/list/
> @@ -15278,7 +15275,6 @@ K:	libie
>
>  LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
>  M:	Vishal Verma <vishal.l.verma@intel.com>
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
>  L:	nvdimm@lists.linux.dev
> @@ -15288,7 +15284,6 @@ P:	Documentation/nvdimm/maintainer-entry-profile.rst
>  F:	drivers/nvdimm/btt*
>
>  LIBNVDIMM PMEM: PERSISTENT MEMORY DRIVER
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
> @@ -15307,7 +15302,6 @@ F:	Documentation/devicetree/bindings/pmem/pmem-region.yaml
>  F:	drivers/nvdimm/of_pmem.c
>
>  LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
> -M:	Dan Williams <djbw@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  M:	Alison Schofield <alison.schofield@intel.com>
>
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> --
> 2.54.0
>
