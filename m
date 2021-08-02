Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6DA72
	for <nvdimm@lists.linux.dev>; Mon,  2 Aug 2021 10:41:10 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 172AV8vF018919;
	Mon, 2 Aug 2021 10:40:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=XBcPyP/1lJuILu1iwJVbi+5BKQEMJj6moToKN6dmQcQ=;
 b=ykcU90DAZIrhMQfU/o0sFhrVhN9uO7uInnKsF1pM9ooJaH8PfW53oLkNC1DyunQSq0YR
 B7ShPyNo6WU6eFBzj1dtvzZb4ak6SjInp97wG3tu01CNessRMGLuTQGQQcdTEaAH+jq0
 NqBiDMpJlpHeGznKJmLB/+TupIM+xh1yx5UcTeqTepAAFTzjQs6FIur/js8GThBO8Bif
 Ke+EAfldh+bHT5NKo0rMxHqstwgkUDiTaRE2FjqOhdLbg0MwSpAQLGQaxyfQThmhXO4S
 5DyHfud6QwFG8GKMXYAc7K9H+GciZRizXl/10yn1ZNdPB6Hzl3JCJHUnF9fUxi3pgZGp Vg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=XBcPyP/1lJuILu1iwJVbi+5BKQEMJj6moToKN6dmQcQ=;
 b=n9YIW9CX+Vwz1vkuUisyN71sy5HWyNct4knh60w1VpgcpxnYuo8XKH79WNJf78689y9V
 ruf41fMXVDA/3WP+vCEcXq1Galzm4Z9fMV4jqp/em6bQLibhSrNUKl2w2nPXri66AmUs
 b+Y8LJw94ixQmIR7nZKT0Hq3a9ebPv7bvpIIez7xGpl9w+7AQK4KDP1x6sSaKZUD0zvT
 LsQmZNt7mGQVaLjFCNyJm+AhpphD+vhqwbxsh8jRp9TsV270tzx9Wdj/YkiHm4v7QV2d
 e58ed+1ra94L52I+Ue6rCuhyZgtcZBiWEYvHPVzJcMqwO9jYTAfM9edKj2MCRTAJ4Ay9 6g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a65vd8wsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Aug 2021 10:40:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 172Aa2MB029331;
	Mon, 2 Aug 2021 10:40:40 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by aserp3030.oracle.com with ESMTP id 3a4vjbsmd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Aug 2021 10:40:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CM44FQQwvsztVcyg3Z2nZsLa8vO6upCSvbTNBvtuOnGd0wxTdZBGZs3SNIVqZLciiFYyKz4cOhW9UBjQL3r4G8a4RMhs4PsedWpFaZbwSeCCqM6H4wK/YwKOMaJVzam66uLNrQoNw199xH01daaVMoTO5qEPLMJe4UD7XQ+AHyl9E7IBdPF8yRTsCjSuxWKtIsooRLLGID+gM3WFMdUNC+reRczOQhqEZizDQ8UQhnZ6VHcKmlqk0Xkdmbg3TlGizYhZ3ki5tB/qu9oENa7o62Sf0G56pD5rZdIrh0rKk1R+oFtHP6AJQ0FwLDL/PmliJ5GfzV6ViCx7evCw/Blqpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XBcPyP/1lJuILu1iwJVbi+5BKQEMJj6moToKN6dmQcQ=;
 b=oQGlInAT/JYLe2K6h90v7luEYjmjvJkhKsspbcUUr6M82JsLZoD9xOY9Bo6u6llPZMfuvGbT1V25mJhPuNf0q5swcKYLKzU0hld3Uotze5H4BMfgXCqdADfJAPnzwe4NchujsMDzzz+G9CyY1c2k/K7B1QzsZJNflVmTSV01/EUZMAsbhcjGQodXDyCXh5YftcRnIZRu4VbZF8FW1jnDZGn9+bLWrrouGBNP8ceHYG5SLgKT/WMCnmJvi53Or2QzatdYGeBDyZJjZQ0z6xUkBzDIRfXiBGT4DaOuw4tWSIbw4IxJIKow36wzDj4Cjihiwvag8+oh4hWlPYDORHhD0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XBcPyP/1lJuILu1iwJVbi+5BKQEMJj6moToKN6dmQcQ=;
 b=RLpsbR+5v+dDupQT4kf7hJ8bMiz0QAMAW5ZVe6vZ1A7VFQre07yQJFaeWbDFVcF69O+tr5kjPjY+rW8R0cL/Q5gu1NHfbHTaEUcul8FtfZTooiI0+yrIUcy7pdeGkf8jd0Y7ia5jcqJYTHvtQoCd/g1xJPtJYIo2X3rM0GqNY+Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5106.namprd10.prod.outlook.com (2603:10b6:208:30c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Mon, 2 Aug
 2021 10:40:35 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 10:40:35 +0000
Subject: Re: [PATCH v3 00/14] mm, sparse-vmemmap: Introduce compound pagemaps
To: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714144830.29f9584878b04903079ef7eb@linux-foundation.org>
 <YPjW7tu1NU0iRaH9@casper.infradead.org>
 <5642c8c3-cf13-33dc-c617-9d1becfba1b1@oracle.com>
 <CAPcyv4ho7idBPU8F4qE8XWhRttkdfzQRATaTAw2C3AfY+Z2BdQ@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <fbb77d0f-f1e9-3ef9-fd12-b412b845b7fc@oracle.com>
Date: Mon, 2 Aug 2021 11:40:28 +0100
In-Reply-To: <CAPcyv4ho7idBPU8F4qE8XWhRttkdfzQRATaTAw2C3AfY+Z2BdQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0273.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO2P265CA0273.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Mon, 2 Aug 2021 10:40:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9eea93e8-e5e4-4629-c9d0-08d955a1f589
X-MS-TrafficTypeDiagnostic: BLAPR10MB5106:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5106851F101FBA8251ED308BBBEF9@BLAPR10MB5106.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	iEqLkcPiaa7Ga34tFRH3EnGpNOyYRFOtUHebyHmGnZ6BZHdbyt8xOsdk2LmHxVynCLrb1fO4DZBIn0Jh++A0TC0PCh57BoZPEBgiAptFZG/5yvJCgNisosI3ZwrKenFgHVx3dtjQ9dY8qWOKhZosWQ9D1YcOYQ5TiJYcGJAlxuJ9RGVHs8UEf0ztYOsNmbrE0QHKJEqgGkoyUFxOkUetG9l1T/evpxOdLIHO47LpN1x39fxLPad5QRjc5UrgmEwKzwlJ0IK3wt7WWtrqm6hErntAhWCVHVnZlz6M1KQH+GF5FcTw6nUtN3ttA3m2Y7RBgisuxnucNxVul8g9sdABE1XzqtPhSr0qURtA9GAwjjB7nZYv2yLvLvVYLP0uExcT09G4ZXo7IC/T3PGV+awpb4SVCKGGsY7n9flfS4zLEjA3oU7Vbt/H5pTDA1qR/0zL8S9HGEoG0p/uYNJ2iXBzjfmrILNxjzTsQa81//74JBZ43ElpMGigr8iJxMaMVx16gUaJ1N09sbfqrazWHdbPJJm9ZsnkSFWwASz6nQHsJQnPwqgOGqszqJwRE7nlw/vjOoTTSFK3OKOKYww8xF6RUWMufld5iDOPa52636zU1YvA1m9OKh41c5P7BLMPQb1gyJvr2Tk3tYs6l8MXSEggTQ5dAieRtHacOGO/SPeNKTfrc1WcH+/geteo/ugfMCAAFVORW1Ug96t6rK8DGTxUrw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(366004)(376002)(396003)(6486002)(83380400001)(478600001)(2906002)(54906003)(66556008)(5660300002)(66476007)(31686004)(66946007)(8936002)(6916009)(8676002)(4326008)(956004)(53546011)(7416002)(36756003)(316002)(2616005)(26005)(31696002)(16576012)(86362001)(6666004)(186003)(38100700002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SzN0REJDTmpBemdpOTNza3kyczlqTmtUc2p6VlZaRzBRV2ppZHhmeGo2d0d6?=
 =?utf-8?B?MlBGbDh6aWV6L2hhOGJnY2paUFM5ajVob2prRDl1bUlKb0lhQkQ2cGRPbmMy?=
 =?utf-8?B?QUNtRG81cjdzSWFRM24vV2IrWTdQdXFhV1haU3dJWmVVS3oyaWJ2SnJTRTVS?=
 =?utf-8?B?d0pGbXB3NkZpRDU0cGJ1RkxKZGRneHIyeFN2akYva0U4KytuSXhNdnhSQzFp?=
 =?utf-8?B?c0d2aFhwSEZOM0FLeHdDUnVrRngySHd0ZEg5Q3VoRHV5dmRycHpwcDZiTm5B?=
 =?utf-8?B?cU9XbmwvSWVPR3V6QW5KL3Jidk9RMWxaUW1FSHl0MDdyaXJCenNvWnR0bEk2?=
 =?utf-8?B?aStUYlVRSklZQ1VOb0ZPU0dSdUNtNnpDSFNrMHRGbll0MjdNbjFtbDBTTGJn?=
 =?utf-8?B?SDdPRmtsQlRzaXFzcTB5ZzZGYUxRbU4wREU1dnJEajhkTnk3UHlRckhPd2d2?=
 =?utf-8?B?V0RCQlE5M0xQeE1IREU5WGxmWVphaFpQVE9ZZGRHb3hCaVBxZUV6VExmVUhj?=
 =?utf-8?B?bFB4dVFwK3pFZFB4My8rMFJRRFdVSGQ2dWMydTAzak5kWFd2VCt2T0U5dXY5?=
 =?utf-8?B?ZUJwM1B5U0FObW9FUnBhT2JNSDk0QUlCTENnMmIyd1FMOVFFVStwWHlhTnZ1?=
 =?utf-8?B?RjFCYjB4MWpkN3dQeDlRRmJ6OS9Ec0xyRUJDT3luT3d1ZWpuZHpzaFBoRWR5?=
 =?utf-8?B?UWxwTytkSW5FQVNCQWNxSWROWW9yRUNBYVEyaXNsOVlDOVk0T1J4SjJpUVZM?=
 =?utf-8?B?UWJxUUlTUVU0RDBTSVdkcnlaMXVWUUt6T3BzUTVJMTNWaTlSSFRIaGJpU1dV?=
 =?utf-8?B?MmtLcTVESjdmUUF4ZHZ4OVoybk1rdlJTMlF5dnpBTHlTM25CVE5SRXZhWEdz?=
 =?utf-8?B?ZVJNRTVBcklVc1h3ZVcwTUtneFUyVERkc2wrdC9iYmJDUG9sWlBuNG9RWGYw?=
 =?utf-8?B?d1JCR0twN3V1ZUowdVUralBzR0RjeU5MS1ZlZmN4U3NZNTVBeFpKN3FDRjdk?=
 =?utf-8?B?c1V4TWpYQnFEc3Bwd0FkMlJCZFFXSnhsMk9ka3pCNmw0dGV2OUNrYjdHalNG?=
 =?utf-8?B?MFFBTGxyUHVHaldaclRXaVhqUmQ1SjJpZThmTFV3RlVpdVhjVllzU3VJOGV4?=
 =?utf-8?B?NzNOZXlEVis3Ym5wYWx5NFM1NjJYN1BxcUpESTBEY093OUlNa1VNL212Smpx?=
 =?utf-8?B?QnpuNVVuRVlHdkM5dWxjODBjblp5d0tPN041TDkyd0xoVkZncHdQRFZocGFN?=
 =?utf-8?B?bEhvVHBwWWJWOCtoU2ZKZXRuUnZ4eXhEdEdtcUYyeG4zVlFzNHNmRXJtQndX?=
 =?utf-8?B?Y2RYRDhDQU0zbGQ4OGxVUkh6d0hPSE4xdGI5S1dhU3AwSGNnL1BxOFhUNisx?=
 =?utf-8?B?VmNmU2tjVVlDMEY1bWRrNGUrdGh0eE1PQnRTUlhpeERvbC9aUEFCenpqaFln?=
 =?utf-8?B?Q1RnSHgvdVZMb3V0Vk1sMEYrc0t1dm5PNXFPMzhLa2pJSXluMGhWOHBOKytW?=
 =?utf-8?B?dHM3WjJ2VnI3VzJwMVVrV3l3R3UrWnFSRFpmNHh5d3hUNW9jRlBNZ0pidWlS?=
 =?utf-8?B?NU4xTk8wVVVXSjZVVGQvdC8zbFg3eTdjOHZZSjZPQWMzam0vZWMxcEhmMmlZ?=
 =?utf-8?B?K2tDcitSOW1mVjVmVENzKzRMeUtQUWxmT1ZuNjFKbXg4Q25KQmN4ODczRUNw?=
 =?utf-8?B?SzNhZG5IVk9sUnIxK3F4a3RFMmd0Tit0aUZvWVVydlpxZjNmNW1BaDNHMFM0?=
 =?utf-8?Q?IyfkGKYKKNWbWUyUiRrE3uuX9EppR1Ky02XyzOL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eea93e8-e5e4-4629-c9d0-08d955a1f589
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 10:40:34.9429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 76cWeZbs8D2IImEn11mfJugW58BprLUg8CGQS/dFm6aFug9hYpnBM9FVFKuxEfur8hm4Jjx/ZZeeQD3ZNtgy1To0ll/bqGNkPTQuYaCY2Zo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5106
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10063 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108020071
X-Proofpoint-GUID: G9yUa1kF7PDEmUK48D3HY-zutll1UrlE
X-Proofpoint-ORIG-GUID: G9yUa1kF7PDEmUK48D3HY-zutll1UrlE



On 7/28/21 12:23 AM, Dan Williams wrote:
> On Thu, Jul 22, 2021 at 3:54 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> [..]
>>> The folio work really touches the page
>>> cache for now, and this seems mostly to touch the devmap paths.
>>>
>> /me nods -- it really is about devmap infra for usage in device-dax for persistent memory.
>>
>> Perhaps I should do s/pagemaps/devmap/ throughout the series to avoid confusion.
> 
> I also like "devmap" as a more accurate name. It matches the PFN_DEV
> and PFN_MAP flags that decorate DAX capable pfn_t instances. It also
> happens to match a recommendation I gave to Ira for his support for
> supervisor protection keys with devmap pfns.
> 
/me nods

Additionally, I think I'll be reordering the patches for more clear/easier
bisection i.e. first introducing compound pages for devmap, fixing associated
issues wrt to the slow pinning and then introduce vmemmap deduplication for
devmap.

It should look like below after the reordering from first patch to last.
Let me know if you disagree.

memory-failure: fetch compound_head after pgmap_pfn_valid()
mm/page_alloc: split prep_compound_page into head and tail subparts
mm/page_alloc: refactor memmap_init_zone_device() page init
mm/memremap: add ZONE_DEVICE support for compound pages
device-dax: use ALIGN() for determining pgoff
device-dax: compound devmap support
mm/gup: grab head page refcount once for group of subpages
mm/sparse-vmemmap: add a pgmap argument to section activation
mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to helper
mm/hugetlb_vmemmap: move comment block to Documentation/vm
mm/sparse-vmemmap: populate compound devmaps
mm/page_alloc: reuse tail struct pages for compound devmaps
mm/sparse-vmemmap: improve memory savings for compound pud geometry
