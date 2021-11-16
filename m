Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9719B68
	for <nvdimm@lists.linux.dev>; Tue, 16 Nov 2021 16:39:24 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AGFZXSX010322;
	Tue, 16 Nov 2021 16:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=cvlExy+MqnreM4qsU3DffIhlvVNeRAyi2DbCXfXxIOg=;
 b=N3NBaRY5HjyL+8NcaWupyl+QOpCe6j/i/9NXk1u8Rje83X4s3FM+MjJkemdt2IMfsxly
 SJ9uHyVMgwzdAa59owKfvxBoJ1I6juxGkz0cHHgNpZYvizDS/DyUQlW4qfAjiiyUiBTw
 zli02Mr1xcOv4OFISDinliRbJeD598O6sSNK5l8psocN6mr6APWla7IWWpJAA8GFK8Dq
 bjvQAFX+uvk+Ae++GZdTZeqiCDhPveE4KpSlktvwef/61MAmkkknyo+6cfsN58KG9jTP
 qyAiDKZaR6SDTtW+Bpyd3kZcmg/8VjvupffAcJ7jMuEzO/UuXBh79cKRPvlg3958QqUt kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cbfjxtveg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Nov 2021 16:38:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AGGauUT041432;
	Tue, 16 Nov 2021 16:38:49 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by aserp3020.oracle.com with ESMTP id 3ca565q2ek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Nov 2021 16:38:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7IV7NftOk7lWS+NE22kDCJYF60qdZqhcp+D4lqDbPzGFLGsjUhWha2/GxmAOTW9jIKSuFEu7+7wTiz2KnLT9kUSiVVh42qlxEbcWsBZxvcB2RDVcX/AGGtrBQwYHtoOQ/5tXd0sdEO89rPd396Mqo1Jh8bPInSkatPclJCSMaDp0Cu5avY8C88JV0vf06gMDZ3T0Lop/K0o5dw+pNGc6VsmGxitbCbsJ4s8J0FqaInjkUZ3sl6PEQAEojQCD7m3hiShfns0VsQ918pmHCwvCRlvqLevjf2uAJfya/KaCOf6U+jenff4FFql1XzCs569FoR44EI5uNGg7BFyJZnqmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvlExy+MqnreM4qsU3DffIhlvVNeRAyi2DbCXfXxIOg=;
 b=NetaFfqNvUhGTJO6uQCa0mUMH7W58fLZt2Aj2bt8ypSq/zVHE9BsvgfqWux/GTEE3LKZZHXx7VuTtV0zFG+tpnpU/cFRhiZ726DQ4rAfyrId9Bn/aaKyTdH8wG4rNx44kVol3FOn3OaPshjkxryMnBY2qR/NXibhMfsfTgrvcGKn7E+yjjOZpbeIEf73WbXVukDWW3zDw+gvveZ6I+UJBBR5KO1apCVIkDIZPD4toSrDxdw3pqyKFTziJt+dYjR7E8IV+kJ2gUZwUMz4fvmxjN1JipclQ2577IlHDTNgxeMg8F4EY0r50OesXinu/Bcm/KJT9Lvw91J5Ze4DY8EKog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvlExy+MqnreM4qsU3DffIhlvVNeRAyi2DbCXfXxIOg=;
 b=m7vCS/VXcZV3ZR6wdvep73ZxDEPdhAuFBPJD4rW9O+JNrdl9Pr8uiDNbM8p6p97cUk/CBWr8kvYG0tTUCa9pqVy4iLOu+DAfeLH8P2UDp12BcakJ+M/hgmL3HoKwbQwd79CGl9omzUTdEGEYX80hZxawNsjtPPhyLVWI5i6cWNg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4015.namprd10.prod.outlook.com (2603:10b6:208:1ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 16:38:47 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 16:38:47 +0000
Message-ID: <4d74bfb8-2cff-237b-321b-05aff34c1e5d@oracle.com>
Date: Tue, 16 Nov 2021 17:38:39 +0100
Subject: Re: [PATCH v5 8/8] device-dax: compound devmap support
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi
 <naoya.horiguchi@nec.com>,
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
 <01f36268-4010-ecea-fee5-c128dd8bb179@oracle.com>
 <20211115164909.GF876299@ziepe.ca>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211115164909.GF876299@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0171.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::15) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.62.141] (138.3.203.13) by LO2P265CA0171.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 16 Nov 2021 16:38:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e790887-b425-4e6c-c512-08d9a91f8f87
