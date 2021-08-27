Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064123FC1
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 18:35:18 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RGf0o5015214;
	Fri, 27 Aug 2021 18:35:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=KVdVELDiwbzoBbwoUmKjdocktxSI5A3aChoJ2U6qd/k=;
 b=jvv7Zj+9/h+ITfDEbA7rw0FpqZvzd829c0a9eatnLWjHk6OVc+Lqz4kPv9ccP2J76meA
 ACcjsOM5fpcu6q48v6ymP4iHkQPxPcgVSiEjtI6iwo5WFHXrjs0MGqLe87sdMNe5x3cq
 j34I3fniuRv+KVIWoIj+ZekS+St5oLPyZ60LsJZFcYx5bm7imZnzv8rq7sj8prnQXMhr
 MXukZRMWvDGmReImAFM9YOzQdfBY3sCewkYiF5bqtza18OCQDXGRvjJo9IUPc4IQ2UEM
 gaG1VIRyz6SdT5YRDByFfiMNq/gFbT7fhdka9QGGFIzox3DOR7XDRXOT+vxxSX76S230 zw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KVdVELDiwbzoBbwoUmKjdocktxSI5A3aChoJ2U6qd/k=;
 b=AbZ0DTEF5u0KSRVuEHBcUA8x/uCUBaAKpkKgi58gi0Kn63odX/R9V0FWkwWB0hspvwby
 5ZeaWvhIAeB1U9CEsXAvkcluLLHYA0n3QFEzedr/hGpVJFxKRgQqeqOgeNRgiC956+Gt
 bfEBYCDOhvjyoB5gkz1M3h/XxJjoEIFagS+7IxFODPLZL/8PchN7SLqNknD3MEMxHCEI
 vyO25WwW3fpyjcqT47EWc8vHa5gXoxyB3BqJvN+nCUR9QL90VTAmS2BZw0wjb/4tOCgO
 nE5cW7+PbFSDGe/glTDoU/a0kCyiAqTuczFkAJnFqk9Jmd7zbQLf/2/XPQV8jsphxOcJ jQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap4ekvd4v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 18:35:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RIFVK0060525;
	Fri, 27 Aug 2021 18:35:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by aserp3030.oracle.com with ESMTP id 3aq2hurutk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 18:35:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBETGRBuc4x4L9avlvHn2XcgclU8qQBBgnTPkGmXJcHFkqRNR9w4OHFxc0zF7Taq1Aw5sInZL87CPdsm3gT6W3w7NC2irImWFYL5ah/AaqmP6jORKrbw8PpVvqFjYtEyeaFrAxvBbGdGp5JhiwdEt3oBCkvdRrIccE8Avxq1D8ZIAvXfZLOc1u+NPo5XUt7wfho2eDJjaFv+mWBpdQIyNIThBUmzIO8qxjqSex5y0mtSyWQMLlfN284AmJZvvx2nBFcmOxExUJrRgp8c+wFEpzikQ4BtbGs//uuiVPZ379fI5DF2T+kvxYoZR6WZuipEBXv1bShqgpztisuYDr4dow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVdVELDiwbzoBbwoUmKjdocktxSI5A3aChoJ2U6qd/k=;
 b=b5YG8pxdzsonAcWpvJexVz2dwgYZw32Ub/9PxgXBLlrFueYBwAaYhbZb0qiqDmTPA31f/vF9wbkOKhyvqA1SRR3Vpi7VwdTR5l6BpCQBJcsqWun2H9SRY6PCWoED6+5Pb/YIizJtVPS6LwoqVtogMbbt2NFQCmgMC1MfbH4bJqUhPb6K0CydnyoUBY0awIZlo/EAy44FH1mTvOZX1UQYMxFkwZ51sVX+W5I4ksvacOGezT+PwA9dgL8sBHhjYj2zfhTXXtEoZeJ7SfCHPxq+6t4AiTbn5b86uApOtu4tVeBq8ybPEK0coNhWvue/UPuyJsZaTcW0dTPIiG/GNXDrow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVdVELDiwbzoBbwoUmKjdocktxSI5A3aChoJ2U6qd/k=;
 b=uKguOpG+y3oTBpENixYzyHszylu+/p+7gTECJr97dbI1Yr4LqzM3qlZPTn4cjR1OYP0qxG0pWelVbQ2+OjdPmkMtDwxnSsa4KUMLwjWQVfdr17pDoQEoGF2cSajS2UHPo+cOKD9fra7Jl/eJIakim4DwsflTTePJHnpKWRWoKhY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4079.namprd10.prod.outlook.com (2603:10b6:208:1b9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Fri, 27 Aug
 2021 18:35:02 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c9e9:caf3:fa4a:198%5]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 18:35:02 +0000
