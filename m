Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061F572
	for <nvdimm@lists.linux.dev>; Fri, 26 Nov 2021 18:40:18 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AQHAutE016596;
	Fri, 26 Nov 2021 18:39:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=PHX1ZTkSNqk/4DEkUchojA2oF5lK6rm0iWj0fSOo9/0=;
 b=D3+OSY/XHoT0tAE4MtFv4ILO5lATSijTP+zh4UKwX/OmEaTB+YppOC2j9QpsNkz5D8Jc
 jg6S6DAy/tSXG9bH644nL2GamT37L6n8Yi+s3Zv9YvgFyms2K/KLMm3gZjlKxTkmNN/p
 I9ccKEtlwv3Qdmn9ypkFULHFVyFRnkwPQ/6Bf3tFW7RudFCdQ+DeCma277HDPE8xbX/4
 wJQeFjjbIYe/UzDSvxsCO6KmN6VfgTQroKWH5Z3P/Jlw8CldVTIFrKV8fxbcf6eV5msW
 nz5qqpih18ZGQxRoSL4AXEXkilcoOjTeswgm4vEBlt+yQlIAxcKXjKIQsh6cas/IIKe1 LA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ck1vsgnsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Nov 2021 18:39:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AQIZUUh129388;
	Fri, 26 Nov 2021 18:39:55 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
	by aserp3020.oracle.com with ESMTP id 3cerua9j4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Nov 2021 18:39:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDO+yWHxLtIrOxFmr2hukuZjjJuoJ7cjlb2QhCsH6mDo+J4zBaO35/rV8YIQ0MM6vqke3GopJdMvNi8oFsHaB7kPfTur+3761R3g679ZnhQshHHFDGC8W8NmTUB3Fjf9r6n/myXn7xpzaqCUc3fBj3lIXfMLCHAvlorEMr7Ww2FazkGtXrXglfFrk2d5AMkdoyfPRLyev3iwTJzd4JTWQwEtdX+3V3Fk/GsAryajmmNhOwSi4Pehnc6CTLhGF/rdvYX8cr23PmHWWgCIwr8lNyoIXooijwCqFUfkwL1hvrylB/cxp1gksSu6IJTQW0gKoQm1RromLLpGk+DMNrgItg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PHX1ZTkSNqk/4DEkUchojA2oF5lK6rm0iWj0fSOo9/0=;
 b=GGI5pSpuiLqVIc1ySMD4ot8yLkEQafMPABKfJDpCKXZWARjTUItp5XRlsDOgPG3o5rPD0hg4XGtsYG4j/A/1/n7V1gaxz1yIH2//HR6qcOa9YabzePI4swBZBYtNXGbGb6JHCRrKM/fChxRZK0y0pPhK9AQE4oiHht2yQzh6o3EVgqxevAdmMHxxsG9wxg7zL45qd2ln4VEIGqyti7MTr6gXQHKP4O9nrn3eh1F3M6qTK6H/QXQ3f9ysn/jLFpdxhSKkBkL4W9WyHqPqi8I/TvohpxhnSGW+JMMPIkiAJMgyJfOXA37HRPERSqKT1v9r9uFNpgWbQiYDAmD/nr/9/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHX1ZTkSNqk/4DEkUchojA2oF5lK6rm0iWj0fSOo9/0=;
 b=iU0OO1swhmLT881p1aE9zHqLomSjulZqBvjxlomoBSIdIdq6Z4154+c7S2iaPbQtB3FjvftS1dcTKWaCDmlmK2k4WzgCNhjtmyyoqAwNq0sw87+DCWhB7WPCNpsSevOhWzkd5toBCmaYvPzVLzeKyirmM2WLHPD/NWLzRNNaPqo=
Received: from DS7PR10MB4846.namprd10.prod.outlook.com (2603:10b6:5:38c::24)
 by DM6PR10MB3050.namprd10.prod.outlook.com (2603:10b6:5:67::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Fri, 26 Nov
 2021 18:39:52 +0000
Received: from DS7PR10MB4846.namprd10.prod.outlook.com
 ([fe80::6026:4ded:66a9:cbd6]) by DS7PR10MB4846.namprd10.prod.outlook.com
 ([fe80::6026:4ded:66a9:cbd6%9]) with mapi id 15.20.4713.026; Fri, 26 Nov 2021
 18:39:52 +0000
Message-ID: <96b53b3c-5c18-5f93-c595-a7d509d58f92@oracle.com>
Date: Fri, 26 Nov 2021 18:39:39 +0000
Subject: Re: [PATCH v6 09/10] device-dax: set mapping prior to
 vmf_insert_pfn{,_pmd,pud}()
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
References: <20211124191005.20783-1-joao.m.martins@oracle.com>
 <20211124191005.20783-10-joao.m.martins@oracle.com>
 <0439eb48-1688-a4f4-5feb-8eb2680d652f@oracle.com>
In-Reply-To: <0439eb48-1688-a4f4-5feb-8eb2680d652f@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0085.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::18) To DS7PR10MB4846.namprd10.prod.outlook.com
 (2603:10b6:5:38c::24)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.171.211] (138.3.204.19) by LO2P123CA0085.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:138::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19 via Frontend Transport; Fri, 26 Nov 2021 18:39:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14a84b16-eb37-4cea-37cb-08d9b10c2254
