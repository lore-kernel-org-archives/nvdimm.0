Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94ADCA76
	for <nvdimm@lists.linux.dev>; Thu, 24 Aug 2023 18:24:51 +0000 (UTC)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OIMf3w027064;
	Thu, 24 Aug 2023 18:24:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=49vsL0jTrKa+vr/zJHTYRnBO/KSDZ6czmr2AyeKgmt0=;
 b=x3WcCvlF7qZeANhRiF1ENvCm3aiAaFr//xaDUJiTE556MYDdK8uW2NcM22bPH6WDEEK5
 x0N7u4APFnlWz9PcJZlwxvwwnHlKmd02JC4E9934fVL0tuxlrGt3E9Ono8Pe37peLJ8O
 vxiVd5genFxrA7UmHPqj2UjbovIiMQFygVV82JX+/RWOvSI/Rs4K83y9oLIJKi6gjs17
 uI5cj67OYzjf3af6NdJ9S+d3In3Xij5b4HY4ts7+84JdwYy23Nx2f7nBED48d5fmQlUz
 SIEMreHCM+fhHc1Ad0CL5QczYDiMna2U43JQlVe8FHLRor/NaBbT3T80PYnG3IqDm4Sw Kw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn20dcrfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Aug 2023 18:24:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37OI1oFH005909;
	Thu, 24 Aug 2023 18:24:27 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1ytjjyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Aug 2023 18:24:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7sdoM7Bwxpdxk+TUMEPCz6Ozab0LzJfoIH/4ucv+FWNydRna4L6FVszq1hnczAt6bWP+DEPNnu15tsC04FZEWaub4sxg1KM47ckis2e9SkhvoI2XwcLGojfHst6DaUAqhx9Ntt4Z52lINOpqaQNTNeAsf4NtQgcCXg1gKZiXq1myEPm3hplJV2G8qzf2OXPGTo179X3mpZ5vqZzMDhfIv9XqrXgHeNWA9yYDya495NIWXHXnNPPrbk9QvCZZnVmjZ9SErnIyWUXoyjejm4SJDUcqiEDArhwSvH0dCc8zJLn2EuZcRSLZ4OnEGxwLOgmkhCdRUaxA9mB02my4je4Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49vsL0jTrKa+vr/zJHTYRnBO/KSDZ6czmr2AyeKgmt0=;
 b=Fca3ReS8nk8oOkxE3HVuYAUSUq8NwfNkXntN10Gj6wX4Y2EBuQWbooTCwFz3zOWBEBuk1jZ1wjICCZgvZ0evHFKndjI1hRNxleVaJHIcHJtS9GeJYW7EESq2ng8LQLRfu3nr06FzOzjW+F0RpBqJLHxupUQ+1F/yjFWZV0HQZcmhpGZf/hDay/Qv8XM49K+G1lM106BKpo1NP+2qX8FbH4AJocj6SAoKDjZVOwF5ZTI+BjV6sSTAZrJU/gugA8vmLXxHxwGGpoNGWQkU9DDXiUfQfb+95kv+7jbkveGqTQUFUYKitHPCmkhhPE1jbSBGQo5YdYN6McEEBlnIZq/a2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49vsL0jTrKa+vr/zJHTYRnBO/KSDZ6czmr2AyeKgmt0=;
 b=BK97qHBBKQOOg+bmsw70Hqep9A8Z4n7PE4w6Yqe6FmRWfvoAUXj4MhwfSRjoXli02/M1Kc9sMjeQb/vcprRUHBvjLFLdm6KFCEh/wMt5m/Px7SmRKrWD5RIqUqJ9/CFS/HVaC73Ss9CVGJaUhkTMhYRDzGaYnqtg44KiEssgXKY=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by SA1PR10MB6661.namprd10.prod.outlook.com (2603:10b6:806:2b8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Thu, 24 Aug
 2023 18:24:25 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::df9b:4211:cbe:cfc9]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::df9b:4211:cbe:cfc9%6]) with mapi id 15.20.6699.020; Thu, 24 Aug 2023
 18:24:25 +0000
