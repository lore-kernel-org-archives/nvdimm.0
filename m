Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373C07A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 11:33:16 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22AA9vtL002638;
	Thu, 10 Mar 2022 11:32:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/IFjqNEP3wHHjlzgTjo5rG78Gc/QL0+z/uCQx5ZBgzE=;
 b=tWiA3CQiKQOZUtVIttSFdNL6hqt+PILxkrAMkKTjM4W9Rhmzg0Ow0BP7nDaeB/p1zCya
 fmyIc6n0+oJScseQnKLhKHGyCc3mFQjkvk/D5LBlkenLZdx7L9nOyWz+gLBewZC1Vq+3
 fOVXM3rWrsCvD+/prJkzXGuL4vYqQ/r9VYKiNxMXla+jZTgVhQapz3YZmJ0g7ZS4U31u
 CkUxUlNvbTf2cDkGR2asROjShlstp1oFG/tZ+86NEGA94I5fpRkYaK85pBsi8MPx5mmB
 dJ0XjFI2LFafyGibZR3lJk0BIuihJT+ppXLawHEEa+KfsKVouN5nT9O7/n+xR5nesHW8 Pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cmrv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Mar 2022 11:32:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22ABVLHA171491;
	Thu, 10 Mar 2022 11:32:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
	by aserp3020.oracle.com with ESMTP id 3ekyp3h52c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Mar 2022 11:32:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eS0WJ6jOC/0kMjOihs8qIXmT5JN0Nj2GHEThbNifh3DWqzkL+YwjW/6NMq4vjLRUwhuCVP3M3NkPuva+YrpOji8KYeEenbPPuXkk1RkGgQ6w+IR5XBk/A033pOvbgbf/TN0j2BWecyRH0VyzDt0DMw+ue8mp7a9Qys6nY7DQXyWp+xtYD+ZxqLdt4cqL8wwPydrbUQpi7OsArzKswcEt0cGI5BI5wMwzdEFplB7LaScHicp82IMYYQKWEgS3AfT+fhaUmOoI572ERTLhzalToWUok0T+cxkKqC4ia5gIYPOuRlTZtaYET0K9fj/g26nZx0+lfh5uZi8nLIoh6T1ViA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/IFjqNEP3wHHjlzgTjo5rG78Gc/QL0+z/uCQx5ZBgzE=;
 b=JjYNowQCGWcvGSaRAedAwGQkExCjTGEv4sqW1Qc9VCaSSuHuE44p/xNxx6OLrqH9WbXxV2GOm1RlDS+wkwghhkpE9vPBykn1G8szcV3Mg/4c+3GIhqICWFyZk958E57IQrh7nLRqrNj3WH9APjYWgcqJAa3Z/Cf8V0/Bn5l4nBvkfiIsteyucawbV1qeHrYWtnWUEIcbvBA+0tqx84G/liEccHoLr4Q+mSSW0bbq2+p/7k8E6syJPz/0/lprtK1mGn63d4OartAb/CVuMjztW7Gyb35Vh7wExWJNaLi8vEhq1/QrnG96lMWrb1KKXgP2cvJ1fWh3dOzlsylT+1FVzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IFjqNEP3wHHjlzgTjo5rG78Gc/QL0+z/uCQx5ZBgzE=;
 b=iUMq89doCqvbIRQUGwittsAOccM0EY4gSkOdz3z7e7+8AyGpeQbP2HEHCiUPrhjtZHHAg3lk9nKCe6tg7Cnbzdg34YEPpssm8gYU/e5EhDnJPjEKVBKyK1JN3w6a6b7P9q5JziH5ukO3vH0PpLfuZTtcEllJ+qX/BCtOVyTM6Kw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR1001MB2379.namprd10.prod.outlook.com (2603:10b6:4:30::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Thu, 10 Mar
 2022 11:32:32 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5cee:6897:b292:12d0]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5cee:6897:b292:12d0%6]) with mapi id 15.20.5061.022; Thu, 10 Mar 2022
 11:32:32 +0000