X-MS-TrafficTypeDiagnostic: DM6PR10MB3050:
X-Microsoft-Antispam-PRVS: 
	<DM6PR10MB30500CFD45CA9FA15A483C2FBB639@DM6PR10MB3050.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	aBbWbzpIvH1wqyoLgYAcmpwIiyIjZTnOZie3YcHTLsX7pj36YgGx88vEqn4wsUaoVXU4X+oJSR8jmc6Q0budYvtmapoIYRc8MdX1MhNIaRPTlCYrF3DPO0/9pGBiGtx/c5oBFTrEFDYoRuSnbtc9GyEAiQXgeLhGff0J97AeXeebHjMoQSZhsZS783WEoAz/PAZpz5HYzNhLXRKQA4ruvTqiyXzDgmwmFVCTRNrwQv25eKpZIj4lg9cjLEuoxuHF57LSHACMrvntvbPxWSZ5BFgnHi5/Vjb3n7OVLXKcLh3EmCORXieGGtYOTSMrO2TPT0oppuy6rLD3n78b2+zKbGKrsjlIEkzuI0rIMF/AzlWBvRClh40fi3w+rmQnjDfS1yNVSgrYAt7chaIT/4wvnF1Sixecs313BufdKFIAXPwWTvzr988PescBJmbE7FbQ3B3C/mQHABpU0WhE+/I000LiLDe4TgPxUZ1AzGYHKkNSSuNbZtf9W0i1FjZd0b/GxOspTFbYJCwq8OVxAOMh4Cgw7oce/mbPL0tAs4doGsb7lVS5+TVgc8BjX2783JAd7Auf7xbbFo3RMfYJCQLPyPe6RKjpmhGvPtcP4GqdKiy8YIAcJ0GOZ7ZYiY2ChWAqWDhxfHogWmqVu0mKMlxCn8ZaGdINgW6c7DPdb9extpFhR+Pz3ywNFNHyU3/2eAtOhrJknkwNtLaevrkeoXUbqg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4846.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(8936002)(86362001)(54906003)(6486002)(956004)(2616005)(26005)(186003)(31696002)(16576012)(6666004)(36756003)(7416002)(316002)(66946007)(4326008)(5660300002)(2906002)(508600001)(83380400001)(6916009)(66476007)(8676002)(31686004)(38100700002)(66556008)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VnFoMERTOEord1I2QXJ2WXhIZ1o3d0lHOTQ3OFpiZnI3V1htZTNNNXVUOGZG?=
 =?utf-8?B?VlZpQ0c4UXhRQXlNVUJGNnk3b29hb1JLTm0yU0Q0STU5Ni9LaEcrWWVyUElC?=
 =?utf-8?B?eFNoVk55OEpTUDZlR0x6RzBxd0k1NUNQTWYxQSsyZ0xuOHdWbWFxWSthNjQ5?=
 =?utf-8?B?cHpFaTExYm5NeXdwV1FvMXJwTFYxQ3FPaEFXWmRvclBxS3ZMTFNTQ25BY0x1?=
 =?utf-8?B?dktPNmhMMlAxanZobDYrUzROblVqNGs5QXN0dStiL1ZwM2tPcEJGK21teUhT?=
 =?utf-8?B?NFE2eEQzd1NzTDR5Nm9iVW94ZGxmUllhQ0pMU1Jxb1ZCVm4zb3VjWG0yUmxu?=
 =?utf-8?B?L2U4K3VMMnltbFB1eGVBZEwxS21xeklPbFJ1dmtINGFUdFMrVGx0Wkx0aWVP?=
 =?utf-8?B?UDBBVlpYdkNWOFZ3NzlYUGdLVkdVZklJSk5GMk93WVVXcWQ0VkZvcjNkaFhG?=
 =?utf-8?B?OGpOZElOU2IwaEUxQzBsS0JLUS9WT2ZJQ1N4ZnRvSnVsQ3JZVkcrdlhQUktx?=
 =?utf-8?B?cjNTdTNEMFRpSEdpL0poTWZlTWp3OUZwNm8zLzY2ZXd4STdmWFpxbVRVUklm?=
 =?utf-8?B?bld4UUxwaG5vaUhua3NuWTlhSlY0WE93cmtSYkI4U1ZOSms2UGRrMEkwVXhv?=
 =?utf-8?B?VytmcmVhTFl2RElxdXRIOFRkQXAreVRrajltUkNLVkl5b3dUU0J6djE5aWpL?=
 =?utf-8?B?SlczemZOZ2hQUXFJQTFoalNuY1pBRHRMd1dUejZub1NqSVAvUDFYck93VWxx?=
 =?utf-8?B?RzhFdFV2UVJuSlVGSXZVRTM2VjBJR3NyMnFoWlZvNytRRnlhL0xXWkNuN1BB?=
 =?utf-8?B?NjJzR2ZBenpycm11bHg1Q2x1U3RrVnhlSUIvV2oyMlFyRzhQMStwOU5zTnBj?=
 =?utf-8?B?TGtOMUJscjFDbHRUdWd2V1UyaUYzNitmbVk1RjVmbUcxa0EzNko5RmhRZFpW?=
 =?utf-8?B?QVBwWEJHSXNFeUlKVERxNjVzenpmSFZQSDVvS0h4bnV3YUJyZUdlanRtUjJE?=
 =?utf-8?B?T1ZCc3l2OFZ2bVFnZHh1VlBOQ2dvVW0wMEJPaWlGQitNZjE2cWtoM0pHbmEx?=
 =?utf-8?B?bXZTeFhGblRKRDZHZG9MR3MrcDJjZENicmV2SVlmc1FRa0JWYk84YS82S3dt?=
 =?utf-8?B?MGs3QW9jTXFxZXFhaUlNTWZjZ3Q0TEJNUkpwNW1jazRWWUQyS3p3ZHFvV1Qz?=
 =?utf-8?B?WWRoUG90ZlpBZU1qQW12dFBQVUN4NUtmZHpqSFlZNkNDVXo4ZDMvR3lyek9h?=
 =?utf-8?B?Q0ZXN2t2RWFORWdsaVdQN0tIejlqUzhCaFJ3R2Z2d2N2U0lsQnpTOU5UcytZ?=
 =?utf-8?B?NkhPRmpaajE3Y2R1QzhJQU1MMUtsamVqRmVBeTJoeFY3WVRhaXFBaDdKZ01E?=
 =?utf-8?B?SnJnR3NkcHIrTGlvQWN6K0VSWjA5WUpjVks2eWdyYk5kdDU0ZmtsZzEwaGRv?=
 =?utf-8?B?WUhXdEg0N3VuRHh6SVZWZ3k4bHJDS0N1YUJOS1A1TjlBOG4xYW5aY1R1SzhC?=
 =?utf-8?B?RGNpU2xobHVTVnNwbTBQYTZpS2p6NXlzUk5mOWRNMEFyRXJUU2FEQzNmWDFR?=
 =?utf-8?B?dmFRUy8zRndFOEJITk81ZFc5Q0lpallONTlGaHNpK0pBWGR1amEwKzN5cWdz?=
 =?utf-8?B?eVdHWmhwTEJITVNJRmROUXJqdkJzRXQ4UDV3VTNPWXQ2a1RjUXRhMDl1NmFL?=
 =?utf-8?B?WjBzN0pMQnBIcnFXb1ZGcVlwWTZlTkM1cjF1VjhOcGE2UmhVZFN6alZiV3pH?=
 =?utf-8?B?YWNtMTZhZERyTW5iRHdwVTRkeG9UYTlOSzA0a0IvamkyWGRYelcxbGFoOUtT?=
 =?utf-8?B?MURyZXVPbjJpRHNrRTRYQWQ5RktaaW9tNVk3RXFmTHBTZmFMeG8wVjFWSjdz?=
 =?utf-8?B?WGxOTzFSMDVudjhrRXErTjdLbzRmQXRHRnM3c3hBWFZDMmlZMTFNWEtaNW92?=
 =?utf-8?B?SVl3T3U5VSswVzRCeWdHY2o2aWpWTkM0Wm81TlcrekhyNlNUL2hOaCtvTDhG?=
 =?utf-8?B?aml3SC9SeUlDTDhTeHRBdEtHWFI0SUZuSWxlU0I5a0FLS0NLOXdnbFdkZllW?=
 =?utf-8?B?TWV4QjM3ejNSRXZJLzVOTUZLeUd5eVpSUWg5MDdhMVJmSEVSdmUvc0hndUhT?=
 =?utf-8?B?Q0FaTzRKVFpQaS9HNUZEazVGSTdGZTR3L1E4bERyYkNyUFdITVZpaHM3UmlM?=
 =?utf-8?B?L0luR1RnZDRZZjE5c0pjVmNIWUtEZnN5elQveGhJRlNYc25wNzl1Z09kM1F5?=
 =?utf-8?B?L0ZKZE9NVmxpOHVCZ3dpMFB6cG1RPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a84b16-eb37-4cea-37cb-08d9b10c2254
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4846.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 18:39:52.6281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NGn3nyLyxjkOmVClnLXziwC7aK/CWH4IXF9GL9jh5G1cW17n6xf07bNTH17GSpA7/jOU6QDaRcKYzoIEoK7cI2+dUTXz+GdNREB+Mck5Pzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3050
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10180 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111260107
X-Proofpoint-GUID: pQHC9xmw8A2oetfdlxQ4EfT1atcHR64J
X-Proofpoint-ORIG-GUID: pQHC9xmw8A2oetfdlxQ4EfT1atcHR64J