Message-ID: <df52b1f7-7645-b9cd-4cea-d3e08897c297@oracle.com>
Date: Thu, 24 Aug 2023 11:24:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] mm: Convert DAX lock/unlock page to lock/unlock folio
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>, linux-mm@kvack.org
References: <20230822231314.349200-1-willy@infradead.org>
Content-Language: en-US
From: Jane Chu <jane.chu@oracle.com>
In-Reply-To: <20230822231314.349200-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0178.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::26) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:EE_|SA1PR10MB6661:EE_
X-MS-Office365-Filtering-Correlation-Id: 14bed797-3291-464a-a7f9-08dba4cf5870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nPhzVP/xa8gUzXt+ze1oJW3jG/kgwav7v4iY5PHcEEcEsme92OYnsXgP88KEDLwUPMUk/XuZXwJoo8MViMH4z+hmdWpuo9DmvQ0rqaHneIaGr1RijzZiL9Gd3g93s7WwqUXrKks/r8fPl/3HJ3BwK4OpwRsYJ/wUEVqfllOyTcTZqjuCpOnf6FhDr1CJIFFj4OZ/n4TFmZYecpNG/Rtm8gTIqhi9zTf8rHgV2Jgf/0loRbYx0rcYM9L0Gs9qsJMTD2CC5pakomJP7DSV37udIkdwRkijQMJzWm/0dp9gWukderST0vZxrkmPxb8STfkqz2FD2Q0zxoX5KTjkP02GBhLPT78yXFS25tI0oFmSpF8kv3CutnNBa14zfdh8uxsx4pMOG8i0Oxq5YeHdMPVfwYPCT3MGU2iV4C1IKYfZ2CDbA0BKcRtBKxUzMaUKV2ByMoqVjc9Qu5ISGMbE/4WHc+Xl8Xc5pz3dVliRow4MsJCVAedva398wpM6tMaZSauDQSlBkMMQBC0nvocOyjCcrfFnRYhsH7wCyPhLa42fNp/Tj4KqOK9F+ekrMB7BW2tTOILt8aFhxfC3tO1t6hWII/N+lljL6zkOR/IxtSgeRO0dCuYYjbfkVQXXSeig2z9y/jGPiKsPsYPRgg4INyVy3A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(136003)(39860400002)(366004)(186009)(451199024)(1800799009)(6512007)(26005)(83380400001)(53546011)(2616005)(41300700001)(66946007)(66476007)(66556008)(54906003)(2906002)(316002)(5660300002)(44832011)(4326008)(8936002)(110136005)(8676002)(478600001)(6486002)(6666004)(6506007)(31696002)(86362001)(38100700002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Q3MwR3FmKy9JQ0tJM0o5eElCN0tZd0NCcU1KaFJsQ2FQQjJlYndDUGQyaXd3?=
 =?utf-8?B?eU5ub1Z4cFR3OVBNd2JSbzVUSHhBRnRzSTJtZlFZSXRNVkZ6YnJMdFBCWHBW?=
 =?utf-8?B?RXJFcGl2bWttd1JlZExLbHM5Qk0xdEU5a0N5bk5tS29nTUsyWlJLQzd1U1E0?=
 =?utf-8?B?NHFYOGRJcHZQaGlMdVkra0lvM1AxNktFb3diR01WbTIxUFdGUWMvZzZIUjdE?=
 =?utf-8?B?Z2VUK2sxTTgwRWFwdkFsS1ZObDJXdnN6alpKMVRVaENZaGRkeE1DSm00azdp?=
 =?utf-8?B?cUpzcU1iV3dsZmRYbkk0ekZCaEhCTVJidE5obEc1Y21FelJvdG82RC9nMlJl?=
 =?utf-8?B?VDZobkFoNTN5U0xPQjdWcTNGa1VwbDJLNzRlZTVrNWtHeHkwU2VMYUhuMDB0?=
 =?utf-8?B?OHNvZ09jYnorNk16NVZmcjFCeSs5ekNvbC92SXBvRzRYWXRCUVRhWE9RM0xx?=
 =?utf-8?B?b3RUcEVGNjU3eVQxQlFoYXhEMG9tK25SM00yYjBpV1pCS0VnSnJMM3hWZ3ZO?=
 =?utf-8?B?M1VOOTFEUFhvS1d1ZXNGbGlSUlVIaXN5YThpWjVhWUt6Z2tLYmx0VUZHNTBl?=
 =?utf-8?B?cjRVZHo1ZWM4dWZOVHFIN29LTFp1M1FicHptT1M4UGJTR2xTbEh4SEJTMWZ5?=
 =?utf-8?B?MlNJRGNHeU1IbXdlM3F4cDhmSlUyaGN1Z2pGdTBIUU8zOURmZnBpcE8zZTlT?=
 =?utf-8?B?R1NEbTFKbTJwOEZ3TjJWUVZNbUZOdEF0M1FrdjdJSnNqOFdvY0lVMmI4RmhW?=
 =?utf-8?B?Z2E1UXpNU0hxWmNYcFBwdlBDaHNCM0tac2pvd25RODdsNE4zamRhTFpjOFdF?=
 =?utf-8?B?UFZmMm5ZbTBnVUlhU0lTWUY5VGltUUlHZjhYL0tPb2ZZTC9VUnlqdFlMV2Fa?=
 =?utf-8?B?TmNZNlVuVC9aNkRhRjhIOEw1b0R6ZEZDR1JaQXp4SmRmd28xOHhaNHFqcTBt?=
 =?utf-8?B?SU1XOHlZTE90bGQ2Y2FRclJFR3ZKQlZ4U2FST3N3QTdrZk04S3hSZ04zcWZp?=
 =?utf-8?B?ajlRdlFYMmtZK0NBN3kxZDNMMFZyeEd3bzNuS2QweXA4b09lTVhRczRUemZC?=
 =?utf-8?B?Ri9wekwwRWhRYkFzSkRQSFB4MnN2b21hU0tFWCt3bk9zOExGbUNYcjdmZWNl?=
 =?utf-8?B?T0V5bGthS09rVTBSKzYxZWp1WitKTmtsRU9WWFNuTUIwVFZ2cVlpVTR5NUp5?=
 =?utf-8?B?UitxVG9RMG1NZTYvS0VwM3hKcGR2VTBwS1lleHErMzE4M21SSmNYbklvUWtx?=
 =?utf-8?B?NFkrcjJ3cU4zVkZYKy92YW9RRTgwSjV3b3p5V2lwWmdzbEo1bW1QeEkzbTNZ?=
 =?utf-8?B?cFJmUkFwRVRVSzl4bXZlR1JQSEFUZi83cFRFem16dTJGUWZrTDRNWDArRHBC?=
 =?utf-8?B?cTF1U3pMZmZJOVB0MlI0TFlyaktrU2ZObVIxZXFsZmR1QUNlQnI5eW1BM0Nk?=
 =?utf-8?B?SDRpb2ZiNVNOWXM3bm9vV3p1OFcrU1V1NHQ4REN6cVMyTHcraFk2WHRUNFk3?=
 =?utf-8?B?OEk3bUNHUm0wSmR4MFF2V0FvVnlqZ2RiUXFldEllU0srS3pleG8rN2pXcDM1?=
 =?utf-8?B?TXBNRE1mWC9kYnYwSGMvUEZXdXNqRk5ETEpidVlZQTBrV1VpMjhyZ0ZvUDc1?=
 =?utf-8?B?WFhjNjZkbjJBekRvZ2xPTDNMQU1lZFhWY1JreVhkV0t0VXRoYUhlR1RzVitU?=
 =?utf-8?B?b1RIeWJCczN6bVI0MUpHTW9Lc29PQTBUaks2bTVnWDlDT0NxTzEraG9iRkZI?=
 =?utf-8?B?TVNoeFNHd2IxeWt1TERxa2U0RW1BMURuTlVIRGhKcncwbERDbkROOTIwbG1P?=
 =?utf-8?B?amtiZElPUTdBMDRUcmU1dm9CbGlFVnM5d1F0Nm1LeWFrZmFJTmdzcE05R3dv?=
 =?utf-8?B?WTRrRS9GQVZFdEc5U21xVFdKY2VaTGFpTkt0aVpENy9TRTFUY3MrRHdzQzhD?=
 =?utf-8?B?MW9NNjBiMktQVFpCZk8xY0hXaVU1UkVGNHJvRnlIY21GSEN0bmlFOHZ6aTR4?=
 =?utf-8?B?U1J3QklMM2F0Rm9sQlhiR3F0ekQ0WHMxWjBWVEt2ZkswRll5elB1UnFuamZq?=
 =?utf-8?B?UkZRQ1FpbGZBczlPTFBjQW9JeXY0d1hydmJTbVFiTEhxTTN5Uzg4ZjhpcFpa?=
 =?utf-8?Q?fiBQZtbcSogkk47F2xT+gyHeR?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5gpoMRXd0UY3hzSudPMiXi3xmnvnfoaaLDxSEvwUotwz+UyAQIGaX+/NBO/rN5PE/BgkuSD5tBCjK1mpGgGn/qaaVeaL3OxpXwmruZlPkD0A6EpDeuUA6RzC50xyg9cL6VwOCbaS8wzRNJZaHF+knfPScQUQT75VcNLC2TNiOStKL/X1Ivq5DvcqTkrIJCla0YfFuSY3x+Mc3MkDfsLAXtAXl7JYd5IDf2YcSRpsSeWnOWch834U4Ds+PViJ+OKzV9WqNe4M6n5rrkgslIddkQ4w2Ys8DQj6aYhhmmyRhBRF2GGGWvEHUXfwOAMsfggGsS9EkJCywdBDrhx+TfCwwLWxjHKYJIxtUosDCAXCuKTrl15beRo9t9UvOTjXSk7x7ZAozOyGx0N84Oq4M8vbOwlvhP6heMpXZTXYVcZxoSISasp4zF8ZLvoRadF1XhsSC14JM/VFvbYfsEOzYLm+WhN/GUC73V1I5Q5AyVp24kA+Bw5ADQdF9DF8R53XjFLH2v3S8Q4wk0rvMus/sspzusYs96Vg/W4yIDFsrE5bzJuNnB33/kh2NcCDgooNquO8++sasS0whpHIT80DTgoO8uwdFM1RIHrtYInH7qfT4SkZN0p5uHO8Zg1Z8epbXuSARBDxc1kza28YE3PVZcOZiXSgRW3JUEnwkgxTTAFuIvho3RKnLA6Qu/1Dq+9BuD3kcibgug6hB3FtTMZLoRb962xBoQM038yCGYgq5m2uxcAev8s350w2yb46iaDvvTXLPaDMaDUCBSKFR9BMufThDxvF8hkLiwSrzfRpCY8E2xTz6/6A15G+c0XUSOxATvJgbCUswGI3BnTLk3Hp7e3Woxb9jMAFs/CJ+FLKFqLzDfSSCWQFspjdQbeGAKXLiDUpjulzpVVr9TGeWReYr+LBZ20SHjNlxQs7gPNs0cjTCrg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14bed797-3291-464a-a7f9-08dba4cf5870
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2023 18:24:25.3878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ULPfnN5ClSrUO+zkXaCOMN8qQMIoqOyNpcMfiFdnR9/6s/+bBK1W9WqTl83wt+YQXQGfpGiK8BmpFmgKtIOTVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6661
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_15,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308240158
X-Proofpoint-GUID: aJwKt1TvWmHPLbyJ4y7os1cYYNqjq0cf
X-Proofpoint-ORIG-GUID: aJwKt1TvWmHPLbyJ4y7os1cYYNqjq0cf


On 8/22/2023 4:13 PM, Matthew Wilcox (Oracle) wrote:
[..]
>   
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a6c3af985554..b81d6eb4e6ff 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1717,16 +1717,11 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
>   		struct dev_pagemap *pgmap)
>   {
>   	struct page *page = pfn_to_page(pfn);

Looks like the above line, that is, the 'page' pointer is no longer needed.

> +	struct folio *folio = page_folio(page);
>   	LIST_HEAD(to_kill);
>   	dax_entry_t cookie;
>   	int rc = 0;
>   
> -	/*
> -	 * Pages instantiated by device-dax (not filesystem-dax)
> -	 * may be compound pages.
> -	 */
> -	page = compound_head(page);
> -
>   	/*
>   	 * Prevent the inode from being freed while we are interrogating
>   	 * the address_space, typically this would be handled by
> @@ -1734,11 +1729,11 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
>   	 * also prevents changes to the mapping of this pfn until
>   	 * poison signaling is complete.
>   	 */
> -	cookie = dax_lock_page(page);
> +	cookie = dax_lock_folio(folio);
>   	if (!cookie)
>   		return -EBUSY;
>   
> -	if (hwpoison_filter(page)) {
> +	if (hwpoison_filter(&folio->page)) {
>   		rc = -EOPNOTSUPP;
>   		goto unlock;
>   	}
> @@ -1760,7 +1755,7 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
>   	 * Use this flag as an indication that the dax page has been
>   	 * remapped UC to prevent speculative consumption of poison.
>   	 */
> -	SetPageHWPoison(page);
> +	SetPageHWPoison(&folio->page);
>   
>   	/*
>   	 * Unlike System-RAM there is no possibility to swap in a
> @@ -1769,11 +1764,11 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
>   	 * SIGBUS (i.e. MF_MUST_KILL)
>   	 */
>   	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> -	collect_procs(page, &to_kill, true);
> +	collect_procs(&folio->page, &to_kill, true);
>   
> -	unmap_and_kill(&to_kill, pfn, page->mapping, page->index, flags);
> +	unmap_and_kill(&to_kill, pfn, folio->mapping, folio->index, flags);
>   unlock:
> -	dax_unlock_page(page, cookie);
> +	dax_unlock_folio(folio, cookie);
>   	return rc;
>   }
>  


thanks,
-jane