Subject: Re: [PATCH v4 08/14] mm/gup: grab head page refcount once for group
 of subpages
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
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-9-joao.m.martins@oracle.com>
 <20210827162552.GK1200268@ziepe.ca>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <da90638d-d97f-bacb-f0fa-01f5fd9f2504@oracle.com>
Date: Fri, 27 Aug 2021 19:34:54 +0100
In-Reply-To: <20210827162552.GK1200268@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0075.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::8) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.175.210.136] (138.3.204.8) by LO2P123CA0075.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:138::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 18:34:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edea96ec-bd13-4195-406d-08d969896175
X-MS-TrafficTypeDiagnostic: MN2PR10MB4079:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4079B134BF03738484C9EC0FBBC89@MN2PR10MB4079.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	7+e+JfxTL2/ewU1z1VUmesAKZHnIbQdhLK9FL5+Pi0plpYI9YOfyA4n6K7ItlsafUKL0fAVPaT71EnEhOkoLT918CEe2xsjbVSAGp6k/hBNynG2A3kU31mNk2B0ZmS6xq7XQybxUDrf+egDvbj08ZZ37UK85dzo8Vx/4WMqkxzw13EkQwWbHO9ea6LuMi5xmoyhO6viigCAOwHRRTzq66CHDiCPr0RHNn1i6pPXOZ56TMmXVaWW2IrCgEivaYdZA17IpQ5/rxRJCAn3k4aVA4Q3zPyc5syGBx0ByozdLfKd6x9CCoM9f9GagcF3KpkFP1WulvkJsppQOvfZ5tWEJkXY7nHS4UPba1lpuNt3JGru8Ixn37yctzWL1Bwsws16TjC1Yue3+Z65kCnJHdq+5pUkAkTcMQLEJEtwjRY2SWJrug6QCD3fVcNJ1V8/RhyTNpPRH3ZmMvH+DgJCtnQhudWDitUd4aC6tsgSA+2eg1esq7pgMIlul4NxPCnqMWPUhuhiruElWF3wgsq7NK8Vapo4XFofWj6wBzEby0DsNnTx488V2UKBF/6gSv/GSFqiAg1xz6eOjW2G7qKUeEhfsOU7k6KUwXpgu+K2SVUzl8S4ea2pWwnc39woRtvVqFD+VQgKWSbLkA5FR5UvPFBthw8jYTU3EOvZFPRBMweup6YCO5vV/zl6MsnVLeQiOzYP+aDS1bev11tSw3i5nJMUUCw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(136003)(346002)(366004)(66476007)(478600001)(5660300002)(2616005)(66946007)(316002)(66556008)(6916009)(2906002)(8936002)(186003)(86362001)(6486002)(26005)(83380400001)(8676002)(4326008)(53546011)(16576012)(38100700002)(7416002)(54906003)(36756003)(31686004)(956004)(6666004)(31696002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WHJkMmJBSkR4ZnlyR3lzajdIeGdpaUg4azN0blJvamF5cmNIOXRnaUEzblNX?=
 =?utf-8?B?d2pjMnUvR1ZqajY3bis2bUU2cHF4UUdZSlB3MTFwZmNEQVdkamFwaTM2bUIy?=
 =?utf-8?B?TXQ3bm5LVzVhZDk1SU1wbHI5dWVrOUlvOWVLbS9TUGlSRDlEZTQ4K00vTytz?=
 =?utf-8?B?SmFGdUdVaG9rWWxrRUkvdFl5bVV4UUVjVkhSWjNRNmFSZ014QklDN2lSenJu?=
 =?utf-8?B?RW04V0RVeTE0aWJTbkp4VEFCb0tOZjlrcHhJb1g1YkdMQVFzTXJTWDhTNXl1?=
 =?utf-8?B?SGt6SkF6b0tBcVdUK21KSS9BM3d1Q2RvcGZYdVZ1RzJmUmhscnEraVF4OVk0?=
 =?utf-8?B?MEgrVzAzUkNJK0RzNEJRZFJGUnlub1g3V2JGSjg3UElRQ2t3YXd5QVYzVEJ2?=
 =?utf-8?B?TjVEQkZJRzIxbnlKK1hpTXFEcVBTeXN4N3pyNExXMXNDNVB1TnZ4bS9SOEg3?=
 =?utf-8?B?NERWUVpHN0hDWWdvYnoxRDlrTGIrYVJ5QzE2Mkl0M1czOG1YTXpQeE5BS1Zt?=
 =?utf-8?B?Mnk1QzMzWGJ5aVZjOENjdDFQdFQrT0ZNQlV5RE9iRk5VUXVtN0w1bG5MTzZm?=
 =?utf-8?B?VnAyZzBHWEYxalBFTHc1RlZYTFNMaUZMMVYyYmoxR2lBQktqbGFmTU83RjRY?=
 =?utf-8?B?WWJrVmVLNitVSCsySWhFUXlMamdNQXdYUkE0Q1R0d01EVlM2Rzg2N05BNmEr?=
 =?utf-8?B?Njl3OHhoUHM4VnN5b0JoMGJoYXB0aWJsRXRhWkIvd0syRFc4aEhNcTBtUWhj?=
 =?utf-8?B?WmJLOThwQVVjSE9kaklIbnFtS2hocEYycW5ZRTAraHFESjJSdE9iaVBLSCth?=
 =?utf-8?B?R0p4NWRDNFJRSUtHSUpZTlRqMWY0RWxneTZ0cVgzZHU3ZFE3THl6dDFIa05F?=
 =?utf-8?B?cVdCQ3Z0K1ZYR3grOStDS1BuUVZjMHdJUnFEdGNheFYyZkRhQk1TRjllbUNB?=
 =?utf-8?B?N1BqWHRPMDd4OGJDUVV0VnNSQmI3d0dpRUZGRmhwbkJlSzZQZDd5WUNybVdH?=
 =?utf-8?B?ZldMRGlkYm5RYURoaHMrbEJPRnV0cnRNRkk4Y0R4L2hlNDBnWDZHcWpRYzNo?=
 =?utf-8?B?STBlNWd2V0xxQ2pHZDFYZGFSczN5ejRNZENPV2RxMngrUkZTbzR0QzZmUXFa?=
 =?utf-8?B?c0ZrVDdrYzROd1kxVHRzMEdvRk9NS0lmVVNVTGlQUFJtSDYvQWxRQk9Zc2pu?=
 =?utf-8?B?bHN3Y3ZkaXBZcnhiTXNudnl0d3VkOVdmeGhab1hmUlZzY0RTRFFhZXBDZi8v?=
 =?utf-8?B?MktFRVFHcytTcGVHdjU0bmpEWjVKalhXcHl4UW5wRWVNYlJ3ZHBFZG1EUkpL?=
 =?utf-8?B?L1VPdVd0YzdtVEduV3RIcjRGUFMvRTRkN3ZLazVQMVQ3RVUzbDdWMWlJNUlZ?=
 =?utf-8?B?dWltckVTWWNhVGNVRi9leHE5ekhENmpobko4cXd5V25mT2dtbkZ0d080OW1D?=
 =?utf-8?B?bDhkZlhaRFlEckxkZ1ZpZ3k2bXY5bjVmNFNoVlpmcnBHVHRHSFhod2VDR2FT?=
 =?utf-8?B?WCs0YnQ4VDYxdVRIamNpYjdFbUpwK29iVXIzYzBIR1MwajVHNXRXMy9NTWtI?=
 =?utf-8?B?QVRxR3pMUGc4NE94YzQ3cDl2WmVaN2VXdWhNbCsrUzVrWlZIRXVudW90Q01F?=
 =?utf-8?B?NXl1QjFWRm9KUnBDY0pVMnJ6WHdVdmw4M1JiVWpSS1ZCZ0s2THZPbkJUZ0k3?=
 =?utf-8?B?QlBnNWlmeDBsTi95cmRRMndJTXkxUlIvREFsaHVnYzdaYUhMY0h6VWxVQzAx?=
 =?utf-8?Q?GNQNCTa29fZhHscEFZyEg8i7DnGIuEq2HXE+Cxz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edea96ec-bd13-4195-406d-08d969896175
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 18:35:01.9590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tpCwHdLAkQhpqy+WceA//qk9rFnYeMGDRT+r2DDE4CWMPPKjLhTZyXbHPH8y5tXg6EDas7grPqlskGQ8eK71rKfCgnu2TVnm3p2xePzIto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4079
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270107
X-Proofpoint-GUID: VSTkeIsZavApIiRTUpP-5U64uHbx3kt6
X-Proofpoint-ORIG-GUID: VSTkeIsZavApIiRTUpP-5U64uHbx3kt6

On 8/27/21 5:25 PM, Jason Gunthorpe wrote:
> On Fri, Aug 27, 2021 at 03:58:13PM +0100, Joao Martins wrote:
> 
>>  #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
>>  static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>>  			     unsigned long end, unsigned int flags,
>>  			     struct page **pages, int *nr)
>>  {
>> -	int nr_start = *nr;
>> +	int refs, nr_start = *nr;
>>  	struct dev_pagemap *pgmap = NULL;
>>  	int ret = 1;
>>  
>>  	do {
>> -		struct page *page = pfn_to_page(pfn);
>> +		struct page *head, *page = pfn_to_page(pfn);
>> +		unsigned long next = addr + PAGE_SIZE;
>>  
>>  		pgmap = get_dev_pagemap(pfn, pgmap);
>>  		if (unlikely(!pgmap)) {
>> @@ -2252,16 +2265,25 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>>  			ret = 0;
>>  			break;
>>  		}
>> -		SetPageReferenced(page);
>> -		pages[*nr] = page;
>> -		if (unlikely(!try_grab_page(page, flags))) {
>> -			undo_dev_pagemap(nr, nr_start, flags, pages);
>> +
>> +		head = compound_head(page);
>> +		/* @end is assumed to be limited at most one compound page */
>> +		if (PageHead(head))
>> +			next = end;
>> +		refs = record_subpages(page, addr, next, pages + *nr);
>> +
>> +		SetPageReferenced(head);
>> +		if (unlikely(!try_grab_compound_head(head, refs, flags))) {
>> +			if (PageHead(head))
>> +				ClearPageReferenced(head);
>> +			else
>> +				undo_dev_pagemap(nr, nr_start, flags, pages);
>>  			ret = 0;
>>  			break;
> 
> Why is this special cased for devmap?
> 
> Shouldn't everything processing pud/pmds/etc use the same basic loop
> that is similar in idea to the 'for_each_compound_head' scheme in
> unpin_user_pages_dirty_lock()?
> 
> Doesn't that work for all the special page type cases here?

We are iterating over PFNs to create an array of base pages (regardless of page table
type), rather than iterating over an array of pages to work on. Given that all these gup
functions already give you the boundary (end of pmd or end of pud, etc) then we just need
to grab the ref to pgmap and head page and save the tails. But sadly we need to handle the
base page case which is why there's this outer loop exists sadly. If it was just head
pages we wouldn't need the outer loop (and hence no for_each_compound_head, like the
hugetlb variant).

But maybe I am being dense and you just mean to replace the outer loop with
for_each_compound_range(). I am a little stuck on the part that I anyways need to record
back the tail pages when iterating over the (single) head page. So I feel that it wouldn't
bring that much improvement, unless I missed your point.

	Joao
