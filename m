Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B6C68
	for <nvdimm@lists.linux.dev>; Fri, 19 Nov 2021 16:12:46 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJG6j6S011359;
	Fri, 19 Nov 2021 16:12:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=dxqV4IW6P4jvsIeAfQXz+rMu/AOixD2gawCUAUYXgp4=;
 b=seWQ+OXXMx4DIIyT9IKv6rkBvP6LDD9RvA7cwj8mSnYtYLdA0yYlOGEqr87oX/AkgSpx
 B6I76qo8g49Zj1Ix6LUQO3aggmeGY2q3omxziP1JdDPYYyzjQ0yDe8tMG6MjBK6oB+4U
 ODtwf2L9Kpineqw26igjnXvuP7V/6FvsUBh3037oWZzPxISAaFfHqXLR2oAK1MptRar3
 3KPDhUHM05J06PVdYEyxYdhG5Gf13EyDTKOIzMNaxRogqNsvO1cvga1k9w0XGBb+ziqh
 SaG+wPLNXPpcsdBmkTOZf6ggGl9mXXjnBJ3DRbXrYeIjtIJ3GyUcAZK71k/xUpW5tQxD Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cd205r1bm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Nov 2021 16:12:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJGApNK009479;
	Fri, 19 Nov 2021 16:12:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by aserp3020.oracle.com with ESMTP id 3ca56af2ah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Nov 2021 16:12:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mo9QQ3gKQi74y34vtA5pwUatVNaO9eQ2wNBgOSrK/3TMKrlGsMlqUQXJRVgmkOXsX1IWzrViYT/RBlpqBxo76cvwI2VX1NjHDfnsRvgYSeOdRR3StaLavcIT4x6aAJxlMTS3N1cVQGs+BNlfqkUzrB/gaHR8maa2PVq5cqQZJlQ2trIwCoxjqAV37nh9RyLzYA3XVAhqHcVsbVaX+YdsqmlvIZbG48b1385CvX6SLivTW/TquiPGOs7XIozSBk9pJeu5Kx7oXo8GKtXsLMPp2OfvCNVTKdfBVFs8jJrrmoT9R2it4SILxbm04m26K3fb4F57MKdxphnszqkbufaF4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxqV4IW6P4jvsIeAfQXz+rMu/AOixD2gawCUAUYXgp4=;
 b=nGjhx7s1htFjX4r0iq+WucrInn2B+nNNCcbsrtEFgQagK+/0rTHvZCzdfh3uDJ8bLe/mp5REIjLYBCAZMz1ywLx7g52xFGHMgW1PeRyf0bhwXX0mOdTux1sluXBMbMds+RgWaU/++G7ip7TAqVmods+qc3mZ/I6e7eOFzwENn6aV0+HnhmnXyRhBFBnjI5IGPUYSrKXEpNAxP5LXeIC8SaRiwbUGnvZ9ABJYOBVNd0deS4NB06OmY0PUpcZg3Gnu8PcuI2Q+Xs6vOBNU6NtzsSEcB/ZxSpqcxS6wkHTSAq4G9DGMx/y/X5nY6CvajicV4RTCVC2EzufJI/tmQItqBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxqV4IW6P4jvsIeAfQXz+rMu/AOixD2gawCUAUYXgp4=;
 b=J6iS/46vhIPa5D1AXH+scIfwj7MpPtMl7WgCPRy2RICfFuvm4S9U/8F8kDRORaGSJdBmZW2YN7g6uhE46IFasH3cLJO50A8NMaAD8ci7EPGkYOYFBAje1oGrtp+h4UWjVaFP887FTA4moMS9aKy4jzB7Ts9S1bxGNZG371v+y68=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5106.namprd10.prod.outlook.com (2603:10b6:208:30c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Fri, 19 Nov
 2021 16:12:26 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4690.027; Fri, 19 Nov 2021
 16:12:25 +0000
Message-ID: <3b7f9516-a35a-e46e-83d4-3059a959d221@oracle.com>
Date: Fri, 19 Nov 2021 16:12:18 +0000
Subject: Re: [PATCH v5 8/8] device-dax: compound devmap support
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
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
 <4d74bfb8-2cff-237b-321b-05aff34c1e5d@oracle.com>
In-Reply-To: <4d74bfb8-2cff-237b-321b-05aff34c1e5d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0126.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::23) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.193.46] (138.3.204.46) by AM0PR02CA0126.eurprd02.prod.outlook.com (2603:10a6:20b:28c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 16:12:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3ad06bc-e6a1-4fa1-3a09-08d9ab776061
X-MS-TrafficTypeDiagnostic: BLAPR10MB5106:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB510667515A929FCD8412CAF0BB9C9@BLAPR10MB5106.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:164;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	59u69kXb9cM+ahUrjBdqsVLjHduAl42GeEj/MAKlYNJU3q6txComwF2+R08oGPl+PUhNTMK7A6mbrbCC2TVs/n0yUBGm/DXFq/1yHoIzDRGpqPnERbfnbEM/WzCWcy+pV8MVUAG6xI6FcfzRsvdEiv/LKMflx0/z9nVVZjwlBG4DJL9KkioZgiQOjqaz54k2koLCjtxjyE46wq8wSDC1+503NK9qjWK5+oNyuEJtR274SKjNZ4R0PmHwHhvnr6r3Y4p35orpIBOthDQbrBjU4O4BEyn1NS+/xtsSBKxsqpvhwVyRJJ9ZLRDwuyIwiE3dXAVairsumyqV155OzYSp2hzkPTg12TuIrSNIOMGJ/iPbKpjZPVzlqyuJVUru14lXxCE3tUJhkloWP2ge+UzP5tDZa01Srzinhrgv78PzVdidN3VR9SjuNfgLxBO+/zoxibqvvvqk0DwAcNVVKbOKQ/C9ALKXJzb44uxcjJOEEKdHpoBfeyxJ/uhww5OKRaCEU/JB5BXMHRCav23fapt/v4dn/AcwlCX5krETZe5wAhwl07YHOjvVybw730Pg9uLYjI5HqF5GAm7KJbKtmx0cNxIljtcIesEDrUKgQl8FuSL8O7mXyA8N5dsCuCiScc7GG6NfoL/REXfOHmmBfIEorrt2bIS7K0p2KCMbCLjXe0jho8+j64+I9sr5rj1Dn4fFHohi9JstDbKlVeWxA9/jIQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(7416002)(54906003)(8676002)(83380400001)(6666004)(2906002)(31686004)(110136005)(4326008)(16576012)(6486002)(66476007)(66946007)(66556008)(956004)(36756003)(5660300002)(26005)(53546011)(2616005)(316002)(8936002)(508600001)(38100700002)(86362001)(186003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZkE1RHBHRWI2WnFES2dmNkxqK2R4cHp6VDlIVklUR0xDR053Y1A1cDA5NXg3?=
 =?utf-8?B?RTNJOTdLaks2VXp4QVNwMGhucXJ3b0JIVStXWE5vdVRMNStMOUV5c0JsQVdB?=
 =?utf-8?B?aUs0YUV1MUExQ3IzK3ZodldEZUErbFFsaTNWRGJ5S203Wk9CRlhMeFRFYlI1?=
 =?utf-8?B?Y1dPemEwQ2w1dUNlOEVYN2piZlVPUDlFQlovamZ3WVZkWjJaUzFzc3hwT0l5?=
 =?utf-8?B?RDhZbEQvV0tnRjc3SDI4bUlUdUpGNWhDVGhXYjRwVTNxUjRDckZQNEk4d3RG?=
 =?utf-8?B?V0gwdmtiTUVKK3ZWTW1qTHpiYlJSNithc0xpamQ2Y2RrUVhaWFVKTFNaR0hk?=
 =?utf-8?B?K2ZVNWNVS0dqV2tPUEVUcDRFWVhoVmQ2Tk5wbzljU3lNcDhiM0hOdlM0U0I4?=
 =?utf-8?B?THRxeS9ScDZYaklYQUlRQUJRNmdWTWtsekd1a0JXZUJEY2FDTG80Sml5NDF2?=
 =?utf-8?B?N1dFYzVycGxaNkZReDZjMU9rb2kyQjh0YjZFZmwvQVRKT0lTMmo2US95OHF2?=
 =?utf-8?B?TTV2bzZsZmh6T2w5VWM1Z0dGRFRMYTU3QlVrN1F1cHNTYzFpRGxQQkZybGJ0?=
 =?utf-8?B?Vis1Z3I3WnBCNGNHRVRTUW10d3dibFZxVVJyT0JhdEJSWG9hdkVuQzMxVlNr?=
 =?utf-8?B?WkpVTjcvL1g3V1JtZWR4NnBkL0dCaDBRemhCSGZsSm9mN2xJazVvamRiU2R1?=
 =?utf-8?B?c2hJd3NXcm1OUnlWZkl0SGo0dzQ0V1ZVWFZjTEVzTjhNT1JHWk0yK2EyeHJw?=
 =?utf-8?B?N3F5Q3pkTUVwcXQ5TWx5VElaTjZTa1VCWVFsREVwbmEvSkpuNElFZ2dKZVF6?=
 =?utf-8?B?K3lraytSdHNDSitqWFB6eFVOMC9yazEwNkpFL0E1SGcvblVScTl0bWJnSHBB?=
 =?utf-8?B?U1ZiT3NhTzNEMGFOUFlDSlFoTU52TC9RRXh6YldvK1R0VHY5SXJjQ1gzL2tU?=
 =?utf-8?B?cHdJVkhLMWhLdnZPZHg0QUFvWHc3UExpMGI3REUvTFBwUGRsdHN3a2pKamp3?=
 =?utf-8?B?QlhjdnltZzhrcDR5OFpnWDlRUkVxaDkzNTJPQ2xxeng1MVN6RlA0MGEvbW9k?=
 =?utf-8?B?STZmY1dBTHBtYmg2YStCeUpGcVJWcW45M2l6OXIrSVIrV0xnbmo0Y2ttYklJ?=
 =?utf-8?B?dzFBemFGWWZ0OHBiZ3JURGtrZ3FBNEdaejlvZy9SRnpIOFVib2tkaGlRbmxD?=
 =?utf-8?B?cXQwSTZMSElNTWp4c3NvT2Y4WmVvbzdqbmF1RGRvS1gxeXJYa3dRell2ZHJC?=
 =?utf-8?B?V1ZNRHNMKzNXR0s4MDdicFVheW53OFV3QXlPcUVTc290UTlVRFNRZ01Nb0N4?=
 =?utf-8?B?ZW1sMzJlS2gxNHlUaC9CQy83MCtYRXJ3Vm9SQXhCbC9vTXViVXkvY3Zyc2g3?=
 =?utf-8?B?M2k3RWJIdG5uaDFPU0N2anhibjN0dUJoZmcva2xVRVg2L3ByZFpQZS91cEdn?=
 =?utf-8?B?alRXZmFLNEMxd0wwQzcrcjBXbm9pQTEyd2M1ZjBSZWhVZjV0c2pXRFdnZTcr?=
 =?utf-8?B?NGVoVjNhSWJJL2J0UVlaTWNJdGxBY3FYb2NsbVRtZUdwY2l5WklBc3B6ellj?=
 =?utf-8?B?SVRNYytQeEZYWlVLZlBjclM0b3hyUDJacGlnUnBONWJPVko5c2drTW1kdC9V?=
 =?utf-8?B?eStNdE5YOGVvZWpNb0NmTmpOUnJxdnBFTUlieFBoem1DV0RReFkzVnl3Um1Z?=
 =?utf-8?B?UExjYjJvZTVRTTlEQUpmNFk0MWJ5N21wdjZOTHROQzBnQitVV0tPLy82Rm4w?=
 =?utf-8?B?QmhRTUQzNVU2SUd4MFdCcTNGcUY3NHcwbU9namdZQ3ZjQlN1Wk5uZy9qQzBt?=
 =?utf-8?B?ZHJSNHlXUmh5WExWbk5sdm9yMmN1TzR2S0QzN0s2Ujh6VmVxMmRNUHl3QWND?=
 =?utf-8?B?SkRTS1k5RDhJTDdVK01sb1lEZmVHLzNBV0N3SURtNFhLSFJSUlZiQnBrTjBK?=
 =?utf-8?B?L2VLaVR5SjFzLzNmYzVaOXprS0VMUHdrK0F3clMwa0tDSDBRYnQ4YmRqNDBh?=
 =?utf-8?B?QXA0L2E3TWIzd1hTV1ltVVB0MVJBS05oaDliWjJZTGYxOTZsMjMyYXNQTFhM?=
 =?utf-8?B?UUdQaVYyUE5DMXZXS2MxMG9ScTFoek5NUEM3TWxNUEVmRVdoNmlwR1REcnoz?=
 =?utf-8?B?TFpkRW85cUFLMXF3WkRaaytHYUpJRXlsbWdEK09pend6d0x4dUVvZWdmOExD?=
 =?utf-8?B?L0JXVFp6TExuT0NYaTE1bXM5M1dpTDBpUEQvMDZOdkVhbjVybmFXRkx2djd1?=
 =?utf-8?B?c1Q2aWJhNkxmZ0VDeGpKS043SDRBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ad06bc-e6a1-4fa1-3a09-08d9ab776061
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 16:12:25.8507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 68nv6CnWqO6oAx7cZ7tnY1NvNcAHSSX8ULnZu/iLtAcTO8NfxZvZOMGHwBtbHUFHTS4vAczIIBj8MtsF3fhycBv7pw1nJm82vTnAmBMqVn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5106
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190090
X-Proofpoint-ORIG-GUID: zwmvPcX0qMeVxE936--v5_1fBgSSNFLL
X-Proofpoint-GUID: zwmvPcX0qMeVxE936--v5_1fBgSSNFLL

On 11/16/21 16:38, Joao Martins wrote:
> On 11/15/21 17:49, Jason Gunthorpe wrote:
>> On Mon, Nov 15, 2021 at 01:11:32PM +0100, Joao Martins wrote:
>>> On 11/12/21 16:34, Jason Gunthorpe wrote:
>>>> On Fri, Nov 12, 2021 at 04:08:24PM +0100, Joao Martins wrote:
>>>>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>>>>> index a65c67ab5ee0..0c2ac97d397d 100644
>>>>> +++ b/drivers/dax/device.c
>>>>> @@ -192,6 +192,42 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
>>>>>  }
>>>>>  #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>>>>>  
>>>>> +static void set_page_mapping(struct vm_fault *vmf, pfn_t pfn,
>>>>> +			     unsigned long fault_size,
>>>>> +			     struct address_space *f_mapping)
>>>>> +{
>>>>> +	unsigned long i;
>>>>> +	pgoff_t pgoff;
>>>>> +
>>>>> +	pgoff = linear_page_index(vmf->vma, ALIGN(vmf->address, fault_size));
>>>>> +
>>>>> +	for (i = 0; i < fault_size / PAGE_SIZE; i++) {
>>>>> +		struct page *page;
>>>>> +
>>>>> +		page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
>>>>> +		if (page->mapping)
>>>>> +			continue;
>>>>> +		page->mapping = f_mapping;
>>>>> +		page->index = pgoff + i;
>>>>> +	}
>>>>> +}
>>>>> +
>>>>> +static void set_compound_mapping(struct vm_fault *vmf, pfn_t pfn,
>>>>> +				 unsigned long fault_size,
>>>>> +				 struct address_space *f_mapping)
>>>>> +{
>>>>> +	struct page *head;
>>>>> +
>>>>> +	head = pfn_to_page(pfn_t_to_pfn(pfn));
>>>>> +	head = compound_head(head);
>>>>> +	if (head->mapping)
>>>>> +		return;
>>>>> +
>>>>> +	head->mapping = f_mapping;
>>>>> +	head->index = linear_page_index(vmf->vma,
>>>>> +			ALIGN(vmf->address, fault_size));
>>>>> +}
>>>>
>>>> Should this stuff be setup before doing vmf_insert_pfn_XX?
>>>>
>>>
>>> Interestingly filesystem-dax does this, but not device-dax.
>>
>> I think it may be a bug ?
>>
> Possibly.
> 
> Dan, any thoughts (see also below) ? You probably hold all that
> history since its inception on commit 2232c6382a4 ("device-dax: Enable page_mapping()")
> and commit 35de299547d1 ("device-dax: Set page->index").
> 
Below is what I have staged so far as a percursor patch (see below scissors mark).

It also lets me simplify compound page case for __dax_set_mapping() in this patch,
like below diff.

But I still wonder whether this ordering adjustment of @mapping setting is best placed
as a percursor patch whenever pgmap/page refcount changes happen. Anyways it's just a
thought.

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 80824e460fbf..35706214778e 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -78,15 +78,21 @@ static void __dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
                              struct address_space *f_mapping)
 {
        struct address_space *c_mapping = vmf->vma->vm_file->f_mapping;
+       struct dev_dax *dev_dax = vmf->vma->vm_file->private_data;
        unsigned long i, nr_pages = fault_size / PAGE_SIZE;
        pgoff_t pgoff;

+       /* mapping is only set on the head */
+       if (dev_dax->pgmap->vmemmap_shift)
+               nr_pages = 1;
+
        pgoff = linear_page_index(vmf->vma,
                        ALIGN(vmf->address, fault_size));

        for (i = 0; i < nr_pages; i++) {
                struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);

+               page = compound_head(page);
                if (page->mapping &&
                    (!f_mapping && page->mapping != c_mapping))
                        continue;
@@ -473,6 +479,9 @@ int dev_dax_probe(struct dev_dax *dev_dax)
        }

        pgmap->type = MEMORY_DEVICE_GENERIC;
