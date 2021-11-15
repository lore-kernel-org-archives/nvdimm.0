Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD65068
	for <nvdimm@lists.linux.dev>; Mon, 15 Nov 2021 12:11:52 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFBpm85002641;
	Mon, 15 Nov 2021 12:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=UkzydkbKdjIbuBbt8ixbEuALOfH5zwz5ZWYFWqmjD+Y=;
 b=vk+EwF7qe2R70pHPbFvBp3rI/EKkdScqvlKutizS8KWBVO9V0qSk6Q9BjtoY8dAti9uw
 toZKdyHrY8obnfX+LCdyHHhnKCUTxtWTGd1nnhHJ/fAS+zyvgmNLeH7/Y+KK77SNty3Z
 Jzt2xH3aItJweCdSLKxMh/gprmL0kuKH1dk1O8zd7EUfP/MQnBDaTTxbWz36Q8LUMuwx
 HL/+J3eCal8G6T4ajSKKFYojY2kAMLT/bCUZR7JNIwBL12TC/vBkolBEKmCWltCslkOw
 0fR4+b92LLuuHTd3Tgh6CJ/rZQhoYpGpFjlAHR91kRQSiYPtT20hd6vMDKt6Wc53DMk0 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cbh3dsueg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Nov 2021 12:11:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AFCAdIV181158;
	Mon, 15 Nov 2021 12:11:44 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2168.outbound.protection.outlook.com [104.47.73.168])
	by aserp3020.oracle.com with ESMTP id 3ca563r43d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Nov 2021 12:11:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyevC8jB96a3D+mu5s+MEU/k9cj+z4a9ZuMIRgxWGf0j4FXjiLujtFJtILd+icUB4az8bu9pHKwD5ljmvIqUdVWK1BLZ+41g7SfWH0MumBPpAvcWUBDVhGp9wFn9ne3Qs/3i+xWvjkaL0YPayyL+3CnxpcdQSsskMCND6VwhR4ReRnz6Wff4AhHmnnqOuoJX2EBneEdmiHVZHjJJZ6CnzBMqF3PPIiv27DB2AWMOtaN0Xk+krhJX2DTxJMMLYuPEvfOGx85ILZO5a3AhUoiMMFBtMSZUcw8Kn84v/wxQc3vubmCoBVEDmQhlaLvS8bmN/tYzG/7k1W9/DSTu9anwrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UkzydkbKdjIbuBbt8ixbEuALOfH5zwz5ZWYFWqmjD+Y=;
 b=FjZxYus3c2VJnZpE7CKwNgyytr4C7Qf+m4HgcyW5z8aNyOXMZk4HrOxXWFNjdTkDChnMxH0rZTrhW8JoGKrHN+6i5MK6q2LkNkazst1Ro3zkaC1ghMe+3o03OJPxHIM30UvdFvJD6r8PL9y6QjzaSpX2+dQIuyItEotlRO2347bC8iCGAvMb8TaNPbBsnc+WfEbXGrv3XN2PPlHXDNOtRxXMkSBojAlZhc4sPOsqCX/qnQnq6LFzr8u9MKZzVluq9PB3V1vo4mIDXjOs5Uy14OaArM5aThZvjw6bIFO1xeqYS1oPFx70WzNdjwlEgydJxrdItYA7CQ85dRR0PmVO1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkzydkbKdjIbuBbt8ixbEuALOfH5zwz5ZWYFWqmjD+Y=;
 b=M2FTULYjU8eBJw6ffHYoN9vFWwkaiVOJiIlgRLtx79zrvyZCIIcMK1M9V7oa7YMmjcx33b96FarCELm+aNlgqMx7fbMuBToOYyPdvGaMe6XRneCH70IhnV7UVx1U+aN5j6P9xrxa4oIfU3azWU2dQExQw14sefKVwhekCwtvLk4=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5186.namprd10.prod.outlook.com (2603:10b6:208:321::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.18; Mon, 15 Nov
 2021 12:11:39 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 12:11:39 +0000
Message-ID: <01f36268-4010-ecea-fee5-c128dd8bb179@oracle.com>
Date: Mon, 15 Nov 2021 13:11:32 +0100
Subject: Re: [PATCH v5 8/8] device-dax: compound devmap support
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
References: <20211112150824.11028-1-joao.m.martins@oracle.com>
 <20211112150824.11028-9-joao.m.martins@oracle.com>
 <20211112153404.GD876299@ziepe.ca>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211112153404.GD876299@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0068.eurprd07.prod.outlook.com
 (2603:10a6:207:4::26) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.31.208] (138.3.203.16) by AM3PR07CA0068.eurprd07.prod.outlook.com (2603:10a6:207:4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.18 via Frontend Transport; Mon, 15 Nov 2021 12:11:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1983ecd7-bc62-4e22-8f45-08d9a831142a
X-MS-TrafficTypeDiagnostic: BLAPR10MB5186:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB51861436EA031C9BE77D02C3BB989@BLAPR10MB5186.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	JRoUkG2ewEBImsPSrMsIQ+DCg6zWYWrsXdbQlblj4S27vlReddq5E/imxq6wDMgVz6dTzZ7JF4RbZ48iDi4XNqhp6fQYMkWpUUiPq4m/nl3j62bLTbn9oLmmYGR4gkDYK2cygjiJWelKFuTQl4+GkPUqpUuGyDZRVviG6Gc4qJxVAcoz6ZKUblNh/L5ccR9aw64/dovxqDflkRRP+F6P3jd1U5/y/83RBuG4WIIiRPQlW9jeJt4/B6WgxuZFS5OYZLLKB9OAsHXkGLAltosjuho9fcJarrJ1+ylgcT7sTf8qhEXSHrJyC0uxbrPktdX9Qs9uqabrRn5sbgaGEhr0mQ79DovVhK6P/RdfqvPSvkNEQB1gipXrlPW9DlvShMxm+Kr0klBU4KZyHqZdEKXpgdvIUJgsE2EvA37vLTfgH7yP8fryT+C7Tyx9ySW7fkyK0DL2g40PPAL6Hj74+s6tdaYIba26huVs4BzZ40zTaQlpEQCQpFumZclaDcNRwCGMz16WxCmJg8y/hts7GGbybpMaCi2ROCJj4T3LAQa8lmoiKrPyVnI8si5AgxjPcVKsNtdErx/mBxOUSMUbftrrpXkl7sZlnmCuHNHZAlAkqselYkT+AP8H3+KhQUMCVO1i/efE9ugsGZ9ycvZGZI3Ryw578pq1E0fjm84ezKZqpIZKZzEQwoIkAu3wOqTjVOFgrvWoH+OTPBrh9GA0DgAHeA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(38100700002)(8676002)(31696002)(316002)(54906003)(6916009)(26005)(86362001)(16576012)(8936002)(66556008)(66946007)(2616005)(66476007)(83380400001)(508600001)(4326008)(5660300002)(36756003)(53546011)(186003)(956004)(6666004)(31686004)(6486002)(2906002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SzNkNTkwaHJxZER6M0xHWmErZXR6SUpDVFM1dzhiUzdxYVBqaitOcmxHMmFz?=
 =?utf-8?B?K1V1RS9yOE9Da1MzN1RMRE90bDhtSUpJZTlzVjJLVFhQQlhwY0t3aThaY3Ft?=
 =?utf-8?B?dFAwemxZM1BROS8wSU5zQTJwYnJCMlRZTStKZFJVUFR1RFhUeFlJM3BPaFFi?=
 =?utf-8?B?MU53SndDNURKSFBuV3Z5SGc2S2hTSlFVM3RzOUhhR1hzb2R6eklsdW1MeFEx?=
 =?utf-8?B?b01Ib0xkZDg0ZW9NR01WMTk5SEt0dVI1U3lBUmZEL3YwYWNDczNweEc4RkFy?=
 =?utf-8?B?cStNOHNjMjhyNnRiVWJKZjJQaUd3cFJqQTBrUUx3b3F5eVZIYm1xL0Y4eTl5?=
 =?utf-8?B?YTF4bFQyaVQzV2Y5NzkyQmdGZTdTa0dhQ1NTQkxyY0UvcXk0VExacER6R1Iw?=
 =?utf-8?B?U0RLQWYwWVhybm9YQ2pGZjhQZFgreFpsMDhvL3FJVlJRM1h1M3FYR1kzckVL?=
 =?utf-8?B?OE53K1h1b0cwMURkYjVGdGZOeFVDaWdPSmF1UmVrRzhsajVBVmZ0cklGbStm?=
 =?utf-8?B?R3RoZi82cGdUSHd5WldCN0VGSXF2aTV1VnRtZEVDRmNvZTUrR0lpUWxnRDZn?=
 =?utf-8?B?MnNLRkRGVHZ5UG9QcVR2cmlQMi9Eby9zZ1RxSlp6TDZROHF0bXdJdE1GQU5v?=
 =?utf-8?B?WTF5U09tdTA4S0tERGxuQVFUM3VOTms0OHlOeWZNYldQTUM3M3V3bFQ0a1Uy?=
 =?utf-8?B?eVZIdWtNR0dtVFFaakVuSUNBUmtzM2NxOXhYbGpDak9pMEN4TURSRlc2T0E1?=
 =?utf-8?B?TVVmZkVuQ2Z4K1N4M1gyRFoxVXpOd0xvQVdqTzNMaW53RmRCRjl2M3FJZDZp?=
 =?utf-8?B?ZFZkeS9wVTFSc1d6SlZDaDNLdUM1NkovQkxFdzBsdEUyN1ZhVzU5Y3dPMHRa?=
 =?utf-8?B?K2pZNUEwMGkvUW1PUGcyVjgwZWUyN0U3cnNxNFRYVnVBRHY4T0VDWlI0cjFz?=
 =?utf-8?B?TDhPcGFpY0w1cG1paVA5ZDV5OFhhdGxla0c3SFFjNVFFTzNFMkh1Y3c4bzFG?=
 =?utf-8?B?cS9JNjlsSFVXY2g4dCt5RUVIa294MTY4dU5pNmZPWHhXZWpaaWVSRWZhUVQw?=
 =?utf-8?B?aURGNDNKZUkza1habHlJWXBjVnVmamhreU0zVENDdW1lM1pZTHVPanVtb0xQ?=
 =?utf-8?B?RkQzM2NWbzRMS0VSTjE2SWRUUC9hZWp1QkRGSFQ1SkZTaEJUL3Q4MkdRTVhR?=
 =?utf-8?B?Slgya3ZDVmt2angrek11SHc2dFN1UkpreE5VTis0UFQ1NVBFSnRmdGhNL1NY?=
 =?utf-8?B?M1J5cmVLTEZ2NDNIM1B3ZGhPN0JWR0dVQkp5Wk9YVnNhZ3lBQUVkcG1DM2x2?=
 =?utf-8?B?ZkM4NTdKTEZta3dIMHIrR0RBVXZkWDlxcDV4clZ3cmRyNnpyQXgvcEo3Smg0?=
 =?utf-8?B?Z21ManhWZ0tQclYzb0E2amM5VmNPTkZLR2JrVXErUzk4MFB1cWM3NmhaTk1E?=
 =?utf-8?B?eEJEalJ0UUowUHJ5a0ZRQi9qNVI3M1Rsd2lCa0tGQVRmZGN4dnJGaGhXczdT?=
 =?utf-8?B?ZWRIMzhRbjRibWlWeDVTZEVBZmdQK1dXYXJwMU5sUFRQcldDb0xXSmdyTzNV?=
 =?utf-8?B?M1hSTjFjWThBdHNoTXVlNW5Mb3Z3S1phQzVoWmhkM2g1ejh2a0lGRGlFMlVI?=
 =?utf-8?B?OTU5ZmVwcDNaeTUzOHRoT2tjTlppY2dUY1JkTWpUaWphMTZpUWZZVGFXYzRR?=
 =?utf-8?B?Z0ZKcnozR0hWOTdISk10VlhOektQcldLSXRMbHNyQnpLTzNOZlZJS3B5bmRu?=
 =?utf-8?B?SWRteHQzTWszenV2ZkltcXllNEZNaXVqb3hlV0E5WHJUWnpPZWJHaXRTRm5W?=
 =?utf-8?B?NmJ2Q1JTWi82U3BsaDB3Y2RXbncvQkw0OER4QmRZT1ZRa3NuWG5FYmZiakdC?=
 =?utf-8?B?K2RTN2UycVZUQ3ZXdFZ0QTk1RXFDaEk0YVdsOEJOMjlqQ1JYT3V6RFF0aXl2?=
 =?utf-8?B?dnRzMXkyWTIybEYwVGxzMzkyeXQ3UE5QT2JVSGZxcm1RajFxRjJYcUxqdE8r?=
 =?utf-8?B?a2x3K2I0RGgxTlUyWlBQRjZVOFZkMzJ0Wm5FNzBSWXNKMVcxcy9OalJjNVgy?=
 =?utf-8?B?Z0JLK2Fzazc0NGRiSXFYVEpQUFFBZUg0NGNoNldVemg2TWpRMmNUVndPYlo2?=
 =?utf-8?B?WmxXd2J2Vi8zYThFa0Z4WVNJSnc5dVNVNW11OHFvbUxFSVZWejVuV3BIV2JX?=
 =?utf-8?B?NTA2UmdmK1hBSnc1RTcrL2gxdnVrRzZtSWdHb1VMY0wrYmlRTUhhWHpmdFRw?=
 =?utf-8?B?OGdEVEdvT0VuNWs0dmhXaG9ETGx3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1983ecd7-bc62-4e22-8f45-08d9a831142a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 12:11:39.7252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qE2gPwNbslT/u2bncB8kpo6sEvhYCNccPXqkQWtTa7fZGrWvXLDXWXAXNlCcwbM5a8b1ovWYd4LMZwRO4egs8/d5HhDy16BzbfHAHN3CQCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5186
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10168 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150068
X-Proofpoint-GUID: 8T03Zhjavil_UZqvnLtFXYe-WP4_Jb1F
X-Proofpoint-ORIG-GUID: 8T03Zhjavil_UZqvnLtFXYe-WP4_Jb1F

On 11/12/21 16:34, Jason Gunthorpe wrote:
> On Fri, Nov 12, 2021 at 04:08:24PM +0100, Joao Martins wrote:
> 
>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>> index a65c67ab5ee0..0c2ac97d397d 100644
>> +++ b/drivers/dax/device.c
>> @@ -192,6 +192,42 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
>>  }
>>  #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>>  
>> +static void set_page_mapping(struct vm_fault *vmf, pfn_t pfn,
>> +			     unsigned long fault_size,
>> +			     struct address_space *f_mapping)
>> +{
>> +	unsigned long i;
>> +	pgoff_t pgoff;
>> +
>> +	pgoff = linear_page_index(vmf->vma, ALIGN(vmf->address, fault_size));
>> +
>> +	for (i = 0; i < fault_size / PAGE_SIZE; i++) {
>> +		struct page *page;
>> +
>> +		page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
>> +		if (page->mapping)
>> +			continue;
>> +		page->mapping = f_mapping;
>> +		page->index = pgoff + i;
>> +	}
>> +}
>> +
>> +static void set_compound_mapping(struct vm_fault *vmf, pfn_t pfn,
>> +				 unsigned long fault_size,
>> +				 struct address_space *f_mapping)
>> +{
>> +	struct page *head;
>> +
>> +	head = pfn_to_page(pfn_t_to_pfn(pfn));
>> +	head = compound_head(head);
>> +	if (head->mapping)
>> +		return;
>> +
>> +	head->mapping = f_mapping;
>> +	head->index = linear_page_index(vmf->vma,
>> +			ALIGN(vmf->address, fault_size));
>> +}
> 
> Should this stuff be setup before doing vmf_insert_pfn_XX?
> 

Interestingly filesystem-dax does this, but not device-dax.

set_page_mapping/set_compound_mapping() could be moved to before and then torn down
on @rc != VM_FAULT_NOPAGE (failure). I am not sure what's the benefit in this series..
besides the ordering (that you hinted below) ?

> In normal cases the page should be returned in the vmf and populated
> to the page tables by the core code after all this is done. 
> 

So I suppose by call sites examples as 'core code' is either hugetlbfs call to
__filemap_add_folio() (on hugetlbfs fault handler), shmem_add_to_page_cache() or
anon-equivalent.
