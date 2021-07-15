Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9E7168
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 12:01:13 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FBvjIH005285;
	Thu, 15 Jul 2021 12:01:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=u2DK3VO0OSYR3RwxD1iYZ7J80I1M7LrOEMD/76Cq6Bs=;
 b=v92yG0cYUsz9MN0VyI6zdbDEOcLl55oxaC+U701LEXDWncfAdgJU7D+X+B6VtQI3mFWq
 Vr29d0H+s+jvw7RYnJi7PXEY+b8G1QylWNaIhT2gVSXDyWmJYj0cjBDJaIdyS7tPTWlL
 yHshneH1mWKtmjIftxRGRPACb7wZVC5YIcAkig3L/H4UZ+MWMcvkcuQxaDMopey6k6lE
 EY39OFacsmJnUuXSC7Pvsyzd3PkBfzn6/fSlAHciRoI6hqH9TGwFQtATNYiKIZa+FZ8G
 tAh6sPFjsKLih+NXEfz86sKepG/UJgF6v6nv1SWZHAPsr/qadIjzuN8gAYIe0TO38Tcj EQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=u2DK3VO0OSYR3RwxD1iYZ7J80I1M7LrOEMD/76Cq6Bs=;
 b=zKmSuXhx/V/MyzhElYa05mfFD7q6/XABvHFGwSnsAhq3yLQmqLQxMpeT2NIqeIbJjlDe
 Kaxcipf8/cZ5GYzv8intp0uAXQHIqbrPVQPMwgSwEz8MyT+NrNUW+c/egMKZhBY10IoD
 d4GEI5OxlWT0yxasbylQmShsCZI06F4mmfG1xIS/7uoGmGK83qp8k3OpOPD9L+CqSblx
 RRG/iuwEFugB6HmLoASJfhF+cJCC/QoiN7cgHd0yeaWKY0lA6LyYATiSLRb4mTJ4yKOR
 GhHmHVg6xQs38FpRo0iUPhO/0uOL/SRfCRvbfr8AfMuJDcvuY8JS5IPpGuyyU4RusNwc mQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 39tg510hjb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 12:01:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FC0nZ1160281;
	Thu, 15 Jul 2021 12:01:03 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by aserp3020.oracle.com with ESMTP id 39q3chbkfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 12:01:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9MMtkGyZ09uXo4nW7OUdUlfwa752zZuVMZgKIzp7kcM+CDK6mBrodvxEwippCZVCcT0+3yqN0qWIiD0VT6qprEUvyavDMO21xT9ktCt4ULTptLuQ3+BWbXgHC8ZHhCKmZwE2O4prpvGIyrsUexpaGYt3TzmugJrv0DXhe0dvzutHnoE10ah/fgCJsuV36UW8m0k5+ANlqsPtqxc1IMzcVBTQDvU+kJNZB3HFmYqeKH2NB7zywlmCt3Ii8wahLJc7VAEE6hgYt17Z+Q+KqabcLgL4Cyp1foKXBPsiqAALGhLFs3T/pSw03kwKV+lv/QvhAGgWStq2tYgpIEzdju1fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2DK3VO0OSYR3RwxD1iYZ7J80I1M7LrOEMD/76Cq6Bs=;
 b=SmiI1skBF1JsKQc0s/CAWGab1sfybODxn5zhPJx4GcszZVGU+hrtU7B3044SGhG46+8BoGjlmyy3zi47vyIyjU4ybdzggEWL11blaks4+rYVpEvjGJyw0Pcn0aLavxb2rMegTjt6ixphGQ0xtGMRe5UJBYz8+oQacGV6KVR0qg7AmPbWDzxz7yTQgzAwuX5nb21H2hgNiHamoacQuxkQbNCE9euesKP5JjypVgYY4rjfGbqcF+j5TcFX9MINlrrmo6rw4TFWm3EzUoOAXY5p8C+dNjkhAG8Cfa7LwiEmNxc6UdVQHkPR1UaTFwxVfyQ0vBxEyR9ue0pf5G6SoOhIlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2DK3VO0OSYR3RwxD1iYZ7J80I1M7LrOEMD/76Cq6Bs=;
 b=woV02JYaSspbCHa61+zQgZKyNrcSrMxYOzjw+0BFxZDzpHbp2gwTWowKtaA7IWYEpOhC/KMskQA1hWaJql6N0mAsoF9NBVQK7O8Tc1tjoHE7SYUBUh+l/Z2AG+FPlReoen68vJjMqSr1jlZYM2402mqDchaEOz1iBeILfZ9WSZg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3856.namprd10.prod.outlook.com (2603:10b6:208:1b7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Thu, 15 Jul
 2021 12:00:54 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 12:00:54 +0000
Subject: Re: [PATCH v3 12/14] device-dax: compound pagemap support
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi
 <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-13-joao.m.martins@oracle.com>
 <CAPcyv4h5c9afuxXy=UhrRr_tTwHB62RODyCKWNFU5TumXHc76A@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <f7217b61-c845-eaed-501e-c9e7067a6b87@oracle.com>
Date: Thu, 15 Jul 2021 13:00:47 +0100
In-Reply-To: <CAPcyv4h5c9afuxXy=UhrRr_tTwHB62RODyCKWNFU5TumXHc76A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0416.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::7) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0416.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18b::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 12:00:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bf1b42e-1917-4dd3-3539-08d9478832b8
X-MS-TrafficTypeDiagnostic: MN2PR10MB3856:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB38568EBF5549EF343B94F72BBB129@MN2PR10MB3856.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	CenGV/MDdntNHEve6h3/Mr1UMcb8EXXGCk7lv9uRbWPSeJjGlLbZ2uH/SireArlpHhqE9vuuS2eLUp59RMej9c3IlVgGUQTbe1mX2x3AWF88kvc1uAl8JWX+X8f7nGkUPGsZ2txPRT1WWd/B0bel7l9BcXalyH+oApQzcFQbAwBgh5pZr00aJWprwh5EwdxFPy7+nA8pBQxhfIJ0oPz88veF2wIP3GDADIW9749U8jqW2ckdF+nROrsmYsWC1a1cpTmB+E0RPWnh8ZG0OiBA+fz2RZV1N6k8iRnik/+iWUK+P+8woK/dY8kdwoUopNTTE74RCRHj8BkDkkc69hT6FyVv1lQUexDxf0boJWIdvHCVrrJMOCEEdZ4Pg7BkCSLFY7P9Nj/wOaNhJOJQcUjR1SIYS6dmyLFmedlPKyiuZCVjZttmKRNlRIA6eML3tO/XkTb4tRtV19pogcCRqJUYlvz+x8DP22JKwEynsqeP/BAFhj58ysN1eW1TjpL4tOH5vF6G21GluOLSL6Qdhv7KXETykYfCwsoybTQq2KHEff1zrDB0Jq9jY0iO+iTbXE43r8X3usC3wDonpx/NWnIO2qy8LQe4tMs0ekyLznwYDYK9/UV4aX1k8AphCzPz9t7aKDNf45Q7azzPAzlzkyoa0SoveOuTvltn9eVQBSJnsdkgwgO4G/Y4jrVolObhtOYrj9seFzHEACErHqwnK5bnpg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(39860400002)(346002)(376002)(86362001)(31696002)(66556008)(316002)(54906003)(478600001)(36756003)(31686004)(66476007)(66946007)(2906002)(16576012)(6666004)(186003)(4326008)(6486002)(53546011)(5660300002)(38100700002)(26005)(6916009)(956004)(7416002)(2616005)(8936002)(8676002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eHF0Ny9PMlFLQUYxZk05RHd6WEx6dWZ4NnVLNTBQK3daNXVGQmdqWW5NVnhC?=
 =?utf-8?B?OW5QZEZicTNadWQ4VTlkTklFOXg5Z0poKzRQL1BoeHo4aW13REcxVWpwVi9s?=
 =?utf-8?B?TXRCbGpmNE9Na1JnekJiSG1GeVVwOXgycm1tOFA3ektNd21jTk9PUFdSZFow?=
 =?utf-8?B?M0F4SkdqUFdoeUVBL1g0TG85R2NHcHhocU1FeW96RWE1RWQ3dTM2aElkWjNh?=
 =?utf-8?B?YTJMQWdEWDN2bjIvN2RUVk5rcittbktxS3ZLbHZHQ0FHbzgwZUZJM1FzbjRq?=
 =?utf-8?B?b0V6NzBWY3N4Vm9CbFZrUlkyRUttMzlkekpBUDhLZERRMHUvUmN5WUJEeElR?=
 =?utf-8?B?MHRISjVacEhjMUg3SU04UVp6bklVRXVTZjAzak13cFFtczY0dlEyMnJhZFJv?=
 =?utf-8?B?MlN2R2ZLenYrb2kvdkFDUVUzcC9MU0x2VENkd3ZrUDNocmh6RCtKeHBYS29l?=
 =?utf-8?B?TytrWm53WkJ3b0cwQndVNFpxQ1pRcnZPK00wUmEvTXVObVl0VWNCYVd4NEor?=
 =?utf-8?B?cGs1LytnRXMzd2R6aVRvWmxRZTIxT2Q2YVIzNTJFcjRxd2l1em9iamF3VVVi?=
 =?utf-8?B?NVdNZXZMOWNxVWtWRGhSOEVUcVlYUlBkaUlmN2NMN0FIYnVnU2lCb3dXaVVN?=
 =?utf-8?B?SnRySkpra0VaVEpoZjY0ejBHbnRWTmlCL3B4SzU5Y2VMcmc3N1UwV0FqcnJi?=
 =?utf-8?B?Qmp1d0JhRGkrMEpualRhWGVSZmJrYzZDSTI2OFgxeXBlVnJxMnpxS25qSWJM?=
 =?utf-8?B?OXdNYVJITmUxRlJ2T2NsRVZFNHAzaVE5RkMxbnJBVWJEQ29JM0RLM25uWFNx?=
 =?utf-8?B?cWNDb1BXWjk4TVVxdnRSWHVTUFU1eXFNTHVMdVp3aXJqMnJWTFg2TnhLRGQ0?=
 =?utf-8?B?WElVY1VveUM3UXpkZVVMRlcxMS9TMHc2cEdkTTkvM0xxb2Q0RzJrUUdqMWYy?=
 =?utf-8?B?bDRsV0ErQWhybEdjTVlOVWg0clU5QjB6RGpDT3YzZHdKenhkTlg0UWdSU21v?=
 =?utf-8?B?MFV0SGpLc215T2MvOFNELzNNZ2NtT1FUUWhFd0lOYTFmb2w1YmJVU2FHdUpG?=
 =?utf-8?B?b1JkQWNFT0FhN2Z2cVRSSEx4QkxZV3g4cjltU296ekJCYmN5R3o1SVdPMlVV?=
 =?utf-8?B?WVpPdE5CeTRRQjZXbExxRVdUYWl6dU5zK3lqdUl3MEJVSGxIZ1IrSDd6aTNI?=
 =?utf-8?B?MWNGY2Q1UkR5MVB6ZFNycjhzdE8yaGl4cUUvWUJWZjg0NGVCd0ZCa1pxY1FQ?=
 =?utf-8?B?TWYxRnNFY3NMR2hVb3JZSzU2d0MvTjUrVkxwa2k1TVQ4cnlwQ2hTZ0MzSEhj?=
 =?utf-8?B?RGRvZU1GeHJpeW5WdnlRbGlwOFFXNnN6THJETzBsdkQ3THNXTjllMXF2OG1s?=
 =?utf-8?B?Y0c0akg5b1pzU3kxakR1MjczZTdnc3RvaG56UlNTWUdNZHE1M0kwVWpCZDNa?=
 =?utf-8?B?aGV4N2I1Um42Vy9XOC9RbldEMnRqM0lEbFVQTEN0WDFMdkNZNjhGaU9nalBh?=
 =?utf-8?B?SFljZnFMTjgrOE1hemRudk1DREZCWnRla3NKSHI4T2NaU2dNSmNLbUEvV1Uw?=
 =?utf-8?B?dzlTVVJnMnVhZy95RVc4WURWemN6cElHZXpHdWQyditmMlNoWkI2R0c1elU2?=
 =?utf-8?B?aDhGRjhOWU92ZWl0c2QxQ2wyQnNRT2MzcmpVWEl4VFNOYmtrY3gwazlLbXJv?=
 =?utf-8?B?K2RRVFVkSlBRK0UvQSsxM0lOaC96ZVdzM3h0bjhQNmxmMUoxZkwvUUJOc3RV?=
 =?utf-8?Q?wmy3nYZH9WK7e0c+I7PqQq1pRGomd48cPI/hlhO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf1b42e-1917-4dd3-3539-08d9478832b8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 12:00:54.4759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+iBFAIYmJeTKDlkNgRA8zSoH0SC7cO38/I4Az2pFajFupF4t7wQhmP4IPjNBLS47kS2Sm6L/+lptOwp1aNGa87u7HYTU961B7icPLozg18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3856
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107150087
X-Proofpoint-GUID: -p547N4eHz_CFHoz2md6AILVp4lCVdlS
X-Proofpoint-ORIG-GUID: -p547N4eHz_CFHoz2md6AILVp4lCVdlS

On 7/15/21 12:36 AM, Dan Williams wrote:
> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> Use the newly added compound pagemap facility which maps the assigned dax
>> ranges as compound pages at a page size of @align. Currently, this means,
>> that region/namespace bootstrap would take considerably less, given that
>> you would initialize considerably less pages.
>>
>> On setups with 128G NVDIMMs the initialization with DRAM stored struct
>> pages improves from ~268-358 ms to ~78-100 ms with 2M pages, and to less
>> than a 1msec with 1G pages.
>>
>> dax devices are created with a fixed @align (huge page size) which is
>> enforced through as well at mmap() of the device. Faults, consequently
>> happen too at the specified @align specified at the creation, and those
>> don't change through out dax device lifetime. MCEs poisons a whole dax
>> huge page, as well as splits occurring at the configured page size.
>>
> 
> Hi Joao,
> 
> With this patch I'm hitting the following with the 'device-dax' test [1].
> 
Ugh, I can reproduce it too -- apologies for the oversight.

This patch is not the culprit, the flaw is early in the series, specifically the fourth patch.

It needs this chunk below change on the fourth patch due to the existing elevated page ref
count at zone device memmap init. put_page() called here in memunmap_pages():

for (i = 0; i < pgmap->nr_ranges; i++)
	for_each_device_pfn(pfn, pgmap, i)
		put_page(pfn_to_page(pfn));

... on a zone_device compound memmap would otherwise always decrease head page refcount by
@geometry pfn amount (leading to the aforementioned splat you reported).

diff --git a/mm/memremap.c b/mm/memremap.c
index b0e7b8cf3047..79a883af788e 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -102,15 +102,15 @@ static unsigned long pfn_end(struct dev_pagemap *pgmap, int range_id)
        return (range->start + range_len(range)) >> PAGE_SHIFT;
 }

-static unsigned long pfn_next(unsigned long pfn)
+static unsigned long pfn_next(struct dev_pagemap *pgmap, unsigned long pfn)
 {
        if (pfn % 1024 == 0)
                cond_resched();
-       return pfn + 1;
+       return pfn + pgmap_pfn_geometry(pgmap);
 }

 #define for_each_device_pfn(pfn, map, i) \
-       for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(pfn))
+       for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(map, pfn))

 static void dev_pagemap_kill(struct dev_pagemap *pgmap)
 {

It could also get this hunk below, but it is sort of redundant provided we won't touch
tail page refcount through out the devmap pages lifetime. This setting of tail pages
refcount to zero was in pre-v5.14 series, but it got removed under the assumption it comes
from the page allocator (where tail pages are already zeroed in refcount).

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 96975edac0a8..469a7aa5cf38 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6623,6 +6623,7 @@ static void __ref memmap_init_compound(struct page *page, unsigned
long pfn,
                __init_zone_device_page(page + i, pfn + i, zone_idx,
                                        nid, pgmap);
                prep_compound_tail(page, i);
+               set_page_count(page + i, 0);

                /*
                 * The first and second tail pages need to