+       if (dev_dax->align > PAGE_SIZE)
+               pgmap->vmemmap_shift =
+                       order_base_2(dev_dax->align >> PAGE_SHIFT);
        addr = devm_memremap_pages(dev, pgmap);
        if (IS_ERR(addr))
                return PTR_ERR(addr);
(

----------------------------------->8-------------------------------------

From: Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH] device-dax: set mapping prior to vmf_insert_pfn{,_pmd,pud}()

Normally, the @page mapping is set prior to inserting the page into a
page table entry. Make device-dax adhere to the same  ordering, rather
than setting mapping after the PTE is inserted.

Care is taken to clear the mapping on a vmf_insert_pfn* failure (rc !=
VM_FAULT_NOPAGE). Thus mapping is cleared when we have a valid @pfn
which is right before we call vmf_insert_pfn*() and it is only cleared
if the one set on the page is the mapping recorded in the fault handler
data (@vmf).

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/device.c | 79 +++++++++++++++++++++++++++++++-------------
 1 file changed, 56 insertions(+), 23 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 630de5a795b0..80824e460fbf 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -73,6 +73,43 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t
pgoff,
 	return -1;
 }

+static void __dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
+			      unsigned long fault_size,
+			      struct address_space *f_mapping)
+{
+	struct address_space *c_mapping = vmf->vma->vm_file->f_mapping;
+	unsigned long i, nr_pages = fault_size / PAGE_SIZE;
+	pgoff_t pgoff;
+
+	pgoff = linear_page_index(vmf->vma,
+			ALIGN(vmf->address, fault_size));
+
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
+
+		if (page->mapping &&
+		    (!f_mapping && page->mapping != c_mapping))
+			continue;
+
+		page->mapping = f_mapping;
+		page->index = pgoff + i;
+	}
+}
+
+static void dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
+			    unsigned long fault_size)
+{
+	struct address_space *c_mapping = vmf->vma->vm_file->f_mapping;
+
+	__dax_set_mapping(vmf, pfn, fault_size, c_mapping);
+}
+
+static void dax_clear_mapping(struct vm_fault *vmf, pfn_t pfn,
+			      unsigned long fault_size)
+{
+	__dax_set_mapping(vmf, pfn, fault_size, NULL);
+}
+
 static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 				struct vm_fault *vmf, pfn_t *pfn)
 {
@@ -100,6 +137,8 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,

 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);

