Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.94
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793982753;
	b=BAFCE2jEHmrgHiqfJZWN3kKpmIF12dbq9JwsC3TH4iapgk0EKQ+aBcTjD80sMBKDnllF
	 5DILErwIl+x+tyJZHxkFehpO/gCmcDq5n57Qh7lEHF7DuxihXIy+6548ID3cz+0pe0XqS
	 AyeAhUoG0rmv4ZF8AAOdc95L1839uHEKFmySLAPpEcSC+UioQO8rXlzNJh2SzV0iIAlgh
	 6YySohydUNMZnc0UysOzgUsbLaF7qPR4By/Omiau/iv7KqitlBPJNK18vmHY46zNL3IXN
	 WDkVCJ/LCz963mtz5mDESnb6cesDILb9fWWjWzQwBLjRzODcHG475Rfk4b9N6jtxgTQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793982753;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=biJr2KYTEvPDD87JusUHAvdYHriw47D2bmb+1SNLT4o=;
	b=bwOyUo1Cr1WrSJHgh2ws6ZlA1Gnn+NBa46W33v6zN96mNV44LcnIJPRZ7gYsNsUUZLCs
	 eactGoVTNstBncB9piE5QN9i3YGm7lqYEyihOY5Su9Gee0txyrbTI2wZsl7g+JEQsYbCs
	 Z00SIr3Mg3WD1DCISz5mj/fSiUfNjKv+9DA7Nl36Tzlo3qePpA4LztNywiaXBxRZnrRlc
	 bAQ1Kft1Q5BF8HSTwTzXfJAyV3rpKdQRSMQIbbwGgXkAhuNpDyiuYrLTSvlyhCAwfp+rM
	 9MUl7/D0fSssOigIMRgj6C0BZvsl4c8iDrzGOjgNR3L/zoDhw1p95TJMmrCPDGcHpkA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b="d9z/Fea3";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.94
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021094.outbound.protection.outlook.com [40.107.130.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBD0606A334
	for <nvdimm@lists.linux.dev>; Fri,  6 Nov 2026 16:32:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EBD0606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=d9z/Fea3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RmZwVp73adQ2pLk4SnamLJ3+3SViBhtx4UYca/OYNHnFTqyFGlSX3cpkjEVaQF9dvrqcR28wd96gOaHi3gsBYMYSU3hqpDHdr99jHAVlmwuy3TAu/4eu/9fGg/UK/g2sBo5riK1czs3lEGy7gwdn7kOFBD/tJtd+YzIvoGuQi83anIdu/8p0qgQEHIVmn13ZZI2LPFGPAYogle6on9ZilVuHGvTBwhXCKScxxC2FbY8llgxVL2gbB4GswO+BGicdkRd2HYxkbMm9MC6tO8BE1D2D6wzA6W7HKfkgxWOg8eYEVfoC4D8VLNsM7xfJTEsxGc++iTCfOlsbaBbMhAjePA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=biJr2KYTEvPDD87JusUHAvdYHriw47D2bmb+1SNLT4o=;
 b=ENSEltiG9YB91xIXoHe4yi8SkBKwHkucZu9t2AzPS/f1x/YCSCC8hDven9NOHyenr9szwNMhTS6cHZ7heNmBRiyLY+XC9S4FV7B3Svj/ExtYA3laFuDIMcMhqDlEavhCMu9H03m0IZPM5W7d4V15+Sa9WR0IkgHVthYb3+ZDkdPQf526GYUcgv9HKjTwpanviBG+nFG6Gb6+HJvJljnS47lqe6sl59IkPtyxOvIEYJQtpWzcQSY3xw9Bjepf0q2p7bHxToJsW2uQHh7tsYcyo77RsY+wn5ITVCeKOBJ0UV0wGqhYrep2tbd4sAWT7wyzA+t4yVc3/K+Afl83NaCSbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biJr2KYTEvPDD87JusUHAvdYHriw47D2bmb+1SNLT4o=;
 b=d9z/Fea375lzxh8CYdI7S708zCg3qa1t6LXNBx5Fnv1rYyHyY9nrscaAsrzo6WsnJsWeh1AQTsJcqkxT4cpaCnNpQAp0cOZkeXlCOL10eHGv88ayDqBk1n2zvuzFsICFdcwJZB129pDAGkF3HW9ce84JF/YljqAlZ8cN+QyHUiTnq6OzZpOnPJPUFE+D55qu3lsT6u7GdR/yV1x766CVEHaAWisysv9UwvKNQAeNmBJWyzcZZKmrllGh21wjeaoVl+93095EEHhDx5zq1aCmxGvBxxptNVT3Y0iWpuHvxyMKee4WeCm0afKFamYJZ+2bFoOL8xM2CMLkhG0XRQ5eIA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com (2603:10a6:20b:5ff::9)
 by VI0PR08MB10920.eurprd08.prod.outlook.com (2603:10a6:800:250::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 6 Nov
 2026 16:32:28 +0000
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8]) by AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8%4]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 16:32:28 +0000
Message-ID: <a514a8d4-b9f1-4741-86f2-4671fad24ab8@virtuozzo.com>
Date: Fri, 6 Nov 2026 17:32:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory: take a reference on a folio PUD
 copied by fork
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
 <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-1-2828fe5a51ed@virtuozzo.com>
 <DMNK05HCXYUJ.578OO1NG15LZ@nvidia.com>
 <6f035f97-8b55-47ad-bd52-833b86b8ae8f@kernel.org>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <6f035f97-8b55-47ad-bd52-833b86b8ae8f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VIVP296CA0021.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:800:354::9) To AS2PR08MB9075.eurprd08.prod.outlook.com
 (2603:10a6:20b:5ff::9)
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
X-MS-TrafficTypeDiagnostic: AS2PR08MB9075:EE_|VI0PR08MB10920:EE_
X-MS-Office365-Filtering-Correlation-Id: d98695c6-f239-4d6f-1c57-08df3c238c2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|10067099003|18002099003|22082099003|261028144727099003|261026140227099003|56012099006|261026121527099003|4143699003|261009223027099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	Omy2+eM7JIZx9zaYXJdjF5w0IWhQHUZSRw9q9HRpR8eR75NAbU8+0ne30wGF0olmp3uHWGgW8nOQXuZXWz1evq+iIESk9neSp5qfSjPuSRPaa/HtpxwcR6IRuuCPWuI6Qn5Jywo5t4QfHJWP2G9Z/JeCNEUWmq3FXMXsa8KTVuDTjmBIs5mgHLVtoakxYCalnsPPHJSbwdGups0VREkL9YvhvQYLMYenWAz8ZAEiJZtT5TT/idddeeWNrmmfP1dc/uQVJRujymzgO6xWiPCYNHmykL0LdmX0O7deAX8yzPSGPPvNkeOA9dFBavejh1HLsIFno1mjcgr8fnawYf0sSlBD1ZEtvWKc0dskysWXEC3EsAkyyAHLx+MYo1wdu/tjONkbTVZY0egwz3+uiFVs+derQgJgGrYyahh4SeIMFzi1DCHTvDhK4RYnk4PllnkYd3xDZKnXY5QRlm+QZ3xiGzhffbAz65/8Jk2ECxuGxL9f+xdJozRbtxA5dKiFAeF2veDSbzx4w17qY7j6sE02/hv37y7I43uvj3X9ny7NK96Eagos7p95R4AIrJtKBsRxASivj1gDi5No/WTukgTUqBUwe9C0stWG4oIrcCxujdRyE/KI0NG/X1mF3Uw82huo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9075.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(261028144727099003)(261026140227099003)(56012099006)(261026121527099003)(4143699003)(261009223027099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0VoNkFqSDdUaGZsaUtvaFowdjlDeW5uMmtOb2gxWHNYRCtWckppeVBnamZL?=
 =?utf-8?B?TU5WcDE2M3pGcEZHb0RhRXRjTzZBdE9VN0U5NE9GOEg2NEp4YzFXRjA1VGZT?=
 =?utf-8?B?alg1T1JTTjZDc2xkaWxOaU5PUmVjWVkrS3l4dTc0RFJKSnErZmVHem0vRmlW?=
 =?utf-8?B?T2xOd2dEZk0yb3VwZ0JmWVprOXBnZklzb1R5QVRuOUJhcHhvaE9URTF4RUd0?=
 =?utf-8?B?MjVOYUd5bUpaQWJocmdZREorKzJRSFpqTjhiWFVRMUdmaDdpVDU4UkxvSUE5?=
 =?utf-8?B?WENIaWQ0dW5XcHBWOWQvVUIxMmJCbUdGVW42L3ZJYlk1dG0xNit3cUJ3NnJI?=
 =?utf-8?B?RjVDQlFHdWJ4NTd0U2g5MUUrZFAwZDJDMmJtY2cxRWlJSjgxZElBV0Y2TjJI?=
 =?utf-8?B?enFjaXhDSWFNbEtqV2F2WjhGSlVzSTBTazFHYmV3RHBodldhRHJiRkJWUWl5?=
 =?utf-8?B?WHFDWmVYbzcvWHpQSG5KZlRFTmFRVk9STVNiUFdWcWx5bFl3R1BPMEM0STBt?=
 =?utf-8?B?amZtVHhTK2JMWThZdC81c29vcUZlUDFvU2s0bWtEcEcvOHBuaVFURk85cTZX?=
 =?utf-8?B?Y3UxUzN3MEUwT3lmVUxGa29ydmJPL0NYREFaYjJjMUJKVVNMNzloeXNnNHlw?=
 =?utf-8?B?WmpFNFhyRnNEZFgxRW00UVJsdlVZaG51MEt1RHFlM0dyY2xucFI3anJyejdp?=
 =?utf-8?B?bzRRamt0RDdFdHdTSHBIcFVhQlV3amR0djZMaGJQeUErbmFMK2owYmVsQWJU?=
 =?utf-8?B?clVFV0VpTVZrdERONFhRWHBselNwVEhpK2Yrb0VkR24wczhkTjhhdXRoMkJ5?=
 =?utf-8?B?RzBxOWRneE5ERlloSmVLa3JEYzdXYkpNWEllM2FYblo2VnJzbWhHRVQ2WDA3?=
 =?utf-8?B?UGd3ZDd6VGgraUFLdDV6V0hpQVROTnVhWjBTaVhZNjlablZUR1hQdGtJcW9Q?=
 =?utf-8?B?SEFWaW51RWpuL0ZNRldqOUZJekl0eFFFMitmbUUxaXlncEpEaW95bXplZXcy?=
 =?utf-8?B?R3JXUlU1Q2czY2xlTnlmTDRiSXVNSHdCWTNmclNSSXpwZHp4R0t0RFdwbTN5?=
 =?utf-8?B?VzA4bXpRTnFBc0RiclZhZVZOeDZsWEpGelVmenJKNmZsNGp3aFgrZ2JQQUo4?=
 =?utf-8?B?cTNRVTNsNlhlVitaSW1ramJFNWhka2JCSnFxby81NW1YMTIrNnVtbjZQOElR?=
 =?utf-8?B?U0dzbEovcVlZRk14N1p4aFhHNGU4WUs1UWFzUmtHVDlNemN5TWRPWkIzVmkw?=
 =?utf-8?B?Z3JHQU50Z2ZoM3ovMWQzZ21rSVcyT3daVStoNjdTN3h6alRCdlpKbCs5S2lS?=
 =?utf-8?B?SThOd082WUNKcGRWTTcrMDMvbERjMkdZb1J6S1FaZkpHUW9pQnUrcWQ2b0NI?=
 =?utf-8?B?R3VtV2ROT0xEZDhuRDMwcWtESDR4RWVyMjBhZ09LcDdRaW5QelRndzdWdUJQ?=
 =?utf-8?B?bDJwdW5wZDVvbUtaMGJkbWNnQ3BkQWJtdjQrSEsyQXJud0ZFSkFJRUpwS0FD?=
 =?utf-8?B?Y3lqN0IvNlBPREw4a2Q3a2svQ3RaZjlRRHRaVXA0RFQ0RHdBUXh0TWxBMEh2?=
 =?utf-8?B?eUM1aXpaN3RLNHlDY2d0UmUzeTdlY1crSVlUdnhsRmhFUlFIWEFkR1p4YlQ0?=
 =?utf-8?B?c0tqVEhnWmg5Uzc0S2czbStJZGRSV0RPSkFjY1FPbmNFeU1WQkRYZnR2d0tx?=
 =?utf-8?B?ZHRtRzZrSWZqNC8xaVZXcnpmQU5tZlJwTVMxSVE2VmU0aW5ndzBPMlErTnli?=
 =?utf-8?B?OXY4UzMyOG9jbXQvN3pYVHE5Vkw0UzcrY2VHOXlQYUMyUlI1ekpSTDUyOGNW?=
 =?utf-8?B?MVE1YXllRlhCcU1nYWVXZlVGVXJRS3RHMXZrSmRPRVJsdUQzUTlyK3F1dzF3?=
 =?utf-8?B?ZmRqbzBRUXJBQTJ5bGtheEN0OURacnBHRnJLT1ZKQUhWNEFlM1Fmek10QWZ4?=
 =?utf-8?B?N1NybjVDTFJpTlRmNzlQT3UxTVhoTEdhSXpYTEhiV2tDQXkxVnduYmNiSkxy?=
 =?utf-8?B?UGtSbHRyV1oybEI3dW0vU3VzZFBMR1VrVktkbHJPQ2xNNGZESUZYS25pWnls?=
 =?utf-8?B?TEdQaEZuR0N4WWp6dXRJS2Z2dDZwaW5pclY4VGgvcFdPV3EwSjFXWllqMmxQ?=
 =?utf-8?B?VVZZclB4Y2JyaEhtQUJVMzJVZ2NwMzRMZldvVWcwWHFaN0RrVjFReWV5Zlo0?=
 =?utf-8?B?UWxRS3lJbzUzeVA2T3dlQzRDV1p5cVlwa3czUGprczlUSW5NeEJUZnhyQXQ4?=
 =?utf-8?B?N24wSWE1RXNtbEZqQ0dQMVdSWFBDWWVoNFcvMVdJQ0pNMGNiRnoxcVg4NFk3?=
 =?utf-8?B?VWN5RjhkN05GZ295MG9KQ2czN3dwdi9ZODVXdTFkK3lnK1JxYTBwQT09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d98695c6-f239-4d6f-1c57-08df3c238c2a
X-MS-Exchange-CrossTenant-AuthSource: AS2PR08MB9075.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 16:32:28.3912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bl2YdeEE55sXp6NpRV1gV+c9fEYS9O9bIv21eGeXRJwkt7ZWz2eNXy5VARxIh3C1oTGQg3yADB1Pqa7IP/C7oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10920

On 11/5/26 21:31, David Hildenbrand (Arm) wrote:
> On 11/5/26 21:19, Zi Yan wrote:
...
>> I assume this supersedes David's version[1], which uses
>> folio_add_file_rmap_pud().
>>
>> [1] https://lore.kernel.org/all/20261031-fixes_core-v3-11-d6437171ecc3@kernel.org/
> 
> Ugh, I thought I dropped it to wait for this one here. But turns out the flood
> of patches confused me :( (hoping I didn't drop another one by mistake)
> 
> It's already part of the fixes PULL request:
> 
> https://lore.kernel.org/linux-mm/20261105084704.5703-1-david@kernel.org/
> 
> Konstantin, sorry! Can you send a follow up to introduce+use the dup variant?

No problem, will do the follow-up on top of thp-7.5.misc in the mm/core tree.

-- 
Cheers,
Konstantin.
