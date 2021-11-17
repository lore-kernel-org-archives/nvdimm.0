Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A262C82
	for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 10:15:51 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH9G8pQ019484;
	Wed, 17 Nov 2021 10:15:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=MxIQ5J0ZnhUrSGOw1EyqQBP9nZ/V2G1U5HkKB9ukiHg=;
 b=ZfynPG3Tr97MtfK0A7u69FDTWVwlPOiUJpvdvDeu8CUTISVwoOPv8ZRSFcF6wv6o6hZp
 P5+KhdxgDQ0P7EoBl/fh1KIRNdFE5cUytefZrhUJt7gZAwjdbcUsWV82HHnTA4ys5EoR
 +KTtScppceGBkW2Jg0QEHexUjX5M2Dkmzq1qjQdBboLRqgCw3ybKnInqFCPIAyLbGrBb
 UKZkvIiUDDFwO5NJusHhYv39jdE5xIYQdwKZa5BFiNhNuaah/Ylici5frA/6U64sJ0FU
 spWUrv2Orcglk3EPD78orf5wkAnD8v0c6yVYtwJp6A23SZutT1xn2WDzkiYzlrSxpzSX Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv5fe5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Nov 2021 10:15:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AHAB5iv120021;
	Wed, 17 Nov 2021 10:15:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by userp3020.oracle.com with ESMTP id 3caq4u11xw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Nov 2021 10:15:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCA6JWX0ETKeT7FwIs3GZW6dz2cmo0ZCTRfGcxX7riiio6Y+dD+7rYazUrBPkp9fNzel9gxcFCPqszr9LLR537UIZcttk0YbUmrbqM0CpALwHJp5YX14/DMBvhZQp3z03kawKMJ7/bk0lG5/eBcRx4mAlA15QW/w1e1i5hiim5tp2gvTSSYwOP+fK4+CachIYHK6st13uF4mUeny1bznaZrQtxkm1mL9AEPJsw/i+bViWK6xbjj6v5e3yO5HJF9APHCCTZnwmtl6dEv2yXUq5axE3pvoQiqfvn5WEEp4KhOT+oMLRMXz6EZIqLdCCTp59aA5cm2rWB8eaFOzoX1D3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MxIQ5J0ZnhUrSGOw1EyqQBP9nZ/V2G1U5HkKB9ukiHg=;
 b=NV1RiTYHC8l4jDnz7b5mVHUcYGF5fCF1FW1VwYuVGV1wWp+AvPWLlALrd1nKfmpoxgGCjZRF6ocsjU9lkhQiOO86B9veNB1OdTrp/K/E8S2KA7YiX2TkXFcXujnFTu19R2UeJY+j/+FyVD0mK+p/6ZpHXLjdrb6RdJ5TmR4+4R+DyXaWpYfR1gB8fG7Y0ruzaFYa1K3NdFJxKA2jro7qFzKHK3wVz6BcXEOy9TV+y1aM5GD1jd/S5Izhi7KABIpc+vjyOmkCY2ZMDMP/rE/qHtZFTjfEwOTm3XQ8qMhtW/tERT30Q4kBSk1XzQUVQIQW09jVAu5vwpCwdqjUkyDpLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MxIQ5J0ZnhUrSGOw1EyqQBP9nZ/V2G1U5HkKB9ukiHg=;
 b=elVSqHLzvsQrHumaasbJjbqE05/Pl+YVspWMwzBIhp9sJ0+ZBzTJMwqSVAPNrGsy3nH/sUJ39YQ7wN1Z2oCtAMIF7Ec6kKQebcAd2EU8iebiVesJc3Zf2U9eF4tb6pAwQNUg3UXWLIIt9PJy7+dWVN2a/5cJXxMrVJ9+IxRy0iE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3904.namprd10.prod.outlook.com (2603:10b6:208:1bb::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 10:15:41 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4690.027; Wed, 17 Nov 2021
 10:15:41 +0000
Message-ID: <b268df30-a488-7029-aa21-a258e8788b9c@oracle.com>
Date: Wed, 17 Nov 2021 11:15:30 +0100
Subject: Re: [PATCH v5 6/8] device-dax: use struct_size()
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20211112150824.11028-1-joao.m.martins@oracle.com>
 <20211112150824.11028-7-joao.m.martins@oracle.com>
 <20211117093722.GA8429@lst.de>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211117093722.GA8429@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0009.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.34.134] (138.3.203.6) by AM0PR10CA0009.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 10:15:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cac64014-e4bc-43c7-d578-08d9a9b33559