+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_mixed(vmf->vma, vmf->address, *pfn);
 }

@@ -140,6 +179,8 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,

 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);

+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }

@@ -182,6 +223,8 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,

 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);

+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 #else
@@ -199,7 +242,7 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 	unsigned long fault_size;
 	vm_fault_t rc = VM_FAULT_SIGBUS;
 	int id;
-	pfn_t pfn;
+	pfn_t pfn = { .val = 0 };
 	struct dev_dax *dev_dax = filp->private_data;

 	dev_dbg(&dev_dax->dev, "%s: %s (%#lx - %#lx) size = %d\n", current->comm,
@@ -224,28 +267,18 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		rc = VM_FAULT_SIGBUS;
 	}

-	if (rc == VM_FAULT_NOPAGE) {
-		unsigned long i;
-		pgoff_t pgoff;
-
-		/*
-		 * In the device-dax case the only possibility for a
-		 * VM_FAULT_NOPAGE result is when device-dax capacity is
-		 * mapped. No need to consider the zero page, or racing
-		 * conflicting mappings.
-		 */
-		pgoff = linear_page_index(vmf->vma,
-				ALIGN(vmf->address, fault_size));
-		for (i = 0; i < fault_size / PAGE_SIZE; i++) {
-			struct page *page;
-
-			page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
-			if (page->mapping)
-				continue;
-			page->mapping = filp->f_mapping;
-			page->index = pgoff + i;
-		}
-	}
+	/*
+	 * In the device-dax case the only possibility for a
+	 * VM_FAULT_NOPAGE result is when device-dax capacity is
+	 * mapped. No need to consider the zero page, or racing
+	 * conflicting mappings.
+	 * We could get VM_FAULT_FALLBACK without even attempting
+	 * to insert the page table entry. So make sure we test
+	 * for the error code with a devmap @pfn value which is
+	 * set right before vmf_insert_pfn*().
+	 */
+	if (rc != VM_FAULT_NOPAGE && pfn_t_devmap(pfn))
+		dax_clear_mapping(vmf, pfn, fault_size);
 	dax_read_unlock(id);

 	return rc;
-- 
2.17.2