Message-ID: <1debf72b-8354-604e-1574-bf956c869dd7@oracle.com>
Date: Thu, 10 Mar 2022 11:32:21 +0000
Subject: Re: [PATCH v8 3/5] mm/hugetlb_vmemmap: move comment block to
 Documentation/vm
Content-Language: en-US
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Matthew Wilcox
 <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
References: <20220307122457.10066-1-joao.m.martins@oracle.com>
 <20220307122457.10066-4-joao.m.martins@oracle.com>
 <YinT2fO2cDmoLYXG@kernel.org>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <YinT2fO2cDmoLYXG@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0412.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a001420-f535-4e0a-ea5b-08da0289aace
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2379:EE_
X-Microsoft-Antispam-PRVS: 
	<DM5PR1001MB2379DD10F6F5423C46A410D3BB0B9@DM5PR1001MB2379.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	OT6VC8uh7wZft2aVt4+8QUmocUiHFc0RkavJSzK3zN094p03hAYJ9QK02/M4dIX2CoNj7IivlIfcWN0ABupNLve19JjhCvofB3G4c9mYLBdrWs4O9ROuZkOwa/yPGj3hKnnB34venQZlLzzi7eioAjeV3bNAkNw4UxkBp6pe9YggwpHqW027+WzIHREp3jaJA41+3etiiTA1o1VmUpeSE8dSUT1K6F8Y1d7c37yrrLbvHEtnC01bEP6cUySaMANCFp84+PgT3vTp7JfUhUODjtaDZHw9reIoszEwFLgBLHZT9rb3Xxrj5w5nnSlUDsuArnmZUOzUxIYAZM7QnyS0Rg+d0WsBlzyC+QqHlToxuc94T5Q2IHrJ7PIxHLDdC2Z/iWtTDcHujUfXNu4YTH4SOgl4k6qP/KOWgRgKmGXJMOgthV98m9Zk+3/o2IbVU9NAJxhmaQ2uIpoNaU3/HWzh3JdQvdUTnWXp+rONXpPHPQRs1nLUljNpOv+cVVjQ6VcjeXczZeO/9jbMjvzWGgDoIxL18ZeStVYRbuUFV0nbiFQiAbPzVvKGOLR8EgFJb86C4UqKMXMQN3aGrBwI6anXnr4sptjSCkIveueMF5qxzfAzVNFT/awmo1sPSNSS6OFlt+BtjCgHCQjuwbDyQBZveVws1++d9eOOp2D/cEg+217T9llohIejfTBWUaeXHKKieFG7M9RHxN7GGPm9LC/9JQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66946007)(6506007)(316002)(4326008)(8676002)(6916009)(2616005)(66476007)(6486002)(186003)(36756003)(26005)(31686004)(83380400001)(38100700002)(53546011)(5660300002)(31696002)(86362001)(6512007)(6666004)(7416002)(2906002)(8936002)(508600001)(54906003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NzhqZDlWZjVnUlY4RW8wSVdndnh4dmhCeTNWVGpZNTUva21oWHdWb3o0QStG?=
 =?utf-8?B?bmxpeEpwSG15aGx3Qm9ac1p3QjVpL29MTW8vSWRBTC9SUDYzYldjWFNUNGVV?=
 =?utf-8?B?ZkQ3azZGY1NJWTZPMWZMVmwrVU5PRExaQXFHY0k1SUIwY21sR08xUnJyVzdK?=
 =?utf-8?B?ZUJLbHF3a0FmejdNcmJOOWZON3o3OGt6TkUvUndqdDhuRmNBL0JuQ1lueEc0?=
 =?utf-8?B?UjBOT1NrS09yajd6THJIK0pqVDFGaTZaOG5RQitZTEZhVnJqM2N1UWdoZkdz?=
 =?utf-8?B?KzJOYk1QcG1UajdFalZVcU9jYjlta1VhVkxTYmVlNTFHVEtZcEQrMjdVMjNi?=
 =?utf-8?B?N0RxcHBaZ0RWN1YxTkRSa1dBMkYrU25XcDJPYm8zMUc3bW5ndDNOcXhUQzFX?=
 =?utf-8?B?R3RlanlFYjZrSWVZaEZYTk5QM3luaHZXWGw5M21yNXRrQi9IUTRWanZxcytL?=
 =?utf-8?B?Wlc0eHVPTEZhV2RjT2VlSWs0aDZnL2ZhV1NuNkJLRHJzKzh0TXhmRVBwZTJ3?=
 =?utf-8?B?dHFTOS9tbFhoSUdKZ3ZNZzdYMjNlbmFOUElNWjJwL2ZhbUZScnVUT2ZKNzJL?=
 =?utf-8?B?ZEVJMXdGWEw1dTBXaWhXVXlFdnRFQ2NsZ1JpdGlFcUtIR29PeUhaV2N4T1Vj?=
 =?utf-8?B?WVZycWxxMml0MkkxaTZjUlE2dGl4VDloTUFpcURVRUdYNmErd0MzR24raHdE?=
 =?utf-8?B?Tm5YNmV3ZkdTdGs0SGk0MENHRGR4SWRDTTlOMEVZN1BUM3pRZHpreTBock14?=
 =?utf-8?B?NFpYL0Qxc1cxazRkY1dLNHNpRmRXdU42Y1JMRU1MbktxTlloQS9CS3haRCtP?=
 =?utf-8?B?eXo5MERpUUNMUFNtMDZlN0RmMnZkOEVKUmVUV1FSTUNWRVB2NWtEOEF2OGN3?=
 =?utf-8?B?ZkxNTDFIY0ZDeEVkd1JnZkVTSlZtRVFselppNlFqSDdMbkRrcWgzZVdkQVpU?=
 =?utf-8?B?L2tBaVZnWHNmTHpzbCt5UEhNNTFCQXRaS1hUSHZpMFBjVHpXV25HZkdpd0cy?=
 =?utf-8?B?c1JXOGxjQnBKNk83ZzdmWnZxZWZBOHhFRFA3WXZZS3p4c3FJMmFpQ3F1ZmlV?=
 =?utf-8?B?QjRpRktxSHdyS096VHlvdUxCaHRPZFN3T3UyM3o5bjQ2ZlBJRWJvd0VLVDdq?=
 =?utf-8?B?UlVFNnNIc1hFV3VBNG9HZUFOMGl1eTR1RXFtOXc4bEoxbUNhNlNaT2RUbDQ1?=
 =?utf-8?B?N01Xd3ljMElScTBWbElvNmVab0N3QTZ5VVpJOWdXc1FaaU5nTExtTnZULzho?=
 =?utf-8?B?TjloM2t0Z3NPeURHM0dpVC9SRnZWQy9rTnJxSWoxeTN4S1FadnZqSWs1OWNq?=
 =?utf-8?B?K2pBdVVsdzIzYWZxNWFPbXB5Y0sxMDAwcVJycW1BNHpHOEcwM1AvNG82Vnpw?=
 =?utf-8?B?UERGeHk0QVR1T1hreGRXOE0xWVhuTmQ1YTF3VER1VTdrK2RDYWJJZVcxTFVr?=
 =?utf-8?B?eXN1WXNGbS94TTFMdlJ3M0dWRjNDUGpVaUV2ekdvR3ZuaU5tcEd0WTFYV1RC?=
 =?utf-8?B?K3JLekdrU1ZvaHR1NWdHZEdTQ0tUOWQrMjZ5SnlHSFhYZGdDbzNJZ08vaSs1?=
 =?utf-8?B?M3Q1YU91YmxFV2U5UE13VzRQaCtzOVB1VDAwZnFtMUoyUEJsYXlQaE5NVmpz?=
 =?utf-8?B?M3N6VzRaTTlSZFo3V1N4cVkyZ1pLcHdLYmw3NW9leCtlRzRkTDk0Z0pxVjFC?=
 =?utf-8?B?UmFXN2V6NWpObXREU1ViZWtXSnYrTFcvVGR6YWowRnp4VHAvbTJmZU1Odk50?=
 =?utf-8?B?Q3RwQTZFWlljKzk3YXdHNmt2cGJQN2xLUzhOQ2dNaVNTemFRRnNEbnZjMmlV?=
 =?utf-8?B?SkkrYURKSHRlR0Z1ZlhMcGVQeXV0QjIwbmh0L0VEcGpHWC9CbDhJNDEwUkJ0?=
 =?utf-8?B?d2xuazVoZTZMNjBEYWU0NzE0WTlTdkx3bXl4Y2MxUllsakNKelFmb01EUDNO?=
 =?utf-8?B?NnRKVS9JNno0YUNSeEVvRWNQV05rbFZJMEtydE9uRitnL01RUkFaRUZpWTl5?=
 =?utf-8?B?OG4za1RYWXo0NEZ4VzhrNm5JNmZxb1NvWUZDKy9nWGxmR2JjOVZZQzNJWGtq?=
 =?utf-8?B?cWxRaERlYk1OQWw3eE5rbnYvNlJlWS95SjRHQjFyTTQ0QUVRbEF1RGJTYlZp?=
 =?utf-8?B?SXpJaTF5WGpXRXJPYXVGcmt2dmNzYmVCOUJvUHZ6RWM0MTVCeWw3b2lvU2xN?=
 =?utf-8?B?Z0tBOEt1N0lNeVhNMURHYldKLzNHVDAxbE1GQlEyQjZHWUxseUl0QWs5TFlV?=
 =?utf-8?B?ekM2dFExNFdieU00ZnRIQU9rdDhnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a001420-f535-4e0a-ea5b-08da0289aace
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 11:32:32.8152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3aJENfoKyFLTh0VV53/CTp/oOYn+ZrP1YehQPhI8Cl4KZSGpUOXlHR2oNXnxBnuvjI3Jzc4Dl4gC43A/IDHj0BM6hQM92WyT4HYsP/nL8NE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2379
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203100061
X-Proofpoint-ORIG-GUID: tZUmHMY08keoIB87BEgBYPMm3IMCFA2j
X-Proofpoint-GUID: tZUmHMY08keoIB87BEgBYPMm3IMCFA2j

On 3/10/22 10:32, Mike Rapoport wrote:
> Hi,
> 
> On Mon, Mar 07, 2022 at 12:24:55PM +0000, Joao Martins wrote:
>> In preparation for device-dax for using hugetlbfs compound page tail
>> deduplication technique, move the comment block explanation into a
>> common place in Documentation/vm.
>>
>> Cc: Muchun Song <songmuchun@bytedance.com>
>> Cc: Mike Kravetz <mike.kravetz@oracle.com>
>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
>> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  Documentation/vm/index.rst         |   1 +
>>  Documentation/vm/vmemmap_dedup.rst | 173 +++++++++++++++++++++++++++++
> 
> Sorry for jumping late.
> 
> Please consider moving this into Documentation/vm/memory-model.rst along
> with the documentation added in the next patch
> 
Hmmm, I don't think this is the right place to put it.

We don't change the memory model fundamentally (rather the *backing* pages of
vmemmap VA in some specific cases) to justify putting the entire thing there.
The new doc is also just as big as memory-model.rst doc. I feel the two separate
docs stand on their own and the vmemmap dedup technique doc is better placed as
its own.

Perhaps alternatively (in a followup patch) it could get a relevant mention
(either in an new subsection or in paragraphs of the existing subsections)
in memory-model.rst to point readers to vmemmap_dedup.rst...?
