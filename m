Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82742C9C
	for <nvdimm@lists.linux.dev>; Fri, 11 Feb 2022 12:48:38 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21B9UetP019101;
	Fri, 11 Feb 2022 12:48:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=zLyWL6gH3dIKvTaA0k6EmSVH2bXSzSLIgYZ6ml5Kp5Y=;
 b=sBvV5yqJivEW/AMpYhc30LSxD5/1550t5OAR2p62PFDc1eWUWvo0kA6rb+lr3tFs+Fmd
 cRf1gtxgCNPQPE38RCVIZIlQQTmdT4a1Y6B6F7++mUE01dkmLM1BBy3a/pr2pNUhVMMa
 W22xK0orQKwCpztUS/dlRkbpTLiup+ku5ajAC83syy5sn/BAYBrrnpxedIdo4TDGNUpn
 3dcfbklRRT+BA8CDuZ/H8CJWd70Ssg72Fi+sPgzBGAptR3651UdwyaaCbnf41MyNEYxf
 4tgjKCovLljliPsKI7YVziRfNX9YfAA3okInIcf+ec7cW6UnNKZiKw4nozi3oRm+7rc5 FQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e5gt48whb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Feb 2022 12:48:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BCaYdv097165;
	Fri, 11 Feb 2022 12:48:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
	by aserp3030.oracle.com with ESMTP id 3e51rv3dyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Feb 2022 12:48:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezu7g/CfHUhC50my/jUDc81r/41SzgYW/yWS5wBfcrSMByJHR6lsTxmfuucmIi/jtgjkYXOB002kvQgKf0XqJUJetd8FHJJVdIj49SxXFcG101aEIxu272dpcGVLULQoTlHRGuK6XaFFIlbuTOcMPEkZt79P9TXsHksPtJD0cDKS2pBSncuq4W9DNs3cldoSBsdZpoKcdYlosnRcbEoryIp/MgT5UpPmcNGjMWJHNCJz+zs6slYMbmdlDNwQDAnLdU/7Z2vyZBFOlyOcX3cclJnu415LGMdSdaWpltW+ceI2ddVE/2fdBQuzzqEs5lEAO0XQ8c9Qh13lV/l5LrdPKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zLyWL6gH3dIKvTaA0k6EmSVH2bXSzSLIgYZ6ml5Kp5Y=;
 b=AQzmM082JSSaedB/Tm8wGeWVb8Q1gUzS2BrZY3xNuDKsWJ6BlrLeBYc3BnVfwfegVAIR+PETd3ghab5WBAEZoN9yDYiIZVOfnvUiu7JQhLHJPzWlpLLr3blyS2IYvhghVyMM/N6bilfBxeeYdDWXBFzdd49Gcek55vrAhYmK3X3ynV7ZRzal4R8sqJM4gbIoEEwHKUt0G+JVELpzRFUhGiYAlBvOZSnllvGJoPTlw3gD/0Gt1J6tC8nqtRRKqtDzXoW4SA2Z3ZQw97bAWtGKfLPuKz3lLAAOZ+OyixjqCWiDLVTXngEFKcTPBHJYEK7EuW2RtqLB53YCDI+lrOBs6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zLyWL6gH3dIKvTaA0k6EmSVH2bXSzSLIgYZ6ml5Kp5Y=;
 b=rKIBlaoaCpkj3nn3iDu9Aa7XiOBR/9hf3SAtQcq0vhiDf2rdo9TN+hRZRowEY8bkjFl1RPa0YaIeiuesB8uKrP865Vor922cWspfkVGJ7LZlBSDgebbpSe9ACsebdKP6jZblw5MnGEUo6tK8D9YnIdKcryhp2+xObAVLBCvSU5o=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB3083.namprd10.prod.outlook.com (2603:10b6:5:68::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 11 Feb
 2022 12:48:29 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.011; Fri, 11 Feb 2022
 12:48:29 +0000
Message-ID: <cfd0690f-bbc5-0fba-e085-1385041c470d@oracle.com>
Date: Fri, 11 Feb 2022 12:48:22 +0000
Subject: Re: [PATCH v5 5/5] mm/page_alloc: reuse tail struct pages for
 compound devmaps
Content-Language: en-US
To: Muchun Song <songmuchun@bytedance.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox
 <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20220210193345.23628-1-joao.m.martins@oracle.com>
 <20220210193345.23628-6-joao.m.martins@oracle.com>
 <CAMZfGtXRPn3MPDpDEyFJJ98E3xTB65Q8_C+P92_XKsL-q8ah=w@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAMZfGtXRPn3MPDpDEyFJJ98E3xTB65Q8_C+P92_XKsL-q8ah=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0058.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::22) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47cd3a4e-3b9d-489d-42ab-08d9ed5ccda9
