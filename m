Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC06070
	for <nvdimm@lists.linux.dev>; Tue, 22 Jun 2021 17:22:03 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MHHWQX010650;
	Tue, 22 Jun 2021 17:21:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KOfTsvwcSKZgBrMYPS87epGLjxBjbtK/YPQGubwA0bc=;
 b=hSpng9qb78vECGABscVmemPJPxQgG6fMlq+E8EUAWFUG+GkLjolKthFTolZIAPBe8qzk
 4Bd5f/rdPzQqb9hAkQDrWKXqw5crW91b5lnfn+fGFFdgA71eEzR8i6FcpqQ8vBFw+6v7
 IQIKbUzbF8+fdS3HSmPwDz12NF8DfLErNNBYOy2FtGp40kvPPFENO/kwz3xU4yCPmEQi
 rZsNCD5aYVQogVrzsu+EK1UwrhkCjpDZIGskyinMeWhVdzLMgF/P48ybO+qnzph5dTcB
 r5pWzkiMjaF/h4WGDfBoyy4GnweJejufj7wvdFlvchimb78i71P8ObDFzdcO2EFouQCO Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39as86uhsq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jun 2021 17:21:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15MHFqEW173464;
	Tue, 22 Jun 2021 17:21:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by userp3020.oracle.com with ESMTP id 399tbt30yx-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jun 2021 17:21:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxgIjH6VeMLgGu12PaauMSJAkfLaM3TD0BS+VHtR+Ra6aSf3b8nkfaXPSrMhHWN1c8clPhAjOkG1n9dXn9bSo0QPqahhWG6SHDJBU5rmSLkOqEC0wViikQCBZ0V8zuCQl9UWh4YvariRRw4abl0b5/ksNZm7NqKK6WftEVcNWuq2TMIVSg0M+MOSJiywyKRbAExBX4YInpRMD3PiSowroNTpdmzSKUJuNf3VRDO+RKKdyQ90fG17pUA7ppR+Lp/A0vqj7ZQ4BvUvMgFQ28vzg8E2Lc7mdljGtSaxFg42s3AH3AMVtJdVdrcB7QHEv50TOuegHOei6flCwtcGFi0n4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOfTsvwcSKZgBrMYPS87epGLjxBjbtK/YPQGubwA0bc=;
 b=Ipo9cLwMkGKVzmH/CRa4kYc4L/xmsy7sDkM41XoJJO66GJ1ZWlmLTbmIbTWn+l+Wig9UTzOGbdd1mSn7ug/ewqSdjXKLzuA9KtIzhzQG53UvzdMfZEQAOWPRl4jINHmw844aLaCIUQTER3H5FnqikJACWOG4y4O4zoPm2M5rbQm9ds3FvltYuNKnKwKUnJlEAPiks0ow4KwSiJT9kwt6bTftty8Cg+CQ8B9jibHoRgB19AiX7v8FDhyFRlxIxZxmoFLv4gOuLKAs9s0edUsZ7Cu+npvncC6fuangsZAsqzsvKawwmSu0Jr8Lv3cB74iIevkyRfKrCI72hqQlCn1YGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOfTsvwcSKZgBrMYPS87epGLjxBjbtK/YPQGubwA0bc=;
 b=MXam16yWuIy/N/l77qnzph0Eq/VrRmH+WG+aniFZwR/7qMlk3aU/vUWmXhQ387D4i9Zx8YxE1yDQhvWwVPrFhFqKEAXmp0syuYC+NtNRa6y3/W/NGw24XT5+OiSPYe4aqNZEKtcCKiwUS8BdKX07nOMSnyIj3Me6n0g/EBXUMuw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BYAPR10MB2437.namprd10.prod.outlook.com (2603:10b6:a02:b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23; Tue, 22 Jun
 2021 17:21:53 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::8c71:75d7:69ce:e58e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::8c71:75d7:69ce:e58e%8]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 17:21:53 +0000
Subject: Re: set_memory_uc() does not work with pmem poison handling
To: Luis Chamberlain <mcgrof@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev,
        mcgrof@kernel.org
References: <327f9156-9b28-d20e-2850-21c125ece8c7@oracle.com>
 <YNErtAaG/i3HBII+@garbanzo>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <81b46576-f30e-5b92-e926-0ffd20c7deac@oracle.com>