On 11/25/21 11:42, Joao Martins wrote:
> On 11/24/21 19:10, Joao Martins wrote:
>> @@ -245,8 +251,6 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>>  		rc = VM_FAULT_SIGBUS;
>>  	}
>>  
>> -	if (rc == VM_FAULT_NOPAGE)
>> -		dax_set_mapping(vmf, pfn, fault_size);
>>  	dax_read_unlock(id);
>>  
>>  	return rc;
>>
> This last chunk is going to spoof out a new warning because @fault_size in
> dev_dax_huge_fault stops being used after this patch.
> I've added below chunk for the next version (in addition to Christoph comments in
> patch 4):
> 

Re-attached as a replacement patch below scissors line.

As mentioned earlier, I'll be respinning v7 series with the comments I got on patch 4 and
this replacement below. But given the build warning yesterday&today, figured I
preemptively attach a replacement for it.

----->8-----

From 2f4cb25c0a6546a27ced4981f0963546f386caec Mon Sep 17 00:00:00 2001
From: Joao Martins <joao.m.martins@oracle.com>
Date: Tue, 23 Nov 2021 06:00:38 -0500
Subject: [PATCH] device-dax: set mapping prior to vmf_insert_pfn{,_pmd,pud}()

Normally, the @page mapping is set prior to inserting the page into a
page table entry. Make device-dax adhere to the same ordering, rather
than setting mapping after the PTE is inserted.