X-MS-TrafficTypeDiagnostic: MN2PR10MB4015:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB40159F0D35E4CD8A14CC1FADBB999@MN2PR10MB4015.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	2+mJBUxq/ayEEswmFC47q4tCTbP0pEsopmIURXimIZtg+uOACV6mb2kJoupsgsmjOoQ/jhBiUKVjDAFmJlnMp3FKImEILHk3zCcZ7374uu5lE+WFUx6R7uuReAM1HnJ+T4ZVy/iZCmy9G7LCZnQjNcsSlzlJ5AOlsF7mzpUs/jJAM2S2wPQ7FNqPU86ohRaHLwKLEAxekUIAP11MrzJpMsnFMsc9m//jRdalcNZLI20E81QBP23qXUJiSz9xR33EMDW/aLyuiUaJFEqjHmFaoBJK67YuwdRJWvmpaFRWZsF3RFaW6n0LRNSRjDpEVpmRoCVoa2HwjY7FZKqBuAvfcJkfjoBX14juVQS8OcJn4lbWLVt+DVzaZPzTEDK2ImbpCoBywUYn9ybqKOgLW32QMmg0EN9e4jLgSA5z6KkeKGVYwbamCUxMTagSaDaBoiNrv3QYe/dSSMxxHGDfVH2hSI27Eb8XkwGTdf9mpnRNk9tR13QSIAYo7B6gOCh9uF0wcX6IiL0+aJvIQAYubHmOzF5V+pelTEpBwt3OfLmQVP0fc97MkWyB/rj4imS6Ube5XYyeKjiwF8s+gj1GBu9i5+1jjxgd/k85bT5tDXsIM/h5WBqmLD52bipfGDq7qDk1K/ISET07KlHsjsnDTaZSyu0j67eNdAaRxobWuWOS7z35DBfvun45fcJlxz7rGMuW3lgldYawd/4WDCQDpgI11g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(36756003)(6666004)(508600001)(2616005)(66946007)(31686004)(66556008)(956004)(53546011)(66476007)(110136005)(31696002)(16576012)(54906003)(2906002)(316002)(5660300002)(38100700002)(83380400001)(7416002)(186003)(4326008)(8676002)(86362001)(8936002)(26005)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UFVnQThoMFM5SlprZjU1K2JUMEVKcDRZZzZxM3hucS80MmtkTmFublhXY0dR?=
 =?utf-8?B?Y2pwYXVQR0JoN1BoLzhGN1U0aEtCTFFhUm80aXRweXcwUUJmZHIrM2IvWUJQ?=
 =?utf-8?B?Vm5ZaWtiSUlUZC9vTW5pcDZzNFVhbEEvOTNaejU1RlVVVUVoeXVLaEpaanQx?=
 =?utf-8?B?a3o0K2JtbjZKZTlyUWJGUll5aEZoNzNDcDVLQ0pnWlB0NlFXb0hTMkJ5aUFl?=
 =?utf-8?B?Z0huNEJycHhSUWhiYThMbEh1c3J6ZGZLN0pOZ3RqdFRnUWMrV0tWaVNnTzhL?=
 =?utf-8?B?aUtuUDMwTE1xY1Fka051QVNjS2dNcGh4akwvNEtNS3p6anMwc3hKdzBKSWRp?=
 =?utf-8?B?YkNQZE9tVmloU2lCank5d0pQWm42dzVUZ1dQaWlIa28xYnlTZGFkK2hCVDQ5?=
 =?utf-8?B?QXNpZzZTSTNQdnJpT0JoRWhIMW9WR0hpUjR5VHpIampWZzE0c05uaG1mMFBK?=
 =?utf-8?B?TE5Pb1V2TFJxNU04T2hkaVRndnJVTDRyR3haU1dKclEvN3RobTkyOGltdFh5?=
 =?utf-8?B?NXFIczRyMk00VGtDTzhadDgzVjVHV2IwWUFENEtiUkl2eDR2bGhybGkxWmhK?=
 =?utf-8?B?Zmt3YjF3TnZtT0dNWHRtU2VQRnRBK2pqK014dVlCL1ZGRnhwaEZTWUFRbmc0?=
 =?utf-8?B?QkZZZjVJWVZkZjI0RFJhRTNRRnhBVkpBYlAyWDZZdWxpdmZvWHJNWW9ydGIz?=
 =?utf-8?B?ZlBrSC9aNTdWOVcxZUV5bngzRmhuRXFlTEFudTVrMGJHMDdPTEdiMDhPcXZV?=
 =?utf-8?B?cUZ6aXhraEdubDdoME9XdzZ4NWp5K0E1WExPeUxTVVR0UlVkcE90NE9KVEFR?=
 =?utf-8?B?bTc5WDdzNkxaaW4wbDJYVDRDejcyUlNuQXJDSVIrWFJEWWhuLzlrajFub1Y0?=
 =?utf-8?B?SlVPVUdJTUorK0JHNXVFYjN1eGpWUzczVzhRRHJKY3MzRDlhSGNTOXlOVkVG?=
 =?utf-8?B?ZHE5UXZaam1Lejc1U1VWbEtucHZqTGlpOEE4TU5pQ0RXMUJzNm9ZMk13WUFB?=
 =?utf-8?B?OWZqWksyQlhvK3VpMGtvdVhpeXN2Y2wwUThRZ2YrTUVlTDM0dktvcG1INEEx?=
 =?utf-8?B?OHd5VFRkbm02QXJBSzNnVXRPUjhYM21RRzVWTnBSbEVxcHZuNHVNVXcyYUVD?=
 =?utf-8?B?bVFGWXhYZ3VoZFU5Vk5tR0l0S2k3OHdCVVo0TXo1WnB6UTJZSWxQbXNaNzBH?=
 =?utf-8?B?WE9IemhCVmhqTzkvaDdrOStBN2Q1R3E1dXhyakVLMk9KRG5tbEVGTzA0WDRD?=
 =?utf-8?B?d1hKc2hwOU1la2FjVmlrRGpReTgwTFF3UGFyWGluckIzRGtRcmVkdUZ0L2Fq?=
 =?utf-8?B?bHI0Z3BtSjUvN1JoQWtGMWorYS9JVnZOYjZVWUxOaHVXZTN1OXV3WHRTQ1Zi?=
 =?utf-8?B?QnlGQmc3OXIzYllaUjNYVy83eXFKR3JNUjZWUWh6V1djdi9QM29EWkYwdlFv?=
 =?utf-8?B?bldnL1pkQjVjbEtMcmt0NkQ5akNVNm92aW43TkFrRW55aWNtSnFtT3dMdE1U?=
 =?utf-8?B?K2RNdTFsR21BcmZTbDJ6WS8yRWNzUWt2UzhnNWxnWk5UTTdjdE5tSjlMcXhq?=
 =?utf-8?B?SmM4dHhPWXhndHFIa2VMMDRycTZ5V3JaNmZzaDN4TldFVnp5WFFlWVh6b2VX?=
 =?utf-8?B?dytMc2tjRSt3UnZyeExYZEdMRDc3c1poZzl0ZnkyTTc1U0lvcEVkNkZHMTdx?=
 =?utf-8?B?ZUdua2s3ZkEvVFZqUzdRZXJ6dDdFNFpraHExVHQzVGZBeDYxN1lTVVBGdjUz?=
 =?utf-8?B?NW92SnROVTFzeHdCdFJRWkNpWHJ2bys2QnBBZFBlNUx4amJTSzVQRXF6bStE?=
 =?utf-8?B?OGlyTkxxc28wNlpCdThNNW1va2dqcVM3N29KaHQxNURDemM5bVErL0dhcEts?=
 =?utf-8?B?WHhaLzdWUGtBVTJsRUsxTGhUUnAvWlJjQ1JsalBvOEQwVWdXMU9IRjdJUFA1?=
 =?utf-8?B?TmMvQyt0ZG92MUFJTEVIOUZzNGk2YjhOeFhPU0pIblhxdkQzR1RwcEFlalhK?=
 =?utf-8?B?cGRpQnM0ZnpsLzlwOTcwZjRCZUU4ejl0TXhaVnMrYUxMWEdtNDAwQ3VxWDBY?=
 =?utf-8?B?WjEveFlCTTZIeVp4eTFzNHBHazFHSUU3THJWRG5jREJpWC81WlY3MXhqYmZP?=
 =?utf-8?B?ZE1QS0NZeWtZMFEwY1BtSHJCWCt0TVVtM29qRTNwQVNiSUQ1RTJwQXRNcFpE?=
 =?utf-8?B?YmNncVVCNDFxaHBKeEFpQWw0ZVNEN2ZLQktaSmFkZ1VrdlYvaWF0REZWSHVT?=
 =?utf-8?B?MlB0M1NQUFFWMXIwRjNDY0k1dzZ3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e790887-b425-4e6c-c512-08d9a91f8f87
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 16:38:46.9633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFQ1YiQ4FNmuLo+8HhfnSUaW6XjrenNdF0+jfH+Cn7JJBAlNdeN//Q9m8L1GlJ7UnMt68zQl82yRaz2MoJxPPyFnZcRjg6bwTz9P1uOquLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4015
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10169 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111160081
X-Proofpoint-ORIG-GUID: NHP2tNiAKJaOO-SycYlrAY3bIXTFRZSA
X-Proofpoint-GUID: NHP2tNiAKJaOO-SycYlrAY3bIXTFRZSA

