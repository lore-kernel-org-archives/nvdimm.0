Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44D33481
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 15:36:09 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SFZTMv031360;
	Wed, 28 Jul 2021 15:35:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Pgkjr85fc70SUg8+bqBROaVv5bs8DJO9UBxrcxcEQjc=;
 b=iIIxx0JXs3udamSAR5PSSB0DIoDTv9Pjgwx4E8kf+rV1sXyr7Lamhjve/McJaVYj5KKc
 rL22VXbM82V989GCy9eNvk3ZJXlb2bKsRvBgp2u7YhHVxmhOe3V/gCETUEojZ0JtniU8
 SR1MxjxvKtVzScu15ucVLyy3FGgUUDcDJinKWTEu3t0vhkG2dyPZunJQphKSnr4i4imL
 MMPTwaEkXKodMcKXxIji+lADDQLILPSFgZgpMvhIqj3Wwr3Bi1Dg00x/dqWir34gxYPS
 ncLEfNKLnKeGK0wR45xXmHqOjoUhWNhFtffxnGXPHTtCCBRDPY1iuIIPOB7i+NcXfyfT uQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Pgkjr85fc70SUg8+bqBROaVv5bs8DJO9UBxrcxcEQjc=;
 b=vZehOiKTxPCWOrXd9wZnCCCzzT2gXWnSqHjNP9h6i7SP+5pekCQI+3PEB429i5kejSmg
 klfszjEFYBxUWUxvMXDCc+85GpxauZg5RF4lI+msHG50OHNVb+VOsCQB1dN/MmCQFG+9
 gvZzkF4iu7xv+1OW6oEwPR1U2F1bIo01yU509x3TlkCxhP7ft9GIfiuPYxWH4021iP2y
 6V3HrVzEYv9lK4a+TdirPEAPdqA6ISRAWAKngn7Omaj0RUow8hxia3pK4TAl6eYpF66W
 v8T7PwWlk/ZpiFYJu1IY0K3pduuDxoKZQ+1A/0LqQpY5PkQbX+lJB/3rt8W9wmB43bC1 oA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a234w506k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 15:35:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16SFUwZb103540;
	Wed, 28 Jul 2021 15:35:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by userp3030.oracle.com with ESMTP id 3a2355g85g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 15:35:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+GS4+pXNDg1gJjLBhP7c/BC8y99iGmBRC9m91pvgErrppEF0C6lxSp8CCC/63fGBHLou0L9LtT95n+DpPQtOGRRqRyGVIqTtAwMddgUn90Qj3VfBVyd114lwsoSXjrk3NgG3AAcoGqlgvwsk+KqCdXwvw6sF7cgA+EA4cbeNXtZjBnryK/vZoPdZ/Y1YuX49yKkwnrqGiYB+YW/Man+Xe1AjTeyZ5R/+QJdwwXVuVFViBPSjVf2oEzH4VOLQ2pjd+8xiZuCu4YhAbKM5RD9OXXPszw8WTMQ71glyzL8p+hQIfIIOwcLDx9+QYZeoAhyCXvmlwT9sovotmSP7P7IIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pgkjr85fc70SUg8+bqBROaVv5bs8DJO9UBxrcxcEQjc=;
 b=VJqDdHxgMFw0dXxj7suEDVm0+0uZ2IHjjdSj7vHGu/TIJILA5CDa1THBfzXo6spae55NT0uPUVMGsTpz//JUilRFoIenos3OQi4saV8fOnvv178mOFZBrGCZrcVRKjqVGhEwcNEHh2QHOmJqJbvr7TJt6qISMEcucxzLqF2oMR8BkmHJxGRQDaSOTKvW9dPhCsC+er4Q2zR1IU2xz/VFVTum1HZBi6kf9kMlhX3xP/mf0/ymcKlNpW+hPOD6PNk8E0aFKJqNxUMXaZSCZYcoDN7gDskSBH6Z7mvwllJCDchUxRgXHKX89E9wG4BGXyzt2/lw9cF+ut9ScgMlZkZwsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pgkjr85fc70SUg8+bqBROaVv5bs8DJO9UBxrcxcEQjc=;
 b=v8Hj1ysabjnz/MNC8tZdG4wnsAJCwNMp4jrfWcTYLoPCKE0DLXmCf50XyH26zvM9b0TWXxtaxs6IWwCjWZdANRAbusO/9FPOQjFbxCNiwr52058by99GPb7HJPq31CvbkD5SBmDUtDiPP4Feg1VIsjTi/vtsT5OeRbK0IthCGA4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5140.namprd10.prod.outlook.com (2603:10b6:208:320::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Wed, 28 Jul
 2021 15:35:51 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 15:35:51 +0000
Subject: Re: [PATCH v3 08/14] mm/sparse-vmemmap: populate compound pagemaps
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
 <20210714193542.21857-9-joao.m.martins@oracle.com>
 <CAPcyv4jPWSeP3jOKiEy0ko4Yy5SgAFmuD64ABgv=cRxHaQM7ew@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <131e77ec-6de4-8401-e7b0-7ff12abac04c@oracle.com>
Date: Wed, 28 Jul 2021 16:35:44 +0100
In-Reply-To: <CAPcyv4jPWSeP3jOKiEy0ko4Yy5SgAFmuD64ABgv=cRxHaQM7ew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0186.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::11) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0186.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a4::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Wed, 28 Jul 2021 15:35:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26377b9b-db02-4994-7040-08d951dd615d
X-MS-TrafficTypeDiagnostic: BLAPR10MB5140:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB51404AAFDBA4BF8B4DE7E86BBBEA9@BLAPR10MB5140.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	yEl8eui/wt69/QC+JWy3/2KroavnScHmu/wPybjou96sxM1tg3W4zCRE0SLGJAg8uWT2oqi71yGlbTh8NY8F/Q/veU3FsUZC5ZoQ36e7I74tn9UpuC6fP13mGtigIeUgObFwjWwgGoHjhUC+UkFDsFi7sPMqBlzLgmBbKK9iEMV9FjLus5LdC402hGhR0C5fdcDNLpxoa3hFd1QmvysoBrQS7qU3avoshC4S68IPyhQ3jjs7c95tsmy+kPQid+a2FBbXHv41xxSeS1b7sTfOLL4+758cD/8VM3u3KY2T+B1WswYzRZlB0Cq7+esu1WcI9GzQ7KLzu9OL0Ylflaa8grxKIah335bVO0qxl+4p7/PumOLxqx9ZTh9PwrX1U9aR8RkXEFzZQIB+5O9WYotRoqu0ZQxCE8EbpRU9X/ncPO3v2Kc5ZOfFn3Sx1o3m2kGRZab7LEMhfXabs4pJct5z6oNZhxy1cX566kZqcY4xIOG1BfVuuLKNG00JhfjDDFBsGg8jGbIHhsOnYHb9I45zSesWOwpn1WTCKC7ylfM6cHlvt6pQf8STk56SA+pS3wOnxzLuUGENP+FQexjTs+P05Sf5FMXm2xJPefVhmGC2wKaPTt5V9W0FSWAp7M6AiKoIDuYKpPNWnt1iEROUvsIc/B2ijgsuXb8VkSdvoj3oJ+Ftw4oWTJHp1Ll48GYZC4vV39Tw0s9wIVkOZxba2NIM4w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(366004)(396003)(136003)(31696002)(86362001)(186003)(6666004)(83380400001)(8676002)(956004)(5660300002)(2616005)(16576012)(26005)(316002)(6916009)(4326008)(36756003)(2906002)(30864003)(7416002)(478600001)(6486002)(8936002)(53546011)(66556008)(66476007)(66946007)(54906003)(31686004)(38100700002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?YTBiQjh3MmF4c0ordm5SVWJzd05jMVYwbzBtZmRtSWo1YlhxbnI5Y2tkUVdZ?=
 =?utf-8?B?OGR3YzhoWXlNUlV1V2E2amlocU9zbFBMWWdQbDNFdkxxOVMxUmhPQWZLNTFs?=
 =?utf-8?B?QW93YVAvbURnanZlR1BjS1oxT2xpempQSFB6SzduT3VhSVRYRWdLcDV6N3R2?=
 =?utf-8?B?UFlMa1ZiWW1pRTd0dG16VFV6UWVycTlIMTBpMGNKMWJoUGZVZDJLWE9EUHli?=
 =?utf-8?B?ZlA2RitLbzhJSXgwVjhzVXVIQTl0VjVOWXBOdU5ib1JMZU5Za2ZTSHlmMXB3?=
 =?utf-8?B?UjJyWTRYNlpVMDhVUHcxNmlqblpBREtPM1FMSWVRTzNIMHRoTHllbWJZVldw?=
 =?utf-8?B?UWRvTk9uZWtRQzZ5SzZLeW4ybEJmZkFsZEhIamNCWWE0aTk4Snh2VEZTdkc5?=
 =?utf-8?B?U2xyNUwrVWlNV0FNOUgvNk1jY1BmZlNPK3d4bW01TWROZitnOHFTam5mcFZi?=
 =?utf-8?B?WER0MCt6Q1l3ZzlPUGV3QWRTUUdoRmViZUkySVdDbFdyaFpoUzAvVDVJUnVW?=
 =?utf-8?B?d2pQWkkyaVdFdVNOL0FBRXVORDJCeXR2MTZhdGpUODlacExDUDUvLzBpc2tl?=
 =?utf-8?B?bDJmNXRHa2lCOUNFTzhJaG5HdE1vR1llT1dVeThMTVJXeW5WdFNaYUYva24z?=
 =?utf-8?B?VkFaVEY5cUJaUWVVWWt2MndGb2lmVjNmOGtOb3RjOSt3M3doczl5bFl2WWo1?=
 =?utf-8?B?cWZWVmtWcFhVUXdWYWRsQ2NmeG1QZG5SRjFTSG5zNHVqb0lHTzFOb0psd0hw?=
 =?utf-8?B?MjArMVJKZlRINU5SeENrZHVEeXNIQ3I1VFFkcmhBbUtNci9XNG4vOGhzaHJF?=
 =?utf-8?B?bXhNYkozOGdFaGFTY0E4czRZdm1Sczh3ai8yd0pOdWgyOWlaRWNVSUJOUU1o?=
 =?utf-8?B?a3RLSlJUYXo4ZXZ5Yi9aMWc0QUZxL2YvS2llcmt2aE8yMGZOc3B2RDlibjZm?=
 =?utf-8?B?R1JHeGF2SGtPVzhoZFBRS0c4Nk5RNHdoWmlRbFJJaXRWaG1Xdzl0TTgyMnFt?=
 =?utf-8?B?aWJYS3pKc2doSS9mMnJMUTRLZHllUjhYU1Rnb0VLWEp1UGNJUHV6Y2EwQWV3?=
 =?utf-8?B?VEtlNmhVOTFXc1U1TVdKajROMFNrN25WWjhZYWhZZ0EwZTFzN0R6OThKQ2Qv?=
 =?utf-8?B?Ym9jdzRQL0VNY3BOK2FHZVhQYm9WQkhIYWpZWnRYNllnRjVpeU4zaWZGU1Nr?=
 =?utf-8?B?YnM0eVdNSEpNNko5eUNqdXZ6SWJycUpsZzcvZnc5bnppcmlFcjAySjJTTmM4?=
 =?utf-8?B?R3NGVnF0REhYTloxQnFEczlyc0UvRGF2VXJOeGtiM3ErcVF4TVBvOUJlRG5a?=
 =?utf-8?B?V0ZDRVk3NmtXaHFvc3RRaFhGa2NPVEdwRW1GY3VmRS9VNjlHckNrbG8wNzc1?=
 =?utf-8?B?S1JQell1ZE41SzhjTzJ1emp2MEhLRlB0bElHSWIxNTF2WXJDL2hTVEx5MHpX?=
 =?utf-8?B?dDl3eFBuM2pIMXk0QnZlWHl5VTFJVTQreG5xN21jeHFHRjVzRzFyN1RoMlJp?=
 =?utf-8?B?R0UyZjVJL0hMSElFa2I2Z2Z0WWFyUWtjbEo1WFlyTGU1cjBQeFg5Q3hlcmRO?=
 =?utf-8?B?ZFVKK3Y1SW0zRUpjdjJyaU4wWWx1Qkhqd0pISkFoU0VCSG1ZdkU0UFZJL2lQ?=
 =?utf-8?B?Y3dPbXNSMnZnVDVMUUpWeTZMSUZhaFQyWEo5RC9TYXZoSU1hcFA2dW0vR3Fu?=
 =?utf-8?B?WGRZdzVaNkxIRGdLa3pLaVMycWp6UmFUV2NCL1VzR2p0NHZnd3JyTzhwMnlJ?=
 =?utf-8?Q?SagFuq0aWCdxwiga71s/BcrpP+azrk2HsxTm9Kq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26377b9b-db02-4994-7040-08d951dd615d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 15:35:51.4703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: irTnO/Bz72iybcf0tn1dtLW7tVUcE6kqke8b53pyhH4X6VQvtajdsMpqP5x0bpejGywPoiP+1Wi6VyNGITWOQTf21QHBrZ1pyDkB9rqU5KI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5140
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280086
X-Proofpoint-ORIG-GUID: OAEMhgybsQR-AfKbXkIKOq25k2olWKla
X-Proofpoint-GUID: OAEMhgybsQR-AfKbXkIKOq25k2olWKla


On 7/28/21 7:55 AM, Dan Williams wrote:
> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> A compound pagemap is a dev_pagemap with @align > PAGE_SIZE and it
> 
> Maybe s/compound devmap/compound devmap/ per the other planned usage
> of "devmap" in the implementation?
> 
Yeap. I am replacing pagemap with devmap -- hopefully better done than
the s/align/geometry which there's still some leftovers in this series.

>> means that pages are mapped at a given huge page alignment and utilize
>> uses compound pages as opposed to order-0 pages.
>>
>> Take advantage of the fact that most tail pages look the same (except
>> the first two) to minimize struct page overhead. Allocate a separate
>> page for the vmemmap area which contains the head page and separate for
>> the next 64 pages. The rest of the subsections then reuse this tail
>> vmemmap page to initialize the rest of the tail pages.
>>
>> Sections are arch-dependent (e.g. on x86 it's 64M, 128M or 512M) and
>> when initializing compound pagemap with big enough @align (e.g. 1G
> 
> s/@align/@geometry/?
> 
Yeap (and the previous mention too in the hunk before this one).

>> PUD) it will cross various sections.
> 
> s/will cross various/may cross multiple/
> 
OK

>> To be able to reuse tail pages
>> across sections belonging to the same gigantic page, fetch the
>> @range being mapped (nr_ranges + 1).  If the section being mapped is
>> not offset 0 of the @align, then lookup the PFN of the struct page
>> address that precedes it and use that to populate the entire
>> section.
> 
> This sounds like code being read aloud. I would just say something like:
> 
> "The vmemmap code needs to consult @pgmap so that multiple sections
> that all map the same tail data can refer back to the first copy of
> that data for a given gigantic page."
> 
Fixed.

>>
>> On compound pagemaps with 2M align, this mechanism lets 6 pages be
>> saved out of the 8 necessary PFNs necessary to set the subsection's
>> 512 struct pages being mapped. On a 1G compound pagemap it saves
>> 4094 pages.
>>
>> Altmap isn't supported yet, given various restrictions in altmap pfn
>> allocator, thus fallback to the already in use vmemmap_populate().  It
>> is worth noting that altmap for devmap mappings was there to relieve the
>> pressure of inordinate amounts of memmap space to map terabytes of pmem.
>> With compound pages the motivation for altmaps for pmem gets reduced.
> 
> Looks good just some minor comments / typo fixes, and some requests
> for a few more helper functions.
> 
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  Documentation/vm/vmemmap_dedup.rst |  27 +++++-
>>  include/linux/mm.h                 |   2 +-
>>  mm/memremap.c                      |   1 +
>>  mm/sparse-vmemmap.c                | 133 +++++++++++++++++++++++++++--
>>  4 files changed, 151 insertions(+), 12 deletions(-)
>>
>> diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
>> index 215ae2ef3bce..42830a667c2a 100644
>> --- a/Documentation/vm/vmemmap_dedup.rst
>> +++ b/Documentation/vm/vmemmap_dedup.rst
>> @@ -2,9 +2,12 @@
>>
>>  .. _vmemmap_dedup:
>>
>> -==================================
>> -Free some vmemmap pages of HugeTLB
>> -==================================
>> +=================================================
>> +Free some vmemmap pages of HugeTLB and Device DAX
> 
> How about "A vmemmap diet for HugeTLB and Device DAX"
> 
> ...because in the HugeTLB case it is dynamically remapping and freeing
> the pages after the fact, while Device-DAX is avoiding the allocation
> in the first instance.
> 
Yeap. Better title indeed, fixed.

[...]

>> +static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>> +                                                    unsigned long start,
>> +                                                    unsigned long end, int node,
>> +                                                    struct dev_pagemap *pgmap)
>> +{
>> +       unsigned long offset, size, addr;
>> +
>> +       /*
>> +        * For compound pages bigger than section size (e.g. x86 1G compound
>> +        * pages with 2M subsection size) fill the rest of sections as tail
>> +        * pages.
>> +        *
>> +        * Note that memremap_pages() resets @nr_range value and will increment
>> +        * it after each range successful onlining. Thus the value or @nr_range
>> +        * at section memmap populate corresponds to the in-progress range
>> +        * being onlined here.
>> +        */
>> +       offset = PFN_PHYS(start_pfn) - pgmap->ranges[pgmap->nr_range].start;
>> +       if (!IS_ALIGNED(offset, pgmap_geometry(pgmap)) &&
>> +           pgmap_geometry(pgmap) > SUBSECTION_SIZE) {
> 
> How about moving the last 3 lines plus the comment to a helper so this
> becomes something like:
> 
> if (compound_section_index(start_pfn, pgmap))
> 
> ...where it is clear that for the Nth section in a compound page where
> N is > 0, it can lookup the page data to reuse.
> 
Definitely more readable.

Here's what I have so far (already with the change
of pgmap_geometry() to be nr of pages):

+/*
+ * For compound pages bigger than section size (e.g. x86 1G compound
+ * pages with 2M subsection size) fill the rest of sections as tail
+ * pages.
+ *
+ * Note that memremap_pages() resets @nr_range value and will increment
+ * it after each range successful onlining. Thus the value or @nr_range
+ * at section memmap populate corresponds to the in-progress range
+ * being onlined here.
+ */
+static bool compound_section_index(unsigned long start_pfn,
+                                  struct dev_pagemap *pgmap)
+{
+       unsigned long geometry_size = pgmap_geometry(pgmap) << PAGE_SHIFT;
+       unsigned long offset = PFN_PHYS(start_pfn) -
+               pgmap->ranges[pgmap->nr_range].start;
+
+       return !IS_ALIGNED(offset, geometry_size) &&
+               geometry_size > SUBSECTION_SIZE;
+}
+
 static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
                                                     unsigned long start,
                                                     unsigned long end, int node,
                                                     struct dev_pagemap *pgmap)
 {
-       unsigned long geometry_size = pgmap_geometry(pgmap) << PAGE_SHIFT;
        unsigned long offset, size, addr;

-       /*
-        * For compound pages bigger than section size (e.g. x86 1G compound
-        * pages with 2M subsection size) fill the rest of sections as tail
-        * pages.
-        *
-        * Note that memremap_pages() resets @nr_range value and will increment
-        * it after each range successful onlining. Thus the value or @nr_range
-        * at section memmap populate corresponds to the in-progress range
-        * being onlined here.
-        */
-       offset = PFN_PHYS(start_pfn) - pgmap->ranges[pgmap->nr_range].start;
-       if (!IS_ALIGNED(offset, geometry_size) &&
-           geometry_size > SUBSECTION_SIZE) {
+       if (compound_section_index(start_pfn, pgmap)) {
                pte_t *ptep;

                addr = start - PAGE_SIZE;


> 
>> +               pte_t *ptep;
>> +
>> +               addr = start - PAGE_SIZE;
>> +
>> +               /*
>> +                * Sections are populated sequently and in sucession meaning
>> +                * this section being populated wouldn't start if the
>> +                * preceding one wasn't successful. So there is a guarantee that
>> +                * the previous struct pages are mapped when trying to lookup
>> +                * the last tail page.
> 
> I think you can cut this down to:
> 
> "Assuming sections are populated sequentially, the previous section's
> page data can be reused."
> 
OK.

> ...and maybe this can be a helper like:
> 
> compound_section_tail_page()?
> 
It makes this patch more readable.

Albeit doing this means we might need a compound_section_tail_huge_page (...)

> 
>> +                * the last tail page.
> 
>> +               ptep = pte_offset_kernel(pmd_off_k(addr), addr);
>> +               if (!ptep)
>> +                       return -ENOMEM;
>> +
>> +               /*
>> +                * Reuse the page that was populated in the prior iteration
>> +                * with just tail struct pages.
>> +                */
>> +               return vmemmap_populate_range(start, end, node,
>> +                                             pte_page(*ptep));
>> +       }

The last patch separates the above check and uses the PMD (and the @offset) to reuse the
PMD of the compound_section_tail_page(). So this might mean that we introduce
in the last patch some sort of compound_section_tail_huge_page() for the pmd page.
So far it the second change doesn't seem to translate an obvious improvement in readability.

Pasted below, Here's compound_section_tail_page() [...]

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index d7419b5d54d7..31f94802c095 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -673,6 +673,23 @@ static bool __meminit compound_section_index(unsigned long start_pfn,
                geometry_size > SUBSECTION_SIZE;
 }

+static struct page * __meminit compound_section_tail_page(unsigned long addr)
+{
+       pte_t *ptep;
+
+       addr -= PAGE_SIZE;
+
+       /*
+        * Assuming sections are populated sequentially, the previous section's
+        * page data can be reused.
+        */
+       ptep = pte_offset_kernel(pmd_off_k(addr), addr);
+       if (!ptep)
+               return NULL;
+
+       return pte_page(*ptep);
+}
+
 static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
                                                     unsigned long start,
                                                     unsigned long end, int node,
@@ -681,27 +698,17 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long
start_pfn,
        unsigned long offset, size, addr;

        if (compound_section_index(start_pfn, pgmap)) {
-               pte_t *ptep;
-
-               addr = start - PAGE_SIZE;
+               struct page *page;

-               /*
-                * Sections are populated sequently and in sucession meaning
-                * this section being populated wouldn't start if the
-                * preceding one wasn't successful. So there is a guarantee that
-                * the previous struct pages are mapped when trying to lookup
-                * the last tail page.
-                */
-               ptep = pte_offset_kernel(pmd_off_k(addr), addr);
-               if (!ptep)
+               page = compound_section_tail_page(start);
+               if (!page)
                        return -ENOMEM;

                /*
                 * Reuse the page that was populated in the prior iteration
                 * with just tail struct pages.
                 */
-               return vmemmap_populate_range(start, end, node,
-                                             pte_page(*ptep));
+               return vmemmap_populate_range(start, end, node, page);
        }

        size = min(end - start, pgmap_geometry(pgmap) * sizeof(struct page));




[...] And here's compound_section_tail_huge_page() (for the last patch in the series):


@@ -690,6 +727,33 @@ static struct page * __meminit compound_section_tail_page(unsigned
long addr)
        return pte_page(*ptep);
 }

+static struct page * __meminit compound_section_tail_huge_page(unsigned long addr,
+                               unsigned long offset, struct dev_pagemap *pgmap)
+{
+       unsigned long geometry_size = pgmap_geometry(pgmap) << PAGE_SHIFT;
+       pmd_t *pmdp;
+
+       addr -= PAGE_SIZE;
+
+       /*
+        * Assuming sections are populated sequentially, the previous section's
+        * page data can be reused.
+        */
+       pmdp = pmd_off_k(addr);
+       if (!pmdp)
+               return ERR_PTR(-ENOMEM);
+
+       /*
+        * Reuse the tail pages vmemmap pmd page
+        * See layout diagram in Documentation/vm/vmemmap_dedup.rst
+        */
+       if (offset % geometry_size > PFN_PHYS(PAGES_PER_SECTION))
+               return pmd_page(*pmdp);
+
+       /* No reusable PMD fallback to PTE tail page*/
+       return NULL;
+}
+
 static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
                                                     unsigned long start,
                                                     unsigned long end, int node,
@@ -697,14 +761,22 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long
start_pfn,
 {
        unsigned long offset, size, addr;

-       if (compound_section_index(start_pfn, pgmap)) {
-               struct page *page;
+       if (compound_section_index(start_pfn, pgmap, &offset)) {
+               struct page *page, *hpage;
+
+               hpage = compound_section_tail_huge_page(addr, offset);
+               if (IS_ERR(hpage))
+                       return -ENOMEM;
+               else if (hpage)
+                       return vmemmap_populate_pmd_range(start, end, node,
+                                                         hpage);

                page = compound_section_tail_page(start);
                if (!page)
                        return -ENOMEM;

                /*
+                * Populate the tail pages vmemmap pmd page.
                 * Reuse the page that was populated in the prior iteration
                 * with just tail struct pages.
                 */