X-MS-TrafficTypeDiagnostic: MN2PR10MB3904:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB3904CE91180A6A971227A7B3BB9A9@MN2PR10MB3904.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	QmvI3GC39c2pSQo5tS+JSEewp34bFRgb8X4K5u3nLZ2q+Wn0cTcVmVnGr3CpxC8PKHlYcjuMSvkmRMsecpp/wFCX13+TpzTXcR827lsb9LY4LWhQK4JDlisvWA0Qt574QjaOcokHGZjccTwFu4HY7j9aP8C3XQIDiHUwHwsR+Oh78juaPm/ZhmhQAUBZb6r8hzSUtE0K2131MCkXMAOnuxBEgXREYCcw0/3GBeBpH5IAweGPcMhp/7iFh0a0pg2NTa/NOCV1Dc33HM/UfXPfaJiTXqo18USqUH+16L/VndBDVotvIw1JcLPdwecBcznLfv8S5oJpQB6Qv+Exn2tE46XjWtHxuv6/XcGiP7pTF6To1rrSOyA/p3wlgn9QvevDgyXrIXsW/ysQUhsucbyb+wxlWVKMfm/cMcCqDZPiJ2oRYFoCUW4CeSOhZk0deebyjIu6JClHj21hakG/8Y62k/rjDWmNHXWag5+WJiTH62Sdtd+2H6YEnrQ2VDQQTmCkBPzXPMrWq4qzrMs7BHda+uZTDPw0Qnzi9TDk7/rS22MTN109kcUx3H9seI0LymRVholBghe4ksnKXXdtXNP8yEtSVJd5aSBRRM7RMKX+7H5cnHBr/m9wWSUxSwigBsABptcTn6W3LWIOVSGf2y2fcBYFXTbovwviyk/YW+lqYVS1UYBH3n4A9lMHztap8G5rNnHP5BWtraEsF1I/I6nWOQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(7416002)(956004)(8676002)(66946007)(186003)(26005)(36756003)(86362001)(53546011)(6666004)(66556008)(31686004)(38100700002)(2616005)(4326008)(54906003)(66476007)(6486002)(6916009)(5660300002)(16576012)(508600001)(316002)(558084003)(2906002)(31696002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bWI3eWM3UjZJZ2o0V3ZKRlZMNEx0SGhCSUN6dWNvQW94eHUxSWZ1ZXNYbStO?=
 =?utf-8?B?MmFWeTRPaFNycU9PQ01pb3U2cWRud3ZDeXk0dWZQUXI1dlhGS2N1RVNCTDdZ?=
 =?utf-8?B?T2d0L3FWaUkybkNaYXZzaGhOQVlDZnc0cWVLbGRNUHFaNUNORDV4cDdLUldr?=
 =?utf-8?B?cE54ODViS0ZsdXRHQk16a1ZReHBJVlRPU0xsMmsrQmRaSlVTZkJ1MFpUQ3By?=
 =?utf-8?B?VmRXUERPQWxINmJKV3FzdzFjcWkzd3VXZlV5K05WQThIRWlFY0dpcVhJeW4x?=
 =?utf-8?B?Ty81TWJlVEs3UUpTOUc4MzBtRDJJd2VzdUhtTXpsNlVPb0FhdFNvOHB6a2I2?=
 =?utf-8?B?NDhXSEkzaUYvaWVwUGxDY0Jpek55eEtsMkVPdkJZSkNJdW9RSm50UmxzakY4?=
 =?utf-8?B?ZWJLNStUWlNqWGp6bHA2OGU0c3NoVi9oSkhFb2xEbWhkMFNLN1lIdzMxTTB5?=
 =?utf-8?B?YnVSbkhNcEZRUnJZMkdsMjJjU0IvdlNId0UrajMzNzhKZUZISmlPVm0wbkxu?=
 =?utf-8?B?TXltZndGWmxUUGZmcjRDYmZ4UDl2V0xWaitMekIzV2o1ZGE4WitrYzFUUkpz?=
 =?utf-8?B?Tm51czdYVjlOTWVRQmRMSWsrVk5IMHlRQXZEZWxzNEw0NlQyMHUyKzhra0pD?=
 =?utf-8?B?emM5WDkwM2dPNkVyM0oyM0JaeXBUM3M1a0lOUWwwWUU2S0gyOFUwQmdwL1p1?=
 =?utf-8?B?UmRWMi9RK1R5QWJDUGVNdWI0Qmp6ZStlSTNwY0JSenpMd1VzU1EyREh2WEhK?=
 =?utf-8?B?M2k5ZkpTMnJMakpFYVdGR2pvL3dqalN0VGFPemFrdjhYUjhmSW9jSTU2bHRw?=
 =?utf-8?B?RzFKUk5ic0ZDT3BZWXpCMXlXa2Z2RVJraDZYdHhBSDJpRWxYWmcxemowUWZr?=
 =?utf-8?B?UU5VSDVTODZMVWljY3FNQXF4Mk5TT2tZVk5KMDR6Y1NXS25BN09ZVHFjS0RI?=
 =?utf-8?B?SkpzZ1hDVFA1Y09XTVIyanQ3R2ZBSUZ2WDNZMitxb284U085anlmM2Q1Tk56?=
 =?utf-8?B?MXVpMEFVTExmM2xSdEszaG9FQklqeWNDZ1pqOWtXQzh6U3JXRllNQllhZUpV?=
 =?utf-8?B?dlI4cVpnOUE2elVCTXR4czllVlV6RkFRRGs4dGlzVlFSVzVkZ2E5RTVTYjQ1?=
 =?utf-8?B?elM5UkZtQVlKcDlyZzFUL2ExeEMxM1pwN29JWGxjeThkczg1VHhBRmh0alIx?=
 =?utf-8?B?NTZWMGVqYVd5REY2UFVwVWxwY0pRcWkrSFdBNkdsangrUlZLd2dleEllYXlQ?=
 =?utf-8?B?ZytWWjB1R1VvenVrTGJvVStwN3hZTzJTd2ZSTnZMSlVQTVJKN2Fta3Q5QURk?=
 =?utf-8?B?VUs5dGt6cVlBWFR5SGJPVUdTVUN0S290blUwSjVXa3FJSmluV1I0blRjV0Fw?=
 =?utf-8?B?TWwrR0prOG40VVFjQ3M0bGl4bFdlaGNvNTd1K2dzZmFteldiekV6K0xuckZF?=
 =?utf-8?B?eFIraUFnK3BKS0MvcXVDMk1oYzNrSGV5MlZCM2JkRjJXQmRsOUpIQ1hQMDFl?=
 =?utf-8?B?Ti94bTk4cVV2Nk90b2NPbTJGbGRndW04em1XcDgzUEpDdDhqOHVQRlBYbEdS?=
 =?utf-8?B?cE5hOWIxQVk1aHBodXJVT0NQY2ErK0hYRTcrRFBHTndjakx4bUh4NDRhU1Qw?=
 =?utf-8?B?NGpDeTlKMFdNZWNuRko2ZzI1cGZRNFNKUFM4eVZWQnJZRnRaRjFrdFZRY3I1?=
 =?utf-8?B?THpKZWhiTzk4SjNLalBVVHM1ajYrcFZMd2FQWE9jL3RGSEFEY2VuRVFYVGJW?=
 =?utf-8?B?Lzh0VFEyc3dIUlgrM3hwdTVUSk9zSW4xSnc3ODA1dUJqdWtCa2xRVzhpckNi?=
 =?utf-8?B?dGNnOElLMElvd1dPcVZEb1ZIQWk4b1dDdldpeFBxT1h1bFl5c2UxdHgzOEN0?=
 =?utf-8?B?M2gvM1ZyVGQwYnVEdi9SQ3QyK1FicDRkanBxMmh1dkhyd1AzZm9wdUtITnZx?=
 =?utf-8?B?ckJSVVFQUXg1TUhNdjlOUVZnOHdmMjMzVElyaUxBVWtKaW5Xd2Y4WkR3QUp6?=
 =?utf-8?B?bU10UVdUam4xOFFQNnZHZ2x4MEIvamxiZ2xnakx6ZW9wdE94WVZqZlNNU2l0?=
 =?utf-8?B?bFJLL2ZzQzB2RHMyZ1ZrZEtLTThRd2xTTzZKVStYa0hERmhQdWJteEFGeXhV?=
 =?utf-8?B?QXhOZzRWV3d4ZVFWamFka2dYS2lIenRDZ2ZpZ1F6Q1ZyR1NSM1RCMnQxbTRF?=
 =?utf-8?B?U0trS3FTKzgyTUFFano3VVhRUFhEYzFKTnFzRXVpQXhDc21ZbUtIcFI5SWh0?=
 =?utf-8?B?STFVZGJ4QzQ1TjBpekZJWk54aHNBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac64014-e4bc-43c7-d578-08d9a9b33559
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 10:15:41.2231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OeiTIW6NaCC9dt71f/IYd8iWU3ykd395Gjyq+ma7PrS28+mqP9Zlk7CrJBmhkvVvpzt2f+M8uxgyg2iWjBLZTEsXwFol/Iq6epKx7xLw4Jw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3904
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170052
X-Proofpoint-ORIG-GUID: mAktsivFDJN4Wvom-r1IjX2P_U3CyIjf
X-Proofpoint-GUID: mAktsivFDJN4Wvom-r1IjX2P_U3CyIjf

On 11/17/21 10:37, Christoph Hellwig wrote:
>> +		pgmap = devm_kzalloc(
>> +                       dev, struct_size(pgmap, ranges, dev_dax->nr_range - 1),
>> +                       GFP_KERNEL);
> 
> Keeping the dev argument on the previous line would not only make this
> much more readable but also avoid the overly long line.
> 
Fixed.