X-MS-TrafficTypeDiagnostic: DM6PR10MB3083:EE_
X-Microsoft-Antispam-PRVS: 
	<DM6PR10MB308310640055AE69AC21CE5ABB309@DM6PR10MB3083.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	EWFTADQDWfa46BkEmycOeEcbgfa1nMHCtHrWZpKTVEjDjnB8isZQZSXqXpcjqigD0y0vQ48UBz6O/cZB2xxnIDp1THZ+T7ztAildDUW2tpxGwbvbl7XV71KeLo3mAD0LFs78fab1skXFOeC3l4P1aPbqeYOdGdDOqMSHstec6CjUagsZ4SALbocgWoknbfCmwxsmbPJIJ59aKZDW/EJTcnhIpg0EOo1eUFYOh3DYdpHj9R+wZog24L2jW+5UxIcpaBmjdAY1qvAJGwRGWlPh8yCZcho7H+bRsqr81beLYzqS059sxCftIMyJPEN9iBWvaWp+PucdFZqjsNEe9SIdXxutFj+vsF3f5EHf8YPmDUFest0albhn8m5/glxMsq3jiQG6aqkKgL48YlE1giGmBcTumLjSdIqfE8XJKsrrVUKbWP9IVLrGMgIlPi8N1Tq5NZdkz5lFkN3fVLoJDJm4Vu465P4jdUT2vQ0trC1o+py/NMIq/B14i5Qr/M/DZ/ZU7af28gwvTPbLpJyezfamLzmSQD2EdO9Oh214Cf2VyOnaz49wclg5jgakmv3fsV/+xQgEXLi5ve85NBIQQ1aYafmuIJcFeGS2ReVir71hcwTMpdGDCaJjz3rgAoTEfKrvpdqaNcjMywQI6zWOXzfVwc0hzDSRQpsanC7bGc5acuDfnNMdfGnzDFeEGS/cJL/1022wmNqInPlv44BW7ornvQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(6916009)(38100700002)(54906003)(7416002)(6666004)(66556008)(36756003)(6506007)(508600001)(31686004)(2616005)(5660300002)(66476007)(53546011)(6486002)(6512007)(26005)(186003)(83380400001)(66946007)(4326008)(8676002)(8936002)(31696002)(2906002)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cVNkQjd0UUV0V3dLRjVyWmozcTlJaHdKMUxRV3VIaGY1VzFNeHFqdjRXZ1B0?=
 =?utf-8?B?OTlHaDNaYlhKQXZ1bGJRajR4SWpPRnlMYng2aDM0MEhIZllhejk2ajVrT0ZQ?=
 =?utf-8?B?SnVzZE1rckR3NnhrU2J5ZFB6eUxlNWE5SUYzZlczVTZDYU5yRzM5OEpnOE4w?=
 =?utf-8?B?VFRFNHU5QnVaOU5XUStQajZ2MlBvSHVKS2djYzJIWDZsVG5haFRHVzd3L1Rw?=
 =?utf-8?B?NnlBUVovOC9ZY0IvbE1JRGkwQUNSQkFTQnpvdzNiVXZKRnlBZnFKNE9TQkRn?=
 =?utf-8?B?UnpSMGVlNTZDZDRFWFF2RFdBNlp4eU5XN2oyVDFxQW5SeFNTc0tCUnQxd2VM?=
 =?utf-8?B?YldqL0JYdmZud01JeDcrK3dpNUx6MTlGNXB5S2hVTlpVRVZxeDVFbHNlbXk5?=
 =?utf-8?B?TWtaOGc3SURIUjRQV2JvSm52d1M5L2JQdFZkWjZVcFY5dm9obXV0ZzRKYXhQ?=
 =?utf-8?B?NzZxeU5IVmZsRTZ1OVZwblJmK09MMkZTSEhoYzBmWUFiVTV6TjM4b0hBNG5u?=
 =?utf-8?B?cXg0ZmNpaTdKVEFxdit2SWFVdlk0UnJVdDdHK0RXMURxczlMTUk1b0QzQjJC?=
 =?utf-8?B?M2wvY05aQXBoUTlmV09SaHpRRHhocS9VNUlYci80d0dFL1ROemFxcW5RTFJG?=
 =?utf-8?B?Vm5MbGllS0RVS1Z4QzNPSDhlYWhiUXhJNDN0UFc1a0g3WmQveFN0czgzVHRp?=
 =?utf-8?B?cUQzQlNNV2wvNk1MRjZ3SHFSYXRDQncvS3BCRDh5Mk9QdG9pTjFsaUZZZ3E5?=
 =?utf-8?B?VGRlQ2xBVEFGTkovR0JkTW9uT1daeUVwMzYrdkRQWlFHaXNuZm45SWpzLzZ2?=
 =?utf-8?B?MmNNTFJabnFNcHI5WVJtemlVOFZ4UzVHWTh6TGZsRDFEYWExSEZpbTFZNXIz?=
 =?utf-8?B?RktMbE05WTlCNHpiRXg4QUY1QXBnNUdaUHorZXhPTVpERmtLUFdMYW9EZDJV?=
 =?utf-8?B?Vm1TYWZMRHp2TGJVWXRZVFFTQS9pNEZtS1hSdEsvYUs1dk1GVjJRSmZUSFN0?=
 =?utf-8?B?eUE1VkNoSlE4MGpaOGN6cFdseGdHSlkyLysvQzJEcUo5WlJUVzRFbmd3KzNy?=
 =?utf-8?B?RTZFNGZaUFg4ZHlEWVR6UjBwOTJrWk5YRXA1c3RFeGVjRkljeFpVcFVxNmo5?=
 =?utf-8?B?R09Jd1NWcTdUNUxoTGhlZ0JVcWRVYzNQLzhta1FoaWk2MnFjTHRBRmdRd2Jy?=
 =?utf-8?B?cU5PdVVCbHBsWkVwQjl4RFN0V2paSS9ZRW9mVXhNSWg4YVV5Z2lKbWh1Rm8v?=
 =?utf-8?B?MHZrd3NyUGtza2FyYzFsVkczaDRwVFRPdHdCS2IybGc3RnVBZk8wNC82UzRw?=
 =?utf-8?B?dHp2SVVneEZTL3ZNOGhSaEVQd3hBS2RjT3BBVVpSQjgzd3A4eUx2OEpER3ph?=
 =?utf-8?B?QUVhWGI4QzljOWttWU9VN3I5RXZMZ0RMaWI0OFM4VCtVK0s3SHdWcm5kcjlJ?=
 =?utf-8?B?b3pDN3dYYW11Z3lGVVZyNDM3RU9GT2ROdkYxQjR3a05OV0V5YzlhRWU4S0Jm?=
 =?utf-8?B?ZHZXOUl1VmR2ZDhqYmNnbHcrSC8wWDJENzhjNlpDL3dueE8yMWJ6L1FRNUdm?=
 =?utf-8?B?SzljWDZXWVB6eGpjeUY3Ym5WUFQ2a21mUHNIRXUvTGNrdGxSaFY3aW42SXR4?=
 =?utf-8?B?OUtIem9HOWJwNlJyelE1SWdPSmQ3aDVxNGNabzR2UDBwUkxkdmNXMStrNjBm?=
 =?utf-8?B?SjFibWFIc0hvdVpYOE9zd2VFaDIyQkZDZnNXOHo3QTJHMUhRUkdaYkZZeUd4?=
 =?utf-8?B?a0JPVzNKUmN3Y0hiYUNsdWJ0bUpqMlRUeTVqZ2Y1L21naStJUy9tVjkzMVhN?=
 =?utf-8?B?TXJ5UnNMVW9zQ243cXNyZVQ3cFhQM2xsK3BwMVQ3Yy95Z2hsb0RDVzBEeEVK?=
 =?utf-8?B?eFM3b2FqYjFsZVJ0eWZqMFhwSkFFQk9BTUR2eUVCK0RyTnNURVI5NHhxRDRM?=
 =?utf-8?B?SWl6RFN6NHNhZG9lZmlXeDdFYzVueVB0YzlvMFV6ZGlUS3BXekhycEVGbVJq?=
 =?utf-8?B?WFhodXY5dlU0OWhzcDU1SFdncm5rN0dEamdUVkZsZXpqbFFhbUtsK3ZiT3BP?=
 =?utf-8?B?TFpsWDFuMTgrNjZ4cDNTUHR0Q2ttcEVyQlZ2aWxReUNrTjFhb25MamVLWkdk?=
 =?utf-8?B?V3BPbXN5QVRQd0tCWmNlczAwODJmdHZ6UVMzUFZyWkNob3FxbFdWck9UTlp4?=
 =?utf-8?B?azdtUEFFWEE2VnA0T3lxY2dGbnZ6cmNVenc0ekpTU2tyaXBLU05RUXlXQ0s4?=
 =?utf-8?B?VWV4aEV3WlViRXg2aHpoTW0rQnFnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47cd3a4e-3b9d-489d-42ab-08d9ed5ccda9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 12:48:29.5007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kPFh23FQNU0T11PhCnIl2RrHYrV/NvgsEEAcEHGya4AxI0jWwtTxGS7/kXifdP85xqAlqWUJIfjxIYGuJU8pil1JXL0ryY65tNwpOFe6gw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3083
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110072
X-Proofpoint-GUID: Il1gHE_wFaRH_Earqe78Tl2azoRq4vg2
X-Proofpoint-ORIG-GUID: Il1gHE_wFaRH_Earqe78Tl2azoRq4vg2