Date: Tue, 22 Jun 2021 10:21:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YNErtAaG/i3HBII+@garbanzo>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [108.226.113.12]
X-ClientProxiedBy: SN4PR0601CA0009.namprd06.prod.outlook.com
 (2603:10b6:803:2f::19) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.70] (108.226.113.12) by SN4PR0601CA0009.namprd06.prod.outlook.com (2603:10b6:803:2f::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 22 Jun 2021 17:21:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a37215fe-72af-47f6-b85b-08d935a23a61
X-MS-TrafficTypeDiagnostic: BYAPR10MB2437:
X-Microsoft-Antispam-PRVS: 
	<BYAPR10MB2437D0ADFB7CAF4991B0B152F3099@BYAPR10MB2437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	CYfJ30g8xro0ylSqlD0Fj5brQ7vhlrDTjthm/AuDVwbWaIFaii/f9HXoElRYpJc/M/i0fL+qSE5fjZhTmIYzx94swNdPrsNlxMZ27nTzNvGlTa0/SILgt4aAJjQoDQPg8NoTJivSAX6Ymf0RV4H4rmpu9MN7k4NnBzbuA8abU0cDKh87e1KiWWoC99aAHmb1LyEsPXo8juCYQZRGbiHrfFcsDCY0r+4Dqsj0c/ZsITUcQMyVUYWKAQ9N12v39B7a2HhxVE/pZxV0GWbz/KiAicbLLdZ/AzZ+i+B808yqh+OwZzx2SOofVkr/ohskwBcJ3cq5XRMmIiMoRq2iMEgzDpvI2RobSEWLpxLnsEJw+CApe8E9VwToHlh3AcyAHgD8pxgZqHqZMWKH1EuOoVnZ5RAwXEFgNLA/C84yZBmS4ZsZ7uyuE4aPMmSVUhn6kD1VSzFVyNpv51rCXgXmYcRdEABLwssSfIOh9i6eLebyeKdgQUGPo9uCok2WG4q+1peB3gzplTHwlZ6Saxrc6xesYsIEq8jDB+rBnYm9lmH5zM9HcyO/N08zlTzw9P05Q1FcjBgxQ2TfMcyxdF7zq0O9RP6ALdo2BI/7cQdfkB/Mti0qLf6sRF79exkuf4UwPaZz3g8IfBZ/M95OWNpIMt0e9zYO9zckBjIqZQUy7dseWVGARGvlvB1AuI0b4es/ktjc
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(366004)(136003)(376002)(478600001)(36756003)(16526019)(186003)(6666004)(4326008)(316002)(53546011)(36916002)(26005)(16576012)(31696002)(8936002)(956004)(66556008)(66946007)(2616005)(5660300002)(8676002)(2906002)(31686004)(6916009)(38100700002)(66476007)(44832011)(86362001)(83380400001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZStxMVgzdSsyQkxXam5aMHJhUTJYa1RrKzVMbStqNUJydEdJdW80RmN4N2xK?=
 =?utf-8?B?RmhZVHRsZk92T1Y4YmJ1UDhSbDVOdGtwaGpsRmU3NEZHVW1ZTVJod1dQOHZO?=
 =?utf-8?B?Z2hVQU5HcWxKU0lGNEREYlhjWisvMWJZcDhsbDRLenNPU2NyTUdsWExlcnp0?=
 =?utf-8?B?K0tGV1RIdUFSNlRUSEpnVDdOQ3N4bEJBbkZCaisraTVNV1dPLytodnhYQ3E4?=
 =?utf-8?B?Mk0rNXNURmNtSHNKa1F1TURQeCt3MHJtVGxwZTNDK1ViTzRGckJadEdKeXl3?=
 =?utf-8?B?LzdoQXVSV09PS0l1R005dTF4M2t3QkpVeTlwT3ZKMHZoMDlvQ0k3a0kzRStz?=
 =?utf-8?B?MXBPelEydFpKWjFMT1poUURwSnJOODlOb0I2S2ZoeU9LODV4alJRK1lBdjhx?=
 =?utf-8?B?YmZXa1BEYXFmQXRidk42SlQ2ck1wNi9EVm44YXRIaXFnak9Fdzlkb0pIdzFu?=
 =?utf-8?B?U1ppMnpuZDRCYVI0b0g2RnEvYXBmNDBmYjdaUkxzNlZ3a1psSHJacjZ3ZmIz?=
 =?utf-8?B?V3lDWDNORm92enBNS2I4dHBUaWZTb2Y4RGU4U0hpdDIxVFlIa05XYUw5QUxu?=
 =?utf-8?B?RGJ1Wk14SFlUeTRybCs4cVd1RGIxdXlrZG5sTVVKN3ZHOUVDZVg5dWxlV1RE?=
 =?utf-8?B?ZEpPQ2JsTHdUZkJvd2JXTVF4SkFRV3Myb0tPMS8rejAycEQxNXhTbzdWaWlX?=
 =?utf-8?B?QnR3T09UMFpBelpkK0s1czhwaElaaXdWZUpmcTN4ZDhkaGFLN2RHSVZRajV0?=
 =?utf-8?B?K2NYUjdQV2hwWFF1cWhSZ0dQUkV6MnRma3YwK29VbjluaEhmY0owWXNlbWhV?=
 =?utf-8?B?YnBia21Rb1pIa3lXSW0xcWJhN0Jqc2ltNUNHL0ZJNWhRM25aVzVRSjJaSzlw?=
 =?utf-8?B?emxVSjA5YzdPRHZXaEhyZkxNcTd2MXBub0hoTHE5eWJtOTJ4TllNYjNJS2dx?=
 =?utf-8?B?UHFqQkRtN29sT2JlV2Vic1VhVGcvSkdYMTR6cHJxcFVLejBYYnVIczh4bFBN?=
 =?utf-8?B?azVoRWlvc1NkejFRY0ZPYVZhdmJheFVDUktyREU3bjFuU1dTM1pndTB3YnBZ?=
 =?utf-8?B?dnB0VG8xV1VVUzVGaTNvK09aQWx6Z0REK3AxSkZ3VlEyQWVpOWxvSWNNcWl4?=
 =?utf-8?B?UmdMT3BHanpVcDB5bWRkMGp1Y1poTFVEanltaEFoWkRVbUkrenJzSHFROEJS?=
 =?utf-8?B?Um1TWktuWDBiSHk5eUF1d1Y2MnpUMGRialFwN3NiZm45QXhxQ2lJbkxVOHY5?=
 =?utf-8?B?eGQwdmNGZ2pueDRMQWdVQkpmSGpzbDR3eXBTMFc4OWNBQXp4RUtEZXZYcFJx?=
 =?utf-8?B?SjVUT1QxT3FWbytqTDJ0Y2hkT096ajRNcjNITDlkREJTc1ZVMjdyZ1h4aCs4?=
 =?utf-8?B?MUJpVm1ta3FRVXFJTDlMOXBMd0VkVWlTWkdVR3F6MG0rRUZJcU1lS3lqMVNM?=
 =?utf-8?B?ZW4rVUlGRSt4VmpDWExhYWIzcTJxckhOTElKMnRoc3dtcG9pdjRUOU03M1dC?=
 =?utf-8?B?T0ROZFVUdDdEWW5vR09hVzJwejI4T1ZnR2UvMHg0TEpRODhON2kyWlRJdEsx?=
 =?utf-8?B?d2FUK3p2dEpHNmJLbmpZVm9SU1RqUThubGcxZjA1OXM5aXRLREtxT0x6NUgr?=
 =?utf-8?B?K29VeXJFL1F5T3pzWmwwcW1LUXVJcDZNSHdCY2lwVGovTjFNNzZadWdIbUhj?=
 =?utf-8?B?Y1dnUVhhT1N0NFMxc203NFBVbkpnNlhUWWQ4N0tUZlBGWlVIS0pjNFY0V0F3?=
 =?utf-8?Q?tS/MxyMjR3sAbS/zi48la1x+M3Lh79VIQNr6t4f?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a37215fe-72af-47f6-b85b-08d935a23a61
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 17:21:53.3955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1P1XxTTHPvTcfh7qiYXXuWj+KPi3YRmj9Ltm8BYyreF4P9HVxFbeF93zNROJQlcNGdBDdfpLioYEmdvNwfdC4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2437
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106220107
X-Proofpoint-ORIG-GUID: VpVfdZS-SFW72_ZlIfcvADRfK0Thor8G
X-Proofpoint-GUID: VpVfdZS-SFW72_ZlIfcvADRfK0Thor8G


On 6/21/2021 5:15 PM, Luis Chamberlain wrote:
> On Tue, Jun 15, 2021 at 11:55:19AM -0700, Jane Chu wrote:
>> Hi, Dan,
>>
>> It appears the fact pmem region is of WB memtype renders set_memory_uc()
>>
>> to fail due to inconsistency between the requested memtype(UC-) and the
>> cached
>>
>> memtype(WB).
>>
>> # cat /proc/iomem |grep -A 8 -i persist
>> 1840000000-d53fffffff : Persistent Memory
>>    1840000000-1c3fffffff : namespace0.0
>>    5740000000-76bfffffff : namespace2.0
>>
>> # cat /sys/kernel/debug/x86/pat_memtype_list
>> PAT memtype list:
>> PAT: [mem 0x0000001840000000-0x0000001c40000000] write-back
>> PAT: [mem 0x0000005740000000-0x00000076c0000000] write-back
>>
>> [10683.418072] Memory failure: 0x1850600: recovery action for dax page:
>> Recovered
>> [10683.426147] x86/PAT: fsdax_poison_v1:5018 conflicting memory types
>> 1850600000-1850601000  uncached-minus<->write-back
>>
>> cscope search shows that unlike pmem, set_memory_uc() is primarily used by
>> drivers dealing with ioremap(),
> 
> Yes, when a driver *knows* the type must follow certain rules, it
> requests it.
> 
>> perhaps the pmem case needs another way to suppress prefetch?
>>
>> Your thoughts?
> 
> The way to think about this problem is, who did the ioremap call for the
> ioremap'd area? That's the driver that needs changing.

I'm not sure if the pmem driver is doing something wrong, but rather the
pmem memory failure handler.

thanks,
-jane

> 
>    Luis
> 
