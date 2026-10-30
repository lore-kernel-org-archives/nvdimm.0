Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793357642;
	b=29MJ0WHT7c3iv5N2GCQMPEpfyfj3K1O+WDBVzAu8zDROXGHc4NUUmLwauggjk+oJj64Q
	 7plpQ9oID1LS3k+ITWg9Z8gj6wrtojtrcoyZZiqBSh0z03jKgu6sG+k5J/u/jYlGPVW0i
	 jrQen7/O13z8TiDmdEM6XY+BtnSg0Xwx3F9ljTGKVHQRI0TZYtEPugs8P5aqq3Rpsnzr7
	 Xk30JbVFves2uVHCUCKwd4utVzxu+7xHVl4FdfhqZuVyETsIww35FDGeXETL2eOpUoNiW
	 24xfkQ7P4kCgVo5E2cBLeaR71M4HLFDJ8NXYGLD0E5eAF94X8WyXhVLMitCdn0hPSDw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793357642;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-TrafficTypeDiagnostic:X-MS-PublicTrafficType:client-request-id:
	 request-id:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID;
	bh=0m1KRfxR8XKHPUhFuiozlOI1J4rQWDyWGyGE65GD+cA=;
	b=H30DbBbQ+gvR9z/V5O2MBsPallSYmDuNKwBP066aKoxlT6057ru/Zlf2wpQNnDzAlRFY
	 Ing91oKo7gq2PmZLtRzUWuma7rv+RYCB9P0MLVBCBQXmmMgPmDq4tpVRNLN6B28ZHe9D6
	 XF5E46CCPWJ0j+2+ID4mn3uXdoELokg4G/39uMH0oEsfdCe3Gm09lz10pF3jwqupE0zKR
	 43lrcMXqelNV7Y5feMb1ggTLdJz5YozHS8uiRGOTwK//cmyqBaGuAjbs3Cq2442N5hulE
	 eYO33zQOUAn1azwebe0NCCEKmZADwRpEc8sPSPGtHqR2vodn8x3kB6TBfOqoKANVMHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=WT9rbvon;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=m9EFnzpY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E77606C6DC;
	Fri, 30 Oct 2026 10:54:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1E77606C6DC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=WT9rbvon;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=m9EFnzpY
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69U2tV8R679165;
	Fri, 30 Oct 2026 10:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0m1KRfxR8XKHPUhFuiozlOI1J4rQWDyWGyGE65GD+cA=; b=
	WT9rbvonA1zlSX6M5urVtmuwbYzk9Wsf3n4fGeYy/Thw1i3Qt4nEuGNKoh5RUqJd
	RDc/t6aRZsBkhyxhCVI7heC9d3XuMutCwaGrO87soIeatArNMsNnJL8YnCmXF7Kl
	EUVveQTXxU+rU2mWbFtQ2ot2jXUv88e9GkxUGHoDCHsKdyR3J3biQl6XGFK2h8Gt
	eMMrmLH2Yf9ND9UlY5cQ3qvtFI37tBr3/s9zHeEXTNhUuDITOmgVjKfge8a3an0p
	jkME7j4PVQhuG8doLYNMz/TPJ254pc2EmWX5bkyER7Rrn6mTBp+Lx7wAKcbmczZ6
	aXhGVoiyPA1PlHh/33ofwA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4hme5prmdr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 30 Oct 2026 10:53:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 69UAnu3G3525438;
	Fri, 30 Oct 2026 10:53:43 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011029.outbound.protection.outlook.com [40.107.208.29])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4hmsu4r3b8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 30 Oct 2026 10:53:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gf7V0KFO2AF54dchA0qZsNyhg2bTit27k2srrDp7Vh4fJalvrde0Jo6605YpXlJ6hp4pavqXqIyewQy0Nr8bYqmJ7uMsAQdtfKXnr6eTdPS08n+/xrEOFWq/wNoNC125ZWzDgsQKx9SqRIBSj9a1t3fJfdDivHo8ERVu3eNyc0V/XVD3nW3uX+IPQ+BmJzOxbCiGYJlINL/5tkNnu9x5Mh3DMh2qPwkOqZjGLryBkbNitJ4/MEm/7uDe4zssxbnVSR2uQTTHKb8dS66D0ZCJFkLOwDgtrwl7PatYOHyp5LlSFcKqphwwAWxTNcS6Yi5n5q5p1rGbswz1vRNtApqZsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0m1KRfxR8XKHPUhFuiozlOI1J4rQWDyWGyGE65GD+cA=;
 b=F9M4CKDYD5ns69+76f4DW5Wb7ws0BWAcQcpv2zckfCUGUblTHIh15c1yiPR5HK/Aq0/RxQxUhlfxcG8RNDdCUHf1qZAy5kbeE1IW1sn79+hK9NuutCeZXw+UhnqVejtb+Lfq7M/tmEKfKgT4d8DJoMIPvKTKOsfxcTuv2wOufODB+bi1zTbu6NaK6oQLjCUoXd/QaO1BeMsovmjgMHYRCZjugpIorARrlT2vHCOiooQh+Fd5o6FSVpAVGExOGUBFJLZ0m3lPRFJy7ERMd958uT+9nQVK6j8Zm2LmR+hBwXvPH6v6KqTkVsNg2OxEON8aSazEMCJN/hu1clphSD0ZVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0m1KRfxR8XKHPUhFuiozlOI1J4rQWDyWGyGE65GD+cA=;
 b=m9EFnzpY0wSf/EpZxuxaTNBSDKnhuPYo/o5c1rUq0ndbiWgGgCwaY15Sp2TuJeFpC4aXp9rhqirN/cKRr7+zqElUNIYD8L0F2Ga8JSl3f/YCRlr660acXmpkHyAbwhFztb+gVYjQYw9YDuW4pHIxlAqO8uZOVixzDvPiC/ExsOY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from CHAPR10MB997722.namprd10.prod.outlook.com
 (2603:10b6:610:2f3::10) by MW4PR10MB6464.namprd10.prod.outlook.com with HTTP
 via P2P; Fri, 30 Oct 2026 10:53:40 +0000