On 11/15/21 17:49, Jason Gunthorpe wrote:
> On Mon, Nov 15, 2021 at 01:11:32PM +0100, Joao Martins wrote:
>> On 11/12/21 16:34, Jason Gunthorpe wrote:
>>> On Fri, Nov 12, 2021 at 04:08:24PM +0100, Joao Martins wrote:
>>>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>>>> index a65c67ab5ee0..0c2ac97d397d 100644
>>>> +++ b/drivers/dax/device.c
>>>> @@ -192,6 +192,42 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
>>>>  }
>>>>  #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>>>>  
>>>> +static void set_page_mapping(struct vm_fault *vmf, pfn_t pfn,
>>>> +			     unsigned long fault_size,
>>>> +			     struct address_space *f_mapping)
>>>> +{
>>>> +	unsigned long i;
>>>> +	pgoff_t pgoff;
>>>> +
>>>> +	pgoff = linear_page_index(vmf->vma, ALIGN(vmf->address, fault_size));
>>>> +
>>>> +	for (i = 0; i < fault_size / PAGE_SIZE; i++) {
>>>> +		struct page *page;
>>>> +
>>>> +		page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
>>>> +		if (page->mapping)
>>>> +			continue;
>>>> +		page->mapping = f_mapping;
>>>> +		page->index = pgoff + i;
>>>> +	}
>>>> +}
>>>> +
>>>> +static void set_compound_mapping(struct vm_fault *vmf, pfn_t pfn,
>>>> +				 unsigned long fault_size,
>>>> +				 struct address_space *f_mapping)
>>>> +{
>>>> +	struct page *head;
>>>> +
>>>> +	head = pfn_to_page(pfn_t_to_pfn(pfn));
>>>> +	head = compound_head(head);
>>>> +	if (head->mapping)
>>>> +		return;
>>>> +
>>>> +	head->mapping = f_mapping;
>>>> +	head->index = linear_page_index(vmf->vma,
>>>> +			ALIGN(vmf->address, fault_size));
>>>> +}
>>>
>>> Should this stuff be setup before doing vmf_insert_pfn_XX?
>>>
>>
>> Interestingly filesystem-dax does this, but not device-dax.
> 
> I think it may be a bug ?
> 
Possibly.

