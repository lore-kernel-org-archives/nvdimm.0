Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB5A70
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 01:11:36 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D1AXos028293;
	Tue, 13 Jul 2021 01:11:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=k6yEZ5Kep+EUHox6d0OkhKv495Knm2W8TnGgRp4zlZ8=;
 b=Cc0VzbNzgCDXN0oqu9GLxgMkwzAUxOeRH5SmCCVxaPKUKM1A4sJ1wye+QCu5sFkP5mE6
 BaDr08AjjutOz+bqHkhqT3YtCFjznjpJePJL4GBXMT424QOrJ8qhXpAPqRanePn3oJtI
 31v3sjfPQpSkcnBNUVWqNpx+TJx0HcQBv063FtRKPJOXAfnkdAi22VQCSQp3dbCtkAt+
 iwynRappBauwej2jMINAZAR39cwZO/rOBxqWSBK8KuvKzucXMGvSm3LkQru5ZssQd72g
 rCH/M0XGXKYTRxUjzvZJ+yBQG2BSF1FYVxgrccYYSqiSjLEzF/Ft3jwFz8FiXsTyJW2F Qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 39rqm0s6ej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 01:11:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16D14qTH139810;
	Tue, 13 Jul 2021 01:11:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
	by aserp3030.oracle.com with ESMTP id 39qyctkcpa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 01:11:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqV9adgb5Aym74SnDHhATj7dwZZUYrhGOuI04d/GgSLb6Fx8KKEPqaOdNzojzx2tCUokgbn6Stn3yjxFYzbxNQo/LPbMt04oNQS0csrP02TjQ0nQHTMb67yqFoTe/z6lhGSZAcC0PmG1TUCdAQYCOqLEp4APyqgGgragQipCuhE/3Fhf5RhTPHdX8+K3Ed4Mlw9kkSUORk7tk0Hztoa4pfjAPbDCtGgXUksRbeZ2YCCfu+VegAf1oO1aFHLK9sRI646UCYxwf1ltG5qQgtGvhwFbMm6972MXyWjMwiT3Whr1YJLbi8LB/Ob7DbB7l5zsdmz5AxQiDtkziWYXxiNmYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6yEZ5Kep+EUHox6d0OkhKv495Knm2W8TnGgRp4zlZ8=;
 b=OwB3pDPW9CAXiyWs071UEUv+ifndgnoB97tJHbkq241alZe1lK+pQu7HXzhxq5gfL8F6anvOArhcKUbBU5hvtUlmcKkD4MJLzhGH77lJEfXnkHxxOYFbl0PhoV/d4FziQzyhPBHMCq93N2fsl6hTZSkHTH7BxJ/LcQ1QRM5K8Xv4NoaWDmFQI/ycH2Qd/pe4sZbTnB0lhAng/i0g/a7lj0l+mhob+wnVRD48ym4a+WYv7kGgt4pCtOJ489kDwUcx4cgiLNB8Qdm6eUcN7d6R9iJ9yac9CNAFMkdbxPYKWhYP02GXxClxp3RmI3kGtU0mwIKf/54LrbVaJy1d3VnesA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6yEZ5Kep+EUHox6d0OkhKv495Knm2W8TnGgRp4zlZ8=;
 b=WOWTGlXyOfIDoAcPKLLkBOUj7eM8NObY+ngftZvOdguRdeD6QNXe4oX55sAY8XD7fR57Dwax7gvYMreF6aG/drb0aD4fnHr6NlSQ/tHwCUtRveAX3lAIhj2Fefs+q8zghd+bx1posZbnqECi+GFEpAlZTbqkhwW9JT+7wHboH6k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4013.namprd10.prod.outlook.com (2603:10b6:208:185::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Tue, 13 Jul
 2021 01:11:17 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 01:11:17 +0000
Subject: Re: [External] [PATCH v2 07/14] mm/hugetlb_vmemmap: move comment
 block to Documentation/vm
To: Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20210617184507.3662-1-joao.m.martins@oracle.com>
 <20210617184507.3662-8-joao.m.martins@oracle.com>
 <CAMZfGtXSJE2ZsSOBW7Ef0VtP=+Q=cULSw9urqZGSG_WbGTiaSA@mail.gmail.com>
 <7f7313c6-f101-1726-f049-61091567f9c3@oracle.com>
 <dacf10bd-f221-9339-a025-723943dddea6@oracle.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <f320eb05-3516-94b6-f1ee-7f25076a9341@oracle.com>
Date: Tue, 13 Jul 2021 02:11:11 +0100
In-Reply-To: <dacf10bd-f221-9339-a025-723943dddea6@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0018.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::23) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO3P265CA0018.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:bb::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 01:11:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e21bc126-388b-4718-4d36-08d9459b1dc9
X-MS-TrafficTypeDiagnostic: MN2PR10MB4013:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB4013E7AE523CF83E98551297BB149@MN2PR10MB4013.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	hezjOicFKUTGkTS56T13DkCYeVuH4EUv6i8SIiS93sHtJ+PIkUEGpS6qKqN8y9C4aasC7C+SIOFoUCetaOmTkQiUol9WWYSOuGZEPyw69hP1EVdTRA9t/N39GJ+i8rZoHU6GkJzPpwQ1LO98L1OocLffRat4/yQguMxDswmbg0gYqApPgfrYLkRHI2ciWElF+bmTsVFwLxl4hGEZJlMCFu8l4NHqhBNhUjAUuXIqGfuom2CWdLaIdl+4iY8i1UtN9Prk+1egY23c3VvUFmvfnfRJFJ2WMr75vtxOMCHfhoQyfjG0MslWVUsbrTYcxwM2qtUbgDu2JDKEjAltMldGdrlbffgtkfei49eX42/uO8rY8oHJ9xkHEKeh4OqMu0KsCpu69yETR19Psv1TKO9CwwbricGZL0DrRwU/87zOOwMowLx4sFDHyPLxjWFREJ4I6EMxgmsY0QS+gaP+7O2rWObTn7w2MXjZXPOngxRo3/AXtiX0yGKusfxczN9t3tCJlI6X4hCZWbQj/7YIRABO8WWkunW5DTJn/A6bIZG2hFeJgSAO0FT9lY6/WmndX+zpGRFFb2OafVZI5ks/piI/5FIuLpL/Reh/3eoef1B8QBI6InI3o6kw/eTJ9/Cq/MCrptR68QVNfGH3vqEZ88K9cbDUQ+7iqGlScwrv6QcOCYdlUl9n8lhrpAjPci3EMm1Prr9B9ED5Kj7O3zKAQwL7aw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(376002)(346002)(396003)(83380400001)(31686004)(110136005)(8936002)(66476007)(66556008)(38100700002)(6486002)(2616005)(36756003)(66946007)(956004)(8676002)(4326008)(54906003)(478600001)(53546011)(26005)(186003)(16576012)(316002)(7416002)(31696002)(2906002)(6666004)(86362001)(5660300002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UVFjb05qOGVzbS9sdjhLY0d3aGZYSjIrOTJiVFFqRUU5dUlmTW85TGpXci9I?=
 =?utf-8?B?T0JuUjRRMFF3SGs3bURYU0UvYTlhcG1XSTNRSnFueWJUc1lwTWF5Z1pSSXVL?=
 =?utf-8?B?N1ozVUpDcWVrWHR2V2x1WElnRW4wYkQ4LzFaVTV3bWQ2b2traUtPdXVoM3dQ?=
 =?utf-8?B?TjdETnNNUllCc1psOWZQVEIvOGZWc21MNWczOEJrdSs0ZHJaWHhsa3g5RlJZ?=
 =?utf-8?B?NHdyOXpNZU9UY0taTTFaR3kyY1pod1gvWkJ1L21pdFE4SVhxckpLLzBYOHBE?=
 =?utf-8?B?b3ZOODJVL3JEZHRSMGp5M1hnVnplNHhJelp2alpOeW5NVmowbUJrQlBRS3ZU?=
 =?utf-8?B?NjNBYXdBVCtCZmlGU0JZaUgzeG1iaG5MTkxTT3Z5aEJDc3lvN2hVNDlrTHZk?=
 =?utf-8?B?RExYMGtGam84ZDI3ZldENEI5bUh4cG42aFJKYXdPc0FsOEhmQmFaRVZxQkNL?=
 =?utf-8?B?RGFacmxQRVhqMjZTK3dDU0VMeGZuOW02bERoNGdZcDE5eVZ4UjZoeG9QRlNY?=
 =?utf-8?B?NUU2WCtMM0V1MWVpT0RnVHNaNFVXL3pSTEYzUnkvSkt3Q2Fjb2ZvQy91d3Rq?=
 =?utf-8?B?dE1rQTRzZE5ZRmFUSWc2ajVveU9qZkliK0RBTGV3VnhMbkxBaUhBSnk2cGxq?=
 =?utf-8?B?QVRCZUpMekNMV05zMXdxalhKd25BVWxuVEQ3UW5Ydm5pTWRHODNYNVFlVFBO?=
 =?utf-8?B?YlFPNlIwYzlqd2ZqazdQWTQ2aVlGcmE4aG1wYzgwWTc4QjNQaTBvUHBJait6?=
 =?utf-8?B?QXRIVVlCdXpTZ21PazVQZTBQTVZMMXRqSEk1QjBSdDlIajA1NFJNcHBSUXA4?=
 =?utf-8?B?QVdtTCsxcTF2aWxiZFJPMWxYeTlqOHhwYjBhbm1VNkdBbE13eURmMWdqQVJR?=
 =?utf-8?B?aWhQZTNLc1J6ODJNeVJ2RnE5bS9RMEVhdHdIREw2cENhVjFKaXR6TmIzZUVE?=
 =?utf-8?B?aUQ2UEZlL0c1R2IrQUNhcGtjdjRQRDM1NGJIbUJVaTZCb3FwOVBZRmZXa0Rp?=
 =?utf-8?B?SDlEcVFUbVNnMURCR1oyYTdIeTNucGxkTjNLR1hrM2VIV2JhRnRLck9Gb1ZF?=
 =?utf-8?B?SUhUUDJrOTVNdVhnZHExYVRHaFdkNDJFdXd3OExyZHhnOGRiNUx0WEpCMmFF?=
 =?utf-8?B?dzRwT1lwNTlHYnNzN3dwM250VldDWURaN2Jqb3Btb3JKMEZoYjJjTitKdmZi?=
 =?utf-8?B?b3JEd2syazJFZjJvVDZOSHZhWFAzT2JrMjZlT0gvQWcwbjRJRHlFMjg2K0FT?=
 =?utf-8?B?OHlEWkRqNXI2TENHL3dIYlZkL2JrU3RIMHZZNm92UGd6czB6RWlQUjk1QmdD?=
 =?utf-8?B?aFI0emxmcDN4M1hIR2V2TU1BKzFjVHE0TmNUKzFtcThUemZmYUt1RU9rODlZ?=
 =?utf-8?B?UFVBTjFlb2g3QnpxV2lDL3J6dnRBbnJyemdiT3ZSRGI0OU0yOWV1NEhKRkF2?=
 =?utf-8?B?c2xjNXh3MkYvL3d6bElxVzV6b0VEYkpwUzZOVkdvTThDcHpZQUZoUUFhZi8y?=
 =?utf-8?B?cG1VVUY3UUFNRi8yTTFvNm83aXluelRtd1Niazkvc3NhMURPRkdSck5OaDQ1?=
 =?utf-8?B?NDQ4YUY4WmZSSFlmYzZReUUvT1hmNmMyRXlmQkZ2WGVPekYvT2wvcFhLblRS?=
 =?utf-8?B?bjRDbnBNRGdRU0VLdzRIQUZaTHoxaVhNWGR4Z0I1aDZJSWRkaVVYZk41ZXcz?=
 =?utf-8?B?dEJWUDQvSEJHcWRhRys4QUZsc0hEUFZyQ1dnRDBHZjdqTjRNUmIxd3dhQWFu?=
 =?utf-8?Q?/41xScUE5CGLUQq80fvFKE6aU2/Fyf5pssKkFRU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e21bc126-388b-4718-4d36-08d9459b1dc9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 01:11:17.2849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rvnJR/Thle+oal5g3jn/5m7ud/AAtLjrfCxRe2bgdjLVa1OexT5qeC2Gmrk8077LwD+6XRYyL0VbTvKgOfodioWkbMWqjqKl6MvyKch4sm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4013
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130005
X-Proofpoint-GUID: kvJvc_FYEy3cVx98F8kBGhLG0v3R_ooX
X-Proofpoint-ORIG-GUID: kvJvc_FYEy3cVx98F8kBGhLG0v3R_ooX



On 7/13/21 1:14 AM, Mike Kravetz wrote:
> On 6/21/21 6:42 AM, Joao Martins wrote:
>> On 6/21/21 2:12 PM, Muchun Song wrote:
>>> On Fri, Jun 18, 2021 at 2:46 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>>
>>>> In preparation for device-dax for using hugetlbfs compound page tail
>>>> deduplication technique, move the comment block explanation into a
>>>> common place in Documentation/vm.
>>>>
>>>> Cc: Muchun Song <songmuchun@bytedance.com>
>>>> Cc: Mike Kravetz <mike.kravetz@oracle.com>
>>>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>>> ---
>>>>  Documentation/vm/compound_pagemaps.rst | 170 +++++++++++++++++++++++++
>>>>  Documentation/vm/index.rst             |   1 +
>>>>  mm/hugetlb_vmemmap.c                   | 162 +----------------------
>>>>  3 files changed, 172 insertions(+), 161 deletions(-)
>>>>  create mode 100644 Documentation/vm/compound_pagemaps.rst
>>>
>>> IMHO, how about the name of vmemmap_remap.rst? page_frags.rst seems
>>> to tell people it's about the page mapping not its vmemmap mapping.
>>>
>>
>> Good point.
>>
>> FWIW, I wanted to avoid the use of the word 'remap' solely because that might be
>> implementation specific e.g. hugetlbfs remaps struct pages, whereas device-dax will
>> populate struct pages already with the tail dedup.
>>
>> Me using 'compound_pagemaps' was short of 'compound struct page map' or 'compound vmemmap'.
>>
>> Maybe one other alternative is 'tail_dedup.rst' or 'metadata_dedup.rst' ? That's probably
>> more generic to what really is being done.
>>
>> Regardless, I am also good with 'vmemmap_remap.rst' if that's what folks prefer.
>>
> 
> How about vmemmap_dedup?
> 
Sounds good to me, I'll rename it.

> I do think it is a good idea to move this to a common documentation file
> if Device DAX is going to use the same technique.
> 
