Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9492270
	for <nvdimm@lists.linux.dev>; Thu, 22 Jul 2021 10:57:15 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MAv1KU010133;
	Thu, 22 Jul 2021 10:57:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=C2w4kp+rG9HlL3EklJQq+JF3wxj6RcQbCXzVN9BNisI=;
 b=eWYOTcULDN1HptMxSKICDKrzjLQuqluXGC/AKbH/Ql9lpeCk4XKE/neJeNtcczKSA074
 HtPA5/LSYOZx2NXIR/kljfyNoiSISxuD29q27qTPsMekmuOI+0U+Axa+Ag52YBRYKkrd
 ooez3Frj4R2ZXoQJq6JhdT0hD02eAdvkMQ/3HKhDTCCMQUduQA8h2kb2e+8UcSuOFWuo
 tZ4f1QA8c1AyTLRUlOHeOAdrYfyonq4bAf3NF6bMWy/MZiD05jJN3xhzgBB+02+Yc29o
 j/PNhJc6EqAQ9S7A1VR1FocPAHgoUN4IuolmCoqZELXZ9bcfgLMMxheyYpN1lK72bbyP Fg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=C2w4kp+rG9HlL3EklJQq+JF3wxj6RcQbCXzVN9BNisI=;
 b=U3t4AG7zgZD9TbV4DCLkpEZJUfvyxfxex9sZD2Y+4zf0RRxBlvAum72Z064M/Lrgtbpf
 1GYCyifs6x2Czvfg9f3X6sU2YR2wrwCVSa5XCHGFPBQP9+LOrjlTn/0dZqmNz4KbhKvp
 2vJmWlSJTk4NwjdDdie+p+U3Vj/44Va+D9S4hEQDCjViEfwhlW6ZxkNBn7PxCSM/Ybgo
 JBN048fYrrd1zHTlevGYsF5K6CsZmNkHkHZviPAy0zub3f4jcwWKgwTaQr/OOQfRZxHs
 6fbBC0se1pIBtfs4Aho70WZ1y5ZyJAlDjb+TxQwMdCjqmjS/mRFTlUTLbQ2smBmzBoGx Lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39y37t8hmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jul 2021 10:57:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MAuYYF087216;
	Thu, 22 Jul 2021 10:57:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by userp3030.oracle.com with ESMTP id 39umb4nx6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jul 2021 10:57:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHEOyYWpcr3rs5L3p+yp/GRhbKhthApQKUokxiEl0Fz6NYS1IfK8RLg7TLr+ad89K+ZyUvDUPQZ8EjGwQIAQ63QlY4eCwyPNRY5o0wanT/OfPVKvxdQj5tXcsF+6MS3EV9NkZpJ5WmlCvr5uDi8UliKIuw3kIOU3gzIj5ZYLksRGYGo9rexq9di3Kj2p61zxl6RNFVFdJOhwB/CtFmdilLqA1RaAP2Jek2vQ5G/r1OhW6VvT7i5HASVxlnFAV7BDvv76MPk9LV/nyijWosLWgL4ymy6KB3b161VJesEP7IMPDkWr0wTPCfA2xfA8IGxMc4p5mbRbSYJweVHG2z3cew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2w4kp+rG9HlL3EklJQq+JF3wxj6RcQbCXzVN9BNisI=;
 b=AdMhjPuvpUFJTPBx0e5rt9UQaJZtfm1glFps4Su9alTK7bgwyG4vouqOqgTgPStEUgcAMrD3esdgoGcxnQDcklcCIbqgGg63KcdV++Awl/hE2JEU2foaBC6YBfoCgzClLD/GTyB8Dp7QlAD0czrz2RcX7ippqsl9rM8ykluXefsV5vOLs6tvP02by/tafpmEb/Am19x1mz8LpjzRtXdtLeCNsmQlCoTcQQK6HEgXP8KCmxzfwBS9IWSxVGdExLm9QRs6HPCeNP1A/nU6kMT4/f1PLPr1M200sgb2iujkY0Yq+HvRqfhoQuNQro4U3tgv+nyvKbCXq3Rp6F+Slcic7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2w4kp+rG9HlL3EklJQq+JF3wxj6RcQbCXzVN9BNisI=;
 b=utb4sx/8kwXVMqNmhgtXlAJE1QodIE7qk8MYStiapydGOoBFwoRrvwD5VWt6jDEVh/xpqa/cHTJ26b3C/YYF9g+Qy5p5yNO9HzR8V8M/md/O96Xdfl92mGT8jynGvpCC9zzTyAS8p/lzEGPxwlNH5fpuNkXpTHAm9uBgyoW5P7Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3984.namprd10.prod.outlook.com (2603:10b6:208:1bf::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Thu, 22 Jul
 2021 10:56:58 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 10:56:58 +0000
Subject: Re: [PATCH v3 04/14] mm/memremap: add ZONE_DEVICE support for
 compound pages
To: Jane Chu <jane.chu@oracle.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi
 <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-5-joao.m.martins@oracle.com>
 <CAPcyv4jwd_dzTH1H+cbiKqfK5=Xaa9JY=EVKHhPbjicVZA-URQ@mail.gmail.com>
 <d73793a8-7540-c473-0e30-0880341c2baf@oracle.com>
 <edf0358d-7ef6-d18e-a45d-f36449b116f5@oracle.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <27e9fbcd-1309-999e-bc23-147f847ab193@oracle.com>
Date: Thu, 22 Jul 2021 11:56:51 +0100
In-Reply-To: <edf0358d-7ef6-d18e-a45d-f36449b116f5@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0169.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::13) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.85] (94.63.165.137) by LO2P265CA0169.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Thu, 22 Jul 2021 10:56:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2029eeb8-938a-4fcd-022a-08d94cff6d70
X-MS-TrafficTypeDiagnostic: MN2PR10MB3984:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB39849DC84BED85121FB81B09BBE49@MN2PR10MB3984.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	UBxNZMRRD3d39m2CebU9gB/bfKokPIc4kYIvXwnMZw3qb5KqbnB7xtJDPKT7D2IFFOh3Y4FjdruI5NE1X5XwAHXwd9FV592TVEoQSC2AoXT3JRen2LwY97qnG2IWRcVu/tEqbpIJt6yJPUD/fHqZFZi0cwdaGLdQkcA3RtRBkjEOIhePETw2HSAZh5ESPkzPVW8MvZz+mW2e+o+ohZl9BhkK+hbKy9O/PKAYjDPJmPHOKJXUG/VdPtFR22ujd+AiC/p3nP1Ln+mst/pfVpT6Osfhy8qNxvhna3hMn09gM8vBe/q3egaAH+iaBFTIgn8Lee0mz8hJMwVIcfAUVarnyDPYVWp945gVzSelhOsgKS31PZQBJpTcAki85kh2q8u/s9ES9SApA8cCBaPNJXl/D1Wv6dbAdT4VipY9T7xOmxT+EA1cMLnJBGgYnEGSsx1T8DOdPz1hOny84kYN5sCJueoENqoMXXqJNmWQt+CQOWWQ6vbQMxpqZr7AvcWSuMdqCYuVoRGTLuQsdDaQpjJam3lCCRvmusBpCOrr90I6cC6wuyszD4JZxRU2zLV5n1eJwOY3B6zDERHtdmcqA8j4KB7mhbC3J6rd1SbzA/yvO864Uc4SwOl47Tsk3S2oE0cFND+pzQjavX+hh93WixEuQtWWlWoJ43FMtOP5CENyUbqQ038Q181d/DryL8NkGlkv2SCsJDnVpzn+SQHmd3Z0MQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(376002)(346002)(396003)(136003)(366004)(6486002)(4326008)(478600001)(31696002)(2616005)(53546011)(86362001)(66556008)(110136005)(8936002)(66946007)(2906002)(186003)(5660300002)(26005)(956004)(6666004)(54906003)(66476007)(316002)(38100700002)(7416002)(83380400001)(31686004)(36756003)(16576012)(8676002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?c0hQZ1BQOUVtK3pseFYvR2EzUXFWZ3M3TXNZWm1FSUJxWmhkdHd6bktSYmFE?=
 =?utf-8?B?SkE1WW9TVnNrbHU0WHV4WXQ5d0VFbk9ZSmxNQm1SVnFqWE1FeWtrLzBvODYz?=
 =?utf-8?B?Nk9jSXhQWUIxUEFveEVVV3ZMRWRpd1krQWlQMENGTzh5VkZwMnBZclRPKzJN?=
 =?utf-8?B?WEV2SnFrcUEzSVJGN05aS212dSt0T3JDbFZnYXZvaU15c3IxRmUzQWNkODYr?=
 =?utf-8?B?UlhXdi84MStiOGVZV0YvRlVTdml6UHhDT3BITXViT1VGZmNhSzVUNzlzWGw2?=
 =?utf-8?B?VXd6VUczSUtabU9lVGJ3R1ZjQ1c5d0x5L0Y0MlpzaFBCZHdPTWlEdnEzb3Zk?=
 =?utf-8?B?a1NHQUJMOGJ0ZzQ5ajVYbldCNjY1TWZ5TlQrbzVIREtJcytxQWhKWFpxTUF0?=
 =?utf-8?B?Ni9zQWpJbFFDd2R0dUxlR2xrdGtjQmJDY1Nnd0pRY0VMTFp5YnFjd0V3VWdJ?=
 =?utf-8?B?cmhjOUVTNmYrRmJjNStURmlWS1pRQ3JzZnFYc0xNTEg3aEJ4YWM1eDVSRFE4?=
 =?utf-8?B?YTZBc2RJakdZcW9CdTJyaUF6SE1wRkpLL0srOWhYUjNwM1dmNDBNNjFOSVlr?=
 =?utf-8?B?N01lOXQrMEdGeHExNHZKTjErT0RYY3ZNeDZneXRyUHNrcTFRV3Q0Tmo1bWxx?=
 =?utf-8?B?ck9LSTMrbHVabEFYTDdmK1ZBVTg4U2l4L2I0MDlxNlRGWEhWamZtU2xjaExG?=
 =?utf-8?B?MXMyS2hKMHZwN2E0QnQxVmFabGpMRnVhdTlrRktKaGMreEFXT2c3bTc1bGdx?=
 =?utf-8?B?WHVHcG1uSmRQU2IxSzk0ZUZBY0Nldm9jRTdFQlJyUTRoMENITEhnMCs3ZXN0?=
 =?utf-8?B?Lyt4OFl1T0ZOT2N1STdRTGdJcklpTWk5K0lvcURaM1l3eXRkdXV0OGY5VW5M?=
 =?utf-8?B?TXg1VFhiSUVYbzR6WG9FRUVydlpOZTdpR1EzWTBjTGc3cGFuUm80T1lVTFRq?=
 =?utf-8?B?TFZhTEhSTEFERjdlTG9yK2pFY1NXbC8rdm5oMlVzUDlNSGZXKzdBMDUwLzNC?=
 =?utf-8?B?a2NhMFh4YTB5emRSaENHb0VjTXRGWUdnLzI3TFpDV1JhYXhkbGUvelNvVlh0?=
 =?utf-8?B?NzRQakRtQTU3RDYzMmtuMmRrWENDSTA3Q01hdGhaTGxQaFpxUkJ3UkdSazRM?=
 =?utf-8?B?OWdlZkVkdFVvK0cyZXQ2ekR5Uk04WUovV3hUK1ZLUnFzZ0pDbG5CZzZvRnJ2?=
 =?utf-8?B?VjdES0pvbmhxdHJPNHZYeDBCbDlVN25KNkFlYWRJOHJpUFpyZGxHVXFocU9v?=
 =?utf-8?B?SytvdTE4N0NHN1VWeVdmb0RGU1NycTVCOGxRbWF5d0hVQlIyMFFhdGJwYy9G?=
 =?utf-8?B?VjlHUEJXK2N3L3kwa1hORy90VnVQN3VQMVQyNzZBbHF1NUl5R0JkaHBCNmY0?=
 =?utf-8?B?ZXdsTE91S1k5dnEzbkQ4YXAxbUpGdmVnNGJsc0NtTkxCMDc3emIvaDh1T1RY?=
 =?utf-8?B?ZEVreGxvdmh2Uk92K0VNNW13RzhnOWN0VWlSb00yRFloTHo2YVk0cWNRL2VW?=
 =?utf-8?B?SHFSV05yRHV6UDJQT0QwNU1oSk1QZHoxMUw3b0tjMXVFQ1NCeXMzeGtkUGp0?=
 =?utf-8?B?dTJwQUw4ZmczcFBpVXpsMEpkYUhQcFZ3dDlGRHR6QVN4WHAxRGdRc3lPRDlj?=
 =?utf-8?B?bGs2T1hGWHJ4eXd4bTVZblJNWmtneDIyVldkSXh0OW1MeER1R3ZqWnVrdWs5?=
 =?utf-8?B?L1gxaVBpTG1IZVZ0b2hhejVaVHc3RW5aOU9WdGMwNktzNXVjYTlRNmxSeHNM?=
 =?utf-8?Q?HgN79cQL+Aukc3GwG3/LVSVYTc4G9KKF4WcaFyu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2029eeb8-938a-4fcd-022a-08d94cff6d70
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 10:56:58.7438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zPcWhXXpTvLMzMw4jk92kEgQMmi7ojClQMybgBa5dcmj04p/gzPQkeIE2c8IIApW4dlXRaDkWB1YHF4n3XlMiSNA3Lk1f37P3TDhhY5EUWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3984
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10052 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220072
X-Proofpoint-ORIG-GUID: DzTuyOBJ7jsqIrrSKm-u5UWvMLJnViGI
X-Proofpoint-GUID: DzTuyOBJ7jsqIrrSKm-u5UWvMLJnViGI



On 7/22/21 1:38 AM, Jane Chu wrote:
> 
> On 7/15/2021 5:52 AM, Joao Martins wrote:
>>>> +               __init_zone_device_page(page + i, pfn + i, zone_idx,
>>>> +                                       nid, pgmap);
>>>> +               prep_compound_tail(page, i);
>>>> +
>>>> +               /*
>>>> +                * The first and second tail pages need to
>>>> +                * initialized first, hence the head page is
>>>> +                * prepared last.
>>> I'd change this comment to say why rather than restate what can be
>>> gleaned from the code. It's actually not clear to me why this order is
>>> necessary.
>>>
>> So the first tail page stores mapcount_ptr and compound order, and the
>> second tail page stores pincount_ptr. prep_compound_head() does this:
>>
>> 	set_compound_order(page, order);
>> 	atomic_set(compound_mapcount_ptr(page), -1);
>> 	if (hpage_pincount_available(page))
>> 		atomic_set(compound_pincount_ptr(page), 0);
>>
>> So we need those tail pages initialized first prior to initializing the head.
>>
>> I can expand the comment above to make it clear why we need first and second tail pages.
>>
> 
> Perhaps just say
>    The reason prep_compound_head() is called after the 1st and 2nd tail
>    pages have been initialized is: so it overwrites some of the tail page
>    fields setup by __init_zone_device_page(), rather than the other way 
> around.
> ?

Yeap, something along those lines is what I was thinking. Perhaps explicitly mentioning
the struct page fields that 1st and 2nd tail pages store to avoid the reader thinking it's
arbitrarily picked.

	Joao