Dan, any thoughts (see also below) ? You probably hold all that
history since its inception on commit 2232c6382a4 ("device-dax: Enable page_mapping()")
and commit 35de299547d1 ("device-dax: Set page->index").

>> set_page_mapping/set_compound_mapping() could be moved to before and
>> then torn down on @rc != VM_FAULT_NOPAGE (failure). I am not sure
>> what's the benefit in this series..  besides the ordering (that you
>> hinted below) ?
> 
> Well, it should probably be fixed in a precursor patch.
> 
Yeap -- I would move page_mapping prior to introduce set_compound_mapping().
Now I am thinking again and with that logic it makes more sense to ammend inside
set_page_mapping() -- should have less nested around in the fault handler.

> I think the general idea is that page->mapping/index are stable once
> the page is published in a PTE?
> 
/me nods

>>> In normal cases the page should be returned in the vmf and populated
>>> to the page tables by the core code after all this is done.
>>
>> So I suppose by call sites examples as 'core code' is either hugetlbfs call to
>> __filemap_add_folio() (on hugetlbfs fault handler), shmem_add_to_page_cache() or
>> anon-equivalent.
> 
> I was talking more about the normal page insertion flow which is done
> by setting vmf->page and then returning. finish_fault() will install
> the PTE
> 
I misunderstood you earlier -- I thought you were suggesting me to look at
how mapping/index is set (in the context of the flow you just described)

	Joao