The address_space never changes and it is always associated with the
same inode and underlying pages. So, the page mapping is set once but
cleared when the struct pages are removed/freed (i.e. after
{devm_}memunmap_pages()).

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 9c87927d4bc2..19a6b86486ce 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -121,6 +121,8 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,

 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);

+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_mixed(vmf->vma, vmf->address, *pfn);
 }

@@ -161,6 +163,8 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,

 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);

+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }

@@ -203,6 +207,8 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,

 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);

+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 #else
@@ -217,7 +223,6 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		enum page_entry_size pe_size)
 {
 	struct file *filp = vmf->vma->vm_file;
-	unsigned long fault_size;
 	vm_fault_t rc = VM_FAULT_SIGBUS;
 	int id;
 	pfn_t pfn;
@@ -230,23 +235,18 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 	id = dax_read_lock();
 	switch (pe_size) {
 	case PE_SIZE_PTE:
-		fault_size = PAGE_SIZE;
 		rc = __dev_dax_pte_fault(dev_dax, vmf, &pfn);
 		break;
 	case PE_SIZE_PMD:
-		fault_size = PMD_SIZE;
 		rc = __dev_dax_pmd_fault(dev_dax, vmf, &pfn);
 		break;
 	case PE_SIZE_PUD:
-		fault_size = PUD_SIZE;
 		rc = __dev_dax_pud_fault(dev_dax, vmf, &pfn);
 		break;
 	default:
 		rc = VM_FAULT_SIGBUS;
 	}

-	if (rc == VM_FAULT_NOPAGE)
-		dax_set_mapping(vmf, pfn, fault_size);
 	dax_read_unlock(id);

 	return rc;
-- 
2.17.2