On 2/11/22 05:07, Muchun Song wrote:
> On Fri, Feb 11, 2022 at 3:34 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index cface1d38093..c10df2fd0ec2 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6666,6 +6666,20 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>>         }
>>  }
>>
>> +/*
>> + * With compound page geometry and when struct pages are stored in ram most
>> + * tail pages are reused. Consequently, the amount of unique struct pages to
>> + * initialize is a lot smaller that the total amount of struct pages being
>> + * mapped. This is a paired / mild layering violation with explicit knowledge
>> + * of how the sparse_vmemmap internals handle compound pages in the lack
>> + * of an altmap. See vmemmap_populate_compound_pages().
>> + */
>> +static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
>> +                                             unsigned long nr_pages)
>> +{
>> +       return !altmap ? 2 * (PAGE_SIZE/sizeof(struct page)) : nr_pages;
>> +}
>> +
> 
> This means only the first 2 pages will be modified, the reset 6 or 4094 pages
> do not.  In the HugeTLB case, those tail pages are mapped with read-only
> to catch invalid usage on tail pages (e.g. write operations). Quick question:
> should we also do similar things on DAX?
> 
What's sort of in the way of marking deduplicated pages as read-only is one
particular CONFIG_DEBUG_VM feature, particularly page_init_poison(). HugeTLB
gets its memory from the page allocator of already has pre-populated (at boot)
system RAM sections and needs those to be 'given back' before they can be
hotunplugged. So I guess it never goes through page_init_poison(). Although
device-dax, the sections are populated and dedicated to device-dax when
hotplugged, and then on hotunplug when the last user devdax user drops the page
reference.

So page_init_poison() is called on those two occasions. It actually writes to
whole sections of memmap, not just one page. So either I gate read-only page
protection when CONFIG_DEBUG_VM=n (which feels very wrong), or I detect inside
page_init_poison() that the caller is trying to init compound devmap backed
struct pages that were already watermarked (i.e. essentially when pfn offset
between passed page and head page is bigger than 128).