Received: from CHAPR10MB997722.namprd10.prod.outlook.com
 ([fe80::d6fa:c744:373e:9f4f]) by CHAPR10MB997722.namprd10.prod.outlook.com
 ([fe80::d6fa:c744:373e:9f4f%4]) with mapi id 15.21.0569.009; Fri, 30 Oct 2026
 10:53:40 +0000
Message-ID: <7de3d0dd-f504-4c8f-8358-80634a2edd6b@oracle.com>
Date: Fri, 30 Oct 2026 10:53:33 +0000
Subject: Re: [PATCH] dax/pmem: fix unaligned compound devmap initialization
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, stable@vger.kernel.org,
        nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
        linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alison Schofield <alison.schofield@intel.com>
References: <20261016054914.2601510-1-songmuchun@bytedance.com>
 <31c89da1-6d3f-4a42-b6bb-2b8f8170eed6@oracle.com>
 <FB79CEA5-ECA4-4313-9D9B-10B231C88E92@linux.dev>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <FB79CEA5-ECA4-4313-9D9B-10B231C88E92@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0435.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::8) To CHAPR10MB997722.namprd10.prod.outlook.com
 (2603:10b6:610:2f3::10)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: CHAPR10MB997722:EE_|MW4PR10MB6464:EE_
X-MS-PublicTrafficType: Email
client-request-id: 2820c82c-ff24-4467-9fb2-ceea1e9746f6
request-id: 481f4185-3dab-4abc-4f53-08df36740e83
X-MS-Office365-Filtering-Correlation-Id: 481f4185-3dab-4abc-4f53-08df36740e83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|6133799003|18002099003|22082099003|56012099006|4143699003|261022105027099003|261026140227099003|10067099003|261022075727099003|261021121427099003|261021135927099003|261028144727099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	YzYHvYLgp0qTjvIiFNuHXcACojG9nxbrf6nSV+RrZ0lS+XTwAopOaF2GlQw20fuSlcK0uQAz9er/XspMi0mKlzkexrnYd+nsxmt+uhxsl95mSyHZ+WbO+u93/7KMrvGlkZ84dMPqNS6P8IW74bFTZu17xP9NDgzoWAg+5y4ozwg3dbLJFa7fNG7Z5csSwW6kxDOY7rBlOqJOnR9Y+LnF+ODSW4dLIelIWaLE+SjShD+R9L5jezQw1GzQmRwcKuT3FAe6R461Ti8POxAZHVIvYCrAg17gT1LBCgzB+wgBsL49V4dEe+pSGD4hEseS17uzY037/4E5wNdovDmTpxyq5VuV3IA4Um8Q/78kwmp4DDuqRz6zhyhI43Q7aECrR9sRSokvUqJEwGQDjwLbWPaeTvxXnULFrhESmlYi5OIADwUB5EQAGXsNthPDtq/PBuPQfHOjn7QizFPae2lL3xEJr4DCadu3ie5+QlrbVfx9KySPGCKGum+2oaHELz2zfDDBgitminlLdUkuuROAfJQrTjNS2UZZrsTosBGl65ydhu+6zhv3OghUnSvvKSHMKjO8SSVdZn/1ulXndvVL5RjjR60iOeTZYsMhmZ291dxn5XElELv/hm5RxZ1NyPBTqg/V
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003)(261022105027099003)(261026140227099003)(10067099003)(261022075727099003)(261021121427099003)(261021135927099003)(261028144727099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkVTdjNkK1g1YW5vb0Z1NXBldi9DeXJOMTgyNkZGTlBJek9DODYwd3V6bG1w?=
 =?utf-8?B?aWwyTXdYRmNiWWJoLzcyMk1FU1krWjljcFI2cEVlWXlRZ1huK1NPMEpnSzE5?=
 =?utf-8?B?cDY0UjJHbXlSWFZZQzVUcnlsNzVCUWdOajljUWRRc0VnN3JIcFhFTytseitD?=
 =?utf-8?B?cnBWQTNwZE5CQlZ2czNTVXhQVTFFR1VmaE9xTzFaZTRrZnZua004ZnRPcXRB?=
 =?utf-8?B?cHpWVCsvSUpVRGZmS29Ka1RDS1VZZkJDd21QY1YwQytDMVZlRWsrYjJxdGFQ?=
 =?utf-8?B?V1l4L21lVWgzOGZvVnl1c2VsdUlTVGgyUzJDeWFHcWdpSWlGSm9oWE12QW92?=
 =?utf-8?B?bkN6SjBhMzJMSGJ4aVQ1KzVwSGxsYVJRL2JQdnFYcHNkOGFDNlZzVkh5R2V4?=
 =?utf-8?B?MEh5Y0JSNGtwd2FHTmRZZTlQNjdwazJBOTc4RUtNc0hIK2ordjdLVlR6M2di?=
 =?utf-8?B?My9wTURUZ04rV0h5WXVJaUovaU90WUF5SWYxMmZudlFTdUJyTGdvREg0N0kv?=
 =?utf-8?B?dklRU0tNbno3THk5YUswSlJHcVpPQjNvU1ZGTUYrRjNDWXNDYkVjRUtCNC85?=
 =?utf-8?B?N3hSSDZGdFhaaVlRYXZKZEhSamZTM3FlSWZTM0FhVTR0RzZqOUozU0tvRkRr?=
 =?utf-8?B?bFhtUUMwSDh1d3QyUHlkMlA2eEhqN2tpSC94N0FlMnNjQWRwMmp3dElRbUk4?=
 =?utf-8?B?UFIzRUk2TUF5bHlQY3JHOG0yNnlSZlBIMnRCa1U5YWl1VURieTFRZ0pjVWly?=
 =?utf-8?B?S2djVXMwYXF4U0NsazBFYkNWSkFUR1dMMjc4MVFERHlqZmZ4UldPM2dxVndU?=
 =?utf-8?B?bG9hczZVaStlSGxZVkxSOXRWa1lXd2d2YllGcVhqTWdtTVRHWFpPZytSQ2JZ?=
 =?utf-8?B?WmJLMUYxaStSSjFlOWNVTjgrZzZ5ZmdMNXRwL0FEOElhc3FUR2c1dlpMNnlz?=
 =?utf-8?B?QlloZG16TUY0a0s1TW01V0JLY1JXNmt3cnljc1pERHZSRW42WFEra2N6bDVs?=
 =?utf-8?B?UHF3ZWxOejN1L1NhbkN4TmovK2FwU0Znb0tiZkZqSmU1WlV3NUV4L0JUL3ky?=
 =?utf-8?B?eGNMUnNvVENnaXQxcndaTThzcEhkSy9VU1U0UjV5a3RycHRqaHpmTEVjUkI0?=
 =?utf-8?B?U0JMQUZoNU5vL0VBOEY3TDd6d0VubVhoN0JmWHcydWZSRkJxWFY2K1JMOG9L?=
 =?utf-8?B?ck5vVElYK3hkaVArZHNJN09MZXBIbkZLQ2ozZzNHQ082MkNOY1NxbGhIRkRi?=
 =?utf-8?B?anF0VUpUUG5CWko4RytRMUlZbTVtc29MRFhVOGgrdzhXSERMaXcxdTd4amJG?=
 =?utf-8?B?R20zVFE1SE1XU1BRL3lTYkZybTRtUWNtSFlJY3loQ0FNUDRzT25wNDZ1V1Ns?=
 =?utf-8?B?OXprOWMrTi9sQzFkakUvVFNqcm5PRHo5WEhDb1dkcWdPWnlpMWdtNVlwS0x1?=
 =?utf-8?B?WDlzOU0vUjlGU2pHdzRpWjFjL0Eyb0dGd2ZJSFpHU2xTYnRNQ2xVejNKdDQ4?=
 =?utf-8?B?MEVGd00yUnR0SlJuODlaSXE4QlNNRDVpQkJNUUlmODNWRFZkVklJZlowUGxY?=
 =?utf-8?B?c2tYN2RFdUdsMU9yMitOdHlRL0lmaDd3a1BWV3BXTGY1dFNQQ2FITC9PTTlE?=
 =?utf-8?B?bFdVN0JxKzNROXlrSjllUFowRXU1emprNlRMREZkYnp3Yy8xSXIzM0xwWnda?=
 =?utf-8?B?YmlJOGlQQWlkNFpYRUhSM2dDZW9GM3Vpd3JON1Eyb1RLRk1kSWxnM1ByYlJI?=
 =?utf-8?B?SEQwQmgvbjRqeStNaFJLd0psR1VpaVZCSnJyYnhHNzZuUlBVUXpmOW44Q205?=
 =?utf-8?B?RU9RMCt0SVJnOHVvdEcyT2FQNHZ0WlRMVUd3VXRySGQ3Y25FSTE1azVLd05U?=
 =?utf-8?B?NWhpSGRLYkJhMzBHQlYxSFVYYmRvQWo4WitGVXdwM2x4WkdIblFDLzRpY1lF?=
 =?utf-8?B?d1V3UXZvS1FrdGlYVjM4VXBPek9JTFRzVVZYazNRTE9MWkdrQ3h3d3dWSGtl?=
 =?utf-8?B?K0U0UUtzSzFsbTBsTkhlWlpKWkJOci9XK0QwbDJEVkszSG15REFJbzBDOVF3?=
 =?utf-8?B?NzJiMnY0N09BTFE5b1ZMcFM5SW9qRFZ2bGNjakZDWkxacjJSOWFxRjVZakhj?=
 =?utf-8?B?RThqd0RpM0oyOGpYU2RndUF0aFlvdFZORS9BMnRuOGU3anl6eGhYdUZKUk45?=
 =?utf-8?B?S05xanZ4bHhobjliMm9QS1hYUVBiOTJIMTVPL2pCeXhzM29GRCs4b2lGbndV?=
 =?utf-8?B?Z3BkTWpRUDNvSlFyMmUvUDlTa3JFTDhSRk9jUUtrY3RMeGt6Q3ZKSTZ1Tlht?=
 =?utf-8?B?ZG8rOWNzbXVlNUlSYm9KTStLR0lHamdYVCtmV3I0c2tCVURpY2pnTUIvbVha?=
 =?utf-8?Q?kSRS5PuHmpN1or9k=3D?=
X-Exchange-RoutingPolicyChecked:
	FWzDc3LIGJSCx6UdDGOxwo85bO89orLLT0Ye7oGxpvRH8HIg8M2qhhwZt5kFy3TNwF8lZqs6rL4GpFVQbYud6Ybr1IkM5vzV2BWuvEIFl1WZckxmcrHzYsjeKOvLqezMmdHFZRFWyDvlszHBnuAu6Q+eF6eNCJWxC3vryVnuYVf8ZlAqVAuxgrPiRq0evPaMY9K4copoE8aaDYUb8WoXM+mIRUhvRb5XQLEZmJoPd+punXwx7BNRQMoKbTP701H1BwLfS+Rxv1NjkZwBjz8q8u1Knw3NRot4t8zXXAjbvUuNCNBfPPPIetzX9NrAmvtgW7UF0AC0STbmWEV159jEQw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nvm+9RNhCtREl21FCgEL7hpNf5/+WCvWdUuAQyaavvng4vI8kgXZTB45oln2BObu4t4j7tGcZP4RESCFR8MWugEyRlF8MMps4m1kogoJtDHFG8oh8TPWZXHpA9m+oPHpxMAR32+cnFpAA1U+4RDCi/PRFgrNhozpE8d1TTH7+nUeQDfaT63WnInY85gW99yU/qJG48RjS6zMTZogQRxdlgVYSePb/fPKYik5F1QQ/Rn83fNFrwIZaCqGLZ1nm8hYgfrQUm32JMb93847l3nN/rf185Wk3JiEWVRpwk9rZ4Q9+egRRNLoSHWSueuiv3JdqARHu5pYVmaMq0T1dtg2HJT8BTMQDGLcM6PTI9U5hCCmq4DyxCIzCCwtvIb4JfjSCwDitkRzEqymsMOuBnwSGHJSRxFUVlpjFiKOx5oHtSpMoJHrR2+BKn/WgzMDBjHlir+F9ZMpFDfkTWz5OUjuXeoKAZiS+X/8WPGIkQoXQJzy2BBthNmWjhMBdox6QnQLI6M+aditF1W5KwbnuRZGUNFiXZMKBAyLVk34HOs59M9LOPM4MfZEDDiGkJC0kdWhGLePqQE9Y5htHrQsZOLi19E8xftkNJGmKDMvN6Hp+ec=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 481f4185-3dab-4abc-4f53-08df36740e83
X-MS-Exchange-CrossTenant-AuthSource: CHAPR10MB997722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 10:53:40.3542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OtVMedO8KxHP+ETdSHnywK5kh9Qx40gP1zlCL0p+iAEdZyngLh0VCyQWuY+nhWRpasEhwgmJ6LxxfOEA++7kTjH6WwDC9nlmNF4arpA7RsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6464
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2610190000 definitions=main-2610300042
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA0MyBTYWx0ZWRfX9KeWMypexTWl
 BLtsoYTRLKPD7ow/3FcjBVjZITsYLSjAPGwSRhHDREel35ObkSYzX8eK2DN8b0y20c5Ebv4T7Ew
 7Y0M/R9CBTyz5gvwViwknYpUBC+E8m4+b/qscGmDJu4q1c+Nw/Rtwq+9zlMLKWBK5WAEXtWewEZ
 Ub4zU001hNsodla+bjPwOqq4SFKPIMoz8/IjKxQ5BQfeqXlnFTKrQ/7IUu7hAMlWd2S97A63CMO
 pVHQrXpUR6MxBYai4SQLCnPrjjNBn3pDzEmslPA8CknJkEvUGL7ZINlTc1le3zirkeHVluw/ZEQ
 sXWmfmDTPB5idhy7l0y7fMnndalVzX7c59pcsfEpaffA7/IHj8gjkNQ3y5e21teuODkEQtOIFoY
 9875orE1suPKdox0G/01j6cSW8872AAseCzejfySR/PlBb4Me8pc6/irp31eGV6rf+pnxa0ulYT
 6jtv9sEwOZMf0pyJ9rQ==
X-Authority-Analysis: v=2.4 cv=SI/Xx+vH c=1 sm=1 tr=0 ts=6ae47737 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=968KyxNXAAAA:8 a=fybzUvBd16Gubq0c39sA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: kUwGkh62DTHmDxieY_dYcBwu4sTmy93t
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA0MyBTYWx0ZWRfX3jDsExY0nJfN
 VJ6zcCqZHCi2UJGU/spKc7SVmr6Vi4fOYlNyGGWhqKuoTbZnyR2zaDO991TmECuhbJx2gr5qxKl
 NXseYtOcVCkIJX4rlBxrsQI4YryK7NZUtx6X5SU+WO2yKjbUosY4
X-Proofpoint-ORIG-GUID: kUwGkh62DTHmDxieY_dYcBwu4sTmy93t

On 16/10/2026 15:06, Muchun Song wrote:
>> On Oct 16, 2026, at 18: 00, Joao Martins <joao. m. martins@ oracle. com>
> wrote: > > On 16/10/2026 06: 49, Muchun Song wrote: >> Static pmem Device DAX
> namespaces reserve space for namespace metadata before >> the user-visible
> 
>> On Oct 16, 2026, at 18:00, Joao Martins <joao.m.martins@oracle.com> wrote:
>> 
>> On 16/10/2026 06:49, Muchun Song wrote:
>>> Static pmem Device DAX namespaces reserve space for namespace metadata before
>>> the user-visible data range, and may also include padding needed to satisfy the
>>> Device DAX alignment. __dax_pmem_probe() adjusts the dax_region range to start
>>> at the
>>> 
>>> Static pmem Device DAX namespaces reserve space for namespace metadata
>>> before the user-visible data range, and may also include padding needed
>>> to satisfy the Device DAX alignment. __dax_pmem_probe() adjusts the
>>> dax_region range to start at the data range, but the dev_pagemap range
>>> still starts at the beginning of the namespace.
>>> 
>>> That is not valid for compound devmap mappings whose memmap is stored in
>>> system RAM. Compound page initialization requires the start PFN to be
>>> naturally aligned to the compound page size, because the head and tail
>>> struct pages are initialized according to that geometry. If the pgmap
>>> starts before the aligned data range, memmap_init_zone_device() can build
>>> compound page metadata from an unaligned PFN.
>>> 
>>> The resulting struct page layout is inconsistent with the Device DAX
>>> mapping. A later mmap fault can then resolve the user-visible PFN through
>>> invalid compound page metadata and hit a kernel panic while inserting the
>>> DAX folio.
>>> 
>>> Fix this by advancing the pgmap start to the aligned Device DAX data
>>> range for non-altmap compound mappings. Leave base-page namespaces
>>> unchanged, and leave the altmap path unchanged because
>>> memmap_init_zone_device() already skips the altmap reservation itself.
>>> 
>>> Fixes: 14606001efb4 ("device-dax: compound devmap support")
>>> Cc: <stable@vger.kernel.org>
>>> Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>>> Closes: https://lore.kernel.org/r/wlrkqqvg.ritesh.list@gmail.com
>>> Assisted-by: LLM
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> --->  drivers/dax/pmem.c | 7 +++++++
>>> 1 file changed, 7 insertions(+)
>>> 
>>> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
>>> index bee93066a849..d3a9b85107b0 100644
>>> --- a/drivers/dax/pmem.c
>>> +++ b/drivers/dax/pmem.c
>>> @@ -51,6 +51,13 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
>>> 	/* adjust the dax_region range to the start of data */
>>> 	range = pgmap.range;
>>> 	range.start += offset;
>>> + 	/*
>>> + 	 * When the memmap is stored in RAM, exclude metadata and alignment
>>> + 	 * padding from compound page initialization.  Otherwise, the pgmap
>>> + 	 * may start before the naturally aligned Device DAX data range.
>>> + 	 */
>>> + 	if (!pgmap_altmap(&pgmap) && le32_to_cpu(pfn_sb->align) > PAGE_SIZE)
>>> + 		pgmap.range.start = range.start;
>> 
>> Should we need to check here for pgmap.type == MEMORY_DEVICE_GENERIC ?
>> 
>> Considering the dedup is not quite applicable for FSDAX.
> 
> Good point that FS-DAX does not use compound devmap initialization.
> However, pgmap.type is not set until the Device DAX or FS-DAX driver
> probes, so checking it here would always be false.
> 

Right, I forgot about that part.

> The pgmap is also copied into the static dev_dax and reused across
> driver rebinds. Moving this adjustment into dev_dax_probe() would make
> its range depend on the previous driver binding unless it were
> restored on unbind. The removed prefix is only metadata and alignment
> padding and is not exposed to devdax-backed FS-DAX, while its
> vmemmap_shift remains zero. Therefore, keeping the adjustment here is
> harmless for FS-DAX and keeps the static pgmap range consistent.
> 
> If you have a more elegant solution in mind, I'd be glad to hear it.
I don't. Thanks for addressing this:

	Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
