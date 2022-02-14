Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07DA7C
	for <nvdimm@lists.linux.dev>; Mon, 14 Feb 2022 10:57:39 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EAeO2P017063;
	Mon, 14 Feb 2022 10:57:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/KDCLuRsDu4KUB5iioFpPsQPOPNWBkDRg2Is3ExFK3w=;
 b=TuEGZ7ifvKae52UvQrS+sCsDtyp49tH8aG4+79UoDYvOZezjyQp+KLcpctZW8mjEfg5X
 v+11vk5LLiXgTkKRQFBznXLqdMy9MwpI9Hmnc0xDvaW2hiHRh8BzShfgnLvbacTYEqSg
 bJnmbZ6fOiclZ92dw4RG8Iug0mhV0Pqovj/abSlPKr5rTkjtdJ23F61t4woxb8Q/qMi9
 RniWXc58h6hi1ivl0yc7OZsphUdvFgZYRQlvIwL0uxNhmdAlaloX8oLVBJiBT3g+Z6aY
 qiHAEVgjekinvs8Jo6a+kxtYzqCSIQzLOJrsDZrzjki0rfhxgP6/T8PX6y/mcvuKMxVv /A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e64gt43ry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Feb 2022 10:57:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21EAu1NG049023;
	Mon, 14 Feb 2022 10:57:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by aserp3020.oracle.com with ESMTP id 3e6qkwfqpt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Feb 2022 10:57:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8fXL668PMlReFEz3m19S5AXU0q/HhCq+X/BFnwz4OP3SPJRci8ebVABq3jZXhlniwxDwmzLrOKFxr24JvMjPTrgtW8ZufqDZ6GjI6MoIA61cTv7R6U0e8jxkr5yh9Zg1aJhYC4qEZd1V5d42koriq23jWwTghrtAHN4PNIS5ZBFZRaKHeFj8lHVXrlvPr2tCo0M83hmmrbZw3du9e2QgVTxwQXxtCb6dsEd/xvVdmTZknlDjiACUf5b06Xq0HXRYnM0iFzNDHjU6O62giphDb7py78MEQMBDx4VgSroDXNSXI/qi7GZ4p7lJUOppizzBzzDXpVoln+uBWPhmGnxgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/KDCLuRsDu4KUB5iioFpPsQPOPNWBkDRg2Is3ExFK3w=;
 b=Bknv8uWeo3+JvN+cLz13Ol8vR6wBk7E58U8w3V89qBxZsOrZPnv+38kTgrbUnv5rQz3A8uzU1EWEMxgDxJbfCZkgR0IN6PUFgWKsteK170KDw76xZ1Q2Y7AObMn41fqBcrSEUgbOw/KRzaaJmEd9OsIO8guDmjs0UJ8GMmOW67JctPFO0ztjfJ7FCsG4R/9Ihvj1OISAjFD4GWSMTXC9KbMpzwVVPM8NfIbufDE7Wa40NN5L4mYyqEv8QC9+PpkFxGMT/jTwTAeXOrvxrM3b+INI/MMi9Ev9WHmvEmUJ0eEsLE8YxZq1mqgGhEQ4JaioEhPSteFaG4q1WsK4TCkKrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/KDCLuRsDu4KUB5iioFpPsQPOPNWBkDRg2Is3ExFK3w=;
 b=yvEx6uppRiQeshmhaa+siZ/6F1oQuAmFJVIkAtT6kMi0YCAbaTreVBb/lztJS0ffQo59Vl+uUg3Zcuws9krPpWXowgEY2PEee/ibugXHJVMLjj73nzoHJGqagqL1Jj+TJac4/IYUs+vOWFIv6fPSTUknwAX76dKoj6s4p+nWoyM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CY4PR10MB1560.namprd10.prod.outlook.com (2603:10b6:903:2d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Mon, 14 Feb
 2022 10:57:22 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 10:57:22 +0000
Message-ID: <23cd2843-9494-c129-4038-b23a16ecb0a9@oracle.com>
Date: Mon, 14 Feb 2022 10:57:15 +0000
Subject: Re: [PATCH v5 4/5] mm/sparse-vmemmap: improve memory savings for
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
 <20220210193345.23628-5-joao.m.martins@oracle.com>
 <CAMZfGtUEaFg=CGLRJomyumsZzcyn8O0JE1+De2Vd3a5remcH6w@mail.gmail.com>
 <d258c471-1291-e0c7-f1b3-a495b4d40bb9@oracle.com>
 <CAMZfGtWUHRRfowwPf1o-SycKZMDzMdeGdahaR2OEJZzLhLioNg@mail.gmail.com>
 <CAMZfGtUSxtnrY3Vkn8gP2T2jUjWdfVXu7+zt5Ny4VBi7ZDkWAg@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAMZfGtUSxtnrY3Vkn8gP2T2jUjWdfVXu7+zt5Ny4VBi7ZDkWAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0011.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d85fad4-eaf1-4b70-b3e9-08d9efa8c6c1
X-MS-TrafficTypeDiagnostic: CY4PR10MB1560:EE_
X-Microsoft-Antispam-PRVS: 
	<CY4PR10MB1560DFD48B6866954142492EBB339@CY4PR10MB1560.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	jTUQ3a/yW8Gwxo4WOWHRpUPsLzrOIMW9HDIL+OoX/DJVrO1WSVtLjMm0gwNqTIAKPudazL4H9RG/v+Vkf8lZDcXScCAJAUeAoG3exyBMlLIXwxpytODGXu588Sm/vUnaCuskOs4JMmkxZ1feOlNmhiV1kUzwkWRaT2EUIu5DJp7/AQ7G1vfpwq9yZlNFliNCJQJicL7ELyigWeE8KE9jhURdEx/yw0XPOtUi+hBoBvtjeZeWV8rpSQV0OZ9iTXNvbUalCiISOsxMrO4nZKHbmFMTkiDQfc9foIkzMXTiCGCks4Jp7Rsy07xmBXrmXx8MBHBhgIrBHY4JeSJC+rYWgfbnXmCtIeVcEsuc0ZUpv+tjrwtBjJENxq/qONqm7FTPHHgpftvs4gQAkk8m8yD2zw3NYt0ZcSNrJHw/s+6VLTAqb/mqfKfEaHZ/YNyhleZFqZtm9/qojdEjewvJmGlAaX5iTL/yQfuBwtHnol9FOMqSN/Yr1Tw3SpEgvdExMhRJJg2eCBy5AksuF83shHkrnACAPPTQxN0rDN+bQOvmCFzjkSqfKxfsdC+d9fnmV5iFaTIjEZlZniECGi3Nq9A/9lz0jf05DM/xHVpmiSgnmNA7WQEgcwGot9IidmJ6+EILM1HhXppeVXFtsL6s/bGEWqAiHse5Dy0OoRweNrIfLJMfIhdKJAahIDTduZAYX1R18vZb7oE8QfoFINMBh34+LuufApuaP/SDRbdSIPcIaf8=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(186003)(54906003)(31696002)(8936002)(316002)(8676002)(86362001)(66476007)(66946007)(4326008)(38100700002)(26005)(53546011)(6506007)(2616005)(6512007)(6916009)(2906002)(6486002)(508600001)(6666004)(36756003)(4744005)(31686004)(5660300002)(7416002)(25903002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?K2dKOUEvTitxckQxczBaYmwyekxUcnIydnVTZVdOZXFQdjMwYVQrS0lsL3Vq?=
 =?utf-8?B?M011MVBpckxNYlgxczZMNGRZSWw5dVh0Z3JyZCtVZXRVWGFvMXhTSkpqcFRO?=
 =?utf-8?B?R01BeGNQWk4wcVB5ZFdvL1FOdTVjSm82RW1DcHRkRFZRclVrcnd6QW5HV1lV?=
 =?utf-8?B?NDBBbmVQMmV5VG45RlkvOVVFT0NOT3NwelI4OTJUTDBscUdMdGloUVFKRENV?=
 =?utf-8?B?cUVlZVdPcDZrRGQ5R1djWWIxSzcvMTNrRHJQOGlKeFFlK2h0bGxIQmVBc2JU?=
 =?utf-8?B?Uy9QemdvekZmeS9za1RZalZ6a1I3N0ZyZEdHQUlYb0lsbjEvaWQwQzhPQ081?=
 =?utf-8?B?QURnR1FxT3J1dG5lUVUzOGkvbzgxYThrUUF5NVBlRDJ6TFVDeHdVZTZRTHpQ?=
 =?utf-8?B?S3JmN3lFZkgxMlJldlhyK1pjbkpDcmNNRThPMitBZ2VoTHhSY2t4OWRpK21h?=
 =?utf-8?B?Q2lCSUhVMFZnLzh0dmlyWG84cmhRQTdnUExBdnVjWmlDZENxc2VhSCs0NlBR?=
 =?utf-8?B?TDUzQ3J1T0Z2VWxVNG54Sit6dXVmRTh3aHNodWV3Ri8rTnFNdXdzUXlEdnI5?=
 =?utf-8?B?MzhxMlczdjRlUlJ3dTV1czdJOUdqMnBqWGVOejhkRm83UTBoNXV3dWlseWYr?=
 =?utf-8?B?NDFRMTZYVUYyaFlVWlFDWFJ2YkhITUN3V240bUwyTnNkZktyRzNJS0NsdkFy?=
 =?utf-8?B?K0ZXUUJ6WTk3cEVWMGx1R2JCTVRybXp2UXZ1bitBRExNT1h0Wm9JM3daYnAv?=
 =?utf-8?B?TzZFZEpmVGhNVTVkOFczS0kySVlDTmFyalp4QXU3UFEzeTU1QTltOHllNTBt?=
 =?utf-8?B?SGpob3dwMHhvUzlJdjFBUW5xdlFVOEdRL0RlSnR4WExKVlIvbmQ0K016RGhl?=
 =?utf-8?B?ZjFna0RkM0V3dkp2cmFIZXhadGFYVFR1ZGFTb2dQMm1uR1JIRzdxWGZ1NklN?=
 =?utf-8?B?dWpWN085blJlZEFKbmFWcVhmNkNDTkVPVnl1cUl0U1pBak1LOHFad0s0YTFl?=
 =?utf-8?B?dk4xbUdpT2NTYmt5YmNBYk83U2pnU05NVmRWMkIvQlc1elhJbmdZbzNET2Vo?=
 =?utf-8?B?d1hITHhRSWpTeEI3T1VBNXNOdEptM2d5ZHVXYnFLVWtrTUpFMHl2SEgxeHd5?=
 =?utf-8?B?bXdKMlNsLzJqTW9ZbzhvTGZVNGg1R3djQWliVlhmbzZDajNsNEV6NkVFZ2xn?=
 =?utf-8?B?QnBGNWUvNzRzemRCU1o2NXkwSFJuT3RBMjB0Zm1hancxNVc5dytjMkFYK2Zx?=
 =?utf-8?B?Wk1PSVRqL0lSTU9oYjM5b2hiV3AvanN2Tk5lNlZWTGVBTUk1UmZObWxONXpj?=
 =?utf-8?B?RHNiT0hxVnF2Tkp3ejdxU2N4QklMbUZJcGxJZTlnejdlbUtndzdUczlkQ25B?=
 =?utf-8?B?QzlPTERhZGY5VVJuOU1NQ1NKNHErU1RpL08xd0JucFJXS2IrWk9vN29hdTEy?=
 =?utf-8?B?VE9UUzVMOEJuN1VDNFd3aWxwcys4SzByYnVDeVhwU01OOVFiVTBERW9FRGVr?=
 =?utf-8?B?d2pJVFp0cmFzekpIa0h2MHdOQmt2bURlY0FhaGdiV0NQS05yUTF6b1RNY1Nu?=
 =?utf-8?B?VU16TXZIMHhkbFFRM1ROeTZJcnVabDdnVi9wcnMwaGVQV0c1V21UcFZua2tT?=
 =?utf-8?B?MTVkeVRFMW1WeXVPdmFSdmp0ZWxvcW9PM082SnRCTzJWT0pnTWRyZ3FJSlJh?=
 =?utf-8?B?WlI1cnk5ZWdOSjZhMDYvc1diYlk2Vm9Dc2RDVC9jTzJaYXFtSUduSDBsNEN0?=
 =?utf-8?B?WFFvQ0NwdmhvajVsVEVXUk14Rm4vUlZhUlJxZUJKUjZ4TVdXOEpvZHVwSmEv?=
 =?utf-8?B?d0RjNElmRE9qaklDT1ltOTg0cGltbGVhSE9pbUNkUSt0eDVraEkzenB3YTZt?=
 =?utf-8?B?eXFMMG04eXJ0NTdnVVBHcW1LM1NVUVhCTkdLU1I3eEtFQXdURTR5cnpvQm9T?=
 =?utf-8?B?dXhVUzZpQVFEeU5ScUdvNjdHcGttaXd3R1k3S0UwMjlBbUlmZy9IZjgrQjIw?=
 =?utf-8?B?eGg0OWNnek1jZ1g1SjdCaVY5UUpPZ09scHpWZnVzR1JtOFZFVzVVZHY0L2pq?=
 =?utf-8?B?N1ZsZTF1L3EyM3FpZWE3OFhqSnJqNzRvNTlBdzVKTVdBRm1iZFdCSUpHenRm?=
 =?utf-8?B?TnNqTzBpTXRvSVh0aXdXOVYvZzU3YzVxR2EySUNKMHRXN3NEWnlBRnlORmxU?=
 =?utf-8?B?eG92ZHZZamVXeVdFSmlOd0hITmtXTHRQNncxVFcrK015YTNWbThYeGN0bG9C?=
 =?utf-8?B?Q292MURwNSswbzlGandmRm9WdzRBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d85fad4-eaf1-4b70-b3e9-08d9efa8c6c1
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 10:57:21.9950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gHCNEeyBgXQIyswsEbfVNEk4yZ++GyitGqPfCNAXuGr+Y2FGp7jwGdVCYKSVjk0b9l+UYzoidNNDIM9o+/LUkpCUOhL8MsmFqxuutbgRAmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1560
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10257 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202140067
X-Proofpoint-GUID: B4JX8zg6_77zTOpbc9uUo5-4OpqoUmvk
X-Proofpoint-ORIG-GUID: B4JX8zg6_77zTOpbc9uUo5-4OpqoUmvk

On 2/12/22 14:49, Muchun Song wrote:
> On Sat, Feb 12, 2022 at 6:08 PM Muchun Song <songmuchun@bytedance.com> wrote:
>> On Fri, Feb 11, 2022 at 8:37 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>> On 2/11/22 07:54, Muchun Song wrote:
>>>> On Fri, Feb 11, 2022 at 3:34 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>>> -       if (vmemmap_populate(start, end, nid, altmap))
>>>>> +       if (pgmap && pgmap_vmemmap_nr(pgmap) > 1 && !altmap)
>>>>
>>>> Should we add a judgment like "is_power_of_2(sizeof(struct page))" since
>>>> this optimization is only applied when the size of the struct page does not
>>>> cross page boundaries?
>>>
>>> Totally miss that -- let me make that adjustment.
>>>
>>> Can I ask which architectures/conditions this happens?
>>
>> E.g. arm64 when !CONFIG_MEMCG.
> 
> Plus !CONFIG_SLUB even on x86_64.

Oh, thanks for the ref -- hadn't realized that this was
possible on arm64/x86.
