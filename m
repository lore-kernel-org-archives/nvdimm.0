Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D9970
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 10:48:22 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SAkg1n032075;
	Wed, 28 Jul 2021 10:48:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=WOUKCnVy4Hiv/Yjr+KSJJglRQ/YXFinXigVrptJQRYo=;
 b=aJAcRoM7tX1m9OweQgslaxT80wwnuiQc+IO53VkxAPDTS0j9UkKUbstLPFO73uuzc2Eq
 Ker3LDmYp2D/4lyqYY+qJPhnBgrwO/OeIm6WRuKbNr66AX8F9zPi+35v7dDgC/M7t8bB
 WrbO812TH/huF1Iag0fq4k24PepIv870vUE0Pat24xAYLVnB2URGhhtYiYb3uRHqNMCj
 SrpzNY+t5A1VVFlG+wFutwd+mqBmGrlnr0Ppk7L9XN5E8bo/zyshfcqbwjliS19dpof5
 sdu+P4Q9NuIuymM3304atgyR3G2tEMtPiGSHLdvSHg9EDpYIEI9jRqcDdOwUBkdD/ryO fw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=WOUKCnVy4Hiv/Yjr+KSJJglRQ/YXFinXigVrptJQRYo=;
 b=pg1Rm7xeHwJ3nrvjtMM7mfzAZbw1uiQMYsg9oCqCNuhDiGfc1bvkvJfDMh8RAkp7k81z
 p4pul3OjS+xNvu1ZhXibjWShivWz0bTDfc5tKNNon7uxoaiOMEiDf+USIbJAcVrMY9s6
 YM73qeXhT8c05qGhzl1JZz9EZAz0K7mOGz3sHZBuxDoeOeTVqTG7fAdYbZqURzQuUAi6
 zVZc8tp2LF6B5diibQcsvGKF/w1DDGNGB/4nYnPaRpQtpfBpF8XzIRK/nXHRcLvxF9E8
 oRrxcSMUZJGZAZU3zcIa4NsXSuCkAVaLjFilkoUIUkOKukOA3mr3UW2i7S04EWaJwx+l 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a2jkfadt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 10:48:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16SAjjns062857;
	Wed, 28 Jul 2021 10:48:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by aserp3030.oracle.com with ESMTP id 3a234c5sqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 10:48:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvm4tC7hOUFoc/Aweq5cZ1GbwkoRJ9uWSFdCGE7wIb/v/rptyCbOwCKd6Dg1dFLuff243uZ6lu4yLoEjna9i6zRbQmGSaWUOg8+YpLCm9PoQeYAz3OP+udk7TygVz8hg2sIw9bw4yAALcFilLw482Me42LRzojW7AkFo7WLC+wMlunBkMrQ4fdacUKB053HmdB7J8ky9x3JZbJizm2XTGix7juyaZlreOIm8HJca5nebyxqSV5La3Mh3H9iCjeiswdcQJn6NmhFRDARhs4RsWS1wOWHWEjQ6ywWvDrMLxBuWrFgNUAKIDgmvsp5iefnlNO5gU70FLoxMhZ2Tpk67vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOUKCnVy4Hiv/Yjr+KSJJglRQ/YXFinXigVrptJQRYo=;
 b=HF4Roj4WcSR6vSTmzlULazI2pbOJiM7dWAXepKyrBP/0ZvU02r4eid8VjXhrO5F9NDzWlydznugb/Qnm7jkhdLMVOZiU0JdiWgrMlc7Sbx1rvMLoOchdhxvkyRT0UUjUbiqlmaz4g4cDHsiYtHxc1PsPoa+HDd4j3jjYItcPP2SC12Zq9SfhIldxYlldfedRnhz8LWZ14lyPzOfxBL9VKPM0SesJkmVK0G/0gGj2IJZxyZXyvFkEc2cBFcM6MW3fHZIMI6Hsxc9rPpHzkFPUDhCQwI2XiZQuupc5MWpyAzl7cVfxChfmxjDGBHBDgyhYvemap6k4V8RhEkaFrKpU1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOUKCnVy4Hiv/Yjr+KSJJglRQ/YXFinXigVrptJQRYo=;
 b=uZ8/8LzK1GArP/cJMpRGBlITQZjtOwG24d+T5W905UO64SzrVljxEW/3FObc+IEirrSsn49Z8Qu2orEeJ5yCJZIbF6IljXtL27XkdXBnCnBtHzpVyQpjN055yU+fdCo8XVcU1yTCZzcW5GK+m7I7LJwnwHzdTlwAgAA1rxZPNEY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3981.namprd10.prod.outlook.com (2603:10b6:208:183::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 10:48:12 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 10:48:12 +0000
Subject: Re: [PATCH v3 06/14] mm/sparse-vmemmap: refactor core of
 vmemmap_populate_basepages() to helper
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
 <20210714193542.21857-7-joao.m.martins@oracle.com>
 <CAPcyv4j=gqdkj-hT1dD5jyndG=P9DogUH7Ptr-aDeAk7uacpCQ@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <81b0d198-a467-98fa-e497-b5e6a28e43f9@oracle.com>
Date: Wed, 28 Jul 2021 11:48:05 +0100
In-Reply-To: <CAPcyv4j=gqdkj-hT1dD5jyndG=P9DogUH7Ptr-aDeAk7uacpCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0064.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::15) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0064.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:153::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 10:48:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29a842e4-cb7a-4131-030a-08d951b531f9
X-MS-TrafficTypeDiagnostic: MN2PR10MB3981:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB39811C75D3D05D303ECD62D2BBEA9@MN2PR10MB3981.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	6wbU+iII2sqBIjIjBmxEnee35nWBukYdCyqDS8EVW1qTCDvuTMEHcI1b4WWZsxo1eR9r5F+Wk9ONxVddlGYClRNcbGckgmzd0fUdG64bu4eBcuuEMWxAGSZ9ECABpb0DeLBMWaYJk3FTbqPlBZBrn2IpxKfqo88ylpgjBs58GNlA6r0w0HsI+EVLLlYAT7jchWTA0qyRP72obj/4ufJHgpuX174D+tfqavqcj1rVbEl4SaPVH1LaNh/HcBO7v3+Fs9laravfHC5zXwom0B0SSadkSw2xNAIrHJi3dY3YWTSBrjIiXNo0OFdPsXOl1BABAC31b3dyqtarEOt+gT3OPvgLPCJkmTvqyIBUnqGA/csB6jVVGE14JE3bmekXSCh2oHOfgptrBhfbsfMKdqsWFF37VYQG/S5zhfIQCryxHoOQ2Oo0rmNTpaH5sCoAmgaMotitmUaL28TY88HC5J2PyNhU5OXQNzoebCMuxfsVUK4Ua080mvPuVv3/w6fmw0BV2uOeIIUc4NZDyVJUeLeOkQLsy/SEqlzQJkp7g53gORQeGGCWL9pw72Swm7I9300SEbF4LPmtqssmiJ5ZrGHw1Vo8UlfFYV6j8o/RcctkDyBgWxQM7N9ZOUMkHuQoRKaQkKUC3xxn3rxbpBzH7a0o6/HWnJTE6+1Kuq2TqNOdT31mspTxJnvJRemjrZOq1Nn82wstKZGtnHGvnxLsSaMMpQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(366004)(39860400002)(8676002)(66946007)(83380400001)(316002)(86362001)(54906003)(66556008)(6666004)(2906002)(6916009)(186003)(66476007)(26005)(478600001)(16576012)(31686004)(7416002)(956004)(53546011)(2616005)(31696002)(6486002)(38100700002)(5660300002)(8936002)(4326008)(36756003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VEl1ZThmY0I0MTcrQ25ieTdFSys1QUY1VFhuZ0QzZmNlQU02NjBjbEN4R3lL?=
 =?utf-8?B?Mld3blJvTE1YbEN0OFpDV3lxSlhub2VZd05vTTMvL1pMMUczenJJeVlRelkr?=
 =?utf-8?B?cVYvY3puK21nZmYwbEVlVzc2cDVoTmxDYUVsQTFnU3pDeHhRYVdBZ2VOUGZr?=
 =?utf-8?B?c3kzWklDZDBmNzdBN1JlRTdHczFSTThIZnA5QU1WZnRKR01VR00wOTl2TmJL?=
 =?utf-8?B?Y1E2U3VIZnZmb0o5UE1JRm5kZUVZZ25meUoxQ09kdFJRTExwbzBLTzVmNm1T?=
 =?utf-8?B?K0JYaU9WQThZdjRCa01VNUpYT1NRdFR6UzZuUmJvYlM4b3BGSzI1dGEzamx1?=
 =?utf-8?B?T1ZtZ2tndlBqMlhZWmhIMEgwWFVDOG5xNXA3Z0VQWGtCK3kxbk9leWlIYTlJ?=
 =?utf-8?B?Q2NuZUdWWGpFeGtMVnpYczl1am9OaEFLZHFCN2paTVYwZEYzZ0ozeFhmZjJl?=
 =?utf-8?B?UCs1WkZqRjVKRGtlM2hGWjc0Z3I1c2FDZW1KRlFhUjhONEpnVVRJYUJEL0pL?=
 =?utf-8?B?bTZEUW0rY2RrbnBIaUZoSjBXVFVEUXUvUDlJSndjTEF1QnJOMmk2NUxnYkRm?=
 =?utf-8?B?SkRUdTh6LzdIVi93Y0NJYTJOR1pBbFVaQ3IrNUxEMFU1bm54T0NJSkpsbHdy?=
 =?utf-8?B?TEFDWENhOERiNFpHemtKWloxdzdVa0ZUYjlVZjhEallDeExnaTc1RUd5S3ZQ?=
 =?utf-8?B?bERCdU4waFpxbmtURWNhZjl1WkM3U3J2aXJsOUNDM0dzcTJqeVA5a3BJWTlX?=
 =?utf-8?B?RVpudmFQRDlyTW1GTWErMmh5My94YlZ3c0ZzRDZxUzdUR1Y4RkhUNEtScDM1?=
 =?utf-8?B?b0VVb2U5SW02WlFSZzNzNnJscXVLcTZaQ2dZSVhoelV2Q3d4TDNCenNYYUw1?=
 =?utf-8?B?d1NZZGE4OUtuM2VUc2FOTTdhVVJhTUpiblptYVIraUdBRlRQbkRmUzg0cmVq?=
 =?utf-8?B?cEpVWm96UGozVWk4UzBvcHdSQWlDUEtUbmVNTURwOTdOd1VhYThWazBZbmRk?=
 =?utf-8?B?WWdLazVwdi96WllScEZvSXlHa24xS21ycHdjYmdxeUFRZFordXJGcFpyRXdP?=
 =?utf-8?B?TjNRUTBwMXZSbmdRY3F3TS9BbTdLcXFPaXIwYnFqTzlKTU10Q1RIajh1OE4v?=
 =?utf-8?B?ZnVCN1dubTBZSXl3SWhaMThrZ05IdGMrclNxLzM5bitQL0U0S0NreTh1ajZB?=
 =?utf-8?B?b0x0cldZV3BsekxINlpsdEZkN21kbFltNDV5T3E5WVIvZDUyRmg2eHpIUkNB?=
 =?utf-8?B?T2Z0UjRuenpxZUhZSnlRYi9MOTBMN3NrZkEvUlQ4SVVKSmNmM2lnalJwTXR3?=
 =?utf-8?B?ai9iTDMrb3l6RkdramQrdHYvaElVQ0dSL1pVM3lvZzgrK2NqQ1I4RktteXJG?=
 =?utf-8?B?aWIrOFUvb09rMGp1b0syQUp4U0FSRWpVR1pPTTViby9DdENsbVp1TlU3VGly?=
 =?utf-8?B?Y2taRDNSTzJRamMyVzV5QytPU0JpanU5emJZTWF0bUNEZGhLb3I1ek51YStq?=
 =?utf-8?B?SXlqaHYvNUg1OTFxcU9NMkRLSk5vVkdvSHQyN1AwS08welRIa0EzOUZhRFFh?=
 =?utf-8?B?UXFUZmlxUGhIVG43cTZrd3dPSmVGL0QwRzc4UERtTUNaVyt2SmR2VS9FMFN4?=
 =?utf-8?B?czd5Mm1HU3cyUUcvbzdJMXhCTDJoTk43cGZSWUIvZVpwZUd0cDQxQ3ZvQzY2?=
 =?utf-8?B?eWlxN3F1NnNsOC9VS25NVHY4ZmtFNDAwbE5GU3V0OHV1OHJGTEdLWFFxQ2NK?=
 =?utf-8?Q?zRpfvH49KnX05dI6Jf1As46wA3euBmVU850IIvi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a842e4-cb7a-4131-030a-08d951b531f9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 10:48:12.0611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +N1VbZjqFFHGvsoC0l7ykaLLLGf+Ohj+NiVBPkSzbbk4UVWOkKqwQgnio2WVJK5dRS5w5ay8c2nkhQNyQvCqyoN7XWhJlmJldke1vr66Ttw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3981
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280060
X-Proofpoint-GUID: D6wkBvV6MlvK3ZnQCR2PVujhGewa8fqd
X-Proofpoint-ORIG-GUID: D6wkBvV6MlvK3ZnQCR2PVujhGewa8fqd



On 7/28/21 7:04 AM, Dan Williams wrote:
> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> In preparation for describing a memmap with compound pages, move the
>> actual pte population logic into a separate function
>> vmemmap_populate_address() and have vmemmap_populate_basepages() walk
>> through all base pages it needs to populate.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  mm/sparse-vmemmap.c | 44 ++++++++++++++++++++++++++------------------
>>  1 file changed, 26 insertions(+), 18 deletions(-)
>>
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 80d3ba30d345..76f4158f6301 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -570,33 +570,41 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>>         return pgd;
>>  }
>>
>> -int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
>> -                                        int node, struct vmem_altmap *altmap)
>> +static int __meminit vmemmap_populate_address(unsigned long addr, int node,
>> +                                             struct vmem_altmap *altmap)
>>  {
>> -       unsigned long addr = start;
>>         pgd_t *pgd;
>>         p4d_t *p4d;
>>         pud_t *pud;
>>         pmd_t *pmd;
>>         pte_t *pte;
>>
>> +       pgd = vmemmap_pgd_populate(addr, node);
>> +       if (!pgd)
>> +               return -ENOMEM;
>> +       p4d = vmemmap_p4d_populate(pgd, addr, node);
>> +       if (!p4d)
>> +               return -ENOMEM;
>> +       pud = vmemmap_pud_populate(p4d, addr, node);
>> +       if (!pud)
>> +               return -ENOMEM;
>> +       pmd = vmemmap_pmd_populate(pud, addr, node);
>> +       if (!pmd)
>> +               return -ENOMEM;
>> +       pte = vmemmap_pte_populate(pmd, addr, node, altmap);
>> +       if (!pte)
>> +               return -ENOMEM;
>> +       vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
> 
> Missing a return here:
> 
> mm/sparse-vmemmap.c:598:1: error: control reaches end of non-void
> function [-Werror=return-type]
> 
> Yes, it's fixed up in a later patch 

That fixup definitely needs to be moved here.

>, but might as well not leave the
> bisect breakage lying around, and the kbuild robot would gripe about
> this eventually as well.
> 
Yeap. Fixed, thanks for noticing.

> 
>> +}
>> +
>> +int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
>> +                                        int node, struct vmem_altmap *altmap)
>> +{
>> +       unsigned long addr = start;
>> +
>>         for (; addr < end; addr += PAGE_SIZE) {
>> -               pgd = vmemmap_pgd_populate(addr, node);
>> -               if (!pgd)
>> -                       return -ENOMEM;
>> -               p4d = vmemmap_p4d_populate(pgd, addr, node);
>> -               if (!p4d)
>> -                       return -ENOMEM;
>> -               pud = vmemmap_pud_populate(p4d, addr, node);
>> -               if (!pud)
>> -                       return -ENOMEM;
>> -               pmd = vmemmap_pmd_populate(pud, addr, node);
>> -               if (!pmd)
>> -                       return -ENOMEM;
>> -               pte = vmemmap_pte_populate(pmd, addr, node, altmap);
>> -               if (!pte)
>> +               if (vmemmap_populate_address(addr, node, altmap))
>>                         return -ENOMEM;
> 
> I'd prefer:
> 
> rc = vmemmap_populate_address(addr, node, altmap);
> if (rc)
>     return rc;
> 
> ...in case future refactoring adds different error codes to pass up.
> 
Fixed.
