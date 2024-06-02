Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04olkn2059.outbound.protection.outlook.com [40.92.75.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F264F111A8
	for <nvdimm@lists.linux.dev>; Sun,  2 Jun 2024 08:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.75.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717316328; cv=fail; b=r2e3B8CcKTsZBHlOAvkpXGRvPPhHi4e7crPeWk5hKdWy0QnZvdPsIDoN/7kb0LOYWixpgqub6W1c5vOZbtqzGIlCBAURfnCIvsp3HYTrvsBh2FwzNPOzVgNxoXnEv3LwwrCsCCejj3VQ6/sz/GYTREYm6FC2815JxOo1eKTe74U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717316328; c=relaxed/simple;
	bh=RVLSh558LEQUCGew58xaBnwmWcm/TdYO/JJX8HpSq6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PcwtWh9CZZKVB635AShc7Uo+ngKy9UiTNfZOAq8tR3xKVZfHNxLJEqF2iGa4DosHZirakPT0Y9wkayE9B5fU4soRnUV1/RjoxnxcBhUZoGdgW+osmUaVUoqtrlWxPr2q0E0cpeRi00NvvN9xwixj/BOZbkK2fJBIoOg4WmUUs4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=ZCUWoacO; arc=fail smtp.client-ip=40.92.75.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="ZCUWoacO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLAXJnbsBzbfewKdJ8CvmE19FmwpaxdipmZP60klf6eN3BWjuKsTO2A65MbmwJhYsbXLPWbjcA6DlgfMItRI+KUwqHRmtaR4KqiKlPWNbobt2UM45JigC7UwfuG2gQvwY0ejpmHOCWWmTwbKMyO5TY00MTox3BHaY2CSK1aEkyndjOTx1N2nInSF/v76yBK5kmGS2umlOFisVkRYXhA63DgqDX1kj3ZGxUcekbmd60jZddDvHE3+MY8QIenNw7yYbCBsqu4gdh46dZrRek2/LdmMdqP6f2WuXuSBRQr5KPAIo2+RKRo0xJvvo/4kqOoqPEtV/JLt2nP+1m6zplQTmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZMGFTuKJtqHfCuTi1jhKwZDUrlLhH4uVis8rjYKUoM=;
 b=P3RgK4DXNhrED99Yq1TFD9S70sRg4q4dLtxQnYu3In0H4kOfJOI+0IgB8VWeyXdTAAiCbVbHSEmGYA9glfU7cFVjjiMo7kwBwNyVJrYax/yMBZNXK60vCjM2fuXKAa5TLA+HpAVwq0P1nTo4SF4tmzI5oOwz6N4dDIejU0c2dM/0WOQf7bhwDpzo2VR6Kbi6G6wln1W/Y8shLtftG/LuI8kdIYcrdGIxb5v6urTI0B8BGrLyQEwBc+tPXnNwgCJOlW/R75wXdRVmzVpkS5632VBfvja42nN+W89DChueaSNZliCQn3xcm9skzKMj4G4Gq0Bood5ANBAdGwlbSCMKjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZMGFTuKJtqHfCuTi1jhKwZDUrlLhH4uVis8rjYKUoM=;
 b=ZCUWoacOEtse0SxZPf4pg24M4OpBKdCNWCWGmU2WQ8FOxSRBi9jdKDPOFLZo59yTfnb+4brzf8uODuCMj5AJWeD/ZulwZr7qERo1ZGZSd8gscSr9iotsisg6DuByENyE9F9ZcS3UnKCeJ3VhphyVY/mv9mnRdpOLDMT2dZo/aXKdhDJMxGUtBSlf4sruDU9peDEux4YJYJ1QsgJo+n0WpjtWAXxQBCnqFY68pejyr+dIchnz/U2R+VhfMc0gPrxikntSdboIrC4YnmQAhjMW1WRWmRAFdQWfAlmAImvpglrJps+oRC3itwsr5nm5j+gvoRhUZVL2YipeWI95VyhCeA==
Received: from AS8PR02MB7237.eurprd02.prod.outlook.com (2603:10a6:20b:3f1::10)
 by DU2PR02MB10207.eurprd02.prod.outlook.com (2603:10a6:10:46d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Sun, 2 Jun
 2024 08:18:43 +0000
Received: from AS8PR02MB7237.eurprd02.prod.outlook.com
 ([fe80::409b:1407:979b:f658]) by AS8PR02MB7237.eurprd02.prod.outlook.com
 ([fe80::409b:1407:979b:f658%5]) with mapi id 15.20.7633.021; Sun, 2 Jun 2024
 08:18:43 +0000
From: Erick Archer <erick.archer@outlook.com>
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Justin Stitt <justinstitt@google.com>
Cc: Erick Archer <erick.archer@outlook.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] nvdimm/btt: use sizeof(*pointer) instead of sizeof(type)
Date: Sun,  2 Jun 2024 10:18:23 +0200
Message-ID:
 <AS8PR02MB72372490C53FB2E35DA1ADD08BFE2@AS8PR02MB7237.eurprd02.prod.outlook.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [u8DozTSoAjZnmjIBqh8TQse2TGCPkhDa]
X-ClientProxiedBy: MA4P292CA0009.ESPP292.PROD.OUTLOOK.COM
 (2603:10a6:250:2d::6) To AS8PR02MB7237.eurprd02.prod.outlook.com
 (2603:10a6:20b:3f1::10)
X-Microsoft-Original-Message-ID:
 <20240602081823.7297-1-erick.archer@outlook.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR02MB7237:EE_|DU2PR02MB10207:EE_
X-MS-Office365-Filtering-Correlation-Id: 87b51c5a-de56-44ff-5306-08dc82dc9dfa
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199019|440099019|3412199016|1710799017;
X-Microsoft-Antispam-Message-Info:
	c/lxDm9FuiMut7tS/vXpPRy+XlmWRG9D57HOg8ndnJ1R5tvE2900DftH5tZETQTaEWwAurCxLSNA+6pU61w9gr4yJJ3ZGHk2wAiFU/Ec+ReP1Kyv4CF+ZMMYTLW9dzsOlcODZ1PQBaCyd1laoKxmdMFXQjUmn3hFpXxck9Z4X2Nd7uwehKmEsWQdszzSuIw4X1bh9ZKp2SV1BNADB+T3nHdsXdvRtfAjcfajGyovSx0rgaRQOP6EThcuV2Oll2O9Mn8y+fn2DiXOTCK1PaWYG/pxyRgUg6qnXbbsjS0p1JYLrkAm7L+2CN4IUkMVmTcSJHhdviZ4UB/gtjOq9BlvIJYdYnm7bifbePbS46TQ6fMcdhOFzumBbOZ+BeBdhmuwGYXzNNVVa4Y2hy/2whrCU03nkrgGF43i2Z8nwB2PE2hfDTjQ8/s6JBz9eDNYDXlmaQk7TJZQPsMMEZeC9iYKePOrTumStTnpenjvFuebHIM0JFlJ5pD3o1tOYLVrhNzihS0RUWmspspQ0tAUyJm29KiqPwAGXir3GZspTgOVO+1ENSHHm4YQDMNJnkzwexKZ5REN85Re//EjACo+OLlCXBSAFsQ3ThTUbe/4Cr/bFZLk4FeLPTz9nP0PWNwdx2D3
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MyjDCtnYSZsAa4VR1LHiJxn00df6vF6UTwVegsVS8JWLGf9FP5YrEvFoM5hA?=
 =?us-ascii?Q?6DDkLbYNxW5G5aIW7UciLjYLwkv/qk/sqW4XM4fisZBsKDdQF4WfUEVa469O?=
 =?us-ascii?Q?TBLTkbef62LklfG2/j6MTUodSf1LT7t5YtM070JdAnoR6IHNKVbrI0E9m3iq?=
 =?us-ascii?Q?Uf1nguNPMTYQVoUPTFmOre4nE+E0j2O5HJs64izLcmBweb8L1pldsKLsf6iD?=
 =?us-ascii?Q?fD3tDtC0hjNJLECKNS7ybcJGh1E+otqcxF06agHkK4LWIFICKnT5/+uOwlUT?=
 =?us-ascii?Q?6NBQ/CLMZIeQDsk9P3lK3CNUySqqc/kSFzob1llmqtmVFz9tdzL6h3Bm9/l4?=
 =?us-ascii?Q?L1nqd9fqlQkxVxODVplKW68RB+qqn6L+RqORgceH92Qcs5C142xNSAj2HCsD?=
 =?us-ascii?Q?JcspQjXhrVPMXyCW1p/WkM/r73TUq+CV7yFek7KJ9uRn9uFwHpYRBTNUaSqy?=
 =?us-ascii?Q?7xegoYR+WtQCCoIT5DvyZqjqQd1hDS+DfUAAz9SskTQDlM2EFOou+OSNGP/y?=
 =?us-ascii?Q?uUxh4Ix6/9Bnlpr+DP1lCkoQmHg9oTD/0pfT+A381bw6exINsrqW67fhQFZ9?=
 =?us-ascii?Q?xROykq00ovCx2PiqktbJetTuvR7amCnBfaNwqs86xqSU01k4WXRiYfHEuBNQ?=
 =?us-ascii?Q?LIFYxKkcq50TxBVGcnVR/dhBv3jKTUeG5rtpS4UqVBnZJuNTO7iYtoVGaAap?=
 =?us-ascii?Q?63wApR5rjjKv6nuToNfOuk1F1lPXB+hQwOYZjKTlIR2AQeSlhKK27Bu+b3I2?=
 =?us-ascii?Q?sznOxsIeiUXESEsbpmm1yOH4dpSER+qhviYJKD7TGBNaYNfm4BhZlxSWCmyX?=
 =?us-ascii?Q?rqM6b44j7XuJKRTDJeu3ljReDIMCzpKgrqcMkEYKeFkSPZMYhK83nG1CD0Ye?=
 =?us-ascii?Q?fIpOVC833C0qpUgDIxOZ6kx4+G3nn/zupGfXH+4ANu9/hA68Nl4QhvnnZr6G?=
 =?us-ascii?Q?9ePEG3BrWPxMsYhH24ThG+YNF2nNgDcUzFC2zHIvaoQqfzB3cGWVZGX0Fgsy?=
 =?us-ascii?Q?PRR3o09aA9lTbzcwczYtyIJr3QR+Mvjha6X7tYe97Ms2l6CHlJC26zbq4tPr?=
 =?us-ascii?Q?NewZEiKw5E1DQcEJTltHWxooqPOm8oBQKtfGkQ+OltlTFh7x9FmjfIVG0gE4?=
 =?us-ascii?Q?HqB62ooSS8FsRITG8xM/wgsqt32BuTYD19uhPx/e9QS86v/WVoLqxW6YoWvn?=
 =?us-ascii?Q?E9JDMPEmzxeYt6akO4rPak6Upw90gtswzmrr+tKUJ8VMU4zO8c9+eJYIkaWk?=
 =?us-ascii?Q?2VOj+Hm8BJylKHomGdGp?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b51c5a-de56-44ff-5306-08dc82dc9dfa
X-MS-Exchange-CrossTenant-AuthSource: AS8PR02MB7237.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2024 08:18:43.7433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR02MB10207

It is preferred to use sizeof(*pointer) instead of sizeof(type)
due to the type of the variable can change and one needs not
change the former (unlike the latter). This patch has no effect
on runtime behavior.

Signed-off-by: Erick Archer <erick.archer@outlook.com>
---
 drivers/nvdimm/btt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 1e5aedaf8c7b..b25df8fa8e8e 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -751,7 +751,7 @@ static struct arena_info *alloc_arena(struct btt *btt, size_t size,
 	u64 logsize, mapsize, datasize;
 	u64 available = size;
 
-	arena = kzalloc(sizeof(struct arena_info), GFP_KERNEL);
+	arena = kzalloc(sizeof(*arena), GFP_KERNEL);
 	if (!arena)
 		return NULL;
 	arena->nd_btt = btt->nd_btt;
@@ -978,7 +978,7 @@ static int btt_arena_write_layout(struct arena_info *arena)
 	if (ret)
 		return ret;
 
-	super = kzalloc(sizeof(struct btt_sb), GFP_NOIO);
+	super = kzalloc(sizeof(*super), GFP_NOIO);
 	if (!super)
 		return -ENOMEM;
 
-- 
2.25.1

